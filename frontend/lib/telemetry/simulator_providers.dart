import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'machine_mode.dart';
import 'simulator.dart';
import 'tick.dart';

/// The [TelemetrySimulator] singleton — lives for the app lifetime.
///
/// All downstream providers watch this instance's streams.
final simulatorProvider = Provider<TelemetrySimulator>((ref) {
  final sim = TelemetrySimulator();
  ref.onDispose(sim.dispose);
  return sim;
});

/// The latest [TelemetryTick], broadcast to all consumers.
///
/// This is the **TelemetryStream / Bus** from the architecture diagram
/// (plan §4). Every downstream consumer (`RiskEngine`, `WorkloadEngine`,
/// `Radar`, `TaskAware UI`, `UnusualBehaviour`, `Live ETA`) watches this.
final telemetryTickProvider = StreamProvider<TelemetryTick>((ref) {
  return ref.watch(simulatorProvider).tickStream;
});

/// Current [MachineMode] derived from the latest tick.
///
/// Returns `null` when no tick has been received yet.
final machineModeProvider = Provider<MachineMode?>((ref) {
  return ref.watch(telemetryTickProvider).whenOrNull(data: (tick) => tick.mode);
});

/// Current time-scale factor (1.0, 10.0, or 60.0).
final timeScaleProvider = StateProvider<double>((ref) => 1.0);

/// Current [SimulatorState] (idle / running / paused).
final simStateProvider = StreamProvider<SimulatorState>((ref) {
  return ref.watch(simulatorProvider).stateStream;
});
