import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/health_data.dart';

// Root health data provider
final healthDataProvider = Provider<Map<String, dynamic>>((ref) {
  return healthData;
});

// User info provider
final userProvider = Provider<Map<String, dynamic>>((ref) {
  return ref.watch(healthDataProvider)['user'];
});

// Overall health score
final overallHealthScoreProvider = Provider<int>((ref) {
  return ref.watch(healthDataProvider)['overallHealthScore'];
});

// Score history
final healthScoreHistoryProvider = Provider<List<int>>((ref) {
  final data = ref.watch(healthDataProvider)['healthScoreHistory'];
  return List<int>.from(data);
});

// Organs list
final organsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final data = ref.watch(healthDataProvider)['organs'];
  return List<Map<String, dynamic>>.from(data);
});

// Selected organ notifier
class SelectedOrganNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

final selectedOrganProvider =
    NotifierProvider<SelectedOrganNotifier, String?>(SelectedOrganNotifier.new);

// Current organ detail
final selectedOrganDetailProvider = Provider<Map<String, dynamic>?>((ref) {
  final selectedId = ref.watch(selectedOrganProvider);
  if (selectedId == null) return null;
  final organs = ref.watch(organsProvider);
  try {
    return organs.firstWhere((o) => o['id'] == selectedId);
  } catch (_) {
    return null;
  }
});

// Blood markers
final bloodMarkersProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final data = ref.watch(healthDataProvider)['bloodMarkers'];
  return List<Map<String, dynamic>>.from(data);
});

// Selected blood category notifier
class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'Complete Blood Count';

  void select(String category) => state = category;
}

final selectedBloodCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
        SelectedCategoryNotifier.new);

// Filtered blood markers
final filteredBloodMarkersProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final category = ref.watch(selectedBloodCategoryProvider);
  final allMarkers = ref.watch(bloodMarkersProvider);
  try {
    final categoryData =
        allMarkers.firstWhere((m) => m['category'] == category);
    return List<Map<String, dynamic>>.from(categoryData['markers'] ?? []);
  } catch (_) {
    return [];
  }
});

// Genomics
final genomicsProvider = Provider<Map<String, dynamic>>((ref) {
  return ref.watch(healthDataProvider)['genomics'];
});

// Strengths
final strengthsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final data = ref.watch(healthDataProvider)['strengths'];
  return List<Map<String, dynamic>>.from(data);
});

// Weaknesses
final weaknessesProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final data = ref.watch(healthDataProvider)['weaknesses'];
  return List<Map<String, dynamic>>.from(data);
});

// Recommendations
final recommendationsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final data = ref.watch(healthDataProvider)['recommendations'];
  return List<Map<String, dynamic>>.from(data);
});

// Tab selection notifier
class MainTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void select(int index) => state = index;
}

final mainTabProvider =
    NotifierProvider<MainTabNotifier, int>(MainTabNotifier.new);
