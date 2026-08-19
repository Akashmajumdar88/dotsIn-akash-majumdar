import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/health_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/health_score_ring.dart';
import '../widgets/custom_charts.dart';
import '../widgets/common_widgets.dart';

class HealthOverviewScreen extends ConsumerStatefulWidget {
  const HealthOverviewScreen({super.key});

  @override
  ConsumerState<HealthOverviewScreen> createState() =>
      _HealthOverviewScreenState();
}

class _HealthOverviewScreenState extends ConsumerState<HealthOverviewScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final score = ref.watch(overallHealthScoreProvider);
    final scoreHistory = ref.watch(healthScoreHistoryProvider);
    final organs = ref.watch(organsProvider);
    final strengths = ref.watch(strengthsProvider);
    final weaknesses = ref.watch(weaknessesProvider);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeader(user),
              const SizedBox(height: 20),
              _buildOverallScoreCard(score, scoreHistory),
              const SizedBox(height: 20),
              _buildOrganScoreGrid(organs),
              const SizedBox(height: 20),
              _buildStrengthsWeaknessesSection(strengths, weaknesses),
              const SizedBox(height: 20),
              _buildLastUpdated(user['lastUpdated']),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> user) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Overview',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Hi, ${user['name'].toString().split(' ')[0]} 👋',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
        ),
      ],
    );
  }

  Widget _buildOverallScoreCard(int score, List<int> history) {
    Color scoreColor;
    String scoreLabel;
    if (score >= 80) {
      scoreColor = AppColors.good;
      scoreLabel = 'Excellent';
    } else if (score >= 65) {
      scoreColor = AppColors.warning;
      scoreLabel = 'Good';
    } else {
      scoreColor = AppColors.danger;
      scoreLabel = 'Needs Attention';
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Health Score',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '$score',
                        style: TextStyle(
                          color: scoreColor,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      Text(
                        '/100',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scoreColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      scoreLabel,
                      style: TextStyle(
                        color: scoreColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              HealthScoreRing(
                score: score.toDouble(),
                size: 110,
                strokeWidth: 10,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Trend (last 5 checks)',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          SparkLineChart(
            data: history.map((e) => e.toDouble()).toList(),
            color: scoreColor,
            height: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildOrganScoreGrid(List<Map<String, dynamic>> organs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Organ Health'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
          ),
          itemCount: organs.length,
          itemBuilder: (context, index) {
            final organ = organs[index];
            final color = Color(int.parse(organ['color']));
            final score = organ['score'] as int;
            return GlassCard(
              padding: const EdgeInsets.all(12),
              onTap: () {
                ref.read(selectedOrganProvider.notifier).select(organ['id']);
                ref.read(mainTabProvider.notifier).select(1);
              },
              child: Row(
                children: [
                  MiniScoreRing(
                    score: score.toDouble(),
                    size: 52,
                    color: color,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          organ['name'],
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        StatusChip(status: organ['status'], small: true),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStrengthsWeaknessesSection(
    List<Map<String, dynamic>> strengths,
    List<Map<String, dynamic>> weaknesses,
  ) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Insights'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: '💪 Strengths'),
                Tab(text: '⚠️ Weaknesses'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: strengths.length * 90.0,
            child: TabBarView(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: strengths.length,
                  itemBuilder: (ctx, i) =>
                      InsightCard(data: strengths[i], isStrength: true, index: i),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: weaknesses.length,
                  itemBuilder: (ctx, i) =>
                      InsightCard(data: weaknesses[i], isStrength: false, index: i),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated(String date) {
    return Center(
      child: Text(
        'Last updated: $date',
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 12,
        ),
      ),
    );
  }
}
