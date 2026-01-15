class ApiEndpoints {
  ApiEndpoints._(); // Private constructor to prevent instantiation

  static const String baseUrl = "http://10.0.2.2:3000/api/"; // Change to your server IP

  // Auth Endpoints
  static const String login = "school/auth/student-login";
  static const String changePassword = "auth/change-password";

  // Quiz Endpoints
  static const String getQuestions = "quiz/questions";

  // Constant for connection timeout
  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
}