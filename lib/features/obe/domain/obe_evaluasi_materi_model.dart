class ObeEvaluasiMateriModel {
  final String id;
  final String className;
  final String major;
  final String courseName;
  final int sks;
  final List<bool> meetingsSesuai;
  final int sesuaiCount;
  final int tidakSesuaiCount;

  ObeEvaluasiMateriModel({
    required this.id,
    required this.className,
    required this.major,
    required this.courseName,
    required this.sks,
    required this.meetingsSesuai,
    required this.sesuaiCount,
    required this.tidakSesuaiCount,
  });
}
