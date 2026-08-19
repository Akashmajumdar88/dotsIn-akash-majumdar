import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/health_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/human_body_widget.dart';
import '../widgets/health_score_ring.dart';
import 'organ_detail_screen.dart';

class OrganSelectionScreen extends ConsumerStatefulWidget {
  const OrganSelectionScreen({super.key});

  @override
  ConsumerState<OrganSelectionScreen> createState() =>
      _OrganSelectionScreenState();
}

class _OrganSelectionScreenState extends ConsumerState<OrganSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onOrganTapped(String organId) {
    ref.read(selectedOrganProvider.notifier).select(organId);
  }

  @override
  Widget build(BuildContext context) {
    final organs = ref.watch(organsProvider);
    final selectedId = ref.watch(selectedOrganProvider);

    final organScores = <String, int>{
      for (final o in organs) o['id'] as String: o['score'] as int
    };

    return SlideTransition(
      position: _slideAnim,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Body Map',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Tap an organ',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Main body + side panel layout
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Human body
                  Expanded(
                    flex: 5,
                    child: HumanBodyWidget(
                      selectedOrganId: selectedId,
                      onOrganTapped: _onOrganTapped,
                      organScores: organScores,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Organ list panel
                  Expanded(
                    flex: 4,
                    child: _buildOrganList(organs, selectedId),
                  ),
                ],
              ),
            ),
          ),
          // Detail panel
          if (selectedId != null) _buildDetailPanel(selectedId, organs),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOrganList(List<Map<String, dynamic>> organs, String? selectedId) {
    return ListView.separated(
      itemCount: organs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final organ = organs[index];
        final isSelected = organ['id'] == selectedId;
        final color = Color(int.parse(organ['color']));
        final score = organ['score'] as int;

        return GestureDetector(
          onTap: () => _onOrganTapped(organ['id']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.18)
                  : AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color.withValues(alpha: 0.6) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$score',
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    organ['name'],
                    style: TextStyle(
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isSelected ? color : AppColors.textMuted,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailPanel(String organId, List<Map<String, dynamic>> organs) {
    final organ = organs.firstWhere((o) => o['id'] == organId, orElse: () => {});
    if (organ.isEmpty) return const SizedBox();

    final color = Color(int.parse(organ['color']));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        key: ValueKey(organId),
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, anim, __) =>
                  OrganDetailScreen(organId: organId),
              transitionsBuilder: (_, anim, __, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: anim,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                );
              },
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              HealthScoreRing(
                score: (organ['score'] as int).toDouble(),
                size: 60,
                color: color,
                strokeWidth: 6,
                label: 'Score',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organ['name'],
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      organ['description'],
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Details →',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
