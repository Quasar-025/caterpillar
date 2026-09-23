import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/alert_level.dart';
import 'package:frontend/safety/alert_manager.dart';
import 'package:frontend/safety/risk_state.dart';
import 'package:frontend/safety/workload_engine.dart';

class _Clock {
  DateTime now = DateTime.parse('2025-05-01T08:00:00Z');

  void add(Duration duration) => now = now.add(duration);
}

RiskState risk({
  AlertLevel level = AlertLevel.info,
  HazardType? hazard,
  String action = 'Continue operation',
  List<String> reasons = const [],
}) {
  final at = DateTime.parse('2025-05-01T08:00:00Z');
  return RiskState(
    level: level,
    primaryHazard: hazard,
    action: action,
    reasons: reasons,
    zones: const RiskZones(
      attentionRadiusM: 20,
      actionRadiusM: 10,
      swingRadiusM: 8,
    ),
    tickCreatedAt: at,
    evaluatedAt: at,
  );
}

void main() {
  late _Clock clock;
  late List<AlertLevel> cues;
  late AlertManager manager;

  setUp(() {
    clock = _Clock();
    cues = [];
    manager = AlertManager(clock: () => clock.now, onCue: cues.add);
  });

  tearDown(() => manager.dispose());

  AlertManagerState last() => manager.snapshot;

  test('info states never push a cue or an active alert', () {
    manager.processRiskState(risk());

    expect(last().activeAlerts, isEmpty);
    expect(last().overallLevel, AlertLevel.info);
    expect(cues, isEmpty);
  });

  test('dedupes by hazard key', () {
    manager.processRiskState(
      risk(
        level: AlertLevel.attention,
        hazard: HazardType.proximity,
        action: 'Monitor worker',
      ),
    );
    manager.processRiskState(
      risk(
        level: AlertLevel.attention,
        hazard: HazardType.proximity,
        action: 'Monitor worker',
      ),
    );

    expect(last().activeAlerts, hasLength(1));
    expect(cues, [AlertLevel.attention]);
  });

  test('holds the previous level for two seconds of hysteresis', () {
    manager.processRiskState(
      risk(
        level: AlertLevel.action,
        hazard: HazardType.proximity,
        action: 'Slow movement',
      ),
    );
    manager.processRiskState(risk());
    expect(last().overallLevel, AlertLevel.action);
    expect(last().activeAlerts, hasLength(1));

    clock.add(const Duration(seconds: 1));
    manager.processRiskState(risk());
    expect(last().overallLevel, AlertLevel.action);

    clock.add(const Duration(seconds: 1));
    manager.processRiskState(risk());
    expect(last().activeAlerts, isEmpty);
    expect(last().overallLevel, AlertLevel.info);
  });

  test(
    'rate-limits attention and action cues but still updates the banner',
    () {
      manager.processRiskState(
        risk(
          level: AlertLevel.attention,
          hazard: HazardType.proximity,
          action: 'Watch worker',
        ),
      );
      clock.add(const Duration(seconds: 5));
      manager.processRiskState(
        risk(
          level: AlertLevel.action,
          hazard: HazardType.proximity,
          action: 'Slow movement',
        ),
      );

      expect(last().overallLevel, AlertLevel.action);
      expect(last().activeAlerts.single.action, 'Slow movement');
      expect(cues, [AlertLevel.attention]);
    },
  );

  test('critical requires acknowledgement and is not rate limited', () {
    manager.processRiskState(
      risk(
        level: AlertLevel.critical,
        hazard: HazardType.seatbelt,
        action: 'Stop safely and fasten seatbelt',
      ),
    );
    clock.add(const Duration(seconds: 1));
    manager.processRiskState(
      risk(
        level: AlertLevel.critical,
        hazard: HazardType.seatbelt,
        action: 'Stop safely and fasten seatbelt',
      ),
    );

    expect(last().criticalPending, isTrue);
    expect(cues, [AlertLevel.critical, AlertLevel.critical]);

    manager.acknowledgeCritical();
    expect(last().criticalPending, isFalse);
    expect(last().activeAlerts.single.acknowledged, isTrue);
  });

  test('cools down a hazard that is no longer primary', () {
    manager.processRiskState(
      risk(
        level: AlertLevel.attention,
        hazard: HazardType.proximity,
        action: 'Monitor worker',
      ),
    );
    manager.processRiskState(
      risk(
        level: AlertLevel.action,
        hazard: HazardType.seatbelt,
        action: 'Fasten seatbelt',
      ),
    );
    expect(last().activeAlerts.map((alert) => alert.id).toSet(), {
      'proximity',
      'seatbelt',
    });

    clock.add(const Duration(seconds: 2));
    manager.processRiskState(
      risk(
        level: AlertLevel.action,
        hazard: HazardType.seatbelt,
        action: 'Fasten seatbelt',
      ),
    );
    expect(last().activeAlerts.map((alert) => alert.id), ['seatbelt']);
  });

  test('keeps workload messaging separate from operational risk', () {
    manager.processWorkloadState(
      WorkloadState(
        level: WorkloadLevel.high,
        continuousOperatingTime: const Duration(hours: 3),
        reasons: const ['Control corrections are 23% above baseline'],
        breakRecommended: true,
        evaluatedAt: clock.now,
      ),
    );

    expect(last().overallLevel, AlertLevel.info);
    expect(last().criticalPending, isFalse);
    expect(last().workloadMessage, contains('OPERATOR WORKLOAD: HIGH'));
    expect(cues, isEmpty);
  });
}
