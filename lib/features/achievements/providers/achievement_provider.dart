import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/achievement_model.dart';
import '../data/achievement_repository.dart';
import '../../profile/providers/profile_provider.dart';

final achievementRepositoryProvider = Provider((ref) => AchievementRepository());

final achievementsProvider = FutureProvider<List<AchievementModel>>((ref) async {
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return [];
  
  if (profile.id.startsWith('demo')) {
    return AchievementModel.demoData(profile.id);
  }

  final repo = ref.read(achievementRepositoryProvider);
  return repo.getAchievements(profile.id);
});
