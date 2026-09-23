import 'dart:math';

import '../telemetry/tick.dart';

/// Live ETA blending engine (plan §11).
///
/// Blends the backend model prediction with the operator's current pace.
/// The blend weight `w` rises with progress — early on the model dominates,
/// later the live pace takes over.
///
/// If the backend prediction is unavailable (offline), only the pace term
/// is used.
class EtaLiveEngine {
  EtaLiveEngine();

  /// Cache the model's prediction at task start.
  double? _modelPredictionMin;

  /// The pred_contrib values from the backend.
  Map<String, double>? _contributions;

  /// Conditions snapshot at task start (for explanation comparison).
  double? _startGroundSoftness;
  double? _startRain;
  double? _startCycleTimeSec;
  String? _currentTaskId;

  /// Set when the backend responds at task start.
  void cacheModelPrediction({
    required String taskId,
    required double predictedDurationMin,
    required Map<String, double> contributions,
    required double groundSoftness,
    required double rain,
    required double cycleTimeSec,
  }) {
    _currentTaskId = taskId;
    _modelPredictionMin = predictedDurationMin.isFinite
        ? predictedDurationMin.clamp(1.0, 720.0).toDouble()
        : null;
    _contributions = Map.of(contributions);
    _startGroundSoftness = groundSoftness;
    _startRain = rain;
    _startCycleTimeSec = cycleTimeSec;
  }

  /// Evaluate on every telemetry tick.
  EtaState evaluate(
    TelemetryTick tick, {
    required double baselineCycleTimeSec,
    required double plannedQuantity,
  }) {
    // Reset cache if task changed
    if (_currentTaskId != null && _currentTaskId != tick.taskId) {
      _modelPredictionMin = null;
      _contributions = null;
      _currentTaskId = tick.taskId;
    }

    final progress =
        (tick.progressPct.isFinite ? tick.progressPct : 0).clamp(0.0, 100.0) /
        100.0;

    // ── Pace-based remaining ────────────────────────────────────────────
    final safeQuantity = (plannedQuantity.isFinite ? plannedQuantity : 1.0)
        .clamp(1.0, 10000.0)
        .toDouble();
    final completedCycles = (safeQuantity * progress).round();
    final remainingCycles = max(0.0, safeQuantity - completedCycles);
    final rollingCycle =
        tick.rollingCycleTimeSec.isFinite && tick.rollingCycleTimeSec > 0
        ? tick.rollingCycleTimeSec
        : max(1.0, baselineCycleTimeSec);
    final paceRemaining = remainingCycles > 0
        ? remainingCycles * rollingCycle / 60.0
        : 0.0;

    // ── Model-based remaining ───────────────────────────────────────────
    double? modelRemaining;
    if (_modelPredictionMin != null) {
      modelRemaining = _modelPredictionMin! * (1.0 - progress);
    }

    // ── Blend ───────────────────────────────────────────────────────────
    // w rises with progress (sqrt gives early weight to pace)
    final w = sqrt(progress.clamp(0.0, 1.0));
    double etaRemaining;

    if (modelRemaining != null) {
      etaRemaining = w * paceRemaining + (1.0 - w) * modelRemaining;
    } else {
      // Offline fallback: pace only
      etaRemaining = paceRemaining;
    }

    etaRemaining = etaRemaining.isFinite
        ? etaRemaining.clamp(0.0, 720.0).toDouble()
        : 0.0;

    // ── Deterministic explanation ────────────────────────────────────────
    final explanation = _buildExplanation(
      tick: tick,
      baselineCycleTimeSec: baselineCycleTimeSec,
      etaRemaining: etaRemaining,
      modelRemaining: modelRemaining,
    );

    return EtaState(
      etaRemainingMin: etaRemaining,
      modelPredictionMin: _modelPredictionMin,
      paceRemainingMin: paceRemaining,
      blendWeight: w,
      explanation: explanation,
      contributions: _contributions,
    );
  }

  String? _buildExplanation({
    required TelemetryTick tick,
    required double baselineCycleTimeSec,
    required double etaRemaining,
    required double? modelRemaining,
  }) {
    if (_startCycleTimeSec == null) return null;

    final reasons = <_ExplanationEntry>[];

    // Cycle time change vs baseline
    if (baselineCycleTimeSec > 0) {
      final cycleChangePct =
          ((tick.rollingCycleTimeSec - baselineCycleTimeSec) /
                  baselineCycleTimeSec *
                  100)
              .roundToDouble();
      if (cycleChangePct.abs() > 5) {
        reasons.add(
          _ExplanationEntry(
            weight: cycleChangePct.abs(),
            text:
                'cycle time ${cycleChangePct > 0 ? 'up' : 'down'} '
                '${cycleChangePct.abs().toStringAsFixed(0)}% '
                'over the last 8 cycles',
          ),
        );
      }
    }

    // Ground softness change
    if (_startGroundSoftness != null) {
      final delta = tick.groundSoftness - _startGroundSoftness!;
      if (delta.abs() > 0.1) {
        reasons.add(
          _ExplanationEntry(
            weight: delta.abs() * 50,
            text: 'ground softness ${delta > 0 ? 'increased' : 'decreased'}',
          ),
        );
      }
    }

    // Rain change
    if (_startRain != null) {
      final delta = tick.rain - _startRain!;
      if (delta.abs() > 0.3) {
        reasons.add(
          _ExplanationEntry(
            weight: delta.abs() * 40,
            text: delta > 0 ? 'rain started' : 'rain stopped',
          ),
        );
      }
    }

    if (reasons.isEmpty) return null;

    reasons.sort((a, b) => b.weight.compareTo(a.weight));

    // Build the explanation string
    final signedDelta = modelRemaining != null
        ? etaRemaining - modelRemaining
        : 0.0;
    final delta = signedDelta.abs();
    final topReasons = reasons.take(2).map((r) => r.text).join('; ');
    if (modelRemaining == null || delta < 0.5) {
      return 'ETA stable: $topReasons';
    }
    final change = signedDelta > 0 ? 'increased' : 'improved';
    return 'ETA $change by ${delta.toStringAsFixed(0)} min: $topReasons';
  }

  void reset() {
    _modelPredictionMin = null;
    _contributions = null;
    _startGroundSoftness = null;
    _startRain = null;
    _startCycleTimeSec = null;
    _currentTaskId = null;
  }
}

class _ExplanationEntry {
  const _ExplanationEntry({required this.weight, required this.text});
  final double weight;
  final String text;
}

/// The ETA state emitted on every tick.
class EtaState {
  const EtaState({
    required this.etaRemainingMin,
    required this.modelPredictionMin,
    required this.paceRemainingMin,
    required this.blendWeight,
    this.explanation,
    this.contributions,
  });

  /// Blended ETA remaining (minutes).
  final double etaRemainingMin;

  /// Model's prediction cached at task start (null if offline).
  final double? modelPredictionMin;

  /// Pace-based remaining from rolling cycle time (minutes).
  final double paceRemainingMin;

  /// Blend weight `w` (0–1). Higher = more pace, less model.
  final double blendWeight;

  /// Deterministic explanation string, e.g.
  /// "ETA +8 min: cycle time up 18% over the last 8 cycles; ground softness increased."
  final String? explanation;

  /// Per-feature contributions from LightGBM pred_contrib.
  final Map<String, double>? contributions;

  static const empty = EtaState(
    etaRemainingMin: 0,
    modelPredictionMin: null,
    paceRemainingMin: 0,
    blendWeight: 0,
  );
}
