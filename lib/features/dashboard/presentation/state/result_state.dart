import '../../domain/entities/result_entity.dart';

class ResultState {
  final bool isLoading;
  final String? error;
  final List<QuizHistoryEntity> history;
  final Map<String, List<SubjectGraphPoint>> graph;

  // Detail state
  final bool isLoadingDetail;
  final String? detailError;
  final QuizResultDetailEntity? detail;

  ResultState({
    required this.isLoading,
    this.error,
    required this.history,
    required this.graph,
    required this.isLoadingDetail,
    this.detailError,
    this.detail,
  });

  factory ResultState.initial() => ResultState(
    isLoading: false,
    history: [],
    graph: {},
    isLoadingDetail: false,
  );

  ResultState copyWith({
    bool? isLoading,
    String? error,
    List<QuizHistoryEntity>? history,
    Map<String, List<SubjectGraphPoint>>? graph,
    bool? isLoadingDetail,
    String? detailError,
    QuizResultDetailEntity? detail,
  }) {
    return ResultState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      history: history ?? this.history,
      graph: graph ?? this.graph,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      detailError: detailError,
      detail: detail ?? this.detail,
    );
  }
}