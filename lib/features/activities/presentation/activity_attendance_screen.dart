import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/activity_attendance_provider.dart';
import '../domain/activity_attendance_model.dart';

class ActivityAttendanceScreen extends ConsumerWidget {
  const ActivityAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final activitiesAsync = ref.watch(activityAttendanceProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Detail Kegiatan'),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            profileAsync.when(
              data: (profile) => _buildProfileCard(profile),
              loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 16),
            
            // Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1550B0),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1550B0).withValues(alpha: 0.3),
                    blurRadius: 10, offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(width: 4, height: 16, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 8),
                  Text('JUMLAH KEGIATAN DIIKUTI', style: AppTextStyles.labelSmall.copyWith(color: Colors.white, letterSpacing: 1.0)),
                  const Spacer(),
                  activitiesAsync.when(
                    data: (activities) => Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${activities.length}', style: AppTextStyles.heading1.copyWith(color: Colors.white, height: 1.0)),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('kegiatan', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                    loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                    error: (_, __) => Text('0', style: AppTextStyles.heading1.copyWith(color: Colors.white, height: 1.0)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // List Title
            Text('RIWAYAT KEGIATAN', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
            const SizedBox(height: 4),
            const Divider(),
            const SizedBox(height: 16),
            
            // List View
            activitiesAsync.when(
              data: (activities) => Column(
                children: [
                  ...activities.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final item = entry.value;
                    return _buildActivityCard(index, item);
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildProfileCard(profile) {
    if (profile == null) return const SizedBox();
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(profile.fullName, style: AppTextStyles.subtitle1.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1550B0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('VERIFIED', style: AppTextStyles.chipText.copyWith(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.badge_outlined, color: AppColors.textSecondary, size: 14),
                const SizedBox(width: 6),
                Text('${profile.displayIdLabel}: ${profile.displayId}', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text('${profile.statusKepegawaian ?? "Pegawai"} • ${profile.department ?? ""}', 
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 12),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(int index, ActivityAttendanceModel item) {
    final dfDate = DateFormat('dd-MM-yyyy');
    final dfTime = DateFormat('dd-MM-yy, HH:mm:ss');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4, offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blue left border indicator
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF1550B0),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
            ),
            const SizedBox(width: 16),
            // Index Circle
            Center(
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(index.toString().padLeft(2, '0'), style: AppTextStyles.subtitle2.copyWith(color: AppColors.primary)),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1550B0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(item.status, style: AppTextStyles.chipText.copyWith(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Text(item.title, style: AppTextStyles.subtitle2),
                    const SizedBox(height: 2),
                    Text(item.category, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TANGGAL', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                              const SizedBox(height: 2),
                              Text(dfDate.format(item.date), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('WAKTU HADIR', style: AppTextStyles.chipText.copyWith(color: AppColors.textHint, letterSpacing: 0.5)),
                              const SizedBox(height: 2),
                              Text(dfTime.format(item.checkInTime), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
