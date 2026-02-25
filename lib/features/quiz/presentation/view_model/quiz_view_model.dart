// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../domain/entities/quiz_entity.dart';
// import '../../domain/usecases/quiz_usecases.dart';
// import '../providers/quiz_provider.dart';
// import '../state/quiz_state.dart';
//
// class QuizViewModel extends Notifier<QuizState> {
//   late final GetActiveQuizUsecase _getActiveQuiz;
//   late final GetNextQuestionUsecase _getNextQuestion;
//   late final SubmitAnswerUsecase _submitAnswer;
//
//   Timer? _questionTimer;
//
//   @override
//   QuizState build() {
//     _getActiveQuiz = ref.read(getActiveQuizUsecaseProvider);
//     _getNextQuestion = ref.read(getNextQuestionUsecaseProvider);
//     _submitAnswer = ref.read(submitAnswerUsecaseProvider);
//     Future.microtask(() => checkActiveQuiz());
//     ref.onDispose(() => _questionTimer?.cancel());
//     return QuizState.initial();
//   }
//
//   // ── Check if there's an active quiz ──────────────────────────────
//   Future<void> checkActiveQuiz() async {
//     state = state.copyWith(status: QuizStatus.loading);
//
//     final result = await _getActiveQuiz();
//
//     result.fold(
//           (failure) =>
//       state = state.copyWith(status: QuizStatus.error, error: failure.message),
//           (activeQuiz) {
//         if (!activeQuiz.available) {
//           state = state.copyWith(status: QuizStatus.noQuiz);
//         } else {
//           state = state.copyWith(
//             status: QuizStatus.idle,
//             activeQuiz: activeQuiz,
//           );
//         }
//       },
//     );
//   }
//
//   // ── Start quiz — fetch first question ────────────────────────────
//   Future<void> startQuiz() async {
//     if (state.activeQuiz?.quizId == null) return;
//     await _fetchNextQuestion();
//   }
//
//   // ── Fetch next question ──────────────────────────────────────────
//   Future<void> _fetchNextQuestion() async {
//     state = state.copyWith(
//       status: QuizStatus.loading,
//       clearAnswer: true,
//       error: null,
//     );
//
//     final result = await _getNextQuestion(state.activeQuiz!.quizId!);
//
//     result.fold(
//           (failure) =>
//       state = state.copyWith(status: QuizStatus.error, error: failure.message),
//           (data) {
//         if (data is QuizResultEntity) {
//           _questionTimer?.cancel();
//           state = state.copyWith(
//             status: QuizStatus.finished,
//             result: data,
//           );
//         } else if (data is QuizQuestionEntity) {
//           _startTimer();
//           state = state.copyWith(
//             status: QuizStatus.question,
//             currentQuestion: data,
//             questionTimer: 0,
//           );
//         }
//       },
//     );
//   }
//
//   // ── Submit answer ────────────────────────────────────────────────
//   Future<void> submitAnswer(String selectedOption) async {
//     if (state.isSubmitting) return;
//     if (state.currentQuestion == null) return;
//
//     _questionTimer?.cancel();
//     final timeTaken = state.questionTimer;
//
//     state = state.copyWith(
//       isSubmitting: true,
//       selectedOption: selectedOption,
//     );
//
//     final result = await _submitAnswer(
//       quizId: state.activeQuiz!.quizId!,
//       questionId: state.currentQuestion!.id,
//       selectedOption: selectedOption,
//       timeTaken: timeTaken,
//     );
//
//     result.fold(
//           (failure) => state = state.copyWith(
//         isSubmitting: false,
//         status: QuizStatus.error,
//         error: failure.message,
//       ),
//           (submitResult) {
//         state = state.copyWith(
//           status: QuizStatus.answered,
//           wasCorrect: submitResult.correct,
//           isSubmitting: false,
//         );
//       },
//     );
//   }
//
//   // ── Move to next question after showing feedback ─────────────────
//   Future<void> nextQuestion() async {
//     await _fetchNextQuestion();
//   }
//
//   // ── Timer logic ──────────────────────────────────────────────────
//   void _startTimer() {
//     _questionTimer?.cancel();
//     _questionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       state = state.copyWith(questionTimer: state.questionTimer + 1);
//     });
//   }
//
//   // ── Reset quiz (go back to lobby) ────────────────────────────────
//   void reset() {
//     _questionTimer?.cancel();
//     state = QuizState.initial();
//     checkActiveQuiz();
//   }
// }

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/usecases/quiz_usecases.dart';
import '../providers/quiz_provider.dart';
import '../state/quiz_state.dart';

class QuizViewModel extends Notifier<QuizState> {
  late final GetActiveQuizUsecase _getActiveQuiz;
  late final GetNextQuestionUsecase _getNextQuestion;
  late final SubmitAnswerUsecase _submitAnswer;
  Timer? _questionTimer;

  @override
  QuizState build() {
    _getActiveQuiz = ref.read(getActiveQuizUsecaseProvider);
    _getNextQuestion = ref.read(getNextQuestionUsecaseProvider);
    _submitAnswer = ref.read(submitAnswerUsecaseProvider);
    Future.microtask(() => checkActiveQuiz());
    ref.onDispose(() => _questionTimer?.cancel());
    return QuizState.initial();
  }

  Future<void> checkActiveQuiz() async {
    state = state.copyWith(status: QuizStatus.loading);
    final result = await _getActiveQuiz();
    result.fold(
          (failure) => state =
          state.copyWith(status: QuizStatus.error, error: failure.message),
          (activeQuiz) {
        if (!activeQuiz.available) {
          state = state.copyWith(status: QuizStatus.noQuiz);
        } else {
          state = state.copyWith(
              status: QuizStatus.idle, activeQuiz: activeQuiz);
        }
      },
    );
  }

  // If quiz already completed this session, jump straight to result
  void showExistingResult() {
    if (state.result != null) {
      state = state.copyWith(status: QuizStatus.finished);
    }
  }

  Future<void> startQuiz() async {
    if (state.activeQuiz?.quizId == null) return;
    await _fetchNextQuestion();
  }

  Future<void> _fetchNextQuestion() async {
    state = state.copyWith(
        status: QuizStatus.loading, clearAnswer: true, error: null);
    final result = await _getNextQuestion(state.activeQuiz!.quizId!);
    result.fold(
          (failure) => state =
          state.copyWith(status: QuizStatus.error, error: failure.message),
          (data) {
        if (data is QuizResultEntity) {
          _questionTimer?.cancel();
          state = state.copyWith(status: QuizStatus.finished, result: data);
        } else if (data is QuizQuestionEntity) {
          _startTimer();
          state = state.copyWith(
            status: QuizStatus.question,
            currentQuestion: data,
            questionTimer: 0,
          );
        }
      },
    );
  }

  Future<void> submitAnswer(String selectedOption) async {
    if (state.isSubmitting || state.currentQuestion == null) return;
    _questionTimer?.cancel();
    final timeTaken = state.questionTimer;
    state = state.copyWith(isSubmitting: true, selectedOption: selectedOption);
    final result = await _submitAnswer(
      quizId: state.activeQuiz!.quizId!,
      questionId: state.currentQuestion!.id,
      selectedOption: selectedOption,
      timeTaken: timeTaken,
    );
    result.fold(
          (failure) => state = state.copyWith(
          isSubmitting: false,
          status: QuizStatus.error,
          error: failure.message),
          (submitResult) => state = state.copyWith(
          status: QuizStatus.answered,
          wasCorrect: submitResult.correct,
          isSubmitting: false),
    );
  }

  Future<void> nextQuestion() async => await _fetchNextQuestion();

  void _startTimer() {
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(questionTimer: state.questionTimer + 1);
    });
  }

  void reset() {
    _questionTimer?.cancel();
    state = QuizState.initial();
    checkActiveQuiz();
  }
}