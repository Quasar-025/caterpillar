from fastapi.testclient import TestClient

from app.main import app


def _normal_payload() -> dict:
    return {
        "operator_id": "OP001",
        "mode": "DIG",
        "rolling_cycle_time_sec": 26.0,
        "idle_min": 2.0,
        "fuel_used_l": 5.0,
        "load_cycles": 20,
        "seatbelt": True,
        "is_moving": True,
        "load_pct": 52.0,
        "safe_load_limit": 90.0,
        "slope_deg": 3.0,
        "stability_idx": 0.84,
        "nearest_person_m": 32.0,
        "visibility": 90.0,
        "ground_softness": 0.3,
        "control_corrections_per_min": 2.7,
        "reaction_ms": 420.0,
        "speed": 2.0,
        "swing_angle": 20.0,
    }


def test_normal_usage_stays_inside_learned_envelope() -> None:
    with TestClient(app) as client:
        response = client.post("/anomaly/score", json=_normal_payload())

    assert response.status_code == 200
    body = response.json()
    assert body["is_anomaly"] is False
    assert 0 <= body["anomaly_score"] < 0.5
    assert body["safety_authority"] == "deterministic_rules"


def test_multivariate_extreme_is_flagged_with_explanatory_signals() -> None:
    payload = {
        **_normal_payload(),
        "seatbelt": False,
        "load_pct": 116.0,
        "stability_idx": 0.35,
        "nearest_person_m": 3.0,
        "control_corrections_per_min": 12.0,
        "reaction_ms": 900.0,
    }

    with TestClient(app) as client:
        response = client.post("/anomaly/score", json=payload)

    assert response.status_code == 200
    body = response.json()
    assert body["is_anomaly"] is True
    assert body["anomaly_score"] > 0.5
    assert body["model_version"] == "iforest-telemetry-v1"
    assert len(body["top_signals"]) == 3
    assert any(signal["feature"] == "seatbelt_moving" for signal in body["top_signals"])
