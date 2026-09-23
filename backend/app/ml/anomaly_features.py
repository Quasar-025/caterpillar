"""Feature engineering shared by IsolationForest training and inference."""

from __future__ import annotations

from collections.abc import Mapping

import numpy as np
import pandas as pd

FEATURE_NAMES = [
    "cycle_time_ratio",
    "idle_ratio",
    "fuel_per_cycle",
    "seatbelt_moving",
    "load_margin",
    "slope_deg",
    "stability_idx",
    "nearest_person_m",
    "visibility",
    "ground_softness",
    "correction_ratio",
    "reaction_ratio",
    "speed",
    "absolute_swing_angle",
]

FEATURE_LABELS = {
    "cycle_time_ratio": "cycle time versus operator baseline",
    "idle_ratio": "idle time versus operator baseline",
    "fuel_per_cycle": "fuel used per completed cycle",
    "seatbelt_moving": "movement while the seatbelt is unfastened",
    "load_margin": "load above the safe limit",
    "slope_deg": "ground slope",
    "stability_idx": "machine stability",
    "nearest_person_m": "worker proximity",
    "visibility": "site visibility",
    "ground_softness": "ground softness",
    "correction_ratio": "control corrections versus operator baseline",
    "reaction_ratio": "reaction time versus operator baseline",
    "speed": "travel speed",
    "absolute_swing_angle": "swing angle",
}


def baseline_lookup(baselines: pd.DataFrame) -> dict[tuple[str, str], dict[str, float]]:
    """Create a keyed baseline map with global fallback handled by the caller."""
    result: dict[tuple[str, str], dict[str, float]] = {}
    for row in baselines.to_dict(orient="records"):
        result[(str(row["operator_id"]), str(row["task_type"]))] = {
            "cycle": float(row["median_cycle_time_sec"]),
            "idle": max(float(row["typical_idle_min"]), 0.1),
            "corrections": max(float(row["typical_corrections_per_min"]), 0.1),
            "reaction": max(float(row["typical_reaction_ms"]), 1.0),
        }
    return result


def engineer_frame(
    frame: pd.DataFrame,
    baselines: Mapping[tuple[str, str], Mapping[str, float]],
) -> pd.DataFrame:
    """Turn raw telemetry rows into stable, operator-relative model features."""
    rows = [engineer_record(record, baselines) for record in frame.to_dict(orient="records")]
    return pd.DataFrame(rows, columns=FEATURE_NAMES, dtype=float)


def engineer_record(
    record: Mapping[str, object],
    baselines: Mapping[tuple[str, str], Mapping[str, float]],
) -> dict[str, float]:
    operator_id = str(record.get("operator_id", ""))
    mode = str(record.get("mode", "DIG")).upper()
    baseline = baselines.get((operator_id, mode)) or _global_baseline(baselines, mode)

    rolling_cycle = _number(record.get("rolling_cycle_time_sec"))
    idle_min = _number(record.get("idle_min"))
    load_pct = _number(record.get("load_pct"))
    safe_load_limit = _number(record.get("safe_load_limit"), fallback=90.0)
    load_cycles = max(_number(record.get("load_cycles")), 1.0)
    fuel_used = max(_number(record.get("fuel_used_l")), 0.0)
    is_moving = _boolean(record.get("is_moving"))
    seatbelt = _boolean(record.get("seatbelt"))

    return {
        "cycle_time_ratio": rolling_cycle / baseline["cycle"],
        "idle_ratio": idle_min / baseline["idle"],
        "fuel_per_cycle": fuel_used / load_cycles,
        "seatbelt_moving": float(is_moving and not seatbelt),
        "load_margin": load_pct - safe_load_limit,
        "slope_deg": _number(record.get("slope_deg")),
        "stability_idx": _number(record.get("stability_idx"), fallback=1.0),
        "nearest_person_m": _number(record.get("nearest_person_m"), fallback=50.0),
        "visibility": _number(record.get("visibility"), fallback=100.0),
        "ground_softness": _number(record.get("ground_softness")),
        "correction_ratio": _number(record.get("control_corrections_per_min"))
        / baseline["corrections"],
        "reaction_ratio": _number(record.get("reaction_ms")) / baseline["reaction"],
        "speed": _number(record.get("speed")),
        "absolute_swing_angle": abs(_number(record.get("swing_angle"))),
    }


def _global_baseline(
    baselines: Mapping[tuple[str, str], Mapping[str, float]],
    mode: str,
) -> dict[str, float]:
    candidates = [values for (_, task), values in baselines.items() if task == mode]
    if not candidates:
        candidates = list(baselines.values())
    if not candidates:
        return {"cycle": 30.0, "idle": 5.0, "corrections": 3.0, "reaction": 420.0}
    return {
        key: float(np.median([candidate[key] for candidate in candidates]))
        for key in ("cycle", "idle", "corrections", "reaction")
    }


def _number(value: object, *, fallback: float = 0.0) -> float:
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return fallback
    return parsed if np.isfinite(parsed) else fallback


def _boolean(value: object) -> bool:
    if isinstance(value, bool):
        return value
    if isinstance(value, (int, float)):
        return value == 1
    return str(value).strip().lower() in {"1", "true", "yes", "fastened"}
