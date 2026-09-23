enum TaskWidgetType {
  depth,
  grade,
  bucketLoad,
  proximity,
  loadLimit,
  stability,
  swingZone,
}

/// A configuration map defining which widgets are shown for each machine type + mode.
final Map<String, List<TaskWidgetType>> taskUiConfigMap = {
  // EXCAVATOR + DIG: depth, grade, bucket load, progress (progress is in header), proximity
  'EXCAVATOR_DIG': [
    TaskWidgetType.depth,
    TaskWidgetType.grade,
    TaskWidgetType.bucketLoad,
    TaskWidgetType.proximity,
  ],
  // EXCAVATOR + LIFT: load compared with the safe load limit, stability, swing zone (mini radar), proximity
  'EXCAVATOR_LIFT': [
    TaskWidgetType.loadLimit,
    TaskWidgetType.stability,
    TaskWidgetType.swingZone,
    TaskWidgetType.proximity,
  ],
  // Tier 3 fallbacks
  'LOADER_LOAD': [
    TaskWidgetType.bucketLoad,
    TaskWidgetType.proximity,
  ],
  'DOZER_GRADE': [
    TaskWidgetType.grade,
    TaskWidgetType.proximity,
  ],
};
