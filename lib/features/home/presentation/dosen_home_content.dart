import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../profile/domain/profile_model.dart';

class DosenHomeContent extends StatelessWidget {
  final ProfileModel profile;
  const DosenHomeContent({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Search bar + notification
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7), size: 20),
                          const SizedBox(width: 8),
                          Text('Cari layanan atau fitur tertentu',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => context.push('/notifications'),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Profile row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName,
                        style: AppTextStyles.subtitle2.copyWith(color: Colors.white, fontSize: 15),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('NIP: ${profile.nip}',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Scrollable content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Layanan Cepat
                      GlassCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text('Layanan Cepat', style: AppTextStyles.subtitle2),
                            const SizedBox(height: 16),
                            _buildServiceGrid(context),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Informasi Kegiatan
                      Text('Informasi Kegiatan', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 10),
                      _buildActivityCard('Rapat Karyawan', '10 April, 09:00 WIB • ICT Center UMM'),
                      _buildActivityCard('Rapat Karyawan', '10 April, 09:00 WIB • ICT Center UMM'),
                      const SizedBox(height: 20),
                      // Agenda Mengajar Terdekat
                      _buildAgendaCard(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    final items = [
      _ServiceItem(Icons.calendar_month_rounded, 'Jadwal Kuliah', () => context.push('/schedule')),
      _ServiceItem(Icons.description_outlined, 'Laporan OBE', () => context.push('/obe')),
      _ServiceItem(Icons.groups_outlined, 'Perwalian', () {}),
      _ServiceItem(Icons.school_outlined, 'Tugas Akhir', () => context.push('/tugas-akhir')),
      _ServiceItem(Icons.fact_check_outlined, 'Presensi', () => context.push('/attendance/daily')),
      _ServiceItem(Icons.event_note_outlined, 'Kegiatan', () => context.push('/activities/attendance')),
      _ServiceItem(Icons.workspace_premium_outlined, 'Jab. Akademik', () => context.push('/academic-ranks')),
      _ServiceItem(Icons.grid_view_rounded, 'Lainnya', () {}),
    ];
    return GridView.count(
      crossAxisCount: 4, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14, crossAxisSpacing: 8,
      childAspectRatio: 0.8,
      children: items.map((item) => _buildGridItem(item)).toList(),
    );
  }

  Widget _buildGridItem(_ServiceItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.primarySurface, borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(item.label, style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 11),
            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, String subtitle) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.campaign_outlined, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textHint),
        ],
      ),
    );
  }

  Widget _buildAgendaCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Agenda Mengajar Terdekat',
            style: AppTextStyles.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          Text('Tahun Akademik 2025/2026',
            style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pemrograman Berorientasi Objek',
                        style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.white.withValues(alpha: 0.7), size: 14),
                          const SizedBox(width: 4),
                          Text('08:00 - 10:00', style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                          const SizedBox(width: 10),
                          Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.7), size: 14),
                          const SizedBox(width: 4),
                          Text('Lab. Multimedia', style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildAgendaBtn(Icons.fact_check_outlined, 'Presensi', AppColors.success, () => context.push('/attendance/daily')),
              const SizedBox(width: 8),
              _buildAgendaBtn(Icons.edit_calendar_outlined, 'Jadwal', AppColors.warning, () => context.push('/schedule')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.chipText.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ServiceItem(this.icon, this.label, this.onTap);
}
