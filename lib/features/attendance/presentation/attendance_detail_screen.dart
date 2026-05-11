import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/attendance_provider.dart';
import '../domain/attendance_model.dart';
import '../../schedule/providers/schedule_provider.dart';

class AttendanceDetailScreen extends ConsumerStatefulWidget {
  final String scheduleId;
  const AttendanceDetailScreen({super.key, required this.scheduleId});
  @override
  ConsumerState<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends ConsumerState<AttendanceDetailScreen> {
  DateTime? _selectedDate;
  String _selectedTopic = 'Meeting 1: Introduction';
  bool _matchesRps = true;
  final _startTimeCtrl = TextEditingController(text: '08:00');
  final _endTimeCtrl = TextEditingController(text: '10:00');
  List<StudentAttendanceModel> _students = [];
  bool _loaded = false;

  @override
  void dispose() {
    _startTimeCtrl.dispose();
    _endTimeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(scheduleByIdProvider(widget.scheduleId));
    final studentsAsync = ref.watch(attendanceListProvider(widget.scheduleId));

    if (!_loaded) {
      studentsAsync.whenData((data) {
        if (!_loaded) {
          _students = List.from(data);
          _loaded = true;
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: const Text('Detail Presensi'),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Course header
          scheduleAsync.when(
            data: (schedule) {
              if (schedule == null) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity, padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(16)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('MATA KULIAH', style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7), letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Expanded(child: Text(schedule.courseName,
                        style: AppTextStyles.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: Text('${schedule.sks} SKS', style: AppTextStyles.chipText.copyWith(color: Colors.white))),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.groups_outlined, color: Colors.white.withValues(alpha: 0.8), size: 16),
                      const SizedBox(width: 6),
                      Text(schedule.className, style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today_outlined, color: Colors.white.withValues(alpha: 0.8), size: 14),
                      const SizedBox(width: 6),
                      Text('TA ${schedule.academicYear}',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                    ]),
                  ]),
                ),
              );
            },
            loading: () => const Padding(padding: EdgeInsets.all(16), child: LoadingShimmer(height: 120)),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 20),
          // Presensi form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Presensi Mahasiswa', style: AppTextStyles.heading3),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.monitor_outlined, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Pelaksanaan Pembelajaran', style: AppTextStyles.labelLarge),
                ]),
                const SizedBox(height: 16),
                Text('TANGGAL PELAKSANAAN', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 0.8, color: AppColors.textHint)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final d = await showDatePicker(context: context, initialDate: DateTime.now(),
                      firstDate: DateTime(2020), lastDate: DateTime(2030));
                    if (d != null) setState(() => _selectedDate = d);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(suffixIcon: Icon(Icons.calendar_today, size: 18)),
                    child: Text(_selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'dd / mm / yyyy', style: AppTextStyles.bodyMedium.copyWith(
                        color: _selectedDate != null ? AppColors.textPrimary : AppColors.textHint)),
                  ),
                ),
                const SizedBox(height: 14),
                Text('TOPIK MATERI', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 0.8, color: AppColors.textHint)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedTopic, isExpanded: true,
                  items: ['Meeting 1: Introduction', 'Meeting 2: OOP Basics', 'Meeting 3: Inheritance']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t, style: AppTextStyles.bodyMedium))).toList(),
                  onChanged: (v) => setState(() => _selectedTopic = v!),
                ),
                const SizedBox(height: 14),
                Text('Kesesuaian materi dengan RPS', style: AppTextStyles.bodySmall),
                const SizedBox(height: 6),
                RadioGroup<bool>(
                  groupValue: _matchesRps,
                  onChanged: (v) => setState(() => _matchesRps = v ?? true),
                  child: Row(children: [
                    Radio<bool>(value: true, activeColor: AppColors.primary),
                    const Text('Ya'),
                    const SizedBox(width: 16),
                    Radio<bool>(value: false, activeColor: AppColors.primary),
                    const Text('Tidak'),
                  ]),
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('JAM MASUK', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 0.8, color: AppColors.textHint)),
                    const SizedBox(height: 6),
                    TextFormField(controller: _startTimeCtrl, textAlign: TextAlign.center),
                  ])),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('JAM PULANG', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 0.8, color: AppColors.textHint)),
                    const SizedBox(height: 6),
                    TextFormField(controller: _endTimeCtrl, textAlign: TextAlign.center),
                  ])),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          // Batas Presensi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(14)),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.timer_outlined, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Batas Presensi', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('JAM MULAI', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint)),
                    const SizedBox(height: 4),
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(
                      color: AppColors.cardBackground, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                      child: Text('08:00', style: AppTextStyles.bodyMedium)),
                  ])),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('JAM SELESAI', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint)),
                    const SizedBox(height: 4),
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(
                      color: AppColors.cardBackground, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                      child: Text('08:15', style: AppTextStyles.bodyMedium)),
                  ])),
                ]),
                const SizedBox(height: 14),
                SizedBox(width: double.infinity, height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Presensi berhasil disimpan'), backgroundColor: AppColors.success));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                    child: Text('Simpan Presensi', style: AppTextStyles.button),
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          // Student list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Data Presensi', style: AppTextStyles.sectionTitle),
              Text('${_students.length} MAHASISWA', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textHint)),
            ]),
          ),
          const SizedBox(height: 10),
          studentsAsync.when(
            data: (_) => ListView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _students.length,
              itemBuilder: (context, i) => _StudentRow(
                student: _students[i],
                onStatusChanged: (status) => setState(() => _students[i].status = status),
              ),
            ),
            loading: () => const Padding(padding: EdgeInsets.all(16), child: ShimmerList(itemCount: 3, itemHeight: 60)),
            error: (e, _) => ErrorState(message: e.toString()),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final StudentAttendanceModel student;
  final ValueChanged<String> onStatusChanged;
  const _StudentRow({required this.student, required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(student.studentName, style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
          Text(student.studentNim, style: AppTextStyles.caption),
        ])),
        _StatusChip('Hadir', AppColors.hadirBg, student.status == 'Hadir', () => onStatusChanged('Hadir')),
        const SizedBox(width: 4),
        _StatusChip('Sakit', AppColors.sakitBg, student.status == 'Sakit', () => onStatusChanged('Sakit')),
        const SizedBox(width: 4),
        _StatusChip('Ijin', AppColors.ijinBg, student.status == 'Ijin', () => onStatusChanged('Ijin')),
        const SizedBox(width: 6),
        Icon(Icons.refresh_rounded, color: AppColors.error.withValues(alpha: 0.6), size: 20),
      ]),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label; final Color color; final bool isActive; final VoidCallback onTap;
  const _StatusChip(this.label, this.color, this.isActive, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isActive ? color : AppColors.border),
        ),
        child: Text(label, style: AppTextStyles.chipText.copyWith(
          color: isActive ? Colors.white : AppColors.textSecondary, fontSize: 10)),
      ),
    );
  }
}
