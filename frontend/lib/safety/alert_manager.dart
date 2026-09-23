import 'dart:async';

import 'package:flutter/services.dart';

import '../core/alert_level.dart';
import 'risk_state.dart';
import 'workload_engine.dart';

/// Timestamped alert record emitted by [AlertManager].
///
/// Carries t0-t2 latency probes from the plan (§10):
///   t0 = tick created, t1 = RiskState emitted (both in [RiskState]),
///   t2 = haptic/audio calls fired (set by AlertManager).
class ActiveAlert {
  ActiveAlert({
    required this.id,
    required this.level,
    required this.hazardType,
    required this.action,
    required this.reasons,
    required this.tickCreatedAt,
    required this.riskEvaluatedAt,
    required this.alertEmittedAt,
    required this.requiresAck,
    this.acknowledged = false,
  });

  /// Stable key for deduplication (`hazardType.name`).
  final String id;
  final AlertLevel level;
  final HazardType? hazardType;
  final String action;
  final List<String> reasons;

  /// Latency probe t0 (tick created).
  final DateTime tickCreatedAt;

  /// Latency probe t1 (RiskState emitted).
  final DateTime riskEvaluatedAt;

  /// Latency probe t2 (haptic/audio fired by AlertManager).
  final DateTime alertEmittedAt;

  /// Critical alerts require operator acknowledgement.
  final bool requiresAck;

  /// Set to `true` when the operator acknowledges a Critical alert.
  bool acknowledged;

  ActiveAlert copyWith({
    AlertLevel? level,
    String? action,
    List<String>? reasons,
    DateTime? tickCreatedAt,
    DateTime? riskEvaluatedAt,
    DateTime? alertEmittedAt,
    bool? requiresAck,
    bool? acknowledged,
  }) {
    return ActiveAlert(
      id: id,
      level: level ?? this.level,
      hazardType: hazardType,
      action: action ?? this.action,
      reasons: reasons ?? this.reasons,
      tickCreatedAt: tickCreatedAt ?? this.tickCreatedAt,
      riskEvaluatedAt: riskEvaluatedAt ?? this.riskEvaluatedAt,
      alertEmittedAt: alertEmittedAt ?? this.alertEmittedAt,
      requiresAck: requiresAck ?? this.requiresAck,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }
}

/// The combined alert state visible to the UI.
class AlertManagerState {
  const AlertManagerState({
    required this.overallLevel,
    required this.activeAlerts,
    required this.criticalPending,
    this.workloadMessage,
  });

  /// The highest level across all active alerts.
  final AlertLevel overallLevel;

  /// All currently active (non-expired, non-deduped) alerts.
  final List<ActiveAlert> activeAlerts;

  /// `true` when a Critical alert is un-acknowledged.
  final bool criticalPending;

  /// Optional workload message (separate from risk alerts).
  final String? workloadMessage;

  static const empty = AlertManagerState(
    overallLevel: AlertLevel.info,
    activeAlerts: [],
    criticalPending: false,
  );
}

/// Tracks hysteresis timing for a single hazard.
class _HysteresisEntry {
  _HysteresisEntry(this.level, this.since);

  AlertLevel level;
  DateTime since;
}

/// Anti-fatigue alert manager (plan §10).
///
/// Design highlights:
/// - **Escalation**: levels follow the hazard ladder — no arbitrary jumps.
/// - **Hysteresis**: a level drops only after ~2 s below threshold.
/// - **Dedupe**: one active alert per hazard key.
/// - **Rate limit**: max 1 Attention/Action per 30 s per category.
/// - **Info**: visual only — never vibrates or plays sound.
/// - **Critical**: full-screen overlay, tone, vibration. Must be acked;
///   cannot be muted.
class AlertManager {
  AlertManager({
    DateTime Function()? clock,
    void Function(AlertLevel level)? onCue,
  }) : _clock = clock ?? DateTime.now,
       _onCue = onCue;

  final DateTime Function() _clock;
  final void Function(AlertLevel level)? _onCue;

  final _controller = StreamController<AlertManagerState>.broadcast();

  /// Subscribe for state updates. The overlay widget listens here.
  Stream<AlertManagerState> get stream => _controller.stream;

  AlertManagerState get snapshot => _currentState();

  // ── Internal state ──────────────────────────────────────────────────────

  /// Current active alert per hazard key.
  final _activeAlerts = <String, ActiveAlert>{};

  /// Last time an Attention/Action was emitted per category.
  final _lastAlertTime = <String, DateTime>{};

  /// Hysteresis: tracks when a hazard dropped below its current level.
  final _hysteresis = <String, _HysteresisEntry>{};

  /// Pending critical alert (un-acknowledged).
  ActiveAlert? _pendingCritical;

  /// Duration below threshold before we actually drop the level.
  static const _hysteresisDuration = Duration(seconds: 2);

  /// Minimum gap between Attention/Action alerts of the same category.
  static const _rateLimitDuration = Duration(seconds: 30);

  /// The latest workload message.
  String? _workloadMessage;

  // ── Public API ──────────────────────────────────────────────────────────

  /// Call on every new [RiskState] from the RiskEngine.
  void processRiskState(RiskState state) {
    final now = _clock();

    if (state.primaryHazard == null || state.level == AlertLevel.info) {
      _startHysteresisFor(_activeAlerts.keys, now);
      _expireHysteresisEntries(now);
      _emit();
      return;
    }

    final key = state.primaryHazard!.name;
    final existing = _activeAlerts[key];

    // Stale hazards that are no longer primary must also cool down.
    _startHysteresisFor(_activeAlerts.keys.where((other) => other != key), now);

    // ── Hysteresis check ────────────────────────────────────────────────
    if (existing != null && state.level.rank < existing.level.rank) {
      // The hazard dropped. Start or continue a hysteresis timer.
      final entry = _hysteresis[key];
      if (entry == null) {
        _hysteresis[key] = _HysteresisEntry(state.level, now);
        _expireHysteresisEntries(now);
        _emit();
        return; // Keep old level until hysteresis expires.
      }
      if (now.difference(entry.since) < _hysteresisDuration) {
        _expireHysteresisEntries(now);
        _emit();
        return; // Still within the grace period.
      }
      // Hysteresis expired → allow the drop.
      _hysteresis.remove(key);
    } else {
      // Level stayed same or escalated — reset hysteresis.
      _hysteresis.remove(key);
    }

    // ── Rate limit (Attention / Action only) ────────────────────────────
    var fireHaptics = true;
    if (state.level == AlertLevel.attention ||
        state.level == AlertLevel.action) {
      if (existing == null || state.level.rank > existing.level.rank) {
        final last = _lastAlertTime[key];
        if (last != null && now.difference(last) < _rateLimitDuration) {
          fireHaptics = false;
        } else {
          _lastAlertTime[key] = now;
        }
      } else {
        fireHaptics = false;
      }
    }

    _updateAlert(key, state, now, fireHaptics: fireHaptics);

    if (state.level == AlertLevel.critical) {
      _pendingCritical = _activeAlerts[key];
    }

    _expireHysteresisEntries(now);
    _emit();
  }

  /// Call on every new [WorkloadState].
  void processWorkloadState(WorkloadState state) {
    if (state.level == WorkloadLevel.normal) {
      _workloadMessage = null;
    } else {
      final reasons = state.reasons.isNotEmpty ? state.reasons.first : '';
      _workloadMessage =
          'OPERATOR WORKLOAD: ${state.level.label}${reasons.isNotEmpty ? ' — $reasons' : ''}';
    }
    _emit();
  }

  /// Operator acknowledges the Critical alert.
  void acknowledgeCritical() {
    if (_pendingCritical != null) {
      _pendingCritical!.acknowledged = true;
      _pendingCritical = null;
      _emit();
    }
  }

  /// Reset all state (e.g. on shift end).
  void reset() {
    _activeAlerts.clear();
    _lastAlertTime.clear();
    _hysteresis.clear();
    _pendingCritical = null;
    _workloadMessage = null;
    _emit();
  }

  void dispose() {
    _controller.close();
  }

  // ── Internals ─────────────────────────────────────────────────────────

  void _updateAlert(
    String key,
    RiskState state,
    DateTime now, {
    required bool fireHaptics,
  }) {
    final t2 = now;
    final alert = ActiveAlert(
      id: key,
      level: state.level,
      hazardType: state.primaryHazard,
      action: state.action,
      reasons: state.reasons,
      tickCreatedAt: state.tickCreatedAt,
      riskEvaluatedAt: state.evaluatedAt,
      alertEmittedAt: t2,
      requiresAck: state.level == AlertLevel.critical,
    );

    _activeAlerts[key] = alert;

    if (fireHaptics) {
      _fireHapticsAndAudio(state.level);
    }
  }

  /// Fire haptic feedback and audio cues based on alert level.
  ///
  /// Info: nothing.
  /// Attention: light haptic.
  /// Action: medium haptic.
  /// Critical: heavy haptic + vibration pattern.
  void _fireHapticsAndAudio(AlertLevel level) {
    if (level == AlertLevel.info) return;
    final cue = _onCue;
    if (cue != null) {
      cue(level);
      return;
    }
    switch (level) {
      case AlertLevel.info:
        break;
      case AlertLevel.attention:
        HapticFeedback.lightImpact();
        break;
      case AlertLevel.action:
        HapticFeedback.mediumImpact();
        break;
      case AlertLevel.critical:
        HapticFeedback.heavyImpact();
        HapticFeedback.vibrate();
        break;
    }
  }

  void _startHysteresisFor(Iterable<String> keys, DateTime now) {
    for (final key in keys) {
      _hysteresis.putIfAbsent(
        key,
        () => _HysteresisEntry(AlertLevel.info, now),
      );
    }
  }

  void _expireHysteresisEntries(DateTime now) {
    final expired = <String>[];
    for (final entry in _hysteresis.entries) {
      if (now.difference(entry.value.since) >= _hysteresisDuration) {
        expired.add(entry.key);
      }
    }
    for (final key in expired) {
      _activeAlerts.remove(key);
      _hysteresis.remove(key);
      if (_pendingCritical?.id == key) {
        _pendingCritical = null;
      }
    }
  }

  AlertManagerState _currentState() {
    final alerts = _activeAlerts.values.toList();
    var overallLevel = AlertLevel.info;
    for (final alert in alerts) {
      if (alert.level.rank > overallLevel.rank) {
        overallLevel = alert.level;
      }
    }

    return AlertManagerState(
      overallLevel: overallLevel,
      activeAlerts: alerts,
      criticalPending:
          _pendingCritical != null && !_pendingCritical!.acknowledged,
      workloadMessage: _workloadMessage,
    );
  }

  void _emit() {
    if (!_controller.isClosed) {
      _controller.add(_currentState());
    }
  }
}
