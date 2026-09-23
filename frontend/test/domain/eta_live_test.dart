import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/domain/eta_live.dart';
import 'package:frontend/telemetry/machine_mode.dart';
import 'package:frontend/telemetry/swing_direction.dart';
import 'package:frontend/telemetry/tick.dart';

TelemetryTick _etaTick({double progress = 50, double rollingCycle = 30}) {
  return TelemetryTick(
    timestamp: DateTime(2026, 9, 24, 8),
    machineId: 'EXC001',
    operatorId: 'OP001',
    engineHours: 1530,
    fuelUsedL: 2,
    loadCycles: 5,
    idleMin: 1,
    seatbelt: true,
    safetyAlert: 'NONE',
    taskId: 'T1',
    mode: MachineMode.dig,
    progressPct: progress,
    cycleTimeSec: rollingCycle,
    rollingCycleTimeSec: rollingCycle,
    speed: 1,
    isMoving: true,
    swingAngle: 0,
    swingDir: SwingDirection.center,
    loadPct: 45,
    safeLoadLimit: 90,
    slopeDeg: 2,
    stabilityIdx: 0.9,
    nearestPersonM: 30,
    personBearingDeg: 180,
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
  test('ETA never becomes negative or non-finite', () {
    final engine = EtaLiveEngine()
      ..cacheModelPrediction(
        taskId: 'T1',
        predictedDurationMin: -40,
        contributions: const {},
        groundSoftness: 0.2,
        rain: 0,
        cycleTimeSec: 20,
      );

    final state = engine.evaluate(
      _etaTick(progress: 120, rollingCycle: -10),
      baselineCycleTimeSec: 25,
      plannedQuantity: -50,
    );

    expect(state.etaRemainingMin, greaterThanOrEqualTo(0));
    expect(state.etaRemainingMin.isFinite, isTrue);
  });

  test('ETA explanation uses words instead of a negative display', () {
    final engine = EtaLiveEngine()
      ..cacheModelPrediction(
        taskId: 'T1',
        predictedDurationMin: 30,
        contributions: const {},
        groundSoftness: 0.2,
        rain: 0,
        cycleTimeSec: 20,
      );

    final state = engine.evaluate(
      _etaTick(rollingCycle: 30),
      baselineCycleTimeSec: 20,
      plannedQuantity: 10,
    );

    expect(state.explanation, isNotNull);
    expect(state.explanation, isNot(contains('ETA -')));
    expect(
      state.explanation,
      anyOf(contains('improved by'), contains('increased by')),
    );
  });
}
