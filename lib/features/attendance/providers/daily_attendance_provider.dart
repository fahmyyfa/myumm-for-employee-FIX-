import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/daily_attendance_model.dart';
import '../../profile/providers/profile_provider.dart';

final selectedMonthYearProvider = StateProvider<DateTime>((ref) => DateTime.now());

final dailyAttendanceProvider = FutureProvider<List<DailyAttendanceModel>>((ref) async {
  final profile = await ref.watch(profileProvider.future);
  final monthYear = ref.watch(selectedMonthYearProvider);
  if (profile == null) return [];

  // Generate mock data for the selected month
  List<DailyAttendanceModel> mockData = [];
  final daysInMonth = DateUtils.getDaysInMonth(monthYear.year, monthYear.month);
  
  for (int i = 1; i <= daysInMonth; i++) {
    final date = DateTime(monthYear.year, monthYear.month, i);
    // Skip weekends
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      continue;
    }
    // Mock: Present on random days, up to current date
    if (i % 3 != 0 && date.isBefore(DateTime.now().add(const Duration(days: 1)))) {
      mockData.add(DailyAttendanceModel(
        date: date,
        status: 'Hadir',
        checkInTime: DateTime(date.year, date.month, date.day, 8, 15, 23),
      ));
    }
  }
  return mockData;
});
