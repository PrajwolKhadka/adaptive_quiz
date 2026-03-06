@Tags(['unit'])
library;

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/quiz/domain/entities/quiz_entity.dart';
import 'package:adaptive_quiz/features/quiz/domain/usecases/quiz_usecases.dart';
import 'package:adaptive_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:adaptive_quiz/features/quiz/presentation/state/quiz_state.dart';

class MockGetActiveQuizUsecase extends Mock implements GetActiveQuizUsecase {}

class MockGetNextQuestionUsecase extends Mock
    implements GetNextQuestionUsecase {}

class MockSubmitAnswerUsecase extends Mock implements SubmitAnswerUsecase {}

void main() {
  late MockGetActiveQuizUsecase mockGetActive;
  late MockGetNextQuestionUsecase mockGetNext;
  late MockSubmitAnswerUsecase mockSubmit;
  late ProviderContainer container;

  const tActiveQuiz = ActiveQuizEntity(
    available: true,
    quizId: 'quiz1',
    subject: 'Math',
  );

  const tNoQuiz = ActiveQuizEntity(available: false);

  final tQuestion = QuizQuestionEntity(
    id: 'q1',
    text: 'What is 2+2?',
    options: const [
      QuizOptionEntity(key: 'A', text: '3'),
      QuizOptionEntity(key: 'B', text: '4'),
    ],
    difficulty: 'easy',
    subject: 'Math',
    progress: const QuizProgressEntity(answered: 0, total: 10),
  );

  const tSubmitResult = SubmitAnswerEntity(correct: true);
  const tFailure = ApiFailure(message: 'Server error', statusCode: 500);

  setUp(() {
    mockGetActive = MockGetActiveQuizUsecase();
    mockGetNext = MockGetNextQuestionUsecase();
    mockSubmit = MockSubmitAnswerUsecase();

    // Stub for auto-load on build
    when(
      () => mockGetActive(),
    ).thenAnswer((_) async => const Right(tActiveQuiz));

    container = ProviderContainer(
      overrides: [
        getActiveQuizUsecaseProvider.overrideWithValue(mockGetActive),
        getNextQuestionUsecaseProvider.overrideWithValue(mockGetNext),
        submitAnswerUsecaseProvider.overrideWithValue(mockSubmit),
      ],
    );
    addTearDown(container.dispose);
  });

  test('initial state is correct', () {
    final state = container.read(quizViewModelProvider);
    expect(state.status, QuizStatus.idle);
    expect(state.activeQuiz, null);
    expect(state.isSubmitting, false);
  });

  test(
    'checkActiveQuiz sets status to idle and stores activeQuiz when available',
    () async {
      when(
        () => mockGetActive(),
      ).thenAnswer((_) async => const Right(tActiveQuiz));

      await container.read(quizViewModelProvider.notifier).checkActiveQuiz();

      final state = container.read(quizViewModelProvider);
      expect(state.status, QuizStatus.idle);
      expect(state.activeQuiz?.quizId, 'quiz1');
    },
  );

  test('checkActiveQuiz sets status to noQuiz when not available', () async {
    when(() => mockGetActive()).thenAnswer((_) async => const Right(tNoQuiz));

    await container.read(quizViewModelProvider.notifier).checkActiveQuiz();

    final state = container.read(quizViewModelProvider);
    expect(state.status, QuizStatus.noQuiz);
  });

  test('checkActiveQuiz sets error status on failure', () async {
    when(() => mockGetActive()).thenAnswer((_) async => const Left(tFailure));

    await container.read(quizViewModelProvider.notifier).checkActiveQuiz();

    final state = container.read(quizViewModelProvider);
    expect(state.status, QuizStatus.error);
    expect(state.error, 'Server error');
  });

  test('startQuiz fetches next question and sets status to question', () async {
    // Setup active quiz first
    when(
      () => mockGetActive(),
    ).thenAnswer((_) async => const Right(tActiveQuiz));
    await container.read(quizViewModelProvider.notifier).checkActiveQuiz();

    when(() => mockGetNext('quiz1')).thenAnswer((_) async => Right(tQuestion));

    await container.read(quizViewModelProvider.notifier).startQuiz();

    final state = container.read(quizViewModelProvider);
    expect(state.status, QuizStatus.question);
    expect(state.currentQuestion?.id, 'q1');
  });

  test('submitAnswer sets status to answered with correct result', () async {
    // Setup active quiz and question
    when(
      () => mockGetActive(),
    ).thenAnswer((_) async => const Right(tActiveQuiz));
    await container.read(quizViewModelProvider.notifier).checkActiveQuiz();

    when(() => mockGetNext('quiz1')).thenAnswer((_) async => Right(tQuestion));
    await container.read(quizViewModelProvider.notifier).startQuiz();

    when(
      () => mockSubmit(
        quizId: 'quiz1',
        questionId: 'q1',
        selectedOption: 'B',
        timeTaken: any(named: 'timeTaken'),
      ),
    ).thenAnswer((_) async => const Right(tSubmitResult));

    await container.read(quizViewModelProvider.notifier).submitAnswer('B');

    final state = container.read(quizViewModelProvider);
    expect(state.status, QuizStatus.answered);
    expect(state.wasCorrect, true);
    expect(state.isSubmitting, false);
  });
}
