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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CatTheme.panelHighlight, CatTheme.panel],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CatTheme.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 6),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: CatTheme.yellow.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, size: 17, color: CatTheme.yellow),
              ),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: CatTheme.textPrimary,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
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
    );
  }
}
