class ActivityAttendanceModel {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final DateTime checkInTime;
  final String status;

  ActivityAttendanceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.checkInTime,
    required this.status,
  });
}
