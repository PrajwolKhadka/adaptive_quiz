@Tags(['unit'])
library;

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/dashboard/domain/repositories/i_profile_repository.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/upload_profile_picture_usecase.dart';

class MockIProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late MockIProfileRepository mockRepo;
  late UploadProfilePictureUsecase usecase;

  const tImagePath = '/path/to/image.jpg';
  const tImageUrl = 'https://cdn.example.com/pic.jpg';
  const tFailure = ApiFailure(message: 'Upload failed', statusCode: 500);

  setUp(() {
    mockRepo = MockIProfileRepository();
    usecase = UploadProfilePictureUsecase(mockRepo);
  });

  test('should return image URL string on successful upload', () async {
    when(
      () => mockRepo.uploadProfilePicture(tImagePath),
    ).thenAnswer((_) async => const Right(tImageUrl));

    final result = await usecase(tImagePath);

    expect(result, const Right(tImageUrl));
    verify(() => mockRepo.uploadProfilePicture(tImagePath)).called(1);
  });

  test('should return Failure when upload fails', () async {
    when(
      () => mockRepo.uploadProfilePicture(tImagePath),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await usecase(tImagePath);

    expect(result, const Left(tFailure));
    verify(() => mockRepo.uploadProfilePicture(tImagePath)).called(1);
  });
}
