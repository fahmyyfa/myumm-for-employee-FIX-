class AchievementModel {
  final String id;
  final String profileId;
  final String category;
  final String title;
  final String? description;
  final DateTime? date;
  final String? location;
  final String? status;

  const AchievementModel({
    required this.id, required this.profileId, required this.category,
    required this.title, this.description, this.date, this.location, this.status,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String, profileId: json['profile_id'] as String? ?? '',
      category: json['category'] as String? ?? '', title: json['title'] as String? ?? '',
      description: json['description'] as String?, location: json['location'] as String?,
      date: json['date'] != null ? DateTime.tryParse(json['date'] as String) : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'profile_id': profileId, 'category': category, 'title': title,
    'description': description, 'date': date?.toIso8601String().split('T').first,
    'location': location, 'status': status,
  };

  static List<AchievementModel> demoData(String profileId) {
    return [
      AchievementModel(id: 'ach-001', profileId: profileId, category: 'Kegiatan Ilmiah',
        title: 'Publikasi Jurnal International - IEEE Access', description: 'Machine Learning for IoT Security',
        date: DateTime(2024, 3, 15), location: 'IEEE Access Journal', status: 'Published'),
      AchievementModel(id: 'ach-002', profileId: profileId, category: 'Kegiatan Ilmiah',
        title: 'Presenter ICIC 2023', description: 'International Conference on Informatics',
        date: DateTime(2023, 11, 20), location: 'Jakarta', status: 'Completed'),
      AchievementModel(id: 'ach-003', profileId: profileId, category: 'Aktifitas Sosial',
        title: 'Workshop Coding untuk Siswa SMA', description: 'Pelatihan pemrograman dasar',
        date: DateTime(2024, 1, 10), location: 'SMA Negeri 1 Malang', status: 'Selesai'),
      AchievementModel(id: 'ach-004', profileId: profileId, category: 'Pelatihan',
        title: 'Sertifikasi AWS Cloud Practitioner', description: 'AWS certification',
        date: DateTime(2024, 2, 5), location: 'Online', status: 'Lulus'),
      AchievementModel(id: 'ach-005', profileId: profileId, category: 'Pelatihan',
        title: 'Workshop Flutter Advanced', description: 'Advanced Flutter development',
        date: DateTime(2023, 9, 14), location: 'Google Indonesia', status: 'Selesai'),
      AchievementModel(id: 'ach-006', profileId: profileId, category: 'Studi Lanjut',
        title: 'Post-Doctoral Research', description: 'AI & Education research',
        date: DateTime(2024, 6, 1), location: 'University of Tokyo', status: 'Ongoing'),
    ];
  }
}
