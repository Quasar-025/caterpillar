import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_providers.dart';
import '../../data/database.dart' as db;
import '../../data/sync_engine.dart';
import 'checklist_data.dart';
import 'checklist_provider.dart';

class ChecklistSync {
  ChecklistSync(this._syncEngine);

  static const shiftId = 'SHIFT-DEMO-001';
  final SyncEngine _syncEngine;
  Future<void> _pending = Future.value();

  Future<void> save(ChecklistState state) {
    _pending = _pending.then((_) => _saveNow(state));
    return _pending;
  }

  Future<ChecklistState?> load() async {
    try {
      await _syncEngine.run();
      final database = _syncEngine.db;
      final rows = await (database.select(database.checklistItems)
            ..where((item) => item.shiftId.equals(shiftId)))
          .get();
      if (rows.isEmpty) return null;

      final checkedById = {
        for (final row in rows) row.id: row.checked,
      };
      final shift = await (database.select(database.shifts)
            ..where((row) => row.id.equals(shiftId)))
          .getSingleOrNull();
      return ChecklistState(
        items: [
          for (final template in defaultChecklistItems)
            ChecklistItemState(
              template: template,
              isChecked: checkedById['$shiftId-${template.key}'] ?? false,
            ),
        ],
        shiftStarted: shift?.status == 'active',
      );
    } on Object {
      return null;
    }
  }

  Future<void> _saveNow(ChecklistState state) async {
    final now = DateTime.now().toUtc();
    for (final item in state.items) {
      await _syncEngine.saveChecklistItem(
        db.ChecklistItem(
          id: '$shiftId-${item.template.key}',
          shiftId: shiftId,
          category: item.template.category.name,
          label: item.template.label,
          checked: item.isChecked,
          required: item.template.isRequired,
          updatedAt: now,
        ),
      );
    }

    if (state.shiftStarted) {
      await _syncEngine.saveShift(
        db.Shift(
          id: shiftId,
          operatorId: 'OP001',
          machineId: 'EXC001',
          scheduledStart: now,
          scheduledEnd: now.add(const Duration(hours: 8)),
          startedAt: now,
          status: 'active',
          updatedAt: now,
        ),
      );
    }

    try {
      await _syncEngine.run();
    } on Object {
      // Local rows and outbox entries remain available for the next sync.
    }
  }
}

final checklistSyncProvider = Provider<ChecklistSync>((ref) {
  return ChecklistSync(ref.watch(syncEngineProvider));
});
