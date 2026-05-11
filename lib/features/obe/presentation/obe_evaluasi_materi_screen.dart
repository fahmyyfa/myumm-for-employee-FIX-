import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/obe_provider.dart';
import '../domain/obe_evaluasi_materi_model.dart';

class ObeEvaluasiMateriScreen extends ConsumerWidget {
  final String courseId;

  const ObeEvaluasiMateriScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evalsAsync = ref.watch(obeEvaluasiMateriProvider(courseId));

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
                      const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 14),
                      const SizedBox(width: 8),
                      Text('TA 2025/2026', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text('Riwayat Laporan', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
            Text('Evaluasi Materi', style: AppTextStyles.heading1),
            const SizedBox(height: 24),

            // Class List
            evalsAsync.when(
              data: (evals) => Column(
                children: evals.map((eval) => _buildClassCard(context, eval)).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, ObeEvaluasiMateriModel eval) {
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
              Text(eval.className, style: AppTextStyles.subtitle1.copyWith(color: const Color(0xFF2C5BA1))),
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
          const SizedBox(height: 20),
          
          // Grid of checkmarks/crosses
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: eval.meetingsSesuai.map((sesuai) => _buildStatusBox(sesuai)).toList(),
          ),
          
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SESUAI', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                    Text('${eval.sesuaiCount}', style: AppTextStyles.subtitle1.copyWith(color: const Color(0xFF1A9A5B))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TIDAK SESUAI', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                    Text('${eval.tidakSesuaiCount}', style: AppTextStyles.subtitle1.copyWith(color: const Color(0xFFD94B2B))),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          Divider(color: AppColors.border.withValues(alpha: 0.5)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1550B0),
              ),
              child: Text('LIHAT DETAIL KELAS', style: AppTextStyles.button.copyWith(color: const Color(0xFF1550B0))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBox(bool sesuai) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: sesuai ? const Color(0xFFE8F5EF) : const Color(0xFFFFECE5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        sesuai ? Icons.check : Icons.close,
        size: 14,
        color: sesuai ? const Color(0xFF1A9A5B) : const Color(0xFFD94B2B),
      ),
    );
  }
}
