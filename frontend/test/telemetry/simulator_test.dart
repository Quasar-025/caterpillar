import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/telemetry/machine_mode.dart';
import 'package:frontend/telemetry/scenario_loader.dart';
import 'package:frontend/telemetry/simulator.dart';
import 'package:frontend/telemetry/tick.dart';

const _scenarioJson = '''
{
  "machine": "EXC001",
  "operator": "OP001",
  "timeline": [
    {"t": "08:00", "mode": "DIG", "task": "T1"},
    {"t": "09:45", "mode": "LIFT", "task": "T2"},
    {"t": "10:20", "mode": "DIG", "task": "T3"}
  ],
  "events": [
    {"t": "09:10", "set": {"rain": 1, "ground_softness": 0.7}},
    {"t": "09:55", "worker_path": "approach_swing_zone"}
  ]
}
''';

void main() {
  test('scenario duration is relative to the first timeline entry', () {
    final scenario = ScenarioLoader.fromString(_scenarioJson);

    expect(scenario.totalDuration, const Duration(hours: 2, minutes: 30));
  });

  test('scenario rejects an empty timeline', () {
    expect(
      () => ScenarioLoader.fromString(
        '{"machine":"EXC001","operator":"OP001","timeline":[]}',
      ),
      throwsFormatException,
    );
  });

  test('emits initial tick and deterministic mode transitions', () async {
    final simulator = TelemetrySimulator(random: Random(7));
    addTearDown(simulator.dispose);
    final ticks = <TelemetryTick>[];
    final subscription = simulator.tickStream.listen(ticks.add);
    addTearDown(subscription.cancel);

    simulator.start(
      ScenarioLoader.fromString(_scenarioJson),
      autoplay: false,
    );
    await pumpEventQueue();

    expect(ticks, hasLength(1));
    expect(ticks.last.taskId, 'T1');
    expect(ticks.last.mode, MachineMode.dig);
    expect(ticks.last.progressPct, 0);

    simulator.advanceBy(const Duration(hours: 1, minutes: 45));
    await pumpEventQueue();

    expect(ticks.last.taskId, 'T2');
    expect(ticks.last.mode, MachineMode.lift);
    expect(ticks.last.progressPct, 0);
    expect(ticks.last.rain, 1);
    expect(ticks.last.groundSoftness, 0.7);
  });

  test('worker path approaches the swing zone', () async {
    final simulator = TelemetrySimulator(random: Random(11));
    addTearDown(simulator.dispose);
    final ticks = <TelemetryTick>[];
    final subscription = simulator.tickStream.listen(ticks.add);
    addTearDown(subscription.cancel);
    simulator.start(
      ScenarioLoader.fromString(_scenarioJson),
      autoplay: false,
    );

    simulator.advanceBy(const Duration(hours: 1, minutes: 55));
    simulator.advanceBy(const Duration(seconds: 20));
    await pumpEventQueue();

    expect(ticks.last.nearestPersonM, lessThan(15));
    expect(ticks.last.nearestPersonM, greaterThan(2.5));
  });

  test('stops after the scenario tail', () async {
    final simulator = TelemetrySimulator(random: Random(3));
    addTearDown(simulator.dispose);
    simulator.start(
      ScenarioLoader.fromString(_scenarioJson),
      autoplay: false,
    );

    simulator.advanceBy(const Duration(hours: 2, minutes: 30));
    expect(simulator.state, SimulatorState.running);

    simulator.advanceBy(const Duration(seconds: 1));
    expect(simulator.state, SimulatorState.idle);
  });

  test('rejects unsupported time scales in release and debug modes', () {
    final simulator = TelemetrySimulator();
    addTearDown(simulator.dispose);

    expect(() => simulator.setTimeScale(30), throwsArgumentError);
  });
}
