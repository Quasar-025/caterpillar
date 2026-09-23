import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/alert_level.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/features/radar/safety_radar.dart';
import 'package:frontend/safety/risk_state.dart';
import 'package:frontend/telemetry/machine_mode.dart';
import 'package:frontend/telemetry/swing_direction.dart';
import 'package:frontend/telemetry/tick.dart';

void main() {
  const zones = RiskZones(
    attentionRadiusM: 20,
    actionRadiusM: 10,
    swingRadiusM: 8,
  );

  test('maps 0° bearing to machine-forward (up on screen)', () {
    const center = Offset(100, 100);
    final point = radarPolarToOffset(
      center: center,
      meters: 10,
      bearingDeg: 0,
      metersToPixels: 2,
    );

    expect(point.dx, closeTo(100, 0.001));
    expect(point.dy, closeTo(80, 0.001));
  });

  test('scales rings from RiskState zones only', () {
    final scale = radarMetersToPixels(const Size(200, 200), zones);

    expect(zones.attentionRadiusM * scale, closeTo(76, 0.001));
    expect(
      zones.actionRadiusM * scale,
      lessThan(zones.attentionRadiusM * scale),
    );
    expect(zones.swingRadiusM * scale, lessThan(zones.actionRadiusM * scale));
  });

  testWidgets(
    'paints radar from supplied risk state without computing danger',
    (tester) async {
      final risk = RiskState(
        level: AlertLevel.action,
        primaryHazard: HazardType.proximity,
        action: 'Slow movement and verify the work zone',
        reasons: const ['Worker 9.0 m away'],
        zones: zones,
        tickCreatedAt: DateTime.parse('2025-05-01T08:00:00Z'),
        evaluatedAt: DateTime.parse('2025-05-01T08:00:00Z'),
      );
      final tick = TelemetryTick(
        timestamp: DateTime.parse('2025-05-01T08:00:00Z'),
        machineId: 'EXC001',
        operatorId: 'OP001',
        engineHours: 500,
        fuelUsedL: 1,
        loadCycles: 1,
        idleMin: 0,
        seatbelt: true,
        safetyAlert: 'NONE',
        taskId: 'T1',
        mode: MachineMode.dig,
        progressPct: 20,
        cycleTimeSec: 22,
        rollingCycleTimeSec: 22,
        speed: 0,
        isMoving: false,
        swingAngle: 40,
        swingDir: SwingDirection.right,
        loadPct: 30,
        safeLoadLimit: 90,
        slopeDeg: 2,
        stabilityIdx: 0.8,
        nearestPersonM: 9,
        personBearingDeg: 90,
        rain: 0,
        visibility: 100,
        isNight: false,
        groundSoftness: 0.2,
        fuelPct: 80,
        hydraulicPressure: 30000,
        controlCorrectionsPerMin: 2,
        reactionMs: 400,
        t0: DateTime.parse('2025-05-01T08:00:00Z'),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: CatTheme.dark(),
          home: Scaffold(
            body: SizedBox(
              width: 240,
              height: 240,
              child: SafetyRadar(risk: risk, tick: tick),
            ),
          ),
        ),
      );

      expect(find.byType(SafetyRadar), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    },
  );
}
