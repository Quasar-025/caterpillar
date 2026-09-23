import 'dart:async';
import 'dart:math';

import 'machine_mode.dart';
import 'scenario.dart';
import 'swing_direction.dart';
import 'tick.dart';

// ─── Simulator state ────────────────────────────────────────────────────────

enum SimulatorState { idle, running, paused }

// ─── Operator baselines (from data/operator_baselines.csv) ──────────────────

/// Median cycle time (seconds) per operator × task type.
/// Hardcoded from the 32-row CSV to avoid I/O at runtime.
class _OperatorBaseline {
  const _OperatorBaseline({
    required this.medianCycleTimeSec,
    required this.typicalIdleMin,
    required this.typicalCorrectionsPerMin,
    required this.typicalReactionMs,
  });

  final double medianCycleTimeSec;
  final double typicalIdleMin;
  final double typicalCorrectionsPerMin;
  final double typicalReactionMs;
}

final Map<String, Map<String, _OperatorBaseline>> _baselines = {
  'OP001': {
    'DIG': const _OperatorBaseline(medianCycleTimeSec: 25.87, typicalIdleMin: 5.83, typicalCorrectionsPerMin: 2.69, typicalReactionMs: 420.1),
    'LIFT': const _OperatorBaseline(medianCycleTimeSec: 60.02, typicalIdleMin: 5.83, typicalCorrectionsPerMin: 2.69, typicalReactionMs: 420.1),
    'LOAD': const _OperatorBaseline(medianCycleTimeSec: 31.04, typicalIdleMin: 5.83, typicalCorrectionsPerMin: 2.69, typicalReactionMs: 420.1),
    'GRADE': const _OperatorBaseline(medianCycleTimeSec: 43.46, typicalIdleMin: 5.83, typicalCorrectionsPerMin: 2.69, typicalReactionMs: 420.1),
  },
  'OP002': {
    'DIG': const _OperatorBaseline(medianCycleTimeSec: 22.91, typicalIdleMin: 3.61, typicalCorrectionsPerMin: 2.01, typicalReactionMs: 386.7),
    'LIFT': const _OperatorBaseline(medianCycleTimeSec: 53.13, typicalIdleMin: 3.61, typicalCorrectionsPerMin: 2.01, typicalReactionMs: 386.7),
    'LOAD': const _OperatorBaseline(medianCycleTimeSec: 27.46, typicalIdleMin: 3.61, typicalCorrectionsPerMin: 2.01, typicalReactionMs: 386.7),
    'GRADE': const _OperatorBaseline(medianCycleTimeSec: 38.45, typicalIdleMin: 3.61, typicalCorrectionsPerMin: 2.01, typicalReactionMs: 386.7),
  },
  'OP003': {
    'DIG': const _OperatorBaseline(medianCycleTimeSec: 26.46, typicalIdleMin: 7.93, typicalCorrectionsPerMin: 3.46, typicalReactionMs: 398.3),
    'LIFT': const _OperatorBaseline(medianCycleTimeSec: 61.38, typicalIdleMin: 7.93, typicalCorrectionsPerMin: 3.46, typicalReactionMs: 398.3),
    'LOAD': const _OperatorBaseline(medianCycleTimeSec: 31.74, typicalIdleMin: 7.93, typicalCorrectionsPerMin: 3.46, typicalReactionMs: 398.3),
    'GRADE': const _OperatorBaseline(medianCycleTimeSec: 44.44, typicalIdleMin: 7.93, typicalCorrectionsPerMin: 3.46, typicalReactionMs: 398.3),
  },
  'OP004': {
    'DIG': const _OperatorBaseline(medianCycleTimeSec: 23.70, typicalIdleMin: 4.83, typicalCorrectionsPerMin: 2.43, typicalReactionMs: 445.8),
    'LIFT': const _OperatorBaseline(medianCycleTimeSec: 54.96, typicalIdleMin: 4.83, typicalCorrectionsPerMin: 2.43, typicalReactionMs: 445.8),
    'LOAD': const _OperatorBaseline(medianCycleTimeSec: 28.40, typicalIdleMin: 4.83, typicalCorrectionsPerMin: 2.43, typicalReactionMs: 445.8),
    'GRADE': const _OperatorBaseline(medianCycleTimeSec: 39.78, typicalIdleMin: 4.83, typicalCorrectionsPerMin: 2.43, typicalReactionMs: 445.8),
  },
  'OP005': {
    'DIG': const _OperatorBaseline(medianCycleTimeSec: 27.54, typicalIdleMin: 9.54, typicalCorrectionsPerMin: 3.98, typicalReactionMs: 478.2),
    'LIFT': const _OperatorBaseline(medianCycleTimeSec: 63.88, typicalIdleMin: 9.54, typicalCorrectionsPerMin: 3.98, typicalReactionMs: 478.2),
    'LOAD': const _OperatorBaseline(medianCycleTimeSec: 33.04, typicalIdleMin: 9.54, typicalCorrectionsPerMin: 3.98, typicalReactionMs: 478.2),
    'GRADE': const _OperatorBaseline(medianCycleTimeSec: 46.26, typicalIdleMin: 9.54, typicalCorrectionsPerMin: 3.98, typicalReactionMs: 478.2),
  },
  'OP006': {
    'DIG': const _OperatorBaseline(medianCycleTimeSec: 24.52, typicalIdleMin: 5.20, typicalCorrectionsPerMin: 2.76, typicalReactionMs: 410.5),
    'LIFT': const _OperatorBaseline(medianCycleTimeSec: 56.87, typicalIdleMin: 5.20, typicalCorrectionsPerMin: 2.76, typicalReactionMs: 410.5),
    'LOAD': const _OperatorBaseline(medianCycleTimeSec: 29.38, typicalIdleMin: 5.20, typicalCorrectionsPerMin: 2.76, typicalReactionMs: 410.5),
    'GRADE': const _OperatorBaseline(medianCycleTimeSec: 41.13, typicalIdleMin: 5.20, typicalCorrectionsPerMin: 2.76, typicalReactionMs: 410.5),
  },
  'OP007': {
    'DIG': const _OperatorBaseline(medianCycleTimeSec: 28.39, typicalIdleMin: 11.07, typicalCorrectionsPerMin: 4.21, typicalReactionMs: 512.6),
    'LIFT': const _OperatorBaseline(medianCycleTimeSec: 65.84, typicalIdleMin: 11.07, typicalCorrectionsPerMin: 4.21, typicalReactionMs: 512.6),
    'LOAD': const _OperatorBaseline(medianCycleTimeSec: 34.07, typicalIdleMin: 11.07, typicalCorrectionsPerMin: 4.21, typicalReactionMs: 512.6),
    'GRADE': const _OperatorBaseline(medianCycleTimeSec: 47.70, typicalIdleMin: 11.07, typicalCorrectionsPerMin: 4.21, typicalReactionMs: 512.6),
  },
  'OP008': {
    'DIG': const _OperatorBaseline(medianCycleTimeSec: 21.93, typicalIdleMin: 3.12, typicalCorrectionsPerMin: 1.88, typicalReactionMs: 375.4),
    'LIFT': const _OperatorBaseline(medianCycleTimeSec: 50.86, typicalIdleMin: 3.12, typicalCorrectionsPerMin: 1.88, typicalReactionMs: 375.4),
    'LOAD': const _OperatorBaseline(medianCycleTimeSec: 26.30, typicalIdleMin: 3.12, typicalCorrectionsPerMin: 1.88, typicalReactionMs: 375.4),
    'GRADE': const _OperatorBaseline(medianCycleTimeSec: 36.82, typicalIdleMin: 3.12, typicalCorrectionsPerMin: 1.88, typicalReactionMs: 375.4),
  },
};

// ─── TelemetrySimulator ─────────────────────────────────────────────────────

/// The single source of truth for machine mode and telemetry (plan §1, §7).
///
/// Replays a [Scenario] timeline, emitting [TelemetryTick] objects at ~4 Hz
/// wall-clock. The simulated clock advances at [timeScale] × real time, so
/// a 2-hour demo plays out in ~2 minutes at 60×.
///
/// ## Architecture
///
/// ```
/// Scenario ──▶ TelemetrySimulator ──▶ tickStream (broadcast)
///                                       ├──▶ RiskEngine isolate
///                                       ├──▶ WorkloadEngine
///                                       ├──▶ Radar view
///                                       ├──▶ TaskAware UI
///                                       ├──▶ UnusualBehaviour rules
///                                       └──▶ Live ETA + ShiftRecovery
/// ```
class TelemetrySimulator {
  TelemetrySimulator();

  // ── Configuration ──────────────────────────────────────────────────────

  /// Wall-clock tick interval.  4 Hz = 250 ms.
  static const _wallTickInterval = Duration(milliseconds: 250);

  // ── Public state ───────────────────────────────────────────────────────

  SimulatorState get state => _state;
  double get timeScale => _timeScale;

  /// Broadcast stream of generated ticks.
  Stream<TelemetryTick> get tickStream => _controller.stream;

  /// Broadcast stream of state changes.
  Stream<SimulatorState> get stateStream => _stateController.stream;

  // ── Private state ──────────────────────────────────────────────────────

  SimulatorState _state = SimulatorState.idle;
  double _timeScale = 1.0;

  final _controller = StreamController<TelemetryTick>.broadcast();
  final _stateController = StreamController<SimulatorState>.broadcast();
  Timer? _timer;

  Scenario? _scenario;

  /// Simulated elapsed time since the first timeline entry.
  Duration _simElapsed = Duration.zero;

  /// The absolute simulated start time (the first timeline entry's offset
  /// mapped to a date — we use today's date for convenience).
  DateTime _simStartTime = DateTime.now();

  /// Index of the current timeline segment (the mode we're in).
  int _currentSegmentIdx = 0;

  /// Index of the next unprocessed scenario event.
  int _nextEventIdx = 0;

  final _rng = Random();

  // ── Mutable sim-state that evolves tick to tick ────────────────────────

  double _engineHours = 500.0;
  double _fuelUsedL = 0.0;
  int _loadCycles = 0;
  double _idleMin = 0.0;
  bool _seatbelt = true;
  double _progressPct = 0.0;
  double _fuelPct = 100.0;

  // Environment (overridden by scenario events)
  double _rain = 0.0;
  double _visibility = 80.0;
  bool _isNight = false;
  double _groundSoftness = 0.2;
  double _slopeDeg = 3.0;

  // Proximity (driven by worker-path scripts)
  double _nearestPersonM = 35.0;
  double _personBearingDeg = 180.0;
  bool _workerApproaching = false;
  Duration _workerPathStartOffset = Duration.zero;

  // Swing state
  double _swingAngle = 0.0;
  SwingDirection _swingDir = SwingDirection.center;

  // Rolling cycle time buffer
  final List<double> _cycleTimeBuffer = [];

  // ── Public controls ────────────────────────────────────────────────────

  /// Start the simulator with the given scenario.
  void start(Scenario scenario) {
    stop();
    _scenario = scenario;

    if (scenario.timeline.isEmpty) return;

    _simElapsed = Duration.zero;
    _simStartTime = DateTime.now().copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
    );
    _currentSegmentIdx = 0;
    _nextEventIdx = 0;
    _resetSimState();

    _setState(SimulatorState.running);
    _timer = Timer.periodic(_wallTickInterval, _onWallTick);
  }

  void pause() {
    if (_state != SimulatorState.running) return;
    _timer?.cancel();
    _setState(SimulatorState.paused);
  }

  void resume() {
    if (_state != SimulatorState.paused) return;
    _setState(SimulatorState.running);
    _timer = Timer.periodic(_wallTickInterval, _onWallTick);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    if (_state != SimulatorState.idle) {
      _setState(SimulatorState.idle);
    }
  }

  void setTimeScale(double scale) {
    assert(scale == 1.0 || scale == 10.0 || scale == 60.0);
    _timeScale = scale;
  }

  void dispose() {
    stop();
    _controller.close();
    _stateController.close();
  }

  // ── Private ────────────────────────────────────────────────────────────

  void _setState(SimulatorState s) {
    _state = s;
    _stateController.add(s);
  }

  void _resetSimState() {
    _engineHours = 500.0 + _rng.nextDouble() * 1500;
    _fuelUsedL = 0;
    _loadCycles = 0;
    _idleMin = 0;
    _seatbelt = true;
    _progressPct = 0;
    _fuelPct = 95 + _rng.nextDouble() * 5;
    _rain = 0;
    _visibility = 80;
    _isNight = false;
    _groundSoftness = 0.2;
    _slopeDeg = 3.0;
    _nearestPersonM = 35;
    _personBearingDeg = 180;
    _workerApproaching = false;
    _swingAngle = 0;
    _swingDir = SwingDirection.center;
    _cycleTimeBuffer.clear();
  }

  void _onWallTick(Timer _) {
    final scenario = _scenario;
    if (scenario == null || _state != SimulatorState.running) return;

    // Advance simulated time
    final simDelta = Duration(
      microseconds: (_wallTickInterval.inMicroseconds * _timeScale).round(),
    );
    _simElapsed += simDelta;

    // Check if past scenario end
    if (_simElapsed > scenario.totalDuration) {
      stop();
      return;
    }

    // Compute absolute sim time (relative to the first timeline entry)
    final firstOffset = scenario.timeline.first.offset;
    final currentSimOffset = firstOffset + _simElapsed;

    // ── Process timeline segment transitions ────────────────────────────
    while (_currentSegmentIdx < scenario.timeline.length - 1) {
      final nextSeg = scenario.timeline[_currentSegmentIdx + 1];
      if (currentSimOffset >= nextSeg.offset) {
        _currentSegmentIdx++;
        _progressPct = 0; // reset for new task
        _cycleTimeBuffer.clear();
      } else {
        break;
      }
    }

    final segment = scenario.timeline[_currentSegmentIdx];

    // ── Process scenario events ─────────────────────────────────────────
    while (_nextEventIdx < scenario.events.length) {
      final evt = scenario.events[_nextEventIdx];
      if (currentSimOffset >= evt.offset) {
        _applyEvent(evt);
        _nextEventIdx++;
      } else {
        break;
      }
    }

    // ── Compute the tick ────────────────────────────────────────────────
    final tick = _generateTick(scenario, segment, currentSimOffset);
    _controller.add(tick);
  }

  void _applyEvent(ScenarioEvent evt) {
    if (evt.isSet) {
      final v = evt.setValues!;
      if (v.containsKey('rain')) _rain = (v['rain'] as num).toDouble();
      if (v.containsKey('ground_softness')) {
        _groundSoftness = (v['ground_softness'] as num).toDouble();
      }
      if (v.containsKey('visibility')) {
        _visibility = (v['visibility'] as num).toDouble();
      }
      if (v.containsKey('is_night')) {
        _isNight = v['is_night'] == 1 || v['is_night'] == true;
      }
      if (v.containsKey('slope_deg')) {
        _slopeDeg = (v['slope_deg'] as num).toDouble();
      }
      if (v.containsKey('seatbelt')) {
        _seatbelt = v['seatbelt'] == 1 || v['seatbelt'] == true;
      }
    }

    if (evt.isWorkerPath) {
      _workerApproaching = true;
      _workerPathStartOffset =
          _scenario!.timeline.first.offset + _simElapsed;
      _nearestPersonM = 25.0;
      _personBearingDeg = 45 + _rng.nextDouble() * 90; // forward arc
    }
  }

  TelemetryTick _generateTick(
    Scenario scenario,
    TimelineEntry segment,
    Duration currentSimOffset,
  ) {
    final simTimestamp =
        _simStartTime.add(currentSimOffset);

    // ── Operator baseline ───────────────────────────────────────────────
    final opBaselines = _baselines[scenario.operator] ??
        _baselines['OP001']!;
    final baseline =
        opBaselines[segment.mode.label] ?? opBaselines['DIG']!;

    // ── Progress (linear within segment) ────────────────────────────────
    final segStart = segment.offset;
    Duration segEnd;
    if (_currentSegmentIdx < scenario.timeline.length - 1) {
      segEnd = scenario.timeline[_currentSegmentIdx + 1].offset;
    } else {
      segEnd = segStart + const Duration(minutes: 40);
    }
    final segDuration = segEnd - segStart;
    final elapsed = currentSimOffset - segStart;
    if (segDuration.inMilliseconds > 0) {
      _progressPct = (elapsed.inMilliseconds / segDuration.inMilliseconds *
              100.0)
          .clamp(0.0, 100.0);
    }

    // ── Cycle time (causal formula from plan §6) ────────────────────────
    final baseCycle = baseline.medianCycleTimeSec;
    final cycleTime = baseCycle *
        (1 + 0.6 * _groundSoftness) *
        (1 + 0.3 * (_loadPct / 100.0)) *
        (1 + 0.4 * _rain * _groundSoftness) *
        (1 + 0.02 * _slopeDeg) *
        (1 + 0.15 * (_isNight ? 1.0 : 0.0)) *
        _lognormalNoise(0.08);

    _cycleTimeBuffer.add(cycleTime);
    if (_cycleTimeBuffer.length > 8) _cycleTimeBuffer.removeAt(0);
    final rollingCycle = _cycleTimeBuffer.isEmpty
        ? cycleTime
        : _cycleTimeBuffer.reduce((a, b) => a + b) / _cycleTimeBuffer.length;

    // ── Load ────────────────────────────────────────────────────────────
    final loadPct = _computeLoad(segment.mode);

    // ── Swing ───────────────────────────────────────────────────────────
    _updateSwing(segment.mode);

    // ── Proximity (worker-path script) ──────────────────────────────────
    _updateProximity(currentSimOffset);

    // ── Stability ───────────────────────────────────────────────────────
    final stability = _computeStability(loadPct);

    // ── Fuel ────────────────────────────────────────────────────────────
    final burnRate = 0.04 + 0.03 * (loadPct / 100.0);
    _fuelUsedL += burnRate * (_wallTickInterval.inMilliseconds / 1000.0) *
        _timeScale;
    _fuelPct = (_fuelPct - 0.001 * _timeScale).clamp(0.0, 100.0);

    // ── Idle / engine hours ─────────────────────────────────────────────
    _engineHours += (_wallTickInterval.inMilliseconds / 1000.0 / 3600.0) *
        _timeScale;
    final isIdle = _progressPct < 1 && _rng.nextDouble() < 0.1;
    if (isIdle) {
      _idleMin += (_wallTickInterval.inMilliseconds / 1000.0 / 60.0) *
          _timeScale;
    }

    // ── Motion ──────────────────────────────────────────────────────────
    final speed = _rng.nextDouble() * 3.0;
    final isMoving = speed > 0.5;

    // ── Operator activity (jitter around baseline) ──────────────────────
    final corrections = baseline.typicalCorrectionsPerMin *
        (0.85 + _rng.nextDouble() * 0.3);
    final reaction = baseline.typicalReactionMs *
        (0.9 + _rng.nextDouble() * 0.2);

    // ── Hydraulic pressure ──────────────────────────────────────────────
    final hydraulicPressure = 30000 +
        _rng.nextDouble() * 5000 +
        loadPct * 30;

    _loadCycles += _rng.nextDouble() < 0.1 ? 1 : 0;

    return TelemetryTick(
      timestamp: simTimestamp,
      machineId: scenario.machine,
      operatorId: scenario.operator,
      engineHours: _engineHours,
      fuelUsedL: _fuelUsedL,
      loadCycles: _loadCycles,
      idleMin: _idleMin,
      seatbelt: _seatbelt,
      safetyAlert: 'NONE',
      taskId: segment.taskId,
      mode: segment.mode,
      progressPct: _progressPct,
      cycleTimeSec: cycleTime,
      rollingCycleTimeSec: rollingCycle,
      speed: speed,
      isMoving: isMoving,
      swingAngle: _swingAngle,
      swingDir: _swingDir,
      loadPct: loadPct,
      safeLoadLimit: 90.0,
      slopeDeg: _slopeDeg,
      stabilityIdx: stability,
      nearestPersonM: _nearestPersonM,
      personBearingDeg: _personBearingDeg,
      rain: _rain,
      visibility: _rain > 0.5 ? (40 + _rng.nextDouble() * 20) : _visibility,
      isNight: _isNight,
      groundSoftness: _groundSoftness,
      fuelPct: _fuelPct,
      hydraulicPressure: hydraulicPressure,
      controlCorrectionsPerMin: corrections,
      reactionMs: reaction,
      t0: DateTime.now(),
    );
  }

  // ── Intermediate state helpers ────────────────────────────────────────

  // Cached load value so the cycle-time formula can reference it.
  double _loadPct = 50.0;

  double _computeLoad(MachineMode mode) {
    switch (mode) {
      case MachineMode.lift:
        _loadPct = 60 + _rng.nextDouble() * 35; // 60-95%
      case MachineMode.load:
        _loadPct = 50 + _rng.nextDouble() * 40;
      case MachineMode.dig:
        _loadPct = 30 + _rng.nextDouble() * 40;
      case MachineMode.grade:
        _loadPct = 20 + _rng.nextDouble() * 30;
    }
    return _loadPct;
  }

  void _updateSwing(MachineMode mode) {
    if (mode == MachineMode.dig || mode == MachineMode.lift) {
      // Oscillate swing
      _swingAngle += (_rng.nextDouble() - 0.5) * 20;
      _swingAngle = _swingAngle.clamp(-180.0, 180.0);
      if (_swingAngle.abs() < 10) {
        _swingDir = SwingDirection.center;
      } else if (_swingAngle > 0) {
        _swingDir = SwingDirection.right;
      } else {
        _swingDir = SwingDirection.left;
      }
    } else {
      _swingAngle = 0;
      _swingDir = SwingDirection.center;
    }
  }

  /// Worker-path: over ~30 simulated seconds the worker approaches from
  /// 25 m down to ~3 m, hangs at danger distance for ~10 s, then retreats.
  void _updateProximity(Duration currentSimOffset) {
    if (!_workerApproaching) {
      // Wander person randomly at safe distance
      _nearestPersonM =
          (_nearestPersonM + (_rng.nextDouble() - 0.5) * 2).clamp(20.0, 50.0);
      return;
    }

    final elapsed = currentSimOffset - _workerPathStartOffset;
    final secs = elapsed.inMilliseconds / 1000.0;

    if (secs < 30) {
      // Approach: 25 → 3 m over 30 s
      _nearestPersonM = 25.0 - (22.0 * secs / 30.0) + _rng.nextDouble() * 0.5;
      _nearestPersonM = _nearestPersonM.clamp(2.5, 30.0);
      // Bearing drifts toward swing arc
      _personBearingDeg =
          (_personBearingDeg + (_rng.nextDouble() - 0.3) * 5).clamp(0, 360);
    } else if (secs < 40) {
      // Hold at danger distance
      _nearestPersonM = 3.0 + _rng.nextDouble() * 1.5;
    } else if (secs < 55) {
      // Retreat: 3 → 30 m over 15 s
      final retreatPct = (secs - 40) / 15.0;
      _nearestPersonM = 3.0 + 27.0 * retreatPct + _rng.nextDouble() * 0.5;
    } else {
      // Done
      _workerApproaching = false;
      _nearestPersonM = 35.0;
    }
  }

  double _computeStability(double loadPct) {
    // Base stability: higher slope and load = lower stability
    final base = 1.0 - (_slopeDeg / 30.0) - (loadPct / 300.0);
    final noise = (_rng.nextDouble() - 0.5) * 0.05;
    return (base + noise).clamp(0.1, 1.0);
  }

  double _lognormalNoise(double sigma) {
    // Box-Muller for lognormal
    final u1 = _rng.nextDouble();
    final u2 = _rng.nextDouble();
    final z = sqrt(-2 * log(u1)) * cos(2 * pi * u2);
    return exp(sigma * z);
  }
}
