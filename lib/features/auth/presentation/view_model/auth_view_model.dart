import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_state.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthViewModel extends Notifier<AuthState> {
  late final LoginUsecase loginUsecase;

  @override
  AuthState build() {

    return AuthState.initial();
  }

  // Login function
  bool login(String email, String password) {
    // Set loading true
    state = state.copyWith(isLoading: true);

    final user = loginUsecase(email, password);

    if (user == null) {
      state = state.copyWith(isLoading: false, error: "Invalid credentials");
      return false;
    }

    state = state.copyWith(isLoading: false, error: null);
    return true;
  }
}
