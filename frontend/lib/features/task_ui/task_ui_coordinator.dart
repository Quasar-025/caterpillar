import 'package:flutter/material.dart';

import '../../../telemetry/tick.dart';
import 'task_ui_config.dart';
import 'widgets/task_widgets.dart';

class TaskUiCoordinator extends StatelessWidget {
  const TaskUiCoordinator({super.key, required this.tick});

  final TelemetryTick tick;

  @override
  Widget build(BuildContext context) {
    // Determine the machine type from the ID prefix (e.g. EXC001 -> EXCAVATOR)
    String machineType = 'EXCAVATOR';
    if (tick.machineId.startsWith('LOD')) {
      machineType = 'LOADER';
    } else if (tick.machineId.startsWith('DOZ')) {
      machineType = 'DOZER';
    }

    final modeLabel = tick.mode.name.toUpperCase();
    final configKey = '${machineType}_$modeLabel';

    // Look up the configuration, fallback to DIG if not found
    final widgetTypes = taskUiConfigMap[configKey] ?? taskUiConfigMap['EXCAVATOR_DIG']!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        
        final children = widgetTypes.map((type) {
          final widget = _buildWidget(type);
          if (isWide) {
            return Expanded(child: widget);
          } else {
            // For compact layouts, we could wrap them
            return SizedBox(
              width: (constraints.maxWidth / 2) - 10,
              height: 146, // increased height for wrap
              child: widget,
            );
          }
        }).toList();

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _insertSpacers(children, const SizedBox(width: 12)),
          );
        } else {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: children,
          );
        }
      },
    );
  }

  Widget _buildWidget(TaskWidgetType type) {
    switch (type) {
      case TaskWidgetType.depth:
        return DepthWidget(tick: tick);
      case TaskWidgetType.grade:
        return GradeWidget(tick: tick);
      case TaskWidgetType.bucketLoad:
        return BucketLoadWidget(tick: tick);
      case TaskWidgetType.proximity:
        return ProximityWidget(tick: tick);
      case TaskWidgetType.loadLimit:
        return LoadLimitWidget(tick: tick);
      case TaskWidgetType.stability:
        return StabilityWidget(tick: tick);
      case TaskWidgetType.swingZone:
        return SwingZoneWidget(tick: tick);
    }
  }

  List<Widget> _insertSpacers(List<Widget> items, Widget spacer) {
    final List<Widget> spaced = [];
    for (var i = 0; i < items.length; i++) {
      spaced.add(items[i]);
      if (i < items.length - 1) spaced.add(spacer);
    }
    return spaced;
  }
}
