from datetime import UTC, datetime
from typing import Any

from sqlmodel import Session, col, select

from app.models.entities import ChecklistItem, Handover, Shift, Task
from app.sync.schemas import PullResponse, PushRequest, PushResponse, SyncChange

ENTITY_MODELS = {
    "task": Task,
    "shift": Shift,
    "checklist_item": ChecklistItem,
    "handover": Handover,
}


DATETIME_FIELDS = {
    "scheduled_start",
    "scheduled_end",
    "start_time",
    "end_time",
    "started_at",
    "ended_at",
    "updated_at",
    "deleted_at",
}


def _ensure_utc(value: datetime | None) -> datetime | None:
    if value is None:
        return None
    if value.tzinfo is None:
        return value.replace(tzinfo=UTC)
    return value.astimezone(UTC)


def _dump(record: Task | Shift | ChecklistItem | Handover) -> dict[str, Any]:
    data = record.model_dump()
    for key, value in list(data.items()):
        if isinstance(value, datetime):
            data[key] = value.isoformat()
    return data


def _hydrate(model: type, payload: dict[str, Any], updated_at: datetime):
    body = dict(payload)
    body["updated_at"] = _ensure_utc(updated_at)
    obj = model.model_validate(body)
    for field in DATETIME_FIELDS:
        if hasattr(obj, field):
            setattr(obj, field, _ensure_utc(getattr(obj, field)))
    return obj


def apply_push(session: Session, request: PushRequest) -> PushResponse:
    applied = 0
    skipped = 0
    for change in request.changes:
        model = ENTITY_MODELS[change.entity]
        existing = session.get(model, change.id)
        incoming_at = _ensure_utc(change.updated_at)
        assert incoming_at is not None
        if existing is not None and _ensure_utc(existing.updated_at) > incoming_at:
            skipped += 1
            continue
        if change.op == "delete":
            if existing is None:
                skipped += 1
                continue
            existing.deleted_at = incoming_at
            existing.updated_at = incoming_at
            session.add(existing)
        else:
            if change.payload is None:
                skipped += 1
                continue
            session.merge(_hydrate(model, change.payload, incoming_at))
        applied += 1
    session.commit()
    return PushResponse(applied=applied, skipped=skipped)


def pull_changes(session: Session, since: datetime | None) -> PullResponse:
    changes: list[SyncChange] = []
    since = _ensure_utc(since)
    latest = since
    for entity, model in ENTITY_MODELS.items():
        statement = select(model)
        if since is not None:
            statement = statement.where(col(model.updated_at) > since)
        for record in session.exec(statement):
            op = "delete" if record.deleted_at is not None else "upsert"
            changes.append(
                SyncChange(
                    entity=entity,  # type: ignore[arg-type]
                    id=record.id,
                    op=op,  # type: ignore[arg-type]
                    updated_at=record.updated_at,
                    payload=_dump(record),
                )
            )
            if latest is None or record.updated_at > latest:
                latest = record.updated_at
    changes.sort(key=lambda item: item.updated_at)
    cursor = (latest or datetime.now(UTC)).isoformat()
    return PullResponse(cursor=cursor, changes=changes)
