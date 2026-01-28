// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserSessionService {
//   static const _keyToken = "token";
//   static const _keyStudentId = "studentId";
//   static const _keyFullName = "fullName";
//   static const _keyEmail = "email";
//   static const _keyClassName = "className";
//   static const _keyImageUrl = "imageUrl";
//   static const _keyLocalImagePath = "localImagePath";
//
//
//   Future<void> saveUserSession(String username, String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyUsername, username);
//     await prefs.setString(_keyToken, token);
//   }
//
//   Future<void> clearSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_keyUsername);
//     await prefs.remove(_keyToken);
//   }
//
//   Future<String?> getCurrentUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_keyUsername);
//   }
//
//   Future<bool> isLoggedIn() async {
//     final user = await getCurrentUser();
//     return user != null;
//   }
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_keyToken);
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionService {
  static const _keyToken = "token";
  static const _keyStudentId = "studentId";
  static const _keyFullName = "fullName";
  static const _keyEmail = "email";
  static const _keyClassName = "className";
  static const _keyImageUrl = "imageUrl";
  static const _keyLocalImagePath = "localImagePath";

  Future<void> saveStudentSession({
    required String token,
    required String studentId,
    required String fullName,
    required String email,
    required String className,
    String? imageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyStudentId, studentId);
    await prefs.setString(_keyFullName, fullName);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyClassName, className);
    if (imageUrl != null) {
      await prefs.setString(_keyImageUrl, imageUrl);
    }
  }

  Future<void> saveLocalProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocalImagePath, path);
  }

  Future<Map<String, String?>> getProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "fullName": prefs.getString(_keyFullName),
      "email": prefs.getString(_keyEmail),
      "className": prefs.getString(_keyClassName),
      "imageUrl": prefs.getString(_keyImageUrl),
      "localImagePath": prefs.getString(_keyLocalImagePath),
    };
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyStudentId);
    await prefs.remove(_keyFullName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyClassName);
    await prefs.remove(_keyImageUrl);
    await prefs.remove(_keyLocalImagePath);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }
}
