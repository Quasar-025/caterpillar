import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/alert_level.dart';
import 'package:frontend/safety/risk_engine.dart';
import 'package:frontend/safety/risk_state.dart';
import 'package:frontend/safety/risk_worker.dart';
import 'package:frontend/telemetry/machine_mode.dart';
import 'package:frontend/telemetry/swing_direction.dart';
import 'package:frontend/telemetry/tick.dart';

TelemetryTick tick({
  DateTime? timestamp,
  MachineMode mode = MachineMode.dig,
  bool seatbelt = true,
  bool isMoving = false,
  double speed = 0,
  double nearestPersonM = 40,
  double personBearingDeg = 180,
  SwingDirection swingDir = SwingDirection.center,
  double loadPct = 40,
  double safeLoadLimit = 90,
  double slopeDeg = 3,
  double stabilityIdx = 0.8,
  double rain = 0,
  double visibility = 100,
  bool isNight = false,
  double corrections = 2.69,
  double reactionMs = 420.1,
  double idleMin = 2,
}) {
  final at = timestamp ?? DateTime.parse('2025-05-01T08:00:00Z');
  return TelemetryTick(
    timestamp: at,
    machineId: 'EXC001',
    operatorId: 'OP001',
    engineHours: 500,
    fuelUsedL: 2,
    loadCycles: 4,
    idleMin: idleMin,
    seatbelt: seatbelt,
    safetyAlert: 'NONE',
    taskId: 'T1',
    mode: mode,
    progressPct: 25,
    cycleTimeSec: 25,
    rollingCycleTimeSec: 24,
    speed: speed,
    isMoving: isMoving,
    swingAngle: 30,
    swingDir: swingDir,
    loadPct: loadPct,
    safeLoadLimit: safeLoadLimit,
    slopeDeg: slopeDeg,
    stabilityIdx: stabilityIdx,
    nearestPersonM: nearestPersonM,
    personBearingDeg: personBearingDeg,
    rain: rain,
    visibility: visibility,
    isNight: isNight,
    groundSoftness: 0.2,
    fuelPct: 80,
    hydraulicPressure: 32000,
    controlCorrectionsPerMin: corrections,
    reactionMs: reactionMs,
    t0: DateTime.now(),
  );
}

void main() {
  group('RiskEngine', () {
    test('returns info when no hazard is present', () {
      final state = RiskEngine().evaluate(tick());

      expect(state.level, AlertLevel.info);
      expect(state.primaryHazard, isNull);
      expect(state.zones.attentionRadiusM, 20);
      expect(state.zones.actionRadiusM, 10);
    });

    test('expands proximity zones in restricted conditions', () {
      final state = RiskEngine().evaluate(
        tick(rain: 1, visibility: 40, nearestPersonM: 25),
      );

      expect(state.zones.attentionRadiusM, 30);
      expect(state.zones.actionRadiusM, 15);
      expect(state.level, AlertLevel.attention);
      expect(state.primaryHazard, HazardType.proximity);
    });

    test('escalates proximity from attention to action to critical', () {
      final engine = RiskEngine();

      expect(
        engine.evaluate(tick(nearestPersonM: 18)).level,
        AlertLevel.attention,
      );
      expect(engine.evaluate(tick(nearestPersonM: 9)).level, AlertLevel.action);
      final critical = engine.evaluate(
        tick(
          nearestPersonM: 7,
          personBearingDeg: 90,
          swingDir: SwingDirection.right,
        ),
      );
      expect(critical.level, AlertLevel.critical);
      expect(critical.action, 'Pause swing');
    });

    test('escalates a sustained approach before the action radius', () {
      final engine = RiskEngine();
      final start = DateTime.parse('2025-05-01T08:00:00Z');
      engine.evaluate(tick(timestamp: start, nearestPersonM: 28));
      engine.evaluate(
        tick(
          timestamp: start.add(const Duration(seconds: 1)),
          nearestPersonM: 26,
        ),
      );
      final state = engine.evaluate(
        tick(
          timestamp: start.add(const Duration(seconds: 6)),
          nearestPersonM: 24,
        ),
      );

      expect(state.level, AlertLevel.action);
      expect(state.primaryHazard, HazardType.proximity);
    });

    test('escalates an unfastened belt when persistent or moving', () {
      final engine = RiskEngine();
      final start = DateTime.parse('2025-05-01T08:00:00Z');

      expect(
        engine.evaluate(tick(timestamp: start, seatbelt: false)).level,
        AlertLevel.attention,
      );
      expect(
        engine
            .evaluate(
              tick(
                timestamp: start.add(const Duration(seconds: 11)),
                seatbelt: false,
              ),
            )
            .level,
        AlertLevel.action,
      );
      expect(
        engine
            .evaluate(
              tick(
                timestamp: start.add(const Duration(seconds: 12)),
                seatbelt: false,
                isMoving: true,
                speed: 2,
              ),
            )
            .level,
        AlertLevel.critical,
      );
    });

    test('only evaluates overload ladder while lifting', () {
      final engine = RiskEngine();

      expect(
        engine.evaluate(tick(mode: MachineMode.dig, loadPct: 95)).level,
        AlertLevel.info,
      );
      final state = engine.evaluate(
        tick(
          mode: MachineMode.lift,
          loadPct: 95,
          swingDir: SwingDirection.right,
        ),
      );
      expect(state.level, AlertLevel.critical);
      expect(state.primaryHazard, HazardType.load);
    });

    test('low stability while loaded is critical', () {
      final state = RiskEngine().evaluate(
        tick(stabilityIdx: 0.25, loadPct: 50),
      );

      expect(state.level, AlertLevel.critical);
      expect(state.primaryHazard, HazardType.stability);
    });
  });

  test('worker evaluates sequential ticks in its long-lived isolate', () async {
    final worker = await RiskEngineWorker.start();
    addTearDown(worker.close);
    final start = DateTime.parse('2025-05-01T08:00:00Z');

    final attention = await worker.evaluate(
      tick(timestamp: start, seatbelt: false),
    );
    final action = await worker.evaluate(
      tick(timestamp: start.add(const Duration(seconds: 11)), seatbelt: false),
    );

    expect(attention.level, AlertLevel.attention);
    expect(action.level, AlertLevel.action);
  });
}
