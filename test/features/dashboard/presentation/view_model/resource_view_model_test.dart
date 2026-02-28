import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/resource_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/get_student_resources_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/resource_provider.dart';

class MockGetStudentResourcesUsecase extends Mock
    implements GetStudentResourcesUsecase {}

void main() {
  late MockGetStudentResourcesUsecase mockUsecase;
  late ProviderContainer container;

  final tResources = [
    ResourceEntity(
      id: 'r1',
      title: 'Math Book',
      type: ResourceType.book,
      format: ResourceFormat.pdf,
    ),
  ];

  const tFailure = ApiFailure(message: 'Server error', statusCode: 500);

  setUp(() {
    mockUsecase = MockGetStudentResourcesUsecase();

    // Stub before container creation to handle auto-load on build
    when(
      () => mockUsecase(),
    ).thenAnswer((_) async => Right<Failure, List<ResourceEntity>>(tResources));

    container = ProviderContainer(
      overrides: [
        getStudentResourcesUsecaseProvider.overrideWithValue(mockUsecase),
      ],
    );
    addTearDown(container.dispose);
  });

  test('initial state has empty resources and no error', () {
    // Read before microtask fires
    final state = container.read(resourceViewModelProvider);
    expect(state.resources, isEmpty);
    expect(state.error, null);
  });

  test('loadResources updates state with resources on success', () async {
    when(
      () => mockUsecase(),
    ).thenAnswer((_) async => Right<Failure, List<ResourceEntity>>(tResources));

    await container.read(resourceViewModelProvider.notifier).loadResources();

    final state = container.read(resourceViewModelProvider);
    expect(state.isLoading, false);
    expect(state.resources.length, 1);
    expect(state.resources.first.title, 'Math Book');
  });

  test('loadResources sets error on failure', () async {
    when(() => mockUsecase()).thenAnswer((_) async => const Left(tFailure));

    await container.read(resourceViewModelProvider.notifier).loadResources();

    final state = container.read(resourceViewModelProvider);
    expect(state.isLoading, false);
    expect(state.error, 'Server error');
    expect(state.resources, isEmpty);
  });
}
