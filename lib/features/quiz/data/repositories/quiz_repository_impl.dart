import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/repositories/i_quiz_repository.dart';
import '../datasources/remote/quiz_remote_datasource.dart';

class QuizRepositoryImpl implements IQuizRepository {
  final IQuizRemoteDatasource _remoteDatasource;

  QuizRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, ActiveQuizEntity>> getActiveQuiz() async {
    try {
      final result = await _remoteDatasource.getActiveQuiz();
      return Right(result);
    } catch (e) {
      return Left(
          ApiFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getNextQuestion(String quizId) async {
    try {
      final result = await _remoteDatasource.getNextQuestion(quizId);
      return Right(result);
    } catch (e) {
      return Left(
          ApiFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, SubmitAnswerEntity>> submitAnswer({
    required String quizId,
    required String questionId,
    required String selectedOption,
    required int timeTaken,
  }) async {
    try {
      final result = await _remoteDatasource.submitAnswer(
        quizId: quizId,
        questionId: questionId,
        selectedOption: selectedOption,
        timeTaken: timeTaken,
      );
      return Right(result);
    } catch (e) {
      return Left(
          ApiFailure(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}