import 'dart:math';
import 'package:flutter/material.dart';
import 'package:healthapp/utils/constants/colors.dart';

class CustomPieChart extends StatelessWidget {
  final double percentage;
  final Color color;
  final bool showPercentage;

  const CustomPieChart({
    super.key,
    required this.percentage,
    this.color = Colors.purpleAccent,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: PieChartPainter(
          percentage: percentage*1.2,
          color: color,
        ),
        child: showPercentage ? Container(
          alignment: Alignment(0.7,-0.6),
          child: Text(
            '${percentage.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: TColors.white,
            ),
          ),
        ) : null,
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double percentage;
  final Color color;

  PieChartPainter({
    required this.percentage,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // Create gradients
    final fillGradient = SweepGradient(
      colors: [
        color.withOpacity(0.7),
        color,
      ],
      stops: const [0.0, 1.0],
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      transform: GradientRotation(-pi / 2),
    );

    // Background circle paint
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Gradient fill paint
    final fillPaint = Paint()
      ..shader = fillGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    // Draw background circle
    canvas.drawCircle(center, radius, bgPaint);

    // Calculate the sweep angle based on percentage
    final sweepAngle = 2 * pi * (percentage / 100);

    // Draw pie segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      true,
      fillPaint,
    );

    // Add inner shadow
    final innerShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius * 0.98, innerShadowPaint);

    // Add outer glow
    final outerGlowPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      outerGlowPaint,
    );
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.color != color;
  }
}

// Animation example:
class AnimatedPieChart extends StatefulWidget {
  final double percentage;
  final Color color;

  const AnimatedPieChart({
    super.key,
    required this.percentage,
    required this.color,
  });

  @override
  _AnimatedPieChartState createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPieChart(
          percentage: _animation.value,
          color: widget.color,
        );
      },
    );
  }
}