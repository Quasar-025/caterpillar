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
  final radius = math.max(1.0, math.min(size.width, size.height) / 2 - 36);
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
    final distance = tick?.nearestPersonM;
    return Semantics(
      label: distance == null
          ? 'Safety radar waiting for telemetry'
          : 'Safety radar. Nearest worker ${distance.toStringAsFixed(0)} metres away. '
                '${risk.action}',
      child: CustomPaint(
        painter: SafetyRadarPainter(risk: risk, tick: tick),
        child: const SizedBox.expand(),
      ),
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

    _drawGround(canvas, size, center, scale);
    _drawZone(
      canvas,
      center,
      risk.zones.attentionRadiusM * scale,
      CatTheme.attention.withValues(alpha: 0.07),
      CatTheme.attention,
      'CAUTION · ${risk.zones.attentionRadiusM.toStringAsFixed(0)} m',
    );
    _drawZone(
      canvas,
      center,
      risk.zones.actionRadiusM * scale,
      CatTheme.action.withValues(alpha: 0.10),
      CatTheme.action,
      'ACTION · ${risk.zones.actionRadiusM.toStringAsFixed(0)} m',
    );
    _drawZone(
      canvas,
      center,
      risk.zones.swingRadiusM * scale,
      CatTheme.critical.withValues(alpha: 0.15),
      CatTheme.critical,
      'SWING ZONE · ${risk.zones.swingRadiusM.toStringAsFixed(0)} m',
    );

    _drawHazardCorridor(canvas, center, scale);
    _drawSwingArc(canvas, center, scale);
    _drawMachine(canvas, center);
    _drawWorker(canvas, center, scale);
    _drawCompass(canvas, center, risk.zones.attentionRadiusM * scale);
  }

  void _drawGround(Canvas canvas, Size size, Offset center, double scale) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF101313),
    );
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;
    final spacing = math.max(24.0, scale * 4);
    for (double x = center.dx % spacing; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = center.dy % spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    canvas.drawCircle(
      center,
      3,
      Paint()..color = CatTheme.textMuted.withValues(alpha: 0.45),
    );
  }

  void _drawZone(
    Canvas canvas,
    Offset center,
    double radius,
    Color fill,
    Color stroke,
    String label,
  ) {
    canvas.drawCircle(center, radius, Paint()..color = fill);
    _drawDashedCircle(canvas, center, radius, stroke);
    _drawLabel(
      canvas,
      label,
      Offset(center.dx, center.dy - radius + 8),
      stroke,
    );
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
  ) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    const segments = 72;
    for (var i = 0; i < segments; i += 2) {
      final start = i / segments * math.pi * 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        math.pi * 2 / segments,
        false,
        paint,
      );
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset center, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.7,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = Rect.fromCenter(
      center: center,
      width: painter.width + 12,
      height: painter.height + 5,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()..color = const Color(0xFF101313).withValues(alpha: 0.92),
    );
    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
    );
  }

  void _drawHazardCorridor(Canvas canvas, Offset center, double scale) {
    final current = tick;
    if (current == null ||
        current.nearestPersonM > risk.zones.attentionRadiusM) {
      return;
    }
    final bearing = (current.personBearingDeg - 90) * math.pi / 180;
    final radius = risk.zones.attentionRadiusM * scale;
    final levelColor = _colorFor(risk.level);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      bearing - 0.18,
      0.36,
      true,
      Paint()..color = levelColor.withValues(alpha: 0.15),
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
      Paint()..color = CatTheme.yellow.withValues(alpha: 0.20),
    );
  }

  void _drawMachine(Canvas canvas, Offset center) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    final trackPaint = Paint()..color = const Color(0xFF2B3031);
    final trackStroke = Paint()
      ..color = CatTheme.textMuted.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final x in [-18.0, 18.0]) {
      final track = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(x, 7), width: 15, height: 52),
        const Radius.circular(6),
      );
      canvas.drawRRect(track, trackPaint);
      canvas.drawRRect(track, trackStroke);
      for (double y = -13; y <= 27; y += 8) {
        canvas.drawLine(
          Offset(x - 5, y),
          Offset(x + 5, y),
          Paint()
            ..color = Colors.black.withValues(alpha: 0.55)
            ..strokeWidth = 2,
        );
      }
    }

    final upperRotation = ((tick?.swingAngle ?? 20) - 20) * math.pi / 180;
    canvas.rotate(upperRotation);
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-19, -18, 38, 36),
      const Radius.circular(7),
    );
    canvas.drawRRect(body, Paint()..color = CatTheme.yellow);
    canvas.drawRRect(
      body,
      Paint()
        ..color = const Color(0xFFFFE275)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    final cabin = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-13, -14, 17, 19),
      const Radius.circular(4),
    );
    canvas.drawRRect(cabin, Paint()..color = const Color(0xFF202829));

    final boom = Path()
      ..moveTo(10, -7)
      ..quadraticBezierTo(38, -34, 57, -27)
      ..quadraticBezierTo(70, -21, 78, -9);
    canvas.drawPath(
      boom,
      Paint()
        ..color = const Color(0xFF202323)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      boom,
      Paint()
        ..color = CatTheme.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    final bucket = Path()
      ..moveTo(74, -14)
      ..lineTo(90, -9)
      ..lineTo(85, 4)
      ..lineTo(72, 1)
      ..close();
    canvas.drawPath(bucket, Paint()..color = CatTheme.yellow);
    canvas.restore();
  }

  void _drawWorker(Canvas canvas, Offset center, double scale) {
    final current = tick;
    if (current == null) return;
    final outsideZones = current.nearestPersonM > risk.zones.attentionRadiusM;
    final displayMeters = outsideZones
        ? risk.zones.attentionRadiusM * 0.82
        : current.nearestPersonM;

    final point = radarPolarToOffset(
      center: center,
      meters: displayMeters,
      bearingDeg: current.personBearingDeg,
      metersToPixels: scale,
    );
    final color = risk.primaryHazard == HazardType.proximity
        ? _colorFor(risk.level)
        : CatTheme.safe;
    canvas.drawCircle(
      point,
      15,
      Paint()..color = color.withValues(alpha: 0.14),
    );
    canvas.drawLine(
      center,
      point,
      Paint()
        ..color = color.withValues(alpha: 0.55)
        ..strokeWidth = 1,
    );
    canvas.drawCircle(point.translate(0, -5), 4, Paint()..color = color);
    canvas.drawLine(
      point.translate(0, -1),
      point.translate(0, 8),
      Paint()
        ..color = color
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      point,
      11,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    _drawLabel(
      canvas,
      outsideZones
          ? '${current.nearestPersonM.toStringAsFixed(0)} m · CLEAR'
          : '${current.nearestPersonM.toStringAsFixed(0)} m · WORKER',
      point.translate(0, 25),
      color,
    );
  }

  void _drawCompass(Canvas canvas, Offset center, double radius) {
    const style = TextStyle(
      color: CatTheme.textMuted,
      fontSize: 9,
      fontWeight: FontWeight.w800,
    );
    for (final entry in {
      'FWD': center.translate(0, -radius - 20),
      'AFT': center.translate(0, radius + 12),
      'L': center.translate(-radius - 18, 0),
      'R': center.translate(radius + 13, 0),
    }.entries) {
      final painter = TextPainter(
        text: TextSpan(text: entry.key, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, entry.value);
    }
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
