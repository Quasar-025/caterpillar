# CAT Operator Copilot backend

FastAPI service for tasks, ETA, phrasing, and device sync.

```powershell
python -m pip install -e ".[dev]"
python -m pytest
uvicorn app.main:app --reload
```

## Optional anomaly model

The IsolationForest is a coaching-only secondary signal. Deterministic safety
rules remain authoritative.

```powershell
python -m app.ml.train_anomaly
```

The checked-in model serves `POST /anomaly/score`. Training learns the normal
operating envelope from operator-relative telemetry features and reports its
agreement with held-out deterministic extreme-condition guards.

## Optional LLM phrasing

`POST /phrase` accepts computed facts plus a deterministic fallback. Set
`CAT_LLM_PROVIDER=gemini` or `openai` and configure the matching API key to
enable rewording. Without a key, on timeout, or when validation rejects new
numbers, the endpoint returns the supplied template. Safety alerts and safety
status always remain template-driven.

Gemini uses the `gemini-3.8-live` WebSocket API with output transcription. Put
`CAT_GEMINI_API_KEY` only in `backend/.env`; the key is never sent to Flutter.
The app still displays the deterministic answer immediately and retains local
speech recognition, text-to-speech, and offline fallback behavior.
