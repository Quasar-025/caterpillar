import 'machine_mode.dart';

/// A loaded scenario describing a demo or test session.
///
/// JSON format (plan §7):
/// ```json
/// {
///   "machine": "EXC001",
///   "operator": "OP001",
///   "timeline": [
///     {"t": "08:00", "mode": "DIG", "task": "T1"}
///   ],
///   "events": [
///     {"t": "09:10", "set": {"rain": 1}},
///     {"t": "09:55", "worker_path": "approach_swing_zone"}
///   ]
/// }
/// ```
class Scenario {
  const Scenario({
    required this.machine,
    required this.operator,
    required this.timeline,
    required this.events,
  });

  final String machine;
  final String operator;
  final List<TimelineEntry> timeline;
  final List<ScenarioEvent> events;

  /// Total simulated duration — from the first timeline entry to the last,
  /// plus a 10-minute tail so the final segment has room to run.
  Duration get totalDuration {
    if (timeline.isEmpty) return Duration.zero;
    return timeline.last.offset -
        timeline.first.offset +
        const Duration(minutes: 10);
  }

  factory Scenario.fromJson(Map<String, dynamic> j) {
    final timeline = (j['timeline'] as List)
        .map((e) => TimelineEntry.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.offset.compareTo(b.offset));
    if (timeline.isEmpty) {
      throw const FormatException('A scenario needs at least one timeline entry');
    }
    for (var index = 1; index < timeline.length; index++) {
      if (timeline[index - 1].offset == timeline[index].offset) {
        throw const FormatException(
          'Scenario timeline entries must use unique times',
        );
      }
    }

    final rawEvents = j['events'] as List?;
    final events = rawEvents
            ?.map((e) => ScenarioEvent.fromJson(e as Map<String, dynamic>))
            .toList() ??
        <ScenarioEvent>[];
    events.sort((a, b) => a.offset.compareTo(b.offset));

    return Scenario(
      machine: j['machine'] as String,
      operator: j['operator'] as String? ?? 'OP001',
      timeline: timeline,
      events: events,
    );
  }
}

/// A mode change at a point in simulated time.
class TimelineEntry {
  const TimelineEntry({
    required this.offset,
    required this.mode,
    required this.taskId,
  });

  /// Offset from scenario start (e.g. "08:00" → Duration(hours: 8)).
  final Duration offset;
  final MachineMode mode;
  final String taskId;

  factory TimelineEntry.fromJson(Map<String, dynamic> j) {
    return TimelineEntry(
      offset: _parseTime(j['t'] as String),
      mode: MachineMode.fromString(j['mode'] as String),
      taskId: j['task'] as String,
    );
  }
}

/// A scripted event that changes the environment or triggers a worker path.
class ScenarioEvent {
  const ScenarioEvent({
    required this.offset,
    this.setValues,
    this.workerPath,
  });

  final Duration offset;

  /// Key-value overrides applied to the simulator state.
  /// Keys: `rain`, `ground_softness`, `visibility`, `is_night`,
  /// `slope_deg`, `seatbelt`, `idle_min`, etc.
  final Map<String, dynamic>? setValues;

  /// Named worker-approach script, e.g. `"approach_swing_zone"`.
  final String? workerPath;

  bool get isSet => setValues != null;
  bool get isWorkerPath => workerPath != null;

  factory ScenarioEvent.fromJson(Map<String, dynamic> j) {
    return ScenarioEvent(
      offset: _parseTime(j['t'] as String),
      setValues: j['set'] as Map<String, dynamic>?,
      workerPath: j['worker_path'] as String?,
    );
  }
}

/// Parses `"HH:MM"` into a [Duration].
Duration _parseTime(String t) {
  final parts = t.split(':');
  return Duration(
    hours: int.parse(parts[0]),
    minutes: int.parse(parts[1]),
  );
}
