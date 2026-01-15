import 'package:adaptive_quiz/core/constants/hive_table_constant.dart';
import 'package:adaptive_quiz/features/auth/data/models/auth_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AuthHiveModelAdapter());
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.userTable);

    final box = Hive.box<AuthHiveModel>(HiveTableConstant.userTable);
    if (box.isEmpty) {
      box.addAll([
        AuthHiveModel(
            userId: '1', email: "kavya_ram121", password: "123456"),
        AuthHiveModel(
            userId: '2', email: "ops_sita232", password: "password"),
      ]);
    }
  }

  Box<AuthHiveModel> get userBox => Hive.box<AuthHiveModel>(HiveTableConstant.userTable);

  AuthHiveModel? login(String email, String password) {
    final box = userBox;
    try {
      return box.values.firstWhere(
            (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
