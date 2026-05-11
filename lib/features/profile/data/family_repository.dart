import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../domain/family_member_model.dart';

class FamilyRepository {
  final _client = Supabase.instance.client;

  Future<List<FamilyMemberModel>> getFamilyMembers(String profileId) async {
    try {
      final response = await _client.from(AppConstants.familyMembersTable)
          .select().eq('profile_id', profileId).order('created_at');
      return (response as List).map((e) => FamilyMemberModel.fromJson(e)).toList();
    } catch (_) { return FamilyMemberModel.demoData(profileId); }
  }

  Future<FamilyMemberModel?> getFamilyMember(String id) async {
    try {
      final r = await _client.from(AppConstants.familyMembersTable).select().eq('id', id).maybeSingle();
      return r != null ? FamilyMemberModel.fromJson(r) : null;
    } catch (_) { return null; }
  }

  Future<void> addFamilyMember(FamilyMemberModel member) async {
    await _client.from(AppConstants.familyMembersTable).insert(member.toJson());
  }

  Future<void> updateFamilyMember(FamilyMemberModel member) async {
    await _client.from(AppConstants.familyMembersTable).update(member.toJson()).eq('id', member.id!);
  }

  Future<void> deleteFamilyMember(String id) async {
    await _client.from(AppConstants.familyMembersTable).delete().eq('id', id);
  }
}
