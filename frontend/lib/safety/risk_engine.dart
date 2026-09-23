import '../core/alert_level.dart';
import '../telemetry/machine_mode.dart';
import '../telemetry/swing_direction.dart';
import '../telemetry/tick.dart';
import 'risk_state.dart';

class _Assessment {
  const _Assessment({
    required this.type,
    required this.level,
    required this.action,
    required this.reasons,
  });

  final HazardType type;
  final AlertLevel level;
  final String action;
  final List<String> reasons;
}

/// Deterministic operational risk engine.
///
/// Every hazard follows its own escalation ladder. Environmental context
/// changes observable thresholds; it never contributes an opaque score.
class RiskEngine {
  RiskEngine({
    this.baseAttentionRadiusM = 20,
    this.baseActionRadiusM = 10,
    this.swingRadiusM = 8,
  });

  final double baseAttentionRadiusM;
  final double baseActionRadiusM;
  final double swingRadiusM;

  DateTime? _beltOffSince;
  DateTime? _approachSince;
  double? _previousPersonDistanceM;

  RiskState evaluate(TelemetryTick tick) {
    final contextRestricted =
        tick.rain > 0.2 || tick.isNight || tick.visibility < 50;
    final distanceMultiplier = contextRestricted ? 1.5 : 1.0;
    final zones = RiskZones(
      attentionRadiusM: baseAttentionRadiusM * distanceMultiplier,
      actionRadiusM: baseActionRadiusM * distanceMultiplier,
      swingRadiusM: swingRadiusM,
    );

    final assessments = <_Assessment>[
      _assessProximity(tick, zones, contextRestricted),
      _assessSeatbelt(tick),
      _assessLoad(tick),
      _assessStability(tick, contextRestricted),
    ];
    var primary = assessments.first;
    for (final assessment in assessments.skip(1)) {
      if (assessment.level.rank > primary.level.rank) {
        primary = assessment;
      }
    }

    final hasHazard = primary.level != AlertLevel.info;
    return RiskState(
      level: primary.level,
      primaryHazard: hasHazard ? primary.type : null,
      action: hasHazard ? primary.action : 'Continue operation',
      reasons: hasHazard ? primary.reasons.take(2).toList() : const [],
      zones: zones,
      tickCreatedAt: tick.t0,
      evaluatedAt: DateTime.now(),
    );
  }

  void reset() {
    _beltOffSince = null;
    _approachSince = null;
    _previousPersonDistanceM = null;
  }

  _Assessment _assessProximity(
    TelemetryTick tick,
    RiskZones zones,
    bool contextRestricted,
  ) {
    final previous = _previousPersonDistanceM;
    final isApproaching =
        previous != null && tick.nearestPersonM < previous - 0.1;
    if (isApproaching) {
      _approachSince ??= tick.timestamp;
    } else {
      _approachSince = null;
    }
    _previousPersonDistanceM = tick.nearestPersonM;

    final approachDuration = _approachSince == null
        ? Duration.zero
        : tick.timestamp.difference(_approachSince!);
    final swingingTowardPerson = _isSwingingTowardPerson(tick);
    if (tick.nearestPersonM <= zones.swingRadiusM && swingingTowardPerson) {
      return _Assessment(
        type: HazardType.proximity,
        level: AlertLevel.critical,
        action: 'Pause swing',
        reasons: [
          'Worker inside active swing zone',
          'Machine is swinging toward the worker',
        ],
      );
    }
    if (tick.nearestPersonM <= zones.actionRadiusM ||
        approachDuration >= const Duration(seconds: 5)) {
      return _Assessment(
        type: HazardType.proximity,
        level: AlertLevel.action,
        action: 'Slow movement and verify the work zone',
        reasons: [
          'Worker ${tick.nearestPersonM.toStringAsFixed(1)} m away',
          if (approachDuration >= const Duration(seconds: 5))
            'Worker has been approaching for 5 seconds',
        ],
      );
    }
    if (tick.nearestPersonM <= zones.attentionRadiusM) {
      return _Assessment(
        type: HazardType.proximity,
        level: AlertLevel.attention,
        action: 'Monitor worker position',
        reasons: [
          'Worker ${tick.nearestPersonM.toStringAsFixed(1)} m away',
          if (contextRestricted) 'Caution zone expanded for low visibility',
        ],
      );
    }
    return _safe(HazardType.proximity);
  }

  _Assessment _assessSeatbelt(TelemetryTick tick) {
    if (tick.seatbelt) {
      _beltOffSince = null;
      return _safe(HazardType.seatbelt);
    }
    _beltOffSince ??= tick.timestamp;
    final unfastenedFor = tick.timestamp.difference(_beltOffSince!);
    if (tick.isMoving) {
      return const _Assessment(
        type: HazardType.seatbelt,
        level: AlertLevel.critical,
        action: 'Stop safely and fasten seatbelt',
        reasons: ['Seatbelt unfastened while machine is moving'],
      );
    }
    if (unfastenedFor >= const Duration(seconds: 10)) {
      return const _Assessment(
        type: HazardType.seatbelt,
        level: AlertLevel.action,
        action: 'Fasten seatbelt before movement',
        reasons: ['Seatbelt has been unfastened for 10 seconds'],
      );
    }
    return const _Assessment(
      type: HazardType.seatbelt,
      level: AlertLevel.attention,
      action: 'Fasten seatbelt',
      reasons: ['Seatbelt is unfastened'],
    );
  }

  _Assessment _assessLoad(TelemetryTick tick) {
    if (tick.mode != MachineMode.lift || tick.safeLoadLimit <= 0) {
      return _safe(HazardType.load);
    }
    final ratio = tick.loadPct / tick.safeLoadLimit;
    final swinging = tick.swingDir != SwingDirection.center;
    if (ratio > 1 && (swinging || tick.slopeDeg > 5)) {
      return _Assessment(
        type: HazardType.load,
        level: AlertLevel.critical,
        action: 'Stop swing and lower load',
        reasons: [
          'Load exceeds safe limit',
          if (swinging) 'Machine is swinging while overloaded',
          if (!swinging) 'Ground slope exceeds 5 degrees',
        ],
      );
    }
    if (ratio > 1) {
      return const _Assessment(
        type: HazardType.load,
        level: AlertLevel.action,
        action: 'Lower load before continuing',
        reasons: ['Load exceeds safe limit'],
      );
    }
    if (ratio >= 0.9) {
      return _Assessment(
        type: HazardType.load,
        level: AlertLevel.attention,
        action: 'Avoid increasing the load',
        reasons: ['Load is ${(ratio * 100).toStringAsFixed(0)}% of safe limit'],
      );
    }
    return _safe(HazardType.load);
  }

  _Assessment _assessStability(TelemetryTick tick, bool contextRestricted) {
    final slopeThreshold = contextRestricted ? 8.0 : 10.0;
    if (tick.stabilityIdx < 0.3 && tick.loadPct > 10) {
      return const _Assessment(
        type: HazardType.stability,
        level: AlertLevel.critical,
        action: 'Stop and lower load',
        reasons: ['Machine stability is critically low while loaded'],
      );
    }
    if (tick.stabilityIdx < 0.5) {
      return _Assessment(
        type: HazardType.stability,
        level: AlertLevel.action,
        action: 'Reduce load and level the machine',
        reasons: ['Stability index is ${tick.stabilityIdx.toStringAsFixed(2)}'],
      );
    }
    if (tick.slopeDeg > slopeThreshold) {
      return _Assessment(
        type: HazardType.stability,
        level: AlertLevel.attention,
        action: 'Reduce slope exposure',
        reasons: [
          'Ground slope is ${tick.slopeDeg.toStringAsFixed(1)} degrees',
          if (contextRestricted) 'Slope threshold lowered for conditions',
        ],
      );
    }
    return _safe(HazardType.stability);
  }

  bool _isSwingingTowardPerson(TelemetryTick tick) {
    final bearing = tick.personBearingDeg % 360;
    return switch (tick.swingDir) {
      SwingDirection.right => bearing > 0 && bearing <= 180,
      SwingDirection.left => bearing > 180 && bearing < 360,
      SwingDirection.center => false,
    };
  }

  _Assessment _safe(HazardType type) {
    return _Assessment(
      type: type,
      level: AlertLevel.info,
      action: 'Continue operation',
      reasons: const [],
    );
  }
}
