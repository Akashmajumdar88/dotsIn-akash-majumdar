import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/health_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/health_score_ring.dart';
import '../widgets/common_widgets.dart';

class GenomicsScreen extends ConsumerStatefulWidget {
  const GenomicsScreen({super.key});

  @override
  ConsumerState<GenomicsScreen> createState() => _GenomicsScreenState();
}

class _GenomicsScreenState extends ConsumerState<GenomicsScreen>
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

  @override
  Widget build(BuildContext context) {
    final genomics = ref.watch(genomicsProvider);
    final traits = List<Map<String, dynamic>>.from(genomics['traits'] ?? []);
    final ancestry = List<Map<String, dynamic>>.from(
        genomics['ancestryComposition'] ?? []);

    return FadeTransition(
      opacity: _anim,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Genomics',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your DNA-based health insights',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Genomic overview card
            GlassCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1040), Color(0xFF0D1B2A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Row(
                children: [
                  HealthScoreRing(
                    score: (genomics['score'] as int).toDouble(),
                    size: 90,
                    color: AppColors.secondary,
                    strokeWidth: 8,
                    label: 'Score',
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Genomic Health Score',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${genomics['score']}/100',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          genomics['summary'],
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Ancestry
            const SectionHeader(title: 'Ancestry Composition'),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: ancestry
                    .map((a) => _buildAncestryRow(a))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Genetic traits
            const SectionHeader(title: 'Genetic Traits'),
            const SizedBox(height: 12),
            ...traits.map((t) => _buildTraitCard(t)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAncestryRow(Map<String, dynamic> ancestry) {
    final percentage = ancestry['percentage'] as int;
    const colors = [
      AppColors.secondary,
      AppColors.primary,
      AppColors.good,
      AppColors.warning,
    ];
    final index = ['South Asian', 'Central Asian', 'European', 'East Asian']
        .indexOf(ancestry['population']);
    final color = colors[index.clamp(0, colors.length - 1)];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ancestry['population'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppColors.surfaceElevated,
              color: color,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraitCard(Map<String, dynamic> trait) {
    Color impactColor;
    IconData impactIcon;
    switch (trait['impact']) {
      case 'positive':
        impactColor = AppColors.good;
        impactIcon = Icons.check_circle_rounded;
        break;
      case 'negative':
        impactColor = AppColors.danger;
        impactIcon = Icons.cancel_rounded;
        break;
      default:
        impactColor = AppColors.warning;
        impactIcon = Icons.info_rounded;
    }

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: impactColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(impactIcon, color: impactColor, size: 20),
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
                        trait['name'],
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        trait['gene'],
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  trait['variant'],
                  style: TextStyle(
                    color: impactColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trait['description'],
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
