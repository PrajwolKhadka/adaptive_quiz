@Tags(['widget'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/features/auth/data/repositories/auth_repository.dart';
import 'package:adaptive_quiz/features/auth/presentation/pages/login_screen.dart';
import 'package:adaptive_quiz/features/auth/presentation/providers/auth_provider.dart';
import 'package:adaptive_quiz/core/providers/common_provider.dart';
import 'package:adaptive_quiz/core/services/storage/user_session_service.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_provider.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockUserSessionService extends Mock implements UserSessionService {}

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

Widget buildLoginScreen({
  required MockAuthRepository mockRepo,
  required MockUserSessionService mockSession,
  required MockGetProfileUsecase mockGetProfile,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(mockRepo),
      userSessionServiceProvider.overrideWithValue(mockSession),
      getProfileUsecaseProvider.overrideWithValue(mockGetProfile),
      uploadProfilePictureUsecaseProvider.overrideWithValue(
        MockUploadProfilePictureUsecase(),
      ),
    ],
    child: const MaterialApp(home: LoginScreen()),
  );
}

void main() {
  late MockAuthRepository mockRepo;
  late MockUserSessionService mockSession;
  late MockGetProfileUsecase mockGetProfile;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockSession = MockUserSessionService();
    mockGetProfile = MockGetProfileUsecase();
  });

  testWidgets('LoginScreen shows email and password fields', (tester) async {
    await tester.pumpWidget(
      buildLoginScreen(
        mockRepo: mockRepo,
        mockSession: mockSession,
        mockGetProfile: mockGetProfile,
      ),
    );
    await tester.pump();

    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('LoginScreen shows Sign In button', (tester) async {
    await tester.pumpWidget(
      buildLoginScreen(
        mockRepo: mockRepo,
        mockSession: mockSession,
        mockGetProfile: mockGetProfile,
      ),
    );
    await tester.pump();

    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('LoginScreen shows validation errors when submitted empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildLoginScreen(
        mockRepo: mockRepo,
        mockSession: mockSession,
        mockGetProfile: mockGetProfile,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('LoginScreen shows Forgot password link', (tester) async {
    await tester.pumpWidget(
      buildLoginScreen(
        mockRepo: mockRepo,
        mockSession: mockSession,
        mockGetProfile: mockGetProfile,
      ),
    );
    await tester.pump();

    expect(find.text('Forgot password?'), findsOneWidget);
  });
}
