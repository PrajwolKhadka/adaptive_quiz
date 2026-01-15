import 'package:adaptive_quiz/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:adaptive_quiz/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:adaptive_quiz/features/auth/data/repositories/auth_repository.dart';
import 'package:adaptive_quiz/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:adaptive_quiz/features/auth/presentation/state/auth_state.dart';
import 'package:adaptive_quiz/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/common_provider.dart';

// 1. Data Sources
final authRemoteDatasourceProvider = Provider<IAuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRemoteDatasource(apiClient);
});

final authLocalDatasourceProvider = Provider<IAuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return AuthLocalDatasource(hiveService);
});

// 2. Repository Implementation
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authRemoteDatasourceProvider),
    ref.read(authLocalDatasourceProvider),
  );
});

// 3. View Model
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});