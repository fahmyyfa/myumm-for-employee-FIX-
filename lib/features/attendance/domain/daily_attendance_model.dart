class DailyAttendanceModel {
  final DateTime date;
  final String status;
  final DateTime? checkInTime;

  DailyAttendanceModel({
    required this.date,
    required this.status,
    this.checkInTime,
  });
}
