import 'dart:convert';

import 'package:adaptive_quiz/core/api/api_client.dart';
import 'package:adaptive_quiz/core/api/api_endpoint.dart';
import 'package:adaptive_quiz/features/auth/presentation/pages/login_screen.dart';
import 'package:adaptive_quiz/features/auth/presentation/providers/auth_provider.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_viewmodel_provider.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/state/profile_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../core/providers/common_provider.dart';
import '../../../../core/services/storage/user_session_service.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  late final UserSessionService _session;
  late final ApiClient _apiClient;
  final ImagePicker _picker = ImagePicker();

  @override
  ProfileState build() {
    _session = ref.read(userSessionServiceProvider);
    _apiClient = ref.read(apiClientProvider);
    // Future.microtask(() => loadProfile());
    return ProfileState.initial();
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

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);

    final token = await _session.getToken();
    if (token == null) {
      state = state.copyWith(isLoading: false, error: "No token found");
      return;
    }

    try {
      final response = await _apiClient.get(
        ApiEndpoints.getProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print("Profile API response: ${response.data}");
      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];

        state = state.copyWith(
          isLoading: false,
          fullName: data['fullName'],
          email: data['email'],
          className: data['className'],
          imageUrl: data['imageUrl'],
        );

        // Save locally so image persists
        if (data['imageUrl'] != null) {
          await _session.saveRemoteProfileImage(data['imageUrl']);
        }
      } else {
        state = state.copyWith(isLoading: false, error: "Failed to load profile");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Error: $e");
    }
  }


  Future<void> uploadProfilePicture() async {
    if (state.localImagePath == null) return;

    state = state.copyWith(isLoading: true);

    final token = await _session.getToken();
    if (token == null) {
      state = state.copyWith(isLoading: false, error: "No token found");
      return;
    }

    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          state.localImagePath!,
          filename: state.localImagePath!.split('/').last,
        ),
      });

      final response = await _apiClient.put(
        ApiEndpoints.uploadProfilePicture,
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final imageUrl = response.data['data']['imageUrl'];
        // Save locally
        await _session.saveRemoteProfileImage(imageUrl);
        state = state.copyWith(isLoading: false, imageUrl: imageUrl, clearLocalPath: true);

        // // Save locally
        // await _session.saveLocalProfileImage(state.localImagePath!);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to upload image",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Upload error: $e");
    }
  }

  Future<void> logout(BuildContext context) async {
    await _session.clearSession();

    // ref.invalidate(profileViewModelProvider);
    // ref.invalidate(authViewModelProvider);

    imageCache.clear();
    imageCache.clearLiveImages();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );

    Future.microtask(() {
      ref.invalidate(profileViewModelProvider);
      ref.invalidate(authViewModelProvider);
    });
  }
}
