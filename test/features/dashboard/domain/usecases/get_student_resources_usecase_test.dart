// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import 'package:adaptive_quiz/core/error/failure.dart';
// import 'package:adaptive_quiz/features/dashboard/domain/entities/resource_entity.dart';
// import 'package:adaptive_quiz/features/dashboard/domain/repositories/i_resource_repository.dart';
// import 'package:adaptive_quiz/features/dashboard/domain/usecases/get_student_resources_usecase.dart';

// class MockIResourceRepository extends Mock implements IResourceRepository {}

// void main() {
//   late MockIResourceRepository mockRepo;
//   late GetStudentResourcesUsecase usecase;

//   final tResourceEntity = ResourceEntity(
//     id: 'r1',
//     title: 'Math Book',
//     type: ResourceType.book,
//     format: ResourceFormat.pdf,
//   );

//   const tFailure = ApiFailure(message: 'Server error', statusCode: 500);

//   setUp(() {
//     mockRepo = MockIResourceRepository();
//     usecase = GetStudentResourcesUsecase(mockRepo);
//   });

//   test('should return list of ResourceEntity on success', () async {
//     when(() => mockRepo.getStudentResources()).thenAnswer(
//       (_) async => Right<Failure, List<ResourceEntity>>([tResourceEntity]),
//     );

//     final result = await usecase();

//     expect(result, Right<Failure, List<ResourceEntity>>([tResourceEntity]));
//     verify(() => mockRepo.getStudentResources()).called(1);
//   });

//   test('should return Failure on error', () async {
//     when(
//       () => mockRepo.getStudentResources(),
//     ).thenAnswer((_) async => const Left(tFailure));

//     final result = await usecase();

//     expect(result, const Left(tFailure));
//     verify(() => mockRepo.getStudentResources()).called(1);
//   });
// }

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_quiz/core/error/failure.dart';
import 'package:adaptive_quiz/features/dashboard/domain/entities/resource_entity.dart';
import 'package:adaptive_quiz/features/dashboard/domain/repositories/i_resource_repository.dart';
import 'package:adaptive_quiz/features/dashboard/domain/usecases/get_student_resources_usecase.dart';

class MockIResourceRepository extends Mock implements IResourceRepository {}

void main() {
  late MockIResourceRepository mockRepo;
  late GetStudentResourcesUsecase usecase;

  final tResourceList = [
    ResourceEntity(
      id: 'r1',
      title: 'Math Book',
      type: ResourceType.book,
      format: ResourceFormat.pdf,
    ),
  ];

  const tFailure = ApiFailure(message: 'Server error', statusCode: 500);

  setUp(() {
    mockRepo = MockIResourceRepository();
    usecase = GetStudentResourcesUsecase(mockRepo);
  });

  test('should return list of ResourceEntity on success', () async {
    when(() => mockRepo.getStudentResources()).thenAnswer(
      (_) async => Right<Failure, List<ResourceEntity>>(tResourceList),
    );

    final result = await usecase();

    result.fold((l) => fail('Expected Right but got Left'), (r) {
      expect(r.length, 1);
      expect(r.first.id, 'r1');
      expect(r.first.title, 'Math Book');
      expect(r.first.type, ResourceType.book);
    });
    verify(() => mockRepo.getStudentResources()).called(1);
  });

  test('should return Failure on error', () async {
    when(
      () => mockRepo.getStudentResources(),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await usecase();

    expect(result, const Left(tFailure));
    verify(() => mockRepo.getStudentResources()).called(1);
  });
}
