import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme.dart';
import '../../domain/unusual_behaviour.dart';
import '../../domain/unusual_providers.dart';
import 'training_catalog.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights =
        ref.watch(unusualInsightsProvider).valueOrNull ?? const [];
    final modules = recommendedTrainingFor(insights);

    return Scaffold(
      appBar: AppBar(title: const Text('LEARN')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final columns = wide ? 2 : 1;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Cat Operator Training',
                      subtitle:
                          'Official Next Gen excavator videos and courses',
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  sliver: SliverList.separated(
                    itemCount: modules.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _TrainingTile(module: modules[index]);
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  sliver: SliverToBoxAdapter(
                    child: _Summary(insights: insights),
                  ),
                ),
                if (insights.isEmpty)
                  const SliverToBoxAdapter(child: _EmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 305,
                      ),
                      itemCount: insights.length,
                      itemBuilder: (context, index) {
                        return _RecommendationCard(insight: insights[index]);
                      },
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 6, height: 42, color: CatTheme.yellow),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineLarge),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrainingTile extends StatelessWidget {
  const _TrainingTile({required this.module});

  final TrainingModule module;

  Future<void> _open() async {
    await launchUrl(module.url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CatTheme.panel,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _open,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: CatTheme.yellow.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  module.format == TrainingFormat.video
                      ? Icons.play_circle_fill_rounded
                      : Icons.menu_book_rounded,
                  color: CatTheme.yellow,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          module.formatLabel,
                          style: const TextStyle(
                            color: CatTheme.yellow,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const Text(
                          'CAT OPERATOR TRAINING',
                          style: TextStyle(
                            color: CatTheme.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      module.summary,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new_rounded, color: CatTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.insights});

  final List<BehaviourInsight> insights;

  @override
  Widget build(BuildContext context) {
    final actionCount = insights
        .where((item) => item.priority == InsightPriority.action)
        .length;
    return Row(
      children: [
        Container(width: 6, height: 42, color: CatTheme.yellow),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Operator recommendations',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                insights.isEmpty
                    ? 'Live telemetry is within your normal baseline'
                    : '${insights.length} insight${insights.length == 1 ? '' : 's'} · '
                        '$actionCount requiring action',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.insight});

  final BehaviourInsight insight;

  @override
  Widget build(BuildContext context) {
    final action = insight.priority == InsightPriority.action;
    final color = action ? CatTheme.action : CatTheme.yellow;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CatTheme.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                action ? Icons.warning_rounded : Icons.lightbulb_rounded,
                color: color,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  insight.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                action ? 'ACTION' : 'COACHING',
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Detail(label: 'WHAT HAPPENED', value: insight.whatHappened),
          _Detail(label: 'LIKELY REASON', value: insight.likelyReason),
          _Detail(label: 'RECOMMENDED', value: insight.recommendedAction),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.savings_outlined, color: color, size: 18),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  insight.impact,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$label  ',
              style: const TextStyle(
                color: CatTheme.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: CatTheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: CatTheme.panel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CatTheme.divider),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.verified_rounded,
              color: CatTheme.safe,
              size: 36,
            ),
            const SizedBox(height: 10),
            Text(
              'No unusual patterns detected',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Start with the Cat Operator Training videos above. '
              'Live recommendations appear here when telemetry leaves baseline.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
