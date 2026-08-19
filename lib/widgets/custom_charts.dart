import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom metric bar painter used for blood marker ranges
class MetricRangePainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  final Color color;

  MetricRangePainter({
    required this.value,
    required this.min,
    required this.max,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = AppColors.surfaceElevated
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4),
    );
    canvas.drawRRect(rrect, bgPaint);

    double progress = 0;
    if (max > min) {
      progress = ((value - min) / (max - min)).clamp(0.0, 1.0);
    }

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.6), color],
      ).createShader(Rect.fromLTWH(0, 0, size.width * progress, size.height));

    final fillRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width * progress, size.height),
      const Radius.circular(4),
    );
    canvas.drawRRect(fillRRect, fillPaint);

    // Indicator dot
    final dotX = size.width * progress;
    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(dotX, size.height / 2), size.height * 0.7, dotPaint);
  }

  @override
  bool shouldRepaint(MetricRangePainter oldDelegate) =>
      oldDelegate.value != value;
}

/// SparkLine chart using CustomPainter
class SparkLineChart extends StatefulWidget {
  final List<double> data;
  final Color color;
  final double height;
  final bool filled;

  const SparkLineChart({
    super.key,
    required this.data,
    required this.color,
    this.height = 60,
    this.filled = true,
  });

  @override
  State<SparkLineChart> createState() => _SparkLineChartState();
}

class _SparkLineChartState extends State<SparkLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
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
        return SizedBox(
          height: widget.height,
          child: CustomPaint(
            painter: _SparkLinePainter(
              data: widget.data,
              color: widget.color,
              progress: _animation.value,
              filled: widget.filled,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _SparkLinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double progress;
  final bool filled;

  _SparkLinePainter({
    required this.data,
    required this.color,
    required this.progress,
    required this.filled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minVal = data.reduce(math.min);
    final maxVal = data.reduce(math.max);
    final range = (maxVal - minVal).abs();

    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * size.width;
      final y = range == 0
          ? size.height / 2
          : size.height - ((data[i] - minVal) / range) * size.height * 0.8 -
              size.height * 0.1;
      points.add(Offset(x, y));
    }

    // Draw filled gradient
    if (filled && points.isNotEmpty) {
      final int visiblePointCount = (points.length * progress).ceil()
          .clamp(1, points.length);
      final visiblePoints = points.sublist(0, visiblePointCount);

      final fillPath = Path();
      fillPath.moveTo(visiblePoints.first.dx, size.height);
      for (final p in visiblePoints) {
        fillPath.lineTo(p.dx, p.dy);
      }
      fillPath.lineTo(visiblePoints.last.dx, size.height);
      fillPath.close();

      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw line
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (points.length > 1) {
      final int visiblePointCount = (points.length * progress).ceil()
          .clamp(1, points.length);
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < visiblePointCount; i++) {
        final cp1 = Offset(
          (points[i - 1].dx + points[i].dx) / 2,
          points[i - 1].dy,
        );
        final cp2 = Offset(
          (points[i - 1].dx + points[i].dx) / 2,
          points[i].dy,
        );
        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw last visible point
    if (points.isNotEmpty && progress > 0) {
      final int idx = ((points.length - 1) * progress).round()
          .clamp(0, points.length - 1);
      final dotPaint = Paint()..color = color;
      canvas.drawCircle(points[idx], 4, dotPaint);
      final innerDotPaint = Paint()..color = Colors.white;
      canvas.drawCircle(points[idx], 2, innerDotPaint);
    }
  }

  @override
  bool shouldRepaint(_SparkLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Radial gauge for a single metric
class MetricGauge extends StatelessWidget {
  final double value; // 0-1
  final Color color;
  final double size;

  const MetricGauge({
    super.key,
    required this.value,
    required this.color,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MetricGaugePainter(value: value, color: color),
      ),
    );
  }
}

class _MetricGaugePainter extends CustomPainter {
  final double value;
  final Color color;

  _MetricGaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    final bgPaint = Paint()
      ..color = AppColors.surfaceElevated
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * value.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_MetricGaugePainter oldDelegate) =>
      oldDelegate.value != value;
}
