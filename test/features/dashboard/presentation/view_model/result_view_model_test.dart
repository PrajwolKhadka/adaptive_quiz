import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/api/api_client.dart';
import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/core/providers/common_provider.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/result_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/result_usecases.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/result_provider.dart';

class MockGetMyHistoryUsecase extends Mock implements GetMyHistoryUsecase {}

class MockGetPerformanceGraphUsecase extends Mock
    implements GetPerformanceGraphUsecase {}

class MockGetMyResultDetailUsecase extends Mock
    implements GetMyResultDetailUsecase {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockGetMyHistoryUsecase mockHistory;
  late MockGetPerformanceGraphUsecase mockGraph;
  late MockGetMyResultDetailUsecase mockDetail;
  late MockApiClient mockApiClient;
  late ProviderContainer container;

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

  final tGraph = {
    'Math': [
      SubjectGraphPoint(
        date: DateTime(2024, 1, 1),
        accuracy: 90.0,
        score: 9,
        total: 10,
      ),
    ],
  };

  final tDetail = QuizResultDetailEntity(
    resultId: 'res1',
    quiz: tQuizInfo,
    totalQuestions: 10,
    correctAnswers: 8,
    wrongAnswers: 2,
    accuracy: 80.0,
    timeTaken: 120,
    completedAt: DateTime(2024, 1, 1),
    aiFeedback: 'Good job!',
    questionStats: [],
  );

  const tFailure = ApiFailure(message: 'Server error', statusCode: 500);

  setUp(() async {
    mockHistory = MockGetMyHistoryUsecase();
    mockGraph = MockGetPerformanceGraphUsecase();
    mockDetail = MockGetMyResultDetailUsecase();
    mockApiClient = MockApiClient();

    // Default stubs for the auto-triggered loadHistory in build()
    when(() => mockHistory()).thenAnswer(
      (_) async => Right<Failure, List<QuizHistoryEntity>>(tHistoryList),
    );
    when(() => mockGraph()).thenAnswer(
      (_) async => Right<Failure, Map<String, List<SubjectGraphPoint>>>(tGraph),
    );

    container = ProviderContainer(
      overrides: [
        getMyHistoryUsecaseProvider.overrideWithValue(mockHistory),
        getPerformanceGraphUsecaseProvider.overrideWithValue(mockGraph),
        getMyResultDetailUsecaseProvider.overrideWithValue(mockDetail),
        apiClientProvider.overrideWithValue(mockApiClient),
      ],
    );
    // Keep provider alive to prevent "Ref disposed" error
    container.listen(resultViewModelProvider, (_, __) {});

    // Trigger provider creation and wait for build() microtask to complete
    container.read(resultViewModelProvider);
    await Future<void>.delayed(Duration.zero);

    addTearDown(container.dispose);
  });

  test('initial state is correct after build microtask', () {
    final state = container.read(resultViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, null);
  });

  test('loadHistory updates history and graph on success', () async {
    when(() => mockHistory()).thenAnswer(
      (_) async => Right<Failure, List<QuizHistoryEntity>>(tHistoryList),
    );
    when(() => mockGraph()).thenAnswer(
      (_) async => Right<Failure, Map<String, List<SubjectGraphPoint>>>(tGraph),
    );

    await container.read(resultViewModelProvider.notifier).loadHistory();

    final state = container.read(resultViewModelProvider);
    expect(state.isLoading, false);
    expect(state.history.length, 1);
    expect(state.history.first.resultId, 'res1');
    expect(state.graph.containsKey('Math'), true);
  });

  test('loadHistory sets error when history fails', () async {
    when(() => mockHistory()).thenAnswer((_) async => const Left(tFailure));
    when(() => mockGraph()).thenAnswer(
      (_) async => Right<Failure, Map<String, List<SubjectGraphPoint>>>(tGraph),
    );

    await container.read(resultViewModelProvider.notifier).loadHistory();

    final state = container.read(resultViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, 'Server error');
  });

  test('loadResultDetail updates detail on success', () async {
    when(
      () => mockDetail('res1'),
    ).thenAnswer((_) async => Right<Failure, QuizResultDetailEntity>(tDetail));

    await container
        .read(resultViewModelProvider.notifier)
        .loadResultDetail('res1');

    final state = container.read(resultViewModelProvider);
    expect(state.isLoadingDetail, false);
    expect(state.detail?.resultId, 'res1');
    expect(state.detail?.aiFeedback, 'Good job!');
  });

  test('loadResultDetail sets detailError on failure', () async {
    when(() => mockDetail('bad')).thenAnswer((_) async => const Left(tFailure));

    await container
        .read(resultViewModelProvider.notifier)
        .loadResultDetail('bad');

    final state = container.read(resultViewModelProvider);
    expect(state.isLoadingDetail, false);
    expect(state.detailError, 'Server error');
  });
}
