from fastapi.testclient import TestClient
from sqlalchemy.pool import StaticPool
from sqlmodel import SQLModel, create_engine

from app import db as dbmod
from app.main import app


def _client() -> TestClient:
    test_engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    dbmod.engine = test_engine
    SQLModel.metadata.create_all(test_engine)
    return TestClient(app)


def test_push_then_pull_returns_task() -> None:
    payload = {
        "id": "T1",
        "task_type": "trenching",
        "machine_id": "EXC001",
        "machine_type": "EXCAVATOR",
        "operator_id": "OP1001",
        "scheduled_start": "2025-05-01T08:00:00",
        "scheduled_end": "2025-05-01T11:00:00",
        "progress_pct": 10,
        "cycle_time_sec": 22,
        "updated_at": "2025-05-01T08:05:00",
    }
    with _client() as client:
        push = client.post(
            "/sync/push",
            json={
                "device_id": "tablet-a",
                "changes": [
                    {
                        "entity": "task",
                        "id": "T1",
                        "op": "upsert",
                        "updated_at": "2025-05-01T08:05:00",
                        "payload": payload,
                    }
                ],
            },
        )
        assert push.status_code == 200
        assert push.json() == {"applied": 1, "skipped": 0}

        pulled = client.get("/sync/pull")
        assert pulled.status_code == 200
        body = pulled.json()
        assert len(body["changes"]) == 1
        assert body["changes"][0]["id"] == "T1"
        assert body["changes"][0]["payload"]["progress_pct"] == 10


def test_older_push_does_not_overwrite() -> None:
    first = {
        "id": "T2",
        "task_type": "lifting",
        "machine_id": "EXC001",
        "machine_type": "EXCAVATOR",
        "operator_id": "OP1001",
        "scheduled_start": "2025-05-01T09:00:00",
        "scheduled_end": "2025-05-01T10:00:00",
        "progress_pct": 80,
        "updated_at": "2025-05-01T09:30:00",
    }
    stale = {**first, "progress_pct": 20, "updated_at": "2025-05-01T09:10:00"}
    with _client() as client:
        client.post(
            "/sync/push",
            json={
                "device_id": "tablet-a",
                "changes": [
                    {
                        "entity": "task",
                        "id": "T2",
                        "op": "upsert",
                        "updated_at": first["updated_at"],
                        "payload": first,
                    }
                ],
            },
        )
        skipped = client.post(
            "/sync/push",
            json={
                "device_id": "tablet-b",
                "changes": [
                    {
                        "entity": "task",
                        "id": "T2",
                        "op": "upsert",
                        "updated_at": stale["updated_at"],
                        "payload": stale,
                    }
                ],
            },
        )
        assert skipped.json() == {"applied": 0, "skipped": 1}
        pulled = client.get("/sync/pull").json()
        assert pulled["changes"][0]["payload"]["progress_pct"] == 80
