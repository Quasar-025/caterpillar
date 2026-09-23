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
