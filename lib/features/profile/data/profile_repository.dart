import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';

class ProfileRepository {
  final _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      return await _client.from(AppConstants.profilesTable).select().eq('id', userId).maybeSingle();
    } catch (_) { return null; }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await _client.from(AppConstants.profilesTable).update(data).eq('id', userId);
  }
}
