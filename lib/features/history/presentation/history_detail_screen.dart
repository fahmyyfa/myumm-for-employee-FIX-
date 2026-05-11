import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/history_provider.dart';
import '../domain/history_models.dart';
import '../../profile/providers/profile_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/domain/profile_model.dart';

class HistoryDetailScreen extends ConsumerWidget {
  final String category;
  const HistoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(historyCategoryProvider(category));
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Detail Riwayat'),
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) return const Center(child: Text('Profile tidak ditemukan'));
          
          return itemsAsync.when(
            data: (items) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(profile),
                    const SizedBox(height: 24),
                    
                    _buildDynamicContent(category, items),
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

  Widget _buildDynamicContent(String category, List<EmploymentHistoryModel> items) {
    if (category == 'Organisasi' || category == 'Kepanitiaan' || category == 'Prestasi') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(
            category == 'Organisasi' ? 'JUMLAH ORGANISASI DIIKUTI' : (category == 'Prestasi' ? 'JUMLAH PRESTASI' : 'JUMLAH KEPANITIAAN DIIKUTI'),
            items.length.toString(),
            category == 'Organisasi' ? 'Organisasi' : (category == 'Prestasi' ? 'Prestasi' : 'Kepanitiaan'),
          ),
          const SizedBox(height: 24),
          Text('RIWAYAT ${category.toUpperCase()}', style: AppTextStyles.chipText.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
          const SizedBox(height: 16),
          if (items.isEmpty) const EmptyState(title: 'Belum ada data', subtitle: 'Data masih kosong.')
          else ...items.asMap().entries.map((e) {
            if (category == 'Organisasi') return _buildOrganisasiCard(e.key, e.value);
            if (category == 'Prestasi') return _buildPrestasiCard(e.key, e.value);
            return _buildKepanitiaanCard(e.key, e.value);
          }),
          const SizedBox(height: 16),
          _buildDetailButton(),
        ],
      );
    }

    String sectionTitle = 'RIWAYAT ${category.toUpperCase()}';
    if (category == 'Kerja di UMM') sectionTitle = 'RIWAYAT KERJA';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionTitle, style: AppTextStyles.chipText.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
        const SizedBox(height: 16),
        if (items.isEmpty) const EmptyState(title: 'Belum ada data', subtitle: 'Data masih kosong.')
        else ...items.asMap().entries.map((e) {
          if (category == 'Aktifasi') return _buildAktifasiCard(e.key, e.value);
          if (category == 'Kepangkatan') return _buildKepangkatanCard(e.key, e.value);
          if (category == 'Kerja di UMM') return _buildKerjaCard(e.key, e.value);
          if (category == 'Pendidikan') return _buildPendidikanCard(e.key, e.value);
          return _buildGenericCard(e.key, e.value);
        }),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String count, String subtitle) {
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
            children: [
              Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(2)))),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.chipText.copyWith(color: Colors.white.withValues(alpha: 0.8), letterSpacing: 1.0)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(count, style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 36, height: 1.0)),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(subtitle, style: AppTextStyles.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.normal)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
        ),
        child: Text('LIHAT DETAIL', style: AppTextStyles.button.copyWith(color: const Color(0xFF1550B0))),
      ),
    );
  }

  // ACTIFASI
  Widget _buildAktifasiCard(int index, EmploymentHistoryModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STATUS AKTIVITAS', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                    child: Text(item.status ?? 'Aktif', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ],
              ),
              Container(
                width: 32, height: 32,
                decoration: const BoxDecoration(color: Color(0xFFE2E8F0), shape: BoxShape.circle),
                child: Center(child: Text('${index + 1}', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF334155)))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('KETERANGAN', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(item.title, style: AppTextStyles.subtitle2),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildCol('TANGGAL MULAI', item.startDate != null ? DateFormat('dd-MM-yyyy').format(item.startDate!) : '-')),
              Expanded(child: _buildCol('TANGGAL SELESAI', item.endDate != null ? DateFormat('dd-MM-yyyy').format(item.endDate!) : '-')),
            ],
          ),
          const SizedBox(height: 16),
          Text('NO. SURAT', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text('SK/2023/X.01-IV', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  // KEPANGKATAN
  Widget _buildKepangkatanCard(int index, EmploymentHistoryModel item) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(width: 16, height: 16, decoration: BoxDecoration(color: index == 0 ? const Color(0xFF1550B0) : const Color(0xFF94A3B8), shape: BoxShape.circle, border: Border.all(color: index == 0 ? const Color(0xFFE8F0FE) : const Color(0xFFE2E8F0), width: 4))),
              Expanded(child: Container(width: 1, color: AppColors.border)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STATUS KERJA', style: AppTextStyles.chipText.copyWith(color: const Color(0xFF1550B0), letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text((item.status ?? 'Karyawan Tetap').toUpperCase(), style: AppTextStyles.heading3),
                  const SizedBox(height: 16),
                  Text('PANGKAT', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(item.title.toUpperCase(), style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
                  const SizedBox(height: 12),
                  Text('NO. SK', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text('UMM/SK/ORG/2023/001-UI', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildCol('BERKALA', '06 - Berkala')),
                      Expanded(child: _buildCol('TMT', item.startDate != null ? DateFormat('dd-MM-yyyy').format(item.startDate!) : '-')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // KERJA DI UMM
  Widget _buildKerjaCard(int index, EmploymentHistoryModel item) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(width: 16, height: 16, decoration: BoxDecoration(color: index == 0 ? const Color(0xFF1550B0) : const Color(0xFF94A3B8), shape: BoxShape.circle, border: Border.all(color: index == 0 ? const Color(0xFFE8F0FE) : const Color(0xFFE2E8F0), width: 4))),
              Expanded(child: Container(width: 1, color: AppColors.border)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('POSISI JABATAN', style: AppTextStyles.chipText.copyWith(color: const Color(0xFF1550B0), letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(item.title.toUpperCase(), style: AppTextStyles.heading3),
                  const SizedBox(height: 16),
                  Text('UNIT KERJA', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(item.institution ?? '-', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
                  const SizedBox(height: 12),
                  Text('KLASIFIKASI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text('Tenaga Pendidik', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Text('NO. SK', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text('UMM/SK/ORG/2023/001-UI', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildCol('TANGGAL MULAI', item.startDate != null ? DateFormat('dd-MM-yyyy').format(item.startDate!) : '-')),
                      Expanded(child: _buildCol('TANGGAL SELESAI', item.endDate != null ? DateFormat('dd-MM-yyyy').format(item.endDate!) : '-')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ORGANISASI
  Widget _buildOrganisasiCard(int index, EmploymentHistoryModel item) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(width: 16, height: 16, decoration: BoxDecoration(color: index == 0 ? const Color(0xFF1550B0) : const Color(0xFF94A3B8), shape: BoxShape.circle, border: Border.all(color: index == 0 ? const Color(0xFFE8F0FE) : const Color(0xFFE2E8F0), width: 4))),
              Expanded(child: Container(width: 1, color: AppColors.border)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KEDUDUKAN', style: AppTextStyles.chipText.copyWith(color: const Color(0xFF1550B0), letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(item.title.toUpperCase(), style: AppTextStyles.heading3),
                  const SizedBox(height: 16),
                  Text('NAMA ORGANISASI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(item.institution ?? '-', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
                  const SizedBox(height: 12),
                  Text('NOMOR SURAT', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text('SK/ORG/2023/001-UI', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildCol('TANGGAL MULAI', item.startDate != null ? DateFormat('dd-MM-yyyy').format(item.startDate!) : '-')),
                      Expanded(child: _buildCol('TANGGAL SELESAI', item.endDate != null ? DateFormat('dd-MM-yyyy').format(item.endDate!) : '-')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildCol('PEMVALIDASI', 'Dr. Ir. Heru Santoso')),
                      Expanded(child: _buildCol('TGL VALIDASI', '05-01-2024')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // KEPANITIAAN
  Widget _buildKepanitiaanCard(int index, EmploymentHistoryModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
                width: 40, height: 40,
                decoration: const BoxDecoration(color: Color(0xFFE8F0FE), shape: BoxShape.circle),
                child: Center(child: Text((index + 1).toString().padLeft(2, '0'), style: AppTextStyles.subtitle1.copyWith(color: const Color(0xFF1550B0)))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: AppTextStyles.subtitle2),
                    const SizedBox(height: 4),
                    Text('NO. SK: 102/UN/SK/2023', style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
                  ],
                ),
              ),
              const Icon(Icons.verified, color: Color(0xFF1550B0), size: 20),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildCol('TINGKAT', 'Universitas')),
              Expanded(child: _buildCol('MASA KERJA', item.startDate != null ? DateFormat('dd MMM').format(item.startDate!) + ' - 30 Okt 2023' : '-', alignRight: true, valueColor: const Color(0xFF1550B0))),
            ],
          ),
        ],
      ),
    );
  }

  // PENDIDIKAN
  Widget _buildPendidikanCard(int index, EmploymentHistoryModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: const Color(0xFF0F3470), borderRadius: BorderRadius.circular(8)),
                          child: const Center(child: Icon(Icons.school, color: Colors.white, size: 24)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                                child: Text(item.title.contains('S3') ? 'S3 DOKTOR' : (item.title.contains('S2') ? 'S2 MAGISTER' : 'S1 SARJANA'), style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 8)),
                              ),
                              const SizedBox(height: 6),
                              Text(item.institution ?? '-', style: AppTextStyles.subtitle1.copyWith(fontSize: 16)),
                            ],
                          ),
                        ),
                        const Icon(Icons.verified, color: Color(0xFF1550B0), size: 20),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.account_tree_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item.title, style: AppTextStyles.subtitle2.copyWith(color: AppColors.textSecondary))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.event_available_outlined, size: 14, color: Color(0xFF1550B0)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildCol('LULUSAN', item.endDate != null ? item.endDate!.year.toString() : '-')),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.receipt_long_outlined, size: 14, color: Color(0xFF1550B0)),
                              const SizedBox(width: 6),
                              Expanded(child: _buildCol('TANGGAL IJAZAH', item.endDate != null ? DateFormat('dd MMMM yyyy').format(item.endDate!) : '-')),
                            ],
                          ),
                        ),
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
  }

  // PRESTASI
  Widget _buildPrestasiCard(int index, EmploymentHistoryModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                color: Color(0xFF3F82F7), // Lighter blue for Prestasi
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                              Text('PENGHARGAAN/PRESTASI', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                              const SizedBox(height: 4),
                              Text(item.title.toUpperCase(), style: AppTextStyles.subtitle2),
                            ],
                          ),
                        ),
                        Container(
                          width: 32, height: 32,
                          decoration: const BoxDecoration(color: Color(0xFFE8F0FE), shape: BoxShape.circle),
                          child: Center(child: Text('${index + 1}', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF3F82F7)))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildCol('KATEGORI', 'Kategori 1')),
                        Expanded(child: _buildCol('TINGKAT', 'Nasional')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCol('TANGGAL PENGHARGAAN', item.startDate != null ? DateFormat('dd MMM yyyy').format(item.startDate!) : '-'),
                    const SizedBox(height: 16),
                    Text('NO. SURAT', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.description_outlined, size: 14, color: Color(0xFF1550B0)),
                        const SizedBox(width: 6),
                        Text('UMM/SK/2023/X.01-IV', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
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
  }

  Widget _buildGenericCard(int index, EmploymentHistoryModel item) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text('${index + 1}', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)))),
          const SizedBox(width: 12),
          Expanded(child: Text(item.title, style: AppTextStyles.labelLarge)),
        ]),
        if (item.institution != null) ...[
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.business_outlined, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(item.institution!, style: AppTextStyles.bodySmall),
          ]),
        ],
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(item.dateRange, style: AppTextStyles.bodySmall),
          const Spacer(),
          if (item.status != null) Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: item.status == 'Aktif' ? AppColors.successLight : AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12)),
            child: Text(item.status!, style: AppTextStyles.chipText.copyWith(
              color: item.status == 'Aktif' ? AppColors.success : AppColors.primary, fontSize: 11)),
          ),
        ]),
      ]),
    );
  }

  Widget _buildCol(String label, String value, {bool alignRight = false, Color? valueColor}) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.caption.copyWith(color: valueColor ?? AppColors.textPrimary, fontWeight: FontWeight.w600), textAlign: alignRight ? TextAlign.right : TextAlign.left),
      ],
    );
  }
}
