import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/attendance_model.dart';

final attendanceListProvider = FutureProvider.family<List<StudentAttendanceModel>, String>((ref, scheduleId) async {
  return StudentAttendanceModel.demoStudents(scheduleId);
});
