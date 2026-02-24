import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/result_usecases.dart';
import '../providers/result_provider.dart';
import '../state/result_state.dart';

class ResultViewModel extends Notifier<ResultState> {
  late final GetMyHistoryUsecase _getMyHistory;
  late final GetPerformanceGraphUsecase _getPerformanceGraph;
  late final GetMyResultDetailUsecase _getMyResultDetail;

  @override
  ResultState build() {
    _getMyHistory = ref.read(getMyHistoryUsecaseProvider);
    _getPerformanceGraph = ref.read(getPerformanceGraphUsecaseProvider);
    _getMyResultDetail = ref.read(getMyResultDetailUsecaseProvider);
    Future.microtask(() => loadHistory());
    return ResultState.initial();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, error: null);

    final historyResult = await _getMyHistory();
    final graphResult = await _getPerformanceGraph();

    historyResult.fold(
          (failure) =>
      state = state.copyWith(isLoading: false, error: failure.message),
          (history) {
        graphResult.fold(
              (_) => state = state.copyWith(isLoading: false, history: history),
              (graph) => state =
              state.copyWith(isLoading: false, history: history, graph: graph),
        );
      },
    );
  }

  Future<void> loadResultDetail(String quizId) async {
    state = state.copyWith(isLoadingDetail: true, detailError: null);

    final result = await _getMyResultDetail(quizId);

    result.fold(
          (failure) => state =
          state.copyWith(isLoadingDetail: false, detailError: failure.message),
          (detail) =>
      state = state.copyWith(isLoadingDetail: false, detail: detail),
    );
  }
}