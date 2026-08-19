import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A custom health score ring with gradient arc and animated fill
class HealthScoreRing extends StatefulWidget {
  final double score; // 0-100
  final double size;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final bool showLabel;
  final String? label;
  final bool animate;

  const HealthScoreRing({
    super.key,
    required this.score,
    this.size = 120,
    this.color = AppColors.primary,
    this.backgroundColor = const Color(0xFF1E2B42),
    this.strokeWidth = 10,
    this.showLabel = true,
    this.label,
    this.animate = true,
  });

  @override
  State<HealthScoreRing> createState() => _HealthScoreRingState();
}

class _HealthScoreRingState extends State<HealthScoreRing>
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
    _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    if (widget.animate) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.good;
    if (score >= 60) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _ScoreRingPainter(
              progress: _animation.value,
              color: widget.color == AppColors.primary
                  ? _getScoreColor(widget.score)
                  : widget.color,
              backgroundColor: widget.backgroundColor,
              strokeWidth: widget.strokeWidth,
            ),
            child: widget.showLabel
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(widget.score * _animation.value).round()}',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: widget.size * 0.22,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                        if (widget.label != null)
                          Text(
                            widget.label!,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: widget.size * 0.1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _ScoreRingPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Glow effect
    if (progress > 0) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        glowPaint,
      );
    }

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi * progress,
        colors: [
          color.withValues(alpha: 0.7),
          color,
        ],
        tileMode: TileMode.clamp,
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // Dot at the end
    if (progress > 0.02) {
      final angle = -math.pi / 2 + 2 * math.pi * progress;
      final dotCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final dotPaint = Paint()..color = Colors.white;
      canvas.drawCircle(dotCenter, strokeWidth / 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ScoreRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// A small compact ring for lists/cards
class MiniScoreRing extends StatelessWidget {
  final double score;
  final double size;
  final Color color;

  const MiniScoreRing({
    super.key,
    required this.score,
    this.size = 56,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return HealthScoreRing(
      score: score,
      size: size,
      color: color,
      strokeWidth: 5,
      showLabel: true,
      animate: true,
    );
  }
}
