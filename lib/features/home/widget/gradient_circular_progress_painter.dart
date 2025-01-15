import 'package:flutter/material.dart';

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;

  GradientCircularProgressPainter({
    required this.progress,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint backgroundPaint = Paint()
      ..color = Color(0xFFF7F8F8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final Paint progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, backgroundPaint);

    // Draw progress arc
    final double startAngle = -90 * (3.14159 / 180); // Start at the top
    final double sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}