import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_providers.dart';
import '../../safety/alert_providers.dart';
import '../../domain/unusual_providers.dart';
import 'handover_report.dart';

final handoverReportProvider = FutureProvider<HandoverReport>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final alertManager = ref.watch(alertManagerProvider);
  final unusualInsights = ref.watch(unusualInsightsProvider).value ?? [];

  // Get active shift
  final shift = await db.select(db.shifts).getSingleOrNull();
  if (shift == null) {
    throw Exception('No active shift found');
  }

  // Get all tasks for this shift's operator
  final allTasks = await (db.select(db.tasks)
        ..where((t) => t.operatorId.equals(shift.operatorId)))
      .get();

  final tasksDone = <TaskSummary>[];
  final tasksRemaining = <TaskSummary>[];
  TaskSummary? nextTask;

  for (final t in allTasks) {
    final summary = TaskSummary(
      id: t.id,
      taskType: t.taskType,
      progressPct: t.progressPct,
      isComplete: t.progressPct >= 100,
    );
    if (summary.isComplete) {
      tasksDone.add(summary);
    } else {
      tasksRemaining.add(summary);
      if (nextTask == null) {
        nextTask = summary;
      }
    }
  }

  // Deduplicate and gather unusual behaviours
  final unusualBehaviours =
      unusualInsights.map((e) => e.category).toSet().toList();

  return HandoverReport(
    shiftId: shift.id,
    operatorId: shift.operatorId,
    machineId: shift.machineId,
    generatedAt: DateTime.now(),
    tasksDone: tasksDone,
    tasksRemaining: tasksRemaining,
    nextTask: nextTask,
    alertCounts: alertManager.alertCounts,
    unusualBehaviours: unusualBehaviours,
    machineStatus: 'OK', // Could be determined by open issues / telemetry
    openIssues: [], // Open issues from checklist or telemetry
  );
});
