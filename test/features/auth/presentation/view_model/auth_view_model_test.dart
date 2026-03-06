@Tags(['unit'])
library;

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/auth/data/repositories/auth_repository.dart';
import 'package:adaptive_quiz/features/auth/domain/entities/auth_response.dart';
import 'package:adaptive_quiz/features/auth/presentation/providers/auth_provider.dart';
import 'package:adaptive_quiz/core/providers/common_provider.dart';
import 'package:adaptive_quiz/core/services/storage/user_session_service.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/profile_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_provider.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockUserSessionService extends Mock implements UserSessionService {}

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

void main() {
  late MockAuthRepository mockRepo;
  late MockUserSessionService mockSession;
  late MockGetProfileUsecase mockGetProfile;
  late ProviderContainer container;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tFailure = ApiFailure(message: 'Invalid credentials', statusCode: 401);
  const tProfile = ProfileEntity(
    fullName: 'John Doe',
    email: tEmail,
    className: 10,
    isFirstLogin: false,
  );

  final tResponse = AuthResponse(
    token: 'token123',
    studentId: 'student1',
    fullName: 'John Doe',
    email: tEmail,
    className: '10',
    isFirstLogin: false,
  );

  setUp(() {
    mockRepo = MockAuthRepository();
    mockSession = MockUserSessionService();
    mockGetProfile = MockGetProfileUsecase();

    when(
      () => mockSession.saveStudentSession(
        token: any(named: 'token'),
        studentId: any(named: 'studentId'),
        fullName: any(named: 'fullName'),
        email: any(named: 'email'),
        className: any(named: 'className'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockSession.saveRemoteProfileImage(any()),
    ).thenAnswer((_) async {});

    // Stub profile load so ProfileViewModel doesn't fail during login flow
    when(() => mockGetProfile()).thenAnswer((_) async => const Right(tProfile));

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
        userSessionServiceProvider.overrideWithValue(mockSession),
        getProfileUsecaseProvider.overrideWithValue(mockGetProfile),
        uploadProfilePictureUsecaseProvider.overrideWithValue(
          MockUploadProfilePictureUsecase(),
        ),
      ],
    );
    addTearDown(container.dispose);
  });

  test('initial state is correct', () {
    final state = container.read(authViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, null);
  });

  test('login sets error on failure', () async {
    when(
      () => mockRepo.loginStudent(tEmail, tPassword),
    ).thenAnswer((_) async => const Left(tFailure));

    await container
        .read(authViewModelProvider.notifier)
        .login(tEmail, tPassword, (_, __) {});

    final state = container.read(authViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, 'Invalid credentials');
  });

  test('login calls onSuccess with correct isFirstLogin on success', () async {
    when(
      () => mockRepo.loginStudent(tEmail, tPassword),
    ).thenAnswer((_) async => Right(tResponse));

    bool? capturedFirstLogin;
    await container
        .read(authViewModelProvider.notifier)
        .login(
          tEmail,
          tPassword,
          (isFirstLogin, token) => capturedFirstLogin = isFirstLogin,
        );

    expect(capturedFirstLogin, false);
    expect(container.read(authViewModelProvider).error, null);
  });
}
