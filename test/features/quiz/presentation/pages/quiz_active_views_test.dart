import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/features/quiz/domain/entities/quiz_entity.dart';
import 'package:adaptive_quiz/features/quiz/domain/usecases/quiz_usecases.dart';
import 'package:adaptive_quiz/features/quiz/presentation/pages/quiz_active_views.dart';
import 'package:adaptive_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:adaptive_quiz/features/quiz/presentation/state/quiz_state.dart';

class MockGetActiveQuizUsecase extends Mock implements GetActiveQuizUsecase {}

class MockGetNextQuestionUsecase extends Mock
    implements GetNextQuestionUsecase {}

class MockSubmitAnswerUsecase extends Mock implements SubmitAnswerUsecase {}

final tQuestion = QuizQuestionEntity(
  id: 'q1',
  text: 'What is 2 + 2?',
  options: const [
    QuizOptionEntity(key: 'A', text: '3'),
    QuizOptionEntity(key: 'B', text: '4'),
    QuizOptionEntity(key: 'C', text: '5'),
  ],
  difficulty: 'EASY',
  subject: 'Math',
  progress: const QuizProgressEntity(answered: 0, total: 5),
);

Widget buildQuestionView(
  QuizState state, {
  MockSubmitAnswerUsecase? mockSubmit,
  MockGetActiveQuizUsecase? mockGetActive,
  MockGetNextQuestionUsecase? mockGetNext,
}) {
  final submit = mockSubmit ?? MockSubmitAnswerUsecase();
  final active = mockGetActive ?? MockGetActiveQuizUsecase();
  final next = mockGetNext ?? MockGetNextQuestionUsecase();

  when(() => active()).thenAnswer(
    (_) async => const Right(
      ActiveQuizEntity(available: true, quizId: 'quiz1', subject: 'Math'),
    ),
  );

  return ProviderScope(
    overrides: [
      getActiveQuizUsecaseProvider.overrideWithValue(active),
      getNextQuestionUsecaseProvider.overrideWithValue(next),
      submitAnswerUsecaseProvider.overrideWithValue(submit),
    ],
    child: MaterialApp(
      home: Scaffold(body: QuizQuestionView(state: state)),
    ),
  );
}

void main() {
  testWidgets('QuizQuestionView shows question text', (tester) async {
    final state = QuizState(
      status: QuizStatus.question,
      questionTimer: 0,
      isSubmitting: false,
      activeQuiz: const ActiveQuizEntity(
        available: true,
        quizId: 'quiz1',
        subject: 'Math',
      ),
      currentQuestion: tQuestion,
    );

    await tester.pumpWidget(buildQuestionView(state));
    await tester.pump();

    expect(find.text('What is 2 + 2?'), findsOneWidget);
  });

  testWidgets('QuizQuestionView shows all answer options', (tester) async {
    final state = QuizState(
      status: QuizStatus.question,
      questionTimer: 0,
      isSubmitting: false,
      activeQuiz: const ActiveQuizEntity(
        available: true,
        quizId: 'quiz1',
        subject: 'Math',
      ),
      currentQuestion: tQuestion,
    );

    await tester.pumpWidget(buildQuestionView(state));
    await tester.pump();

    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('QuizQuestionView shows timer', (tester) async {
    final state = QuizState(
      status: QuizStatus.question,
      questionTimer: 15,
      isSubmitting: false,
      activeQuiz: const ActiveQuizEntity(
        available: true,
        quizId: 'quiz1',
        subject: 'Math',
      ),
      currentQuestion: tQuestion,
    );

    await tester.pumpWidget(buildQuestionView(state));
    await tester.pump();

    expect(find.text('15s'), findsOneWidget);
  });

  testWidgets('QuizQuestionView shows Next Question button after answering', (
    tester,
  ) async {
    final state = QuizState(
      status: QuizStatus.answered,
      questionTimer: 10,
      isSubmitting: false,
      activeQuiz: const ActiveQuizEntity(
        available: true,
        quizId: 'quiz1',
        subject: 'Math',
      ),
      currentQuestion: tQuestion,
      selectedOption: 'B',
      wasCorrect: true,
    );

    await tester.pumpWidget(buildQuestionView(state));
    await tester.pump();

    expect(find.text('Next Question →'), findsOneWidget);
  });

  testWidgets('QuizResultView shows accuracy percentage', (tester) async {
    final result = QuizResultEntity(
      done: true,
      totalQuestions: 10,
      correctAnswers: 8,
      wrongAnswers: 2,
      timeTakenSeconds: 120,
      aiFeedback: 'Great work!',
    );

    final state = QuizState(
      status: QuizStatus.finished,
      questionTimer: 0,
      isSubmitting: false,
      result: result,
    );

    final mockGetActive = MockGetActiveQuizUsecase();
    when(
      () => mockGetActive(),
    ).thenAnswer((_) async => const Right(ActiveQuizEntity(available: false)));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getActiveQuizUsecaseProvider.overrideWithValue(mockGetActive),
          getNextQuestionUsecaseProvider.overrideWithValue(
            MockGetNextQuestionUsecase(),
          ),
          submitAnswerUsecaseProvider.overrideWithValue(
            MockSubmitAnswerUsecase(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: QuizResultView(state: state)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('80%'), findsOneWidget);
    expect(find.text('Great work!'), findsOneWidget);
  });
}
