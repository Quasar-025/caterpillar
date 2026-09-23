import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'alert_manager.dart';
import 'latency_probe.dart';
import 'safety_providers.dart';

/// Singleton [AlertManager] instance.
final alertManagerProvider = Provider<AlertManager>((ref) {
  final manager = AlertManager();
  ref.onDispose(() => manager.dispose());
  return manager;
});

/// Singleton [LatencyProbe] instance.
final latencyProbeProvider = Provider<LatencyProbe>((ref) {
  return LatencyProbe();
});

/// Wires [RiskState] and [WorkloadState] into the [AlertManager] and
/// exposes the resulting [AlertManagerState] as a stream.
///
/// This provider starts listening as soon as any widget reads it, ensuring
/// the safety pipeline runs even before the alert overlay is visible.
final alertStateProvider = StreamProvider<AlertManagerState>((ref) {
  final manager = ref.watch(alertManagerProvider);
  final controller = StreamController<AlertManagerState>();

  // Forward RiskState → AlertManager.
  final riskSub = ref.listen(riskStateProvider, (_, next) {
    next.whenData((state) {
      manager.processRiskState(state);
    });
  });

  // Forward WorkloadState → AlertManager.
  final workloadSub = ref.listen(workloadStateProvider, (_, next) {
    next.whenData((state) {
      manager.processWorkloadState(state);
    });
  });

  // Forward AlertManager emissions into the returned stream.
  final managerSub = manager.stream.listen(controller.add);

  ref.onDispose(() {
    riskSub.close();
    workloadSub.close();
    managerSub.cancel();
    controller.close();
  });

  return controller.stream;
});

/// Whether a Critical alert is awaiting acknowledgement.
final criticalPendingProvider = Provider<bool>((ref) {
  final state = ref.watch(alertStateProvider).valueOrNull;
  return state?.criticalPending ?? false;
});
