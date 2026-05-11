class EmploymentHistoryModel {
  final String id;
  final String profileId;
  final String category;
  final String title;
  final String? institution;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  const EmploymentHistoryModel({
    required this.id,
    required this.profileId,
    required this.category,
    required this.title,
    this.institution,
    this.description,
    this.startDate,
    this.endDate,
    this.status,
  });

  factory EmploymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return EmploymentHistoryModel(
      id: json['id'] as String,
      profileId: json['profile_id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      institution: json['institution'] as String?,
      description: json['description'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'] as String)
          : null,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'category': category,
      'title': title,
      'institution': institution,
      'description': description,
      'start_date': startDate?.toIso8601String().split('T').first,
      'end_date': endDate?.toIso8601String().split('T').first,
      'status': status,
    };
  }

  String get dateRange {
    final start = startDate != null
        ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
        : '-';
    final end = endDate != null
        ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
        : 'Sekarang';
    return '$start - $end';
  }

  static Map<String, List<EmploymentHistoryModel>> demoData(String profileId) {
    return {
      'Pendidikan': [
        EmploymentHistoryModel(
          id: 'h-001',
          profileId: profileId,
          category: 'Pendidikan',
          title: 'S3 Teknik Informatika',
          institution: 'Universitas Indonesia',
          startDate: DateTime(2018, 8),
          endDate: DateTime(2022, 7),
          status: 'Lulus',
        ),
        EmploymentHistoryModel(
          id: 'h-002',
          profileId: profileId,
          category: 'Pendidikan',
          title: 'S2 Teknik Informatika',
          institution: 'Institut Teknologi Bandung',
          startDate: DateTime(2012, 8),
          endDate: DateTime(2014, 7),
          status: 'Lulus',
        ),
        EmploymentHistoryModel(
          id: 'h-003',
          profileId: profileId,
          category: 'Pendidikan',
          title: 'S1 Teknik Informatika',
          institution: 'Universitas Muhammadiyah Malang',
          startDate: DateTime(2007, 8),
          endDate: DateTime(2011, 7),
          status: 'Lulus',
        ),
      ],
      'Kepangkatan': [
        EmploymentHistoryModel(
          id: 'h-004',
          profileId: profileId,
          category: 'Kepangkatan',
          title: 'Penata Tk. I - III/d',
          institution: 'UMM',
          startDate: DateTime(2022, 4),
          status: 'Aktif',
        ),
        EmploymentHistoryModel(
          id: 'h-005',
          profileId: profileId,
          category: 'Kepangkatan',
          title: 'Penata - III/c',
          institution: 'UMM',
          startDate: DateTime(2018, 4),
          endDate: DateTime(2022, 3),
          status: 'Selesai',
        ),
      ],
      'Aktifasi': [
        EmploymentHistoryModel(
          id: 'h-006',
          profileId: profileId,
          category: 'Aktifasi',
          title: 'Dosen Tetap',
          institution: 'UMM',
          startDate: DateTime(2014, 9),
          status: 'Aktif',
        ),
      ],
      'Kerja di UMM': [
        EmploymentHistoryModel(
          id: 'h-007',
          profileId: profileId,
          category: 'Kerja di UMM',
          title: 'Dosen Program Studi Informatika',
          institution: 'Fakultas Teknik UMM',
          startDate: DateTime(2014, 9),
          status: 'Aktif',
        ),
        EmploymentHistoryModel(
          id: 'h-008',
          profileId: profileId,
          category: 'Kerja di UMM',
          title: 'Kepala Lab Rekayasa Perangkat Lunak',
          institution: 'FT UMM',
          startDate: DateTime(2020, 1),
          status: 'Aktif',
        ),
      ],
      'Kepanitiaan': [
        EmploymentHistoryModel(
          id: 'h-009',
          profileId: profileId,
          category: 'Kepanitiaan',
          title: 'Panitia Dies Natalis UMM ke-60',
          institution: 'UMM',
          startDate: DateTime(2024, 6),
          endDate: DateTime(2024, 7),
          status: 'Selesai',
        ),
      ],
      'Organisasi': [
        EmploymentHistoryModel(
          id: 'h-010',
          profileId: profileId,
          category: 'Organisasi',
          title: 'Anggota APTIKOM',
          institution: 'APTIKOM Jawa Timur',
          startDate: DateTime(2020, 1),
          status: 'Aktif',
        ),
      ],
      'Prestasi': [
        EmploymentHistoryModel(
          id: 'h-011',
          profileId: profileId,
          category: 'Prestasi',
          title: 'Best Paper Award ICIC 2023',
          institution: 'IEEE',
          startDate: DateTime(2023, 11),
          status: 'Diterima',
        ),
      ],
    };
  }
}
