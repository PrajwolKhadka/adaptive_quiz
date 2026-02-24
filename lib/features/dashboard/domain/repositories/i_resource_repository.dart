import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/resource_entity.dart';

abstract interface class IResourceRepository {
  Future<Either<Failure, List<ResourceEntity>>> getStudentResources();
}