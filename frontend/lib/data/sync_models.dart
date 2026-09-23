import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';

class SyncChange {
  const SyncChange({
    required this.entity,
    required this.id,
    required this.op,
    required this.updatedAt,
    this.payload,
  });

  final String entity;
  final String id;
  final String op;
  final DateTime updatedAt;
  final Map<String, dynamic>? payload;

  Map<String, dynamic> toJson() => {
        'entity': entity,
        'id': id,
        'op': op,
        'updated_at': updatedAt.toIso8601String(),
        'payload': payload,
      };

  factory SyncChange.fromJson(Map<String, dynamic> json) {
    return SyncChange(
      entity: json['entity'] as String,
      id: json['id'] as String,
      op: json['op'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      payload: json['payload'] == null ? null : Map<String, dynamic>.from(json['payload'] as Map),
    );
  }

  factory SyncChange.fromOutbox(OutboxEntry row) {
    return SyncChange(
      entity: row.entity,
      id: row.recordId,
      op: row.op,
      updatedAt: row.updatedAt,
      payload: jsonDecode(row.payloadJson) as Map<String, dynamic>?,
    );
  }
}

class PullResult {
  const PullResult({required this.cursor, required this.changes});

  final String cursor;
  final List<SyncChange> changes;
}

abstract class SyncApi {
  Future<void> push(List<SyncChange> changes);
  Future<PullResult> pull(String? since);
}

DateTime? parseOptionalDate(Object? value) {
  if (value == null || value == '') {
    return null;
  }
  return DateTime.parse(value.toString());
}

double asDouble(Object? value, [double fallback = 0]) {
  if (value == null) {
    return fallback;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.parse(value.toString());
}

int asInt(Object? value, [int fallback = 0]) {
  if (value == null) {
    return fallback;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.parse(value.toString());
}

Map<String, dynamic> taskToPayload(Task row) => {
      'id': row.id,
      'task_type': row.taskType,
      'machine_id': row.machineId,
      'machine_type': row.machineType,
      'operator_id': row.operatorId,
      'scheduled_start': row.scheduledStart.toIso8601String(),
      'scheduled_end': row.scheduledEnd.toIso8601String(),
      'start_time': row.startTime?.toIso8601String(),
      'end_time': row.endTime?.toIso8601String(),
      'actual_duration_min': row.actualDurationMin,
      'planned_quantity': row.plannedQuantity,
      'quantity_done': row.quantityDone,
      'progress_pct': row.progressPct,
      'cycle_time_sec': row.cycleTimeSec,
      'cycles_completed': row.cyclesCompleted,
      'ground_softness': row.groundSoftness,
      'rain': row.rain,
      'slope_deg': row.slopeDeg,
      'avg_load_pct': row.avgLoadPct,
      'is_night': row.isNight,
      'idle_min': row.idleMin,
      'fuel_used_l': row.fuelUsedL,
      'updated_at': row.updatedAt.toIso8601String(),
      'deleted_at': row.deletedAt?.toIso8601String(),
    };

TasksCompanion taskFromPayload(Map<String, dynamic> payload) {
  return TasksCompanion.insert(
    id: payload['id'] as String,
    taskType: payload['task_type'] as String,
    machineId: payload['machine_id'] as String,
    machineType: payload['machine_type'] as String,
    operatorId: payload['operator_id'] as String,
    scheduledStart: DateTime.parse(payload['scheduled_start'] as String),
    scheduledEnd: DateTime.parse(payload['scheduled_end'] as String),
    startTime: Value(parseOptionalDate(payload['start_time'])),
    endTime: Value(parseOptionalDate(payload['end_time'])),
    actualDurationMin: Value(payload['actual_duration_min'] == null ? null : asDouble(payload['actual_duration_min'])),
    plannedQuantity: Value(asDouble(payload['planned_quantity'])),
    quantityDone: Value(asDouble(payload['quantity_done'])),
    progressPct: Value(asDouble(payload['progress_pct'])),
    cycleTimeSec: Value(asDouble(payload['cycle_time_sec'])),
    cyclesCompleted: Value(asInt(payload['cycles_completed'])),
    groundSoftness: Value(asDouble(payload['ground_softness'])),
    rain: Value(asDouble(payload['rain'])),
    slopeDeg: Value(asDouble(payload['slope_deg'])),
    avgLoadPct: Value(asDouble(payload['avg_load_pct'])),
    isNight: Value(payload['is_night'] == true),
    idleMin: Value(asDouble(payload['idle_min'])),
    fuelUsedL: Value(asDouble(payload['fuel_used_l'])),
    updatedAt: DateTime.parse(payload['updated_at'] as String),
    deletedAt: Value(parseOptionalDate(payload['deleted_at'])),
  );
}

Map<String, dynamic> shiftToPayload(Shift row) => {
      'id': row.id,
      'operator_id': row.operatorId,
      'machine_id': row.machineId,
      'scheduled_start': row.scheduledStart.toIso8601String(),
      'scheduled_end': row.scheduledEnd.toIso8601String(),
      'started_at': row.startedAt?.toIso8601String(),
      'ended_at': row.endedAt?.toIso8601String(),
      'status': row.status,
      'updated_at': row.updatedAt.toIso8601String(),
      'deleted_at': row.deletedAt?.toIso8601String(),
    };

ShiftsCompanion shiftFromPayload(Map<String, dynamic> payload) {
  return ShiftsCompanion.insert(
    id: payload['id'] as String,
    operatorId: payload['operator_id'] as String,
    machineId: payload['machine_id'] as String,
    scheduledStart: DateTime.parse(payload['scheduled_start'] as String),
    scheduledEnd: DateTime.parse(payload['scheduled_end'] as String),
    startedAt: Value(parseOptionalDate(payload['started_at'])),
    endedAt: Value(parseOptionalDate(payload['ended_at'])),
    status: Value(payload['status'] as String? ?? 'planned'),
    updatedAt: DateTime.parse(payload['updated_at'] as String),
    deletedAt: Value(parseOptionalDate(payload['deleted_at'])),
  );
}

Map<String, dynamic> checklistToPayload(ChecklistItem row) => {
      'id': row.id,
      'shift_id': row.shiftId,
      'category': row.category,
      'label': row.label,
      'checked': row.checked,
      'required': row.required,
      'updated_at': row.updatedAt.toIso8601String(),
      'deleted_at': row.deletedAt?.toIso8601String(),
    };

ChecklistItemsCompanion checklistFromPayload(Map<String, dynamic> payload) {
  return ChecklistItemsCompanion.insert(
    id: payload['id'] as String,
    shiftId: payload['shift_id'] as String,
    category: payload['category'] as String,
    label: payload['label'] as String,
    checked: Value(payload['checked'] == true),
    required: Value(payload['required'] != false),
    updatedAt: DateTime.parse(payload['updated_at'] as String),
    deletedAt: Value(parseOptionalDate(payload['deleted_at'])),
  );
}

Map<String, dynamic> handoverToPayload(Handover row) => {
      'id': row.id,
      'shift_id': row.shiftId,
      'report_json': row.reportJson,
      'next_task_id': row.nextTaskId,
      'updated_at': row.updatedAt.toIso8601String(),
      'deleted_at': row.deletedAt?.toIso8601String(),
    };

HandoversCompanion handoverFromPayload(Map<String, dynamic> payload) {
  return HandoversCompanion.insert(
    id: payload['id'] as String,
    shiftId: payload['shift_id'] as String,
    reportJson: Value(payload['report_json'] as String? ?? '{}'),
    nextTaskId: Value(payload['next_task_id'] as String?),
    updatedAt: DateTime.parse(payload['updated_at'] as String),
    deletedAt: Value(parseOptionalDate(payload['deleted_at'])),
  );
}
