import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/common_provider.dart';
import '../../data/datasources/remote/resource_remote_datasource.dart';
import '../../data/repositories/resource_repository_impl.dart';
import '../../domain/repositories/i_resource_repository.dart';
import '../../domain/usecases/get_student_resources_usecase.dart';
import '../state/resource_state.dart';
import '../view_model/resource_view_model.dart';

// 1. Remote Datasource
final resourceRemoteDatasourceProvider =
Provider<IResourceRemoteDatasource>((ref) {
  return ResourceRemoteDatasource(
    ref.read(apiClientProvider),
    ref.read(userSessionServiceProvider),
  );
});

// 2. Repository
final resourceRepositoryProvider = Provider<IResourceRepository>((ref) {
  return ResourceRepositoryImpl(ref.read(resourceRemoteDatasourceProvider));
});

// 3. Use Case
final getStudentResourcesUsecaseProvider =
Provider<GetStudentResourcesUsecase>((ref) {
  return GetStudentResourcesUsecase(ref.read(resourceRepositoryProvider));
});

// 4. ViewModel
final resourceViewModelProvider =
NotifierProvider<ResourceViewModel, ResourceState>(
      () => ResourceViewModel(),
);