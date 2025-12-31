import 'package:adaptive_quiz/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDatasource {
  AuthHiveModel? login(String email, String password);
}
