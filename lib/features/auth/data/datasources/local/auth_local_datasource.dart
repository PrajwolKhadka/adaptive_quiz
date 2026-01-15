import 'package:adaptive_quiz/core/services/hive/hive_service.dart';
import 'package:adaptive_quiz/features/auth/data/models/auth_hive_model.dart';
import '../auth_datasource.dart';

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService hiveService;

  AuthLocalDatasource(this.hiveService);

  @override
  AuthHiveModel? login(String email, String password) {
    return hiveService.login(email, password);
  }
}
