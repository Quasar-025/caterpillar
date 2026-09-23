from collections.abc import Generator

from sqlalchemy.engine import Engine
from sqlmodel import Session, SQLModel, create_engine

from app.core.config import get_settings
from app.models import ChecklistItem, Handover, Shift, Task  # noqa: F401

engine: Engine


def configure_engine(url: str | None = None) -> Engine:
    global engine
    settings = get_settings()
    database_url = url or settings.sqlalchemy_database_url
    connect_args = {"check_same_thread": False} if database_url.startswith("sqlite") else {}
    engine_options = {
        "connect_args": connect_args,
        "pool_pre_ping": True,
    }
    if not database_url.startswith("sqlite"):
        engine_options.update(
            pool_size=5,
            max_overflow=10,
            pool_recycle=300,
        )
    engine = create_engine(database_url, **engine_options)
    return engine


configure_engine()


def create_db_and_tables() -> None:
    SQLModel.metadata.create_all(engine)


def get_session() -> Generator[Session, None, None]:
    with Session(engine) as session:
        yield session
