import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/achievement_provider.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../providers/achievement_provider.dart';
import '../domain/achievement_model.dart';

class AchievementScreen extends ConsumerWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary), 
          onPressed: () => context.pop()
        ),
        title: Text('Capaian', style: AppTextStyles.subtitle1),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Kegiatan', 
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text('Kelola Kinerja\nCapaian Akademik', 
              style: AppTextStyles.heading1.copyWith(height: 1.2, fontWeight: FontWeight.w800)),
            const SizedBox(height: 32),
            
            _buildCategoryCard(
              context, 
              'Kegiatan Ilmiah', 
              'Publikasi, Seminar & Workshop', 
              Icons.menu_book_rounded, 
              const Color(0xFFF0F5FF), 
              const Color(0xFF1550B0)
            ),
            _buildCategoryCard(
              context, 
              'Aktifitas Sosial', 
              'Pengabdian & Bakti Masyarakat', 
              Icons.emoji_events_outlined, 
              const Color(0xFFF0F5FF), 
              const Color(0xFF1550B0)
            ),
            _buildCategoryCard(
              context, 
              'Pelatihan/AA/Pekerti', 
              'Sertifikasi & Peningkatan Kompetensi', 
              Icons.person_outline_rounded, 
              const Color(0xFFFFF1F0), 
              const Color(0xFFD94B2B),
              realCategory: 'Pelatihan'
            ),
            _buildCategoryCard(
              context, 
              'Studi Lanjut', 
              'Monitoring Beasiswa & Tugas Belajar', 
              Icons.business_rounded, 
              const Color(0xFFF0F5FF), 
              const Color(0xFF1550B0)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, 
    String title, 
    String subtitle, 
    IconData icon, 
    Color bgColor, 
    Color iconColor, 
    {String? realCategory}
  ) {
    return GestureDetector(
      onTap: () => context.push('/achievements/detail/${realCategory ?? title}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), 
              blurRadius: 24, 
              offset: const Offset(0, 8)
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}
