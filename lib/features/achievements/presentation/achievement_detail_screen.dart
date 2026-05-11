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
import '../../profile/providers/profile_provider.dart';
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
    final profileAsync = ref.watch(profileProvider);
    
    // Page title logic
    final pageTitle = (category == 'Kegiatan Ilmiah') ? 'Detail Capaian' : 'Detail Riwayat';
    final sectionTitle = 'RIWAYAT ${category.toUpperCase()}';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark background matching the screenshot
      body: Column(
        children: [
          const SizedBox(height: 40), // Spacer for OS status bar or aesthetic
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Custom Header inside the white area
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, size: 22, color: AppColors.textPrimary),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        Text(
                          pageTitle,
                          style: AppTextStyles.subtitle1.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: profileAsync.when(
                      data: (profile) {
                        if (profile == null) return const Center(child: Text('Profile tidak ditemukan'));
                        
                        return achievementsAsync.when(
                          data: (allAchievements) {
                            final items = allAchievements.where((a) => a.category == category).toList();
                            
                            return SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildProfileHeader(profile),
                                  const SizedBox(height: 32),
                                  Text(sectionTitle, style: AppTextStyles.chipText.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2, fontWeight: FontWeight.w800, fontSize: 11)),
                                  const SizedBox(height: 20),
                                  if (items.isEmpty)
                                    _buildEmptyState()
                                  else
                                    ...items.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      return _buildItemCard(category, index, item);
                                    }),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            );
                          },
                          loading: () => const Padding(padding: EdgeInsets.all(24), child: ShimmerList()),
                          error: (e, _) => Center(child: Text('Kesalahan: $e')),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1550B0))),
                      error: (e, _) => Center(child: Text(e.toString())),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(60),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey.shade200),
          const SizedBox(height: 24),
          Text(
            'Belum ada riwayat',
            style: AppTextStyles.subtitle1.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfileModel profile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 15)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(profile.fullName, style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.textPrimary)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1550B0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('VERIFIED', style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.badge_outlined, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      Text('NIP: ${profile.nip}', style: AppTextStyles.caption.copyWith(color: const Color(0xFF64748B), fontWeight: FontWeight.w800, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('Dosen Tetap • Teknik Informatika', style: AppTextStyles.caption.copyWith(color: AppColors.textHint, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(String category, int index, AchievementModel item) {
    final df = DateFormat('dd MMMM yyyy', 'id');
    final dateStr = item.createdAt != null ? df.format(item.createdAt!) : '-';
    final dfShort = DateFormat('dd/MM/yyyy');
    final dateShortStr = item.createdAt != null ? dfShort.format(item.createdAt!) : '-';

    switch (category) {
      case 'Kegiatan Ilmiah':
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1550B0),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFF0F5FF), borderRadius: BorderRadius.circular(8)),
                              child: Text('NO. ${(index + 1).toString().padLeft(2, '0')}', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.w900, fontSize: 10)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFF0F5FF), borderRadius: BorderRadius.circular(8)),
                              child: Text('JURNAL INTERNASIONAL', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.w900, fontSize: 10)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(item.title, style: AppTextStyles.subtitle1.copyWith(fontSize: 16, fontWeight: FontWeight.w800, height: 1.4, color: AppColors.textPrimary)),
                        const SizedBox(height: 20),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildDetailCol('TINGKAT', 'Global/Q1')),
                            Expanded(child: _buildDetailCol('KEDUDUKAN', 'Penulis Utama')),
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
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1550B0),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
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
                                  Text('JENIS AKTIFITAS', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, fontSize: 9, fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text('AKTIFITAS 1', style: AppTextStyles.subtitle1.copyWith(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                  const SizedBox(height: 16),
                                  Text('NAMA AKTIFITAS', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, fontSize: 9, fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 4),
                                  Text(item.title, style: AppTextStyles.subtitle1.copyWith(fontSize: 16, color: const Color(0xFF1550B0), fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                            Container(
                              width: 40, height: 40,
                              decoration: const BoxDecoration(color: Color(0xFFF0F5FF), shape: BoxShape.circle),
                              child: Center(child: Text('${index + 1}', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.w900, fontSize: 16))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildDetailCol('KEDUDUKAN', 'Kedudukan 1')),
                            Expanded(child: _buildDetailCol('TANGGAL', '01 Januari 2023')),
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
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(color: const Color(0xFFF0F5FF), borderRadius: BorderRadius.circular(16)),
                    child: Center(child: Text('${index + 1}', style: AppTextStyles.heading3.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.w900))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NAMA PELATIHAN', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, fontSize: 9, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(item.title, style: AppTextStyles.subtitle1.copyWith(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFF0F5FF), borderRadius: BorderRadius.circular(10)),
                    child: Text('Pelatihan', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.w900, fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(child: _buildDetailCol('PENYELENGGARA', 'Penyelenggara 1')),
                  Expanded(child: _buildDetailCol('TINGKAT', 'Nasional')),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildDetailCol('TANGGAL MULAI', '01 Januari 2026')),
                  Expanded(child: _buildDetailCol('TANGGAL SELESAI', '31 Januari 2026')),
                ],
              ),
            ],
          ),
        );

      case 'Studi Lanjut':
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 25, offset: const Offset(0, 10))],
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
                            Text('JENJANG & INSTITUSI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, fontSize: 10, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text('Doktoral (S3)', style: AppTextStyles.heading2.copyWith(color: const Color(0xFF1550B0), fontSize: 28, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                            Text('University of Oxford', style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w800, fontSize: 22, color: AppColors.textPrimary)),
                            const SizedBox(height: 18),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFF0F5FF), borderRadius: BorderRadius.circular(10)),
                              child: Text('United Kingdom', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.w900, fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 64, height: 64,
                        decoration: const BoxDecoration(color: Color(0xFFF0F5FF), shape: BoxShape.circle),
                        child: const Center(child: Icon(Icons.workspace_premium, color: Color(0xFF1550B0), size: 36)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 28),
                  Text('PROGRAM STUDI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, fontSize: 10, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('Ilmu Komputer', style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.textPrimary)),
                  const SizedBox(height: 24),
                  Text('TGL. AWAL S/D TGL. AKHIR', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, fontSize: 10, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('9 Januari 2027 s/d 21 Juni 2030', style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.textPrimary)),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.timer_outlined, color: Color(0xFF1550B0), size: 36),
                        const SizedBox(height: 16),
                        Text('LAMA STUDI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, fontSize: 11, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text('0 Th / 8 Bl / 9 Hr', style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1550B0),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: const Color(0xFF1550B0).withValues(alpha: 0.2), blurRadius: 20)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.payments_outlined, color: Colors.white, size: 36),
                        const SizedBox(height: 16),
                        Text('SUMBER BIAYA', style: AppTextStyles.chipText.copyWith(color: Colors.white.withValues(alpha: 0.7), fontSize: 11, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text('Beasiswa LPDP', style: AppTextStyles.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RIWAYAT LAPORAN', style: AppTextStyles.subtitle2.copyWith(fontSize: 13, letterSpacing: 1.2, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                Text('LIHAT SEMUA', style: AppTextStyles.subtitle2.copyWith(fontSize: 13, color: const Color(0xFF1550B0), letterSpacing: 1.2, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 28),
            _buildStudiLanjutTimeline('01', 'Semester Ganjil 2026', '14 Des 2026', '3.92', '"Penelitian bab 1 selesai sepenuhnya, pengajuan proposal telah disetujui oleh supervisor utama di Oxford. Saat ini sedang melakukan studi literatur mendalam terkait algoritma kuantum terbaru."'),
            _buildStudiLanjutTimeline('02', 'Semester Genap 2026', '20 Jun 2026', '3.95', '"Implementasi awal algoritma Shor telah menunjukkan hasil yang menjanjikan pada simulator 5-qubit. Draft publikasi jurnal Q1 sedang dalam tahap penulisan dan review internal."', color: const Color(0xFFFFF1F0), textColor: const Color(0xFFD94B2B)),
          ],
        );

      default:
        return Container();
    }
  }

  Widget _buildStudiLanjutTimeline(String no, String title, String date, String ipk, String note, {Color color = const Color(0xFFF0F5FF), Color textColor = const Color(0xFF1550B0)}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(no, style: AppTextStyles.heading3.copyWith(color: textColor, fontWeight: FontWeight.w900))),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title, style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                      child: Text('IPK: $ipk', style: AppTextStyles.caption.copyWith(color: textColor, fontWeight: FontWeight.w900, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Dilaporkan: $date', style: AppTextStyles.caption.copyWith(color: AppColors.textHint, fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 14),
                Text(note, style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary, height: 1.6, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 28),
        ],
      ),
    );
  }

  Widget _buildDetailCol(String label, String value, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 13), textAlign: alignRight ? TextAlign.right : TextAlign.left),
      ],
    );
  }
}

