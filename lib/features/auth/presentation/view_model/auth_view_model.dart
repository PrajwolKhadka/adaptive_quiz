import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_quiz/features/auth/data/repositories/auth_repository.dart';
import 'package:adaptive_quiz/features/auth/presentation/providers/auth_provider.dart';
import '../state/auth_state.dart';

class AuthViewModel extends Notifier<AuthState> {
  late final IAuthRepository _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    return AuthState.initial();
  }

  Future<void> login(
    String email,
    String password,
    void Function(bool isFirstLogin, String token) onSuccess,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _authRepository.loginStudent(email, password);

      result.fold(
        (failure) {
          state = state.copyWith(isLoading: false, error: failure.message);
        },
        (response) {
          state = state.copyWith(isLoading: false, error: null);
          onSuccess(response.isFirstLogin, response.token);
        },
      );
    } catch (e) {
      // 🔥 THIS PREVENTS INFINITE LOADING
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);
