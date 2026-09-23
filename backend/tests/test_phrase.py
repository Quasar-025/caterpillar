import asyncio
from types import SimpleNamespace

from fastapi.testclient import TestClient
from pytest import MonkeyPatch

from app.core.config import Settings
from app.main import app
from app.services.phrasing import PhrasingService


def test_endpoint_returns_deterministic_fallback_without_provider() -> None:
    with TestClient(app) as client:
        response = client.post(
            "/phrase",
            json={
                "intent": "eta_explanation",
                "facts": {"eta_change_min": 8, "cause": "soft ground"},
                "fallback": "ETA increased by 8 minutes because the ground is softer.",
            },
        )

    assert response.status_code == 200
    assert response.json() == {
        "text": "ETA increased by 8 minutes because the ground is softer.",
        "source": "template",
        "fallback_used": True,
    }


def test_configured_provider_can_rephrase_supplied_facts() -> None:
    service = _StubGeminiService(
        Settings(llm_provider="gemini", gemini_api_key="test-key"),
        candidate="Softer ground increased the ETA by 8 minutes.",
    )

    result = asyncio.run(
        service.phrase(
            intent="eta_explanation",
            facts={"eta_change_min": 8, "cause": "softer ground"},
            fallback="ETA increased by 8 minutes because the ground is softer.",
        )
    )

    assert result.source == "gemini"
    assert result.fallback_used is False
    assert result.text == "Softer ground increased the ETA by 8 minutes."


def test_new_numbers_are_rejected_as_hallucinated_facts() -> None:
    fallback = "ETA increased by 8 minutes because the ground is softer."
    service = _StubGeminiService(
        Settings(llm_provider="gemini", gemini_api_key="test-key"),
        candidate="ETA increased by 99 minutes.",
    )

    result = asyncio.run(
        service.phrase(
            intent="eta_explanation",
            facts={"eta_change_min": 8, "cause": "softer ground"},
            fallback=fallback,
        )
    )

    assert result.source == "template"
    assert result.fallback_used is True
    assert result.text == fallback


def test_safety_wording_never_leaves_deterministic_templates() -> None:
    service = _StubGeminiService(
        Settings(llm_provider="gemini", gemini_api_key="test-key"),
        candidate="Keep operating.",
    )

    result = asyncio.run(
        service.phrase(
            intent="safety_status",
            facts={"risk": "CRITICAL", "action": "STOP"},
            fallback="Critical risk. Stop machine movement.",
        )
    )

    assert result.source == "template"
    assert result.text == "Critical risk. Stop machine movement."
    assert service.calls == 0


def test_gemini_live_uses_transcribed_audio_response(monkeypatch: MonkeyPatch) -> None:
    session = _FakeLiveSession("Softer ground increased the ETA by 8 minutes.")
    client = SimpleNamespace(
        aio=SimpleNamespace(
            live=SimpleNamespace(
                connect=lambda **kwargs: _FakeLiveConnection(session, kwargs),
            )
        )
    )
    monkeypatch.setattr(
        "app.services.phrasing.genai.Client",
        lambda **kwargs: client,
    )
    service = PhrasingService(
        Settings(
            llm_provider="gemini",
            gemini_api_key="test-key",
            gemini_model="gemini-3.8-live",
        )
    )

    result = asyncio.run(
        service.phrase(
            intent="eta_explanation",
            facts={"eta_change_min": 8, "cause": "softer ground"},
            fallback="ETA increased by 8 minutes because the ground is softer.",
        )
    )

    assert result.source == "gemini"
    assert result.text == "Softer ground increased the ETA by 8 minutes."
    assert session.connection_args["model"] == "gemini-3.8-live"
    assert session.connection_args["config"]["response_modalities"] == ["AUDIO"]
    assert session.sent_text is not None


class _StubGeminiService(PhrasingService):
    def __init__(self, settings: Settings, *, candidate: str):
        super().__init__(settings)
        self.candidate = candidate
        self.calls = 0

    async def _gemini(
        self,
        intent: str,
        facts: dict[str, object],
        fallback: str,
    ) -> str:
        self.calls += 1
        return self.candidate


class _FakeLiveConnection:
    def __init__(self, session: "_FakeLiveSession", connection_args: dict):
        self._session = session
        self._session.connection_args = connection_args

    async def __aenter__(self) -> "_FakeLiveSession":
        return self._session

    async def __aexit__(self, *_: object) -> None:
        return None


class _FakeLiveSession:
    def __init__(self, transcript: str):
        self.transcript = transcript
        self.sent_text: str | None = None
        self.connection_args: dict = {}

    async def send_realtime_input(self, *, text: str) -> None:
        self.sent_text = text

    async def receive(self):
        yield SimpleNamespace(
            server_content=SimpleNamespace(
                output_transcription=SimpleNamespace(text=self.transcript),
                turn_complete=True,
            )
        )
