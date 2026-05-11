import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../profile/domain/profile_model.dart';
import '../../activities/providers/activity_attendance_provider.dart';
import '../../daily_log/providers/daily_log_provider.dart';
import '../../schedule/providers/schedule_provider.dart';

class DosenHomeContent extends ConsumerWidget {
  final ProfileModel profile;
  const DosenHomeContent({super.key, required this.profile});

  void _showUnderConstruction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur ini masih dalam pengembangan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.white.withValues(alpha: 0.7), size: 20),
                          const SizedBox(width: 8),
                          Text('Cari layanan atau fitur tertentu',
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.6))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => context.push('/notifications'),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        Positioned(
                          bottom: -4,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1550B0),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: Text('VERIFIED', style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w900)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.fullName,
                            style: AppTextStyles.subtitle1.copyWith(color: const Color(0xFF1E293B), fontWeight: FontWeight.w900, fontSize: 18)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.badge_outlined, size: 12, color: Color(0xFF64748B)),
                                const SizedBox(width: 4),
                                Text('${profile.displayIdLabel}: ${profile.displayId}',
                                  style: AppTextStyles.caption.copyWith(color: const Color(0xFF64748B), fontWeight: FontWeight.w800, fontSize: 11)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('${profile.statusKepegawaian ?? "Dosen Tetap"} • ${profile.department ?? "Teknik Informatika"}',
                            style: AppTextStyles.caption.copyWith(color: const Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildServiceGrid(context),
                      const SizedBox(height: 20),
                      Text('Informasi Kegiatan', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 10),
                      const _ActivitiesSection(),
                      const SizedBox(height: 20),
                      const _AgendaSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    final items = [
      _ServiceItem(Icons.calendar_month_rounded, 'Jadwal Kuliah', () => context.push('/schedule')),
      _ServiceItem(Icons.description_outlined, 'Laporan OBE', () => context.push('/obe')),
      _ServiceItem(Icons.groups_outlined, 'Perwalian', () => _showUnderConstruction(context)),
      _ServiceItem(Icons.school_outlined, 'Tugas Akhir', () => context.push('/tugas-akhir')),
      _ServiceItem(Icons.fact_check_outlined, 'Presensi', () => context.push('/attendance/daily')),
      _ServiceItem(Icons.event_note_outlined, 'Kegiatan', () => context.push('/activities/attendance')),
      _ServiceItem(Icons.workspace_premium_outlined, 'Jab. Akademik', () => context.push('/academic-ranks')),
      _ServiceItem(Icons.grid_view_rounded, 'Lainnya', () => _showUnderConstruction(context)),
    ];
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text('Layanan Cepat', style: AppTextStyles.subtitle2),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 14, crossAxisSpacing: 8,
            childAspectRatio: 0.8,
            children: items.map((item) => _buildGridItem(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(_ServiceItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.primarySurface, borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(item.label, style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 11),
            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _ActivitiesSection extends ConsumerWidget {
  const _ActivitiesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(dailyLogsProvider);
    return logsAsync.when(
      data: (logs) {
        if (logs.isEmpty) {
          return const _EmptyState(message: 'Belum ada kegiatan hari ini.');
        }
        return Column(
          children: logs.take(2).map((l) => 
            _ActivityCard(
              title: l.title, 
              subtitle: '${l.location ?? "UMM"} • ${DateFormat('dd MMM').format(l.date)}',
            )
          ).toList(),
        );
      },
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(),
      )),
      error: (e, _) => const _EmptyState(message: 'Belum ada kegiatan hari ini.'),
    );
  }
}

class _AgendaSection extends ConsumerWidget {
  const _AgendaSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(schedulesProvider);
    return schedulesAsync.when(
      data: (schedules) {
        if (schedules.isEmpty) {
          return const _EmptyState(message: 'Belum ada agenda mengajar hari ini.');
        }
        final schedule = schedules.first;
        return _AgendaCard(
          title: schedule.courseName,
          time: '${schedule.startTime} - ${schedule.endTime}',
          location: schedule.room,
          id: schedule.id,
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const _EmptyState(message: 'Belum ada agenda mengajar hari ini.'),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(message, style: AppTextStyles.bodySmall),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ActivityCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => context.push('/notifications'),
        child: AppCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.campaign_outlined, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.labelLarge),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  final String title;
  final String time;
  final String location;
  final String id;
  const _AgendaCard({required this.title, required this.time, required this.location, required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Agenda Mengajar Terdekat',
            style: AppTextStyles.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          Text('Tahun Akademik 2025/2026',
            style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(title,
                              style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontSize: 13), 
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.white.withValues(alpha: 0.7), size: 14),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(time, 
                              style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.7), size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(location, 
                              style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildAgendaBtn(context, Icons.fact_check_outlined, 'Presensi', AppColors.success, () => context.push('/attendance/$id'))),
              const SizedBox(width: 8),
              Expanded(child: _buildAgendaBtn(context, Icons.edit_calendar_outlined, 'Jadwal', AppColors.warning, () => context.push('/schedule/$id'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaBtn(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.chipText.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ServiceItem(this.icon, this.label, this.onTap);
}
