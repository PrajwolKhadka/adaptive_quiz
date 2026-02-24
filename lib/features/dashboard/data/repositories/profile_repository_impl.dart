import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDatasource _remoteDatasource;

  ProfileRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final model = await _remoteDatasource.getProfile();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ApiFailure(
        message: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(String imagePath) async {
    try {
      final imageUrl = await _remoteDatasource.uploadProfilePicture(imagePath);
      return Right(imageUrl);
    } catch (e) {
      return Left(ApiFailure(
        message: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}