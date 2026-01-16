class AuthState {
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.isLoading,
    this.error,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoading: false,
      error: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
