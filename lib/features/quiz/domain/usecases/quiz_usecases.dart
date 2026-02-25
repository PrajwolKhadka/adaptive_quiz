import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/quiz_entity.dart';
import '../repositories/i_quiz_repository.dart';

class GetActiveQuizUsecase {
  final IQuizRepository _repository;
  GetActiveQuizUsecase(this._repository);

  Future<Either<Failure, ActiveQuizEntity>> call() {
    return _repository.getActiveQuiz();
  }
}

class GetNextQuestionUsecase {
  final IQuizRepository _repository;
  GetNextQuestionUsecase(this._repository);

  // Returns either QuizQuestionEntity or QuizResultEntity
  Future<Either<Failure, dynamic>> call(String quizId) {
    return _repository.getNextQuestion(quizId);
  }
}

class SubmitAnswerUsecase {
  final IQuizRepository _repository;
  SubmitAnswerUsecase(this._repository);

  Future<Either<Failure, SubmitAnswerEntity>> call({
    required String quizId,
    required String questionId,
    required String selectedOption,
    required int timeTaken,
  }) {
    return _repository.submitAnswer(
      quizId: quizId,
      questionId: questionId,
      selectedOption: selectedOption,
      timeTaken: timeTaken,
    );
  }
}