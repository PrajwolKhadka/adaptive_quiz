import 'dart:async' show Completer;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/api/api_client.dart';
import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/core/providers/common_provider.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/result_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/result_usecases.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/result_screen_page.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/result_provider.dart';

class MockGetMyHistoryUsecase extends Mock implements GetMyHistoryUsecase {}

class MockGetPerformanceGraphUsecase extends Mock
    implements GetPerformanceGraphUsecase {}

class MockGetMyResultDetailUsecase extends Mock
    implements GetMyResultDetailUsecase {}

class MockApiClient extends Mock implements ApiClient {}

final tQuizInfo = const QuizInfoEntity(
  id: 'q1',
  subject: 'Math',
  classLevel: 10,
);

final tHistoryList = [
  QuizHistoryEntity(
    resultId: 'res1',
    quiz: tQuizInfo,
    totalQuestions: 10,
    correctAnswers: 8,
    wrongAnswers: 2,
    accuracy: 80.0,
    timeTaken: 120,
    completedAt: DateTime(2024, 1, 1),
  ),
];

Widget buildResultScreen({
  required MockGetMyHistoryUsecase mockHistory,
  required MockGetPerformanceGraphUsecase mockGraph,
  required MockGetMyResultDetailUsecase mockDetail,
}) {
  return ProviderScope(
    overrides: [
      getMyHistoryUsecaseProvider.overrideWithValue(mockHistory),
      getPerformanceGraphUsecaseProvider.overrideWithValue(mockGraph),
      getMyResultDetailUsecaseProvider.overrideWithValue(mockDetail),
      apiClientProvider.overrideWithValue(MockApiClient()),
    ],
    child: const MaterialApp(home: Scaffold(body: ResultScreen())),
  );
}

void main() {
  late MockGetMyHistoryUsecase mockHistory;
  late MockGetPerformanceGraphUsecase mockGraph;
  late MockGetMyResultDetailUsecase mockDetail;

  setUp(() {
    mockHistory = MockGetMyHistoryUsecase();
    mockGraph = MockGetPerformanceGraphUsecase();
    mockDetail = MockGetMyResultDetailUsecase();

    when(() => mockGraph()).thenAnswer(
      (_) async => Right<Failure, Map<String, List<SubjectGraphPoint>>>({}),
    );
  });

  testWidgets('ResultScreen shows loading indicator initially', (tester) async {
    final completer = Completer<Either<Failure, List<QuizHistoryEntity>>>();

    when(() => mockHistory()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      buildResultScreen(
        mockHistory: mockHistory,
        mockGraph: mockGraph,
        mockDetail: mockDetail,
      ),
    );

    await tester.pump(); // build frame

    // 👇 Now it is still waiting → so loading shows
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Complete it after checking loading
    completer.complete(Right<Failure, List<QuizHistoryEntity>>(tHistoryList));

    await tester.pumpAndSettle();
  });

  testWidgets('ResultScreen shows Quiz History label after data loads', (
    tester,
  ) async {
    when(() => mockHistory()).thenAnswer(
      (_) async => Right<Failure, List<QuizHistoryEntity>>(tHistoryList),
    );

    await tester.pumpWidget(
      buildResultScreen(
        mockHistory: mockHistory,
        mockGraph: mockGraph,
        mockDetail: mockDetail,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quiz History'), findsOneWidget);
  });

  testWidgets('ResultScreen shows subject name in history card', (
    tester,
  ) async {
    when(() => mockHistory()).thenAnswer(
      (_) async => Right<Failure, List<QuizHistoryEntity>>(tHistoryList),
    );

    await tester.pumpWidget(
      buildResultScreen(
        mockHistory: mockHistory,
        mockGraph: mockGraph,
        mockDetail: mockDetail,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Math'), findsWidgets);
  });

  testWidgets('ResultScreen shows empty state when no history', (tester) async {
    when(
      () => mockHistory(),
    ).thenAnswer((_) async => Right<Failure, List<QuizHistoryEntity>>([]));

    await tester.pumpWidget(
      buildResultScreen(
        mockHistory: mockHistory,
        mockGraph: mockGraph,
        mockDetail: mockDetail,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No quiz results yet.'), findsOneWidget);
  });
}
