import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/obe_course_model.dart';
import '../domain/obe_grade_model.dart';
import '../domain/obe_evaluation_model.dart';
import '../domain/obe_jurnal_model.dart';
import '../domain/obe_capaian_model.dart';
import '../domain/obe_evaluasi_materi_model.dart';
import '../domain/obe_evaluation_detail_model.dart';
import '../domain/obe_kinerja_model.dart';

final obeCoursesProvider = FutureProvider<List<ObeCourseModel>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    ObeCourseModel(
      id: '1',
      courseName: 'Pengembangan Aplikasi Mobile',
      curriculum: 'OBE INFORMATIKA 2025',
      sks: 3,
      lecturer: 'Dr. Eng. Muhammad Arifin, S.T., M.Sc.',
      faculty: 'Fakultas Teknik',
      major: 'Informatika',
    ),
    ObeCourseModel(
      id: '2',
      courseName: 'Metode Penelitian',
      curriculum: 'OBE INFORMATIKA 2025',
      sks: 3,
      lecturer: 'Dr. Eng. Muhammad Arifin, S.T., M.Sc.',
      faculty: 'Fakultas Teknik',
      major: 'Informatika',
    ),
    ObeCourseModel(
      id: '3',
      courseName: 'Algoritma Pemrograman',
      curriculum: 'OBE INFORMATIKA 2025',
      sks: 3,
      lecturer: 'Dr. Eng. Muhammad Arifin, S.T., M.Sc.',
      faculty: 'Fakultas Teknik',
      major: 'Informatika',
    ),
  ];
});

final obeCourseDetailProvider = FutureProvider.family<ObeCourseModel?, String>((ref, id) async {
  final courses = await ref.watch(obeCoursesProvider.future);
  return courses.firstWhere((c) => c.id == id, orElse: () => courses.first);
});

final obeGradeDistributionProvider = FutureProvider.family<List<ObeGradeDistributionModel>, String>((ref, courseId) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return [
    ObeGradeDistributionModel(
      id: 'c1',
      className: 'Class A',
      totalStudents: 42,
      grades: [
        ObeGradeItem(grade: 'A', count: 12, percentage: 28.5),
        ObeGradeItem(grade: 'B+', count: 8, percentage: 19.0),
        ObeGradeItem(grade: 'B', count: 10, percentage: 23.8),
        ObeGradeItem(grade: 'C+', count: 8, percentage: 19.0),
        ObeGradeItem(grade: 'D', count: 2, percentage: 4.2),
        ObeGradeItem(grade: 'E', count: 2, percentage: 4.2),
      ],
    ),
    ObeGradeDistributionModel(
      id: 'c2',
      className: 'Class D',
      totalStudents: 42,
      grades: [
        ObeGradeItem(grade: 'A', count: 12, percentage: 28.5),
        ObeGradeItem(grade: 'B+', count: 8, percentage: 19.0),
        ObeGradeItem(grade: 'B', count: 10, percentage: 23.8),
        ObeGradeItem(grade: 'C+', count: 8, percentage: 19.0),
        ObeGradeItem(grade: 'D', count: 2, percentage: 4.2),
        ObeGradeItem(grade: 'E', count: 2, percentage: 4.2),
      ],
    ),
  ];
});

final obeEvaluationProvider = FutureProvider.family<List<ObeEvaluationModel>, String>((ref, courseId) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return [
    ObeEvaluationModel(
      id: 'e1',
      className: 'KELAS A',
      major: 'INFORMATIKA',
      courseName: 'Pengembangan Aplikasi Mobile',
      sks: 3,
      lecturer: 'Dr. Ahmad Wijaya',
      totalStudents: 48,
    ),
    ObeEvaluationModel(
      id: 'e2',
      className: 'KELAS B',
      major: 'INFORMATIKA',
      courseName: 'Pengembangan Aplikasi Mobile',
      sks: 3,
      lecturer: 'Dr. Ahmad Wijaya',
      totalStudents: 48,
    ),
    ObeEvaluationModel(
      id: 'e3',
      className: 'KELAS C',
      major: 'INFORMATIKA',
      courseName: 'Pengembangan Aplikasi Mobile',
      sks: 3,
      lecturer: 'Dr. Ahmad Wijaya',
      totalStudents: 48,
    ),
  ];
});

final obeJurnalDetailProvider = FutureProvider.family<List<ObeJurnalItem>, String>((ref, classId) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return [
    ObeJurnalItem(
      refId: 'REF#029381',
      date: 'Kamis, 26 Feb 2026',
      room: '208 GKB I',
      time: '09:00 - 09:50',
      topic: 'Dasar pemrograman OOP',
      subTopic: 'Java Intro & SDK Setup',
      presentCount: 31,
      absentCount: 31,
    ),
    ObeJurnalItem(
      refId: 'REF#029381',
      date: 'Kamis, 26 Feb 2026',
      room: '208 GKB I',
      time: '09:00 - 09:50',
      topic: 'Dasar pemrograman OOP',
      subTopic: 'Java Intro & SDK Setup',
      presentCount: 31,
      absentCount: 31,
    ),
  ];
});

final obeCapaianDetailProvider = FutureProvider.family<ObeCapaianDetailModel, String>((ref, classId) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return ObeCapaianDetailModel(
    rataCplNa: 3.4,
    rataCplNh: 'B+',
    averages: [
      ObeCplAverage(cplCode: '2025-3', average: 3.4, target: 3.0),
      ObeCplAverage(cplCode: '2025-3', average: 3.4, target: 3.0),
      ObeCplAverage(cplCode: '2025-3', average: 3.4, target: 3.0),
    ],
    students: [
      ObeStudentCapaian(
        nim: '210910101001',
        name: 'Aditya Pratama',
        totalGrade: 88.5,
        gradeLetter: 'A',
        cplGrades: [
          ObeCplGrade(cplCode: '2025-3', percentage: 50, grade: 88.5),
          ObeCplGrade(cplCode: '2025-4', percentage: 50, grade: 72.0),
          ObeCplGrade(cplCode: '2025-5', percentage: 40, grade: 92.4),
        ],
      ),
      ObeStudentCapaian(
        nim: '210910101001',
        name: 'Aditya Pratama',
        totalGrade: 88.5,
        gradeLetter: 'A',
        cplGrades: [
          ObeCplGrade(cplCode: '2025-3', percentage: 50, grade: 88.5),
          ObeCplGrade(cplCode: '2025-4', percentage: 50, grade: 72.0),
          ObeCplGrade(cplCode: '2025-5', percentage: 40, grade: 92.4),
        ],
      ),
    ],
  );
});

final obeEvaluasiMateriProvider = FutureProvider.family<List<ObeEvaluasiMateriModel>, String>((ref, courseId) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return [
    ObeEvaluasiMateriModel(
      id: 'em1',
      className: 'Pemrograman Mobile A',
      major: 'INFORMATIKA',
      courseName: 'Pemrograman Mobile',
      sks: 3,
      meetingsSesuai: [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, true, false, false, false, false, false, false, false, true, true, true],
      sesuaiCount: 19,
      tidakSesuaiCount: 11,
    ),
    ObeEvaluasiMateriModel(
      id: 'em2',
      className: 'Pemrograman Mobile D',
      major: 'INFORMATIKA',
      courseName: 'Pemrograman Mobile',
      sks: 3,
      meetingsSesuai: [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, true, false, false, false, false, false, false, false, true, true, true],
      sesuaiCount: 19,
      tidakSesuaiCount: 11,
    ),
    ObeEvaluasiMateriModel(
      id: 'em3',
      className: 'Pemrograman Mobile F',
      major: 'INFORMATIKA',
      courseName: 'Pemrograman Mobile',
      sks: 3,
      meetingsSesuai: [true, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, true, false, false, false, false, false, false, false, true, true, true],
      sesuaiCount: 19,
      tidakSesuaiCount: 11,
    ),
  ];
});

final obeEvaluationDetailProvider = FutureProvider.family<ObeEvaluationDetailModel, String>((ref, classId) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return ObeEvaluationDetailModel(
    rataIpClass: 3.82,
    tuntasCount: 28,
    tidakTuntasCount: 4,
    students: [
      ObeStudentEvaluation(
        nim: '210910101001',
        name: 'Aditya Pratama',
        totalGrade: 88.5,
        gradeLetter: 'A',
        subCpmkGrades: [
          ObeSubCpmkGrade(cpmkCode: 'CPMK 1', subCpmkName: 'Sub-Cpmk 1', percentage: 50, grade: 88.5),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 1', subCpmkName: 'Sub-Cpmk 2', percentage: 50, grade: 72.0),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 1', subCpmkName: 'Sub-Cpmk 3', percentage: 40, grade: 92.4),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 2', subCpmkName: 'Sub-Cpmk 4', percentage: 50, grade: 88.5),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 2', subCpmkName: 'Sub-Cpmk 5', percentage: 50, grade: 72.0),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 4', subCpmkName: 'Sub-Cpmk 6', percentage: 50, grade: 88.5),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 4', subCpmkName: 'Sub-Cpmk 7', percentage: 50, grade: 72.0),
        ],
      ),
      ObeStudentEvaluation(
        nim: '210910101001',
        name: 'Aditya Pratama',
        totalGrade: 88.5,
        gradeLetter: 'A',
        subCpmkGrades: [
          ObeSubCpmkGrade(cpmkCode: 'CPMK 1', subCpmkName: 'Sub-Cpmk 1', percentage: 50, grade: 88.5),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 1', subCpmkName: 'Sub-Cpmk 2', percentage: 50, grade: 72.0),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 1', subCpmkName: 'Sub-Cpmk 3', percentage: 40, grade: 92.4),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 2', subCpmkName: 'Sub-Cpmk 4', percentage: 50, grade: 88.5),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 2', subCpmkName: 'Sub-Cpmk 5', percentage: 50, grade: 72.0),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 4', subCpmkName: 'Sub-Cpmk 6', percentage: 50, grade: 88.5),
          ObeSubCpmkGrade(cpmkCode: 'CPMK 4', subCpmkName: 'Sub-Cpmk 7', percentage: 50, grade: 72.0),
        ],
      ),
    ],
  );
});

final obeKinerjaDetailProvider = FutureProvider.family<ObeKinerjaModel, String>((ref, classId) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return ObeKinerjaModel(
    courseId: '1',
    courseName: 'Pemrograman Mobile',
    sks: 3,
    className: 'Kelas A',
    cpls: [
      ObeKinerjaCpl(code: 'CPL 2025-3', description: 'Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi.'),
      ObeKinerjaCpl(code: 'CPL 2025-5', description: 'Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi.'),
    ],
    cpmks: [
      ObeKinerjaCpmk(
        code: 'CPMK 1',
        description: 'Mahasiswa menguasai pilar dasar OOP.',
        subCpmks: [
          ObeKinerjaSubCpmk(code: 'Sub-Cpmk 1.', description: 'Mahasiswa menguasai pilar dasar OOP.'),
          ObeKinerjaSubCpmk(code: 'Sub-Cpmk 2.', description: 'Mahasiswa menguasai pilar dasar OOP.'),
          ObeKinerjaSubCpmk(code: 'Sub-Cpmk 3.', description: 'Mahasiswa menguasai pilar dasar OOP.'),
        ],
      ),
      ObeKinerjaCpmk(
        code: 'CPMK 2',
        description: 'Mahasiswa menguasai pilar dasar OOP.',
        subCpmks: [
          ObeKinerjaSubCpmk(code: 'Sub-Cpmk 4.', description: 'Mahasiswa menguasai pilar dasar OOP.'),
          ObeKinerjaSubCpmk(code: 'Sub-Cpmk 5.', description: 'Mahasiswa mampu melakukan abstraksi data.'),
        ],
      ),
      ObeKinerjaCpmk(
        code: 'CPMK 3',
        description: 'Mahasiswa menguasai pilar dasar OOP.',
        subCpmks: [
          ObeKinerjaSubCpmk(code: 'Sub-Cpmk 6.', description: 'Mahasiswa menguasai pilar dasar OOP.'),
        ],
      ),
    ],
    rpsTidakLengkap: ['1. Profil Lulusan'],
    presensiMhs: 11.12,
    presensiDosen: 21.15,
    kesesuaianRps: 13.52,
    capaianIndeksPrestasi: 0.0,
    targetIndeksPrestasi: 0.0,
    gradeDistribution: {'F': 46, 'A': 0, 'B+': 0, 'B': 0, 'C+': 0, 'C': 0, 'D': 0, 'E': 0, 'X': 0},
    pengendalian: 'Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi.',
    peningkatan: 'Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi. Mampu merancang sistem perangkat lunak terintegrasi.',
  );
});
