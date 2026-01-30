import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:adaptive_quiz/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:adaptive_quiz/features/auth/data/models/auth_api_model.dart';
import 'package:adaptive_quiz/features/auth/data/models/auth_hive_model.dart';
import 'package:adaptive_quiz/features/auth/domain/entities/auth_response.dart';
import 'package:adaptive_quiz/core/error/failure.dart';
import '../../../../mocks.dart'; // Your mock classes

// --- Fake for AuthHiveModel ---
class FakeAuthHiveModel extends Fake implements AuthHiveModel {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDatasource mockRemote;
  late MockAuthLocalDatasource mockLocal;

  setUpAll(() {
    // Register fallback for any() calls with AuthHiveModel
    registerFallbackValue(FakeAuthHiveModel());
  });

  setUp(() {
    mockRemote = MockAuthRemoteDatasource();
    mockLocal = MockAuthLocalDatasource();
    repository = AuthRepositoryImpl(mockRemote, mockLocal);
  });

  group('loginStudent', () {
    final tEmail = 'john@example.com';
    final tPassword = 'password123';

    final tApiModelFirstLogin = AuthApiModel(
      id: 'stu01',
      fullName: 'John Doe',
      email: tEmail,
      className: '10A',
      role: 'student',
      isFirstLogin: true,
      token: 'token123',
    );

    final tApiModelNotFirst = AuthApiModel(
      id: 'stu01',
      fullName: 'John Doe',
      email: tEmail,
      className: '10A',
      role: 'student',
      isFirstLogin: false,
      token: 'token123',
    );

    final tEntityFirstLogin = tApiModelFirstLogin.toEntity();
    final tEntityNotFirst = tApiModelNotFirst.toEntity();

    test(
      'should return AuthResponse when remote datasource succeeds (first login)',
      () async {
        // Arrange
        when(
          () => mockRemote.login(tEmail, tPassword),
        ).thenAnswer((_) async => tApiModelFirstLogin);

        // Act
        final result = await repository.loginStudent(tEmail, tPassword);

        // Assert
        result.fold(
          (_) => fail('Expected Right, got Left'),
          (entity) => expect(entity, tEntityFirstLogin),
        );
        verify(() => mockRemote.login(tEmail, tPassword)).called(1);
        // local save should NOT be called because isFirstLogin is true
        verifyNever(() => mockLocal.saveStudent(any()));
      },
    );

    test('should save locally if not first login', () async {
      when(
        () => mockRemote.login(tEmail, tPassword),
      ).thenAnswer((_) async => tApiModelNotFirst);
      when(() => mockLocal.saveStudent(any())).thenAnswer((_) async {});

      final result = await repository.loginStudent(tEmail, tPassword);

      result.fold(
        (_) => fail('Expected Right, got Left'),
        (entity) => expect(entity, tEntityNotFirst),
      );
      verify(
        () => mockLocal.saveStudent(tApiModelNotFirst.toHiveModel()),
      ).called(1);
    });

    test('should return ApiFailure when remote datasource throws', () async {
      when(
        () => mockRemote.login(tEmail, tPassword),
      ).thenThrow(Exception('Invalid credentials'));

      final result = await repository.loginStudent(tEmail, tPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Invalid credentials'),
        (_) => fail('Expected failure'),
      );
    });
  });

  group('changePassword', () {
    final tPassword = 'newPass123';

    test('should return Right(null) when remote datasource succeeds', () async {
      when(() => mockRemote.changePassword(tPassword)).thenAnswer((_) async {});

      final result = await repository.changePassword(tPassword);

      result.fold(
        (_) => fail('Expected Right, got Left'),
        (_) {},
      );
      verify(() => mockRemote.changePassword(tPassword)).called(1);
    });

    test('should return ApiFailure when remote datasource throws', () async {
      when(
        () => mockRemote.changePassword(tPassword),
      ).thenThrow(Exception('Server error'));

      final result = await repository.changePassword(tPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Exception: Server error'),
        (_) => fail('Expected failure'),
      );
    });
  });
}
