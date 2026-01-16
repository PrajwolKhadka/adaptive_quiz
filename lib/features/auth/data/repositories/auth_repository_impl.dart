import 'package:adaptive_quiz/features/auth/data/models/auth_api_model.dart';
import 'package:adaptive_quiz/features/auth/domain/entities/auth_response.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDatasource _authRemoteDatasource;
  final IAuthLocalDatasource _authLocalDatasource;

  AuthRepositoryImpl(this._authRemoteDatasource, this._authLocalDatasource);

  @override
  Future<Either<Failure, AuthResponse>> loginStudent(String email, String password) async {
    try {
      final authApiModel = await _authRemoteDatasource.login(email, password);

      // Save locally if not first login (optional)
      if (!authApiModel.isFirstLogin) {
        await _authLocalDatasource.saveStudent(authApiModel.toHiveModel());
      }

      return Right(authApiModel.toEntity()); // Return the AuthResponse
    } catch (e) {
      return Left(
        ApiFailure(
          message: e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Invalid credentials',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(String newPassword) async{
    try {
      await _authRemoteDatasource.changePassword(newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
