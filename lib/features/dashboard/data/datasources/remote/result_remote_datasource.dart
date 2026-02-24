import 'package:dio/dio.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoint.dart';
import '../../../../../core/services/storage/user_session_service.dart';
import '../../../domain/entities/result_entity.dart';
import '../../models/result_api_model.dart';


abstract interface class IResultRemoteDatasource {
  Future<List<QuizHistoryApiModel>> getMyHistory();
  Future<Map<String, List<SubjectGraphPoint>>> getPerformanceGraph();
  Future<QuizResultDetailApiModel> getMyResultDetail(String quizId);
}

class ResultRemoteDatasource implements IResultRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _sessionService;

  ResultRemoteDatasource(this._apiClient, this._sessionService);

  Future<Options> _authOptions() async {
    final token = await _sessionService.getToken();
    if (token == null) throw Exception("No token found. Please login again.");
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<QuizHistoryApiModel>> getMyHistory() async {
    try {
      final options = await _authOptions();
      final response = await _apiClient.get(
        ApiEndpoints.getMyResults,
        options: options,
      );

      if (response.statusCode == 200) {
        final List history = response.data['history'] as List;
        return history
            .map((e) =>
            QuizHistoryApiModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception("Failed to load results");
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to load results";
      throw Exception(message);
    }
  }

  @override
  Future<Map<String, List<SubjectGraphPoint>>> getPerformanceGraph() async {
    try {
      final options = await _authOptions();
      final response = await _apiClient.get(
        ApiEndpoints.getMyResults,
        options: options,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> graph =
        response.data['graph'] as Map<String, dynamic>;

        return graph.map((subject, points) {
          final List pointList = points as List;
          return MapEntry(
            subject,
            pointList.map((p) {
              final map = p as Map<String, dynamic>;
              return SubjectGraphPoint(
                date: DateTime.parse(map['date'].toString()),
                accuracy: (map['accuracy'] as num).toDouble(),
                score: (map['score'] as num).toInt(),
                total: (map['total'] as num).toInt(),
              );
            }).toList(),
          );
        });
      }
      throw Exception("Failed to load graph data");
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to load graph data";
      throw Exception(message);
    }
  }

  @override
  Future<QuizResultDetailApiModel> getMyResultDetail(String quizId) async {
    try {
      final options = await _authOptions();
      final response = await _apiClient.get(
        '${ApiEndpoints.getMyResults}/$quizId',
        options: options,
      );

      if (response.statusCode == 200) {
        return QuizResultDetailApiModel.fromJson(
            response.data['result'] as Map<String, dynamic>);
      }
      throw Exception("Failed to load result detail");
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to load result detail";
      throw Exception(message);
    }
  }
}