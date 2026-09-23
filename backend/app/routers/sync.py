from datetime import datetime

from fastapi import APIRouter, Depends, Query
from sqlmodel import Session

from app.db import get_session
from app.sync import apply_push, pull_changes
from app.sync.schemas import PullResponse, PushRequest, PushResponse

router = APIRouter(prefix="/sync", tags=["sync"])


@router.post("/push", response_model=PushResponse)
def push_changes(request: PushRequest, session: Session = Depends(get_session)) -> PushResponse:
    return apply_push(session, request)


@router.get("/pull", response_model=PullResponse)
def pull(
    since: datetime | None = Query(default=None),
    session: Session = Depends(get_session),
) -> PullResponse:
    return pull_changes(session, since)
