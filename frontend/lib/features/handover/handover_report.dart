import '../../core/alert_level.dart';
import '../../domain/unusual_behaviour.dart';

class TaskSummary {
  const TaskSummary({
    required this.id,
    required this.taskType,
    required this.progressPct,
    required this.isComplete,
  });

  final String id;
  final String taskType;
  final double progressPct;
  final bool isComplete;
}

class HandoverReport {
  const HandoverReport({
    required this.shiftId,
    required this.operatorId,
    required this.machineId,
    required this.generatedAt,
    required this.tasksDone,
    required this.tasksRemaining,
    required this.nextTask,
    required this.alertCounts,
    required this.unusualBehaviours,
    required this.machineStatus,
    required this.openIssues,
  });

  final String shiftId;
  final String operatorId;
  final String machineId;
  final DateTime generatedAt;
  final List<TaskSummary> tasksDone;
  final List<TaskSummary> tasksRemaining;
  final TaskSummary? nextTask;
  final Map<AlertLevel, int> alertCounts;
  final List<BehaviourCategory> unusualBehaviours;
  final String machineStatus;
  final List<String> openIssues;
}
