import 'package:adaptive_quiz/features/quiz/domain/entities/quiz_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/resource_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/get_student_resources_usecase.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/homepage_screen.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/resource_provider.dart';

import 'package:adaptive_quiz/features/quiz/domain/usecases/quiz_usecases.dart';
import 'package:adaptive_quiz/features/quiz/presentation/providers/quiz_provider.dart';

class MockGetStudentResourcesUsecase extends Mock
    implements GetStudentResourcesUsecase {}

class MockGetActiveQuizUsecase extends Mock implements GetActiveQuizUsecase {}

class MockGetNextQuestionUsecase extends Mock
    implements GetNextQuestionUsecase {}

class MockSubmitAnswerUsecase extends Mock implements SubmitAnswerUsecase {}

void main() {
  late MockGetStudentResourcesUsecase mockResources;
  late MockGetActiveQuizUsecase mockGetActive;

  setUp(() {
    mockResources = MockGetStudentResourcesUsecase();
    mockGetActive = MockGetActiveQuizUsecase();
  });

  Widget buildTestWidget({
    List<ResourceEntity> resources = const [],
    bool quizAvailable = false,
  }) {
    when(
      () => mockResources(),
    ).thenAnswer((_) async => Right<Failure, List<ResourceEntity>>(resources));

    when(() => mockGetActive()).thenAnswer(
      (_) async => Right<Failure, ActiveQuizEntity>(
        ActiveQuizEntity(available: quizAvailable),
      ),
    );

    return ProviderScope(
      overrides: [
        getStudentResourcesUsecaseProvider.overrideWithValue(mockResources),
        getActiveQuizUsecaseProvider.overrideWithValue(mockGetActive),
        getNextQuestionUsecaseProvider.overrideWithValue(
          MockGetNextQuestionUsecase(),
        ),
        submitAnswerUsecaseProvider.overrideWithValue(
          MockSubmitAnswerUsecase(),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: HomeScreen())),
    );
  }

  testWidgets('HomeScreen shows Start Quiz button', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(resources: [], quizAvailable: true),
    );

    await tester.pumpAndSettle();

    expect(find.text('Start Quiz'), findsOneWidget);
  });

  testWidgets('HomeScreen shows Quiz Preparation section', (tester) async {
    await tester.pumpWidget(
      buildTestWidget(resources: [], quizAvailable: false),
    );

    await tester.pumpAndSettle();

    expect(find.text('Quiz Preparation'), findsOneWidget);
  });

  testWidgets('HomeScreen shows no resources text when list is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(resources: [], quizAvailable: false),
    );

    await tester.pumpAndSettle();

    expect(find.text('No resources available yet.'), findsOneWidget);
  });
}
