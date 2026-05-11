import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/profile_repository.dart';
import '../data/family_repository.dart';
import '../domain/profile_model.dart';
import '../domain/family_member_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/domain/auth_state.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository());
final familyRepositoryProvider = Provider((ref) => FamilyRepository());

final profileProvider = FutureProvider<ProfileModel?>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  if (authState.status != AuthStatus.authenticated || authState.userId == null) return null;

  final userId = authState.userId!;
  if (userId.startsWith('demo-dosen')) return ProfileModel.demoDosenProfile();
  if (userId.startsWith('demo-karyawan')) return ProfileModel.demoKaryawanProfile();

  final repo = ref.read(profileRepositoryProvider);
  final data = await repo.getProfile(userId);
  return data != null ? ProfileModel.fromJson(data) : ProfileModel.demoDosenProfile();
});

final familyMembersProvider = FutureProvider<List<FamilyMemberModel>>((ref) async {
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return [];

  final repo = ref.read(familyRepositoryProvider);
  return repo.getFamilyMembers(profile.id);
});

final familyMemberProvider = FutureProvider.family<FamilyMemberModel?, String>((ref, id) async {
  final repo = ref.read(familyRepositoryProvider);
  return repo.getFamilyMember(id);
});
