import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../telemetry/simulator_providers.dart';
import 'unusual_behaviour.dart';

final unusualBehaviourEngineProvider = Provider<UnusualBehaviourEngine>((ref) {
  return UnusualBehaviourEngine();
});

final unusualInsightsProvider =
    StreamProvider<List<BehaviourInsight>>((ref) {
  final engine = ref.watch(unusualBehaviourEngineProvider);
  final simulator = ref.watch(simulatorProvider);
  final controller = StreamController<List<BehaviourInsight>>();

  controller.add(engine.insights);
  final subscription = simulator.tickStream.listen((tick) {
    controller.add(engine.evaluate(tick));
  });

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });
  return controller.stream;
});
