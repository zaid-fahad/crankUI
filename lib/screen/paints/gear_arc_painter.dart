import 'dart:math';
import 'package:flutter/material.dart';

class GearArcPainter extends CustomPainter {
  final double screenHeight;
  final String selectedGear;

  GearArcPainter({
    required this.screenHeight,
    required this.selectedGear,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = (30 * screenHeight) / 480;

    // Increase arc dimensions for more outer look
    final arcWidth = size.height * 1.2;
    final arcHeight = size.height * 1.35;
    final center = Offset(size.width - arcWidth / 2 - 20, arcHeight / 2);

    // Adjust rect to make stroke appear outside
    final outerRect = Rect.fromCenter(
      center: center,
      width: arcWidth - strokeWidth,
      height: arcHeight - strokeWidth,
    );

    // Background arc
    final bgPaint = Paint()
      ..color = const Color(0xFF313030)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Make sweep a bit bigger than half-circle
    final totalAngle = 3.8 * pi / 6.5; // ~150 degrees
    canvas.drawArc(
      outerRect,
      -4 * pi / 12, // start a little left
      totalAngle,
      false,
      bgPaint,
    );

    final gears = ["R", "N", "D", "3", "P"];
    final segmentCount = gears.length;

    final gapAngle = pi / 100; // small gap
    final segmentAngle = (totalAngle - gapAngle * (segmentCount - 1)) / segmentCount;

    for (int i = 0; i < segmentCount; i++) {
      final isActive = selectedGear == gears[i];

      final paint = Paint()
        ..color = isActive ? Colors.white : Colors.grey[700]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      final startAngle = -4 * pi / 12 + i * (segmentAngle + gapAngle);
      canvas.drawArc(
        outerRect,
        startAngle,
        segmentAngle,
        false,
        paint,
      );

      // Draw label in the middle of segment
      final textPainter = TextPainter(
        text: TextSpan(
          text: gears[i],
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey[400],
            fontSize: (16 * screenHeight) / 480,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final angle = startAngle + segmentAngle / 2;

      // Place text slightly inside the arc to avoid overlap
      final radiusX = (arcWidth - strokeWidth * 1.2) / 2;
      final radiusY = (arcHeight - strokeWidth * 1.2) / 2;

      final dx = center.dx + radiusX * cos(angle);
      final dy = center.dy + radiusY * sin(angle);

      textPainter.paint(
        canvas,
        Offset(dx - textPainter.width / 2, dy - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(GearArcPainter oldDelegate) =>
      oldDelegate.selectedGear != selectedGear;
}
