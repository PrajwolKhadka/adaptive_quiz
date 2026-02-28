import '../../domain/entities/quiz_entity.dart';

enum QuizStatus { idle, noQuiz, loading, question, answered, finished, error }

class QuizState {
  final QuizStatus status;
  final String? error;

  final ActiveQuizEntity? activeQuiz;

  final QuizQuestionEntity? currentQuestion;

  final String? selectedOption;
  final bool? wasCorrect;

  final int questionTimer;

  final QuizResultEntity? result;

  final bool isSubmitting;

  QuizState({
    required this.status,
    this.error,
    this.activeQuiz,
    this.currentQuestion,
    this.selectedOption,
    this.wasCorrect,
    required this.questionTimer,
    this.result,
    required this.isSubmitting,
  });

  factory QuizState.initial() =>
      QuizState(status: QuizStatus.idle, questionTimer: 0, isSubmitting: false);

  QuizState copyWith({
    QuizStatus? status,
    String? error,
    ActiveQuizEntity? activeQuiz,
    QuizQuestionEntity? currentQuestion,
    String? selectedOption,
    bool? wasCorrect,
    int? questionTimer,
    QuizResultEntity? result,
    bool? isSubmitting,
    bool clearAnswer = false,
    bool clearQuestion = false,
  }) {
    return QuizState(
      status: status ?? this.status,
      error: error,
      activeQuiz: activeQuiz ?? this.activeQuiz,
      currentQuestion: clearQuestion
          ? null
          : (currentQuestion ?? this.currentQuestion),
      selectedOption: clearAnswer
          ? null
          : (selectedOption ?? this.selectedOption),
      wasCorrect: clearAnswer ? null : (wasCorrect ?? this.wasCorrect),
      questionTimer: questionTimer ?? this.questionTimer,
      result: result ?? this.result,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
