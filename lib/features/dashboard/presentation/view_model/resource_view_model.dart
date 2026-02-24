import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_student_resources_usecase.dart';
import '../providers/resource_provider.dart';
import '../state/resource_state.dart';

class ResourceViewModel extends Notifier<ResourceState> {
  late final GetStudentResourcesUsecase _getStudentResourcesUsecase;

  @override
  ResourceState build() {
    _getStudentResourcesUsecase = ref.read(getStudentResourcesUsecaseProvider);
    Future.microtask(() => loadResources());
    return ResourceState.initial();
  }

  Future<void> loadResources() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getStudentResourcesUsecase();

    result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
          (resources) {
        state = state.copyWith(isLoading: false, resources: resources);
      },
    );
  }
}