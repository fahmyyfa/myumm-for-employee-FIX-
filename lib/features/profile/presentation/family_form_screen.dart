import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/profile_provider.dart';
import '../domain/family_member_model.dart';

class FamilyFormScreen extends ConsumerStatefulWidget {
  final String? familyMemberId;
  const FamilyFormScreen({super.key, this.familyMemberId});
  @override
  ConsumerState<FamilyFormScreen> createState() => _FamilyFormScreenState();
}

class _FamilyFormScreenState extends ConsumerState<FamilyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _birthPlaceCtrl = TextEditingController();
  final _educationCtrl = TextEditingController();
  final _occupationCtrl = TextEditingController();
  String _relationship = AppConstants.familyRelationships.first;
  DateTime? _birthDate;
  bool _isLoading = false;
  bool get isEditing => widget.familyMemberId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) _loadData();
  }

  void _loadData() async {
    // In a real app, would fetch from provider
    // For demo, we skip
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _birthPlaceCtrl.dispose();
    _educationCtrl.dispose(); _occupationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context, initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1940), lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final profile = await ref.read(profileProvider.future);
      if (profile == null) return;

      final member = FamilyMemberModel(
        id: widget.familyMemberId,
        profileId: profile.id,
        name: _nameCtrl.text.trim(),
        relationship: _relationship,
        birthDate: _birthDate,
        birthPlace: _birthPlaceCtrl.text.trim(),
        education: _educationCtrl.text.trim(),
        occupation: _occupationCtrl.text.trim(),
        status: 'Aktif',
      );

      final repo = ref.read(familyRepositoryProvider);
      if (isEditing) {
        await repo.updateFamilyMember(member);
      } else {
        await repo.addFamilyMember(member);
      }

      ref.invalidate(familyMembersProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditing ? 'Data berhasil diperbarui' : 'Data berhasil ditambahkan'),
            backgroundColor: AppColors.success));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: AppColors.error));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text(isEditing ? 'Edit Data Keluarga' : 'Tambah Data Keluarga'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('NAMA LENGKAP', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextFormField(controller: _nameCtrl, decoration: const InputDecoration(hintText: 'Masukkan nama'),
              validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null),
            const SizedBox(height: 18),
            Text('HUBUNGAN', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _relationship,
              decoration: const InputDecoration(),
              items: AppConstants.familyRelationships.map((r) =>
                DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => setState(() => _relationship = v!),
            ),
            const SizedBox(height: 18),
            Text('TANGGAL LAHIR', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(suffixIcon: Icon(Icons.calendar_today, size: 20)),
                child: Text(_birthDate != null ? df.format(_birthDate!) : 'Pilih tanggal',
                  style: _birthDate != null ? AppTextStyles.bodyMedium : AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint)),
              ),
            ),
            const SizedBox(height: 18),
            Text('TEMPAT LAHIR', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextFormField(controller: _birthPlaceCtrl, decoration: const InputDecoration(hintText: 'Masukkan tempat lahir')),
            const SizedBox(height: 18),
            Text('PENDIDIKAN', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextFormField(controller: _educationCtrl, decoration: const InputDecoration(hintText: 'Masukkan pendidikan')),
            const SizedBox(height: 18),
            Text('PEKERJAAN', style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            TextFormField(controller: _occupationCtrl, decoration: const InputDecoration(hintText: 'Masukkan pekerjaan')),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : Text(isEditing ? 'Perbarui Data' : 'Simpan Data', style: AppTextStyles.button),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
