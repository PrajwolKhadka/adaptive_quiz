import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, String>> uploadProfilePicture(String imagePath);
}