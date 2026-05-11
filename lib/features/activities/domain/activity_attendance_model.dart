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

  factory ActivityAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ActivityAttendanceModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      checkInTime: json['check_in_time'] != null ? DateTime.parse(json['check_in_time']) : DateTime.now(),
      status: json['status'] ?? '',
    );
  }
}
