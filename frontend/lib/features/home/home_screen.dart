import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/alert_level.dart';
import '../../core/theme.dart';
import '../../domain/eta_live.dart';
import '../../domain/eta_providers.dart';
import '../../domain/shift_recovery.dart';
import '../../domain/unusual_behaviour.dart';
import '../../domain/unusual_providers.dart';
import '../../safety/risk_state.dart';
import '../../safety/safety_providers.dart';
import '../../safety/workload_engine.dart';
import '../../telemetry/machine_mode.dart';
import '../../telemetry/scenario_loader.dart';
import '../../telemetry/simulator.dart';
import '../../telemetry/simulator_providers.dart';
import '../../telemetry/tick.dart';
import '../task_ui/task_ui_coordinator.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final tick = ref.watch(telemetryTickProvider).valueOrNull;
    final risk = ref.watch(riskStateProvider).valueOrNull;
    final workload = ref.watch(workloadStateProvider).valueOrNull;
    final eta = ref.watch(etaStateProvider).valueOrNull;
    final recovery = ref.watch(shiftRecoveryProvider);
    final insights =
        ref.watch(unusualInsightsProvider).valueOrNull ?? const [];
    final simulator = ref.watch(simulatorProvider);
    final snapshot = _HomeSnapshot.from(
      tick,
      risk,
      workload,
      eta,
      recovery,
      insights.isEmpty ? null : insights.first,
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840;
            final horizontalPadding = wide ? 28.0 : 18.0;
            return Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                18,
                horizontalPadding,
                18,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: wide
                        ? _WideDashboard(snapshot: snapshot)
                        : _CompactDashboard(snapshot: snapshot),
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

class _HomeSnapshot {
  const _HomeSnapshot({
    required this.tick,
    required this.mode,
    required this.taskName,
    required this.zone,
    required this.progress,
    required this.etaMinutes,
    required this.etaExplanation,
    required this.paceSummary,
    required this.paceAhead,
    required this.latestInsight,
    required this.riskLevel,
    required this.safetyAction,
    required this.workerDistance,
    required this.seatbelt,
    required this.fuelPct,
    required this.loadPct,
    required this.engineHours,
    required this.idleMinutes,
    required this.workloadLevel,
    required this.live,
  });

  final TelemetryTick? tick;
  final MachineMode mode;
  final String taskName;
  final String zone;
  final double progress;
  final int etaMinutes;
  final String? etaExplanation;
  final String paceSummary;
  final bool paceAhead;
  final BehaviourInsight? latestInsight;
  final AlertLevel riskLevel;
  final String safetyAction;
  final double workerDistance;
  final bool seatbelt;
  final double fuelPct;
  final double loadPct;
  final double engineHours;
  final double idleMinutes;
  final WorkloadLevel workloadLevel;
  final bool live;

  factory _HomeSnapshot.from(
    TelemetryTick? tick,
    RiskState? risk,
    WorkloadState? workload,
    EtaState? eta,
    ShiftRecoveryState? recovery,
    BehaviourInsight? latestInsight,
  ) {
    if (tick == null) {
      return const _HomeSnapshot(
        tick: null,
        mode: MachineMode.dig,
        taskName: 'Trenching',
        zone: 'Zone B · East cut',
        progress: 71,
        etaMinutes: 24,
        etaExplanation: null,
        paceSummary: 'ON PACE WITH SHIFT BASELINE',
        paceAhead: true,
        latestInsight: null,
        riskLevel: AlertLevel.info,
        safetyAction: 'No immediate hazards',
        workerDistance: 14,
        seatbelt: true,
        fuelPct: 67,
        loadPct: 42,
        engineHours: 1530.2,
        idleMinutes: 6,
        workloadLevel: WorkloadLevel.normal,
        live: false,
      );
    }

    final taskName = switch (tick.mode) {
      MachineMode.dig => 'Trenching',
      MachineMode.lift => 'Pipe lift',
      MachineMode.load => 'Truck loading',
      MachineMode.grade => 'Final grading',
    };
    final previewEta = ((100 - tick.progressPct) * 0.34).clamp(3, 45).round();
    final liveEta = eta == null || eta.etaRemainingMin <= 0
        ? previewEta
        : eta.etaRemainingMin.clamp(1, 180).round();
    return _HomeSnapshot(
      tick: tick,
      mode: tick.mode,
      taskName: taskName,
      zone: tick.mode == MachineMode.lift
          ? 'Zone B · Lift corridor'
          : 'Zone B · East cut',
      progress: tick.progressPct,
      etaMinutes: liveEta,
      etaExplanation: eta?.explanation,
      paceSummary: recovery?.summary.toUpperCase() ??
          'ON PACE WITH SHIFT BASELINE',
      paceAhead: recovery?.isAhead ?? true,
      latestInsight: latestInsight,
      riskLevel: risk?.level ?? AlertLevel.info,
      safetyAction: risk?.primaryHazard == null
          ? 'No immediate hazards'
          : risk!.action,
      workerDistance: tick.nearestPersonM,
      seatbelt: tick.seatbelt,
      fuelPct: tick.fuelPct,
      loadPct: tick.loadPct,
      engineHours: tick.engineHours,
      idleMinutes: tick.idleMin,
      workloadLevel: workload?.level ?? WorkloadLevel.normal,
      live: true,
    );
  }
}

class _WideDashboard extends StatelessWidget {
  const _WideDashboard({required this.snapshot});

  final _HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            children: [
              _StatusBand(snapshot: snapshot),
              const SizedBox(height: 12),
              Expanded(flex: 6, child: _CurrentTask(snapshot: snapshot)),
              const SizedBox(height: 12),
              Expanded(
                flex: 3,
                child: snapshot.tick != null
                    ? TaskUiCoordinator(tick: snapshot.tick!)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 18),
        SizedBox(width: 330, child: _ShiftRail(snapshot: snapshot)),
      ],
    );
  }
}

class _CompactDashboard extends StatelessWidget {
  const _CompactDashboard({required this.snapshot});

  final _HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _StatusBand(snapshot: snapshot),
        const SizedBox(height: 12),
        SizedBox(height: 300, child: _CurrentTask(snapshot: snapshot)),
        const SizedBox(height: 12),
        if (snapshot.tick != null) TaskUiCoordinator(tick: snapshot.tick!),
        const SizedBox(height: 18),
        _ShiftRail(snapshot: snapshot),
      ],
    );
  }
}

class _StatusBand extends StatelessWidget {
  const _StatusBand({required this.snapshot});

  final _HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(snapshot.riskLevel);
    final label = switch (snapshot.riskLevel) {
      AlertLevel.info => 'SAFE TO OPERATE',
      AlertLevel.attention => 'ATTENTION',
      AlertLevel.action => 'ACTION REQUIRED',
      AlertLevel.critical => 'STOP — CRITICAL RISK',
    };
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            snapshot.riskLevel == AlertLevel.info
                ? Icons.verified_rounded
                : Icons.warning_rounded,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  snapshot.safetyAction,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          _CompactPill(
            label: 'WORKLOAD',
            value: snapshot.workloadLevel.label,
            dark: true,
          ),
        ],
      ),
    );
  }
}

class _CurrentTask extends StatelessWidget {
  const _CurrentTask({required this.snapshot});

  final _HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 840;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: CatTheme.panel,
        border: Border.all(color: CatTheme.divider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ModeBadge(mode: snapshot.mode),
              const SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: snapshot.live
                                ? CatTheme.safe
                                : CatTheme.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          snapshot.live ? 'LIVE TELEMETRY' : 'DEMO PREVIEW',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            snapshot.taskName,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 5),
          Text(
            snapshot.zone,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: CatTheme.textMuted),
          ),
          const Spacer(),
          if (compact)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ProgressValue(progress: snapshot.progress),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'COMPLETE',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '${snapshot.etaMinutes} MIN LEFT',
                          style: const TextStyle(
                            color: CatTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ProgressValue(progress: snapshot.progress),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    'COMPLETE',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'EST. REMAINING',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      '${snapshot.etaMinutes} min',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: snapshot.progress / 100,
              backgroundColor: CatTheme.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(CatTheme.yellow),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                snapshot.paceAhead
                    ? Icons.trending_flat_rounded
                    : Icons.trending_up_rounded,
                color: snapshot.paceAhead ? CatTheme.safe : CatTheme.attention,
                size: 20,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  snapshot.etaExplanation ?? snapshot.paceSummary,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: snapshot.paceAhead
                        ? CatTheme.safe
                        : CatTheme.attention,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressValue extends StatelessWidget {
  const _ProgressValue({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${progress.toStringAsFixed(0)}%',
      style: const TextStyle(
        color: CatTheme.yellow,
        fontSize: 44,
        height: 1,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.5,
      ),
    );
  }
}


class _ShiftRail extends StatelessWidget {
  const _ShiftRail({required this.snapshot});

  final _HomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CatTheme.panelRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CatTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Shift brief',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 5),
          Text(
            'What changed since your last shift',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          const _BriefRow(
            icon: Icons.water_drop_outlined,
            title: 'Ground conditions',
            detail: 'Zone B is softer than yesterday',
            emphasis: true,
          ),
          const _BriefRow(
            icon: Icons.cloud_outlined,
            title: 'Weather',
            detail: 'Rain expected around 15:00',
          ),
          const _BriefRow(
            icon: Icons.map_outlined,
            title: 'Work zone',
            detail: 'East boundary moved 120 m',
          ),
          const Divider(height: 28),
          Text('Today', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _TaskRow(
            time: 'NOW',
            title: snapshot.taskName,
            status: '${snapshot.progress.toStringAsFixed(0)}%',
            active: true,
          ),
          const _TaskRow(time: '11:20', title: 'Pipe lift', status: '45 min'),
          const _TaskRow(time: '12:15', title: 'Final grade', status: '35 min'),
          const SizedBox(height: 20),
          if (snapshot.latestInsight != null) ...[
            _InsightHint(insight: snapshot.latestInsight!),
            const SizedBox(height: 10),
          ],
          const _HandoverHint(),
        ],
      ),
    );
  }
}


class _ModeBadge extends StatelessWidget {
  const _ModeBadge({required this.mode});

  final MachineMode mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: CatTheme.yellow,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        'EXCAVATOR · ${mode.label}',
        style: const TextStyle(
          color: CatTheme.black,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _CompactPill extends StatelessWidget {
  const _CompactPill({
    required this.label,
    required this.value,
    this.dark = false,
  });

  final String label;
  final String value;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: dark ? Colors.black.withValues(alpha: 0.22) : CatTheme.panel,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              color: dark ? Colors.white70 : CatTheme.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BriefRow extends StatelessWidget {
  const _BriefRow({
    required this.icon,
    required this.title,
    required this.detail,
    this.emphasis = false,
  });

  final IconData icon;
  final String title;
  final String detail;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: emphasis ? CatTheme.yellow : CatTheme.textMuted,
            size: 22,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CatTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(detail, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.time,
    required this.title,
    required this.status,
    this.active = false,
  });

  final String time;
  final String title;
  final String status;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CatTheme.divider)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              time,
              style: TextStyle(
                color: active ? CatTheme.yellow : CatTheme.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: CatTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(status, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _InsightHint extends StatelessWidget {
  const _InsightHint({required this.insight});

  final BehaviourInsight insight;

  @override
  Widget build(BuildContext context) {
    final action = insight.priority == InsightPriority.action;
    final color = action ? CatTheme.action : CatTheme.yellow;
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => context.go('/learn'),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                action ? Icons.warning_rounded : Icons.lightbulb_rounded,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CatTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      insight.recommendedAction,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: CatTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _HandoverHint extends StatelessWidget {
  const _HandoverHint();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CatTheme.black,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => context.push('/handover'),
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.assignment_turned_in_outlined,
                color: CatTheme.yellow,
                size: 20,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'End Shift / Generate Handover',
                  style: TextStyle(
                    color: CatTheme.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      color: CatTheme.critical,
      child: Text(
        '$message. Check the scenario asset and try again.',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

Color _riskColor(AlertLevel level) => switch (level) {
  AlertLevel.info => CatTheme.safe,
  AlertLevel.attention => CatTheme.attention,
  AlertLevel.action => CatTheme.action,
  AlertLevel.critical => CatTheme.critical,
};
