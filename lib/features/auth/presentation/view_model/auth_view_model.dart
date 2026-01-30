import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_quiz/features/auth/data/repositories/auth_repository.dart';
import 'package:adaptive_quiz/features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/providers/common_provider.dart';
import '../state/auth_state.dart';

class AuthViewModel extends Notifier<AuthState> {
  late final IAuthRepository _authRepository;
  late final session = ref.read(userSessionServiceProvider);
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

      await result.fold(
        (failure) async {
          state = state.copyWith(isLoading: false, error: failure.message);
        },
        (response) async {
          state = state.copyWith(isLoading: false, error: null);
          await session.saveStudentSession(
            token: response.token,
            studentId: response.studentId,
            fullName: response.fullName,
            email: response.email,
            className: response.className,
          );
          final profileVM = ref.read(profileViewModelProvider.notifier);
          await profileVM.loadProfile();
          onSuccess(response.isFirstLogin, response.token);
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> changePassword(String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.changePassword(newPassword);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);
