import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final IAuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  AuthEntity? login(String email, String password) {
    final user = datasource.login(email, password);
    return user?.toEntity();
  }
}
