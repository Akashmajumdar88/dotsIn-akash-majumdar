import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/health_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() =>
      _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _anim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  IconData _iconFromString(String name) {
    const icons = {
      'restaurant': Icons.restaurant,
      'no_food': Icons.no_food,
      'set_meal': Icons.set_meal,
      'medication': Icons.medication,
      'directions_run': Icons.directions_run,
      'no_drinks': Icons.no_drinks,
      'bedtime': Icons.bedtime,
    };
    return icons[name] ?? Icons.star;
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.danger;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Nutrition':
        return AppColors.good;
      case 'Supplements':
        return AppColors.secondary;
      case 'Lifestyle':
        return AppColors.primary;
      default:
        return AppColors.info;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Nutrition':
        return Icons.restaurant_menu_rounded;
      case 'Supplements':
        return Icons.medication_rounded;
      case 'Lifestyle':
        return Icons.self_improvement_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = ref.watch(recommendationsProvider);
    final strengths = ref.watch(strengthsProvider);
    final weaknesses = ref.watch(weaknessesProvider);

    return FadeTransition(
      opacity: _anim,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Plan',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Personalized recommendations',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Quick summary row
            Row(
              children: [
                _buildQuickStat('${strengths.length}', 'Strengths', AppColors.good),
                const SizedBox(width: 10),
                _buildQuickStat('${weaknesses.length}', 'To Improve', AppColors.warning),
                const SizedBox(width: 10),
                _buildQuickStat(
                  '${recommendations.fold<int>(0, (sum, r) => sum + (r['items'] as List).length)}',
                  'Actions',
                  AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recommendations by category
            ...recommendations
                .map((cat) => _buildCategorySection(cat))
                ,
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String value, String label, Color color) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(Map<String, dynamic> category) {
    final catName = category['category'] as String;
    final items = List<Map<String, dynamic>>.from(category['items'] ?? []);
    final catColor = _getCategoryColor(catName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getCategoryIcon(catName), color: catColor, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              catName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...items.map((item) => _buildRecommendationCard(item, catColor)),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildRecommendationCard(
      Map<String, dynamic> item, Color categoryColor) {
    final priorityColor = _getPriorityColor(item['priority']);
    final icon = _iconFromString(item['icon']);

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: categoryColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['priority'].toString().toUpperCase(),
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
