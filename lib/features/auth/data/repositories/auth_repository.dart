import 'package:adaptive_quiz/features/auth/domain/entities/auth_response.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, AuthResponse>> loginStudent(String email, String password);
}
