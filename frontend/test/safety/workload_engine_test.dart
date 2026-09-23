import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/safety/workload_engine.dart';
import 'package:frontend/telemetry/machine_mode.dart';
import 'package:frontend/telemetry/swing_direction.dart';
import 'package:frontend/telemetry/tick.dart';

TelemetryTick workloadTick({
  required DateTime timestamp,
  bool isMoving = true,
  double corrections = 2.69,
  double reactionMs = 420.1,
  double idleMin = 2,
}) {
  return TelemetryTick(
    timestamp: timestamp,
    machineId: 'EXC001',
    operatorId: 'OP001',
    engineHours: 500,
    fuelUsedL: 2,
    loadCycles: 4,
    idleMin: idleMin,
    seatbelt: true,
    safetyAlert: 'NONE',
    taskId: 'T1',
    mode: MachineMode.dig,
    progressPct: 25,
    cycleTimeSec: 25,
    rollingCycleTimeSec: 24,
    speed: isMoving ? 2 : 0,
    isMoving: isMoving,
    swingAngle: 0,
    swingDir: SwingDirection.center,
    loadPct: 40,
    safeLoadLimit: 90,
    slopeDeg: 3,
    stabilityIdx: 0.8,
    nearestPersonM: 40,
    personBearingDeg: 180,
    rain: 0,
    visibility: 100,
    isNight: false,
    groundSoftness: 0.2,
    fuelPct: 80,
    hydraulicPressure: 32000,
    controlCorrectionsPerMin: corrections,
    reactionMs: reactionMs,
    t0: DateTime.now(),
  );
}

void main() {
  test('normal activity stays at normal workload', () {
    final at = DateTime.parse('2025-05-01T08:00:00Z');
    final state = WorkloadEngine().evaluate(workloadTick(timestamp: at));

    expect(state.level, WorkloadLevel.normal);
    expect(state.breakRecommended, isFalse);
    expect(state.reasons, isEmpty);
  });

  test('continuous operation and corrections produce high workload', () {
    final engine = WorkloadEngine();
    final start = DateTime.parse('2025-05-01T08:00:00Z');
    engine.evaluate(workloadTick(timestamp: start));

    final high = engine.evaluate(
      workloadTick(
        timestamp: start.add(const Duration(hours: 2, minutes: 46)),
        corrections: 3.35,
      ),
    );
    expect(high.level, WorkloadLevel.high);
    expect(high.breakRecommended, isFalse);
    expect(high.reasons.first, contains('2h 46m'));

    final stopped = engine.evaluate(
      workloadTick(
        timestamp: start.add(const Duration(hours: 2, minutes: 46, seconds: 1)),
        isMoving: false,
        corrections: 3.35,
      ),
    );
    expect(stopped.level, WorkloadLevel.high);
    expect(stopped.breakRecommended, isTrue);
  });

  test('five-minute stop resets continuous operating time', () {
    final engine = WorkloadEngine();
    final start = DateTime.parse('2025-05-01T08:00:00Z');
    engine.evaluate(workloadTick(timestamp: start));
    engine.evaluate(
      workloadTick(
        timestamp: start.add(const Duration(hours: 1)),
        isMoving: false,
      ),
    );
    engine.evaluate(
      workloadTick(
        timestamp: start.add(const Duration(hours: 1, minutes: 5)),
        isMoving: false,
      ),
    );
    final resumed = engine.evaluate(
      workloadTick(timestamp: start.add(const Duration(hours: 1, minutes: 6))),
    );

    expect(resumed.continuousOperatingTime, Duration.zero);
    expect(resumed.level, WorkloadLevel.normal);
  });

  test('operator-specific baseline avoids a one-size-fits-all score', () {
    final at = DateTime.parse('2025-05-01T08:00:00Z');
    final tick = workloadTick(timestamp: at, corrections: 3.5);

    final op1 = WorkloadEngine().evaluate(
      tick,
      baseline: WorkloadBaseline.forOperator('OP001'),
    );
    final op7 = WorkloadEngine().evaluate(
      tick,
      baseline: WorkloadBaseline.forOperator('OP007'),
    );

    expect(op1.level, WorkloadLevel.elevated);
    expect(op7.level, WorkloadLevel.normal);
  });
}
