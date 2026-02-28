import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/core/providers/common_provider.dart';
import 'package:adaptive_quiz/core/services/storage/user_session_service.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/profile_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_provider.dart';

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockGetProfileUsecase mockGetProfile;
  late MockUploadProfilePictureUsecase mockUpload;
  late MockUserSessionService mockSession;
  late ProviderContainer container;

  const tProfile = ProfileEntity(
    fullName: 'John Doe',
    email: 'john@example.com',
    className: 10,
    isFirstLogin: false,
  );

  const tFailure = ApiFailure(message: 'Unauthorized', statusCode: 401);

  setUp(() async {
    mockGetProfile = MockGetProfileUsecase();
    mockUpload = MockUploadProfilePictureUsecase();
    mockSession = MockUserSessionService();

    when(
      () => mockSession.saveRemoteProfileImage(any()),
    ).thenAnswer((_) async {});

    // Default stub for the auto-triggered loadProfile in build()
    when(() => mockGetProfile()).thenAnswer((_) async => const Right(tProfile));

    container = ProviderContainer(
      overrides: [
        getProfileUsecaseProvider.overrideWithValue(mockGetProfile),
        uploadProfilePictureUsecaseProvider.overrideWithValue(mockUpload),
        userSessionServiceProvider.overrideWithValue(mockSession),
      ],
    );
    // Keep autoDispose provider alive for the entire test
    container.listen(profileViewModelProvider, (_, __) {});

    // Trigger provider creation and wait for build() microtask to complete
    container.read(profileViewModelProvider);
    await Future<void>.delayed(Duration.zero);

    addTearDown(container.dispose);
  });

  test('initial state has no error and not loading after build microtask', () {
    final state = container.read(profileViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, null);
  });

  test('loadProfile updates state with profile data on success', () async {
    when(() => mockGetProfile()).thenAnswer((_) async => const Right(tProfile));

    await container.read(profileViewModelProvider.notifier).loadProfile();

    final state = container.read(profileViewModelProvider);
    expect(state.isLoading, false);
    expect(state.fullName, 'John Doe');
    expect(state.email, 'john@example.com');
    expect(state.className, 10);
  });

  test('loadProfile sets error on failure', () async {
    when(() => mockGetProfile()).thenAnswer((_) async => const Left(tFailure));

    await container.read(profileViewModelProvider.notifier).loadProfile();

    final state = container.read(profileViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, 'Unauthorized');
  });

  test('uploadProfilePicture usecase returns image URL on success', () async {
    when(
      () => mockUpload('/local/path.jpg'),
    ).thenAnswer((_) async => const Right('https://cdn.example.com/pic.jpg'));

    final result = await mockUpload('/local/path.jpg');

    result.fold(
      (l) => fail('Expected Right but got Left'),
      (url) => expect(url, 'https://cdn.example.com/pic.jpg'),
    );
    verify(() => mockUpload('/local/path.jpg')).called(1);
  });
}
