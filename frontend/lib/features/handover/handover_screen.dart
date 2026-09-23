import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/alert_level.dart';
import '../../core/theme.dart';
import 'handover_providers.dart';
import 'handover_report.dart';

class HandoverScreen extends ConsumerWidget {
  const HandoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(handoverReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SHIFT HANDOVER'),
        backgroundColor: CatTheme.panel,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: CatTheme.black,
      body: reportAsync.when(
        data: (report) => _HandoverBody(report: report),
        loading: () => const Center(
          child: CircularProgressIndicator(color: CatTheme.yellow),
        ),
        error: (error, stack) => Center(
          child: Text('Error generating report: $error',
              style: const TextStyle(color: CatTheme.critical)),
        ),
      ),
    );
  }
}

class _HandoverBody extends StatelessWidget {
  const _HandoverBody({required this.report});

  final HandoverReport report;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(
        CatTheme.pagePadding(MediaQuery.sizeOf(context).width),
      ),
      children: [
        Text(
          'End of Shift Report',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Generated at ${report.generatedAt.hour.toString().padLeft(2, '0')}:${report.generatedAt.minute.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CatTheme.textMuted,
              ),
        ),
        const SizedBox(height: 32),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final taskSection = _Section(
              title: 'Tasks',
              icon: Icons.assignment_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MetricRow(
                    label: 'Completed Tasks',
                    value: report.tasksDone.length.toString(),
                  ),
                  const SizedBox(height: 12),
                  _MetricRow(
                    label: 'Remaining Tasks',
                    value: report.tasksRemaining.length.toString(),
                  ),
                  const SizedBox(height: 16),
                  if (report.nextTask != null) ...[
                    const Text(
                      'Next Task',
                      style: TextStyle(
                        color: CatTheme.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${report.nextTask!.taskType} (${report.nextTask!.progressPct.toStringAsFixed(0)}% done)',
                      style: const TextStyle(
                        color: CatTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            );

            final machineSection = _Section(
              title: 'Machine & Safety',
              icon: Icons.health_and_safety_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MetricRow(label: 'Status', value: report.machineStatus),
                  const SizedBox(height: 16),
                  const Text(
                    'Safety Alerts',
                    style: TextStyle(
                      color: CatTheme.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _AlertCountsRow(counts: report.alertCounts),
                  if (report.unusualBehaviours.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Unusual Behaviours',
                      style: TextStyle(
                        color: CatTheme.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...report.unusualBehaviours.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 6,
                                color: CatTheme.yellow,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  b.name,
                                  style: const TextStyle(
                                    color: CatTheme.textPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ]
                ],
              ),
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: taskSection),
                  const SizedBox(width: 24),
                  Expanded(child: machineSection),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  taskSection,
                  const SizedBox(height: 24),
                  machineSection,
                ],
              );
            }
          },
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

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
        children: [
          Row(
            children: [
              Icon(icon, color: CatTheme.yellow, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CatTheme.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: CatTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _AlertCountsRow extends StatelessWidget {
  const _AlertCountsRow({required this.counts});

  final Map<AlertLevel, int> counts;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _AlertCount(
          level: AlertLevel.attention,
          count: counts[AlertLevel.attention] ?? 0,
        ),
        const SizedBox(width: 12),
        _AlertCount(
          level: AlertLevel.action,
          count: counts[AlertLevel.action] ?? 0,
        ),
        const SizedBox(width: 12),
        _AlertCount(
          level: AlertLevel.critical,
          count: counts[AlertLevel.critical] ?? 0,
        ),
      ],
    );
  }
}

class _AlertCount extends StatelessWidget {
  const _AlertCount({required this.level, required this.count});

  final AlertLevel level;
  final int count;

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      AlertLevel.info => CatTheme.safe,
      AlertLevel.attention => CatTheme.attention,
      AlertLevel.action => CatTheme.action,
      AlertLevel.critical => CatTheme.critical,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            level == AlertLevel.critical
                ? Icons.warning_rounded
                : Icons.info_outline,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
