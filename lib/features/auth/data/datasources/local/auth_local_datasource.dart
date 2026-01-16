import 'package:adaptive_quiz/core/services/hive/hive_service.dart';
import 'package:adaptive_quiz/features/auth/data/models/auth_hive_model.dart';


abstract interface class IAuthLocalDatasource {
  Future<void> saveStudent(AuthHiveModel student);
  Future<AuthHiveModel?> getLoggedInStudent();
  Future<void> deleteStudent();
}

class AuthLocalDatasource implements IAuthLocalDatasource {
  final HiveService _hiveService;

  AuthLocalDatasource(this._hiveService);

  @override
  Future<void> saveStudent(AuthHiveModel student) async {
    return await _hiveService.saveUser(student);
  }

  @override
  Future<AuthHiveModel?> getLoggedInStudent() async {
    return _hiveService.getUser();
  }

  @override
  Future<void> deleteStudent() async {
    return await _hiveService.logout();
  }
}