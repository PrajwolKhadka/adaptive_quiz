import 'package:shared_preferences/shared_preferences.dart';

class AppLockService {
  static const _key = 'app_lock_enabled';

  /// Default is false — user must explicitly enable it
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}