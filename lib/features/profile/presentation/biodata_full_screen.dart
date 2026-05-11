import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/profile_provider.dart';
import '../domain/profile_model.dart';
import 'package:intl/intl.dart';

class BiodataFullScreen extends ConsumerWidget {
  const BiodataFullScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white), onPressed: () => context.pop()),
        title: const Text('Biodata Diri', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1550B0),
        elevation: 0,
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) return const EmptyState(title: 'Profil tidak ditemukan');
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(profile),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('IDENTITAS DASAR'),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('NAMA LENGKAP', profile.fullName)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('NIP', profile.nip)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('KTP', profile.ktp ?? '-')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('NIDN', profile.nidn ?? '-')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('NIDN', profile.nidn ?? '-')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('NUPTK', '1234567890123456')), // Mock
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard('NAMA IBU KANDUNG', 'SITI AMINAH', fullWidth: true), // Mock
                      
                      const SizedBox(height: 24),
                      _buildSectionTitle('PERSONAL & KELAHIRAN'),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('TEMPAT LAHIR', profile.birthPlace?.toUpperCase() ?? '-')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('TANGGAL LAHIR', profile.birthDate != null ? DateFormat('dd MMMM yyyy').format(profile.birthDate!) : '-')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('JENIS KELAMIN', profile.gender ?? '-')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('AGAMA', profile.religion ?? '-')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard('PENDIDIKAN TERAKHIR', 'S3 - Teknik Informatika', fullWidth: true), // Mock

                      const SizedBox(height: 24),
                      _buildSectionTitle('KONTAK & DIGITAL'),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('WHATSAPP', profile.phone ?? '-')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('INTERNAL EMAIL', profile.email ?? '-', textColor: const Color(0xFF1550B0))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard('PERSONAL EMAIL', profile.email ?? '-', fullWidth: true), // Mock
                      
                      const SizedBox(height: 24),
                      _buildSectionTitle('DOMISILI'),
                      _buildInfoCard('ALAMAT KTP', profile.address ?? '-', fullWidth: true),
                      const SizedBox(height: 12),
                      _buildInfoCard('DOMISILI SEKARANG', 'Perumahan Villa Bukit Tidar Blok A2-11, Lowokwaru, Malang', fullWidth: true), // Mock

                      const SizedBox(height: 24),
                      _buildSectionTitle('STATUS & AKADEMIK'),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('STATUS', profile.statusKepegawaian ?? '-')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('UNIT', profile.unitKerja ?? '-')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('JAB. AKADEMIK', profile.jabatanAkademik ?? '-')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('JAB. STRUKTURAL', profile.position ?? '-')),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      _buildSectionTitle('KEPAKARAN'),
                      _buildInfoCard('KEPAKARAN / MINAT RISET', 'Software Development, Software Security', fullWidth: true), // Mock
                      
                      const SizedBox(height: 24),
                      _buildSectionTitle('SERDOS ACCESS'),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('USER', 'aditya_serdos')),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border.withValues(alpha: 0.5))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('PASS', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, letterSpacing: 0.5)),
                                      const SizedBox(height: 4),
                                      Text('••••••••', style: AppTextStyles.subtitle2),
                                    ],
                                  ),
                                  const Icon(Icons.visibility_outlined, color: AppColors.textSecondary, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(message: e.toString()),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileModel profile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1550B0),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.primarySurface,
                  ),
                  child: const Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
                Positioned(
                  bottom: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1550B0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('VERIFIED', style: AppTextStyles.chipText.copyWith(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
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
                    decoration: BoxDecoration(
                      color: AppColors.scaffoldBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.badge_outlined, color: AppColors.textSecondary, size: 12),
                        const SizedBox(width: 4),
                        Text('${profile.displayIdLabel}: ${profile.displayId}', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${profile.statusKepegawaian ?? "Pegawai"} • ${profile.department ?? ""}', 
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
    );
  }

  Widget _buildInfoCard(String label, String value, {bool fullWidth = false, Color textColor = AppColors.textPrimary}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.subtitle2.copyWith(color: textColor)),
        ],
      ),
    );
  }
}
