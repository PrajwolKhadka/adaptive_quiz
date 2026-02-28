import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/quiz/domain/entities/quiz_entity.dart';
import 'package:adaptive_quiz/features/quiz/domain/repositories/i_quiz_repository.dart';
import 'package:adaptive_quiz/features/quiz/domain/usecases/quiz_usecases.dart';

class MockIQuizRepository extends Mock implements IQuizRepository {}

void main() {
  late MockIQuizRepository mockRepo;
  late GetActiveQuizUsecase usecase;
  late GetNextQuestionUsecase usecaseII;
  late SubmitAnswerUsecase usecaseIII;

  const tActiveQuiz = ActiveQuizEntity(
    available: true,
    quizId: 'quiz1',
    subject: 'Math',
  );

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
    mockRepo = MockIQuizRepository();
    usecase = GetActiveQuizUsecase(mockRepo);
    usecaseII = GetNextQuestionUsecase(mockRepo);
    usecaseIII = SubmitAnswerUsecase(mockRepo);
  });

  test('should return ActiveQuizEntity when a quiz is available', () async {
    when(
      () => mockRepo.getActiveQuiz(),
    ).thenAnswer((_) async => const Right(tActiveQuiz));

    final result = await usecase();

    expect(result, const Right(tActiveQuiz));
    verify(() => mockRepo.getActiveQuiz()).called(1);
  });

  test('should return Failure when no quiz is available', () async {
    when(
      () => mockRepo.getActiveQuiz(),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await usecase();

    expect(result, const Left(tFailure));
    verify(() => mockRepo.getActiveQuiz()).called(1);
  });

  test('should return QuizQuestionEntity on success', () async {
    when(
      () => mockRepo.getNextQuestion('quiz1'),
    ).thenAnswer((_) async => Right(tQuestion));

    final result = await usecaseII('quiz1');

    expect(result, Right(tQuestion));
    verify(() => mockRepo.getNextQuestion('quiz1')).called(1);
  });

  test('should return Failure on error', () async {
    when(
      () => mockRepo.getNextQuestion('quiz1'),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await usecaseII('quiz1');

    expect(result, const Left(tFailure));
    verify(() => mockRepo.getNextQuestion('quiz1')).called(1);
  });

  test(
    'should return SubmitAnswerEntity with correct=true on success',
    () async {
      when(
        () => mockRepo.submitAnswer(
          quizId: 'quiz1',
          questionId: 'q1',
          selectedOption: 'B',
          timeTaken: 10,
        ),
      ).thenAnswer((_) async => const Right(tSubmitResult));

      final result = await usecaseIII(
        quizId: 'quiz1',
        questionId: 'q1',
        selectedOption: 'B',
        timeTaken: 10,
      );

      expect(result, const Right(tSubmitResult));
      verify(
        () => mockRepo.submitAnswer(
          quizId: 'quiz1',
          questionId: 'q1',
          selectedOption: 'B',
          timeTaken: 10,
        ),
      ).called(1);
    },
  );

  test('should return Failure when submission fails', () async {
    when(
      () => mockRepo.submitAnswer(
        quizId: 'quiz1',
        questionId: 'q1',
        selectedOption: 'A',
        timeTaken: 5,
      ),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await usecaseIII(
      quizId: 'quiz1',
      questionId: 'q1',
      selectedOption: 'A',
      timeTaken: 5,
    );

    expect(result, const Left(tFailure));
    verify(
      () => mockRepo.submitAnswer(
        quizId: 'quiz1',
        questionId: 'q1',
        selectedOption: 'A',
        timeTaken: 5,
      ),
    ).called(1);
  });
}
