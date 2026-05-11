import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/obe_provider.dart';
import '../domain/obe_evaluation_model.dart';

class ObeEvaluationScreen extends ConsumerWidget {
  final String courseId;

  const ObeEvaluationScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evalsAsync = ref.watch(obeEvaluationProvider(courseId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Detail Evaluasi'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text('Riwayat Laporan', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
            Text('Penilaian Sub CPMK', style: AppTextStyles.heading1),
            const SizedBox(height: 24),

            // Evaluations List
            evalsAsync.when(
              data: (evals) => Column(
                children: evals.asMap().entries.map((entry) {
                  return _buildEvaluationCard(context, entry.key + 1, entry.value);
                }).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationCard(BuildContext context, int index, ObeEvaluationModel eval) {
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(index.toString().padLeft(2, '0'), style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Text('${eval.major} - ${eval.className}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1550B0).withValues(alpha: 0.2)),
                ),
                child: Text('${eval.sks} SKS', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(eval.courseName, style: AppTextStyles.subtitle1),
          const SizedBox(height: 12),
          
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(child: Text(eval.lecturer, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.domain, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(child: Text('${eval.totalStudents} Mahasiswa', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
            ],
          ),
          const SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: () {
              context.push('/obe/course/$courseId/evaluation/${eval.id}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1550B0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, size: 16),
                const SizedBox(width: 8),
                Text('Capaian', style: AppTextStyles.button.copyWith(fontSize: 12)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
