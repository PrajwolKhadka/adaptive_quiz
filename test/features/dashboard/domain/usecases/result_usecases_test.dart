@Tags(['unit'])
library;

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/result_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/repositories/i_result_repository.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/result_usecases.dart';

class MockIResultRepository extends Mock implements IResultRepository {}

void main() {
  late MockIResultRepository mockRepo;
  late GetMyHistoryUsecase usecase;
  late GetMyResultDetailUsecase usecaseII;
  late GetPerformanceGraphUsecase usecaseIII;

  final tQuizInfo = QuizInfoEntity(id: 'q1', subject: 'Math', classLevel: 10);

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
  final tResultDetail = QuizResultDetailEntity(
    resultId: 'res1',
    quiz: tQuizInfo,
    totalQuestions: 10,
    correctAnswers: 8,
    wrongAnswers: 2,
    accuracy: 80.0,
    timeTaken: 120,
    completedAt: DateTime(2024, 1, 1),
    aiFeedback: 'Great job!',
    questionStats: [],
  );

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

  const tFailure = ApiFailure(message: 'Server error', statusCode: 500);

  setUp(() {
    mockRepo = MockIResultRepository();
    usecase = GetMyHistoryUsecase(mockRepo);
    usecaseII = GetMyResultDetailUsecase(mockRepo);
    usecaseIII = GetPerformanceGraphUsecase(mockRepo);
  });

  test('should return list of QuizHistoryEntity on success', () async {
    when(() => mockRepo.getMyHistory()).thenAnswer(
      (_) async => Right<Failure, List<QuizHistoryEntity>>(tHistoryList),
    );

    final result = await usecase();

    result.fold((l) => fail('Expected Right but got Left'), (r) {
      expect(r.length, 1);
      expect(r.first.resultId, 'res1');
      expect(r.first.correctAnswers, 8);
    });
    verify(() => mockRepo.getMyHistory()).called(1);
  });

  test('should return Failure on history error', () async {
    when(
      () => mockRepo.getMyHistory(),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await usecase();

    expect(result, const Left(tFailure));
    verify(() => mockRepo.getMyHistory()).called(1);
  });

  test('should return QuizResultDetailEntity when quizId is valid', () async {
    when(
      () => mockRepo.getMyResultDetail('res1'),
    ).thenAnswer((_) async => Right(tResultDetail));

    final result = await usecaseII('res1');

    expect(result, Right(tResultDetail));
    verify(() => mockRepo.getMyResultDetail('res1')).called(1);
  });

  test('should return Failure when quizId is invalid', () async {
    when(
      () => mockRepo.getMyResultDetail('invalid'),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await usecaseII('invalid');

    expect(result, const Left(tFailure));
    verify(() => mockRepo.getMyResultDetail('invalid')).called(1);
  });

  test('should return performance graph map on success', () async {
    when(
      () => mockRepo.getPerformanceGraph(),
    ).thenAnswer((_) async => Right(tGraph));

    final result = await usecaseIII();

    expect(result, Right(tGraph));
    verify(() => mockRepo.getPerformanceGraph()).called(1);
  });

  test('should return Failure on error', () async {
    when(
      () => mockRepo.getPerformanceGraph(),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await usecaseIII();

    expect(result, const Left(tFailure));
    verify(() => mockRepo.getPerformanceGraph()).called(1);
  });
}
