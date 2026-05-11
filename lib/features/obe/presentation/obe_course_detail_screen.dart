import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/obe_provider.dart';

class ObeCourseDetailScreen extends ConsumerWidget {
  final String courseId;

  const ObeCourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(obeCourseDetailProvider(courseId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Laporan OBE'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: courseAsync.when(
        data: (course) {
          if (course == null) return const Center(child: Text('Mata Kuliah tidak ditemukan'));
          
          return SingleChildScrollView(
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
                            child: Text('${course.sks} SKS', style: AppTextStyles.caption.copyWith(color: const Color(0xFF2C5BA1), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(course.courseName, style: AppTextStyles.heading2.copyWith(color: Colors.white)),
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
                const SizedBox(height: 24),

                // Title
                Text('Daftar Riwayat', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                Text('Laporan OBE', style: AppTextStyles.heading1),
                const SizedBox(height: 16),

                // Menu Items
                _buildMenuCard(context, Icons.school_outlined, 'Persebaran Nilai', 'Laporan persebaran nilai mahasiswa', () {
                  context.push('/obe/course/$courseId/grades');
                }),
                _buildMenuCard(context, Icons.menu_book_outlined, 'Jurnal Mengajar', 'Laporan jurnal mengajar', () {
                  context.push('/obe/course/$courseId/jurnal');
                }),
                _buildMenuCard(context, Icons.show_chart_outlined, 'Evaluasi', 'Laporan evaluasi kesesuaian materi', () {
                  context.push('/obe/course/$courseId/evaluasi_materi');
                }, color: const Color(0xFFFFECE5), iconColor: const Color(0xFFD94B2B)),
                _buildMenuCard(context, Icons.bar_chart_outlined, 'Penilaian', 'Laporan penilaian sub CPMK', () {
                  context.push('/obe/course/$courseId/evaluation');
                }),
                _buildMenuCard(context, Icons.groups_outlined, 'Kinerja Dosen', 'Laporan kinerja dosen', () {
                  context.push('/obe/course/$courseId/kinerja');
                }, color: const Color(0xFFFFECE5), iconColor: const Color(0xFFD94B2B)),
                _buildMenuCard(context, Icons.workspace_premium_outlined, 'Rata-Rata Capaian', 'Laporan capaian', () {
                  context.push('/obe/course/$courseId/capaian');
                }),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, {Color? color, Color? iconColor}) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: color != null ? const Color(0xFFFFB28A) : const Color(0xFFB3C5E7),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color ?? AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: iconColor ?? const Color(0xFF2C5BA1), size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(title, style: AppTextStyles.subtitle1),
                              const SizedBox(height: 4),
                              Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
