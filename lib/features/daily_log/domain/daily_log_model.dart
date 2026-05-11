class DailyLogModel {
  final String? id;
  final String profileId;
  final DateTime date;
  final String activity;
  final String? description;
  final String? startTime;
  final String? endTime;
  final String? status;

  const DailyLogModel({
    this.id, required this.profileId, required this.date, required this.activity,
    this.description, this.startTime, this.endTime, this.status,
  });

  factory DailyLogModel.fromJson(Map<String, dynamic> json) {
    return DailyLogModel(
      id: json['id'] as String?, profileId: json['profile_id'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      activity: json['activity'] as String? ?? '', description: json['description'] as String?,
      startTime: json['start_time'] as String?, endTime: json['end_time'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id, 'profile_id': profileId,
    'date': date.toIso8601String().split('T').first, 'activity': activity,
    'description': description, 'start_time': startTime, 'end_time': endTime, 'status': status,
  };

  static List<DailyLogModel> demoData(String profileId) {
    final now = DateTime.now();
    return [
      DailyLogModel(id: 'dl-001', profileId: profileId, date: now, activity: 'Rapat Koordinasi',
        description: 'Rapat koordinasi divisi administrasi', startTime: '08:00', endTime: '09:30', status: 'Selesai'),
      DailyLogModel(id: 'dl-002', profileId: profileId, date: now, activity: 'Input Data Kepegawaian',
        description: 'Menginput data kepegawaian baru', startTime: '10:00', endTime: '12:00', status: 'Selesai'),
      DailyLogModel(id: 'dl-003', profileId: profileId, date: now, activity: 'Pembuatan Laporan Bulanan',
        description: 'Menyusun laporan bulanan', startTime: '13:00', endTime: '15:00', status: 'Proses'),
    ];
  }
}
