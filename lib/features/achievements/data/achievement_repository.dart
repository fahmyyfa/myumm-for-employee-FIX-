import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/achievement_model.dart';

class AchievementRepository {
  final _client = Supabase.instance.client;

  Future<List<AchievementModel>> getAchievements(String profileId) async {
    try {
      final response = await _client
          .from('achievements')
          .select()
          .eq('profile_id', profileId)
          .order('date', ascending: false);
      
      return (response as List).map((e) => AchievementModel.fromJson(e)).toList();
    } catch (_) {
      // Fallback to demo data if table doesn't exist or error
      return AchievementModel.demoData(profileId);
    }
  }
}
