import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class TaskPanel extends StatelessWidget {
  const TaskPanel({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CatTheme.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CatTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: CatTheme.yellow),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class TaskMeasure extends StatelessWidget {
  const TaskMeasure({
    super.key,
    required this.value,
    required this.label,
    this.valueColor = CatTheme.textPrimary,
    this.compact = false,
  });

  final String value;
  final String label;
  final Color valueColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: compact ? 21 : 32,
              fontWeight: FontWeight.w800,
              letterSpacing: compact ? 0 : -0.6,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        ],
      ),
    );
  }
}
