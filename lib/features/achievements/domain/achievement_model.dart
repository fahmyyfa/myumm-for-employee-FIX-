class AchievementModel {
  final String id;
  final String profileId;
  final String category;
  final String title;
  final double points;
  final String? description;
  final DateTime? createdAt;
  final String? location;
  final String? status;

  const AchievementModel({
    required this.id, required this.profileId, required this.category,
    required this.title, required this.points, this.description, this.createdAt,
    this.location, this.status,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String, profileId: json['profile_id'] as String? ?? '',
      category: json['category'] as String? ?? '', title: json['title'] as String? ?? '',
      points: (json['points'] as num? ?? 0.0).toDouble(),
      description: json['description'] as String?, location: json['location'] as String?,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'profile_id': profileId, 'category': category, 'title': title,
    'points': points, 'description': description, 
    'created_at': createdAt?.toIso8601String(),
    'location': location, 'status': status,
  };

  static List<AchievementModel> demoData(String profileId) {
    return [
      AchievementModel(id: 'ach-001', profileId: profileId, category: 'Kegiatan Ilmiah',
        title: 'Publikasi Jurnal International - IEEE Access', points: 40.0,
        description: 'Machine Learning for IoT Security',
        createdAt: DateTime(2024, 3, 15), location: 'IEEE Access Journal', status: 'Published'),
      AchievementModel(id: 'ach-002', profileId: profileId, category: 'Kegiatan Ilmiah',
        title: 'Presenter ICIC 2023', points: 15.0,
        description: 'International Conference on Informatics',
        createdAt: DateTime(2023, 11, 20), location: 'Jakarta', status: 'Completed'),
      AchievementModel(id: 'ach-003', profileId: profileId, category: 'Aktifitas Sosial',
        title: 'Workshop Coding untuk Siswa SMA', points: 10.0,
        description: 'Pelatihan pemrograman dasar',
        createdAt: DateTime(2024, 1, 10), location: 'SMA Negeri 1 Malang', status: 'Selesai'),
    ];
  }
}
