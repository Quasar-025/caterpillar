"""Secondary machine-usage anomaly scoring.

This endpoint is coaching-only. Deterministic safety rules remain authoritative.
"""

from __future__ import annotations

import math
from functools import lru_cache
from pathlib import Path

import joblib
import pandas as pd
from fastapi import APIRouter
from pydantic import BaseModel, Field

from app.ml.anomaly_features import FEATURE_LABELS, FEATURE_NAMES, engineer_record

router = APIRouter(prefix="/anomaly", tags=["anomaly"])

_MODEL_PATH = Path(__file__).resolve().parent.parent / "ml" / "anomaly_model.joblib"


class AnomalyScoreRequest(BaseModel):
    operator_id: str
    mode: str
    rolling_cycle_time_sec: float = Field(ge=0)
    idle_min: float = Field(ge=0)
    fuel_used_l: float = Field(ge=0)
    load_cycles: int = Field(ge=0)
    seatbelt: bool
    is_moving: bool
    load_pct: float
    safe_load_limit: float
    slope_deg: float
    stability_idx: float
    nearest_person_m: float
    visibility: float
    ground_softness: float
    control_corrections_per_min: float
    reaction_ms: float
    speed: float
    swing_angle: float


class AnomalySignal(BaseModel):
    feature: str
    label: str
    direction: str
    deviation: float


class AnomalyScoreResponse(BaseModel):
    is_anomaly: bool
    anomaly_score: float
    decision_score: float
    top_signals: list[AnomalySignal]
    model_version: str
    safety_authority: str = "deterministic_rules"


@lru_cache
def _artifact() -> dict:
    return joblib.load(_MODEL_PATH)


@router.post("/score", response_model=AnomalyScoreResponse)
def score_anomaly(req: AnomalyScoreRequest) -> AnomalyScoreResponse:
    artifact = _artifact()
    values = engineer_record(req.model_dump(), artifact["baselines"])
    feature_frame = pd.DataFrame([[values[name] for name in FEATURE_NAMES]], columns=FEATURE_NAMES)

    decision_score = float(artifact["model"].decision_function(feature_frame)[0])
    threshold = float(artifact["threshold"])
    score_scale = float(artifact["score_scale"])
    margin = (threshold - decision_score) / score_scale
    anomaly_score = 1.0 / (1.0 + math.exp(-max(-20.0, min(20.0, margin))))

    deviations = []
    for feature in FEATURE_NAMES:
        median = float(artifact["feature_medians"][feature])
        scale = max(float(artifact["feature_scales"][feature]), 1e-6)
        deviation = (values[feature] - median) / scale
        deviations.append((feature, deviation))
    deviations.sort(key=lambda item: abs(item[1]), reverse=True)

    signals = [
        AnomalySignal(
            feature=feature,
            label=FEATURE_LABELS[feature],
            direction="above" if deviation >= 0 else "below",
            deviation=round(abs(deviation), 2),
        )
        for feature, deviation in deviations[:3]
    ]

    return AnomalyScoreResponse(
        is_anomaly=decision_score < threshold,
        anomaly_score=round(anomaly_score, 4),
        decision_score=round(decision_score, 6),
        top_signals=signals,
        model_version=str(artifact["version"]),
    )
