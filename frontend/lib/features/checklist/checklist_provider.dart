import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'checklist_data.dart';
import 'checklist_sync.dart';

/// Tracks the live state of a single checklist item.
class ChecklistItemState {
  const ChecklistItemState({
    required this.template,
    required this.isChecked,
  });

  final ChecklistTemplate template;
  final bool isChecked;

  ChecklistItemState copyWith({bool? isChecked}) {
    return ChecklistItemState(
      template: template,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

/// The full checklist state for a shift.
class ChecklistState {
  const ChecklistState({
    required this.items,
    required this.shiftStarted,
  });

  final List<ChecklistItemState> items;
  final bool shiftStarted;

  /// All required items are checked.
  bool get allRequiredComplete => items
      .where((i) => i.template.isRequired)
      .every((i) => i.isChecked);

  /// Progress as fraction 0.0 – 1.0 across all items.
  double get progress {
    if (items.isEmpty) return 0;
    return items.where((i) => i.isChecked).length / items.length;
  }

  /// Number of checked items.
  int get checkedCount => items.where((i) => i.isChecked).length;

  /// Items in a specific category.
  List<ChecklistItemState> byCategory(ChecklistCategory cat) =>
      items.where((i) => i.template.category == cat).toList();

  /// Whether a specific category is fully complete.
  bool isCategoryComplete(ChecklistCategory cat) =>
      byCategory(cat).every((i) => i.isChecked);

  /// Fraction complete for a category.
  double categoryProgress(ChecklistCategory cat) {
    final catItems = byCategory(cat);
    if (catItems.isEmpty) return 0;
    return catItems.where((i) => i.isChecked).length / catItems.length;
  }
}

/// Manages the pre-shift checklist state.
///
/// Initialises from [defaultChecklistItems] and provides toggle + reset.
/// The "Start shift" button is only enabled when [allRequiredComplete].
class ChecklistNotifier extends StateNotifier<ChecklistState> {
  ChecklistNotifier({
    Future<void> Function(ChecklistState)? onChanged,
    Future<ChecklistState?> Function()? load,
  })
      : _onChanged = onChanged,
        super(ChecklistState(
          items: defaultChecklistItems
              .map((t) => ChecklistItemState(template: t, isChecked: false))
              .toList(),
          shiftStarted: false,
        )) {
    if (load != null) unawaited(_hydrate(load));
  }

  final Future<void> Function(ChecklistState)? _onChanged;
  bool _changedLocally = false;

  Future<void> _hydrate(Future<ChecklistState?> Function() load) async {
    final stored = await load();
    if (stored != null && !_changedLocally) state = stored;
  }

  void _persist() {
    _changedLocally = true;
    final callback = _onChanged;
    if (callback != null) unawaited(callback(state));
  }

  /// Toggle one item on/off.
  void toggle(String key) {
    if (state.shiftStarted) return; // Lock after shift start.
    state = ChecklistState(
      items: [
        for (final item in state.items)
          if (item.template.key == key)
            item.copyWith(isChecked: !item.isChecked)
          else
            item,
      ],
      shiftStarted: state.shiftStarted,
    );
    _persist();
  }

  /// Check all items at once (convenience for demo).
  void checkAll() {
    if (state.shiftStarted) return;
    state = ChecklistState(
      items: [
        for (final item in state.items) item.copyWith(isChecked: true),
      ],
      shiftStarted: state.shiftStarted,
    );
    _persist();
  }

  /// Uncheck all items (reset).
  void uncheckAll() {
    if (state.shiftStarted) return;
    state = ChecklistState(
      items: [
        for (final item in state.items) item.copyWith(isChecked: false),
      ],
      shiftStarted: state.shiftStarted,
    );
    _persist();
  }

  /// Mark shift as started — locks the checklist.
  void startShift() {
    if (!state.allRequiredComplete) return;
    state = ChecklistState(
      items: state.items,
      shiftStarted: true,
    );
    _persist();
  }

  /// Full reset (e.g. new shift).
  void reset() {
    state = ChecklistState(
      items: defaultChecklistItems
          .map((t) => ChecklistItemState(template: t, isChecked: false))
          .toList(),
      shiftStarted: false,
    );
    _persist();
  }
}

// ── Providers ──────────────────────────────────────────────────────────────

final checklistProvider =
    StateNotifierProvider<ChecklistNotifier, ChecklistState>((ref) {
  final sync = ref.watch(checklistSyncProvider);
  return ChecklistNotifier(onChanged: sync.save, load: sync.load);
});

/// Convenience — whether the shift can start.
final canStartShiftProvider = Provider<bool>((ref) {
  final checklist = ref.watch(checklistProvider);
  return checklist.allRequiredComplete && !checklist.shiftStarted;
});

/// Whether the shift has been started (checklist locked).
final shiftStartedProvider = Provider<bool>((ref) {
  return ref.watch(checklistProvider).shiftStarted;
});
