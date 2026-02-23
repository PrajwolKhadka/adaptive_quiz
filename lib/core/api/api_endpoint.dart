

import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._(); // Private constructor to prevent instantiation

  // static const String baseUrl = "http://10.0.2.2:5000/api/";

  // Configuration
  static const bool isPhysicalDevice = false;
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
  static String get baseUrl => '$serverUrl/api/v1';
  static String get mediaServerUrl => serverUrl;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  // Auth Endpoints
  static const String login = "school/auth/student-login";
  static const String changePassword = "school/auth/change-password";
  static const String uploadProfilePicture = "student/profile-picture";
  static const String getProfile= "student/profile";

  // Quiz Endpoints
  static const String getQuestions = "quisz/questions";

  // Constant for connection timeout
  // static const Duration connectionTimeout = Duration(seconds: 10);
  // static const Duration receiveTimeout = Duration(seconds: 10);
}