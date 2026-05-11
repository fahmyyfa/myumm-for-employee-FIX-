import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/app_card.dart';
import '../providers/schedule_provider.dart';

class ScheduleDetailScreen extends ConsumerWidget {
  final String scheduleId;
  const ScheduleDetailScreen({super.key, required this.scheduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(schedulesProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Detail Jadwal Kuliah'),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppHeaderSmall(
              subtitle: 'Jadwal Perkuliahan',
              title: 'Kelola Jadwal\nMengajar Anda',
              tags: [Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 26))],
            ),
          ),
          const SizedBox(height: 12),
          // Filters row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _FilterChip(label: 'TAHUN AKADEMIK: 2023/2024'),
              const SizedBox(width: 8),
              _FilterChip(label: 'SEMESTER: GANJIL'),
            ]),
          ),
          const SizedBox(height: 16),
          // Schedule cards
          schedulesAsync.when(
            data: (schedules) => ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: schedules.length > 3 ? 3 : schedules.length,
              itemBuilder: (context, i) {
                final s = schedules[i];
                return AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
                        child: Text((i + 1).toString().padLeft(2, '0'),
                          style: AppTextStyles.chipText.copyWith(color: AppColors.primary)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text('${s.programStudi.toUpperCase()} - ${s.className.toUpperCase()}',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, letterSpacing: 0.5))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
                        child: Text('${s.sks} SKS', style: AppTextStyles.chipText.copyWith(color: AppColors.primary)),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Text(s.courseName, style: AppTextStyles.subtitle2),
                    const SizedBox(height: 8),
                    _InfoRow(Icons.person_outline, 'Dr. Eng. Muhammad Arifin, S.T., M.Sc.'),
                    _InfoRow(Icons.location_on_outlined, s.fullLocation),
                    _InfoRow(Icons.access_time, '${s.day}, ${s.scheduleTime}'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => context.push('/attendance/${s.id}'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(20)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.check_circle, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text('Ceklist', style: AppTextStyles.chipText.copyWith(color: Colors.white)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                        ]),
                      ),
                    ),
                  ]),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
          ),
          const SizedBox(height: 16),
          Center(child: OutlinedButton(onPressed: () {}, child: const Text('LIHAT DETAIL'))),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(width: 4),
        const Icon(Icons.expand_more, size: 16, color: AppColors.textSecondary),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String text;
  const _InfoRow(this.icon, this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Flexible(child: Text(text, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}
