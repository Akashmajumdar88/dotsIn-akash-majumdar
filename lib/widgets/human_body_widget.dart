import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Interactive human body silhouette with selectable organs
class HumanBodyWidget extends StatefulWidget {
  final String? selectedOrganId;
  final Function(String organId) onOrganTapped;
  final Map<String, int> organScores;

  const HumanBodyWidget({
    super.key,
    this.selectedOrganId,
    required this.onOrganTapped,
    required this.organScores,
  });

  @override
  State<HumanBodyWidget> createState() => _HumanBodyWidgetState();
}

class _HumanBodyWidgetState extends State<HumanBodyWidget>
    with TickerProviderStateMixin {
  late Map<String, AnimationController> _pulseControllers;
  late Map<String, Animation<double>> _pulseAnimations;

  final _organPositions = {
    'brain': const Offset(0.5, 0.085),
    'lungs': const Offset(0.5, 0.285),
    'heart': const Offset(0.42, 0.275),
    'liver': const Offset(0.55, 0.365),
    'gut': const Offset(0.5, 0.47),
    'kidney': const Offset(0.5, 0.41),
    'immune': const Offset(0.5, 0.55),
  };


  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.good;
    if (score >= 65) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  void initState() {
    super.initState();
    _pulseControllers = {};
    _pulseAnimations = {};

    for (final id in _organPositions.keys) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      );
      final animation = Tween<double>(begin: 0.85, end: 1.15).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
      _pulseControllers[id] = controller;
      _pulseAnimations[id] = animation;
      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (final c in _pulseControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Stack(
          children: [
            // Body silhouette
            Center(
              child: CustomPaint(
                size: Size(width, height),
                painter: _BodySilhouettePainter(),
              ),
            ),
            // Organ dots
            ..._organPositions.entries.map((entry) {
              final id = entry.key;
              final pos = entry.value;
              final score = widget.organScores[id] ?? 75;
              final isSelected = widget.selectedOrganId == id;
              final color = _getScoreColor(score);

              return AnimatedBuilder(
                animation: _pulseAnimations[id]!,
                builder: (context, child) {
                  final scale = isSelected
                      ? _pulseAnimations[id]!.value
                      : 1.0;
                  return Positioned(
                    left: pos.dx * width - 18,
                    top: pos.dy * height - 18,
                    child: GestureDetector(
                      onTap: () => widget.onOrganTapped(id),
                      child: AnimatedScale(
                        scale: scale,
                        duration: const Duration(milliseconds: 150),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow
                            if (isSelected)
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color.withValues(alpha: 0.2),
                                ),
                              ),
                            // Main dot
                            Container(
                              width: isSelected ? 26 : 22,
                              height: isSelected ? 26 : 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color.withValues(alpha: isSelected ? 1.0 : 0.85),
                                border: Border.all(
                                  color: Colors.white,
                                  width: isSelected ? 2.5 : 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '$score',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSelected ? 7 : 6,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        );
      },
    );
  }
}

/// Simple human body outline
class _BodySilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surfaceCard.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final w = size.width;
    final h = size.height;

    // Head
    final headCenter = Offset(w * 0.5, h * 0.08);
    canvas.drawCircle(headCenter, w * 0.1, paint);
    canvas.drawCircle(headCenter, w * 0.1, outlinePaint);

    // Neck
    final neckPath = Path()
      ..moveTo(w * 0.44, h * 0.16)
      ..lineTo(w * 0.56, h * 0.16)
      ..lineTo(w * 0.56, h * 0.20)
      ..lineTo(w * 0.44, h * 0.20)
      ..close();
    canvas.drawPath(neckPath, paint);
    canvas.drawPath(neckPath, outlinePaint);

    // Torso
    final torsoPath = Path()
      ..moveTo(w * 0.30, h * 0.20)
      ..lineTo(w * 0.70, h * 0.20)
      ..lineTo(w * 0.68, h * 0.55)
      ..lineTo(w * 0.54, h * 0.57)
      ..lineTo(w * 0.46, h * 0.57)
      ..lineTo(w * 0.32, h * 0.55)
      ..close();
    canvas.drawPath(torsoPath, paint);
    canvas.drawPath(torsoPath, outlinePaint);

    // Left arm
    final leftArmPath = Path()
      ..moveTo(w * 0.30, h * 0.20)
      ..lineTo(w * 0.18, h * 0.22)
      ..lineTo(w * 0.12, h * 0.42)
      ..lineTo(w * 0.18, h * 0.43)
      ..lineTo(w * 0.24, h * 0.24)
      ..lineTo(w * 0.33, h * 0.22)
      ..close();
    canvas.drawPath(leftArmPath, paint);
    canvas.drawPath(leftArmPath, outlinePaint);

    // Right arm
    final rightArmPath = Path()
      ..moveTo(w * 0.70, h * 0.20)
      ..lineTo(w * 0.82, h * 0.22)
      ..lineTo(w * 0.88, h * 0.42)
      ..lineTo(w * 0.82, h * 0.43)
      ..lineTo(w * 0.76, h * 0.24)
      ..lineTo(w * 0.67, h * 0.22)
      ..close();
    canvas.drawPath(rightArmPath, paint);
    canvas.drawPath(rightArmPath, outlinePaint);

    // Left leg
    final leftLegPath = Path()
      ..moveTo(w * 0.33, h * 0.55)
      ..lineTo(w * 0.46, h * 0.57)
      ..lineTo(w * 0.44, h * 0.85)
      ..lineTo(w * 0.36, h * 0.86)
      ..close();
    canvas.drawPath(leftLegPath, paint);
    canvas.drawPath(leftLegPath, outlinePaint);

    // Right leg
    final rightLegPath = Path()
      ..moveTo(w * 0.67, h * 0.55)
      ..lineTo(w * 0.54, h * 0.57)
      ..lineTo(w * 0.56, h * 0.85)
      ..lineTo(w * 0.64, h * 0.86)
      ..close();
    canvas.drawPath(rightLegPath, paint);
    canvas.drawPath(rightLegPath, outlinePaint);
  }

  @override
  bool shouldRepaint(_BodySilhouettePainter oldDelegate) => false;
}
