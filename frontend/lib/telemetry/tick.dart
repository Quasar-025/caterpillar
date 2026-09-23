import 'machine_mode.dart';
import 'swing_direction.dart';

/// A single telemetry sample emitted by the simulator.
///
/// Matches the schema in plan §5 (Telemetry tick, 1-5 Hz) and the columns
/// of `data/telemetry.csv`. Immutable — every tick is a new instance.
///
/// [t0] is the wall-clock time the tick was created, used for latency
/// measurement (plan §10).
class TelemetryTick {
  const TelemetryTick({
    required this.timestamp,
    required this.machineId,
    required this.operatorId,
    required this.engineHours,
    required this.fuelUsedL,
    required this.loadCycles,
    required this.idleMin,
    required this.seatbelt,
    required this.safetyAlert,
    required this.taskId,
    required this.mode,
    required this.progressPct,
    required this.cycleTimeSec,
    required this.rollingCycleTimeSec,
    required this.speed,
    required this.isMoving,
    required this.swingAngle,
    required this.swingDir,
    required this.loadPct,
    required this.safeLoadLimit,
    required this.slopeDeg,
    required this.stabilityIdx,
    required this.nearestPersonM,
    required this.personBearingDeg,
    required this.rain,
    required this.visibility,
    required this.isNight,
    required this.groundSoftness,
    required this.fuelPct,
    required this.hydraulicPressure,
    required this.controlCorrectionsPerMin,
    required this.reactionMs,
    required this.t0,
  });

  // ── Core ──────────────────────────────────────────────────────────────

  /// Simulated timestamp (scenario time, not wall-clock).
  final DateTime timestamp;
  final String machineId;
  final String operatorId;
  final double engineHours;
  final double fuelUsedL;
  final int loadCycles;
  final double idleMin;

  /// `true` when the seatbelt is fastened.
  final bool seatbelt;

  /// One of `NONE`, `ATTENTION`, `ACTION`, `CRITICAL` — echoed from the
  /// scenario / injected anomaly.  The RiskEngine computes its own level.
  final String safetyAlert;

  // ── Task state ────────────────────────────────────────────────────────

  final String taskId;
  final MachineMode mode;

  /// 0 – 100.
  final double progressPct;

  /// The last completed cycle time (seconds).
  final double cycleTimeSec;

  /// Rolling average of the last 8 cycle times (seconds).
  final double rollingCycleTimeSec;

  // ── Motion ────────────────────────────────────────────────────────────

  /// Machine travel speed (km/h). 0 when stationary.
  final double speed;
  final bool isMoving;

  /// Current swing angle in degrees (−180 to +180).
  final double swingAngle;
  final SwingDirection swingDir;

  // ── Load & stability ─────────────────────────────────────────────────

  /// Current payload as a percentage of max rated capacity.
  final double loadPct;

  /// Safe load threshold as a percentage of rated capacity.
  final double safeLoadLimit;

  /// Ground slope at the machine (degrees).
  final double slopeDeg;

  /// Stability index (0 – 1). Lower = less stable.
  final double stabilityIdx;

  // ── Proximity ─────────────────────────────────────────────────────────

  /// Distance to nearest person in metres.  30+ = nobody nearby.
  final double nearestPersonM;

  /// Bearing to nearest person in degrees (0-360, relative to machine).
  final double personBearingDeg;

  // ── Environment ───────────────────────────────────────────────────────

  /// Rain intensity (0 = none, 1 = heavy).
  final double rain;

  /// Visibility in metres.  100 = clear, <30 = poor.
  final double visibility;
  final bool isNight;

  /// 0 – 1.  Higher = softer ground.
  final double groundSoftness;

  // ── Machine ───────────────────────────────────────────────────────────

  /// Fuel remaining (percentage).
  final double fuelPct;

  /// Hydraulic system pressure (kPa).
  final double hydraulicPressure;

  // ── Operator activity ─────────────────────────────────────────────────

  /// Control corrections per minute.
  final double controlCorrectionsPerMin;

  /// Operator reaction time (ms).
  final double reactionMs;

  // ── Latency probe ─────────────────────────────────────────────────────

  /// Wall-clock time this tick was created, for latency measurement.
  final DateTime t0;

  // ── Serialisation ─────────────────────────────────────────────────────

  factory TelemetryTick.fromJson(Map<String, dynamic> j) {
    return TelemetryTick(
      timestamp: DateTime.parse(j['timestamp'] as String),
      machineId: j['machine_id'] as String,
      operatorId: j['operator_id'] as String,
      engineHours: (j['engine_hours'] as num).toDouble(),
      fuelUsedL: (j['fuel_used_l'] as num).toDouble(),
      loadCycles: (j['load_cycles'] as num).toInt(),
      idleMin: (j['idle_min'] as num).toDouble(),
      seatbelt: j['seatbelt'] == 1 || j['seatbelt'] == true,
      safetyAlert: j['safety_alert'] as String? ?? 'NONE',
      taskId: j['task_id'] as String,
      mode: MachineMode.fromString(j['mode'] as String),
      progressPct: (j['progress_pct'] as num).toDouble(),
      cycleTimeSec: (j['cycle_time_sec'] as num).toDouble(),
      rollingCycleTimeSec: (j['rolling_cycle_time_sec'] as num).toDouble(),
      speed: (j['speed'] as num).toDouble(),
      isMoving: j['is_moving'] == 1 || j['is_moving'] == true,
      swingAngle: (j['swing_angle'] as num).toDouble(),
      swingDir: SwingDirection.fromString(j['swing_dir'] as String),
      loadPct: (j['load_pct'] as num).toDouble(),
      safeLoadLimit: (j['safe_load_limit'] as num).toDouble(),
      slopeDeg: (j['slope_deg'] as num).toDouble(),
      stabilityIdx: (j['stability_idx'] as num).toDouble(),
      nearestPersonM: (j['nearest_person_m'] as num).toDouble(),
      personBearingDeg: (j['person_bearing_deg'] as num).toDouble(),
      rain: (j['rain'] as num).toDouble(),
      visibility: (j['visibility'] as num).toDouble(),
      isNight: j['is_night'] == 1 || j['is_night'] == true,
      groundSoftness: (j['ground_softness'] as num).toDouble(),
      fuelPct: (j['fuel_pct'] as num).toDouble(),
      hydraulicPressure: (j['hydraulic_pressure'] as num).toDouble(),
      controlCorrectionsPerMin:
          (j['control_corrections_per_min'] as num).toDouble(),
      reactionMs: (j['reaction_ms'] as num).toDouble(),
      t0: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'machine_id': machineId,
        'operator_id': operatorId,
        'engine_hours': engineHours,
        'fuel_used_l': fuelUsedL,
        'load_cycles': loadCycles,
        'idle_min': idleMin,
        'seatbelt': seatbelt ? 1 : 0,
        'safety_alert': safetyAlert,
        'task_id': taskId,
        'mode': mode.label,
        'progress_pct': progressPct,
        'cycle_time_sec': cycleTimeSec,
        'rolling_cycle_time_sec': rollingCycleTimeSec,
        'speed': speed,
        'is_moving': isMoving ? 1 : 0,
        'swing_angle': swingAngle,
        'swing_dir': swingDir.label,
        'load_pct': loadPct,
        'safe_load_limit': safeLoadLimit,
        'slope_deg': slopeDeg,
        'stability_idx': stabilityIdx,
        'nearest_person_m': nearestPersonM,
        'person_bearing_deg': personBearingDeg,
        'rain': rain,
        'visibility': visibility,
        'is_night': isNight ? 1 : 0,
        'ground_softness': groundSoftness,
        'fuel_pct': fuelPct,
        'hydraulic_pressure': hydraulicPressure,
        'control_corrections_per_min': controlCorrectionsPerMin,
        'reaction_ms': reactionMs,
      };

  TelemetryTick copyWith({
    DateTime? timestamp,
    String? machineId,
    String? operatorId,
    double? engineHours,
    double? fuelUsedL,
    int? loadCycles,
    double? idleMin,
    bool? seatbelt,
    String? safetyAlert,
    String? taskId,
    MachineMode? mode,
    double? progressPct,
    double? cycleTimeSec,
    double? rollingCycleTimeSec,
    double? speed,
    bool? isMoving,
    double? swingAngle,
    SwingDirection? swingDir,
    double? loadPct,
    double? safeLoadLimit,
    double? slopeDeg,
    double? stabilityIdx,
    double? nearestPersonM,
    double? personBearingDeg,
    double? rain,
    double? visibility,
    bool? isNight,
    double? groundSoftness,
    double? fuelPct,
    double? hydraulicPressure,
    double? controlCorrectionsPerMin,
    double? reactionMs,
    DateTime? t0,
  }) {
    return TelemetryTick(
      timestamp: timestamp ?? this.timestamp,
      machineId: machineId ?? this.machineId,
      operatorId: operatorId ?? this.operatorId,
      engineHours: engineHours ?? this.engineHours,
      fuelUsedL: fuelUsedL ?? this.fuelUsedL,
      loadCycles: loadCycles ?? this.loadCycles,
      idleMin: idleMin ?? this.idleMin,
      seatbelt: seatbelt ?? this.seatbelt,
      safetyAlert: safetyAlert ?? this.safetyAlert,
      taskId: taskId ?? this.taskId,
      mode: mode ?? this.mode,
      progressPct: progressPct ?? this.progressPct,
      cycleTimeSec: cycleTimeSec ?? this.cycleTimeSec,
      rollingCycleTimeSec: rollingCycleTimeSec ?? this.rollingCycleTimeSec,
      speed: speed ?? this.speed,
      isMoving: isMoving ?? this.isMoving,
      swingAngle: swingAngle ?? this.swingAngle,
      swingDir: swingDir ?? this.swingDir,
      loadPct: loadPct ?? this.loadPct,
      safeLoadLimit: safeLoadLimit ?? this.safeLoadLimit,
      slopeDeg: slopeDeg ?? this.slopeDeg,
      stabilityIdx: stabilityIdx ?? this.stabilityIdx,
      nearestPersonM: nearestPersonM ?? this.nearestPersonM,
      personBearingDeg: personBearingDeg ?? this.personBearingDeg,
      rain: rain ?? this.rain,
      visibility: visibility ?? this.visibility,
      isNight: isNight ?? this.isNight,
      groundSoftness: groundSoftness ?? this.groundSoftness,
      fuelPct: fuelPct ?? this.fuelPct,
      hydraulicPressure: hydraulicPressure ?? this.hydraulicPressure,
      controlCorrectionsPerMin:
          controlCorrectionsPerMin ?? this.controlCorrectionsPerMin,
      reactionMs: reactionMs ?? this.reactionMs,
      t0: t0 ?? this.t0,
    );
  }

  @override
  String toString() =>
      'Tick($timestamp $machineId $taskId ${mode.label} ${progressPct.toStringAsFixed(1)}%)';
}
