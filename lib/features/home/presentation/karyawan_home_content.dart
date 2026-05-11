import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../profile/domain/profile_model.dart';

class KaryawanHomeContent extends StatelessWidget {
  final ProfileModel profile;
  const KaryawanHomeContent({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(children: [
                Expanded(child: Container(
                  height: 44, padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
                  child: Row(children: [
                    Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7), size: 20),
                    const SizedBox(width: 8),
                    Text('Cari layanan atau fitur tertentu',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.6))),
                  ]),
                )),
                const SizedBox(width: 10),
                Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22)),
              ]),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                CircleAvatar(radius: 24, backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(Icons.person, color: Colors.white, size: 28)),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(profile.fullName, style: AppTextStyles.subtitle2.copyWith(color: Colors.white, fontSize: 15),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('NIP: ${profile.nip}',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                ]),
              ]),
            ),
            const SizedBox(height: 20),
            Expanded(child: Container(
              decoration: const BoxDecoration(color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 16),
                  GlassCard(padding: const EdgeInsets.all(20), child: Column(children: [
                    Text('Layanan Cepat', style: AppTextStyles.subtitle2),
                    const SizedBox(height: 16),
                    _buildServiceGrid(context),
                  ])),
                  const SizedBox(height: 20),
                  Text('Informasi Kegiatan', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 10),
                  _buildActivityCard('Rapat Koordinasi Bulanan', '15 April, 09:00 WIB • Aula Rektorat'),
                  _buildActivityCard('Pelatihan Sistem Informasi', '18 April, 13:00 WIB • Lab. Komputer'),
                  const SizedBox(height: 20),
                  _buildAgendaCard(context),
                  const SizedBox(height: 20),
                ]),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    final items = [
      _SItem(Icons.edit_note_rounded, 'Catatan Harian', () => context.push('/daily-log')),
      _SItem(Icons.model_training_outlined, 'Pelatihan', () => context.push('/achievements/Pelatihan')),
      _SItem(Icons.assessment_outlined, 'IKK', () {}),
      _SItem(Icons.account_balance_wallet_outlined, 'Keuangan', () {}),
      _SItem(Icons.fact_check_outlined, 'Presensi', () => context.push('/attendance/daily')),
      _SItem(Icons.event_note_outlined, 'Kegiatan', () => context.push('/activities/attendance')),
      _SItem(Icons.swap_horiz_rounded, 'Mutasi', () => context.push('/history/Riwayat Pekerjaan')),
      _SItem(Icons.grid_view_rounded, 'Lainnya', () {}),
    ];
    return GridView.count(crossAxisCount: 4, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 14, crossAxisSpacing: 8, childAspectRatio: 0.8,
      children: items.map((i) => GestureDetector(
        onTap: i.onTap,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 48, height: 48,
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(14)),
            child: Icon(i.icon, color: AppColors.primary, size: 24)),
          const SizedBox(height: 6),
          Text(i.label, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 11),
            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
        ]),
      )).toList(),
    );
  }

  Widget _buildActivityCard(String title, String subtitle) {
    return AppCard(padding: const EdgeInsets.all(14), child: Row(children: [
      Container(width: 42, height: 42,
        decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.campaign_outlined, color: AppColors.primary, size: 22)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppTextStyles.labelLarge),
        const SizedBox(height: 2),
        Text(subtitle, style: AppTextStyles.bodySmall),
      ])),
      const Icon(Icons.chevron_right, color: AppColors.textHint),
    ]));
  }

  Widget _buildAgendaCard(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Agenda Hari Ini', style: AppTextStyles.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.assignment_outlined, color: Colors.white, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Rapat Koordinasi Divisi', style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 13)),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.access_time, color: Colors.white.withValues(alpha: 0.7), size: 14),
                const SizedBox(width: 4),
                Text('09:00 - 11:00', style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                const SizedBox(width: 10),
                Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.7), size: 14),
                const SizedBox(width: 4),
                Text('Ruang Rapat Lt. 2', style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8))),
              ]),
            ])),
          ])),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => context.push('/daily-log'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.edit_note, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text('Catatan Harian', style: AppTextStyles.chipText.copyWith(color: Colors.white)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _SItem {
  final IconData icon; final String label; final VoidCallback onTap;
  const _SItem(this.icon, this.label, this.onTap);
}
