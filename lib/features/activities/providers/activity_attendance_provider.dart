import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/activity_attendance_model.dart';

final activityAttendanceProvider = FutureProvider<List<ActivityAttendanceModel>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 600));
  
  return [
    ActivityAttendanceModel(
      id: '1',
      title: 'Seminar Kewirausahaan Digital',
      category: 'Seminar & Workshop',
      date: DateTime(2023, 10, 12),
      checkInTime: DateTime(2023, 10, 12, 8, 30, 12),
      status: 'HADIR',
    ),
    ActivityAttendanceModel(
      id: '2',
      title: 'Seminar Kewirausahaan Digital', // Repeating same as mockup
      category: 'Seminar & Workshop',
      date: DateTime(2023, 10, 12),
      checkInTime: DateTime(2023, 10, 12, 8, 30, 12),
      status: 'HADIR',
    ),
    ActivityAttendanceModel(
      id: '3',
      title: 'Seminar Kewirausahaan Digital',
      category: 'Seminar & Workshop',
      date: DateTime(2023, 10, 12),
      checkInTime: DateTime(2023, 10, 12, 8, 30, 12),
      status: 'HADIR',
    ),
  ];
});
