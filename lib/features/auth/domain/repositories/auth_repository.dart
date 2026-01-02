import '../entities/auth_entity.dart';

abstract class AuthRepository {
  AuthEntity? login(String email, String password);
}
