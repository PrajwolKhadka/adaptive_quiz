import 'package:adaptive_quiz/core/api/api_client.dart';
import 'package:adaptive_quiz/core/api/api_endpoint.dart';
import 'package:adaptive_quiz/core/services/storage/user_session_service.dart';
import 'package:adaptive_quiz/features/auth/data/models/auth_api_model.dart';
import 'package:dio/dio.dart';


abstract interface class IAuthRemoteDatasource {
  Future<AuthApiModel> login(String email, String password);
  Future<void> changePassword(String newPassword);
}

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _sessionService;

  AuthRemoteDatasource(this._apiClient, this._sessionService);

  @override
  Future<AuthApiModel> login(String email, String password) async {
    try {
      Response response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        // Convert the JSON response to your Model
        return AuthApiModel.fromJson(response.data);
      } else {
        throw Exception("Login Failed");
      }
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
              e.response?.data?['error'] ??
              "Invalid credentials";

      throw Exception(message);
    }
  }

  @override
  Future<void> changePassword(String newPassword) async {
    final token = await _sessionService.getToken();
    if (token == null) throw Exception("No token found. Please login again.");
    await _apiClient.post(
      ApiEndpoints.changePassword,
      data: {'newPassword': newPassword},
      options: Options(headers: {'Authorization': 'Bearer $token'}),

    );
  }

}