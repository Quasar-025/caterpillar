"""Train a LightGBM model to predict task duration (actual_duration_min).

Usage:
    python -m app.ml.train_eta          # from backend/
    python backend/app/ml/train_eta.py  # from repo root

Reads:
    data/tasks.csv            – task-level records
    data/operator_baselines.csv – median cycle time per operator × task type

Writes:
    backend/app/ml/eta_model.txt   – LightGBM booster (native format)
    backend/app/ml/encoders.json   – label encoder mappings for categoricals
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import lightgbm as lgb
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder

# ── Paths ────────────────────────────────────────────────────────────────────

_SCRIPT_DIR = Path(__file__).resolve().parent
_REPO_ROOT = _SCRIPT_DIR.parents[2]  # backend/app/ml -> backend -> repo root
_DATA_DIR = _REPO_ROOT / "data"
_MODEL_PATH = _SCRIPT_DIR / "eta_model.txt"
_ENCODERS_PATH = _SCRIPT_DIR / "encoders.json"

# ── Feature spec (plan §11) ─────────────────────────────────────────────────

CATEGORICAL_FEATURES = ["task_type", "machine_type"]
NUMERIC_FEATURES = [
    "planned_quantity",
    "baseline_cycle_time_sec",
    "ground_softness",
    "rain",
    "slope_deg",
    "avg_load_pct",
    "is_night",
]
TARGET = "actual_duration_min"


def load_data() -> pd.DataFrame:
    """Load tasks and join operator baselines."""
    tasks = pd.read_csv(_DATA_DIR / "tasks.csv")
    baselines = pd.read_csv(_DATA_DIR / "operator_baselines.csv")

    # Join baseline cycle time for each operator × task_type
    df = tasks.merge(
        baselines[["operator_id", "task_type", "median_cycle_time_sec"]],
        on=["operator_id", "task_type"],
        how="left",
    )
    df.rename(columns={"median_cycle_time_sec": "baseline_cycle_time_sec"}, inplace=True)

    # Fill any missing baselines with the global median
    global_median = df["baseline_cycle_time_sec"].median()
    df["baseline_cycle_time_sec"].fillna(global_median, inplace=True)

    # Convert is_night to int (0/1)
    df["is_night"] = df["is_night"].astype(int)

    return df


def train() -> None:
    """Train and save the ETA model."""
    df = load_data()
    print(f"Loaded {len(df)} tasks")

    all_features = CATEGORICAL_FEATURES + NUMERIC_FEATURES

    # ── Encode categoricals ──────────────────────────────────────────────
    encoders: dict[str, dict[str, int]] = {}
    for col in CATEGORICAL_FEATURES:
        le = LabelEncoder()
        df[col] = le.fit_transform(df[col])
        encoders[col] = {label: int(idx) for label, idx in zip(le.classes_, le.transform(le.classes_))}

    X = df[all_features].values
    y = df[TARGET].values

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42,
    )

    # ── Train ────────────────────────────────────────────────────────────
    train_data = lgb.Dataset(X_train, label=y_train, feature_name=all_features)
    valid_data = lgb.Dataset(X_test, label=y_test, feature_name=all_features, reference=train_data)

    params = {
        "objective": "regression",
        "metric": "mae",
        "num_leaves": 31,
        "learning_rate": 0.05,
        "feature_fraction": 0.9,
        "bagging_fraction": 0.8,
        "bagging_freq": 5,
        "verbose": -1,
    }

    booster = lgb.train(
        params,
        train_data,
        num_boost_round=500,
        valid_sets=[valid_data],
        callbacks=[lgb.early_stopping(50), lgb.log_evaluation(100)],
    )

    # ── Evaluate ─────────────────────────────────────────────────────────
    preds = booster.predict(X_test)
    mae = float(np.mean(np.abs(preds - y_test)))

    # Naive baseline: mean duration per task type
    df_test = pd.DataFrame(X_test, columns=all_features)
    df_test["actual"] = y_test
    df_test["pred_naive"] = y_train.mean()  # simplest baseline
    naive_mae = float(np.mean(np.abs(df_test["pred_naive"] - y_test)))

    print(f"\nModel MAE:   {mae:.2f} min")
    print(f"Naive MAE:   {naive_mae:.2f} min")
    print(f"Improvement: {((naive_mae - mae) / naive_mae * 100):.1f}%")

    # ── Feature importance ───────────────────────────────────────────────
    importance = dict(zip(all_features, booster.feature_importance(importance_type="gain").tolist()))
    print(f"\nFeature importance (gain):")
    for feat, imp in sorted(importance.items(), key=lambda x: -x[1]):
        print(f"  {feat:30s} {imp:.1f}")

    # ── Save ─────────────────────────────────────────────────────────────
    _SCRIPT_DIR.mkdir(parents=True, exist_ok=True)
    booster.save_model(str(_MODEL_PATH))
    print(f"\nModel saved to {_MODEL_PATH}")

    with open(_ENCODERS_PATH, "w") as f:
        json.dump(encoders, f, indent=2)
    print(f"Encoders saved to {_ENCODERS_PATH}")


if __name__ == "__main__":
    train()
