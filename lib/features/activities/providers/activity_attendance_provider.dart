import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/activity_attendance_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';

final activityAttendanceProvider = FutureProvider<List<ActivityAttendanceModel>>((ref) async {
  try {
    final userId = ref.watch(userIdProvider);
    if (userId == null) return [];

    final response = await Supabase.instance.client
        .from(AppConstants.activitiesTable)
        .select()
        .eq('profile_id', userId)
        .order('date', ascending: false)
        .limit(10);
    
    return (response as List).map((json) => ActivityAttendanceModel.fromJson(json)).toList();
  } catch (e) {
    // Return empty list on error as requested to avoid red snackbars
    return [];
  }
});
