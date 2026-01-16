import 'package:adaptive_quiz/core/constants/hive_table_constant.dart';
import 'package:adaptive_quiz/features/auth/data/models/auth_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(AuthHiveModelAdapter());

    await Hive.openBox<AuthHiveModel>(HiveTableConstant.userTable);
  }


  Box<AuthHiveModel> get _userBox => Hive.box<AuthHiveModel>(HiveTableConstant.userTable);

  // 1. Save user after successful login
  Future<void> saveUser(AuthHiveModel user) async {
    await _userBox.clear(); // Clear old sessions first
    await _userBox.put('currentUser', user);
  }

  // 2. Retrieve user for auto-login or profile display
  AuthHiveModel? getUser() {
    return _userBox.get('currentUser');
  }

  // 3. Logout
  Future<void> logout() async {
    await _userBox.clear();
  }
}