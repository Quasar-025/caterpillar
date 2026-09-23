import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../telemetry/simulator_providers.dart';
import 'risk_state.dart';
import 'risk_worker.dart';
import 'workload_engine.dart';

final riskEngineWorkerProvider = FutureProvider<RiskEngineWorker>((ref) async {
  final worker = await RiskEngineWorker.start();
  ref.onDispose(() => unawaited(worker.close()));
  return worker;
});

/// Operational risk evaluated in a long-lived background isolate.
final riskStateProvider = StreamProvider<RiskState>((ref) async* {
  final worker = await ref.watch(riskEngineWorkerProvider.future);
  final ticks = ref.watch(simulatorProvider).tickStream;
  await for (final tick in ticks) {
    yield await worker.evaluate(tick);
  }
});

final workloadEngineProvider = Provider<WorkloadEngine>((ref) {
  return WorkloadEngine();
});

/// Operator workload remains separate from operational risk.
final workloadStateProvider = StreamProvider<WorkloadState>((ref) async* {
  final engine = ref.watch(workloadEngineProvider);
  final ticks = ref.watch(simulatorProvider).tickStream;
  await for (final tick in ticks) {
    yield engine.evaluate(tick);
  }
});
