// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskTypeMeta = const VerificationMeta(
    'taskType',
  );
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
    'task_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _machineIdMeta = const VerificationMeta(
    'machineId',
  );
  @override
  late final GeneratedColumn<String> machineId = GeneratedColumn<String>(
    'machine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _machineTypeMeta = const VerificationMeta(
    'machineType',
  );
  @override
  late final GeneratedColumn<String> machineType = GeneratedColumn<String>(
    'machine_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatorIdMeta = const VerificationMeta(
    'operatorId',
  );
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
    'operator_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledStartMeta = const VerificationMeta(
    'scheduledStart',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledStart =
      GeneratedColumn<DateTime>(
        'scheduled_start',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _scheduledEndMeta = const VerificationMeta(
    'scheduledEnd',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledEnd = GeneratedColumn<DateTime>(
    'scheduled_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualDurationMinMeta = const VerificationMeta(
    'actualDurationMin',
  );
  @override
  late final GeneratedColumn<double> actualDurationMin =
      GeneratedColumn<double>(
        'actual_duration_min',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _plannedQuantityMeta = const VerificationMeta(
    'plannedQuantity',
  );
  @override
  late final GeneratedColumn<double> plannedQuantity = GeneratedColumn<double>(
    'planned_quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quantityDoneMeta = const VerificationMeta(
    'quantityDone',
  );
  @override
  late final GeneratedColumn<double> quantityDone = GeneratedColumn<double>(
    'quantity_done',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _progressPctMeta = const VerificationMeta(
    'progressPct',
  );
  @override
  late final GeneratedColumn<double> progressPct = GeneratedColumn<double>(
    'progress_pct',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cycleTimeSecMeta = const VerificationMeta(
    'cycleTimeSec',
  );
  @override
  late final GeneratedColumn<double> cycleTimeSec = GeneratedColumn<double>(
    'cycle_time_sec',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cyclesCompletedMeta = const VerificationMeta(
    'cyclesCompleted',
  );
  @override
  late final GeneratedColumn<int> cyclesCompleted = GeneratedColumn<int>(
    'cycles_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _groundSoftnessMeta = const VerificationMeta(
    'groundSoftness',
  );
  @override
  late final GeneratedColumn<double> groundSoftness = GeneratedColumn<double>(
    'ground_softness',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rainMeta = const VerificationMeta('rain');
  @override
  late final GeneratedColumn<double> rain = GeneratedColumn<double>(
    'rain',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _slopeDegMeta = const VerificationMeta(
    'slopeDeg',
  );
  @override
  late final GeneratedColumn<double> slopeDeg = GeneratedColumn<double>(
    'slope_deg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _avgLoadPctMeta = const VerificationMeta(
    'avgLoadPct',
  );
  @override
  late final GeneratedColumn<double> avgLoadPct = GeneratedColumn<double>(
    'avg_load_pct',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isNightMeta = const VerificationMeta(
    'isNight',
  );
  @override
  late final GeneratedColumn<bool> isNight = GeneratedColumn<bool>(
    'is_night',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_night" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _idleMinMeta = const VerificationMeta(
    'idleMin',
  );
  @override
  late final GeneratedColumn<double> idleMin = GeneratedColumn<double>(
    'idle_min',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fuelUsedLMeta = const VerificationMeta(
    'fuelUsedL',
  );
  @override
  late final GeneratedColumn<double> fuelUsedL = GeneratedColumn<double>(
    'fuel_used_l',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskType,
    machineId,
    machineType,
    operatorId,
    scheduledStart,
    scheduledEnd,
    startTime,
    endTime,
    actualDurationMin,
    plannedQuantity,
    quantityDone,
    progressPct,
    cycleTimeSec,
    cyclesCompleted,
    groundSoftness,
    rain,
    slopeDeg,
    avgLoadPct,
    isNight,
    idleMin,
    fuelUsedL,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_type')) {
      context.handle(
        _taskTypeMeta,
        taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_taskTypeMeta);
    }
    if (data.containsKey('machine_id')) {
      context.handle(
        _machineIdMeta,
        machineId.isAcceptableOrUnknown(data['machine_id']!, _machineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_machineIdMeta);
    }
    if (data.containsKey('machine_type')) {
      context.handle(
        _machineTypeMeta,
        machineType.isAcceptableOrUnknown(
          data['machine_type']!,
          _machineTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_machineTypeMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
        _operatorIdMeta,
        operatorId.isAcceptableOrUnknown(data['operator_id']!, _operatorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_operatorIdMeta);
    }
    if (data.containsKey('scheduled_start')) {
      context.handle(
        _scheduledStartMeta,
        scheduledStart.isAcceptableOrUnknown(
          data['scheduled_start']!,
          _scheduledStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledStartMeta);
    }
    if (data.containsKey('scheduled_end')) {
      context.handle(
        _scheduledEndMeta,
        scheduledEnd.isAcceptableOrUnknown(
          data['scheduled_end']!,
          _scheduledEndMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledEndMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('actual_duration_min')) {
      context.handle(
        _actualDurationMinMeta,
        actualDurationMin.isAcceptableOrUnknown(
          data['actual_duration_min']!,
          _actualDurationMinMeta,
        ),
      );
    }
    if (data.containsKey('planned_quantity')) {
      context.handle(
        _plannedQuantityMeta,
        plannedQuantity.isAcceptableOrUnknown(
          data['planned_quantity']!,
          _plannedQuantityMeta,
        ),
      );
    }
    if (data.containsKey('quantity_done')) {
      context.handle(
        _quantityDoneMeta,
        quantityDone.isAcceptableOrUnknown(
          data['quantity_done']!,
          _quantityDoneMeta,
        ),
      );
    }
    if (data.containsKey('progress_pct')) {
      context.handle(
        _progressPctMeta,
        progressPct.isAcceptableOrUnknown(
          data['progress_pct']!,
          _progressPctMeta,
        ),
      );
    }
    if (data.containsKey('cycle_time_sec')) {
      context.handle(
        _cycleTimeSecMeta,
        cycleTimeSec.isAcceptableOrUnknown(
          data['cycle_time_sec']!,
          _cycleTimeSecMeta,
        ),
      );
    }
    if (data.containsKey('cycles_completed')) {
      context.handle(
        _cyclesCompletedMeta,
        cyclesCompleted.isAcceptableOrUnknown(
          data['cycles_completed']!,
          _cyclesCompletedMeta,
        ),
      );
    }
    if (data.containsKey('ground_softness')) {
      context.handle(
        _groundSoftnessMeta,
        groundSoftness.isAcceptableOrUnknown(
          data['ground_softness']!,
          _groundSoftnessMeta,
        ),
      );
    }
    if (data.containsKey('rain')) {
      context.handle(
        _rainMeta,
        rain.isAcceptableOrUnknown(data['rain']!, _rainMeta),
      );
    }
    if (data.containsKey('slope_deg')) {
      context.handle(
        _slopeDegMeta,
        slopeDeg.isAcceptableOrUnknown(data['slope_deg']!, _slopeDegMeta),
      );
    }
    if (data.containsKey('avg_load_pct')) {
      context.handle(
        _avgLoadPctMeta,
        avgLoadPct.isAcceptableOrUnknown(
          data['avg_load_pct']!,
          _avgLoadPctMeta,
        ),
      );
    }
    if (data.containsKey('is_night')) {
      context.handle(
        _isNightMeta,
        isNight.isAcceptableOrUnknown(data['is_night']!, _isNightMeta),
      );
    }
    if (data.containsKey('idle_min')) {
      context.handle(
        _idleMinMeta,
        idleMin.isAcceptableOrUnknown(data['idle_min']!, _idleMinMeta),
      );
    }
    if (data.containsKey('fuel_used_l')) {
      context.handle(
        _fuelUsedLMeta,
        fuelUsedL.isAcceptableOrUnknown(data['fuel_used_l']!, _fuelUsedLMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_type'],
      )!,
      machineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_id'],
      )!,
      machineType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_type'],
      )!,
      operatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operator_id'],
      )!,
      scheduledStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_start'],
      )!,
      scheduledEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_end'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      actualDurationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_duration_min'],
      ),
      plannedQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}planned_quantity'],
      )!,
      quantityDone: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_done'],
      )!,
      progressPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress_pct'],
      )!,
      cycleTimeSec: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cycle_time_sec'],
      )!,
      cyclesCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycles_completed'],
      )!,
      groundSoftness: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ground_softness'],
      )!,
      rain: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rain'],
      )!,
      slopeDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}slope_deg'],
      )!,
      avgLoadPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_load_pct'],
      )!,
      isNight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_night'],
      )!,
      idleMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}idle_min'],
      )!,
      fuelUsedL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_used_l'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String taskType;
  final String machineId;
  final String machineType;
  final String operatorId;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? actualDurationMin;
  final double plannedQuantity;
  final double quantityDone;
  final double progressPct;
  final double cycleTimeSec;
  final int cyclesCompleted;
  final double groundSoftness;
  final double rain;
  final double slopeDeg;
  final double avgLoadPct;
  final bool isNight;
  final double idleMin;
  final double fuelUsedL;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Task({
    required this.id,
    required this.taskType,
    required this.machineId,
    required this.machineType,
    required this.operatorId,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.startTime,
    this.endTime,
    this.actualDurationMin,
    required this.plannedQuantity,
    required this.quantityDone,
    required this.progressPct,
    required this.cycleTimeSec,
    required this.cyclesCompleted,
    required this.groundSoftness,
    required this.rain,
    required this.slopeDeg,
    required this.avgLoadPct,
    required this.isNight,
    required this.idleMin,
    required this.fuelUsedL,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_type'] = Variable<String>(taskType);
    map['machine_id'] = Variable<String>(machineId);
    map['machine_type'] = Variable<String>(machineType);
    map['operator_id'] = Variable<String>(operatorId);
    map['scheduled_start'] = Variable<DateTime>(scheduledStart);
    map['scheduled_end'] = Variable<DateTime>(scheduledEnd);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || actualDurationMin != null) {
      map['actual_duration_min'] = Variable<double>(actualDurationMin);
    }
    map['planned_quantity'] = Variable<double>(plannedQuantity);
    map['quantity_done'] = Variable<double>(quantityDone);
    map['progress_pct'] = Variable<double>(progressPct);
    map['cycle_time_sec'] = Variable<double>(cycleTimeSec);
    map['cycles_completed'] = Variable<int>(cyclesCompleted);
    map['ground_softness'] = Variable<double>(groundSoftness);
    map['rain'] = Variable<double>(rain);
    map['slope_deg'] = Variable<double>(slopeDeg);
    map['avg_load_pct'] = Variable<double>(avgLoadPct);
    map['is_night'] = Variable<bool>(isNight);
    map['idle_min'] = Variable<double>(idleMin);
    map['fuel_used_l'] = Variable<double>(fuelUsedL);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      taskType: Value(taskType),
      machineId: Value(machineId),
      machineType: Value(machineType),
      operatorId: Value(operatorId),
      scheduledStart: Value(scheduledStart),
      scheduledEnd: Value(scheduledEnd),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      actualDurationMin: actualDurationMin == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDurationMin),
      plannedQuantity: Value(plannedQuantity),
      quantityDone: Value(quantityDone),
      progressPct: Value(progressPct),
      cycleTimeSec: Value(cycleTimeSec),
      cyclesCompleted: Value(cyclesCompleted),
      groundSoftness: Value(groundSoftness),
      rain: Value(rain),
      slopeDeg: Value(slopeDeg),
      avgLoadPct: Value(avgLoadPct),
      isNight: Value(isNight),
      idleMin: Value(idleMin),
      fuelUsedL: Value(fuelUsedL),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      taskType: serializer.fromJson<String>(json['taskType']),
      machineId: serializer.fromJson<String>(json['machineId']),
      machineType: serializer.fromJson<String>(json['machineType']),
      operatorId: serializer.fromJson<String>(json['operatorId']),
      scheduledStart: serializer.fromJson<DateTime>(json['scheduledStart']),
      scheduledEnd: serializer.fromJson<DateTime>(json['scheduledEnd']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      actualDurationMin: serializer.fromJson<double?>(
        json['actualDurationMin'],
      ),
      plannedQuantity: serializer.fromJson<double>(json['plannedQuantity']),
      quantityDone: serializer.fromJson<double>(json['quantityDone']),
      progressPct: serializer.fromJson<double>(json['progressPct']),
      cycleTimeSec: serializer.fromJson<double>(json['cycleTimeSec']),
      cyclesCompleted: serializer.fromJson<int>(json['cyclesCompleted']),
      groundSoftness: serializer.fromJson<double>(json['groundSoftness']),
      rain: serializer.fromJson<double>(json['rain']),
      slopeDeg: serializer.fromJson<double>(json['slopeDeg']),
      avgLoadPct: serializer.fromJson<double>(json['avgLoadPct']),
      isNight: serializer.fromJson<bool>(json['isNight']),
      idleMin: serializer.fromJson<double>(json['idleMin']),
      fuelUsedL: serializer.fromJson<double>(json['fuelUsedL']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskType': serializer.toJson<String>(taskType),
      'machineId': serializer.toJson<String>(machineId),
      'machineType': serializer.toJson<String>(machineType),
      'operatorId': serializer.toJson<String>(operatorId),
      'scheduledStart': serializer.toJson<DateTime>(scheduledStart),
      'scheduledEnd': serializer.toJson<DateTime>(scheduledEnd),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'actualDurationMin': serializer.toJson<double?>(actualDurationMin),
      'plannedQuantity': serializer.toJson<double>(plannedQuantity),
      'quantityDone': serializer.toJson<double>(quantityDone),
      'progressPct': serializer.toJson<double>(progressPct),
      'cycleTimeSec': serializer.toJson<double>(cycleTimeSec),
      'cyclesCompleted': serializer.toJson<int>(cyclesCompleted),
      'groundSoftness': serializer.toJson<double>(groundSoftness),
      'rain': serializer.toJson<double>(rain),
      'slopeDeg': serializer.toJson<double>(slopeDeg),
      'avgLoadPct': serializer.toJson<double>(avgLoadPct),
      'isNight': serializer.toJson<bool>(isNight),
      'idleMin': serializer.toJson<double>(idleMin),
      'fuelUsedL': serializer.toJson<double>(fuelUsedL),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Task copyWith({
    String? id,
    String? taskType,
    String? machineId,
    String? machineType,
    String? operatorId,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    Value<DateTime?> startTime = const Value.absent(),
    Value<DateTime?> endTime = const Value.absent(),
    Value<double?> actualDurationMin = const Value.absent(),
    double? plannedQuantity,
    double? quantityDone,
    double? progressPct,
    double? cycleTimeSec,
    int? cyclesCompleted,
    double? groundSoftness,
    double? rain,
    double? slopeDeg,
    double? avgLoadPct,
    bool? isNight,
    double? idleMin,
    double? fuelUsedL,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Task(
    id: id ?? this.id,
    taskType: taskType ?? this.taskType,
    machineId: machineId ?? this.machineId,
    machineType: machineType ?? this.machineType,
    operatorId: operatorId ?? this.operatorId,
    scheduledStart: scheduledStart ?? this.scheduledStart,
    scheduledEnd: scheduledEnd ?? this.scheduledEnd,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    actualDurationMin: actualDurationMin.present
        ? actualDurationMin.value
        : this.actualDurationMin,
    plannedQuantity: plannedQuantity ?? this.plannedQuantity,
    quantityDone: quantityDone ?? this.quantityDone,
    progressPct: progressPct ?? this.progressPct,
    cycleTimeSec: cycleTimeSec ?? this.cycleTimeSec,
    cyclesCompleted: cyclesCompleted ?? this.cyclesCompleted,
    groundSoftness: groundSoftness ?? this.groundSoftness,
    rain: rain ?? this.rain,
    slopeDeg: slopeDeg ?? this.slopeDeg,
    avgLoadPct: avgLoadPct ?? this.avgLoadPct,
    isNight: isNight ?? this.isNight,
    idleMin: idleMin ?? this.idleMin,
    fuelUsedL: fuelUsedL ?? this.fuelUsedL,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      machineId: data.machineId.present ? data.machineId.value : this.machineId,
      machineType: data.machineType.present
          ? data.machineType.value
          : this.machineType,
      operatorId: data.operatorId.present
          ? data.operatorId.value
          : this.operatorId,
      scheduledStart: data.scheduledStart.present
          ? data.scheduledStart.value
          : this.scheduledStart,
      scheduledEnd: data.scheduledEnd.present
          ? data.scheduledEnd.value
          : this.scheduledEnd,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      actualDurationMin: data.actualDurationMin.present
          ? data.actualDurationMin.value
          : this.actualDurationMin,
      plannedQuantity: data.plannedQuantity.present
          ? data.plannedQuantity.value
          : this.plannedQuantity,
      quantityDone: data.quantityDone.present
          ? data.quantityDone.value
          : this.quantityDone,
      progressPct: data.progressPct.present
          ? data.progressPct.value
          : this.progressPct,
      cycleTimeSec: data.cycleTimeSec.present
          ? data.cycleTimeSec.value
          : this.cycleTimeSec,
      cyclesCompleted: data.cyclesCompleted.present
          ? data.cyclesCompleted.value
          : this.cyclesCompleted,
      groundSoftness: data.groundSoftness.present
          ? data.groundSoftness.value
          : this.groundSoftness,
      rain: data.rain.present ? data.rain.value : this.rain,
      slopeDeg: data.slopeDeg.present ? data.slopeDeg.value : this.slopeDeg,
      avgLoadPct: data.avgLoadPct.present
          ? data.avgLoadPct.value
          : this.avgLoadPct,
      isNight: data.isNight.present ? data.isNight.value : this.isNight,
      idleMin: data.idleMin.present ? data.idleMin.value : this.idleMin,
      fuelUsedL: data.fuelUsedL.present ? data.fuelUsedL.value : this.fuelUsedL,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('taskType: $taskType, ')
          ..write('machineId: $machineId, ')
          ..write('machineType: $machineType, ')
          ..write('operatorId: $operatorId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('scheduledEnd: $scheduledEnd, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('actualDurationMin: $actualDurationMin, ')
          ..write('plannedQuantity: $plannedQuantity, ')
          ..write('quantityDone: $quantityDone, ')
          ..write('progressPct: $progressPct, ')
          ..write('cycleTimeSec: $cycleTimeSec, ')
          ..write('cyclesCompleted: $cyclesCompleted, ')
          ..write('groundSoftness: $groundSoftness, ')
          ..write('rain: $rain, ')
          ..write('slopeDeg: $slopeDeg, ')
          ..write('avgLoadPct: $avgLoadPct, ')
          ..write('isNight: $isNight, ')
          ..write('idleMin: $idleMin, ')
          ..write('fuelUsedL: $fuelUsedL, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    taskType,
    machineId,
    machineType,
    operatorId,
    scheduledStart,
    scheduledEnd,
    startTime,
    endTime,
    actualDurationMin,
    plannedQuantity,
    quantityDone,
    progressPct,
    cycleTimeSec,
    cyclesCompleted,
    groundSoftness,
    rain,
    slopeDeg,
    avgLoadPct,
    isNight,
    idleMin,
    fuelUsedL,
    updatedAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.taskType == this.taskType &&
          other.machineId == this.machineId &&
          other.machineType == this.machineType &&
          other.operatorId == this.operatorId &&
          other.scheduledStart == this.scheduledStart &&
          other.scheduledEnd == this.scheduledEnd &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.actualDurationMin == this.actualDurationMin &&
          other.plannedQuantity == this.plannedQuantity &&
          other.quantityDone == this.quantityDone &&
          other.progressPct == this.progressPct &&
          other.cycleTimeSec == this.cycleTimeSec &&
          other.cyclesCompleted == this.cyclesCompleted &&
          other.groundSoftness == this.groundSoftness &&
          other.rain == this.rain &&
          other.slopeDeg == this.slopeDeg &&
          other.avgLoadPct == this.avgLoadPct &&
          other.isNight == this.isNight &&
          other.idleMin == this.idleMin &&
          other.fuelUsedL == this.fuelUsedL &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> taskType;
  final Value<String> machineId;
  final Value<String> machineType;
  final Value<String> operatorId;
  final Value<DateTime> scheduledStart;
  final Value<DateTime> scheduledEnd;
  final Value<DateTime?> startTime;
  final Value<DateTime?> endTime;
  final Value<double?> actualDurationMin;
  final Value<double> plannedQuantity;
  final Value<double> quantityDone;
  final Value<double> progressPct;
  final Value<double> cycleTimeSec;
  final Value<int> cyclesCompleted;
  final Value<double> groundSoftness;
  final Value<double> rain;
  final Value<double> slopeDeg;
  final Value<double> avgLoadPct;
  final Value<bool> isNight;
  final Value<double> idleMin;
  final Value<double> fuelUsedL;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.taskType = const Value.absent(),
    this.machineId = const Value.absent(),
    this.machineType = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.scheduledStart = const Value.absent(),
    this.scheduledEnd = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.actualDurationMin = const Value.absent(),
    this.plannedQuantity = const Value.absent(),
    this.quantityDone = const Value.absent(),
    this.progressPct = const Value.absent(),
    this.cycleTimeSec = const Value.absent(),
    this.cyclesCompleted = const Value.absent(),
    this.groundSoftness = const Value.absent(),
    this.rain = const Value.absent(),
    this.slopeDeg = const Value.absent(),
    this.avgLoadPct = const Value.absent(),
    this.isNight = const Value.absent(),
    this.idleMin = const Value.absent(),
    this.fuelUsedL = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String taskType,
    required String machineId,
    required String machineType,
    required String operatorId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.actualDurationMin = const Value.absent(),
    this.plannedQuantity = const Value.absent(),
    this.quantityDone = const Value.absent(),
    this.progressPct = const Value.absent(),
    this.cycleTimeSec = const Value.absent(),
    this.cyclesCompleted = const Value.absent(),
    this.groundSoftness = const Value.absent(),
    this.rain = const Value.absent(),
    this.slopeDeg = const Value.absent(),
    this.avgLoadPct = const Value.absent(),
    this.isNight = const Value.absent(),
    this.idleMin = const Value.absent(),
    this.fuelUsedL = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskType = Value(taskType),
       machineId = Value(machineId),
       machineType = Value(machineType),
       operatorId = Value(operatorId),
       scheduledStart = Value(scheduledStart),
       scheduledEnd = Value(scheduledEnd),
       updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? taskType,
    Expression<String>? machineId,
    Expression<String>? machineType,
    Expression<String>? operatorId,
    Expression<DateTime>? scheduledStart,
    Expression<DateTime>? scheduledEnd,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<double>? actualDurationMin,
    Expression<double>? plannedQuantity,
    Expression<double>? quantityDone,
    Expression<double>? progressPct,
    Expression<double>? cycleTimeSec,
    Expression<int>? cyclesCompleted,
    Expression<double>? groundSoftness,
    Expression<double>? rain,
    Expression<double>? slopeDeg,
    Expression<double>? avgLoadPct,
    Expression<bool>? isNight,
    Expression<double>? idleMin,
    Expression<double>? fuelUsedL,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskType != null) 'task_type': taskType,
      if (machineId != null) 'machine_id': machineId,
      if (machineType != null) 'machine_type': machineType,
      if (operatorId != null) 'operator_id': operatorId,
      if (scheduledStart != null) 'scheduled_start': scheduledStart,
      if (scheduledEnd != null) 'scheduled_end': scheduledEnd,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (actualDurationMin != null) 'actual_duration_min': actualDurationMin,
      if (plannedQuantity != null) 'planned_quantity': plannedQuantity,
      if (quantityDone != null) 'quantity_done': quantityDone,
      if (progressPct != null) 'progress_pct': progressPct,
      if (cycleTimeSec != null) 'cycle_time_sec': cycleTimeSec,
      if (cyclesCompleted != null) 'cycles_completed': cyclesCompleted,
      if (groundSoftness != null) 'ground_softness': groundSoftness,
      if (rain != null) 'rain': rain,
      if (slopeDeg != null) 'slope_deg': slopeDeg,
      if (avgLoadPct != null) 'avg_load_pct': avgLoadPct,
      if (isNight != null) 'is_night': isNight,
      if (idleMin != null) 'idle_min': idleMin,
      if (fuelUsedL != null) 'fuel_used_l': fuelUsedL,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? taskType,
    Value<String>? machineId,
    Value<String>? machineType,
    Value<String>? operatorId,
    Value<DateTime>? scheduledStart,
    Value<DateTime>? scheduledEnd,
    Value<DateTime?>? startTime,
    Value<DateTime?>? endTime,
    Value<double?>? actualDurationMin,
    Value<double>? plannedQuantity,
    Value<double>? quantityDone,
    Value<double>? progressPct,
    Value<double>? cycleTimeSec,
    Value<int>? cyclesCompleted,
    Value<double>? groundSoftness,
    Value<double>? rain,
    Value<double>? slopeDeg,
    Value<double>? avgLoadPct,
    Value<bool>? isNight,
    Value<double>? idleMin,
    Value<double>? fuelUsedL,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      taskType: taskType ?? this.taskType,
      machineId: machineId ?? this.machineId,
      machineType: machineType ?? this.machineType,
      operatorId: operatorId ?? this.operatorId,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      actualDurationMin: actualDurationMin ?? this.actualDurationMin,
      plannedQuantity: plannedQuantity ?? this.plannedQuantity,
      quantityDone: quantityDone ?? this.quantityDone,
      progressPct: progressPct ?? this.progressPct,
      cycleTimeSec: cycleTimeSec ?? this.cycleTimeSec,
      cyclesCompleted: cyclesCompleted ?? this.cyclesCompleted,
      groundSoftness: groundSoftness ?? this.groundSoftness,
      rain: rain ?? this.rain,
      slopeDeg: slopeDeg ?? this.slopeDeg,
      avgLoadPct: avgLoadPct ?? this.avgLoadPct,
      isNight: isNight ?? this.isNight,
      idleMin: idleMin ?? this.idleMin,
      fuelUsedL: fuelUsedL ?? this.fuelUsedL,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (machineId.present) {
      map['machine_id'] = Variable<String>(machineId.value);
    }
    if (machineType.present) {
      map['machine_type'] = Variable<String>(machineType.value);
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (scheduledStart.present) {
      map['scheduled_start'] = Variable<DateTime>(scheduledStart.value);
    }
    if (scheduledEnd.present) {
      map['scheduled_end'] = Variable<DateTime>(scheduledEnd.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (actualDurationMin.present) {
      map['actual_duration_min'] = Variable<double>(actualDurationMin.value);
    }
    if (plannedQuantity.present) {
      map['planned_quantity'] = Variable<double>(plannedQuantity.value);
    }
    if (quantityDone.present) {
      map['quantity_done'] = Variable<double>(quantityDone.value);
    }
    if (progressPct.present) {
      map['progress_pct'] = Variable<double>(progressPct.value);
    }
    if (cycleTimeSec.present) {
      map['cycle_time_sec'] = Variable<double>(cycleTimeSec.value);
    }
    if (cyclesCompleted.present) {
      map['cycles_completed'] = Variable<int>(cyclesCompleted.value);
    }
    if (groundSoftness.present) {
      map['ground_softness'] = Variable<double>(groundSoftness.value);
    }
    if (rain.present) {
      map['rain'] = Variable<double>(rain.value);
    }
    if (slopeDeg.present) {
      map['slope_deg'] = Variable<double>(slopeDeg.value);
    }
    if (avgLoadPct.present) {
      map['avg_load_pct'] = Variable<double>(avgLoadPct.value);
    }
    if (isNight.present) {
      map['is_night'] = Variable<bool>(isNight.value);
    }
    if (idleMin.present) {
      map['idle_min'] = Variable<double>(idleMin.value);
    }
    if (fuelUsedL.present) {
      map['fuel_used_l'] = Variable<double>(fuelUsedL.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('taskType: $taskType, ')
          ..write('machineId: $machineId, ')
          ..write('machineType: $machineType, ')
          ..write('operatorId: $operatorId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('scheduledEnd: $scheduledEnd, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('actualDurationMin: $actualDurationMin, ')
          ..write('plannedQuantity: $plannedQuantity, ')
          ..write('quantityDone: $quantityDone, ')
          ..write('progressPct: $progressPct, ')
          ..write('cycleTimeSec: $cycleTimeSec, ')
          ..write('cyclesCompleted: $cyclesCompleted, ')
          ..write('groundSoftness: $groundSoftness, ')
          ..write('rain: $rain, ')
          ..write('slopeDeg: $slopeDeg, ')
          ..write('avgLoadPct: $avgLoadPct, ')
          ..write('isNight: $isNight, ')
          ..write('idleMin: $idleMin, ')
          ..write('fuelUsedL: $fuelUsedL, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, Shift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operatorIdMeta = const VerificationMeta(
    'operatorId',
  );
  @override
  late final GeneratedColumn<String> operatorId = GeneratedColumn<String>(
    'operator_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _machineIdMeta = const VerificationMeta(
    'machineId',
  );
  @override
  late final GeneratedColumn<String> machineId = GeneratedColumn<String>(
    'machine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledStartMeta = const VerificationMeta(
    'scheduledStart',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledStart =
      GeneratedColumn<DateTime>(
        'scheduled_start',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _scheduledEndMeta = const VerificationMeta(
    'scheduledEnd',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledEnd = GeneratedColumn<DateTime>(
    'scheduled_end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planned'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operatorId,
    machineId,
    scheduledStart,
    scheduledEnd,
    startedAt,
    endedAt,
    status,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Shift> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('operator_id')) {
      context.handle(
        _operatorIdMeta,
        operatorId.isAcceptableOrUnknown(data['operator_id']!, _operatorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_operatorIdMeta);
    }
    if (data.containsKey('machine_id')) {
      context.handle(
        _machineIdMeta,
        machineId.isAcceptableOrUnknown(data['machine_id']!, _machineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_machineIdMeta);
    }
    if (data.containsKey('scheduled_start')) {
      context.handle(
        _scheduledStartMeta,
        scheduledStart.isAcceptableOrUnknown(
          data['scheduled_start']!,
          _scheduledStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledStartMeta);
    }
    if (data.containsKey('scheduled_end')) {
      context.handle(
        _scheduledEndMeta,
        scheduledEnd.isAcceptableOrUnknown(
          data['scheduled_end']!,
          _scheduledEndMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledEndMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shift(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      operatorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operator_id'],
      )!,
      machineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}machine_id'],
      )!,
      scheduledStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_start'],
      )!,
      scheduledEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_end'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class Shift extends DataClass implements Insertable<Shift> {
  final String id;
  final String operatorId;
  final String machineId;
  final DateTime scheduledStart;
  final DateTime scheduledEnd;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String status;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Shift({
    required this.id,
    required this.operatorId,
    required this.machineId,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.startedAt,
    this.endedAt,
    required this.status,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['operator_id'] = Variable<String>(operatorId);
    map['machine_id'] = Variable<String>(machineId);
    map['scheduled_start'] = Variable<DateTime>(scheduledStart);
    map['scheduled_end'] = Variable<DateTime>(scheduledEnd);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      operatorId: Value(operatorId),
      machineId: Value(machineId),
      scheduledStart: Value(scheduledStart),
      scheduledEnd: Value(scheduledEnd),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Shift.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shift(
      id: serializer.fromJson<String>(json['id']),
      operatorId: serializer.fromJson<String>(json['operatorId']),
      machineId: serializer.fromJson<String>(json['machineId']),
      scheduledStart: serializer.fromJson<DateTime>(json['scheduledStart']),
      scheduledEnd: serializer.fromJson<DateTime>(json['scheduledEnd']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'operatorId': serializer.toJson<String>(operatorId),
      'machineId': serializer.toJson<String>(machineId),
      'scheduledStart': serializer.toJson<DateTime>(scheduledStart),
      'scheduledEnd': serializer.toJson<DateTime>(scheduledEnd),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Shift copyWith({
    String? id,
    String? operatorId,
    String? machineId,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> endedAt = const Value.absent(),
    String? status,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Shift(
    id: id ?? this.id,
    operatorId: operatorId ?? this.operatorId,
    machineId: machineId ?? this.machineId,
    scheduledStart: scheduledStart ?? this.scheduledStart,
    scheduledEnd: scheduledEnd ?? this.scheduledEnd,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Shift copyWithCompanion(ShiftsCompanion data) {
    return Shift(
      id: data.id.present ? data.id.value : this.id,
      operatorId: data.operatorId.present
          ? data.operatorId.value
          : this.operatorId,
      machineId: data.machineId.present ? data.machineId.value : this.machineId,
      scheduledStart: data.scheduledStart.present
          ? data.scheduledStart.value
          : this.scheduledStart,
      scheduledEnd: data.scheduledEnd.present
          ? data.scheduledEnd.value
          : this.scheduledEnd,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shift(')
          ..write('id: $id, ')
          ..write('operatorId: $operatorId, ')
          ..write('machineId: $machineId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('scheduledEnd: $scheduledEnd, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operatorId,
    machineId,
    scheduledStart,
    scheduledEnd,
    startedAt,
    endedAt,
    status,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shift &&
          other.id == this.id &&
          other.operatorId == this.operatorId &&
          other.machineId == this.machineId &&
          other.scheduledStart == this.scheduledStart &&
          other.scheduledEnd == this.scheduledEnd &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ShiftsCompanion extends UpdateCompanion<Shift> {
  final Value<String> id;
  final Value<String> operatorId;
  final Value<String> machineId;
  final Value<DateTime> scheduledStart;
  final Value<DateTime> scheduledEnd;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> status;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.operatorId = const Value.absent(),
    this.machineId = const Value.absent(),
    this.scheduledStart = const Value.absent(),
    this.scheduledEnd = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftsCompanion.insert({
    required String id,
    required String operatorId,
    required String machineId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       operatorId = Value(operatorId),
       machineId = Value(machineId),
       scheduledStart = Value(scheduledStart),
       scheduledEnd = Value(scheduledEnd),
       updatedAt = Value(updatedAt);
  static Insertable<Shift> custom({
    Expression<String>? id,
    Expression<String>? operatorId,
    Expression<String>? machineId,
    Expression<DateTime>? scheduledStart,
    Expression<DateTime>? scheduledEnd,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operatorId != null) 'operator_id': operatorId,
      if (machineId != null) 'machine_id': machineId,
      if (scheduledStart != null) 'scheduled_start': scheduledStart,
      if (scheduledEnd != null) 'scheduled_end': scheduledEnd,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftsCompanion copyWith({
    Value<String>? id,
    Value<String>? operatorId,
    Value<String>? machineId,
    Value<DateTime>? scheduledStart,
    Value<DateTime>? scheduledEnd,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? status,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ShiftsCompanion(
      id: id ?? this.id,
      operatorId: operatorId ?? this.operatorId,
      machineId: machineId ?? this.machineId,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (operatorId.present) {
      map['operator_id'] = Variable<String>(operatorId.value);
    }
    if (machineId.present) {
      map['machine_id'] = Variable<String>(machineId.value);
    }
    if (scheduledStart.present) {
      map['scheduled_start'] = Variable<DateTime>(scheduledStart.value);
    }
    if (scheduledEnd.present) {
      map['scheduled_end'] = Variable<DateTime>(scheduledEnd.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('operatorId: $operatorId, ')
          ..write('machineId: $machineId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('scheduledEnd: $scheduledEnd, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedMeta = const VerificationMeta(
    'checked',
  );
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
    'checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _requiredMeta = const VerificationMeta(
    'required',
  );
  @override
  late final GeneratedColumn<bool> required = GeneratedColumn<bool>(
    'required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("required" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shiftId,
    category,
    label,
    checked,
    required,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    }
    if (data.containsKey('required')) {
      context.handle(
        _requiredMeta,
        required.isAcceptableOrUnknown(data['required']!, _requiredMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
      required: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}required'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }
}

class ChecklistItem extends DataClass implements Insertable<ChecklistItem> {
  final String id;
  final String shiftId;
  final String category;
  final String label;
  final bool checked;
  final bool required;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const ChecklistItem({
    required this.id,
    required this.shiftId,
    required this.category,
    required this.label,
    required this.checked,
    required this.required,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shift_id'] = Variable<String>(shiftId);
    map['category'] = Variable<String>(category);
    map['label'] = Variable<String>(label);
    map['checked'] = Variable<bool>(checked);
    map['required'] = Variable<bool>(required);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      category: Value(category),
      label: Value(label),
      checked: Value(checked),
      required: Value(required),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ChecklistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItem(
      id: serializer.fromJson<String>(json['id']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      category: serializer.fromJson<String>(json['category']),
      label: serializer.fromJson<String>(json['label']),
      checked: serializer.fromJson<bool>(json['checked']),
      required: serializer.fromJson<bool>(json['required']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shiftId': serializer.toJson<String>(shiftId),
      'category': serializer.toJson<String>(category),
      'label': serializer.toJson<String>(label),
      'checked': serializer.toJson<bool>(checked),
      'required': serializer.toJson<bool>(required),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ChecklistItem copyWith({
    String? id,
    String? shiftId,
    String? category,
    String? label,
    bool? checked,
    bool? required,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => ChecklistItem(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    category: category ?? this.category,
    label: label ?? this.label,
    checked: checked ?? this.checked,
    required: required ?? this.required,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  ChecklistItem copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItem(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      category: data.category.present ? data.category.value : this.category,
      label: data.label.present ? data.label.value : this.label,
      checked: data.checked.present ? data.checked.value : this.checked,
      required: data.required.present ? data.required.value : this.required,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItem(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('checked: $checked, ')
          ..write('required: $required, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shiftId,
    category,
    label,
    checked,
    required,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItem &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.category == this.category &&
          other.label == this.label &&
          other.checked == this.checked &&
          other.required == this.required &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItem> {
  final Value<String> id;
  final Value<String> shiftId;
  final Value<String> category;
  final Value<String> label;
  final Value<bool> checked;
  final Value<bool> required;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.category = const Value.absent(),
    this.label = const Value.absent(),
    this.checked = const Value.absent(),
    this.required = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    required String id,
    required String shiftId,
    required String category,
    required String label,
    this.checked = const Value.absent(),
    this.required = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shiftId = Value(shiftId),
       category = Value(category),
       label = Value(label),
       updatedAt = Value(updatedAt);
  static Insertable<ChecklistItem> custom({
    Expression<String>? id,
    Expression<String>? shiftId,
    Expression<String>? category,
    Expression<String>? label,
    Expression<bool>? checked,
    Expression<bool>? required,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (category != null) 'category': category,
      if (label != null) 'label': label,
      if (checked != null) 'checked': checked,
      if (required != null) 'required': required,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? shiftId,
    Value<String>? category,
    Value<String>? label,
    Value<bool>? checked,
    Value<bool>? required,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      category: category ?? this.category,
      label: label ?? this.label,
      checked: checked ?? this.checked,
      required: required ?? this.required,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (required.present) {
      map['required'] = Variable<bool>(required.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('checked: $checked, ')
          ..write('required: $required, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HandoversTable extends Handovers
    with TableInfo<$HandoversTable, Handover> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HandoversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportJsonMeta = const VerificationMeta(
    'reportJson',
  );
  @override
  late final GeneratedColumn<String> reportJson = GeneratedColumn<String>(
    'report_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _nextTaskIdMeta = const VerificationMeta(
    'nextTaskId',
  );
  @override
  late final GeneratedColumn<String> nextTaskId = GeneratedColumn<String>(
    'next_task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shiftId,
    reportJson,
    nextTaskId,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'handovers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Handover> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('report_json')) {
      context.handle(
        _reportJsonMeta,
        reportJson.isAcceptableOrUnknown(data['report_json']!, _reportJsonMeta),
      );
    }
    if (data.containsKey('next_task_id')) {
      context.handle(
        _nextTaskIdMeta,
        nextTaskId.isAcceptableOrUnknown(
          data['next_task_id']!,
          _nextTaskIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Handover map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Handover(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      )!,
      reportJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_json'],
      )!,
      nextTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_task_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $HandoversTable createAlias(String alias) {
    return $HandoversTable(attachedDatabase, alias);
  }
}

class Handover extends DataClass implements Insertable<Handover> {
  final String id;
  final String shiftId;
  final String reportJson;
  final String? nextTaskId;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Handover({
    required this.id,
    required this.shiftId,
    required this.reportJson,
    this.nextTaskId,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['shift_id'] = Variable<String>(shiftId);
    map['report_json'] = Variable<String>(reportJson);
    if (!nullToAbsent || nextTaskId != null) {
      map['next_task_id'] = Variable<String>(nextTaskId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  HandoversCompanion toCompanion(bool nullToAbsent) {
    return HandoversCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      reportJson: Value(reportJson),
      nextTaskId: nextTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(nextTaskId),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Handover.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Handover(
      id: serializer.fromJson<String>(json['id']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      reportJson: serializer.fromJson<String>(json['reportJson']),
      nextTaskId: serializer.fromJson<String?>(json['nextTaskId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shiftId': serializer.toJson<String>(shiftId),
      'reportJson': serializer.toJson<String>(reportJson),
      'nextTaskId': serializer.toJson<String?>(nextTaskId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Handover copyWith({
    String? id,
    String? shiftId,
    String? reportJson,
    Value<String?> nextTaskId = const Value.absent(),
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Handover(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    reportJson: reportJson ?? this.reportJson,
    nextTaskId: nextTaskId.present ? nextTaskId.value : this.nextTaskId,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Handover copyWithCompanion(HandoversCompanion data) {
    return Handover(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      reportJson: data.reportJson.present
          ? data.reportJson.value
          : this.reportJson,
      nextTaskId: data.nextTaskId.present
          ? data.nextTaskId.value
          : this.nextTaskId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Handover(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('reportJson: $reportJson, ')
          ..write('nextTaskId: $nextTaskId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, shiftId, reportJson, nextTaskId, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Handover &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.reportJson == this.reportJson &&
          other.nextTaskId == this.nextTaskId &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class HandoversCompanion extends UpdateCompanion<Handover> {
  final Value<String> id;
  final Value<String> shiftId;
  final Value<String> reportJson;
  final Value<String?> nextTaskId;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const HandoversCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.reportJson = const Value.absent(),
    this.nextTaskId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HandoversCompanion.insert({
    required String id,
    required String shiftId,
    this.reportJson = const Value.absent(),
    this.nextTaskId = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       shiftId = Value(shiftId),
       updatedAt = Value(updatedAt);
  static Insertable<Handover> custom({
    Expression<String>? id,
    Expression<String>? shiftId,
    Expression<String>? reportJson,
    Expression<String>? nextTaskId,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (reportJson != null) 'report_json': reportJson,
      if (nextTaskId != null) 'next_task_id': nextTaskId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HandoversCompanion copyWith({
    Value<String>? id,
    Value<String>? shiftId,
    Value<String>? reportJson,
    Value<String?>? nextTaskId,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return HandoversCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      reportJson: reportJson ?? this.reportJson,
      nextTaskId: nextTaskId ?? this.nextTaskId,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (reportJson.present) {
      map['report_json'] = Variable<String>(reportJson.value);
    }
    if (nextTaskId.present) {
      map['next_task_id'] = Variable<String>(nextTaskId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HandoversCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('reportJson: $reportJson, ')
          ..write('nextTaskId: $nextTaskId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entity,
    recordId,
    op,
    payloadJson,
    updatedAt,
    createdAt,
    attempts,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final int id;
  final String entity;
  final String recordId;
  final String op;
  final String payloadJson;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int attempts;
  const OutboxEntry({
    required this.id,
    required this.entity,
    required this.recordId,
    required this.op,
    required this.payloadJson,
    required this.updatedAt,
    required this.createdAt,
    required this.attempts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity'] = Variable<String>(entity);
    map['record_id'] = Variable<String>(recordId);
    map['op'] = Variable<String>(op);
    map['payload_json'] = Variable<String>(payloadJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      entity: Value(entity),
      recordId: Value(recordId),
      op: Value(op),
      payloadJson: Value(payloadJson),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      recordId: serializer.fromJson<String>(json['recordId']),
      op: serializer.fromJson<String>(json['op']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entity': serializer.toJson<String>(entity),
      'recordId': serializer.toJson<String>(recordId),
      'op': serializer.toJson<String>(op),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
    };
  }

  OutboxEntry copyWith({
    int? id,
    String? entity,
    String? recordId,
    String? op,
    String? payloadJson,
    DateTime? updatedAt,
    DateTime? createdAt,
    int? attempts,
  }) => OutboxEntry(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    recordId: recordId ?? this.recordId,
    op: op ?? this.op,
    payloadJson: payloadJson ?? this.payloadJson,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      op: data.op.present ? data.op.value : this.op,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('recordId: $recordId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entity,
    recordId,
    op,
    payloadJson,
    updatedAt,
    createdAt,
    attempts,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.recordId == this.recordId &&
          other.op == this.op &&
          other.payloadJson == this.payloadJson &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> id;
  final Value<String> entity;
  final Value<String> recordId;
  final Value<String> op;
  final Value<String> payloadJson;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.recordId = const Value.absent(),
    this.op = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String entity,
    required String recordId,
    required String op,
    required String payloadJson,
    required DateTime updatedAt,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
  }) : entity = Value(entity),
       recordId = Value(recordId),
       op = Value(op),
       payloadJson = Value(payloadJson),
       updatedAt = Value(updatedAt),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? entity,
    Expression<String>? recordId,
    Expression<String>? op,
    Expression<String>? payloadJson,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (recordId != null) 'record_id': recordId,
      if (op != null) 'op': op,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? entity,
    Value<String>? recordId,
    Value<String>? op,
    Value<String>? payloadJson,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
  }) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      recordId: recordId ?? this.recordId,
      op: op ?? this.op,
      payloadJson: payloadJson ?? this.payloadJson,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('recordId: $recordId, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }
}

class $SyncCursorsTable extends SyncCursors
    with TableInfo<$SyncCursorsTable, SyncCursor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCursorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _collectionMeta = const VerificationMeta(
    'collection',
  );
  @override
  late final GeneratedColumn<String> collection = GeneratedColumn<String>(
    'collection',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cursorMeta = const VerificationMeta('cursor');
  @override
  late final GeneratedColumn<String> cursor = GeneratedColumn<String>(
    'cursor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [collection, cursor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_cursors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCursor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('collection')) {
      context.handle(
        _collectionMeta,
        collection.isAcceptableOrUnknown(data['collection']!, _collectionMeta),
      );
    } else if (isInserting) {
      context.missing(_collectionMeta);
    }
    if (data.containsKey('cursor')) {
      context.handle(
        _cursorMeta,
        cursor.isAcceptableOrUnknown(data['cursor']!, _cursorMeta),
      );
    } else if (isInserting) {
      context.missing(_cursorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {collection};
  @override
  SyncCursor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCursor(
      collection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection'],
      )!,
      cursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cursor'],
      )!,
    );
  }

  @override
  $SyncCursorsTable createAlias(String alias) {
    return $SyncCursorsTable(attachedDatabase, alias);
  }
}

class SyncCursor extends DataClass implements Insertable<SyncCursor> {
  final String collection;
  final String cursor;
  const SyncCursor({required this.collection, required this.cursor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['collection'] = Variable<String>(collection);
    map['cursor'] = Variable<String>(cursor);
    return map;
  }

  SyncCursorsCompanion toCompanion(bool nullToAbsent) {
    return SyncCursorsCompanion(
      collection: Value(collection),
      cursor: Value(cursor),
    );
  }

  factory SyncCursor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCursor(
      collection: serializer.fromJson<String>(json['collection']),
      cursor: serializer.fromJson<String>(json['cursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'collection': serializer.toJson<String>(collection),
      'cursor': serializer.toJson<String>(cursor),
    };
  }

  SyncCursor copyWith({String? collection, String? cursor}) => SyncCursor(
    collection: collection ?? this.collection,
    cursor: cursor ?? this.cursor,
  );
  SyncCursor copyWithCompanion(SyncCursorsCompanion data) {
    return SyncCursor(
      collection: data.collection.present
          ? data.collection.value
          : this.collection,
      cursor: data.cursor.present ? data.cursor.value : this.cursor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursor(')
          ..write('collection: $collection, ')
          ..write('cursor: $cursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(collection, cursor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCursor &&
          other.collection == this.collection &&
          other.cursor == this.cursor);
}

class SyncCursorsCompanion extends UpdateCompanion<SyncCursor> {
  final Value<String> collection;
  final Value<String> cursor;
  final Value<int> rowid;
  const SyncCursorsCompanion({
    this.collection = const Value.absent(),
    this.cursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCursorsCompanion.insert({
    required String collection,
    required String cursor,
    this.rowid = const Value.absent(),
  }) : collection = Value(collection),
       cursor = Value(cursor);
  static Insertable<SyncCursor> custom({
    Expression<String>? collection,
    Expression<String>? cursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (collection != null) 'collection': collection,
      if (cursor != null) 'cursor': cursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCursorsCompanion copyWith({
    Value<String>? collection,
    Value<String>? cursor,
    Value<int>? rowid,
  }) {
    return SyncCursorsCompanion(
      collection: collection ?? this.collection,
      cursor: cursor ?? this.cursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (collection.present) {
      map['collection'] = Variable<String>(collection.value);
    }
    if (cursor.present) {
      map['cursor'] = Variable<String>(cursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCursorsCompanion(')
          ..write('collection: $collection, ')
          ..write('cursor: $cursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $HandoversTable handovers = $HandoversTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final $SyncCursorsTable syncCursors = $SyncCursorsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tasks,
    shifts,
    checklistItems,
    handovers,
    outboxEntries,
    syncCursors,
  ];
}

typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String taskType,
      required String machineId,
      required String machineType,
      required String operatorId,
      required DateTime scheduledStart,
      required DateTime scheduledEnd,
      Value<DateTime?> startTime,
      Value<DateTime?> endTime,
      Value<double?> actualDurationMin,
      Value<double> plannedQuantity,
      Value<double> quantityDone,
      Value<double> progressPct,
      Value<double> cycleTimeSec,
      Value<int> cyclesCompleted,
      Value<double> groundSoftness,
      Value<double> rain,
      Value<double> slopeDeg,
      Value<double> avgLoadPct,
      Value<bool> isNight,
      Value<double> idleMin,
      Value<double> fuelUsedL,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> taskType,
      Value<String> machineId,
      Value<String> machineType,
      Value<String> operatorId,
      Value<DateTime> scheduledStart,
      Value<DateTime> scheduledEnd,
      Value<DateTime?> startTime,
      Value<DateTime?> endTime,
      Value<double?> actualDurationMin,
      Value<double> plannedQuantity,
      Value<double> quantityDone,
      Value<double> progressPct,
      Value<double> cycleTimeSec,
      Value<int> cyclesCompleted,
      Value<double> groundSoftness,
      Value<double> rain,
      Value<double> slopeDeg,
      Value<double> avgLoadPct,
      Value<bool> isNight,
      Value<double> idleMin,
      Value<double> fuelUsedL,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get machineId => $composableBuilder(
    column: $table.machineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get machineType => $composableBuilder(
    column: $table.machineType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operatorId => $composableBuilder(
    column: $table.operatorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledEnd => $composableBuilder(
    column: $table.scheduledEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualDurationMin => $composableBuilder(
    column: $table.actualDurationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityDone => $composableBuilder(
    column: $table.quantityDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progressPct => $composableBuilder(
    column: $table.progressPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cycleTimeSec => $composableBuilder(
    column: $table.cycleTimeSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cyclesCompleted => $composableBuilder(
    column: $table.cyclesCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get groundSoftness => $composableBuilder(
    column: $table.groundSoftness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rain => $composableBuilder(
    column: $table.rain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get slopeDeg => $composableBuilder(
    column: $table.slopeDeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgLoadPct => $composableBuilder(
    column: $table.avgLoadPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNight => $composableBuilder(
    column: $table.isNight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get idleMin => $composableBuilder(
    column: $table.idleMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelUsedL => $composableBuilder(
    column: $table.fuelUsedL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get machineId => $composableBuilder(
    column: $table.machineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get machineType => $composableBuilder(
    column: $table.machineType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operatorId => $composableBuilder(
    column: $table.operatorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledEnd => $composableBuilder(
    column: $table.scheduledEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualDurationMin => $composableBuilder(
    column: $table.actualDurationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityDone => $composableBuilder(
    column: $table.quantityDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progressPct => $composableBuilder(
    column: $table.progressPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cycleTimeSec => $composableBuilder(
    column: $table.cycleTimeSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cyclesCompleted => $composableBuilder(
    column: $table.cyclesCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get groundSoftness => $composableBuilder(
    column: $table.groundSoftness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rain => $composableBuilder(
    column: $table.rain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get slopeDeg => $composableBuilder(
    column: $table.slopeDeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgLoadPct => $composableBuilder(
    column: $table.avgLoadPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNight => $composableBuilder(
    column: $table.isNight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get idleMin => $composableBuilder(
    column: $table.idleMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelUsedL => $composableBuilder(
    column: $table.fuelUsedL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<String> get machineId =>
      $composableBuilder(column: $table.machineId, builder: (column) => column);

  GeneratedColumn<String> get machineType => $composableBuilder(
    column: $table.machineType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operatorId => $composableBuilder(
    column: $table.operatorId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledEnd => $composableBuilder(
    column: $table.scheduledEnd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get actualDurationMin => $composableBuilder(
    column: $table.actualDurationMin,
    builder: (column) => column,
  );

  GeneratedColumn<double> get plannedQuantity => $composableBuilder(
    column: $table.plannedQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantityDone => $composableBuilder(
    column: $table.quantityDone,
    builder: (column) => column,
  );

  GeneratedColumn<double> get progressPct => $composableBuilder(
    column: $table.progressPct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cycleTimeSec => $composableBuilder(
    column: $table.cycleTimeSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cyclesCompleted => $composableBuilder(
    column: $table.cyclesCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<double> get groundSoftness => $composableBuilder(
    column: $table.groundSoftness,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rain =>
      $composableBuilder(column: $table.rain, builder: (column) => column);

  GeneratedColumn<double> get slopeDeg =>
      $composableBuilder(column: $table.slopeDeg, builder: (column) => column);

  GeneratedColumn<double> get avgLoadPct => $composableBuilder(
    column: $table.avgLoadPct,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isNight =>
      $composableBuilder(column: $table.isNight, builder: (column) => column);

  GeneratedColumn<double> get idleMin =>
      $composableBuilder(column: $table.idleMin, builder: (column) => column);

  GeneratedColumn<double> get fuelUsedL =>
      $composableBuilder(column: $table.fuelUsedL, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskType = const Value.absent(),
                Value<String> machineId = const Value.absent(),
                Value<String> machineType = const Value.absent(),
                Value<String> operatorId = const Value.absent(),
                Value<DateTime> scheduledStart = const Value.absent(),
                Value<DateTime> scheduledEnd = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<double?> actualDurationMin = const Value.absent(),
                Value<double> plannedQuantity = const Value.absent(),
                Value<double> quantityDone = const Value.absent(),
                Value<double> progressPct = const Value.absent(),
                Value<double> cycleTimeSec = const Value.absent(),
                Value<int> cyclesCompleted = const Value.absent(),
                Value<double> groundSoftness = const Value.absent(),
                Value<double> rain = const Value.absent(),
                Value<double> slopeDeg = const Value.absent(),
                Value<double> avgLoadPct = const Value.absent(),
                Value<bool> isNight = const Value.absent(),
                Value<double> idleMin = const Value.absent(),
                Value<double> fuelUsedL = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                taskType: taskType,
                machineId: machineId,
                machineType: machineType,
                operatorId: operatorId,
                scheduledStart: scheduledStart,
                scheduledEnd: scheduledEnd,
                startTime: startTime,
                endTime: endTime,
                actualDurationMin: actualDurationMin,
                plannedQuantity: plannedQuantity,
                quantityDone: quantityDone,
                progressPct: progressPct,
                cycleTimeSec: cycleTimeSec,
                cyclesCompleted: cyclesCompleted,
                groundSoftness: groundSoftness,
                rain: rain,
                slopeDeg: slopeDeg,
                avgLoadPct: avgLoadPct,
                isNight: isNight,
                idleMin: idleMin,
                fuelUsedL: fuelUsedL,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskType,
                required String machineId,
                required String machineType,
                required String operatorId,
                required DateTime scheduledStart,
                required DateTime scheduledEnd,
                Value<DateTime?> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<double?> actualDurationMin = const Value.absent(),
                Value<double> plannedQuantity = const Value.absent(),
                Value<double> quantityDone = const Value.absent(),
                Value<double> progressPct = const Value.absent(),
                Value<double> cycleTimeSec = const Value.absent(),
                Value<int> cyclesCompleted = const Value.absent(),
                Value<double> groundSoftness = const Value.absent(),
                Value<double> rain = const Value.absent(),
                Value<double> slopeDeg = const Value.absent(),
                Value<double> avgLoadPct = const Value.absent(),
                Value<bool> isNight = const Value.absent(),
                Value<double> idleMin = const Value.absent(),
                Value<double> fuelUsedL = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                taskType: taskType,
                machineId: machineId,
                machineType: machineType,
                operatorId: operatorId,
                scheduledStart: scheduledStart,
                scheduledEnd: scheduledEnd,
                startTime: startTime,
                endTime: endTime,
                actualDurationMin: actualDurationMin,
                plannedQuantity: plannedQuantity,
                quantityDone: quantityDone,
                progressPct: progressPct,
                cycleTimeSec: cycleTimeSec,
                cyclesCompleted: cyclesCompleted,
                groundSoftness: groundSoftness,
                rain: rain,
                slopeDeg: slopeDeg,
                avgLoadPct: avgLoadPct,
                isNight: isNight,
                idleMin: idleMin,
                fuelUsedL: fuelUsedL,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$ShiftsTableCreateCompanionBuilder =
    ShiftsCompanion Function({
      required String id,
      required String operatorId,
      required String machineId,
      required DateTime scheduledStart,
      required DateTime scheduledEnd,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ShiftsTableUpdateCompanionBuilder =
    ShiftsCompanion Function({
      Value<String> id,
      Value<String> operatorId,
      Value<String> machineId,
      Value<DateTime> scheduledStart,
      Value<DateTime> scheduledEnd,
      Value<DateTime?> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operatorId => $composableBuilder(
    column: $table.operatorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get machineId => $composableBuilder(
    column: $table.machineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledEnd => $composableBuilder(
    column: $table.scheduledEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operatorId => $composableBuilder(
    column: $table.operatorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get machineId => $composableBuilder(
    column: $table.machineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledEnd => $composableBuilder(
    column: $table.scheduledEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operatorId => $composableBuilder(
    column: $table.operatorId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get machineId =>
      $composableBuilder(column: $table.machineId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledEnd => $composableBuilder(
    column: $table.scheduledEnd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ShiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftsTable,
          Shift,
          $$ShiftsTableFilterComposer,
          $$ShiftsTableOrderingComposer,
          $$ShiftsTableAnnotationComposer,
          $$ShiftsTableCreateCompanionBuilder,
          $$ShiftsTableUpdateCompanionBuilder,
          (Shift, BaseReferences<_$AppDatabase, $ShiftsTable, Shift>),
          Shift,
          PrefetchHooks Function()
        > {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> operatorId = const Value.absent(),
                Value<String> machineId = const Value.absent(),
                Value<DateTime> scheduledStart = const Value.absent(),
                Value<DateTime> scheduledEnd = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftsCompanion(
                id: id,
                operatorId: operatorId,
                machineId: machineId,
                scheduledStart: scheduledStart,
                scheduledEnd: scheduledEnd,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String operatorId,
                required String machineId,
                required DateTime scheduledStart,
                required DateTime scheduledEnd,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftsCompanion.insert(
                id: id,
                operatorId: operatorId,
                machineId: machineId,
                scheduledStart: scheduledStart,
                scheduledEnd: scheduledEnd,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftsTable,
      Shift,
      $$ShiftsTableFilterComposer,
      $$ShiftsTableOrderingComposer,
      $$ShiftsTableAnnotationComposer,
      $$ShiftsTableCreateCompanionBuilder,
      $$ShiftsTableUpdateCompanionBuilder,
      (Shift, BaseReferences<_$AppDatabase, $ShiftsTable, Shift>),
      Shift,
      PrefetchHooks Function()
    >;
typedef $$ChecklistItemsTableCreateCompanionBuilder =
    ChecklistItemsCompanion Function({
      required String id,
      required String shiftId,
      required String category,
      required String label,
      Value<bool> checked,
      Value<bool> required,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ChecklistItemsTableUpdateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<String> id,
      Value<String> shiftId,
      Value<String> category,
      Value<String> label,
      Value<bool> checked,
      Value<bool> required,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get required => $composableBuilder(
    column: $table.required,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get required => $composableBuilder(
    column: $table.required,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  GeneratedColumn<bool> get required =>
      $composableBuilder(column: $table.required, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistItemsTable,
          ChecklistItem,
          $$ChecklistItemsTableFilterComposer,
          $$ChecklistItemsTableOrderingComposer,
          $$ChecklistItemsTableAnnotationComposer,
          $$ChecklistItemsTableCreateCompanionBuilder,
          $$ChecklistItemsTableUpdateCompanionBuilder,
          (
            ChecklistItem,
            BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItem>,
          ),
          ChecklistItem,
          PrefetchHooks Function()
        > {
  $$ChecklistItemsTableTableManager(
    _$AppDatabase db,
    $ChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shiftId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<bool> required = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsCompanion(
                id: id,
                shiftId: shiftId,
                category: category,
                label: label,
                checked: checked,
                required: required,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String shiftId,
                required String category,
                required String label,
                Value<bool> checked = const Value.absent(),
                Value<bool> required = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsCompanion.insert(
                id: id,
                shiftId: shiftId,
                category: category,
                label: label,
                checked: checked,
                required: required,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistItemsTable,
      ChecklistItem,
      $$ChecklistItemsTableFilterComposer,
      $$ChecklistItemsTableOrderingComposer,
      $$ChecklistItemsTableAnnotationComposer,
      $$ChecklistItemsTableCreateCompanionBuilder,
      $$ChecklistItemsTableUpdateCompanionBuilder,
      (
        ChecklistItem,
        BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItem>,
      ),
      ChecklistItem,
      PrefetchHooks Function()
    >;
typedef $$HandoversTableCreateCompanionBuilder =
    HandoversCompanion Function({
      required String id,
      required String shiftId,
      Value<String> reportJson,
      Value<String?> nextTaskId,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$HandoversTableUpdateCompanionBuilder =
    HandoversCompanion Function({
      Value<String> id,
      Value<String> shiftId,
      Value<String> reportJson,
      Value<String?> nextTaskId,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$HandoversTableFilterComposer
    extends Composer<_$AppDatabase, $HandoversTable> {
  $$HandoversTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextTaskId => $composableBuilder(
    column: $table.nextTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HandoversTableOrderingComposer
    extends Composer<_$AppDatabase, $HandoversTable> {
  $$HandoversTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextTaskId => $composableBuilder(
    column: $table.nextTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HandoversTableAnnotationComposer
    extends Composer<_$AppDatabase, $HandoversTable> {
  $$HandoversTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get reportJson => $composableBuilder(
    column: $table.reportJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nextTaskId => $composableBuilder(
    column: $table.nextTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$HandoversTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HandoversTable,
          Handover,
          $$HandoversTableFilterComposer,
          $$HandoversTableOrderingComposer,
          $$HandoversTableAnnotationComposer,
          $$HandoversTableCreateCompanionBuilder,
          $$HandoversTableUpdateCompanionBuilder,
          (Handover, BaseReferences<_$AppDatabase, $HandoversTable, Handover>),
          Handover,
          PrefetchHooks Function()
        > {
  $$HandoversTableTableManager(_$AppDatabase db, $HandoversTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HandoversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HandoversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HandoversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> shiftId = const Value.absent(),
                Value<String> reportJson = const Value.absent(),
                Value<String?> nextTaskId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HandoversCompanion(
                id: id,
                shiftId: shiftId,
                reportJson: reportJson,
                nextTaskId: nextTaskId,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String shiftId,
                Value<String> reportJson = const Value.absent(),
                Value<String?> nextTaskId = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HandoversCompanion.insert(
                id: id,
                shiftId: shiftId,
                reportJson: reportJson,
                nextTaskId: nextTaskId,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HandoversTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HandoversTable,
      Handover,
      $$HandoversTableFilterComposer,
      $$HandoversTableOrderingComposer,
      $$HandoversTableAnnotationComposer,
      $$HandoversTableCreateCompanionBuilder,
      $$HandoversTableUpdateCompanionBuilder,
      (Handover, BaseReferences<_$AppDatabase, $HandoversTable, Handover>),
      Handover,
      PrefetchHooks Function()
    >;
typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      required String entity,
      required String recordId,
      required String op,
      required String payloadJson,
      required DateTime updatedAt,
      required DateTime createdAt,
      Value<int> attempts,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<int> id,
      Value<String> entity,
      Value<String> recordId,
      Value<String> op,
      Value<String> payloadJson,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> attempts,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$AppDatabase db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
              }) => OutboxEntriesCompanion(
                id: id,
                entity: entity,
                recordId: recordId,
                op: op,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                createdAt: createdAt,
                attempts: attempts,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entity,
                required String recordId,
                required String op,
                required String payloadJson,
                required DateTime updatedAt,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
              }) => OutboxEntriesCompanion.insert(
                id: id,
                entity: entity,
                recordId: recordId,
                op: op,
                payloadJson: payloadJson,
                updatedAt: updatedAt,
                createdAt: createdAt,
                attempts: attempts,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $OutboxEntriesTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncCursorsTableCreateCompanionBuilder =
    SyncCursorsCompanion Function({
      required String collection,
      required String cursor,
      Value<int> rowid,
    });
typedef $$SyncCursorsTableUpdateCompanionBuilder =
    SyncCursorsCompanion Function({
      Value<String> collection,
      Value<String> cursor,
      Value<int> rowid,
    });

class $$SyncCursorsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncCursorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cursor => $composableBuilder(
    column: $table.cursor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncCursorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCursorsTable> {
  $$SyncCursorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cursor =>
      $composableBuilder(column: $table.cursor, builder: (column) => column);
}

class $$SyncCursorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCursorsTable,
          SyncCursor,
          $$SyncCursorsTableFilterComposer,
          $$SyncCursorsTableOrderingComposer,
          $$SyncCursorsTableAnnotationComposer,
          $$SyncCursorsTableCreateCompanionBuilder,
          $$SyncCursorsTableUpdateCompanionBuilder,
          (
            SyncCursor,
            BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
          ),
          SyncCursor,
          PrefetchHooks Function()
        > {
  $$SyncCursorsTableTableManager(_$AppDatabase db, $SyncCursorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCursorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCursorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCursorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> collection = const Value.absent(),
                Value<String> cursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion(
                collection: collection,
                cursor: cursor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String collection,
                required String cursor,
                Value<int> rowid = const Value.absent(),
              }) => SyncCursorsCompanion.insert(
                collection: collection,
                cursor: cursor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncCursorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCursorsTable,
      SyncCursor,
      $$SyncCursorsTableFilterComposer,
      $$SyncCursorsTableOrderingComposer,
      $$SyncCursorsTableAnnotationComposer,
      $$SyncCursorsTableCreateCompanionBuilder,
      $$SyncCursorsTableUpdateCompanionBuilder,
      (
        SyncCursor,
        BaseReferences<_$AppDatabase, $SyncCursorsTable, SyncCursor>,
      ),
      SyncCursor,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$HandoversTableTableManager get handovers =>
      $$HandoversTableTableManager(_db, _db.handovers);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
  $$SyncCursorsTableTableManager get syncCursors =>
      $$SyncCursorsTableTableManager(_db, _db.syncCursors);
}
