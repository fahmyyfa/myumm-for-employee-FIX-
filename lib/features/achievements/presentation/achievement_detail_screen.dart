import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/achievement_provider.dart';
import '../domain/achievement_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/domain/profile_model.dart';

class AchievementDetailScreen extends ConsumerWidget {
  final String category;

  const AchievementDetailScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    
    // Page title logic
    final pageTitle = (category == 'Kegiatan Ilmiah') ? 'Detail Capaian' : 'Detail Riwayat';
    final sectionTitle = 'RIWAYAT ${category.toUpperCase()}';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: Text(pageTitle),
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) return const Center(child: Text('Profile tidak ditemukan'));
          
          return achievementsAsync.when(
            data: (allAchievements) {
              final items = allAchievements.where((a) => a.category == category).toList();
              
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(profile),
                    const SizedBox(height: 24),
                    Text(sectionTitle, style: AppTextStyles.chipText.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
                    const SizedBox(height: 16),
                    if (items.isEmpty)
                      const EmptyState(title: 'Belum ada data', subtitle: 'Data masih kosong.')
                    else
                      ...items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return _buildItemCard(category, index, item);
                      }),
                  ],
                ),
              );
            },
            loading: () => const Padding(padding: EdgeInsets.all(16), child: ShimmerList()),
            error: (e, _) => ErrorState(message: e.toString()),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Center(child: Icon(Icons.person, size: 40, color: Colors.white.withValues(alpha: 0.8))),
                Positioned(
                  bottom: -8, left: 0, right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1550B0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('VERIFIED', style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.fullName, style: AppTextStyles.subtitle1),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.scaffoldBackground, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.badge_outlined, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('NIP: ${profile.nip}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text('Dosen Tetap • Teknik Informatika', style: AppTextStyles.caption.copyWith(color: AppColors.textHint, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(String category, int index, AchievementModel item) {
    final df = DateFormat('dd MMMM yyyy', 'id');
    final dateStr = item.date != null ? df.format(item.date!) : '-';
    final dfShort = DateFormat('dd/MM/yyyy');
    final dateShortStr = item.date != null ? dfShort.format(item.date!) : '-';

    switch (category) {
      case 'Kegiatan Ilmiah':
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1550B0),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
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
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                              child: Text('NO. ${(index + 1).toString().padLeft(2, '0')}', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 10)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFF0F5FF), borderRadius: BorderRadius.circular(4)),
                              child: Text((item.status ?? 'JURNAL').toUpperCase(), style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 10)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(item.title, style: AppTextStyles.subtitle2.copyWith(fontSize: 13)),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildDetailCol('TINGKAT', item.location ?? 'Global')),
                            Expanded(child: _buildDetailCol('KEDUDUKAN', item.description ?? 'Penulis')),
                            Expanded(child: _buildDetailCol('TANGGAL TERBIT', dateShortStr, alignRight: true)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case 'Aktifitas Sosial':
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1550B0),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('JENIS AKTIFITAS', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                                  const SizedBox(height: 4),
                                  Text(item.category.toUpperCase(), style: AppTextStyles.subtitle2.copyWith(fontSize: 13)),
                                  const SizedBox(height: 12),
                                  Text('NAMA AKTIFITAS', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                                  const SizedBox(height: 4),
                                  Text(item.title, style: AppTextStyles.subtitle2.copyWith(fontSize: 13, color: const Color(0xFF1550B0))),
                                ],
                              ),
                            ),
                            Container(
                              width: 32, height: 32,
                              decoration: const BoxDecoration(color: Color(0xFFE8F0FE), shape: BoxShape.circle),
                              child: Center(child: Text('${index + 1}', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0)))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildDetailCol('KEDUDUKAN', item.description ?? '-')),
                            Expanded(child: _buildDetailCol('TANGGAL', dateStr)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case 'Pelatihan':
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text('${index + 1}', style: AppTextStyles.subtitle1.copyWith(color: const Color(0xFF1550B0)))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NAMA PELATIHAN', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text(item.title, style: AppTextStyles.subtitle2.copyWith(fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                    child: Text('Pelatihan', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDetailCol('PENYELENGGARA', item.location ?? '-')),
                  Expanded(child: _buildDetailCol('TINGKAT', item.status ?? 'Nasional')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildDetailCol('TANGGAL MULAI', dateStr)),
                  Expanded(child: _buildDetailCol('TANGGAL SELESAI', dateStr)),
                ],
              ),
            ],
          ),
        );

      case 'Studi Lanjut':
        // Show as the big card at the top, since the design only shows one Studi Lanjut typically.
        // For multiple, we can just render the card multiple times.
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('JENJANG & INSTITUSI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                            const SizedBox(height: 4),
                            Text(item.title, style: AppTextStyles.heading2.copyWith(color: const Color(0xFF1550B0))),
                            const SizedBox(height: 2),
                            Text(item.location ?? 'University', style: AppTextStyles.subtitle2),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                              child: Text('United Kingdom', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40, height: 40,
                        decoration: const BoxDecoration(color: Color(0xFFE8F0FE), shape: BoxShape.circle),
                        child: const Center(child: Icon(Icons.workspace_premium, color: Color(0xFF1550B0), size: 20)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Text('PROGRAM STUDI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(item.description ?? 'Ilmu Komputer', style: AppTextStyles.subtitle2),
                  const SizedBox(height: 12),
                  Text('TGL. AWAL S/D TGL. AKHIR', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text('9 Januari 2027 s/d 21 Juni 2030', style: AppTextStyles.subtitle2),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.timer_outlined, color: Color(0xFF1550B0), size: 20),
                        const SizedBox(height: 12),
                        Text('LAMA STUDI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text('0 Th / 8 Bl / 9 Hr', style: AppTextStyles.subtitle2),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF265CB5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.money, color: Colors.white, size: 20),
                        const SizedBox(height: 12),
                        Text('SUMBER BIAYA', style: AppTextStyles.chipText.copyWith(color: Colors.white.withValues(alpha: 0.7), letterSpacing: 0.5)),
                        const SizedBox(height: 4),
                        Text('Beasiswa LPDP', style: AppTextStyles.subtitle2.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RIWAYAT LAPORAN', style: AppTextStyles.subtitle2.copyWith(fontSize: 11, letterSpacing: 1.0)),
                Text('LIHAT SEMUA', style: AppTextStyles.subtitle2.copyWith(fontSize: 11, color: const Color(0xFF1550B0), letterSpacing: 1.0)),
              ],
            ),
            const SizedBox(height: 16),
            _buildStudiLanjutTimeline('01', 'Semester Ganjil 2026', '14 Des 2026', '3.92', '"Penelitian bab 1 selesai sepenuhnya, pengajuan proposal telah disetujui..."'),
            _buildStudiLanjutTimeline('02', 'Semester Genap 2026', '20 Jun 2026', '3.95', '"Implementasi awal algoritma Shor telah menunjukkan hasil yang menjanjikan..."', color: const Color(0xFFFDECD4), textColor: const Color(0xFFD94B2B)),
          ],
        );

      default:
        return Container();
    }
  }

  Widget _buildStudiLanjutTimeline(String no, String title, String date, String ipk, String note, {Color color = const Color(0xFFE8F0FE), Color textColor = const Color(0xFF1550B0)}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(no, style: AppTextStyles.heading3.copyWith(color: textColor))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title, style: AppTextStyles.subtitle2, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                      child: Text('IPK: $ipk', style: AppTextStyles.caption.copyWith(color: textColor, fontWeight: FontWeight.bold, fontSize: 9)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Dilaporkan: $date', style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
                const SizedBox(height: 8),
                Text(note, style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
        ],
      ),
    );
  }

  Widget _buildDetailCol(String label, String value, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500), textAlign: alignRight ? TextAlign.right : TextAlign.left),
      ],
    );
  }
}

