class AuthResponse {
  final String token;
  final bool isFirstLogin;

  AuthResponse({
    required this.token,
    required this.isFirstLogin,
  });
}
