import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/profile_repository.dart';
import '../data/family_repository.dart';
import '../domain/profile_model.dart';
import '../domain/family_member_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/domain/auth_state.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository());
final familyRepositoryProvider = Provider((ref) => FamilyRepository());

final profileProvider = FutureProvider<ProfileModel?>((ref) async {
  // Use userIdProvider which handles both Supabase and Demo sessions
  final userId = ref.watch(userIdProvider);
  
  if (userId == null) {
    return null;
  }

  if (userId.startsWith('demo-dosen')) return ProfileModel.demoDosenProfile();
  if (userId.startsWith('demo-karyawan')) return ProfileModel.demoKaryawanProfile();

  try {
    final repo = ref.read(profileRepositoryProvider);
    final data = await repo.getProfile(userId);
    
    if (data != null) {
      return ProfileModel.fromJson(data);
    }
  } catch (e) {
    debugPrint('Error in profileProvider: $e');
  }
  return null;
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
