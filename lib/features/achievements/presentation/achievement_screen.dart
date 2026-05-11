import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Capaian'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daftar Kegiatan', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
            Text('Kelola Kinerja\nCapaian Akademik', style: AppTextStyles.heading1),
            const SizedBox(height: 24),
            
            _buildCategoryCard(
              context,
              title: 'Kegiatan Ilmiah',
              subtitle: 'Publikasi, Seminar & Workshop',
              icon: Icons.menu_book_outlined,
              iconBgColor: const Color(0xFFF0F5FF),
              iconColor: const Color(0xFF1550B0),
              route: '/achievements/Kegiatan Ilmiah',
            ),
            _buildCategoryCard(
              context,
              title: 'Aktifitas Sosial',
              subtitle: 'Pengabdian & Bakti Masyarakat',
              icon: Icons.emoji_events_outlined,
              iconBgColor: const Color(0xFFF0F5FF),
              iconColor: const Color(0xFF1550B0),
              route: '/achievements/Aktifitas Sosial',
            ),
            _buildCategoryCard(
              context,
              title: 'Pelatihan/AA/Pekerti',
              subtitle: 'Sertifikasi & Peningkatan Kompetensi',
              icon: Icons.person_pin_circle_outlined,
              iconBgColor: const Color(0xFFFFF4EC),
              iconColor: const Color(0xFFD94B2B),
              route: '/achievements/Pelatihan',
            ),
            _buildCategoryCard(
              context,
              title: 'Studi Lanjut',
              subtitle: 'Monitoring Beasiswa & Tugas Belajar',
              icon: Icons.business_outlined,
              iconBgColor: const Color(0xFFF6F0FF),
              iconColor: const Color(0xFF1550B0), // It looks dark blue in the mockup
              route: '/achievements/Studi Lanjut',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color iconBgColor, required Color iconColor, required String route}) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4, offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subtitle1),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}
