import 'package:adaptive_quiz/core/api/api_client.dart';
import 'package:adaptive_quiz/core/api/api_endpoint.dart';
import 'package:adaptive_quiz/features/auth/data/models/auth_api_model.dart';
import 'package:dio/dio.dart';


abstract interface class IAuthRemoteDatasource {
  Future<AuthApiModel> login(String email, String password);
}

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasource(this._apiClient);

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
      throw Exception(e.message);
    }
  }
}