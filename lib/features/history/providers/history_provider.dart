import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/history_models.dart';
import '../../profile/providers/profile_provider.dart';

final historyDataProvider = FutureProvider<Map<String, List<EmploymentHistoryModel>>>((ref) async {
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return {};
  return EmploymentHistoryModel.demoData(profile.id);
});

final historyCategoryProvider = FutureProvider.family<List<EmploymentHistoryModel>, String>((ref, category) async {
  final all = await ref.watch(historyDataProvider.future);
  return all[category] ?? [];
});
