import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/database.dart';
import 'package:frontend/data/sync_engine.dart';
import 'package:frontend/data/sync_models.dart';

class _MemoryApi implements SyncApi {
  final List<SyncChange> pushed = [];
  List<SyncChange> remote = [];
  String cursor = '2025-05-01T00:00:00.000';

  @override
  Future<void> push(List<SyncChange> changes) async {
    pushed.addAll(changes);
    remote = [...remote, ...changes];
  }

  @override
  Future<PullResult> pull(String? since) async {
    final sinceAt = since == null ? null : DateTime.parse(since);
    final changes = remote.where((change) {
      return sinceAt == null || change.updatedAt.isAfter(sinceAt);
    }).toList();
    return PullResult(cursor: cursor, changes: changes);
  }
}

AppDatabase _memoryDatabase() => AppDatabase(NativeDatabase.memory());

Task _task({
  required String id,
  required double progress,
  required DateTime updatedAt,
}) {
  return Task(
    id: id,
    taskType: 'trenching',
    machineId: 'EXC001',
    machineType: 'EXCAVATOR',
    operatorId: 'OP1001',
    scheduledStart: DateTime.parse('2025-05-01T08:00:00'),
    scheduledEnd: DateTime.parse('2025-05-01T11:00:00'),
    plannedQuantity: 40,
    quantityDone: 4,
    progressPct: progress,
    cycleTimeSec: 22,
    cyclesCompleted: 8,
    groundSoftness: 0.2,
    rain: 0,
    slopeDeg: 3,
    avgLoadPct: 0.4,
    isNight: false,
    idleMin: 5,
    fuelUsedL: 3.1,
    updatedAt: updatedAt,
  );
}

void main() {
  test('local writes go through the outbox and up to the cloud', () async {
    final db = _memoryDatabase();
    addTearDown(db.close);
    final api = _MemoryApi();
    final sync = SyncEngine(db, api);
    await sync.saveTask(_task(id: 'T1', progress: 15, updatedAt: DateTime.parse('2025-05-01T08:10:00')));
    await sync.run();

    expect(api.pushed, hasLength(1));
    expect(api.pushed.first.id, 'T1');
    expect(await sync.db.select(sync.db.outboxEntries).get(), isEmpty);
  });

  test('checklist and shift start sync through the same outbox', () async {
    final db = _memoryDatabase();
    addTearDown(db.close);
    final api = _MemoryApi();
    final sync = SyncEngine(db, api);
    final updatedAt = DateTime.parse('2025-05-01T07:55:00Z');

    await sync.saveChecklistItem(
      ChecklistItem(
        id: 'SHIFT-1-hard_hat',
        shiftId: 'SHIFT-1',
        category: 'safetyGear',
        label: 'Hard hat worn',
        checked: true,
        required: true,
        updatedAt: updatedAt,
      ),
    );
    await sync.saveShift(
      Shift(
        id: 'SHIFT-1',
        operatorId: 'OP1001',
        machineId: 'EXC001',
        scheduledStart: updatedAt,
        scheduledEnd: updatedAt.add(const Duration(hours: 8)),
        startedAt: updatedAt,
        status: 'active',
        updatedAt: updatedAt,
      ),
    );
    await sync.run();

    expect(
      api.pushed.map((change) => change.entity),
      containsAll(['checklist_item', 'shift']),
    );
    expect(await db.select(db.outboxEntries).get(), isEmpty);
  });

  test('newer local rows are not overwritten by an older pull', () async {
    final db = _memoryDatabase();
    addTearDown(db.close);
    final api = _MemoryApi()
      ..remote = [
        SyncChange(
          entity: 'task',
          id: 'T1',
          op: 'upsert',
          updatedAt: DateTime.parse('2025-05-01T08:00:00'),
          payload: taskToPayload(
            _task(id: 'T1', progress: 10, updatedAt: DateTime.parse('2025-05-01T08:00:00')),
          ),
        ),
      ];
    final sync = SyncEngine(db, api);
    await db.into(db.tasks).insert(
          _task(id: 'T1', progress: 70, updatedAt: DateTime.parse('2025-05-01T08:20:00')),
        );
    await sync.run();

    final stored = await (db.select(db.tasks)..where((tbl) => tbl.id.equals('T1'))).getSingle();
    expect(stored.progressPct, 70);
  });

  test('pull applies a newer cloud task', () async {
    final db = _memoryDatabase();
    addTearDown(db.close);
    final newer = _task(id: 'T9', progress: 91, updatedAt: DateTime.parse('2025-05-01T09:00:00'));
    final api = _MemoryApi()
      ..remote = [
        SyncChange(
          entity: 'task',
          id: 'T9',
          op: 'upsert',
          updatedAt: newer.updatedAt,
          payload: taskToPayload(newer),
        ),
      ];
    final sync = SyncEngine(db, api);
    await sync.run();
    final stored = await (db.select(db.tasks)..where((tbl) => tbl.id.equals('T9'))).getSingle();
    expect(stored.progressPct, 91);
  });
}
