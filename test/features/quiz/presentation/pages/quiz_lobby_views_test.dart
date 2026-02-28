import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/features/quiz/domain/entities/quiz_entity.dart';
import 'package:adaptive_quiz/features/quiz/domain/usecases/quiz_usecases.dart';
import 'package:adaptive_quiz/features/quiz/presentation/pages/quiz_lobby_views.dart';
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

  setUp(() {
    mockGetActive = MockGetActiveQuizUsecase();
    mockGetNext = MockGetNextQuestionUsecase();
    mockSubmit = MockSubmitAnswerUsecase();

    when(() => mockGetActive()).thenAnswer(
      (_) async => const Right(
        ActiveQuizEntity(available: true, quizId: 'q1', subject: 'Math'),
      ),
    );
  });

  Widget buildLobby(QuizState state) {
    return ProviderScope(
      overrides: [
        getActiveQuizUsecaseProvider.overrideWithValue(mockGetActive),
        getNextQuestionUsecaseProvider.overrideWithValue(mockGetNext),
        submitAnswerUsecaseProvider.overrideWithValue(mockSubmit),
      ],
      child: MaterialApp(
        home: Scaffold(body: QuizLobbyView(state: state)),
      ),
    );
  }

  testWidgets('QuizLobbyView shows Ready to begin text', (tester) async {
    final state = QuizState(
      status: QuizStatus.idle,
      questionTimer: 0,
      isSubmitting: false,
      activeQuiz: const ActiveQuizEntity(
        available: true,
        quizId: 'q1',
        subject: 'Math',
      ),
    );

    await tester.pumpWidget(buildLobby(state));
    await tester.pump();

    expect(find.textContaining('begin'), findsOneWidget);
  });

  testWidgets('QuizLobbyView shows subject name', (tester) async {
    final state = QuizState(
      status: QuizStatus.idle,
      questionTimer: 0,
      isSubmitting: false,
      activeQuiz: const ActiveQuizEntity(
        available: true,
        quizId: 'q1',
        subject: 'Math',
      ),
    );

    await tester.pumpWidget(buildLobby(state));
    await tester.pump();

    expect(find.text('MATH'), findsOneWidget);
  });

  testWidgets('QuizLobbyView shows Start Quiz button', (tester) async {
    final state = QuizState(
      status: QuizStatus.idle,
      questionTimer: 0,
      isSubmitting: false,
      activeQuiz: const ActiveQuizEntity(
        available: true,
        quizId: 'q1',
        subject: 'Math',
      ),
    );

    await tester.pumpWidget(buildLobby(state));
    await tester.pump();

    expect(find.text('Start Quiz'), findsOneWidget);
  });

  testWidgets('QuizNoQuizView shows no quiz available text', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getActiveQuizUsecaseProvider.overrideWithValue(mockGetActive),
          getNextQuestionUsecaseProvider.overrideWithValue(mockGetNext),
          submitAnswerUsecaseProvider.overrideWithValue(mockSubmit),
        ],
        child: const MaterialApp(home: Scaffold(body: QuizNoQuizView())),
      ),
    );
    await tester.pump();

    expect(find.textContaining('No quiz'), findsOneWidget);
    expect(find.text('Refresh'), findsOneWidget);
  });
}
