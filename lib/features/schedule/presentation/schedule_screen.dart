import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/schedule_provider.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(scheduleHistoryProvider);
    final selectedYear = ref.watch(selectedAcademicYearProvider);
    final selectedSem = ref.watch(selectedSemesterProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Jadwal Kuliah'),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppHeaderSmall(
              subtitle: 'Jadwal Perkuliahan',
              title: 'Kelola Jadwal\nMengajar Anda',
              tags: [Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 26),
              )],
            ),
          ),
          const SizedBox(height: 16),
          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(child: _FilterDropdown(
                label: 'TAHUN AKADEMIK', value: selectedYear,
                items: const ['2024/2025', '2023/2024', '2022/2023'],
                onChanged: (v) => ref.read(selectedAcademicYearProvider.notifier).state = v!,
              )),
              const SizedBox(width: 12),
              Expanded(child: _FilterDropdown(
                label: 'SEMESTER', value: selectedSem,
                items: const ['Ganjil', 'Genap'],
                onChanged: (v) => ref.read(selectedSemesterProvider.notifier).state = v!,
              )),
            ]),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Riwayat Jadwal', style: AppTextStyles.sectionTitle),
          ),
          const SizedBox(height: 10),
          // List
          historyAsync.when(
            data: (entries) => ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final e = entries[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)),
                      child: Center(child: Text(e.number.toString().padLeft(2, '0'),
                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary, fontSize: 13))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(e.academicYear, style: AppTextStyles.labelLarge),
                      Text(e.semester, style: AppTextStyles.bodySmall),
                    ])),
                    GestureDetector(
                      onTap: () => context.push('/schedule/detail-${e.number}'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('Detail', style: AppTextStyles.chipText.copyWith(color: Colors.white)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                        ]),
                      ),
                    ),
                  ]),
                );
              },
            ),
            loading: () => const Padding(padding: EdgeInsets.all(16), child: ShimmerList(itemCount: 5, itemHeight: 60)),
            error: (e, _) => ErrorState(message: e.toString()),
          ),
          const SizedBox(height: 16),
          // Pagination indicator
          Center(child: Text('Menunjukkan 1 ke 25 dari 78 data',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint))),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _PageBtn('Prev', false),
            _PageBtn('1', true),
            _PageBtn('2', false),
            _PageBtn('3', false),
            _PageBtn('4', false),
            _PageBtn('Next', false),
          ]),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label; final String value; final List<String> items;
  final ValueChanged<String?> onChanged;
  const _FilterDropdown({required this.label, required this.value, required this.items, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTextStyles.labelSmall.copyWith(letterSpacing: 0.8, color: AppColors.textHint)),
        DropdownButton<String>(
          value: value, isDense: true, isExpanded: true, underline: const SizedBox(),
          style: AppTextStyles.labelLarge,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
        ),
      ]),
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String label; final bool isActive;
  const _PageBtn(this.label, this.isActive);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isActive ? null : Border.all(color: AppColors.border),
      ),
      child: Center(child: Text(label, style: AppTextStyles.chipText.copyWith(
        color: isActive ? Colors.white : AppColors.textSecondary, fontSize: 12))),
    );
  }
}
