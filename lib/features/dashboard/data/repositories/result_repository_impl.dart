import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/result_entity.dart';
import '../../domain/repositories/i_result_repository.dart';
import '../datasources/remote/result_remote_datasource.dart';

class ResultRepositoryImpl implements IResultRepository {
  final IResultRemoteDatasource _remoteDatasource;

  ResultRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<QuizHistoryEntity>>> getMyHistory() async {
    try {
      final models = await _remoteDatasource.getMyHistory();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ApiFailure(
          message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<SubjectGraphPoint>>>>
  getPerformanceGraph() async {
    try {
      final graph = await _remoteDatasource.getPerformanceGraph();
      return Right(graph);
    } catch (e) {
      return Left(ApiFailure(
          message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, QuizResultDetailEntity>> getMyResultDetail(
      String quizId) async {
    try {
      final model = await _remoteDatasource.getMyResultDetail(quizId);
      return Right(model.toDetailEntity());
    } catch (e) {
      return Left(ApiFailure(
          message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}