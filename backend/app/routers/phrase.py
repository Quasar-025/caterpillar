"""LLM-assisted wording for already-computed facts."""

from __future__ import annotations

from functools import lru_cache
from typing import Literal

from fastapi import APIRouter, Depends
from pydantic import BaseModel, Field, JsonValue

from app.core.config import get_settings
from app.services.phrasing import PhraseResult, PhrasingService

router = APIRouter(prefix="/phrase", tags=["phrase"])

PhraseIntent = Literal[
    "voice_answer",
    "shift_brief",
    "eta_explanation",
    "handover",
    "recommendation",
    "safety_status",
    "safety_alert",
]


class PhraseRequest(BaseModel):
    intent: PhraseIntent
    facts: dict[str, JsonValue]
    fallback: str = Field(min_length=1, max_length=500)


class PhraseResponse(BaseModel):
    text: str
    source: Literal["template", "gemini", "openai"]
    fallback_used: bool


@lru_cache
def get_phrasing_service() -> PhrasingService:
    return PhrasingService(get_settings())


@router.post("", response_model=PhraseResponse)
async def phrase_facts(
    req: PhraseRequest,
    service: PhrasingService = Depends(get_phrasing_service),
) -> PhraseResponse:
    result: PhraseResult = await service.phrase(
        intent=req.intent,
        facts=dict(req.facts),
        fallback=req.fallback,
    )
    return PhraseResponse(
        text=result.text,
        source=result.source,
        fallback_used=result.fallback_used,
    )
