import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/resource_entity.dart';
import '../../domain/repositories/i_resource_repository.dart';
import '../datasources/remote/resource_remote_datasource.dart';

class ResourceRepositoryImpl implements IResourceRepository {
  final IResourceRemoteDatasource _remoteDatasource;

  ResourceRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<ResourceEntity>>> getStudentResources() async {
    try {
      final models = await _remoteDatasource.getStudentResources();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ApiFailure(
        message: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}