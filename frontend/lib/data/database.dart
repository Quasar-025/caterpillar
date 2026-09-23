import 'package:drift/drift.dart';

part 'database.g.dart';

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get taskType => text()();
  TextColumn get machineId => text()();
  TextColumn get machineType => text()();
  TextColumn get operatorId => text()();
  DateTimeColumn get scheduledStart => dateTime()();
  DateTimeColumn get scheduledEnd => dateTime()();
  DateTimeColumn get startTime => dateTime().nullable()();
  DateTimeColumn get endTime => dateTime().nullable()();
  RealColumn get actualDurationMin => real().nullable()();
  RealColumn get plannedQuantity => real().withDefault(const Constant(0))();
  RealColumn get quantityDone => real().withDefault(const Constant(0))();
  RealColumn get progressPct => real().withDefault(const Constant(0))();
  RealColumn get cycleTimeSec => real().withDefault(const Constant(0))();
  IntColumn get cyclesCompleted => integer().withDefault(const Constant(0))();
  RealColumn get groundSoftness => real().withDefault(const Constant(0))();
  RealColumn get rain => real().withDefault(const Constant(0))();
  RealColumn get slopeDeg => real().withDefault(const Constant(0))();
  RealColumn get avgLoadPct => real().withDefault(const Constant(0))();
  BoolColumn get isNight => boolean().withDefault(const Constant(false))();
  RealColumn get idleMin => real().withDefault(const Constant(0))();
  RealColumn get fuelUsedL => real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Shifts extends Table {
  TextColumn get id => text()();
  TextColumn get operatorId => text()();
  TextColumn get machineId => text()();
  DateTimeColumn get scheduledStart => dateTime()();
  DateTimeColumn get scheduledEnd => dateTime()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('planned'))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ChecklistItems extends Table {
  TextColumn get id => text()();
  TextColumn get shiftId => text()();
  TextColumn get category => text()();
  TextColumn get label => text()();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  BoolColumn get required => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Handovers extends Table {
  TextColumn get id => text()();
  TextColumn get shiftId => text()();
  TextColumn get reportJson => text().withDefault(const Constant('{}'))();
  TextColumn get nextTaskId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class OutboxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entity => text()();
  TextColumn get recordId => text()();
  TextColumn get op => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
}

class SyncCursors extends Table {
  TextColumn get collection => text()();
  TextColumn get cursor => text()();

  @override
  Set<Column<Object>> get primaryKey => {collection};
}

@DriftDatabase(
  tables: [Tasks, Shifts, ChecklistItems, Handovers, OutboxEntries, SyncCursors],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
