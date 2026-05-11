import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/obe_provider.dart';
import '../domain/obe_capaian_model.dart';

class ObeCapaianDetailScreen extends ConsumerWidget {
  final String courseId;
  final String classId;

  const ObeCapaianDetailScreen({super.key, required this.courseId, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capaianAsync = ref.watch(obeCapaianDetailProvider(classId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Detail Rata-Rata Capaian'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: capaianAsync.when(
        data: (capaian) => SingleChildScrollView(
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

              // Rata-Rata CPL NA and NH row
              Row(
                children: [
                  Expanded(child: _buildAverageCard('RATA-RATA CPL (NA)', capaian.rataCplNa.toString(), 'TARGET: 3.0')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildAverageCard('RATA-RATA CPL (NH)', capaian.rataCplNh, 'TARGET: B')),
                ],
              ),
              const SizedBox(height: 16),
              
              // CPL Average List
              ...capaian.averages.map((avg) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildAverageCard('RATA-RATA CPL ${avg.cplCode}', avg.average.toString(), 'TARGET: ${avg.target}', true),
              )),
              
              const SizedBox(height: 24),
              Text('DAFTAR MAHASISWA (${capaian.students.length} Mahasiswa)', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 16),

              // Student List
              ...capaian.students.asMap().entries.map((entry) => _buildStudentCard(context, entry.key + 1, entry.value)),
              
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

  Widget _buildAverageCard(String title, String value, String subtitle, [bool fullWidth = false]) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C5BA1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: const Color(0xFF2C5BA1).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(width: 3, color: Colors.white.withValues(alpha: 0.5)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: AppTextStyles.chipText.copyWith(color: Colors.white.withValues(alpha: 0.8), letterSpacing: 1.0))),
                    if (fullWidth) Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Text('50%', style: AppTextStyles.caption.copyWith(color: const Color(0xFF2C5BA1), fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(value, style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 32, height: 1.0)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(subtitle, style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 8)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, int index, ObeStudentCapaian student) {
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
                      Expanded(flex: 2, child: Text('CPL', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10))),
                      Expanded(child: Text('PERSEN', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10), textAlign: TextAlign.center)),
                      Expanded(child: Text('NILAI', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10), textAlign: TextAlign.right)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...student.cplGrades.map((grade) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(grade.cplCode, style: AppTextStyles.subtitle2)),
                        Expanded(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: grade.percentage >= 50 ? const Color(0xFFE8F5EF) : const Color(0xFFE8F0FE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('${grade.percentage.toInt()}%', style: AppTextStyles.caption.copyWith(color: grade.percentage >= 50 ? const Color(0xFF1A9A5B) : const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 10)),
                            ),
                          ),
                        ),
                        Expanded(child: Text(grade.grade.toString(), style: AppTextStyles.subtitle2, textAlign: TextAlign.right)),
                      ],
                    ),
                  )),
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
