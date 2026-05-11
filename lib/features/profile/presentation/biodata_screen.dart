import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/profile_provider.dart';
import '../domain/profile_model.dart';
import '../domain/family_member_model.dart';

class BiodataScreen extends ConsumerWidget {
  const BiodataScreen({super.key});

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
                      // Ringkasan Biodata
                      Row(
                        children: [
                          Text('RINGKASAN BIODATA', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
                          const SizedBox(width: 8),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.2,
                        children: [
                          _buildSummaryCard(Icons.person_outline, 'Nama Lengkap', profile.fullName),
                          _buildSummaryCard(Icons.badge_outlined, 'NIP', profile.nip),
                          _buildSummaryCard(Icons.credit_card_outlined, 'KTP', profile.ktp ?? '-'),
                          _buildSummaryCard(Icons.work_outline, 'Status Kepegawaian', profile.statusKepegawaian ?? '-'),
                          _buildSummaryCard(Icons.cases_outlined, 'Status Kerja', profile.statusKerja ?? '-'),
                          _buildSummaryCard(Icons.domain, 'Unit Kerja', profile.unitKerja ?? '-'),
                          _buildSummaryCard(Icons.access_time, 'Masa Kerja', profile.masaKerja),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => context.push('/profile/biodata/full'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFF1550B0), width: 0.5),
                            backgroundColor: AppColors.primarySurface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.visibility_outlined, color: Color(0xFF1550B0), size: 16),
                              const SizedBox(width: 8),
                              Text('VIEW ALL', style: AppTextStyles.button.copyWith(color: const Color(0xFF1550B0), fontSize: 10, letterSpacing: 1.0)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Data Pegawai
                      Row(
                        children: [
                          Text('DATA PEGAWAI', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0)),
                          const SizedBox(width: 8),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildAccordion(
                        icon: Icons.school_outlined,
                        title: 'Jabatan Akademik',
                        isExpanded: false,
                        children: [], // Add content as needed
                      ),
                      const SizedBox(height: 12),
                      _buildAccordion(
                        icon: Icons.account_tree_outlined,
                        title: 'Jabatan Struktural',
                        isExpanded: true,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(flex: 1, child: Text('NO.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold))),
                                    Expanded(flex: 3, child: Text('JABATAN', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold))),
                                    Expanded(flex: 3, child: Text('UNIT', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold))),
                                    Expanded(flex: 3, child: Text('NO. SK', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold))),
                                    Expanded(flex: 3, child: Text('TANGGAL AWAL', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold))),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(height: 1),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(flex: 1, child: Text('1', style: AppTextStyles.caption.copyWith(fontSize: 8))),
                                    Expanded(flex: 3, child: Text('Lead Data Architect', style: AppTextStyles.caption.copyWith(fontSize: 8, fontWeight: FontWeight.bold))),
                                    Expanded(flex: 3, child: Text('Engineering Div', style: AppTextStyles.caption.copyWith(fontSize: 8))),
                                    Expanded(flex: 3, child: Text('SK/2022/08/142', style: AppTextStyles.caption.copyWith(fontSize: 8))),
                                    Expanded(flex: 3, child: Text('01 Jan 2022', style: AppTextStyles.caption.copyWith(fontSize: 8))),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(flex: 1, child: Text('2', style: AppTextStyles.caption.copyWith(fontSize: 8))),
                                    Expanded(flex: 3, child: Text('Senior Analyst', style: AppTextStyles.caption.copyWith(fontSize: 8, fontWeight: FontWeight.bold))),
                                    Expanded(flex: 3, child: Text('Tech Ops', style: AppTextStyles.caption.copyWith(fontSize: 8))),
                                    Expanded(flex: 3, child: Text('SK/2020/03/011', style: AppTextStyles.caption.copyWith(fontSize: 8))),
                                    Expanded(flex: 3, child: Text('15 Mar 2020', style: AppTextStyles.caption.copyWith(fontSize: 8))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildAccordion(
                        icon: Icons.family_restroom,
                        title: 'Data Keluarga',
                        isExpanded: false,
                        children: [], // Could embed family tab here
                      ),
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

  Widget _buildSummaryCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(child: Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 9))),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.subtitle2.copyWith(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildAccordion({required IconData icon, required String title, required bool isExpanded, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C5BA1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(title, style: AppTextStyles.subtitle2.copyWith(color: Colors.white)),
            ],
          ),
          children: children,
        ),
      ),
    );
  }
}
