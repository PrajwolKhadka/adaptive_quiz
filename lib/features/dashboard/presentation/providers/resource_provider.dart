import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/common_provider.dart';
import '../../data/datasources/remote/resource_remote_datasource.dart';
import '../../data/repositories/resource_repository_impl.dart';
import '../../domain/repositories/i_resource_repository.dart';
import '../../domain/usecases/get_student_resources_usecase.dart';
import '../state/resource_state.dart';
import '../view_model/resource_view_model.dart';

final resourceRemoteDatasourceProvider =
Provider<IResourceRemoteDatasource>((ref) {
  return ResourceRemoteDatasource(
    ref.read(apiClientProvider),
    ref.read(userSessionServiceProvider),
  );
});

final resourceRepositoryProvider = Provider<IResourceRepository>((ref) {
  return ResourceRepositoryImpl(ref.read(resourceRemoteDatasourceProvider));
});

final getStudentResourcesUsecaseProvider =
Provider<GetStudentResourcesUsecase>((ref) {
  return GetStudentResourcesUsecase(ref.read(resourceRepositoryProvider));
});

final resourceViewModelProvider =
NotifierProvider<ResourceViewModel, ResourceState>(
      () => ResourceViewModel(),
);