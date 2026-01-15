class ApiEndpoints {
  ApiEndpoints._(); // Private constructor to prevent instantiation

  static const String baseUrl = "http://10.0.2.2:5000/api/";

  // Auth Endpoints
  static const String login = "school/auth/student-login";
  static const String changePassword = "school/auth/change-password";

  // Quiz Endpoints
  static const String getQuestions = "quisz/questions";

  // Constant for connection timeout
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}