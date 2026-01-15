import 'package:adaptive_quiz/core/services/hive/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_state.dart';

class AuthViewModel extends Notifier<AuthState> {
  late final HiveService hiveService;

  @override
  AuthState build() {
    hiveService = HiveService();
    return AuthState.initial();
  }

  bool login(String username, String password) {
    state = state.copyWith(isLoading: true);

    final user = hiveService.login(username, password);

    if (user == null) {
      state = state.copyWith(isLoading: false, error: "Invalid credentials");
      return false;
    }

    state = state.copyWith(isLoading: false, error: null);
    return true;
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);
