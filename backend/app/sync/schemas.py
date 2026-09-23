from datetime import datetime
from typing import Any, Literal

from pydantic import BaseModel, Field


class SyncChange(BaseModel):
    entity: Literal["task", "shift", "checklist_item", "handover"]
    id: str
    op: Literal["upsert", "delete"]
    updated_at: datetime
    payload: dict[str, Any] | None = None


class PushRequest(BaseModel):
    device_id: str
    changes: list[SyncChange] = Field(default_factory=list)


class PushResponse(BaseModel):
    applied: int
    skipped: int


class PullResponse(BaseModel):
    cursor: str
    changes: list[SyncChange]
