import 'package:dio/dio.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoint.dart';
import '../../../../../core/services/storage/user_session_service.dart';
import '../../models/resource_api_model.dart';


abstract interface class IResourceRemoteDatasource {
  Future<List<ResourceApiModel>> getStudentResources();
}

class ResourceRemoteDatasource implements IResourceRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _sessionService;

  ResourceRemoteDatasource(this._apiClient, this._sessionService);

  @override
  Future<List<ResourceApiModel>> getStudentResources() async {
    try {
      final token = await _sessionService.getToken();
      if (token == null) throw Exception("No token found.");

      final response = await _apiClient.get(
        ApiEndpoints.getResources,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'] as List;
        return data
            .map((e) => ResourceApiModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Failed to load resources");
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          "Failed to load resources";
      throw Exception(message);
    }
  }
}