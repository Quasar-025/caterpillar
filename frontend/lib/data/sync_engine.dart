import 'dart:convert';

import 'database.dart';
import 'sync_models.dart';

class SyncEngine {
  SyncEngine(this.db, this.api);

  final AppDatabase db;
  final SyncApi api;

  static const cursorKey = 'global';

  Future<void> enqueue({
    required String entity,
    required String recordId,
    required String op,
    required DateTime updatedAt,
    required Map<String, dynamic> payload,
  }) {
    return db.into(db.outboxEntries).insert(
          OutboxEntriesCompanion.insert(
            entity: entity,
            recordId: recordId,
            op: op,
            payloadJson: jsonEncode(payload),
            updatedAt: updatedAt,
            createdAt: DateTime.now().toUtc(),
          ),
        );
  }

  Future<void> saveTask(Task row) async {
    await db.into(db.tasks).insertOnConflictUpdate(row);
    await enqueue(
      entity: 'task',
      recordId: row.id,
      op: row.deletedAt == null ? 'upsert' : 'delete',
      updatedAt: row.updatedAt,
      payload: taskToPayload(row),
    );
  }

  Future<void> saveShift(Shift row) async {
    await db.into(db.shifts).insertOnConflictUpdate(row);
    await enqueue(
      entity: 'shift',
      recordId: row.id,
      op: row.deletedAt == null ? 'upsert' : 'delete',
      updatedAt: row.updatedAt,
      payload: shiftToPayload(row),
    );
  }

  Future<void> saveChecklistItem(ChecklistItem row) async {
    await db.into(db.checklistItems).insertOnConflictUpdate(row);
    await enqueue(
      entity: 'checklist_item',
      recordId: row.id,
      op: row.deletedAt == null ? 'upsert' : 'delete',
      updatedAt: row.updatedAt,
      payload: checklistToPayload(row),
    );
  }

  Future<void> run() async {
    final pending = await db.select(db.outboxEntries).get();
    if (pending.isNotEmpty) {
      await api.push(pending.map(SyncChange.fromOutbox).toList());
      final ids = pending.map((row) => row.id).toList();
      await (db.delete(db.outboxEntries)..where((tbl) => tbl.id.isIn(ids))).go();
    }

    final cursorRow = await (db.select(db.syncCursors)..where((tbl) => tbl.collection.equals(cursorKey)))
        .getSingleOrNull();
    final pulled = await api.pull(cursorRow?.cursor);
    await db.transaction(() async {
      for (final change in pulled.changes) {
        await _apply(change);
      }
      await db.into(db.syncCursors).insertOnConflictUpdate(
            SyncCursorsCompanion.insert(collection: cursorKey, cursor: pulled.cursor),
          );
    });
  }

  Future<DateTime?> _localUpdatedAt(String entity, String id) async {
    switch (entity) {
      case 'task':
        return (await (db.select(db.tasks)..where((tbl) => tbl.id.equals(id))).getSingleOrNull())?.updatedAt;
      case 'shift':
        return (await (db.select(db.shifts)..where((tbl) => tbl.id.equals(id))).getSingleOrNull())?.updatedAt;
      case 'checklist_item':
        return (await (db.select(db.checklistItems)..where((tbl) => tbl.id.equals(id))).getSingleOrNull())
            ?.updatedAt;
      case 'handover':
        return (await (db.select(db.handovers)..where((tbl) => tbl.id.equals(id))).getSingleOrNull())?.updatedAt;
      default:
        return null;
    }
  }

  Future<void> _apply(SyncChange change) async {
    final localUpdated = await _localUpdatedAt(change.entity, change.id);
    if (localUpdated != null && localUpdated.isAfter(change.updatedAt)) {
      return;
    }
    final payload = change.payload;
    if (payload == null) {
      return;
    }
    switch (change.entity) {
      case 'task':
        await db.into(db.tasks).insertOnConflictUpdate(taskFromPayload(payload));
      case 'shift':
        await db.into(db.shifts).insertOnConflictUpdate(shiftFromPayload(payload));
      case 'checklist_item':
        await db.into(db.checklistItems).insertOnConflictUpdate(checklistFromPayload(payload));
      case 'handover':
        await db.into(db.handovers).insertOnConflictUpdate(handoverFromPayload(payload));
    }
  }
}
