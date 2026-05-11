import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/obe_provider.dart';
import '../domain/obe_kinerja_model.dart';

class ObeKinerjaDetailScreen extends ConsumerWidget {
  final String courseId;
  final String classId;

  const ObeKinerjaDetailScreen({super.key, required this.courseId, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kinerjaAsync = ref.watch(obeKinerjaDetailProvider(classId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Detail Kinerja Dosen'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: kinerjaAsync.when(
        data: (kinerja) => SingleChildScrollView(
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
                          child: Text('${kinerja.sks} SKS', style: AppTextStyles.caption.copyWith(color: const Color(0xFF2C5BA1), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(kinerja.courseName, style: AppTextStyles.heading2.copyWith(color: Colors.white)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.groups_outlined, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text(kinerja.className, style: AppTextStyles.caption.copyWith(color: Colors.white)),
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

              // PERENCANAAN
              _buildSectionHeader(Icons.assignment, 'PERENCANAAN'),
              const SizedBox(height: 16),
              ...kinerja.cpls.map((cpl) => _buildCplCard(cpl)),
              ...kinerja.cpmks.map((cpmk) => _buildCpmkCard(cpmk)),
              _buildRpsStatusCard(kinerja.rpsTidakLengkap),
              const SizedBox(height: 24),

              // PELAKSANAAN
              _buildSectionHeader(Icons.play_circle_outline, 'PELAKSANAAN'),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTabButton('Kelas A', true),
                  _buildTabButton('Kelas B', false),
                  _buildTabButton('Kelas C', false),
                  _buildTabButton('Kelas D', false),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildPelaksanaanStat('PRESENSI MHS', '${kinerja.presensiMhs}%')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildPelaksanaanStat('PRESENSI DOSEN', '${kinerja.presensiDosen}%')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildPelaksanaanStat('KESESUAIAN RPS', '${kinerja.kesesuaianRps}%')),
                ],
              ),
              const SizedBox(height: 24),

              // EVALUASI
              _buildSectionHeader(Icons.bar_chart, 'EVALUASI'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CAPAIAN INDEKS PRESTASI', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${kinerja.capaianIndeksPrestasi}', style: AppTextStyles.heading1.copyWith(color: const Color(0xFF1550B0), fontSize: 32, height: 1.0)),
                                Text(' / Target ${kinerja.targetIndeksPrestasi}', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF1550B0), width: 3),
                          ),
                          child: Center(
                            child: Text('0%', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 10)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ['No', 'Kelas', 'Mhs', 'A', 'B+', 'B', 'C+', 'C', 'D', 'E', 'X']
                                .map((t) => Text(t, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 10))).toList(),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('F', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontSize: 10)),
                              Text('46', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontSize: 10)),
                              ...['0', '0', '0', '0', '0', '0', '0', '0', '0'].map((t) => Text(t, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontSize: 10))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // PENGENDALIAN
              _buildSectionHeader(Icons.settings_outlined, 'PENGENDALIAN'),
              const SizedBox(height: 16),
              _buildTextCard(kinerja.pengendalian),
              const SizedBox(height: 24),

              // PENINGKATAN
              _buildSectionHeader(Icons.trending_up, 'PENINGKATAN'),
              const SizedBox(height: 16),
              _buildTextCard(kinerja.peningkatan),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF2C5BA1)),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF2C5BA1), letterSpacing: 1.0)),
      ],
    );
  }

  Widget _buildCplCard(ObeKinerjaCpl cpl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF2C5BA1),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(11), bottomRight: Radius.circular(12)),
            ),
            child: Text(cpl.code, style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(cpl.description, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildCpmkCard(ObeKinerjaCpmk cpmk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, color: const Color(0xFF2C5BA1)),
              const SizedBox(width: 8),
              Text(cpmk.code, style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF2C5BA1))),
            ],
          ),
          const SizedBox(height: 12),
          Text(cpmk.description, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ...cpmk.subCpmks.map((sub) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sub.code, style: AppTextStyles.caption.copyWith(color: const Color(0xFF2C5BA1), fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(child: Text(sub.description, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRpsStatusCard(List<String> tidakLengkap) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD94B2B).withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Color(0xFFD94B2B)),
              const SizedBox(width: 8),
              Text('RPS (STATUS TIDAK LENGKAP)', style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFFD94B2B))),
            ],
          ),
          const SizedBox(height: 12),
          ...tidakLengkap.map((item) => Text(item, style: AppTextStyles.caption.copyWith(color: const Color(0xFFD94B2B)))),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1550B0) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? null : Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text(text, style: AppTextStyles.caption.copyWith(color: isSelected ? Colors.white : const Color(0xFF1550B0), fontWeight: FontWeight.bold, fontSize: 10)),
        ),
      ),
    );
  }

  Widget _buildPelaksanaanStat(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 8, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.subtitle1.copyWith(color: const Color(0xFF1550B0))),
          const SizedBox(height: 8),
          Container(
            height: 4, width: 40,
            decoration: BoxDecoration(color: const Color(0xFF1550B0), borderRadius: BorderRadius.circular(2)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Text(text, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, height: 1.5)),
    );
  }
}
