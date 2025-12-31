import 'package:adaptive_quiz/core/constants/hive_table_constant.dart';
import 'package:hive/hive.dart';
import '../../../features/auth/data/models/auth_hive_model.dart';

class HiveService {
  Future<void> openBox() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.userTable);
  }

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.userTable);

  // DUMMY USERS
  Future<void> seedUsers() async {
    if (_authBox.isNotEmpty) return;

    await _authBox.addAll([
      AuthHiveModel(
        userId: "1",
        email: "admin@gmail.com",
        password: "admin123",
      ),
      AuthHiveModel(
        userId: "2",
        email: "user@gmail.com",
        password: "user123",
      ),
    ]);
  }

  // LOGIN
  AuthHiveModel? login(String email, String password) {
    try {
      return _authBox.values.firstWhere(
            (user) => user.email == email && user.password == password,
      );
    } catch (_) {
      return null;
    }
  }
}
