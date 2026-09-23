import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../telemetry/simulator_providers.dart';
import '../telemetry/tick.dart';
import 'eta_live.dart';
import 'shift_recovery.dart';

// ── Backend config ──────────────────────────────────────────────────────────

/// Base URL for the backend API.  Defaults to localhost for dev.
/// Override via the provider if using ngrok or Render.
final etaBaseUrlProvider = Provider<String>((_) => 'http://10.0.2.2:8000');

// ── ETA service (backend HTTP calls) ────────────────────────────────────────

/// Calls POST /eta/predict on the backend.
class EtaService {
  EtaService(this._baseUrl);

  final String _baseUrl;
  final _client = http.Client();

  Future<EtaPrediction?> predict({
    required String taskType,
    required String machineType,
    required double plannedQuantity,
    required String operatorId,
    required double groundSoftness,
    required double rain,
    required double slopeDeg,
    required double avgLoadPct,
    required bool isNight,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/eta/predict'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'task_type': taskType,
              'machine_type': machineType,
              'planned_quantity': plannedQuantity,
              'operator_id': operatorId,
              'ground_softness': groundSoftness,
              'rain': rain,
              'slope_deg': slopeDeg,
              'avg_load_pct': avgLoadPct,
              'is_night': isNight,
            }),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return EtaPrediction(
        predictedDurationMin:
            (json['predicted_duration_min'] as num).toDouble(),
        contributions: (json['contributions'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
        baselineDurationMin:
            (json['baseline_duration_min'] as num).toDouble(),
      );
    } catch (_) {
      // Backend unreachable — fall back to pace-only
      return null;
    }
  }

  void dispose() => _client.close();
}

class EtaPrediction {
  const EtaPrediction({
    required this.predictedDurationMin,
    required this.contributions,
    required this.baselineDurationMin,
  });

  final double predictedDurationMin;
  final Map<String, double> contributions;
  final double baselineDurationMin;
}

// ── Providers ───────────────────────────────────────────────────────────────

final etaServiceProvider = Provider<EtaService>((ref) {
  final baseUrl = ref.watch(etaBaseUrlProvider);
  final service = EtaService(baseUrl);
  ref.onDispose(service.dispose);
  return service;
});

final etaLiveEngineProvider = Provider<EtaLiveEngine>((ref) {
  return EtaLiveEngine();
});

final shiftRecoveryEngineProvider = Provider<ShiftRecoveryEngine>((ref) {
  return const ShiftRecoveryEngine();
});

/// Operator baselines embedded from data/operator_baselines.csv.
/// {operator_id: {task_type: median_cycle_time_sec}}
const _operatorBaselines = <String, Map<String, double>>{
  'OP001': {'DIG': 25.87, 'LIFT': 60.02, 'LOAD': 31.04, 'GRADE': 43.46},
  'OP002': {'DIG': 22.91, 'LIFT': 53.13, 'LOAD': 27.46, 'GRADE': 38.45},
  'OP003': {'DIG': 26.46, 'LIFT': 61.38, 'LOAD': 31.74, 'GRADE': 44.44},
  'OP004': {'DIG': 23.70, 'LIFT': 54.96, 'LOAD': 28.40, 'GRADE': 39.78},
  'OP005': {'DIG': 27.54, 'LIFT': 63.88, 'LOAD': 33.04, 'GRADE': 46.26},
  'OP006': {'DIG': 24.52, 'LIFT': 56.87, 'LOAD': 29.38, 'GRADE': 41.13},
  'OP007': {'DIG': 28.39, 'LIFT': 65.84, 'LOAD': 34.07, 'GRADE': 47.70},
  'OP008': {'DIG': 21.93, 'LIFT': 50.86, 'LOAD': 26.30, 'GRADE': 36.82},
};

double _getBaselineCycle(String operatorId, String modeLabel) {
  return _operatorBaselines[operatorId]?[modeLabel] ?? 30.0;
}

/// Live ETA state, updated on every telemetry tick.
///
/// Calls the backend once per task to cache the model prediction,
/// then blends locally on every tick.
final etaStateProvider = StreamProvider<EtaState>((ref) {
  final engine = ref.watch(etaLiveEngineProvider);
  final service = ref.watch(etaServiceProvider);
  final sim = ref.watch(simulatorProvider);
  final controller = StreamController<EtaState>();

  String? lastTaskId;

  final sub = sim.tickStream.listen((tick) async {
    final modeLabel = tick.mode.label;
    final baselineCycle = _getBaselineCycle(tick.operatorId, modeLabel);

    // Call backend once per new task
    if (tick.taskId != lastTaskId) {
      lastTaskId = tick.taskId;
      engine.reset();

      // Fire and forget — don't block the tick stream
      _fetchAndCache(
        service: service,
        engine: engine,
        tick: tick,
        baselineCycle: baselineCycle,
      );
    }

    // Planned quantity heuristic: infer from progress and cycles
    // In a real app this would come from the task database
    final plannedQty = tick.progressPct > 0
        ? (tick.loadCycles / (tick.progressPct / 100.0)).roundToDouble()
        : 100.0;

    final state = engine.evaluate(
      tick,
      baselineCycleTimeSec: baselineCycle,
      plannedQuantity: plannedQty,
    );

    controller.add(state);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});

Future<void> _fetchAndCache({
  required EtaService service,
  required EtaLiveEngine engine,
  required TelemetryTick tick,
  required double baselineCycle,
}) async {
  // Determine machine type from machine ID prefix
  String machineType;
  if (tick.machineId.startsWith('EXC')) {
    machineType = 'EXCAVATOR';
  } else if (tick.machineId.startsWith('LOD')) {
    machineType = 'LOADER';
  } else {
    machineType = 'DOZER';
  }

  final prediction = await service.predict(
    taskType: tick.mode.label,
    machineType: machineType,
    plannedQuantity: 200, // default for demo
    operatorId: tick.operatorId,
    groundSoftness: tick.groundSoftness,
    rain: tick.rain,
    slopeDeg: tick.slopeDeg,
    avgLoadPct: tick.loadPct,
    isNight: tick.isNight,
  );

  if (prediction != null) {
    engine.cacheModelPrediction(
      taskId: tick.taskId,
      predictedDurationMin: prediction.predictedDurationMin,
      contributions: prediction.contributions,
      groundSoftness: tick.groundSoftness,
      rain: tick.rain,
      cycleTimeSec: tick.cycleTimeSec,
    );
  }
}

/// Shift recovery state, recomputed from ETA and shift schedule.
final shiftRecoveryProvider = Provider<ShiftRecoveryState?>((ref) {
  final eta = ref.watch(etaStateProvider).valueOrNull;
  final tick = ref.watch(telemetryTickProvider).valueOrNull;
  if (eta == null || tick == null) return null;

  final engine = ref.watch(shiftRecoveryEngineProvider);
  final baselineCycle = _getBaselineCycle(tick.operatorId, tick.mode.label);

  // For the demo, assume a 10-hour shift with 3 tasks of ~40 min each remaining
  // In production this would come from the shift/task database
  return engine.evaluate(
    baselineCycleSec: baselineCycle,
    rollingCycleSec: tick.rollingCycleTimeSec,
    remainingTasksMin: [
      eta.etaRemainingMin,  // current task
      40.0,                 // next task estimate
      40.0,                 // task after that
    ],
    scheduledShiftEndMin: 120.0, // 2 hours until shift end (demo)
    excessIdleMin: tick.idleMin > 10 ? tick.idleMin - 10 : 0,
  );
});
