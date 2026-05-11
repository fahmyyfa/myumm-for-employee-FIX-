import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../providers/obe_provider.dart';
import '../domain/obe_course_model.dart';

class ObeMainScreen extends ConsumerStatefulWidget {
  const ObeMainScreen({super.key});

  @override
  ConsumerState<ObeMainScreen> createState() => _ObeMainScreenState();
}

class _ObeMainScreenState extends ConsumerState<ObeMainScreen> {
  String _selectedTa = '2023/2024';
  String _selectedSemester = 'GANJIL';

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(obeCoursesProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => context.pop()),
        title: const Text('Laporan OBE'),
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
                color: const Color(0xFF1550B0),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF1550B0).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Laporan OBE', style: AppTextStyles.chipText.copyWith(color: Colors.white.withValues(alpha: 0.8), letterSpacing: 1.0)),
                        const SizedBox(height: 8),
                        Text('Kelola Laporan\nMengajar Anda', style: AppTextStyles.heading2.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: const Icon(Icons.school, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Filters
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedTa,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textSecondary),
                        items: ['2023/2024', '2024/2025'].map((ta) => DropdownMenuItem(
                          value: ta,
                          child: Text('TAHUN AKADEMIK: $ta', style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.textPrimary)),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedTa = val!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSemester,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textSecondary),
                        items: ['GANJIL', 'GENAP'].map((sem) => DropdownMenuItem(
                          value: sem,
                          child: Text('SEMESTER: $sem', style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.textPrimary)),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedSemester = val!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Courses List
            coursesAsync.when(
              data: (courses) => Column(
                children: courses.asMap().entries.map((entry) {
                  return _buildCourseCard(entry.key + 1, entry.value);
                }).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(int index, ObeCourseModel course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(index.toString().padLeft(2, '0'), style: AppTextStyles.subtitle2.copyWith(color: const Color(0xFF1550B0))),
                  const SizedBox(width: 8),
                  Text(course.curriculum, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1550B0).withValues(alpha: 0.2)),
                ),
                child: Text('${course.sks} SKS', style: AppTextStyles.caption.copyWith(color: const Color(0xFF1550B0), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(course.courseName, style: AppTextStyles.subtitle1),
          const SizedBox(height: 12),
          
          _buildInfoRow(Icons.person_outline, course.lecturer),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.domain, course.faculty),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.schedule, course.major), // Re-using major for icon for simplicity
          const SizedBox(height: 20),
          
          ElevatedButton(
            onPressed: () => context.push('/obe/course/${course.id}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1550B0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bar_chart, size: 16),
                const SizedBox(width: 8),
                Text('Laporan', style: AppTextStyles.button.copyWith(fontSize: 12)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
      ],
    );
  }
}
