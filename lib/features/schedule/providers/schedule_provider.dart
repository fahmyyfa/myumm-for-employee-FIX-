import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/schedule_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_provider.dart';

final schedulesProvider = FutureProvider<List<TeachingScheduleModel>>((ref) async {
  try {
    final userId = ref.watch(userIdProvider);
    if (userId == null) return [];

    final String currentDay = DateFormat('EEEE', 'en_US').format(DateTime.now());
    // Map English day to Indonesian if necessary, but assuming DB uses English or matching names
    // If your DB uses Indonesian names like 'Selasa', you'd need a mapper.

    final response = await Supabase.instance.client
        .from(AppConstants.teachingSchedulesTable)
        .select()
        .eq('profile_id', userId)
        .eq('day_of_week', currentDay)
        .order('start_time', ascending: true);
    
    print('SCHEDULES DATA: $response');
    return (response as List).map((json) => TeachingScheduleModel.fromJson(json)).toList();
  } catch (e) {
    // Return empty list on error as requested to avoid red snackbars
    return [];
  }
});

final scheduleHistoryProvider = FutureProvider<List<ScheduleHistoryEntry>>((ref) async {
  return ScheduleHistoryEntry.demoData();
});

final scheduleByIdProvider = FutureProvider.family<TeachingScheduleModel?, String>((ref, id) async {
  final schedules = await ref.watch(schedulesProvider.future);
  try { return schedules.firstWhere((s) => s.id == id); } catch (_) { return null; }
});

final selectedAcademicYearProvider = StateProvider<String>((ref) => '2024/2025');
final selectedSemesterProvider = StateProvider<String>((ref) => 'Ganjil');
