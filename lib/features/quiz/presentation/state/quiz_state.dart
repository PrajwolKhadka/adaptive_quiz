import '../../domain/entities/quiz_entity.dart';

enum QuizStatus {
  idle,         // not started, checking for active quiz
  noQuiz,       // no active quiz available
  loading,      // fetching question
  question,     // showing a question
  answered,     // answer submitted, showing feedback
  finished,     // quiz done, showing result
  error,
}

class QuizState {
  final QuizStatus status;
  final String? error;

  // Active quiz info
  final ActiveQuizEntity? activeQuiz;

  // Current question
  final QuizQuestionEntity? currentQuestion;

  // Answer feedback
  final String? selectedOption;
  final bool? wasCorrect;

  // Timer (seconds elapsed for current question)
  final int questionTimer;

  // Quiz result
  final QuizResultEntity? result;

  // Submitting flag to prevent double tap
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

  factory QuizState.initial() => QuizState(
    status: QuizStatus.idle,
    questionTimer: 0,
    isSubmitting: false,
  );

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
      currentQuestion:
      clearQuestion ? null : (currentQuestion ?? this.currentQuestion),
      selectedOption: clearAnswer ? null : (selectedOption ?? this.selectedOption),
      wasCorrect: clearAnswer ? null : (wasCorrect ?? this.wasCorrect),
      questionTimer: questionTimer ?? this.questionTimer,
      result: result ?? this.result,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}