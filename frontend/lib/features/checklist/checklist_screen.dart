import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import 'checklist_data.dart';
import 'checklist_provider.dart';

/// Pre-shift checklist screen (plan §14).
///
/// Machine walk-around items plus operator safety gear. The "Start Shift"
/// button stays disabled until every required item is checked. Once the
/// shift starts the checklist is locked and the user is navigated to home.
class ChecklistScreen extends ConsumerWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checklistProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840;
            final pad = wide ? 32.0 : 18.0;

            return CustomScrollView(
              slivers: [
                // ── Header ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(pad, 24, pad, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: CatTheme.yellow.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.checklist_rounded,
                                color: CatTheme.yellow,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pre-Shift Inspection',
                                    style: textTheme.headlineLarge,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Complete all items before starting your shift',
                                    style: textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _ProgressBar(state: state),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${state.checkedCount} of ${state.items.length} items checked',
                              style: textTheme.bodyMedium,
                            ),
                            if (!state.shiftStarted)
                              TextButton.icon(
                                onPressed: state.checkedCount > 0
                                    ? () => ref
                                        .read(checklistProvider.notifier)
                                        .uncheckAll()
                                    : null,
                                icon: const Icon(Icons.restart_alt, size: 18),
                                label: const Text('Reset'),
                                style: TextButton.styleFrom(
                                  foregroundColor: CatTheme.textMuted,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // ── Category sections ───────────────────────────────────
                for (final cat in ChecklistCategory.values) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(pad, 8, pad, 8),
                      child: _CategoryHeader(
                        category: cat,
                        state: state,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: pad),
                    sliver: SliverList.builder(
                      itemCount: state.byCategory(cat).length,
                      itemBuilder: (context, index) {
                        final item = state.byCategory(cat)[index];
                        return _ChecklistTile(
                          item: item,
                          locked: state.shiftStarted,
                          onToggle: () => ref
                              .read(checklistProvider.notifier)
                              .toggle(item.template.key),
                        );
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                ],

                // ── Bottom space for the start button ───────────────────
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      // ── Start Shift button (gated) ──────────────────────────────────────
      bottomNavigationBar: _StartShiftBar(
        state: state,
        onStart: () {
          ref.read(checklistProvider.notifier).startShift();
          // Navigate back to home after starting the shift.
          if (context.mounted) {
            Navigator.of(context).maybePop();
          }
        },
        onCheckAll: () => ref.read(checklistProvider.notifier).checkAll(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Progress bar
// ═══════════════════════════════════════════════════════════════════════════

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.state});

  final ChecklistState state;

  @override
  Widget build(BuildContext context) {
    final progress = state.progress;
    final complete = state.allRequiredComplete;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: CatTheme.divider,
            valueColor: AlwaysStoppedAnimation<Color>(
              complete ? CatTheme.safe : CatTheme.yellow,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Category header
// ═══════════════════════════════════════════════════════════════════════════

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.category,
    required this.state,
  });

  final ChecklistCategory category;
  final ChecklistState state;

  @override
  Widget build(BuildContext context) {
    final catItems = state.byCategory(category);
    final checked = catItems.where((i) => i.isChecked).length;
    final total = catItems.length;
    final complete = state.isCategoryComplete(category);

    return Row(
      children: [
        Text(
          category.icon,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            category.label,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: complete
                ? CatTheme.safe.withValues(alpha: 0.15)
                : CatTheme.panelRaised,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            complete ? '✓ Complete' : '$checked / $total',
            style: TextStyle(
              color: complete ? CatTheme.safe : CatTheme.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Checklist tile
// ═══════════════════════════════════════════════════════════════════════════

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.item,
    required this.locked,
    required this.onToggle,
  });

  final ChecklistItemState item;
  final bool locked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final checked = item.isChecked;
    final required = item.template.isRequired;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: checked
            ? CatTheme.safe.withValues(alpha: 0.08)
            : CatTheme.panel,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: locked ? null : onToggle,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Checkbox visual
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: checked ? CatTheme.safe : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: checked ? CatTheme.safe : CatTheme.divider,
                      width: 2,
                    ),
                  ),
                  child: checked
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
                const SizedBox(width: 14),
                // Label
                Expanded(
                  child: Text(
                    item.template.label,
                    style: TextStyle(
                      color: checked
                          ? CatTheme.textMuted
                          : CatTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration:
                          checked ? TextDecoration.lineThrough : null,
                      decorationColor: CatTheme.textMuted,
                    ),
                  ),
                ),
                // Required badge
                if (required && !checked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: CatTheme.action.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Required',
                      style: TextStyle(
                        color: CatTheme.action,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (locked && checked)
                  const Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: CatTheme.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Start Shift bar
// ═══════════════════════════════════════════════════════════════════════════

class _StartShiftBar extends StatelessWidget {
  const _StartShiftBar({
    required this.state,
    required this.onStart,
    required this.onCheckAll,
  });

  final ChecklistState state;
  final VoidCallback onStart;
  final VoidCallback onCheckAll;

  @override
  Widget build(BuildContext context) {
    final canStart = state.allRequiredComplete && !state.shiftStarted;
    final alreadyStarted = state.shiftStarted;

    return Container(
      decoration: BoxDecoration(
        color: CatTheme.panel,
        border: const Border(
          top: BorderSide(color: CatTheme.divider),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Quick-check-all for demo convenience
            if (!alreadyStarted && !state.allRequiredComplete)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: OutlinedButton.icon(
                  onPressed: onCheckAll,
                  icon: const Icon(Icons.done_all, size: 18),
                  label: const Text('Check All'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CatTheme.textMuted,
                    side: const BorderSide(color: CatTheme.divider),
                    minimumSize: const Size(64, 56),
                  ),
                ),
              ),
            Expanded(
              child: FilledButton.icon(
                onPressed: canStart ? onStart : null,
                icon: Icon(
                  alreadyStarted
                      ? Icons.check_circle
                      : Icons.play_arrow_rounded,
                  size: 24,
                ),
                label: Text(
                  alreadyStarted ? 'Shift Started' : 'Start Shift',
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  backgroundColor:
                      canStart ? CatTheme.safe : CatTheme.panelRaised,
                  foregroundColor:
                      canStart ? Colors.white : CatTheme.textMuted,
                  disabledBackgroundColor: CatTheme.panelRaised,
                  disabledForegroundColor: CatTheme.textMuted,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
