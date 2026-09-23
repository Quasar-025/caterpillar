"""Facts-only LLM phrasing with a deterministic fallback."""

from __future__ import annotations

import asyncio
import json
import re
from dataclasses import dataclass

import httpx
from google import genai

from app.core.config import Settings

_NUMBER_PATTERN = re.compile(r"-?\d+(?:\.\d+)?%?")
_SAFETY_INTENTS = {"safety_status", "safety_alert"}
_SYSTEM_PROMPT = """You are the communication layer for a construction machine operator.
Rewrite only the supplied facts into one concise, direct sentence.
Never calculate, infer, add, omit, or alter a number, condition, cause, or action.
Do not add advice. Do not use markdown. Return only the sentence."""


@dataclass(frozen=True)
class PhraseResult:
    text: str
    source: str
    fallback_used: bool


class PhrasingService:
    def __init__(self, settings: Settings):
        self._settings = settings

    async def phrase(
        self,
        *,
        intent: str,
        facts: dict[str, object],
        fallback: str,
    ) -> PhraseResult:
        clean_fallback = _clean(fallback)
        if intent in _SAFETY_INTENTS:
            return PhraseResult(clean_fallback, "template", True)

        provider = self._settings.llm_provider
        try:
            if provider == "gemini" and self._settings.gemini_api_key:
                candidate = await self._gemini(intent, facts, clean_fallback)
            elif provider == "openai" and self._settings.openai_api_key:
                candidate = await self._openai(intent, facts, clean_fallback)
            else:
                return PhraseResult(clean_fallback, "template", True)
        # Provider, transport, and malformed-response failures must never block
        # the operator's deterministic answer.
        except Exception:
            return PhraseResult(clean_fallback, "template", True)

        candidate = _clean(candidate)
        if not _is_fact_preserving(candidate, facts, clean_fallback):
            return PhraseResult(clean_fallback, "template", True)
        return PhraseResult(candidate, provider, False)

    async def _gemini(
        self,
        intent: str,
        facts: dict[str, object],
        fallback: str,
    ) -> str:
        model = self._settings.gemini_model
        key = self._settings.gemini_api_key
        assert key is not None
        client = genai.Client(api_key=key.get_secret_value())
        config = {
            "response_modalities": ["AUDIO"],
            "output_audio_transcription": {},
            "system_instruction": _SYSTEM_PROMPT,
        }
        transcript: list[str] = []

        async with asyncio.timeout(self._settings.llm_timeout_seconds):
            async with client.aio.live.connect(model=model, config=config) as session:
                await session.send_realtime_input(
                    text=_user_prompt(intent, facts, fallback),
                )
                async for response in session.receive():
                    content = response.server_content
                    if content is None:
                        continue
                    output = content.output_transcription
                    if output is not None and output.text:
                        transcript.append(output.text)
                    if content.turn_complete:
                        break

        return "".join(transcript)

    async def _openai(
        self,
        intent: str,
        facts: dict[str, object],
        fallback: str,
    ) -> str:
        key = self._settings.openai_api_key
        assert key is not None
        payload = {
            "model": self._settings.openai_model,
            "messages": [
                {"role": "system", "content": _SYSTEM_PROMPT},
                {"role": "user", "content": _user_prompt(intent, facts, fallback)},
            ],
            "temperature": 0,
            "max_tokens": 120,
        }
        headers = {
            "Authorization": f"Bearer {key.get_secret_value()}",
            "Content-Type": "application/json",
        }
        async with httpx.AsyncClient(timeout=self._settings.llm_timeout_seconds) as client:
            response = await client.post(
                "https://api.openai.com/v1/chat/completions",
                headers=headers,
                json=payload,
            )
            response.raise_for_status()
        body = response.json()
        return str(body["choices"][0]["message"]["content"])


def _user_prompt(intent: str, facts: dict[str, object], fallback: str) -> str:
    return json.dumps(
        {
            "intent": intent,
            "facts": facts,
            "deterministic_fallback": fallback,
        },
        sort_keys=True,
        separators=(",", ":"),
    )


def _clean(text: str) -> str:
    return " ".join(text.strip().split())[:500]


def _is_fact_preserving(
    candidate: str,
    facts: dict[str, object],
    fallback: str,
) -> bool:
    if not candidate or len(candidate) > 280:
        return False
    allowed_source = f"{json.dumps(facts, sort_keys=True)} {fallback}"
    allowed_numbers = set(_NUMBER_PATTERN.findall(allowed_source))
    candidate_numbers = set(_NUMBER_PATTERN.findall(candidate))
    return candidate_numbers.issubset(allowed_numbers)
