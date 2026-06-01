import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final session = await _authRepository.loadSession();
    if (session != null) {
      state = state.copyWith(
        token: session.token,
        user: session.user,
        isAuthenticated: true,
      );
    }

    state = state.copyWith(isSessionRestored: true);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );
      if (response.success) {
        _applyAuthenticatedState(response);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message ?? 'Đăng nhập thất bại',
        );
      }
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đã xảy ra lỗi kết nối server',
      );
    }
  }

  Future<void> register(
    String username,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await _authRepository.register(
        username: username,
        email: email,
        password: password,
      );
      if (response.success) {
        _applyAuthenticatedState(response);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.message ?? 'Đăng ký thất bại',
        );
      }
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Đã xảy ra lỗi khi đăng ký',
      );
    }
  }

  void _applyAuthenticatedState(AuthResponse response) {
    state = state.copyWith(
      user: response.user,
      token: response.token,
      isLoading: false,
      isAuthenticated: true,
      errorMessage: null,
    );
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(isSessionRestored: true);
  }
}
