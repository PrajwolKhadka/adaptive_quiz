import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/common_provider.dart';
import '../../data/datasources/remote/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/upload_profile_picture_usecase.dart';
import '../state/profile_state.dart';
import '../view_model/profile_view_model.dart';

//  Remote Datasource
final profileRemoteDatasourceProvider = Provider<IProfileRemoteDatasource>((ref) {
  return ProfileRemoteDatasource(
    ref.read(apiClientProvider),
    ref.read(userSessionServiceProvider),
  );
});

//Repository
final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    ref.read(profileRemoteDatasourceProvider),
  );
});

// Use Cases
final getProfileUsecaseProvider = Provider<GetProfileUsecase>((ref) {
  return GetProfileUsecase(ref.read(profileRepositoryProvider));
});

final uploadProfilePictureUsecaseProvider = Provider<UploadProfilePictureUsecase>((ref) {
  return UploadProfilePictureUsecase(ref.read(profileRepositoryProvider));
});

// ViewModel
final profileViewModelProvider =
NotifierProvider.autoDispose<ProfileViewModel, ProfileState>(
      () => ProfileViewModel(),
);