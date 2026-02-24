import '../../domain/entities/resource_entity.dart';

class ResourceState {
  final bool isLoading;
  final String? error;
  final List<ResourceEntity> resources;

  ResourceState({
    required this.isLoading,
    this.error,
    required this.resources,
  });

  factory ResourceState.initial() => ResourceState(
    isLoading: false,
    resources: [],
  );

  ResourceState copyWith({
    bool? isLoading,
    String? error,
    List<ResourceEntity>? resources,
  }) {
    return ResourceState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      resources: resources ?? this.resources,
    );
  }
}