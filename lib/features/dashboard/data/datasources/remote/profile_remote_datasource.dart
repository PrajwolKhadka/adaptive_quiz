import 'package:dio/dio.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoint.dart';
import '../../../../../core/services/storage/user_session_service.dart';
import '../../models/profile_api_model.dart';


abstract interface class IProfileRemoteDatasource {
  Future<ProfileApiModel> getProfile();
  Future<String> uploadProfilePicture(String imagePath);
}

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _sessionService;

  ProfileRemoteDatasource(this._apiClient, this._sessionService);

  Future<Options> _authOptions() async {
    final token = await _sessionService.getToken();
    if (token == null) throw Exception("No token found. Please login again.");
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<ProfileApiModel> getProfile() async {
    try {
      final options = await _authOptions();
      final response = await _apiClient.get(
        ApiEndpoints.getProfile,
        options: options,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        // className comes as int from backend — ensure it stays int
        return ProfileApiModel.fromJson({
          ...data,
          'className': (data['className'] as num).toInt(),
        });
      } else {
        throw Exception("Failed to load profile");
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          "Failed to load profile";
      throw Exception(message);
    }
  }

  @override
  Future<String> uploadProfilePicture(String imagePath) async {
    try {
      final token = await _sessionService.getToken();
      if (token == null) throw Exception("No token found.");

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
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
        return response.data['data']['imageUrl'] as String;
      } else {
        throw Exception("Failed to upload profile picture");
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          "Failed to upload profile picture";
      throw Exception(message);
    }
  }
}