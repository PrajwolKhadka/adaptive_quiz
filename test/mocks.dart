import 'package:adaptive_quiz/core/api/api_client.dart';
import 'package:adaptive_quiz/core/services/storage/user_session_service.dart';
import 'package:adaptive_quiz/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:adaptive_quiz/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:adaptive_quiz/features/auth/data/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {
  MockDio() {
    when(() => this.options).thenReturn(BaseOptions());
  }
}

class MockApiClient extends Mock implements ApiClient {}

class MockUserSessionService extends Mock implements UserSessionService {}

class MockResponse extends Mock implements Response {}

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockAuthRemoteDatasource extends Mock implements IAuthRemoteDatasource {}

class MockAuthLocalDatasource extends Mock implements IAuthLocalDatasource {}
