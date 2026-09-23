import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/alert_level.dart';
import '../../core/theme.dart';
import '../../safety/risk_state.dart';
import '../../safety/safety_providers.dart';
import '../../safety/workload_engine.dart';
import '../../telemetry/simulator_providers.dart';
import '../../telemetry/tick.dart';
import '../radar/safety_radar.dart';

class SafetyScreen extends ConsumerWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tick = ref.watch(telemetryTickProvider).valueOrNull;
    final workload = ref.watch(workloadStateProvider).valueOrNull;
    final risk =
        ref.watch(riskStateProvider).valueOrNull ??
        RiskState(
          level: AlertLevel.info,
          action: 'Continue operation',
          reasons: const [],
          zones: const RiskZones(
            attentionRadiusM: 20,
            actionRadiusM: 10,
            swingRadiusM: 8,
          ),
          tickCreatedAt: DateTime.fromMillisecondsSinceEpoch(0),
          evaluatedAt: DateTime.fromMillisecondsSinceEpoch(0),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('SAFETY COMMAND')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final padding = wide ? 28.0 : 18.0;
            final radar = _RadarPanel(risk: risk, tick: tick);
            final details = _SafetyDetails(
              risk: risk,
              tick: tick,
              workload: workload,
            );
            return Padding(
              padding: EdgeInsets.fromLTRB(padding, 8, padding, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SafetyHeader(risk: risk, tick: tick),
                  const SizedBox(height: 16),
                  Expanded(
                    child: wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(flex: 7, child: radar),
                              const SizedBox(width: 16),
                              SizedBox(width: 310, child: details),
                            ],
                          )
                        : ListView(
                            children: [
                              SizedBox(height: 430, child: radar),
                              const SizedBox(height: 14),
                              details,
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SafetyHeader extends StatelessWidget {
  const _SafetyHeader({required this.risk, required this.tick});

  final RiskState risk;
  final TelemetryTick? tick;

  @override
  Widget build(BuildContext context) {
    final currentTick = tick;
    final color = _levelColor(risk.level);
    final safe = risk.primaryHazard == null;
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.55)),
          ),
          child: Icon(
            safe ? Icons.shield_rounded : Icons.warning_amber_rounded,
            color: color,
            size: 27,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                safe ? 'Work zone clear' : risk.action,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 3),
              Text(
                currentTick == null
                    ? 'Waiting for live machine telemetry'
                    : 'EXC001 · ${risk.level.label} · '
                          'nearest worker ${currentTick.nearestPersonM.toStringAsFixed(0)} m',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            risk.level.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}

class _RadarPanel extends StatelessWidget {
  const _RadarPanel({required this.risk, required this.tick});

  final RiskState risk;
  final TelemetryTick? tick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CatTheme.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CatTheme.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Stack(
          children: [
            Positioned.fill(
              child: SafetyRadar(risk: risk, tick: tick),
            ),
            const Positioned(left: 14, top: 12, child: _LiveChip()),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: _ZoneLegend(zones: risk.zones),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveChip extends StatelessWidget {
  const _LiveChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: CatTheme.black.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: CatTheme.divider),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: CatTheme.safe, size: 8),
          SizedBox(width: 6),
          Text(
            'LIVE PROXIMITY MAP',
            style: TextStyle(
              color: CatTheme.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneLegend extends StatelessWidget {
  const _ZoneLegend({required this.zones});

  final RiskZones zones;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: CatTheme.black.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: CatTheme.divider),
      ),
      child: Row(
        children: [
          _LegendItem(
            color: CatTheme.critical,
            label: 'Swing ${zones.swingRadiusM.toStringAsFixed(0)} m',
          ),
          const SizedBox(width: 14),
          _LegendItem(
            color: CatTheme.action,
            label: 'Action ${zones.actionRadiusM.toStringAsFixed(0)} m',
          ),
          const SizedBox(width: 14),
          _LegendItem(
            color: CatTheme.attention,
            label: 'Caution ${zones.attentionRadiusM.toStringAsFixed(0)} m',
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CatTheme.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyDetails extends StatelessWidget {
  const _SafetyDetails({
    required this.risk,
    required this.tick,
    required this.workload,
  });

  final RiskState risk;
  final TelemetryTick? tick;
  final WorkloadState? workload;

  @override
  Widget build(BuildContext context) {
    final currentTick = tick;
    final operatingMinutes =
        workload?.continuousOperatingTime.inMinutes.clamp(0, 12 * 60) ?? 0;
    final hours = operatingMinutes ~/ 60;
    final minutes = operatingMinutes % 60;
    final operatingLabel = hours == 0 ? '${minutes}m' : '${hours}h ${minutes}m';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CatTheme.panelRaised,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CatTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Live conditions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _MetricLine(
            icon: Icons.person_pin_circle_rounded,
            label: 'Nearest worker',
            value: currentTick == null
                ? '—'
                : '${currentTick.nearestPersonM.toStringAsFixed(0)} m',
            color: risk.primaryHazard == HazardType.proximity
                ? _levelColor(risk.level)
                : CatTheme.safe,
          ),
          _MetricLine(
            icon: Icons.airline_seat_recline_normal_rounded,
            label: 'Seatbelt',
            value: tick?.seatbelt == false ? 'UNFASTENED' : 'FASTENED',
            color: tick?.seatbelt == false ? CatTheme.critical : CatTheme.safe,
          ),
          _MetricLine(
            icon: Icons.rotate_right_rounded,
            label: 'Swing direction',
            value: tick?.swingDir.label ?? '—',
            color: CatTheme.yellow,
          ),
          _MetricLine(
            icon: Icons.timer_outlined,
            label: 'Continuous operation',
            value: operatingLabel,
            color: _workloadColor(workload?.level),
          ),
          const Divider(height: 28),
          Text(
            'Operator action',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(risk.action, style: Theme.of(context).textTheme.bodyLarge),
          if (risk.reasons.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...risk.reasons
                .take(2)
                .map(
                  (reason) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.arrow_right_rounded,
                          color: _levelColor(risk.level),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            reason,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

Color _levelColor(AlertLevel level) => switch (level) {
  AlertLevel.info => CatTheme.safe,
  AlertLevel.attention => CatTheme.attention,
  AlertLevel.action => CatTheme.action,
  AlertLevel.critical => CatTheme.critical,
};

Color _workloadColor(WorkloadLevel? level) => switch (level) {
  WorkloadLevel.high => CatTheme.action,
  WorkloadLevel.elevated => CatTheme.attention,
  _ => CatTheme.safe,
};
