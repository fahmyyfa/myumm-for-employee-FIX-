import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/obe_provider.dart';
import '../domain/obe_evaluation_detail_model.dart';

class ObeEvaluationDetailScreen extends ConsumerWidget {
  final String courseId;
  final String classId;

  const ObeEvaluationDetailScreen({super.key, required this.courseId, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(obeEvaluationDetailProvider(classId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Detail Evaluasi'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: detailAsync.when(
        data: (detail) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C5BA1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF2C5BA1).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('MATA KULIAH', style: AppTextStyles.chipText.copyWith(color: Colors.white.withValues(alpha: 0.8), letterSpacing: 1.0)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('3 SKS', style: AppTextStyles.caption.copyWith(color: const Color(0xFF2C5BA1), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Pemrograman Mobile', style: AppTextStyles.heading2.copyWith(color: Colors.white)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.groups_outlined, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text('Kelas A', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                        const SizedBox(width: 24),
                        const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 14),
                        const SizedBox(width: 8),
                        Text('TA 2025/2026', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Analisis Kelas Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ANALISIS KELAS', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                        const Icon(Icons.bar_chart, color: Color(0xFF1550B0), size: 16),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(detail.rataIpClass.toString(), style: AppTextStyles.heading1.copyWith(color: const Color(0xFF1550B0), fontSize: 32, height: 1.0)),
                                Text(' / 3.5', style: AppTextStyles.subtitle1.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Rata-Rata IP Class', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text('${detail.tuntasCount}', style: AppTextStyles.subtitle1.copyWith(color: const Color(0xFF1550B0))),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                                  child: Text('Tuntas', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontSize: 8)),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Text('${detail.tidakTuntasCount}', style: AppTextStyles.subtitle1.copyWith(color: const Color(0xFFD94B2B))),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: const Color(0xFFFFECE5), borderRadius: BorderRadius.circular(4)),
                                  child: Text('Tidak Tuntas', style: AppTextStyles.caption.copyWith(color: const Color(0xFFD94B2B), fontSize: 8)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('DAFTAR MAHASISWA (${detail.students.length})', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                  Text('Lihat Semua', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),

              // Student List
              ...detail.students.asMap().entries.map((entry) => _buildStudentCard(context, entry.key + 1, entry.value)),
              
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text('LIHAT DETAIL MAHASISWA', style: AppTextStyles.button.copyWith(color: const Color(0xFF1550B0))),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, int index, ObeStudentEvaluation student) {
    // Group sub-CPMKs by CPMK Code
    final groupedSubCpmks = <String, List<ObeSubCpmkGrade>>{};
    for (var sub in student.subCpmkGrades) {
      if (!groupedSubCpmks.containsKey(sub.cpmkCode)) {
        groupedSubCpmks[sub.cpmkCode] = [];
      }
      groupedSubCpmks[sub.cpmkCode]!.add(sub);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
            width: 4,
            decoration: const BoxDecoration(
              color: Color(0xFF3F82F7),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: const BoxDecoration(color: Color(0xFFE8F0FE), shape: BoxShape.circle),
                            child: Center(child: Text(index.toString(), style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0)))),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(student.nim, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                              Text(student.name, style: AppTextStyles.subtitle2),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('TOTAL: ${student.totalGrade}', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 10)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFF1A9A5B), borderRadius: BorderRadius.circular(4)),
                            child: Text('GRADE: ${student.gradeLetter}', style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(flex: 2, child: SizedBox()), // Empty for header spacing
                      Expanded(child: Text('PERSEN', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10), textAlign: TextAlign.center)),
                      Expanded(child: Text('NILAI', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10), textAlign: TextAlign.right)),
                    ],
                  ),
                  
                  ...groupedSubCpmks.entries.map((group) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                          child: Text(group.key, style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 8)),
                        ),
                        const SizedBox(height: 8),
                        ...group.value.map((grade) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text(grade.subCpmkName, style: AppTextStyles.subtitle2)),
                              Expanded(
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5EF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('${grade.percentage.toInt()}%', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1A9A5B), fontWeight: FontWeight.bold, fontSize: 10)),
                                  ),
                                ),
                              ),
                              Expanded(child: Text(grade.grade.toString(), style: AppTextStyles.subtitle2, textAlign: TextAlign.right)),
                            ],
                          ),
                        )),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
