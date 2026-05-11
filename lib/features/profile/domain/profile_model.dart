class ProfileModel {
  final String id;
  final String fullName;
  final String nip;
  final String? nidn;
  final String roleType; // 'dosen' | 'karyawan'
  final String? email;
  final String? photoUrl;
  final String? department;
  final String? faculty;
  final String? position;
  final String? jabatanAkademik;
  final String? pangkat;
  final String? golongan;
  final String? ktp;
  final String? statusKepegawaian;
  final String? statusKerja;
  final String? unitKerja;
  final DateTime? birthDate;
  final String? birthPlace;
  final String? gender;
  final String? religion;
  final String? address;
  final String? phone;
  final DateTime? createdAt;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.nip,
    this.nidn,
    required this.roleType,
    this.email,
    this.photoUrl,
    this.department,
    this.faculty,
    this.position,
    this.jabatanAkademik,
    this.pangkat,
    this.golongan,
    this.ktp,
    this.statusKepegawaian,
    this.statusKerja,
    this.unitKerja,
    this.birthDate,
    this.birthPlace,
    this.gender,
    this.religion,
    this.address,
    this.phone,
    this.createdAt,
  });

  bool get isDosen => roleType.trim().toLowerCase() == 'dosen';
  bool get isKaryawan => roleType.trim().toLowerCase() == 'karyawan';

  String get displayId => nidn ?? nip;
  String get displayIdLabel => isDosen ? 'NIDN' : 'NIP';

  String get masaKerja {
    if (createdAt == null) return '-';
    final now = DateTime.now();
    int years = now.year - createdAt!.year;
    int months = now.month - createdAt!.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    if (years == 0 && months == 0) return 'Baru bergabung';
    if (years == 0) return '$months bulan';
    if (months == 0) return '$years tahun';
    return '$years tahun $months bulan';
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    print('PROFILE MODEL RAW JSON: $json');
    final id = json['id']?.toString() ?? '';
    print('PROFILE MODEL USER ID: $id');
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      nip: json['nip']?.toString() ?? '',
      nidn: json['nidn']?.toString(),
      roleType: json['role_type']?.toString() ?? 'karyawan',
      email: json['email'] as String?,
      photoUrl: json['photo_url'] as String?,
      department: json['department'] as String?,
      faculty: json['faculty'] as String?,
      position: json['position'] as String?,
      jabatanAkademik: json['jabatan_akademik'] as String?,
      pangkat: json['pangkat'] as String?,
      golongan: json['golongan'] as String?,
      ktp: json['ktp'] as String?,
      statusKepegawaian: json['status_kepegawaian'] as String?,
      statusKerja: json['status_kerja'] as String?,
      unitKerja: json['unit_kerja'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'] as String)
          : null,
      birthPlace: json['birth_place'] as String?,
      gender: json['gender'] as String?,
      religion: json['religion'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'nip': nip,
      'nidn': nidn,
      'role_type': roleType,
      'email': email,
      'photo_url': photoUrl,
      'department': department,
      'faculty': faculty,
      'position': position,
      'jabatan_akademik': jabatanAkademik,
      'pangkat': pangkat,
      'golongan': golongan,
      'ktp': ktp,
      'status_kepegawaian': statusKepegawaian,
      'status_kerja': statusKerja,
      'unit_kerja': unitKerja,
      'birth_date': birthDate?.toIso8601String(),
      'birth_place': birthPlace,
      'gender': gender,
      'religion': religion,
      'address': address,
      'phone': phone,
    };
  }

  ProfileModel copyWith({
    String? fullName,
    String? nip,
    String? nidn,
    String? roleType,
    String? email,
    String? photoUrl,
    String? department,
    String? faculty,
    String? position,
    String? jabatanAkademik,
    String? pangkat,
    String? golongan,
    DateTime? birthDate,
    String? birthPlace,
    String? gender,
    String? religion,
    String? address,
    String? phone,
  }) {
    return ProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      nip: nip ?? this.nip,
      nidn: nidn ?? this.nidn,
      roleType: roleType ?? this.roleType,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      department: department ?? this.department,
      faculty: faculty ?? this.faculty,
      position: position ?? this.position,
      jabatanAkademik: jabatanAkademik ?? this.jabatanAkademik,
      pangkat: pangkat ?? this.pangkat,
      golongan: golongan ?? this.golongan,
      ktp: ktp ?? this.ktp,
      statusKepegawaian: statusKepegawaian ?? this.statusKepegawaian,
      statusKerja: statusKerja ?? this.statusKerja,
      unitKerja: unitKerja ?? this.unitKerja,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      createdAt: createdAt,
    );
  }

  /// Creates a demo profile for testing
  static ProfileModel demoDosenProfile() {
    return ProfileModel(
      id: 'demo-dosen-001',
      fullName: 'Dr. Eng. Muhammad Arifin, S.T., M.Sc.',
      nip: '00000000001',
      nidn: '0712345678',
      roleType: 'dosen',
      email: 'arifin@umm.ac.id',
      department: 'Informatika',
      faculty: 'Fakultas Teknik',
      position: 'Lektor Kepala',
      jabatanAkademik: 'Lektor Kepala',
      pangkat: 'Penata Tk. I',
      golongan: 'III/d',
      ktp: '3573012345678901',
      statusKepegawaian: 'Dosen Tetap Yayasan',
      statusKerja: 'Aktif',
      unitKerja: 'Program Studi Informatika',
      birthDate: DateTime(1985, 7, 12),
      birthPlace: 'Malang',
      gender: 'Laki-laki',
      religion: 'Islam',
      address: 'Jl. Raya Tlogomas No. 246 Malang',
      phone: '081234567890',
      createdAt: DateTime.now().subtract(const Duration(days: 365 * 5 + 30 * 4)),
    );
  }

  static ProfileModel demoKaryawanProfile() {
    return ProfileModel(
      id: 'demo-karyawan-001',
      fullName: 'Siti Rahayu, S.E.',
      nip: '00000000002',
      roleType: 'karyawan',
      email: 'siti.rahayu@umm.ac.id',
      department: 'Biro Administrasi',
      faculty: 'Rektorat',
      position: 'Kepala Sub Bagian',
      pangkat: 'Penata Muda Tk. I',
      golongan: 'III/b',
      ktp: '3573019876543210',
      statusKepegawaian: 'Karyawan Tetap Yayasan',
      statusKerja: 'Aktif',
      unitKerja: 'Biro Administrasi Akademik',
      birthDate: DateTime(1990, 3, 15),
      birthPlace: 'Surabaya',
      gender: 'Perempuan',
      religion: 'Islam',
      address: 'Jl. Soekarno Hatta No. 100 Malang',
      phone: '082345678901',
      createdAt: DateTime.now().subtract(const Duration(days: 365 * 3 + 30 * 2)),
    );
  }
}
