import '../telemetry/tick.dart';

enum WorkloadLevel {
  normal,
  elevated,
  high;

  String get label => name.toUpperCase();
}

class WorkloadBaseline {
  const WorkloadBaseline({
    required this.typicalIdleMin,
    required this.typicalCorrectionsPerMin,
    required this.typicalReactionMs,
  });

  final double typicalIdleMin;
  final double typicalCorrectionsPerMin;
  final double typicalReactionMs;

  static WorkloadBaseline forOperator(String operatorId) {
    return _operatorBaselines[operatorId] ?? _operatorBaselines['OP001']!;
  }
}

const _operatorBaselines = <String, WorkloadBaseline>{
  'OP001': WorkloadBaseline(
    typicalIdleMin: 5.83,
    typicalCorrectionsPerMin: 2.69,
    typicalReactionMs: 420.1,
  ),
  'OP002': WorkloadBaseline(
    typicalIdleMin: 3.61,
    typicalCorrectionsPerMin: 2.01,
    typicalReactionMs: 386.7,
  ),
  'OP003': WorkloadBaseline(
    typicalIdleMin: 7.93,
    typicalCorrectionsPerMin: 3.46,
    typicalReactionMs: 398.3,
  ),
  'OP004': WorkloadBaseline(
    typicalIdleMin: 4.83,
    typicalCorrectionsPerMin: 2.43,
    typicalReactionMs: 445.8,
  ),
  'OP005': WorkloadBaseline(
    typicalIdleMin: 9.54,
    typicalCorrectionsPerMin: 3.98,
    typicalReactionMs: 478.2,
  ),
  'OP006': WorkloadBaseline(
    typicalIdleMin: 5.20,
    typicalCorrectionsPerMin: 2.76,
    typicalReactionMs: 410.5,
  ),
  'OP007': WorkloadBaseline(
    typicalIdleMin: 11.07,
    typicalCorrectionsPerMin: 4.21,
    typicalReactionMs: 512.6,
  ),
  'OP008': WorkloadBaseline(
    typicalIdleMin: 3.12,
    typicalCorrectionsPerMin: 1.88,
    typicalReactionMs: 375.4,
  ),
};

class WorkloadState {
  const WorkloadState({
    required this.level,
    required this.continuousOperatingTime,
    required this.reasons,
    required this.breakRecommended,
    required this.evaluatedAt,
  });

  final WorkloadLevel level;
  final Duration continuousOperatingTime;
  final List<String> reasons;
  final bool breakRecommended;
  final DateTime evaluatedAt;
}

/// Estimates workload relative to the operator's own normal baseline.
///
/// This output is deliberately independent of [RiskEngine]. Workload never
/// changes operational hazard levels and never produces a Critical state.
class WorkloadEngine {
  DateTime? _operatingSince;
  DateTime? _stationarySince;
  DateTime? _lastTickAt;

  WorkloadState evaluate(TelemetryTick tick, {WorkloadBaseline? baseline}) {
    final normal = baseline ?? WorkloadBaseline.forOperator(tick.operatorId);
    _updateContinuousOperation(tick);
    final rawOperatingTime = _operatingSince == null
        ? Duration.zero
        : tick.timestamp.difference(_operatingSince!);
    final operatingTime =
        rawOperatingTime.isNegative ||
            rawOperatingTime > const Duration(hours: 12)
        ? Duration.zero
        : rawOperatingTime;

    var score = 0;
    final reasons = <String>[];

    if (operatingTime >= const Duration(hours: 2, minutes: 45)) {
      score += 2;
      reasons.add(
        'Operating continuously for ${_formatDuration(operatingTime)}',
      );
    } else if (operatingTime >= const Duration(hours: 2)) {
      score += 1;
      reasons.add(
        'Operating continuously for ${_formatDuration(operatingTime)}',
      );
    }

    final correctionRatio =
        tick.controlCorrectionsPerMin / normal.typicalCorrectionsPerMin;
    if (correctionRatio >= 1.5) {
      score += 2;
      reasons.add(
        'Control corrections are ${_percentAbove(correctionRatio)} above baseline',
      );
    } else if (correctionRatio >= 1.2) {
      score += 1;
      reasons.add(
        'Control corrections are ${_percentAbove(correctionRatio)} above baseline',
      );
    }

    final reactionRatio = tick.reactionMs / normal.typicalReactionMs;
    if (reactionRatio >= 1.5) {
      score += 2;
      reasons.add(
        'Reaction time is ${_percentAbove(reactionRatio)} above baseline',
      );
    } else if (reactionRatio >= 1.2) {
      score += 1;
      reasons.add(
        'Reaction time is ${_percentAbove(reactionRatio)} above baseline',
      );
    }

    if (tick.idleMin > normal.typicalIdleMin * 1.5) {
      score += 1;
      reasons.add('Idle pattern is above the operator baseline');
    }

    final level = switch (score) {
      >= 3 => WorkloadLevel.high,
      >= 1 => WorkloadLevel.elevated,
      _ => WorkloadLevel.normal,
    };
    return WorkloadState(
      level: level,
      continuousOperatingTime: operatingTime,
      reasons: reasons.take(2).toList(),
      breakRecommended: level == WorkloadLevel.high && !tick.isMoving,
      evaluatedAt: DateTime.now(),
    );
  }

  void reset() {
    _operatingSince = null;
    _stationarySince = null;
    _lastTickAt = null;
  }

  void _updateContinuousOperation(TelemetryTick tick) {
    final previousTick = _lastTickAt;
    if (previousTick != null) {
      final gap = tick.timestamp.difference(previousTick);
      if (gap.isNegative || gap > const Duration(hours: 12)) {
        _operatingSince = null;
        _stationarySince = null;
      }
    }
    _lastTickAt = tick.timestamp;

    if (tick.isMoving) {
      if (_stationarySince != null &&
          tick.timestamp.difference(_stationarySince!) >=
              const Duration(minutes: 5)) {
        _operatingSince = tick.timestamp;
      }
      _stationarySince = null;
      _operatingSince ??= tick.timestamp;
      return;
    }

    _stationarySince ??= tick.timestamp;
    if (_operatingSince != null &&
        tick.timestamp.difference(_stationarySince!) >=
            const Duration(minutes: 5)) {
      _operatingSince = null;
    }
  }

  String _percentAbove(double ratio) {
    return '${((ratio - 1) * 100).round()}%';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
