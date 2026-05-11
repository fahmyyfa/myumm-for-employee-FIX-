class FamilyMemberModel {
  final String? id;
  final String profileId;
  final String name;
  final String relationship;
  final DateTime? birthDate;
  final String? birthPlace;
  final String? education;
  final String? occupation;
  final String? status;

  const FamilyMemberModel({
    this.id,
    required this.profileId,
    required this.name,
    required this.relationship,
    this.birthDate,
    this.birthPlace,
    this.education,
    this.occupation,
    this.status,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['id'] as String?,
      profileId: json['profile_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'] as String)
          : null,
      birthPlace: json['birth_place'] as String?,
      education: json['education'] as String?,
      occupation: json['occupation'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'profile_id': profileId,
      'name': name,
      'relationship': relationship,
      'birth_date': birthDate?.toIso8601String().split('T').first,
      'birth_place': birthPlace,
      'education': education,
      'occupation': occupation,
      'status': status,
    };
  }

  FamilyMemberModel copyWith({
    String? id,
    String? profileId,
    String? name,
    String? relationship,
    DateTime? birthDate,
    String? birthPlace,
    String? education,
    String? occupation,
    String? status,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      status: status ?? this.status,
    );
  }

  static List<FamilyMemberModel> demoData(String profileId) {
    return [
      FamilyMemberModel(
        id: 'fm-001',
        profileId: profileId,
        name: 'Fatimah Azzahra',
        relationship: 'Istri',
        birthDate: DateTime(1988, 5, 20),
        birthPlace: 'Malang',
        education: 'S1 Pendidikan',
        occupation: 'Guru',
        status: 'Aktif',
      ),
      FamilyMemberModel(
        id: 'fm-002',
        profileId: profileId,
        name: 'Ahmad Fauzan',
        relationship: 'Anak',
        birthDate: DateTime(2015, 1, 10),
        birthPlace: 'Malang',
        education: 'SD',
        occupation: 'Pelajar',
        status: 'Aktif',
      ),
      FamilyMemberModel(
        id: 'fm-003',
        profileId: profileId,
        name: 'Aisyah Putri',
        relationship: 'Anak',
        birthDate: DateTime(2018, 8, 25),
        birthPlace: 'Malang',
        education: 'TK',
        occupation: 'Pelajar',
        status: 'Aktif',
      ),
    ];
  }
}
