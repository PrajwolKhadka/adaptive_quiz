import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:adaptive_quiz/features/auth/presentation/providers/auth_provider.dart';
import 'package:adaptive_quiz/features/auth/presentation/state/auth_state.dart';
import 'package:adaptive_quiz/core/providers/common_provider.dart';
import '../../../../mocks.dart';
import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/auth/domain/entities/auth_response.dart';

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;
  late MockUserSessionService mockSession;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSession = MockUserSessionService();

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        userSessionServiceProvider.overrideWithValue(mockSession),
      ],
    );
  });

  test('login success updates state and calls saveStudentSession', () async {
    // Arrange
    final viewModel = container.read(authViewModelProvider.notifier);
    when(() => mockAuthRepository.loginStudent(any(), any())).thenAnswer(
      (_) async => Right<Failure, AuthResponse>(
        AuthResponse(
          token: 'token123',
          studentId: 'stu01',
          fullName: 'John Doe',
          email: 'john@example.com',
          className: '10A',
          isFirstLogin: true,
        ),
      ),
    );
    when(
      () => mockSession.saveStudentSession(
        token: any(named: 'token'),
        studentId: any(named: 'studentId'),
        fullName: any(named: 'fullName'),
        email: any(named: 'email'),
        className: any(named: 'className'),
      ),
    ).thenAnswer((_) async {});

    var onSuccessCalled = false;

    // Act
    await viewModel.login('john@example.com', 'password123', (
      isFirstLogin,
      token,
    ) {
      onSuccessCalled = true;
      expect(isFirstLogin, true);
      expect(token, 'token123');
    });

    // Assert
    final state = container.read(authViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, null);
    expect(onSuccessCalled, true);
    verify(
      () => mockSession.saveStudentSession(
        token: 'token123',
        studentId: 'stu01',
        fullName: 'John Doe',
        email: 'john@example.com',
        className: '10A',
      ),
    ).called(1);
  });

  test('login failure updates state with error', () async {
    final viewModel = container.read(authViewModelProvider.notifier);

    when(
      () => mockAuthRepository.loginStudent(any(), any()),
    ).thenAnswer((_) async => Left(ApiFailure(message: 'Invalid credentials')));

    await viewModel.login('john@example.com', 'wrongpass', (_, __) {});

    final state = container.read(authViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, 'Invalid credentials');
  });

  test('changePassword success updates state', () async {
    final viewModel = container.read(authViewModelProvider.notifier);

    when(
      () => mockAuthRepository.changePassword(any()),
    ).thenAnswer((_) async => const Right(null));

    await viewModel.changePassword('newPass123');

    final state = container.read(authViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, null);
  });

  test('changePassword failure updates state with error', () async {
    final viewModel = container.read(authViewModelProvider.notifier);

    when(
      () => mockAuthRepository.changePassword(any()),
    ).thenThrow(Exception('Server error'));

    expect(
      () => viewModel.changePassword('newPass123'),
      throwsA(isA<Exception>()),
    );

    final state = container.read(authViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, isNotNull);
  });
}
