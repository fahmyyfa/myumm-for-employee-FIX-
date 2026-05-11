class ObeCapaianDetailModel {
  final double rataCplNa;
  final String rataCplNh;
  final List<ObeCplAverage> averages;
  final List<ObeStudentCapaian> students;

  ObeCapaianDetailModel({
    required this.rataCplNa,
    required this.rataCplNh,
    required this.averages,
    required this.students,
  });
}

class ObeCplAverage {
  final String cplCode;
  final double average;
  final double target;

  ObeCplAverage({
    required this.cplCode,
    required this.average,
    required this.target,
  });
}

class ObeStudentCapaian {
  final String nim;
  final String name;
  final double totalGrade;
  final String gradeLetter;
  final List<ObeCplGrade> cplGrades;

  ObeStudentCapaian({
    required this.nim,
    required this.name,
    required this.totalGrade,
    required this.gradeLetter,
    required this.cplGrades,
  });
}

class ObeCplGrade {
  final String cplCode;
  final double percentage;
  final double grade;

  ObeCplGrade({
    required this.cplCode,
    required this.percentage,
    required this.grade,
  });
}
