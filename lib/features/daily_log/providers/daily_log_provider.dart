import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/daily_log_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_provider.dart';

final dailyLogsProvider = FutureProvider<List<DailyLogModel>>((ref) async {
  try {
    final userId = ref.watch(userIdProvider);
    if (userId == null) return [];

    // Use a simple broad filter by profile_id first to ensure data appears,
    // and filter by today's date using gte on created_at or date.
    final today = DateTime.now().toIso8601String().split('T')[0];

    final response = await Supabase.instance.client
        .from(AppConstants.dailyLogsTable)
        .select()
        .eq('profile_id', userId)
        .gte('created_at', today)
        .order('created_at', ascending: false);
    
    print('DAILY LOGS DATA for $userId on $today: $response');
    return (response as List).map((json) => DailyLogModel.fromJson(json)).toList();
  } catch (e) {
    print('ERROR FETCHING DAILY LOGS: $e');
    return [];
  }
});
