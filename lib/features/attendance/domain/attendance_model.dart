class StudentAttendanceModel {
  final String? id;
  final String scheduleId;
  final String studentNim;
  final String studentName;
  String status; // 'Hadir', 'Sakit', 'Ijin', 'Alpha'
  final DateTime date;
  final String? topic;
  final String? startTime;
  final String? endTime;
  final bool? matchesRps;

  StudentAttendanceModel({
    this.id,
    required this.scheduleId,
    required this.studentNim,
    required this.studentName,
    this.status = 'Alpha',
    required this.date,
    this.topic,
    this.startTime,
    this.endTime,
    this.matchesRps,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      id: json['id'] as String?,
      scheduleId: json['schedule_id'] as String? ?? '',
      studentNim: json['student_nim'] as String? ?? '',
      studentName: json['student_name'] as String? ?? '',
      status: json['status'] as String? ?? 'Alpha',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      topic: json['topic'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      matchesRps: json['matches_rps'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'schedule_id': scheduleId,
      'student_nim': studentNim,
      'student_name': studentName,
      'status': status,
      'date': date.toIso8601String().split('T').first,
      'topic': topic,
      'start_time': startTime,
      'end_time': endTime,
      'matches_rps': matchesRps,
    };
  }

  static List<StudentAttendanceModel> demoStudents(String scheduleId) {
    final now = DateTime.now();
    return [
      StudentAttendanceModel(
        id: 'att-001',
        scheduleId: scheduleId,
        studentNim: '2024001',
        studentName: 'Budi Santoso',
        status: 'Hadir',
        date: now,
      ),
      StudentAttendanceModel(
        id: 'att-002',
        scheduleId: scheduleId,
        studentNim: '2024002',
        studentName: 'Siti Aminah',
        status: 'Sakit',
        date: now,
      ),
      StudentAttendanceModel(
        id: 'att-003',
        scheduleId: scheduleId,
        studentNim: '2024003',
        studentName: 'Andi Wijaya',
        status: 'Hadir',
        date: now,
      ),
      StudentAttendanceModel(
        id: 'att-004',
        scheduleId: scheduleId,
        studentNim: '2024004',
        studentName: 'Dewi Lestari',
        status: 'Hadir',
        date: now,
      ),
      StudentAttendanceModel(
        id: 'att-005',
        scheduleId: scheduleId,
        studentNim: '2024005',
        studentName: 'Rizky Pratama',
        status: 'Ijin',
        date: now,
      ),
      StudentAttendanceModel(
        id: 'att-006',
        scheduleId: scheduleId,
        studentNim: '2024006',
        studentName: 'Putri Rahayu',
        status: 'Hadir',
        date: now,
      ),
      StudentAttendanceModel(
        id: 'att-007',
        scheduleId: scheduleId,
        studentNim: '2024007',
        studentName: 'Fajar Nugroho',
        status: 'Hadir',
        date: now,
      ),
    ];
  }
}
