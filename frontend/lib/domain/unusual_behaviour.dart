import '../telemetry/machine_mode.dart';
import '../telemetry/swing_direction.dart';
import '../telemetry/tick.dart';

enum BehaviourCategory {
  excessIdle,
  beltBeforeMovement,
  repeatedOverload,
  highFuelPerCycle,
  harshSwingReversal,
}

enum InsightPriority { coaching, action }

class BehaviourInsight {
  const BehaviourInsight({
    required this.category,
    required this.priority,
    required this.title,
    required this.whatHappened,
    required this.likelyReason,
    required this.recommendedAction,
    required this.impact,
    required this.detectedAt,
  });

  final BehaviourCategory category;
  final InsightPriority priority;
  final String title;
  final String whatHappened;
  final String likelyReason;
  final String recommendedAction;
  final String impact;
  final DateTime detectedAt;
}

class UnusualBehaviourEngine {
  static const _typicalIdleMin = <String, double>{
    'OP001': 5.8,
    'OP002': 4.9,
    'OP003': 6.4,
    'OP004': 5.2,
    'OP005': 7.1,
    'OP006': 5.5,
    'OP007': 7.4,
    'OP008': 4.6,
  };

  static const _fuelPerCycleBaseline = <MachineMode, double>{
    MachineMode.dig: 0.42,
    MachineMode.lift: 0.58,
    MachineMode.load: 0.48,
    MachineMode.grade: 0.36,
  };

  final Map<BehaviourCategory, BehaviourInsight> _insights = {};
  TelemetryTick? _previous;
  int _overloadStreak = 0;
  int _rapidReversals = 0;

  List<BehaviourInsight> get insights {
    final values = _insights.values.toList()
      ..sort((a, b) => b.detectedAt.compareTo(a.detectedAt));
    return List.unmodifiable(values);
  }

  List<BehaviourInsight> evaluate(TelemetryTick tick) {
    _evaluateIdle(tick);
    _evaluateSeatbelt(tick);
    _evaluateOverload(tick);
    _evaluateFuel(tick);
    _evaluateSwing(tick);
    _previous = tick;
    return insights;
  }

  void reset() {
    _insights.clear();
    _previous = null;
    _overloadStreak = 0;
    _rapidReversals = 0;
  }

  void _evaluateIdle(TelemetryTick tick) {
    final baseline = _typicalIdleMin[tick.operatorId] ?? 6;
    final excess = tick.idleMin - baseline;
    if (excess < 8) return;
    final fuelSaved = excess * 0.035;
    _record(
      BehaviourInsight(
        category: BehaviourCategory.excessIdle,
        priority: InsightPriority.coaching,
        title: 'Excess idle detected',
        whatHappened:
            '${tick.idleMin.toStringAsFixed(0)} idle min is '
            '${excess.toStringAsFixed(0)} min above your baseline.',
        likelyReason: 'Waiting-zone congestion or a task coordination delay.',
        recommendedAction:
            'Use standby during waits and confirm the next hand-off early.',
        impact: 'Up to ${fuelSaved.toStringAsFixed(1)} L fuel recoverable.',
        detectedAt: tick.timestamp,
      ),
    );
  }

  void _evaluateSeatbelt(TelemetryTick tick) {
    if (!tick.isMoving || tick.seatbelt) return;
    _record(
      BehaviourInsight(
        category: BehaviourCategory.beltBeforeMovement,
        priority: InsightPriority.action,
        title: 'Movement before belt confirmation',
        whatHappened: 'Machine movement was detected with the belt unfastened.',
        likelyReason: 'Movement began before restraint confirmation.',
        recommendedAction: 'Stop safely, fasten the belt, then resume travel.',
        impact: 'Removes a preventable high-severity exposure.',
        detectedAt: tick.timestamp,
      ),
    );
  }

  void _evaluateOverload(TelemetryTick tick) {
    final overloaded =
        tick.mode == MachineMode.lift && tick.loadPct > tick.safeLoadLimit;
    _overloadStreak = overloaded ? _overloadStreak + 1 : 0;
    if (_overloadStreak < 2) return;
    final excess = tick.loadPct - tick.safeLoadLimit;
    _record(
      BehaviourInsight(
        category: BehaviourCategory.repeatedOverload,
        priority: InsightPriority.action,
        title: 'Repeated lift overload',
        whatHappened:
            'Load remained ${excess.toStringAsFixed(0)}% above the safe limit.',
        likelyReason: 'Lift demand exceeds the configured safe load limit.',
        recommendedAction:
            'Lower the load, reduce the pick, and verify the lift plan.',
        impact: 'Reduces stability loss and hydraulic stress.',
        detectedAt: tick.timestamp,
      ),
    );
  }

  void _evaluateFuel(TelemetryTick tick) {
    if (tick.loadCycles < 3) return;
    final fuelPerCycle = tick.fuelUsedL / tick.loadCycles;
    final baseline = _fuelPerCycleBaseline[tick.mode]!;
    if (fuelPerCycle < baseline * 1.25) return;
    final above = (fuelPerCycle / baseline - 1) * 100;
    _record(
      BehaviourInsight(
        category: BehaviourCategory.highFuelPerCycle,
        priority: InsightPriority.coaching,
        title: 'Fuel per cycle above normal',
        whatHappened:
            '${fuelPerCycle.toStringAsFixed(2)} L/cycle is '
            '${above.toStringAsFixed(0)}% above the task baseline.',
        likelyReason: 'Longer cycles, high load, or avoidable idle time.',
        recommendedAction:
            'Smooth the cycle path and avoid high-RPM waiting between passes.',
        impact: 'Improves fuel efficiency without changing the task target.',
        detectedAt: tick.timestamp,
      ),
    );
  }

  void _evaluateSwing(TelemetryTick tick) {
    final previous = _previous;
    if (previous == null) return;
    final reversed =
        (previous.swingDir == SwingDirection.left &&
            tick.swingDir == SwingDirection.right) ||
        (previous.swingDir == SwingDirection.right &&
            tick.swingDir == SwingDirection.left);
    final elapsed = tick.timestamp.difference(previous.timestamp).abs();
    final rapid =
        reversed &&
        elapsed <= const Duration(minutes: 1) &&
        previous.swingAngle.abs() >= 15 &&
        tick.swingAngle.abs() >= 15;
    _rapidReversals = rapid ? _rapidReversals + 1 : 0;
    if (_rapidReversals < 2) return;
    _record(
      BehaviourInsight(
        category: BehaviourCategory.harshSwingReversal,
        priority: InsightPriority.coaching,
        title: 'Harsh swing reversals',
        whatHappened: 'Multiple rapid swing direction changes were detected.',
        likelyReason: 'The approach path may require repeated corrections.',
        recommendedAction:
            'Use a smoother arc and settle the upper structure before reversal.',
        impact: 'Reduces component stress and improves cycle consistency.',
        detectedAt: tick.timestamp,
      ),
    );
  }

  void _record(BehaviourInsight insight) {
    _insights[insight.category] = insight;
  }
}
