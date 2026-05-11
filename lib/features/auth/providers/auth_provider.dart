import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';
import '../../profile/domain/profile_model.dart';

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// A separate ChangeNotifier that the router can listen to
final authChangeNotifierProvider = ChangeNotifierProvider<AuthChangeNotifier>((ref) {
  return AuthChangeNotifier();
});

// Auth state notifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final changeNotifier = ref.read(authChangeNotifierProvider);
  return AuthNotifier(ref.read(authRepositoryProvider), changeNotifier);
});

// Current profile provider — fetches profile after auth
final currentProfileProvider = FutureProvider<ProfileModel?>((ref) async {
  final authState = ref.watch(authNotifierProvider);

  if (authState.status != AuthStatus.authenticated || authState.userId == null) {
    return null;
  }

  final userId = authState.userId!;
  if (userId.startsWith('demo-dosen')) return ProfileModel.demoDosenProfile();
  if (userId.startsWith('demo-karyawan')) return ProfileModel.demoKaryawanProfile();

  try {
    final repo = ref.read(authRepositoryProvider);
    final data = await repo.fetchProfile(userId);

    if (data != null) {
      return ProfileModel.fromJson(data);
    }
  } catch (e) {
    // If error occurs (e.g., table not created), ignore and return demo
  }

  // Return demo profile if no data in DB (for development)
  return ProfileModel.demoDosenProfile();
});

// Simple boolean check
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).status == AuthStatus.authenticated;
});

/// Separate ChangeNotifier for go_router's refreshListenable
class AuthChangeNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final AuthChangeNotifier _changeNotifier;
  StreamSubscription<sb.AuthState>? _authSubscription;

  AuthNotifier(this._repository, this._changeNotifier) : super(const AuthState()) {
    _init();
  }

  void _init() {
    // Check if already authenticated
    final session = _repository.currentSession;
    if (session != null) {
      state = AuthState(
        status: AuthStatus.authenticated,
        userId: session.user.id,
      );
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }

    // Listen for auth state changes
    _authSubscription = _repository.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          userId: session.user.id,
        );
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
      _changeNotifier.notify();
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final response = await _repository.signIn(
        email: email,
        password: password,
      );

      if (response.session != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          userId: response.user?.id,
        );
      } else {
        state = const AuthState(
          status: AuthStatus.error,
          errorMessage: 'Login gagal. Silakan coba lagi.',
        );
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: _parseError(e),
      );
    }
    _changeNotifier.notify();
  }

  /// Demo login — bypasses Supabase for development
  void demoLogin({bool asDosen = true}) {
    state = AuthState(
      status: AuthStatus.authenticated,
      userId: asDosen ? 'demo-dosen-001' : 'demo-karyawan-001',
    );
    _changeNotifier.notify();
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
    } catch (_) {}
    state = const AuthState(status: AuthStatus.unauthenticated);
    _changeNotifier.notify();
  }

  String _parseError(dynamic error) {
    if (error is sb.AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Username atau password salah.';
        case 'Email not confirmed':
          return 'Email belum dikonfirmasi.';
        default:
          return error.message;
      }
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
