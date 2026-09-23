import 'dart:math';

/// Deterministic shift recovery engine (plan §11).
///
/// Computes how far behind the operator is and how much is recoverable
/// if the next tasks run at baseline pace. No network call — pure math.
class ShiftRecoveryEngine {
  const ShiftRecoveryEngine();

  /// Evaluate shift recovery based on current state.
  ///
  /// [baselineCycleSec] — operator's median cycle time for current task type.
  /// [rollingCycleSec] — current rolling average cycle time.
  /// [remainingTasksMin] — list of predicted remaining minutes per future task.
  /// [scheduledShiftEndMin] — minutes until shift end from now.
  /// [excessIdleMin] — projected excess idle minutes that could be cut.
  ShiftRecoveryState evaluate({
    required double baselineCycleSec,
    required double rollingCycleSec,
    required List<double> remainingTasksMin,
    required double scheduledShiftEndMin,
    double excessIdleMin = 0.0,
  }) {
    // Efficiency: how much faster/slower than baseline
    final efficiency = rollingCycleSec > 0
        ? (baselineCycleSec / rollingCycleSec).clamp(0.6, 1.3)
        : 1.0;

    // Predicted end of all remaining tasks at current efficiency
    double totalRemainingMin = 0;
    for (final taskMin in remainingTasksMin) {
      totalRemainingMin += taskMin / efficiency;
    }

    final behindMin = totalRemainingMin - scheduledShiftEndMin;

    // What's recoverable if next 2 tasks run at baseline pace
    double recoverableFromPace = 0;
    final tasksToRecover = remainingTasksMin.take(2);
    for (final taskMin in tasksToRecover) {
      recoverableFromPace += taskMin * (1.0 / efficiency - 1.0);
    }
    recoverableFromPace = recoverableFromPace.abs();

    final recoverableMin = behindMin > 0
        ? min(behindMin, recoverableFromPace + excessIdleMin)
        : 0.0;

    // Build the template phrase
    String summary;
    if (behindMin <= 0) {
      final aheadMin = behindMin.abs();
      summary = aheadMin >= 1
          ? '${aheadMin.toStringAsFixed(0)} min ahead of schedule.'
          : 'On schedule.';
    } else if (recoverableMin >= behindMin * 0.9) {
      summary =
          'If the next two tasks run at your normal pace, you can recover '
          'about ${recoverableMin.toStringAsFixed(0)} of the '
          '${behindMin.toStringAsFixed(0)} minutes.';
    } else {
      summary =
          '${behindMin.toStringAsFixed(0)} min behind. '
          'About ${recoverableMin.toStringAsFixed(0)} min recoverable '
          'at normal pace.';
    }

    return ShiftRecoveryState(
      behindMin: behindMin,
      recoverableMin: recoverableMin,
      efficiency: efficiency,
      summary: summary,
    );
  }
}

/// The shift recovery state, recomputed whenever ETA or shift data changes.
class ShiftRecoveryState {
  const ShiftRecoveryState({
    required this.behindMin,
    required this.recoverableMin,
    required this.efficiency,
    required this.summary,
  });

  /// How many minutes behind schedule (negative = ahead).
  final double behindMin;

  /// How many of those minutes are recoverable at baseline pace.
  final double recoverableMin;

  /// Current efficiency ratio (baseline / rolling). 1.0 = on pace.
  final double efficiency;

  /// Template-phrased summary for the UI.
  final String summary;

  bool get isAhead => behindMin <= 0;
  bool get isBehind => behindMin > 0;
}
