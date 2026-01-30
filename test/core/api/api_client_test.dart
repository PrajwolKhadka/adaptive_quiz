import 'package:adaptive_quiz/core/api/api_client.dart';
import 'package:adaptive_quiz/core/api/api_endpoint.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late MockDio mockDio;
  late ApiClient apiClient;

  setUp(() {
    mockDio = MockDio();
    apiClient = ApiClient(mockDio);
  });

  test('GET request returns response when successful', () async {
    final response = Response(
      requestOptions: RequestOptions(path: '/profile'),
      statusCode: 200,
      data: {'success': true},
    );

    when(
      () => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => response);

    final result = await apiClient.get('/profile');

    expect(result.statusCode, 200);
    expect(result.data['success'], true);
    verify(
      () => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).called(1);
  });

  test('GET request throws DioException on failure', () async {
    when(
      () => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/profile'),
        type: DioExceptionType.connectionError,
      ),
    );

    expect(() => apiClient.get('/profile'), throwsA(isA<DioException>()));
  });
}
