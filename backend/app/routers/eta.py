"""ETA prediction endpoint.

POST /eta/predict — returns predicted task duration + per-feature contributions.
"""

from __future__ import annotations

import json
from functools import lru_cache
from pathlib import Path

import lightgbm as lgb
import numpy as np
import pandas as pd
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/eta", tags=["eta"])

# ── Paths ────────────────────────────────────────────────────────────────────

_ML_DIR = Path(__file__).resolve().parent.parent / "ml"
_MODEL_PATH = _ML_DIR / "eta_model.txt"
_ENCODERS_PATH = _ML_DIR / "encoders.json"
_REPO_ROOT = _ML_DIR.parents[2]
_BASELINES_PATH = _REPO_ROOT / "data" / "operator_baselines.csv"

# ── Feature spec (must match train_eta.py) ───────────────────────────────────

FEATURE_NAMES = [
    "task_type",
    "machine_type",
    "planned_quantity",
    "baseline_cycle_time_sec",
    "ground_softness",
    "rain",
    "slope_deg",
    "avg_load_pct",
    "is_night",
]


# ── Cached model + data loading ──────────────────────────────────────────────


@lru_cache
def _load_model() -> lgb.Booster:
    return lgb.Booster(model_file=str(_MODEL_PATH))


@lru_cache
def _load_encoders() -> dict[str, dict[str, int]]:
    with open(_ENCODERS_PATH) as f:
        return json.load(f)


@lru_cache
def _load_baselines() -> dict[tuple[str, str], float]:
    """Returns {(operator_id, task_type): median_cycle_time_sec}."""
    df = pd.read_csv(_BASELINES_PATH)
    result: dict[tuple[str, str], float] = {}
    for _, row in df.iterrows():
        result[(row["operator_id"], row["task_type"])] = float(row["median_cycle_time_sec"])
    return result


# ── Request / Response ───────────────────────────────────────────────────────


class EtaPredictRequest(BaseModel):
    task_type: str
    machine_type: str
    planned_quantity: float
    operator_id: str
    ground_softness: float = 0.2
    rain: float = 0.0
    slope_deg: float = 3.0
    avg_load_pct: float = 50.0
    is_night: bool = False


class EtaPredictResponse(BaseModel):
    predicted_duration_min: float
    contributions: dict[str, float]
    baseline_duration_min: float


# ── Endpoint ─────────────────────────────────────────────────────────────────


@router.post("/predict", response_model=EtaPredictResponse)
def predict_eta(req: EtaPredictRequest) -> EtaPredictResponse:
    model = _load_model()
    encoders = _load_encoders()
    baselines = _load_baselines()

    # Look up operator baseline cycle time
    baseline_key = (req.operator_id, req.task_type)
    baseline_cycle = baselines.get(baseline_key)
    if baseline_cycle is None:
        # Fall back to global median across all operators for this task type
        task_baselines = [v for (_, tt), v in baselines.items() if tt == req.task_type]
        baseline_cycle = float(np.median(task_baselines)) if task_baselines else 30.0

    # Encode categoricals
    task_type_enc = encoders.get("task_type", {}).get(req.task_type, 0)
    machine_type_enc = encoders.get("machine_type", {}).get(req.machine_type, 0)

    features = np.array([[
        task_type_enc,
        machine_type_enc,
        req.planned_quantity,
        baseline_cycle,
        req.ground_softness,
        req.rain,
        req.slope_deg,
        req.avg_load_pct,
        int(req.is_night),
    ]])

    # Prediction
    predicted = float(model.predict(features)[0])

    # Per-feature contributions via pred_contrib
    # Returns shape (1, n_features + 1) — last column is the bias/intercept
    contribs_raw = model.predict(features, pred_contrib=True)
    contribs_array = contribs_raw[0]

    contributions: dict[str, float] = {}
    for i, feat in enumerate(FEATURE_NAMES):
        contributions[feat] = round(float(contribs_array[i]), 3)

    # Naive baseline (mean prediction) is the bias term
    baseline_duration = round(float(contribs_array[-1]), 2)

    return EtaPredictResponse(
        predicted_duration_min=round(predicted, 2),
        contributions=contributions,
        baseline_duration_min=baseline_duration,
    )
