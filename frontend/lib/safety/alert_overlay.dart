import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/alert_level.dart';
import '../core/theme.dart';
import 'alert_manager.dart';
import 'alert_providers.dart';
import 'latency_probe.dart';

/// Always-mounted overlay that displays alert banners and the full-screen
/// Critical acknowledgement gate.
///
/// Mount this above the main content via a [Stack] in the app shell so it is
/// never removed from the tree. It toggles its own visibility based on the
/// current [AlertManagerState].
class AlertOverlay extends ConsumerStatefulWidget {
  const AlertOverlay({super.key});

  @override
  ConsumerState<AlertOverlay> createState() => _AlertOverlayState();
}

class _AlertOverlayState extends ConsumerState<AlertOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alertState = ref.watch(alertStateProvider).valueOrNull;
    if (alertState == null) return const SizedBox.shrink();

    // Record t3 on the next frame for latency measurement.
    if (alertState.activeAlerts.isNotEmpty) {
      _recordT3(alertState);
    }

    // Pulse animation for Critical.
    if (alertState.criticalPending) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      if (_pulseController.isAnimating) {
        _pulseController.stop();
        _pulseController.reset();
      }
    }

    return Stack(
      children: [
        // ── Full-screen Critical overlay ─────────────────────────────────
        if (alertState.criticalPending)
          _CriticalOverlay(
            alert: alertState.activeAlerts.firstWhere(
              (a) => a.level == AlertLevel.critical && !a.acknowledged,
              orElse: () => alertState.activeAlerts.first,
            ),
            pulseAnimation: _pulseAnimation,
            onAcknowledge: () {
              ref.read(alertManagerProvider).acknowledgeCritical();
            },
          ),

        // ── Alert banner (non-critical) ─────────────────────────────────
        if (!alertState.criticalPending && alertState.overallLevel != AlertLevel.info)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _AlertBanner(
              level: alertState.overallLevel,
              alerts: alertState.activeAlerts,
            ),
          ),

        // ── Workload chip ───────────────────────────────────────────────
        if (alertState.workloadMessage != null && !alertState.criticalPending)
          Positioned(
            top: alertState.overallLevel != AlertLevel.info ? 80 : 8,
            right: 8,
            child: _WorkloadChip(message: alertState.workloadMessage!),
          ),
      ],
    );
  }

  void _recordT3(AlertManagerState state) {
    final probe = ref.read(latencyProbeProvider);
    for (final alert in state.activeAlerts) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final t3 = DateTime.now();
        probe.record(LatencySample(
          t0: alert.tickCreatedAt,
          t1: alert.riskEvaluatedAt,
          t2: alert.alertEmittedAt,
          t3: t3,
        ));
      });
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Critical overlay — full-screen, cannot be dismissed, must be acked.
// ═══════════════════════════════════════════════════════════════════════════

class _CriticalOverlay extends StatelessWidget {
  const _CriticalOverlay({
    required this.alert,
    required this.pulseAnimation,
    required this.onAcknowledge,
  });

  final ActiveAlert alert;
  final Animation<double> pulseAnimation;
  final VoidCallback onAcknowledge;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Container(
          color: CatTheme.critical.withValues(alpha: pulseAnimation.value * 0.85),
          child: child,
        );
      },
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 96,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  'CRITICAL SAFETY ALERT',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (alert.hazardType != null)
                  _InfoRow(
                    label: 'HAZARD',
                    value: alert.hazardType!.label,
                  ),
                _InfoRow(label: 'ACTION', value: alert.action),
                for (final reason in alert.reasons)
                  _InfoRow(label: 'REASON', value: reason),
                const SizedBox(height: 40),
                SizedBox(
                  width: 280,
                  height: 72,
                  child: FilledButton(
                    onPressed: onAcknowledge,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: CatTheme.critical,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    child: const Text('ACKNOWLEDGE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Alert banner — coloured strip at the top for Attention / Action levels.
// ═══════════════════════════════════════════════════════════════════════════

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({required this.level, required this.alerts});

  final AlertLevel level;
  final List<ActiveAlert> alerts;

  Color get _bannerColor => switch (level) {
        AlertLevel.attention => CatTheme.attention,
        AlertLevel.action => CatTheme.action,
        AlertLevel.critical => CatTheme.critical,
        AlertLevel.info => Colors.transparent,
      };

  IconData get _icon => switch (level) {
        AlertLevel.attention => Icons.info_outline,
        AlertLevel.action => Icons.warning_amber_rounded,
        AlertLevel.critical => Icons.dangerous_outlined,
        AlertLevel.info => Icons.check_circle_outline,
      };

  @override
  Widget build(BuildContext context) {
    final primary = alerts.isNotEmpty ? alerts.first : null;
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        color: _bannerColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              Icon(_icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${level.label}${primary?.hazardType != null ? ' — ${primary!.hazardType!.label}' : ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    if (primary != null)
                      Text(
                        primary.action,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Workload chip — small tag shown next to the status header.
// ═══════════════════════════════════════════════════════════════════════════

class _WorkloadChip extends StatelessWidget {
  const _WorkloadChip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: CatTheme.attention.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
