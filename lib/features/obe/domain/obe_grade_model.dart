class ObeGradeDistributionModel {
  final String id;
  final String className;
  final int totalStudents;
  final List<ObeGradeItem> grades;

  ObeGradeDistributionModel({
    required this.id,
    required this.className,
    required this.totalStudents,
    required this.grades,
  });
}

class ObeGradeItem {
  final String grade;
  final int count;
  final double percentage;

  ObeGradeItem({
    required this.grade,
    required this.count,
    required this.percentage,
  });
}
