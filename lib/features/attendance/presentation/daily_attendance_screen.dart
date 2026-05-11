import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/daily_attendance_provider.dart';
import '../domain/daily_attendance_model.dart';

class DailyAttendanceScreen extends ConsumerStatefulWidget {
  const DailyAttendanceScreen({super.key});

  @override
  ConsumerState<DailyAttendanceScreen> createState() => _DailyAttendanceScreenState();
}

class _DailyAttendanceScreenState extends ConsumerState<DailyAttendanceScreen> {
  final List<String> _months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final monthYear = ref.watch(selectedMonthYearProvider);
    final attendanceAsync = ref.watch(dailyAttendanceProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Presensi Kegiatan'),
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
              loading: () => const SizedBox(height: 140, child: Center(child: CircularProgressIndicator())),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: 24),
            
            // Filter Section
            Text('PRESENSI KEHADIRAN', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, letterSpacing: 1.2)),
            const SizedBox(height: 4),
            const Divider(),
            const SizedBox(height: 16),
            
            Row(
              children: [
                SizedBox(width: 80, child: Text('BULAN', style: AppTextStyles.labelSmall)),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: monthYear.month,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                        items: List.generate(12, (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text(_months[index], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                        )),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(selectedMonthYearProvider.notifier).state = DateTime(monthYear.year, val);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(width: 80, child: Text('TAHUN', style: AppTextStyles.labelSmall)),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: monthYear.year,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                        items: [2023, 2024, 2025, 2026].map((y) => DropdownMenuItem(
                          value: y,
                          child: Text(y.toString(), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                        )).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(selectedMonthYearProvider.notifier).state = DateTime(val, monthYear.month);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(selectedMonthYearProvider.notifier).state = DateTime.now();
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('REFRESH'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Trigger refresh manually if needed
                      ref.invalidate(dailyAttendanceProvider);
                    },
                    icon: const Icon(Icons.search, size: 18),
                    label: const Text('CARI'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Calendar Grid
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PRESENSI HARIAN', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1.0)),
                      Row(
                        children: [
                          Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 4),
                          Text(': HADIR', style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Days Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) => 
                      SizedBox(width: 36, child: Text(d, textAlign: TextAlign.center, style: AppTextStyles.labelSmall))
                    ).toList(),
                  ),
                  const SizedBox(height: 10),
                  
                  // Grid
                  attendanceAsync.when(
                    data: (data) => _buildCalendarGrid(monthYear, data),
                    loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                    error: (e, _) => Center(child: Text(e.toString())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(profile) {
    if (profile == null) return const SizedBox();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1550B0),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1550B0).withValues(alpha: 0.3),
            blurRadius: 15, offset: const Offset(0, 8),
          ),
        ]
      ),
      child: Stack(
        children: [
          // Background blobs
          Positioned(right: -20, top: -20, child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withValues(alpha: 0.05))),
          Positioned(left: -30, bottom: -30, child: CircleAvatar(radius: 50, backgroundColor: Colors.white.withValues(alpha: 0.05))),
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      child: const Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    Positioned(
                      bottom: -10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB28A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('VERIFIED', style: AppTextStyles.chipText.copyWith(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName, style: AppTextStyles.subtitle1.copyWith(color: Colors.white)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.badge_outlined, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text('${profile.displayIdLabel}: ${profile.displayId}', style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('${profile.statusKepegawaian ?? "Pegawai"} • ${profile.department ?? ""}', 
                        style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 10),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime monthYear, List<DailyAttendanceModel> attendanceData) {
    final daysInMonth = DateUtils.getDaysInMonth(monthYear.year, monthYear.month);
    final firstDayOfMonth = DateTime(monthYear.year, monthYear.month, 1);
    // 1 = Monday, 7 = Sunday
    int firstDayOffset = firstDayOfMonth.weekday - 1; 
    
    // Total cells = offset + daysInMonth. Rounded up to multiple of 7
    int totalCells = firstDayOffset + daysInMonth;
    int rows = (totalCells / 7).ceil();
    totalCells = rows * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        if (index < firstDayOffset || index >= firstDayOffset + daysInMonth) {
          // Empty cells (from previous/next month)
          return Container(
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(4)),
            alignment: Alignment.center,
          );
        }

        final day = index - firstDayOffset + 1;
        final currentDate = DateTime(monthYear.year, monthYear.month, day);
        final attendance = attendanceData.firstWhere((a) => a.date.day == day, 
          orElse: () => DailyAttendanceModel(date: currentDate, status: ''));

        final isHadir = attendance.status == 'Hadir';
        
        if (isHadir) {
          final timeStr = attendance.checkInTime != null 
              ? DateFormat('HH:mm:ss').format(attendance.checkInTime!)
              : '';
          final dateStr = DateFormat('yyyy-MM-dd').format(currentDate);
          
          return Container(
            decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(4)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(day.toString(), style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                Text('HADIR', style: AppTextStyles.chipText.copyWith(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold)),
                Text(dateStr, style: AppTextStyles.chipText.copyWith(color: Colors.white, fontSize: 5)),
                Text(timeStr, style: AppTextStyles.chipText.copyWith(color: Colors.white, fontSize: 5)),
              ],
            ),
          );
        }

        // Normal day without attendance
        return Container(
          decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(4)),
          alignment: Alignment.center,
          child: Text(day.toString(), style: AppTextStyles.labelLarge.copyWith(fontSize: 12)),
        );
      },
    );
  }
}
