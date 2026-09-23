import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/domain/unusual_behaviour.dart';
import 'package:frontend/telemetry/machine_mode.dart';
import 'package:frontend/telemetry/swing_direction.dart';
import 'package:frontend/telemetry/tick.dart';

TelemetryTick _tick({
  int minute = 0,
  MachineMode mode = MachineMode.dig,
  double idleMin = 0,
  bool seatbelt = true,
  bool isMoving = false,
  double loadPct = 45,
  double safeLoadLimit = 90,
  double fuelUsedL = 1,
  int loadCycles = 4,
  SwingDirection swingDir = SwingDirection.center,
  double swingAngle = 0,
}) {
  return TelemetryTick(
    timestamp: DateTime(2026, 9, 23, 8, minute),
    machineId: 'EXC001',
    operatorId: 'OP001',
    engineHours: 1530,
    fuelUsedL: fuelUsedL,
    loadCycles: loadCycles,
    idleMin: idleMin,
    seatbelt: seatbelt,
    safetyAlert: 'NONE',
    taskId: 'T1',
    mode: mode,
    progressPct: 20,
    cycleTimeSec: 28,
    rollingCycleTimeSec: 28,
    speed: isMoving ? 2 : 0,
    isMoving: isMoving,
    swingAngle: swingAngle,
    swingDir: swingDir,
    loadPct: loadPct,
    safeLoadLimit: safeLoadLimit,
    slopeDeg: 2,
    stabilityIdx: 0.9,
    nearestPersonM: 30,
    personBearingDeg: 0,
    rain: 0,
    visibility: 100,
    isNight: false,
    groundSoftness: 0.2,
    fuelPct: 80,
    hydraulicPressure: 32000,
    controlCorrectionsPerMin: 2,
    reactionMs: 400,
    t0: DateTime.now(),
  );
}

void main() {
  test('detects excess idle and calculates recoverable fuel', () {
    final engine = UnusualBehaviourEngine();
    final insights = engine.evaluate(_tick(idleMin: 18));

    final idle = insights.singleWhere(
      (item) => item.category == BehaviourCategory.excessIdle,
    );
    expect(idle.title, 'Excess idle detected');
    expect(idle.impact, contains('0.4 L'));
  });

  test('detects movement before belt confirmation immediately', () {
    final engine = UnusualBehaviourEngine();
    final insights = engine.evaluate(
      _tick(seatbelt: false, isMoving: true),
    );

    expect(
      insights.any(
        (item) => item.category == BehaviourCategory.beltBeforeMovement,
      ),
      isTrue,
    );
  });

  test('requires repeated overload before recommending action', () {
    final engine = UnusualBehaviourEngine();
    engine.evaluate(
      _tick(mode: MachineMode.lift, loadPct: 96, minute: 1),
    );
    expect(engine.insights, isEmpty);

    final insights = engine.evaluate(
      _tick(mode: MachineMode.lift, loadPct: 97, minute: 2),
    );
    expect(
      insights.any(
        (item) => item.category == BehaviourCategory.repeatedOverload,
      ),
      isTrue,
    );
  });

  test('detects high fuel per cycle against task baseline', () {
    final engine = UnusualBehaviourEngine();
    final insights = engine.evaluate(
      _tick(fuelUsedL: 3.2, loadCycles: 4),
    );

    expect(
      insights.any(
        (item) => item.category == BehaviourCategory.highFuelPerCycle,
      ),
      isTrue,
    );
  });

  test('requires multiple rapid swing reversals', () {
    final engine = UnusualBehaviourEngine();
    engine.evaluate(
      _tick(minute: 0, swingDir: SwingDirection.left, swingAngle: -25),
    );
    engine.evaluate(
      _tick(minute: 1, swingDir: SwingDirection.right, swingAngle: 25),
    );
    final insights = engine.evaluate(
      _tick(minute: 2, swingDir: SwingDirection.left, swingAngle: -25),
    );

    expect(
      insights.any(
        (item) => item.category == BehaviourCategory.harshSwingReversal,
      ),
      isTrue,
    );
  });
}
