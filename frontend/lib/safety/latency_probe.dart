import 'dart:collection';
import 'dart:math' as math;

/// Tracks latency from telemetry tick creation (t0) through to first frame
/// render (t3), per plan §10.
///
/// Timestamps:
///   t0: tick created (wall-clock)
///   t1: RiskState emitted (evaluatedAt in RiskState)
///   t2: haptic/audio fired (alertEmittedAt in ActiveAlert)
///   t3: first frame rendered with the alert (captured via addPostFrameCallback)
class LatencyProbe {
  LatencyProbe({this.windowSize = 100});

  final int windowSize;

  final _samples = Queue<LatencySample>();

  /// Record a complete latency sample.
  void record(LatencySample sample) {
    _samples.addLast(sample);
    while (_samples.length > windowSize) {
      _samples.removeFirst();
    }
  }

  /// The most recent sample, or `null` if none recorded.
  LatencySample? get last => _samples.isNotEmpty ? _samples.last : null;

  /// Total end-to-end latency (t0 → t3) percentiles.
  LatencyStats? get endToEnd {
    if (_samples.isEmpty) return null;
    final values = _samples.map((s) => s.endToEndMs).toList()..sort();
    return LatencyStats(
      last: values.last,
      p50: _percentile(values, 50),
      p95: _percentile(values, 95),
    );
  }

  /// Risk evaluation latency (t0 → t1) percentiles.
  LatencyStats? get riskEvaluation {
    if (_samples.isEmpty) return null;
    final values = _samples.map((s) => s.riskEvalMs).toList()..sort();
    return LatencyStats(
      last: values.last,
      p50: _percentile(values, 50),
      p95: _percentile(values, 95),
    );
  }

  /// Alert processing latency (t1 → t2) percentiles.
  LatencyStats? get alertProcessing {
    if (_samples.isEmpty) return null;
    final values = _samples.map((s) => s.alertProcessMs).toList()..sort();
    return LatencyStats(
      last: values.last,
      p50: _percentile(values, 50),
      p95: _percentile(values, 95),
    );
  }

  /// Render latency (t2 → t3) percentiles.
  LatencyStats? get render {
    if (_samples.isEmpty) return null;
    final values = _samples.map((s) => s.renderMs).toList()..sort();
    return LatencyStats(
      last: values.last,
      p50: _percentile(values, 50),
      p95: _percentile(values, 95),
    );
  }

  int get sampleCount => _samples.length;

  void reset() => _samples.clear();

  double _percentile(List<double> sorted, int p) {
    if (sorted.isEmpty) return 0;
    final idx = (p / 100 * (sorted.length - 1)).round();
    return sorted[math.min(idx, sorted.length - 1)];
  }
}

/// A single latency measurement through the safety pipeline.
class LatencySample {
  const LatencySample({
    required this.t0,
    required this.t1,
    required this.t2,
    required this.t3,
  });

  /// Tick created (wall-clock).
  final DateTime t0;

  /// RiskState emitted.
  final DateTime t1;

  /// Haptic/audio fired.
  final DateTime t2;

  /// First frame rendered with alert visible.
  final DateTime t3;

  /// t0 → t1 in milliseconds.
  double get riskEvalMs =>
      t1.difference(t0).inMicroseconds / 1000.0;

  /// t1 → t2 in milliseconds.
  double get alertProcessMs =>
      t2.difference(t1).inMicroseconds / 1000.0;

  /// t2 → t3 in milliseconds.
  double get renderMs =>
      t3.difference(t2).inMicroseconds / 1000.0;

  /// Total end-to-end t0 → t3 in milliseconds.
  double get endToEndMs =>
      t3.difference(t0).inMicroseconds / 1000.0;
}

/// Percentile statistics over a sliding window.
class LatencyStats {
  const LatencyStats({
    required this.last,
    required this.p50,
    required this.p95,
  });

  /// Most recent value.
  final double last;

  /// 50th percentile (median).
  final double p50;

  /// 95th percentile.
  final double p95;

  @override
  String toString() =>
      'last: ${last.toStringAsFixed(1)} ms, '
      'p50: ${p50.toStringAsFixed(1)} ms, '
      'p95: ${p95.toStringAsFixed(1)} ms';
}
