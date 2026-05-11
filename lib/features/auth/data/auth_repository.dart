import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';

class AuthRepository {
  final _client = Supabase.instance.client;

  GoTrueClient get _auth => _client.auth;

  Session? get currentSession => _auth.currentSession;
  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentSession != null;

  Stream<AuthState> get onAuthStateChange =>
      _auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    final response = await _client
        .from(AppConstants.profilesTable)
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }
}
