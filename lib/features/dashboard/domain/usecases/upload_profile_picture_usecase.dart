import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/i_profile_repository.dart';

class UploadProfilePictureUsecase {
  final IProfileRepository _repository;

  UploadProfilePictureUsecase(this._repository);

  Future<Either<Failure, String>> call(String imagePath) {
    return _repository.uploadProfilePicture(imagePath);
  }
}