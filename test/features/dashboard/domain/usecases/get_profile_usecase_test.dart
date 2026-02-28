import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/profile_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/repositories/i_profile_repository.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/get_profile_usecase.dart';

class MockIProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late MockIProfileRepository mockRepo;
  late GetProfileUsecase usecase;

  const tProfileEntity = ProfileEntity(
    fullName: 'Test User',
    email: 'test@example.com',
    className: 10,
    imageUrl: null,
    isFirstLogin: false,
  );

  const tFailure = ApiFailure(message: 'Server error', statusCode: 500);

  setUp(() {
    mockRepo = MockIProfileRepository();
    usecase = GetProfileUsecase(mockRepo);
  });

  test('should return ProfileEntity on success', () async {
    when(
      () => mockRepo.getProfile(),
    ).thenAnswer((_) async => const Right(tProfileEntity));

    final result = await usecase();

    expect(result, const Right(tProfileEntity));
    verify(() => mockRepo.getProfile()).called(1);
  });

  test('should return Failure on error', () async {
    when(
      () => mockRepo.getProfile(),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await usecase();

    expect(result, const Left(tFailure));
    verify(() => mockRepo.getProfile()).called(1);
  });
}
