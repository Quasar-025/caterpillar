import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/alert_level.dart';
import '../../core/theme.dart';
import '../../safety/risk_state.dart';
import '../../telemetry/swing_direction.dart';
import '../../telemetry/tick.dart';

/// Converts machine-relative polar coordinates to canvas pixels.
///
/// Bearing 0° is machine-forward (up on screen). Angles increase clockwise.
Offset radarPolarToOffset({
  required Offset center,
  required double meters,
  required double bearingDeg,
  required double metersToPixels,
}) {
  final radians = bearingDeg * math.pi / 180;
  return Offset(
    center.dx + math.sin(radians) * meters * metersToPixels,
    center.dy - math.cos(radians) * meters * metersToPixels,
  );
}

double radarMetersToPixels(Size size, RiskZones zones) {
  final maxMeters = math.max(zones.attentionRadiusM, 1);
  final radius = math.min(size.width, size.height) / 2 - 24;
  return radius / maxMeters;
}

/// Read-only 360° view of [RiskState] plus the latest telemetry tick.
///
/// Zone radii, colours and the operator action come from the risk engine.
/// This widget never decides whether a situation is dangerous.
class SafetyRadar extends StatelessWidget {
  const SafetyRadar({super.key, required this.risk, required this.tick});

  final RiskState risk;
  final TelemetryTick? tick;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SafetyRadarPainter(risk: risk, tick: tick),
      child: const SizedBox.expand(),
    );
  }
}

class SafetyRadarPainter extends CustomPainter {
  SafetyRadarPainter({required this.risk, required this.tick});

  final RiskState risk;
  final TelemetryTick? tick;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = radarMetersToPixels(size, risk.zones);

    _drawZone(
      canvas,
      center,
      risk.zones.attentionRadiusM * scale,
      CatTheme.attention.withValues(alpha: 0.16),
      CatTheme.attention,
    );
    _drawZone(
      canvas,
      center,
      risk.zones.actionRadiusM * scale,
      CatTheme.action.withValues(alpha: 0.18),
      CatTheme.action,
    );
    _drawZone(
      canvas,
      center,
      risk.zones.swingRadiusM * scale,
      CatTheme.critical.withValues(alpha: 0.22),
      CatTheme.critical,
    );

    _drawSwingArc(canvas, center, scale);
    _drawMachine(canvas, center);
    _drawWorker(canvas, center, scale);
  }

  void _drawZone(
    Canvas canvas,
    Offset center,
    double radius,
    Color fill,
    Color stroke,
  ) {
    canvas.drawCircle(center, radius, Paint()..color = fill);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawSwingArc(Canvas canvas, Offset center, double scale) {
    final current = tick;
    if (current == null || current.swingDir == SwingDirection.center) return;

    final sweep = current.swingDir == SwingDirection.right
        ? math.pi / 2
        : -math.pi / 2;
    final start = (current.swingAngle - 90) * math.pi / 180;
    final rect = Rect.fromCircle(
      center: center,
      radius: risk.zones.swingRadiusM * scale,
    );
    canvas.drawArc(
      rect,
      start,
      sweep,
      true,
      Paint()..color = CatTheme.yellow.withValues(alpha: 0.28),
    );
  }

  void _drawMachine(Canvas canvas, Offset center) {
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 28, height: 40),
      const Radius.circular(4),
    );
    canvas.drawRRect(body, Paint()..color = CatTheme.yellow);
    canvas.drawCircle(
      center.translate(0, -16),
      5,
      Paint()..color = CatTheme.black,
    );
  }

  void _drawWorker(Canvas canvas, Offset center, double scale) {
    final current = tick;
    if (current == null) return;
    if (current.nearestPersonM > risk.zones.attentionRadiusM) return;

    final point = radarPolarToOffset(
      center: center,
      meters: current.nearestPersonM,
      bearingDeg: current.personBearingDeg,
      metersToPixels: scale,
    );
    final color = risk.primaryHazard == HazardType.proximity
        ? _colorFor(risk.level)
        : Colors.white;
    canvas.drawCircle(point, 7, Paint()..color = color);
    canvas.drawCircle(
      point,
      7,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  Color _colorFor(AlertLevel level) => switch (level) {
    AlertLevel.info => Colors.white,
    AlertLevel.attention => CatTheme.attention,
    AlertLevel.action => CatTheme.action,
    AlertLevel.critical => CatTheme.critical,
  };

  @override
  bool shouldRepaint(covariant SafetyRadarPainter oldDelegate) {
    return oldDelegate.risk != risk || oldDelegate.tick != tick;
  }
}
