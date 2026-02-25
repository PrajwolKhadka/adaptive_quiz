import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/quiz_entity.dart';

abstract interface class IQuizRepository {
  Future<Either<Failure, ActiveQuizEntity>> getActiveQuiz();
  Future<Either<Failure, dynamic>> getNextQuestion(String quizId);
  // returns QuizQuestionEntity OR QuizResultEntity (done: true)
  Future<Either<Failure, SubmitAnswerEntity>> submitAnswer({
    required String quizId,
    required String questionId,
    required String selectedOption,
    required int timeTaken,
  });
}