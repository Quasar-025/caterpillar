"""Train and validate the secondary IsolationForest anomaly detector.

The rules engine remains authoritative for safety. This model learns normal
machine usage and contributes a non-safety unusual-behaviour signal.
"""

from __future__ import annotations

import json
from pathlib import Path

import joblib
import numpy as np
import pandas as pd
from sklearn.ensemble import IsolationForest
from sklearn.metrics import precision_recall_fscore_support

from app.ml.anomaly_features import FEATURE_NAMES, baseline_lookup, engineer_frame

ML_DIR = Path(__file__).resolve().parent
REPO_ROOT = ML_DIR.parents[2]
DATA_DIR = REPO_ROOT / "data"
MODEL_PATH = ML_DIR / "anomaly_model.joblib"
MODEL_VERSION = "iforest-telemetry-v1"


def train() -> dict[str, float | int | str]:
    telemetry = pd.read_csv(DATA_DIR / "telemetry.csv")
    baselines_frame = pd.read_csv(DATA_DIR / "operator_baselines.csv")
    baselines = baseline_lookup(baselines_frame)

    features = engineer_frame(telemetry, baselines)
    rule_flags = _extreme_condition_mask(telemetry, features)
    normal_features = features.loc[~rule_flags]

    model = IsolationForest(
        n_estimators=300,
        max_samples=min(2048, len(normal_features)),
        max_features=1.0,
        contamination="auto",
        random_state=42,
        n_jobs=-1,
    )
    model.fit(normal_features)

    normal_scores = model.decision_function(normal_features)
    threshold = float(np.quantile(normal_scores, 0.03))
    score_scale = max(float(np.std(normal_scores)), 1e-6)

    all_scores = model.decision_function(features)
    predictions = all_scores < threshold
    precision, recall, f1, _ = precision_recall_fscore_support(
        rule_flags,
        predictions,
        average="binary",
        zero_division=0,
    )

    medians = normal_features.median()
    mad = (normal_features - medians).abs().median()
    # Keep explanations stable for binary or highly discrete features whose
    # median absolute deviation can be zero.
    robust_scales = (
        pd.concat(
            [mad * 1.4826, normal_features.std() * 0.5],
            axis=1,
        )
        .max(axis=1)
        .clip(lower=0.01)
    )

    artifact = {
        "model": model,
        "version": MODEL_VERSION,
        "threshold": threshold,
        "score_scale": score_scale,
        "feature_names": FEATURE_NAMES,
        "feature_medians": medians.to_dict(),
        "feature_scales": robust_scales.to_dict(),
        "baselines": baselines,
    }
    joblib.dump(artifact, MODEL_PATH, compress=3)

    metrics: dict[str, float | int | str] = {
        "model_version": MODEL_VERSION,
        "normal_samples": int((~rule_flags).sum()),
        "rule_flagged_samples": int(rule_flags.sum()),
        "threshold": round(threshold, 6),
        "rule_agreement_precision": round(float(precision), 4),
        "rule_agreement_recall": round(float(recall), 4),
        "rule_agreement_f1": round(float(f1), 4),
    }
    print(json.dumps(metrics, indent=2))
    return metrics


def _extreme_condition_mask(
    telemetry: pd.DataFrame,
    features: pd.DataFrame,
) -> pd.Series:
    """Hold out obvious extremes when learning the normal operating envelope.

    These are evaluation guards, not model labels. IsolationForest still trains
    without target labels and may detect combinations that no individual guard
    captures.
    """
    stationary = telemetry["is_moving"].astype(int) == 0
    return (
        (features["seatbelt_moving"] > 0)
        | (features["load_margin"] > 0)
        | (features["stability_idx"] < 0.62)
        | (features["nearest_person_m"] < 8)
        | (features["cycle_time_ratio"] > 2.0)
        | (features["cycle_time_ratio"] < 0.5)
        | ((features["idle_ratio"] > 2.0) & stationary)
        | (features["fuel_per_cycle"] > 12)
        | (features["correction_ratio"] > 1.8)
        | (features["reaction_ratio"] > 1.5)
        | (features["slope_deg"] > 10)
        | (features["visibility"] < 30)
        | (features["ground_softness"] > 0.85)
        | (features["absolute_swing_angle"] > 110)
    )


if __name__ == "__main__":
    train()
