import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../telemetry/tick.dart';
import 'shared.dart';

class DepthWidget extends StatelessWidget {
  const DepthWidget({super.key, required this.tick});
  final TelemetryTick tick;

  @override
  Widget build(BuildContext context) {
    // We don't have true depth in telemetry, so we mock it based on progress
    // so it looks lively for the demo.
    final mockDepth = (tick.progressPct / 100.0) * 2.5; 
    
    return TaskPanel(
      title: 'Depth',
      icon: Icons.height_rounded,
      child: TaskMeasure(
        value: '${mockDepth.toStringAsFixed(1)} m',
        label: 'TARGET: 2.5 m',
      ),
    );
  }
}

class GradeWidget extends StatelessWidget {
  const GradeWidget({super.key, required this.tick});
  final TelemetryTick tick;

  @override
  Widget build(BuildContext context) {
    final grade = tick.slopeDeg;
    final isLevel = grade.abs() < 2.0;

    return TaskPanel(
      title: 'Grade',
      icon: Icons.signal_cellular_alt_rounded,
      child: TaskMeasure(
        value: '${grade.toStringAsFixed(1)}°',
        label: isLevel ? 'LEVEL' : 'UNEVEN',
        valueColor: isLevel ? CatTheme.safe : CatTheme.attention,
      ),
    );
  }
}

class BucketLoadWidget extends StatelessWidget {
  const BucketLoadWidget({super.key, required this.tick});
  final TelemetryTick tick;

  @override
  Widget build(BuildContext context) {
    return TaskPanel(
      title: 'Bucket',
      icon: Icons.monitor_weight_outlined,
      child: TaskMeasure(
        value: '${tick.loadPct.toStringAsFixed(0)}%',
        label: 'FILL FACTOR',
      ),
    );
  }
}

class ProximityWidget extends StatelessWidget {
  const ProximityWidget({super.key, required this.tick});
  final TelemetryTick tick;

  @override
  Widget build(BuildContext context) {
    final distance = tick.nearestPersonM;
    final isSafe = distance > 15.0;

    return TaskPanel(
      title: 'Proximity',
      icon: Icons.radar_rounded,
      child: TaskMeasure(
        value: '${distance.toStringAsFixed(0)} m',
        label: 'NEAREST WORKER',
        valueColor: isSafe ? CatTheme.textPrimary : CatTheme.action,
      ),
    );
  }
}

class LoadLimitWidget extends StatelessWidget {
  const LoadLimitWidget({super.key, required this.tick});
  final TelemetryTick tick;

  @override
  Widget build(BuildContext context) {
    final overLimit = tick.loadPct > tick.safeLoadLimit;
    
    return TaskPanel(
      title: 'Load',
      icon: Icons.scale_rounded,
      child: TaskMeasure(
        value: '${tick.loadPct.toStringAsFixed(0)}%',
        label: 'LIMIT: ${tick.safeLoadLimit.toStringAsFixed(0)}%',
        valueColor: overLimit ? CatTheme.critical : CatTheme.safe,
      ),
    );
  }
}

class StabilityWidget extends StatelessWidget {
  const StabilityWidget({super.key, required this.tick});
  final TelemetryTick tick;

  @override
  Widget build(BuildContext context) {
    final isStable = tick.stabilityIdx > 0.8;
    return TaskPanel(
      title: 'Stability',
      icon: Icons.balance_rounded,
      child: TaskMeasure(
        value: '${(tick.stabilityIdx * 100).toStringAsFixed(0)}%',
        label: 'STABILITY INDEX',
        valueColor: isStable ? CatTheme.safe : CatTheme.action,
      ),
    );
  }
}

class SwingZoneWidget extends StatelessWidget {
  const SwingZoneWidget({super.key, required this.tick});
  final TelemetryTick tick;

  @override
  Widget build(BuildContext context) {
    // A mini-radar/swing representation
    return TaskPanel(
      title: 'Swing',
      icon: Icons.sync_rounded,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(
                Icons.arrow_left_rounded, 
                color: tick.swingAngle < -10 ? CatTheme.yellow : CatTheme.textMuted,
                size: 32,
              ),
              Text(
                '${tick.swingAngle.abs().toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: CatTheme.textPrimary,
                ),
              ),
              Icon(
                Icons.arrow_right_rounded, 
                color: tick.swingAngle > 10 ? CatTheme.yellow : CatTheme.textMuted,
                size: 32,
              ),
            ],
          ),
          ),
          const SizedBox(height: 4),
          Text(
            tick.swingDir.label,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
        ),
      ),
    );
  }
}
