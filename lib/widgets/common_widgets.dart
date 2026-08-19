import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Glassmorphism card widget
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final Gradient? gradient;
  final double borderOpacity;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.color,
    this.gradient,
    this.borderOpacity = 0.12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceCard,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: borderOpacity),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withValues(alpha: 0.05),
          highlightColor: Colors.white.withValues(alpha: 0.03),
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Status chip for health statuses
class StatusChip extends StatelessWidget {
  final String status;
  final bool small;

  const StatusChip({super.key, required this.status, this.small = false});

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'good':
        return AppColors.good;
      case 'warning':
        return AppColors.warning;
      case 'danger':
      case 'bad':
        return AppColors.danger;
      case 'mild':
        return AppColors.warning;
      case 'moderate':
        return AppColors.danger.withValues(alpha: 0.8);
      default:
        return AppColors.info;
    }
  }

  String _getLabel() {
    switch (status.toLowerCase()) {
      case 'good':
        return 'Optimal';
      case 'warning':
        return 'Monitor';
      case 'danger':
      case 'bad':
        return 'Attention';
      case 'mild':
        return 'Mild';
      case 'moderate':
        return 'Moderate';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    return Container(
      padding: small
          ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          color: color,
          fontSize: small ? 9 : 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// Section header with optional see all button
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing ??
            (onSeeAll != null
                ? GestureDetector(
                    onTap: onSeeAll,
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : const SizedBox()),
      ],
    );
  }
}

/// Gradient icon container
class GradientIconBox extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;
  final double size;

  const GradientIconBox({
    super.key,
    required this.icon,
    required this.gradient,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }
}

/// Animated info card for strengths/weaknesses
class InsightCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isStrength;
  final int index;

  const InsightCard({
    super.key,
    required this.data,
    required this.isStrength,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(data['color']));
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _iconFromString(data['icon']),
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data['description'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isStrength ? Icons.trending_up_rounded : Icons.warning_amber_rounded,
            color: isStrength ? AppColors.good : AppColors.warning,
            size: 18,
          ),
        ],
      ),
    );
  }

  IconData _iconFromString(String name) {
    const icons = {
      'water_drop': Icons.water_drop,
      'psychology': Icons.psychology,
      'monitor_heart': Icons.monitor_heart,
      'favorite': Icons.favorite,
      'bubble_chart': Icons.bubble_chart,
      'lunch_dining': Icons.lunch_dining,
      'wb_sunny': Icons.wb_sunny,
      'biotech': Icons.biotech,
      'favorite_border': Icons.favorite_border,
    };
    return icons[name] ?? Icons.circle;
  }
}
