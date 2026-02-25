import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/common_provider.dart';
import '../../data/datasources/remote/quiz_remote_datasource.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import '../../domain/repositories/i_quiz_repository.dart';
import '../../domain/usecases/quiz_usecases.dart';
import '../state/quiz_state.dart';
import '../view_model/quiz_view_model.dart';

// 1. Remote Datasource
final quizRemoteDatasourceProvider = Provider<IQuizRemoteDatasource>((ref) {
  return QuizRemoteDatasource(
    ref.read(apiClientProvider),
    ref.read(userSessionServiceProvider),
  );
});

// 2. Repository
final quizRepositoryProvider = Provider<IQuizRepository>((ref) {
  return QuizRepositoryImpl(ref.read(quizRemoteDatasourceProvider));
});

// 3. Use Cases
final getActiveQuizUsecaseProvider = Provider<GetActiveQuizUsecase>((ref) {
  return GetActiveQuizUsecase(ref.read(quizRepositoryProvider));
});

final getNextQuestionUsecaseProvider = Provider<GetNextQuestionUsecase>((ref) {
  return GetNextQuestionUsecase(ref.read(quizRepositoryProvider));
});

final submitAnswerUsecaseProvider = Provider<SubmitAnswerUsecase>((ref) {
  return SubmitAnswerUsecase(ref.read(quizRepositoryProvider));
});

// 4. ViewModel
final quizViewModelProvider =
NotifierProvider<QuizViewModel, QuizState>(
      () => QuizViewModel(),
);