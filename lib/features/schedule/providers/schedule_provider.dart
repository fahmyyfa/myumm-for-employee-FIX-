import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/schedule_model.dart';

final schedulesProvider = FutureProvider<List<TeachingScheduleModel>>((ref) async {
  return TeachingScheduleModel.demoData();
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
