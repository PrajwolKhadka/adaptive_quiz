import 'package:adaptive_quiz/features/quiz/domain/entities/quiz_entity.dart';
import 'package:dio/dio.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoint.dart';
import '../../../../../core/services/storage/user_session_service.dart';


abstract interface class IQuizRemoteDatasource {
  Future<ActiveQuizEntity> getActiveQuiz();
  Future<dynamic> getNextQuestion(String quizId);
  Future<SubmitAnswerEntity> submitAnswer({
    required String quizId,
    required String questionId,
    required String selectedOption,
    required int timeTaken,
  });
}

class QuizRemoteDatasource implements IQuizRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _sessionService;

  QuizRemoteDatasource(this._apiClient, this._sessionService);

  Future<Options> _authOptions() async {
    final token = await _sessionService.getToken();
    if (token == null) throw Exception("No token found. Please login again.");
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<ActiveQuizEntity> getActiveQuiz() async {
    try {
      final options = await _authOptions();
      final response = await _apiClient.get(
        ApiEndpoints.getActiveQuiz,
        options: options,
      );

      final data = response.data as Map<String, dynamic>;
      final available = data['available'] as bool;

      if (!available) {
        return const ActiveQuizEntity(available: false);
      }

      return ActiveQuizEntity(
        available: true,
        quizId: data['quizId'].toString(),
        subject: data['subject'] as String?,
        endTime: data['endTime'] != null
            ? DateTime.tryParse(data['endTime'].toString())
            : null,
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to check active quiz";
      throw Exception(message);
    }
  }

  @override
  Future<dynamic> getNextQuestion(String quizId) async {
    try {
      final options = await _authOptions();
      final response = await _apiClient.post(
        ApiEndpoints.nextQuestion,
        data: {'quizId': quizId},
        options: options,
      );

      final data = response.data as Map<String, dynamic>;

      // Backend returns { done: true, ... } when quiz is finished
      if (data['done'] == true) {
        return QuizResultEntity(
          done: true,
          totalQuestions: (data['totalQuestions'] as num).toInt(),
          correctAnswers: (data['correctAnswers'] as num).toInt(),
          wrongAnswers: (data['wrongAnswers'] as num).toInt(),
          timeTakenSeconds: (data['timeTakenSeconds'] as num).toInt(),
          aiFeedback: data['aiFeedback'] as String? ?? "No feedback available.",
        );
      }

      // Otherwise returns { question: { _id, text, options, difficulty, subject, progress } }
      final q = data['question'] as Map<String, dynamic>;
      final optionsList = (q['options'] as List)
          .map((o) => QuizOptionEntity(
        key: o['key'] as String,
        text: o['text'] as String,
      ))
          .toList();

      final progress = q['progress'] as Map<String, dynamic>;

      return QuizQuestionEntity(
        id: q['_id'].toString(),
        text: q['text'] as String,
        options: optionsList,
        difficulty: q['difficulty'] as String,
        subject: q['subject'] as String,
        progress: QuizProgressEntity(
          answered: (progress['answered'] as num).toInt(),
          total: (progress['total'] as num).toInt(),
        ),
      );
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to get next question";
      throw Exception(message);
    }
  }

  @override
  Future<SubmitAnswerEntity> submitAnswer({
    required String quizId,
    required String questionId,
    required String selectedOption,
    required int timeTaken,
  }) async {
    try {
      final options = await _authOptions();
      final response = await _apiClient.post(
        ApiEndpoints.submitAnswer,
        data: {
          'quizId': quizId,
          'questionId': questionId,
          'selectedOption': selectedOption,
          'timeTaken': timeTaken,
        },
        options: options,
      );

      final correct = response.data['correct'] as bool;
      return SubmitAnswerEntity(correct: correct);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? "Failed to submit answer";
      throw Exception(message);
    }
  }
}