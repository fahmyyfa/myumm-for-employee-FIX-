class ObeEvaluationDetailModel {
  final double rataIpClass;
  final int tuntasCount;
  final int tidakTuntasCount;
  final List<ObeStudentEvaluation> students;

  ObeEvaluationDetailModel({
    required this.rataIpClass,
    required this.tuntasCount,
    required this.tidakTuntasCount,
    required this.students,
  });
}

class ObeStudentEvaluation {
  final String nim;
  final String name;
  final double totalGrade;
  final String gradeLetter;
  final List<ObeSubCpmkGrade> subCpmkGrades;

  ObeStudentEvaluation({
    required this.nim,
    required this.name,
    required this.totalGrade,
    required this.gradeLetter,
    required this.subCpmkGrades,
  });
}

class ObeSubCpmkGrade {
  final String cpmkCode;
  final String subCpmkName;
  final double percentage;
  final double grade;

  ObeSubCpmkGrade({
    required this.cpmkCode,
    required this.subCpmkName,
    required this.percentage,
    required this.grade,
  });
}
