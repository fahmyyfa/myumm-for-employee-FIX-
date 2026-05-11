class TeachingScheduleModel {
  final String id;
  final String dosenId;
  final String courseName;
  final String className;
  final String programStudi;
  final int sks;
  final String day;
  final String startTime;
  final String endTime;
  final String room;
  final String building;
  final String academicYear;
  final String semester;

  const TeachingScheduleModel({
    required this.id,
    required this.dosenId,
    required this.courseName,
    required this.className,
    required this.programStudi,
    required this.sks,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.building,
    required this.academicYear,
    required this.semester,
  });

  factory TeachingScheduleModel.fromJson(Map<String, dynamic> json) {
    return TeachingScheduleModel(
      id: json['id'] as String,
      dosenId: json['dosen_id'] as String? ?? '',
      courseName: json['course_name'] as String? ?? '',
      className: json['class_name'] as String? ?? '',
      programStudi: json['program_studi'] as String? ?? '',
      sks: json['sks'] as int? ?? 0,
      day: json['day'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      room: json['room'] as String? ?? '',
      building: json['building'] as String? ?? '',
      academicYear: json['academic_year'] as String? ?? '',
      semester: json['semester'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dosen_id': dosenId,
      'course_name': courseName,
      'class_name': className,
      'program_studi': programStudi,
      'sks': sks,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'building': building,
      'academic_year': academicYear,
      'semester': semester,
    };
  }

  String get scheduleTime => '$startTime - $endTime';
  String get fullLocation => '$building - $room';

  static List<TeachingScheduleModel> demoData() {
    return [
      const TeachingScheduleModel(
        id: 'sch-001',
        dosenId: 'demo-dosen-001',
        courseName: 'Pengembangan Aplikasi Mobile',
        className: 'Kelas A',
        programStudi: 'Informatika',
        sks: 3,
        day: 'Senin',
        startTime: '08:00',
        endTime: '10:30',
        room: 'Lab Komputer 302',
        building: 'GKB IV',
        academicYear: '2024/2025',
        semester: 'Ganjil',
      ),
      const TeachingScheduleModel(
        id: 'sch-002',
        dosenId: 'demo-dosen-001',
        courseName: 'Pengembangan Aplikasi Mobile',
        className: 'Kelas B',
        programStudi: 'Informatika',
        sks: 3,
        day: 'Senin',
        startTime: '08:00',
        endTime: '10:30',
        room: 'Lab Komputer 302',
        building: 'GKB IV',
        academicYear: '2024/2025',
        semester: 'Ganjil',
      ),
      const TeachingScheduleModel(
        id: 'sch-003',
        dosenId: 'demo-dosen-001',
        courseName: 'Pengembangan Aplikasi Mobile',
        className: 'Kelas C',
        programStudi: 'Informatika',
        sks: 3,
        day: 'Senin',
        startTime: '08:00',
        endTime: '10:30',
        room: 'Lab Komputer 302',
        building: 'GKB IV',
        academicYear: '2024/2025',
        semester: 'Ganjil',
      ),
      const TeachingScheduleModel(
        id: 'sch-004',
        dosenId: 'demo-dosen-001',
        courseName: 'Pemrograman Berorientasi Objek',
        className: 'Kelas A',
        programStudi: 'Informatika',
        sks: 3,
        day: 'Rabu',
        startTime: '08:00',
        endTime: '10:00',
        room: 'Lab. Multimedia',
        building: 'GKB IV',
        academicYear: '2025/2026',
        semester: 'Genap',
      ),
      const TeachingScheduleModel(
        id: 'sch-005',
        dosenId: 'demo-dosen-001',
        courseName: 'Basis Data',
        className: 'Kelas A',
        programStudi: 'Informatika',
        sks: 3,
        day: 'Kamis',
        startTime: '13:00',
        endTime: '15:30',
        room: 'R. 303',
        building: 'GKB IV',
        academicYear: '2024/2025',
        semester: 'Ganjil',
      ),
    ];
  }
}

class ScheduleHistoryEntry {
  final int number;
  final String academicYear;
  final String semester;

  const ScheduleHistoryEntry({
    required this.number,
    required this.academicYear,
    required this.semester,
  });

  static List<ScheduleHistoryEntry> demoData() {
    return const [
      ScheduleHistoryEntry(number: 1, academicYear: '2024/2025', semester: 'Semester Ganjil'),
      ScheduleHistoryEntry(number: 2, academicYear: '2024/2025', semester: 'Semester Ganjil'),
      ScheduleHistoryEntry(number: 3, academicYear: '2023/2024', semester: 'Semester Genap'),
      ScheduleHistoryEntry(number: 4, academicYear: '2023/2024', semester: 'Semester Ganjil'),
      ScheduleHistoryEntry(number: 5, academicYear: '2022/2023', semester: 'Semester Genap'),
      ScheduleHistoryEntry(number: 6, academicYear: '2022/2023', semester: 'Semester Ganjil'),
      ScheduleHistoryEntry(number: 7, academicYear: '2021/2022', semester: 'Semester Genap'),
      ScheduleHistoryEntry(number: 8, academicYear: '2021/2022', semester: 'Semester Ganjil'),
    ];
  }
}
