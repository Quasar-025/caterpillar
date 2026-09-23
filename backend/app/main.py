from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import get_settings
from app.db import create_db_and_tables
from app.routers.anomaly import router as anomaly_router
from app.routers.eta import router as eta_router
from app.routers.phrase import router as phrase_router
from app.routers.sync import router as sync_router
from app.routers.telemetry import router as telemetry_router


@asynccontextmanager
async def lifespan(_: FastAPI):
    create_db_and_tables()
    yield


settings = get_settings()
app = FastAPI(title=settings.app_name, version="0.1.0", lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(sync_router)
app.include_router(eta_router)
app.include_router(telemetry_router)
app.include_router(anomaly_router)
app.include_router(phrase_router)


@app.get("/health", tags=["system"])
def health() -> dict[str, str]:
    return {"status": "ok"}
