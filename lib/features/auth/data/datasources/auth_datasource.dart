import 'package:adaptive_quiz/core/services/hive/hive_service.dart';
import 'package:adaptive_quiz/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDatasource {
  AuthHiveModel? login(String email, String password);
}

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService hiveService;
  AuthLocalDatasource(this.hiveService);

  @override
  AuthHiveModel? login(String email, String password) {
    return hiveService.login(email, password);
  }
}
