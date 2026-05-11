import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  static const _icons = {
    'Pendidikan': Icons.school_rounded,
    'Kepangkatan': Icons.military_tech_rounded,
    'Aktifasi': Icons.verified_rounded,
    'Kerja di UMM': Icons.business_rounded,
    'Kepanitiaan': Icons.groups_rounded,
    'Organisasi': Icons.account_tree_rounded,
    'Prestasi': Icons.emoji_events_rounded,
  };

  static const _colors = {
    'Pendidikan': Color(0xFF1E88E5),
    'Kepangkatan': Color(0xFF7B1FA2),
    'Aktifasi': Color(0xFF00897B),
    'Kerja di UMM': Color(0xFFF4511E),
    'Kepanitiaan': Color(0xFF5C6BC0),
    'Organisasi': Color(0xFF00ACC1),
    'Prestasi': Color(0xFFFFA000),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyDataProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(title: const Text('Riwayat')),
      body: historyAsync.when(
        data: (data) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: AppConstants.historyCategories.length,
            itemBuilder: (context, i) {
              final cat = AppConstants.historyCategories[i];
              final count = data[cat]?.length ?? 0;
              return _CategoryCard(
                category: cat, count: count,
                icon: _icons[cat] ?? Icons.folder_outlined,
                color: _colors[cat] ?? AppColors.primary,
                onTap: () => context.push('/history/$cat'),
              );
            },
          );
        },
        loading: () => const Padding(padding: EdgeInsets.all(16), child: ShimmerList(itemCount: 7)),
        error: (e, _) => ErrorState(message: e.toString()),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.count,
    required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Row(children: [
              Container(width: 48, height: 48,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 24)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(category, style: AppTextStyles.labelLarge),
                Text('$count data tercatat', style: AppTextStyles.bodySmall),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('$count', style: AppTextStyles.labelLarge.copyWith(color: color)),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: AppColors.textHint.withValues(alpha: 0.5)),
            ]),
          ),
        ),
      ),
    );
  }
}
