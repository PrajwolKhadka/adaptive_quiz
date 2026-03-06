@Tags(['widget'])
library;

import 'dart:async';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/core/providers/common_provider.dart';
import 'package:adaptive_quiz/core/services/storage/user_session_service.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/profile_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/upload_profile_picture_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_provider.dart';

class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockUserSessionService extends Mock implements UserSessionService {}

Widget buildProfileScreen({
  required MockGetProfileUsecase mockGetProfile,
  required MockUserSessionService mockSession,
}) {
  return ProviderScope(
    overrides: [
      getProfileUsecaseProvider.overrideWithValue(mockGetProfile),
      uploadProfilePictureUsecaseProvider.overrideWithValue(
        MockUploadProfilePictureUsecase(),
      ),
      userSessionServiceProvider.overrideWithValue(mockSession),
    ],
    child: const MaterialApp(home: ProfileScreen()),
  );
}

void main() {
  late MockGetProfileUsecase mockGetProfile;
  late MockUserSessionService mockSession;

  const tProfile = ProfileEntity(
    fullName: 'John Doe',
    email: 'john@example.com',
    className: 10,
    isFirstLogin: false,
  );

  setUp(() {
    mockGetProfile = MockGetProfileUsecase();
    mockSession = MockUserSessionService();
    when(
      () => mockSession.saveRemoteProfileImage(any()),
    ).thenAnswer((_) async {});
  });

  testWidgets('ProfileScreen shows Profile app bar', (tester) async {
    when(() => mockGetProfile()).thenAnswer((_) async => const Right(tProfile));

    await tester.pumpWidget(
      buildProfileScreen(
        mockGetProfile: mockGetProfile,
        mockSession: mockSession,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('ProfileScreen shows user full name after load', (tester) async {
    when(() => mockGetProfile()).thenAnswer((_) async => const Right(tProfile));

    await tester.pumpWidget(
      buildProfileScreen(
        mockGetProfile: mockGetProfile,
        mockSession: mockSession,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
  });

  testWidgets('ProfileScreen shows Logout button', (tester) async {
    when(() => mockGetProfile()).thenAnswer((_) async => const Right(tProfile));

    await tester.pumpWidget(
      buildProfileScreen(
        mockGetProfile: mockGetProfile,
        mockSession: mockSession,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('ProfileScreen shows loading indicator while fetching', (
    tester,
  ) async {
    // Completer never completes during the check — no pending Timer created
    final completer = Completer<Either<Failure, ProfileEntity>>();
    when(() => mockGetProfile()).thenAnswer((_) => completer.future);

    await tester.pumpWidget(
      buildProfileScreen(
        mockGetProfile: mockGetProfile,
        mockSession: mockSession,
      ),
    );
    await tester.pump(); // let microtask fire loadProfile -> isLoading=true

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Resolve before test ends to avoid leaking
    completer.complete(const Right(tProfile));
    await tester.pumpAndSettle();
  });
}
