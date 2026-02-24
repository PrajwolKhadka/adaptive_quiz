import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/result_entity.dart';

abstract interface class IResultRepository {
  Future<Either<Failure, List<QuizHistoryEntity>>> getMyHistory();
  Future<Either<Failure, Map<String, List<SubjectGraphPoint>>>> getPerformanceGraph();
  Future<Either<Failure, QuizResultDetailEntity>> getMyResultDetail(String quizId);
}