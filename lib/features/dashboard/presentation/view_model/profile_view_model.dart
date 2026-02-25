import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../../core/providers/common_provider.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/upload_profile_picture_usecase.dart';
import '../pages/bottom_screen/profile_screen.dart';
import '../providers/profile_provider.dart';
import '../state/profile_state.dart';
import 'package:adaptive_quiz/features/auth/presentation/pages/login_screen.dart';
import 'package:adaptive_quiz/features/auth/presentation/providers/auth_provider.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  late final UserSessionService _session;
  late final GetProfileUsecase _getProfileUsecase;
  late final UploadProfilePictureUsecase _uploadProfilePictureUsecase;
  final ImagePicker _picker = ImagePicker();

  @override
  ProfileState build() {
    _session = ref.read(userSessionServiceProvider);
    _getProfileUsecase = ref.read(getProfileUsecaseProvider);
    _uploadProfilePictureUsecase = ref.read(uploadProfilePictureUsecaseProvider);
    Future.microtask(() => loadProfile());
    return ProfileState.initial();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getProfileUsecase();
    if (!ref.mounted) return;

    result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
          (profile) async {
        state = state.copyWith(
          isLoading: false,
          fullName: profile.fullName,
          email: profile.email,
          className: profile.className,
          imageUrl: profile.imageUrl,
        );

        // Persist image URL locally
        if (profile.imageUrl != null) {
          await _session.saveRemoteProfileImage(profile.imageUrl!);
        }
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 600,
      );
      if (pickedFile != null) {
        state = state.copyWith(localImagePath: pickedFile.path);
      }
    } catch (e) {
      state = state.copyWith(error: "Failed to pick image: $e");
    }
  }

  Future<void> uploadProfilePicture() async {
    if (state.localImagePath == null) return;
    state = state.copyWith(isLoading: true, error: null);

    final result = await _uploadProfilePictureUsecase(state.localImagePath!);
    if (!ref.mounted) return;

    result.fold(
          (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
          (imageUrl) async {
        await _session.saveRemoteProfileImage(imageUrl);
        state = state.copyWith(
          isLoading: false,
          imageUrl: imageUrl,
          clearLocalPath: true,
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await _session.clearSession();

    imageCache.clear();
    imageCache.clearLiveImages();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
    );

    Future.microtask(() {
      if (ref.mounted) {
        ref.invalidate(profileViewModelProvider);
        ref.invalidate(authViewModelProvider);
      }
    });
  }

}