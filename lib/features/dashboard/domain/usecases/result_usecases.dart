import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/result_entity.dart';
import '../repositories/i_result_repository.dart';

class GetMyHistoryUsecase {
  final IResultRepository _repository;
  GetMyHistoryUsecase(this._repository);

  Future<Either<Failure, List<QuizHistoryEntity>>> call() {
    return _repository.getMyHistory();
  }
}

class GetPerformanceGraphUsecase {
  final IResultRepository _repository;
  GetPerformanceGraphUsecase(this._repository);

  Future<Either<Failure, Map<String, List<SubjectGraphPoint>>>> call() {
    return _repository.getPerformanceGraph();
  }
}

class GetMyResultDetailUsecase {
  final IResultRepository _repository;
  GetMyResultDetailUsecase(this._repository);

  Future<Either<Failure, QuizResultDetailEntity>> call(String quizId) {
    return _repository.getMyResultDetail(quizId);
  }
}