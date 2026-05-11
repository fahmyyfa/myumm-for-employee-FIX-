class ObeKinerjaModel {
  final String courseId;
  final String courseName;
  final int sks;
  final String className;
  
  // Perencanaan
  final List<ObeKinerjaCpl> cpls;
  final List<ObeKinerjaCpmk> cpmks;
  final List<String> rpsTidakLengkap;

  // Pelaksanaan (simplified for one class view)
  final double presensiMhs;
  final double presensiDosen;
  final double kesesuaianRps;

  // Evaluasi
  final double capaianIndeksPrestasi;
  final double targetIndeksPrestasi;
  final Map<String, int> gradeDistribution; // e.g. {'A': 0, 'B+': 0, ...}

  // Pengendalian & Peningkatan
  final String pengendalian;
  final String peningkatan;

  ObeKinerjaModel({
    required this.courseId,
    required this.courseName,
    required this.sks,
    required this.className,
    required this.cpls,
    required this.cpmks,
    required this.rpsTidakLengkap,
    required this.presensiMhs,
    required this.presensiDosen,
    required this.kesesuaianRps,
    required this.capaianIndeksPrestasi,
    required this.targetIndeksPrestasi,
    required this.gradeDistribution,
    required this.pengendalian,
    required this.peningkatan,
  });
}

class ObeKinerjaCpl {
  final String code;
  final String description;

  ObeKinerjaCpl({required this.code, required this.description});
}

class ObeKinerjaCpmk {
  final String code;
  final String description;
  final List<ObeKinerjaSubCpmk> subCpmks;

  ObeKinerjaCpmk({required this.code, required this.description, required this.subCpmks});
}

class ObeKinerjaSubCpmk {
  final String code;
  final String description;

  ObeKinerjaSubCpmk({required this.code, required this.description});
}
