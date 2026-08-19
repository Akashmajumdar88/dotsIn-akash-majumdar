import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/health_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/health_score_ring.dart';
import '../widgets/custom_charts.dart';
import '../widgets/common_widgets.dart';

class OrganDetailScreen extends ConsumerStatefulWidget {
  final String organId;

  const OrganDetailScreen({super.key, required this.organId});

  @override
  ConsumerState<OrganDetailScreen> createState() => _OrganDetailScreenState();
}

class _OrganDetailScreenState extends ConsumerState<OrganDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(_fadeAnim);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final organs = ref.watch(organsProvider);
    final organ = organs.firstWhere(
      (o) => o['id'] == widget.organId,
      orElse: () => {},
    );

    if (organ.isEmpty) {
      return const Scaffold(body: Center(child: Text('Not found')));
    }

    final color = Color(int.parse(organ['color']));
    final metrics = List<Map<String, dynamic>>.from(organ['metrics'] ?? []);
    final conditions = List<Map<String, dynamic>>.from(organ['conditions'] ?? []);
    final chartData = List<num>.from(organ['chartData'] ?? []);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                backgroundColor: AppColors.background,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          color.withValues(alpha: 0.3),
                          AppColors.background,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
                        child: Row(
                          children: [
                            HealthScoreRing(
                              score: (organ['score'] as int).toDouble(),
                              size: 100,
                              color: color,
                              strokeWidth: 8,
                              label: 'Health',
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    organ['name'],
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  StatusChip(status: organ['status']),
                                  const SizedBox(height: 8),
                                  Text(
                                    organ['description'],
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
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
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Score trend
                    if (chartData.isNotEmpty) ...[
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Score Trend',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Last 6 data points',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SparkLineChart(
                              data: chartData
                                  .map((e) => e.toDouble())
                                  .toList(),
                              color: color,
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Metrics
                    const SectionHeader(title: 'Key Metrics'),
                    const SizedBox(height: 12),
                    ...metrics.map((metric) => _buildMetricCard(metric)),

                    // Conditions
                    if (conditions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const SectionHeader(title: 'Conditions / Flags'),
                      const SizedBox(height: 12),
                      ...conditions.map(
                        (c) => _buildConditionCard(c, color),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(Map<String, dynamic> metric) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric['label'],
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  metric['value'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Range: ${metric['range']}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          StatusChip(status: metric['status']),
        ],
      ),
    );
  }

  Widget _buildConditionCard(Map<String, dynamic> condition, Color organColor) {
    final severityColor = condition['severity'] == 'moderate'
        ? AppColors.danger
        : AppColors.warning;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: severityColor,
              size: 20,
            ),
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
                        condition['name'],
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    StatusChip(status: condition['severity'], small: true),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  condition['description'],
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
