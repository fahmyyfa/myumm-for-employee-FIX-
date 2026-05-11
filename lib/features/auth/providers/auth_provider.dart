import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';
import '../../profile/domain/profile_model.dart';
import '../../profile/providers/profile_provider.dart';

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
  return AuthNotifier(ref, ref.read(authRepositoryProvider), changeNotifier);
});

// Simple provider to expose the current user ID (supports demo and real auth)
final userIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  if (authState.status == AuthStatus.authenticated) {
    return authState.userId;
  }
  return null;
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
  final Ref _ref;
  final AuthRepository _repository;
  final AuthChangeNotifier _changeNotifier;
  StreamSubscription<sb.AuthState>? _authSubscription;

  AuthNotifier(this._ref, this._repository, this._changeNotifier) : super(const AuthState()) {
    _init();
  }

  void _init() async {
    // Check if already authenticated
    final session = _repository.currentSession;
    if (session != null) {
      state = AuthState(
        status: AuthStatus.authenticated,
        userId: session.user.id,
        userRole: 'unknown',
      );
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }

    // Listen for auth state changes
    _authSubscription = _repository.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        final userId = session.user.id;
        state = AuthState(
          status: AuthStatus.authenticated,
          userId: userId,
          userRole: 'unknown', // Role will be determined by profileProvider
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
        final userId = response.user?.id;
        if (userId != null) {
          state = AuthState(
            status: AuthStatus.authenticated,
            userId: userId,
            userRole: 'unknown',
          );
        }
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
      userRole: asDosen ? 'dosen' : 'karyawan',
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
    debugPrint('DEBUG ERROR PARSE: $error');
    if (error is sb.AuthException) {
      return 'Auth Error: ${error.message}${error.statusCode != null ? ' (${error.statusCode})' : ''}';
    }
    return 'Terjadi kesalahan: ${error.toString()}';
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
