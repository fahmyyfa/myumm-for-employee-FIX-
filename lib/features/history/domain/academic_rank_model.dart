class AcademicRankModel {
  final String id;
  final String rankName;
  final double kum;
  final String tmtDikti;
  final String tmtUmm;
  final String noSkDikti;
  final String noSkUmm;
  final String tglSkDikti;
  final String tglSkUmm;
  final bool isCurrent;

  AcademicRankModel({
    required this.id,
    required this.rankName,
    required this.kum,
    required this.tmtDikti,
    required this.tmtUmm,
    required this.noSkDikti,
    required this.noSkUmm,
    required this.tglSkDikti,
    required this.tglSkUmm,
    this.isCurrent = false,
  });
}
