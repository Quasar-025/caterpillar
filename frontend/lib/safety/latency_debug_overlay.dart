import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'alert_providers.dart';

/// Debug overlay showing alert latency metrics (plan §10).
///
/// Displays:
///   - Last end-to-end latency (t0 → t3)
///   - p50 and p95 over a sliding window
///   - Breakdown: risk eval (t0→t1), alert (t1→t2), render (t2→t3)
///
/// Toggle with the debug fab or a long-press gesture.
class LatencyDebugOverlay extends ConsumerStatefulWidget {
  const LatencyDebugOverlay({super.key});

  @override
  ConsumerState<LatencyDebugOverlay> createState() =>
      _LatencyDebugOverlayState();
}

class _LatencyDebugOverlayState extends ConsumerState<LatencyDebugOverlay> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Refresh the overlay periodically so p50/p95 stay current.
    _refreshTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final probe = ref.watch(latencyProbeProvider);
    final e2e = probe.endToEnd;

    if (e2e == null) {
      return _buildCard(
        context,
        children: [
          const Text(
            'ALERT LATENCY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.white70,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No samples yet',
            style: TextStyle(fontSize: 12, color: Colors.white54),
          ),
        ],
      );
    }

    final riskEval = probe.riskEvaluation!;
    final alertProc = probe.alertProcessing!;
    final render = probe.render!;

    return _buildCard(
      context,
      children: [
        const Text(
          'ALERT LATENCY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.white70,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        _MetricRow(
          label: 'End-to-end',
          last: e2e.last,
          p50: e2e.p50,
          p95: e2e.p95,
          highlight: true,
        ),
        const Divider(height: 8, color: Colors.white12),
        _MetricRow(
          label: 'Risk eval',
          last: riskEval.last,
          p50: riskEval.p50,
          p95: riskEval.p95,
        ),
        _MetricRow(
          label: 'Alert proc',
          last: alertProc.last,
          p50: alertProc.p50,
          p95: alertProc.p95,
        ),
        _MetricRow(
          label: 'Render',
          last: render.last,
          p50: render.p50,
          p95: render.p95,
        ),
        const SizedBox(height: 4),
        Text(
          '${probe.sampleCount} samples',
          style: const TextStyle(fontSize: 10, color: Colors.white38),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.last,
    required this.p50,
    required this.p95,
    this.highlight = false,
  });

  final String label;
  final double last;
  final double p50;
  final double p95;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final color = highlight ? Colors.greenAccent : Colors.white70;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '${last.toStringAsFixed(1)} ms',
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            child: Text(
              'p50: ${p50.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 9, color: Colors.white38),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 48,
            child: Text(
              'p95: ${p95.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 9, color: Colors.white38),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
