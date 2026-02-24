import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/resource_entity.dart';
import '../repositories/i_resource_repository.dart';

class GetStudentResourcesUsecase {
  final IResourceRepository _repository;

  GetStudentResourcesUsecase(this._repository);

  Future<Either<Failure, List<ResourceEntity>>> call() {
    return _repository.getStudentResources();
  }
}