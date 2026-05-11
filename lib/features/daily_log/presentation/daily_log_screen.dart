import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/daily_log_provider.dart';

class DailyLogScreen extends ConsumerWidget {
  const DailyLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(dailyLogsProvider);
    final df = DateFormat('dd MMMM yyyy');

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Catatan Harian'),
      ),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const EmptyState(title: 'Belum ada catatan hari ini',
              subtitle: 'Tambahkan aktivitas harian Anda', icon: Icons.edit_note_rounded);
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Date header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Hari Ini', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                    Text(df.format(DateTime.now()), style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                  ]),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                    child: Text('${logs.length} Aktivitas', style: AppTextStyles.chipText.copyWith(color: Colors.white)),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              // Log entries
              ...logs.asMap().entries.map((entry) {
                final log = entry.value;
                final i = entry.key;
                final isLast = i == logs.length - 1;
                return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Timeline
                  SizedBox(width: 40, child: Column(children: [
                    Container(width: 12, height: 12,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        color: log.status == 'Selesai' ? AppColors.success : AppColors.warning,
                        border: Border.all(color: Colors.white, width: 2))),
                    if (!isLast) Container(width: 2, height: 80, color: AppColors.border),
                  ])),
                  Expanded(child: AppCard(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(child: Text(log.activity, style: AppTextStyles.labelLarge)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: log.status == 'Selesai' ? AppColors.successLight : AppColors.warningLight,
                            borderRadius: BorderRadius.circular(8)),
                          child: Text(log.status ?? 'Proses', style: AppTextStyles.chipText.copyWith(
                            color: log.status == 'Selesai' ? AppColors.success : AppColors.warning, fontSize: 10)),
                        ),
                      ]),
                      if (log.description != null) ...[
                        const SizedBox(height: 4),
                        Text(log.description!, style: AppTextStyles.bodySmall),
                      ],
                      const SizedBox(height: 6),
                      Row(children: [
                        Icon(Icons.access_time, size: 13, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text('${log.startTime ?? '-'} - ${log.endTime ?? '-'}', style: AppTextStyles.caption),
                      ]),
                    ]),
                  )),
                ]);
              }),
            ],
          );
        },
        loading: () => const Padding(padding: EdgeInsets.all(16), child: ShimmerList()),
        error: (e, _) => ErrorState(message: e.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur tambah catatan akan segera hadir'), backgroundColor: AppColors.info));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
