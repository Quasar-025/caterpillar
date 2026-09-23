import '../core/alert_level.dart';

enum HazardType {
  proximity,
  seatbelt,
  load,
  stability;

  String get label => switch (this) {
    proximity => 'PROXIMITY',
    seatbelt => 'SEATBELT',
    load => 'LOAD',
    stability => 'STABILITY',
  };
}

class RiskZones {
  const RiskZones({
    required this.attentionRadiusM,
    required this.actionRadiusM,
    required this.swingRadiusM,
  });

  final double attentionRadiusM;
  final double actionRadiusM;
  final double swingRadiusM;

  Map<String, Object> toJson() => {
    'attention_radius_m': attentionRadiusM,
    'action_radius_m': actionRadiusM,
    'swing_radius_m': swingRadiusM,
  };

  factory RiskZones.fromJson(Map<Object?, Object?> json) {
    return RiskZones(
      attentionRadiusM: (json['attention_radius_m'] as num).toDouble(),
      actionRadiusM: (json['action_radius_m'] as num).toDouble(),
      swingRadiusM: (json['swing_radius_m'] as num).toDouble(),
    );
  }
}

class RiskState {
  const RiskState({
    required this.level,
    required this.action,
    required this.reasons,
    required this.zones,
    required this.tickCreatedAt,
    required this.evaluatedAt,
    this.primaryHazard,
  });

  final AlertLevel level;
  final HazardType? primaryHazard;
  final String action;
  final List<String> reasons;
  final RiskZones zones;
  final DateTime tickCreatedAt;
  final DateTime evaluatedAt;

  bool get hasImmediateHazard => level.rank >= AlertLevel.action.rank;

  Map<String, Object?> toJson() => {
    'level': level.name,
    'primary_hazard': primaryHazard?.name,
    'action': action,
    'reasons': reasons,
    'zones': zones.toJson(),
    'tick_created_at': tickCreatedAt.toIso8601String(),
    'evaluated_at': evaluatedAt.toIso8601String(),
  };

  factory RiskState.fromJson(Map<Object?, Object?> json) {
    final hazard = json['primary_hazard'] as String?;
    return RiskState(
      level: AlertLevel.values.byName(json['level'] as String),
      primaryHazard: hazard == null ? null : HazardType.values.byName(hazard),
      action: json['action'] as String,
      reasons: (json['reasons'] as List<Object?>).cast<String>(),
      zones: RiskZones.fromJson(json['zones'] as Map<Object?, Object?>),
      tickCreatedAt: DateTime.parse(json['tick_created_at'] as String),
      evaluatedAt: DateTime.parse(json['evaluated_at'] as String),
    );
  }
}
