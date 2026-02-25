

import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._(); // Private constructor to prevent instantiation

  // static const String baseUrl = "http://10.0.2.2:5000/api/";

  // Configuration
  static const bool isPhysicalDevice = true;
  static const String _ipAddress = '192.168.1.70';
  static const int _port = 5000;

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => '$serverUrl/api/';
  static String get mediaServerUrl => serverUrl;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth related sab ko sab endpoints
  static const String login = "/school/auth/student-login";
  static const String changePassword = "/school/auth/change-password";
  static const String uploadProfilePicture = "/student/profile-picture";
  static const String getProfile= "/student/profile";
  static const String forgotPassword = "/school/auth/student-forgot-password";
  static const String resetPassword = "/school/auth/student-reset-password";

  // Quiz Endpoints yeta xa
  static const String getQuiz = "/student/quiz";
  static const String getActiveQuiz = "/student/active-quiz";
  static const String submitAnswer = "/student/submit-answer";
  static const String nextQuestion = "/student/next-question";


  //Resources Endpoints yeta xa
  static const String getResources = "/resources/student-resources";


  //Results ko endpoints yetta xa
  static const String getMyResults = "results/student/results";
  // Constant for connection timeout
  // static const Duration connectionTimeout = Duration(seconds: 10);
  // static const Duration receiveTimeout = Duration(seconds: 10);
}