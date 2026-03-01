@Tags(['unit'])
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/features/auth/domain/entities/auth_entity.dart';
import 'package:adaptive_quiz/features/auth/domain/repositories/auth_repository.dart';
import 'package:adaptive_quiz/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late LoginUsecase usecase;

  const tAuthEntity = AuthEntity(
    id: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    className: 10,
    isFirstLogin: false,
    token: 'abc123',
  );

  setUp(() {
    mockRepo = MockAuthRepository();
    usecase = LoginUsecase(mockRepo);
  });

  test('should return AuthEntity when login is successful', () {
    when(
      () => mockRepo.login('test@example.com', 'password'),
    ).thenReturn(tAuthEntity);

    final result = usecase('test@example.com', 'password');

    expect(result, tAuthEntity);
    verify(() => mockRepo.login('test@example.com', 'password')).called(1);
  });

  test('should return null when credentials are wrong', () {
    when(() => mockRepo.login('wrong@example.com', 'wrong')).thenReturn(null);

    final result = usecase('wrong@example.com', 'wrong');

    expect(result, isNull);
    verify(() => mockRepo.login('wrong@example.com', 'wrong')).called(1);
  });
}
