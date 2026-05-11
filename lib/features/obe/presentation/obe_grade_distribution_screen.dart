import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/obe_provider.dart';
import '../domain/obe_grade_model.dart';

class ObeGradeDistributionScreen extends ConsumerWidget {
  final String courseId;

  const ObeGradeDistributionScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(obeCourseDetailProvider(courseId));
    final gradesAsync = ref.watch(obeGradeDistributionProvider(courseId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Detail Persebaran Nilai'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            courseAsync.when(
              data: (course) {
                if (course == null) return const SizedBox();
                return Container(
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
                            child: Text('${course.sks} SKS', style: AppTextStyles.caption.copyWith(color: const Color(0xFF2C5BA1), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(course.courseName, style: AppTextStyles.heading2.copyWith(color: Colors.white)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 14),
                          const SizedBox(width: 8),
                          Text('TA 2025/2026', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 24),

            // Title
            Text('Riwayat Laporan', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
            Text('Persebaran Nilai', style: AppTextStyles.heading1),
            const SizedBox(height: 16),

            // Grades List
            gradesAsync.when(
              data: (grades) => Column(
                children: grades.map((g) => _buildGradeCard(g)).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeCard(ObeGradeDistributionModel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.className, style: AppTextStyles.heading3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${data.totalStudents} Mahasiswa', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Table Header
          Row(
            children: [
              Expanded(flex: 2, child: Text('GRADE', style: AppTextStyles.chipText.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5))),
              Expanded(flex: 3, child: Center(child: Text('JML MHS', style: AppTextStyles.chipText.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)))),
              Expanded(flex: 3, child: Align(alignment: Alignment.centerRight, child: Text('PERSEN', style: AppTextStyles.chipText.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)))),
            ],
          ),
          const SizedBox(height: 16),
          
          // Table Rows
          ...data.grades.map((g) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(g.grade, style: AppTextStyles.subtitle2)),
                  Expanded(flex: 3, child: Center(child: Text(g.count.toString(), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)))),
                  Expanded(
                    flex: 3, 
                    child: Align(
                      alignment: Alignment.centerRight, 
                      child: Text('${g.percentage.toStringAsFixed(1)}%', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0)))
                    )
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
