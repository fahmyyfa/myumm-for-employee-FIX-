import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/academic_rank_model.dart';

final academicRankProvider = FutureProvider<List<AcademicRankModel>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));
  
  return [
    AcademicRankModel(
      id: '1',
      rankName: 'Professor (Guru Besar)',
      kum: 850.5,
      tmtDikti: '2023-08-15',
      tmtUmm: '2023-09-01',
      noSkDikti: '882/UN/KP/2023',
      noSkUmm: 'UMM-SK/2023/12',
      tglSkDikti: '2023-08-01',
      tglSkUmm: '2023-08-20',
      isCurrent: true,
    ),
    AcademicRankModel(
      id: '2',
      rankName: 'Lektor Kepala',
      kum: 550.0,
      tmtDikti: '2020-01-15',
      tmtUmm: '2020-02-01',
      noSkDikti: '112/UN/KP/2020',
      noSkUmm: 'UMM-SK/2020/05',
      tglSkDikti: '2020-01-01',
      tglSkUmm: '2020-01-20',
    ),
    AcademicRankModel(
      id: '3',
      rankName: 'Lektor',
      kum: 300.0,
      tmtDikti: '2016-05-10',
      tmtUmm: '2016-06-01',
      noSkDikti: '405/UN/KP/2016',
      noSkUmm: 'UMM-SK/2016/08',
      tglSkDikti: '2016-04-25',
      tglSkUmm: '2016-05-15',
    ),
    AcademicRankModel(
      id: '4',
      rankName: 'Asisten Ahli',
      kum: 150.0,
      tmtDikti: '2012-03-01',
      tmtUmm: '2012-04-01',
      noSkDikti: '098/UN/KP/2012',
      noSkUmm: 'UMM-SK/2012/03',
      tglSkDikti: '2012-02-15',
      tglSkUmm: '2012-03-20',
    ),
  ];
});
