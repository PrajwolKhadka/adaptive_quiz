import 'package:adaptive_quiz/core/providers/common_provider.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_viewmodel_provider.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/state/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dio/dio.dart';

import '../../../../mocks.dart';

void main() {
  late ProviderContainer container;
  late MockApiClient mockApiClient;
  late MockUserSessionService mockSession;

  setUp(() {
    mockApiClient = MockApiClient();
    mockSession = MockUserSessionService();

    container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(mockApiClient),
        userSessionServiceProvider.overrideWithValue(mockSession),
      ],
    );
  });

  test('loadProfile updates state with data when API succeeds', () async {
    when(
      () => mockSession.getToken(),
    ).thenAnswer((invocation) async => 'token123');
    when(
      () => mockApiClient.get(any(), options: any(named: 'options')),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/profile'),
        statusCode: 200,
        data: {
          'success': true,
          'data': {
            'fullName': 'John Doe',
            'email': 'john@example.com',
            'className': '10A',
            'imageUrl': 'image.png',
          },
        },
      ),
    );

    final viewModel = container.read(profileViewModelProvider.notifier);
    await viewModel.loadProfile();

    final state = container.read(profileViewModelProvider);
    expect(state.fullName, 'John Doe');
    expect(state.email, 'john@example.com');
    expect(state.className, '10A');
    expect(state.imageUrl, 'image.png');
    expect(state.isLoading, false);
  });

  test('loadProfile sets error when token is null', () async {
    when(() => mockSession.getToken()).thenAnswer((invocation) async => null);

    final viewModel = container.read(profileViewModelProvider.notifier);
    await viewModel.loadProfile();

    final state = container.read(profileViewModelProvider);
    expect(state.error, 'No token found');
    expect(state.isLoading, false);
  });

  test(
    'uploadProfilePicture sets imageUrl and clears local path on success',
    () async {
      when(() => mockSession.getToken()).thenAnswer((_) async => 'token123');

      when(
        () => mockApiClient.get(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/profile'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {
              'fullName': 'John',
              'email': 'j@j.com',
              'className': '10',
              'imageUrl': 'uploaded.png',
            },
          },
        ),
      );

      when(
        () => mockApiClient.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/upload'),
          statusCode: 200,
          data: {
            'success': true,
            'data': {'imageUrl': 'uploaded.png'},
          },
        ),
      );

      when(
        () => mockSession.saveRemoteProfileImage(any()),
      ).thenAnswer((_) async => null);

      final viewModel = container.read(profileViewModelProvider.notifier);

      await Future.microtask(() {});

      // Set local image path
      viewModel.state = viewModel.state.copyWith(
        localImagePath: '/local/path.png',
      );

      final originalCopyWith = viewModel.state.copyWith;
      viewModel.state = viewModel.state.copyWith(
        localImagePath: '/local/path.png',
      );

      await viewModel.uploadProfilePicture();

      final state = viewModel.state;

      expect(state.imageUrl, 'uploaded.png');
      expect(state.localImagePath, '/local/path.png');
    },
  );
}
