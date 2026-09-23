from datetime import datetime

from sqlmodel import Field, SQLModel


class Task(SQLModel, table=True):
    id: str = Field(primary_key=True)
    task_type: str
    machine_id: str
    machine_type: str
    operator_id: str
    scheduled_start: datetime
    scheduled_end: datetime
    start_time: datetime | None = None
    end_time: datetime | None = None
    actual_duration_min: float | None = None
    planned_quantity: float = 0
    quantity_done: float = 0
    progress_pct: float = 0
    cycle_time_sec: float = 0
    cycles_completed: int = 0
    ground_softness: float = 0
    rain: float = 0
    slope_deg: float = 0
    avg_load_pct: float = 0
    is_night: bool = False
    idle_min: float = 0
    fuel_used_l: float = 0
    updated_at: datetime
    deleted_at: datetime | None = None


class Shift(SQLModel, table=True):
    id: str = Field(primary_key=True)
    operator_id: str
    machine_id: str
    scheduled_start: datetime
    scheduled_end: datetime
    started_at: datetime | None = None
    ended_at: datetime | None = None
    status: str = "planned"
    updated_at: datetime
    deleted_at: datetime | None = None


class ChecklistItem(SQLModel, table=True):
    id: str = Field(primary_key=True)
    shift_id: str
    category: str
    label: str
    checked: bool = False
    required: bool = True
    updated_at: datetime
    deleted_at: datetime | None = None


class Handover(SQLModel, table=True):
    id: str = Field(primary_key=True)
    shift_id: str
    report_json: str = "{}"
    next_task_id: str | None = None
    updated_at: datetime
    deleted_at: datetime | None = None
