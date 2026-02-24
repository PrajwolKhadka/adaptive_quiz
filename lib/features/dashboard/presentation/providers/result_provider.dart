import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/common_provider.dart';
import '../../data/datasources/remote/result_remote_datasource.dart';
import '../../data/repositories/result_repository_impl.dart';
import '../../domain/repositories/i_result_repository.dart';
import '../../domain/usecases/result_usecases.dart';
import '../state/result_state.dart';
import '../view_model/result_view_model.dart';

// 1. Remote Datasource
final resultRemoteDatasourceProvider =
Provider<IResultRemoteDatasource>((ref) {
  return ResultRemoteDatasource(
    ref.read(apiClientProvider),
    ref.read(userSessionServiceProvider),
  );
});

// 2. Repository
final resultRepositoryProvider = Provider<IResultRepository>((ref) {
  return ResultRepositoryImpl(ref.read(resultRemoteDatasourceProvider));
});

// 3. Use Cases
final getMyHistoryUsecaseProvider = Provider<GetMyHistoryUsecase>((ref) {
  return GetMyHistoryUsecase(ref.read(resultRepositoryProvider));
});

final getPerformanceGraphUsecaseProvider =
Provider<GetPerformanceGraphUsecase>((ref) {
  return GetPerformanceGraphUsecase(ref.read(resultRepositoryProvider));
});

final getMyResultDetailUsecaseProvider =
Provider<GetMyResultDetailUsecase>((ref) {
  return GetMyResultDetailUsecase(ref.read(resultRepositoryProvider));
});

// 4. ViewModel
final resultViewModelProvider =
NotifierProvider<ResultViewModel, ResultState>(
      () => ResultViewModel(),
);