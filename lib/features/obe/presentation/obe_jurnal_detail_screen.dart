import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../providers/obe_provider.dart';
import '../domain/obe_jurnal_model.dart';

class ObeJurnalDetailScreen extends ConsumerWidget {
  final String courseId;
  final String classId;

  const ObeJurnalDetailScreen({super.key, required this.courseId, required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jurnalAsync = ref.watch(obeJurnalDetailProvider(classId));

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Detail Jurnal Mengajar'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                        child: Text('3 SKS', style: AppTextStyles.caption.copyWith(color: const Color(0xFF2C5BA1), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Pemrograman Mobile', style: AppTextStyles.heading2.copyWith(color: Colors.white)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.groups_outlined, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text('Kelas A', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                      const SizedBox(width: 24),
                      const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 14),
                      const SizedBox(width: 8),
                      Text('TA 2025/2026', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pertemuan Count Card
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
                    children: [
                      const Icon(Icons.stop, color: Colors.white, size: 12),
                      const SizedBox(width: 8),
                      Text('JUMLAH PERTEMUAN', style: AppTextStyles.chipText.copyWith(color: Colors.white, letterSpacing: 1.0)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('16', style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 40, height: 1.0)),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('Pertemuan', style: AppTextStyles.subtitle1.copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('RIWAYAT JURNAL MENGAJAR', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),

            // Jurnal List
            jurnalAsync.when(
              data: (jurnals) => Column(
                children: [
                  ...jurnals.asMap().entries.map((entry) => _buildJurnalCard(entry.key + 1, entry.value)),
                  const SizedBox(height: 16),
                  SizedBox(
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
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJurnalCard(int index, ObeJurnalItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Row for P1 and Ref
          Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F82F7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('P$index', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                ),
                const SizedBox(width: 8),
                Text(item.refId, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 10)),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textPrimary),
                          const SizedBox(width: 8),
                          Text(item.date, style: AppTextStyles.subtitle2),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(item.time, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.domain, size: 14, color: AppColors.textPrimary),
                    const SizedBox(width: 8),
                    Text(item.room, style: AppTextStyles.subtitle2),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.menu_book, size: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.topic, style: AppTextStyles.subtitle2),
                      const SizedBox(height: 4),
                      Text(item.subTopic, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5EF),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFF1A9A5B).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: Color(0xFF1A9A5B)),
                          const SizedBox(width: 4),
                          Text('${item.presentCount} HADIR', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1A9A5B), fontSize: 8, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFECE5),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFD94B2B).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: Color(0xFFD94B2B)),
                          const SizedBox(width: 4),
                          Text('${item.absentCount} HADIR', style: AppTextStyles.caption.copyWith(color: const Color(0xFFD94B2B), fontSize: 8, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Left accent border logic: add a blue bar on the left edge
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF3F82F7),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
