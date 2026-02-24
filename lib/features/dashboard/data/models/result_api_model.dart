import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/result_entity.dart';

part 'result_api_model.g.dart';

@JsonSerializable()
class QuestionStatApiModel {
  final String questionId;
  final bool correct;
  final int timeTaken;

  QuestionStatApiModel({
    required this.questionId,
    required this.correct,
    required this.timeTaken,
  });

  factory QuestionStatApiModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionStatApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionStatApiModelToJson(this);

  QuestionStatEntity toEntity() => QuestionStatEntity(
    questionId: questionId,
    correct: correct,
    timeTaken: timeTaken,
  );
}

@JsonSerializable()
class QuizInfoApiModel {
  final String id;
  final String subject;
  final int classLevel;
  final String? startTime;
  final String? endTime;

  QuizInfoApiModel({
    required this.id,
    required this.subject,
    required this.classLevel,
    this.startTime,
    this.endTime,
  });

  factory QuizInfoApiModel.fromJson(Map<String, dynamic> json) =>
      _$QuizInfoApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuizInfoApiModelToJson(this);

  QuizInfoEntity toEntity() => QuizInfoEntity(
    id: id,
    subject: subject,
    classLevel: classLevel,
    startTime: startTime != null ? DateTime.tryParse(startTime!) : null,
    endTime: endTime != null ? DateTime.tryParse(endTime!) : null,
  );
}

@JsonSerializable()
class QuizHistoryApiModel {
  final String resultId;
  final QuizInfoApiModel quiz;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double accuracy;
  final int timeTaken;
  final String completedAt;

  QuizHistoryApiModel({
    required this.resultId,
    required this.quiz,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracy,
    required this.timeTaken,
    required this.completedAt,
  });

  factory QuizHistoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$QuizHistoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuizHistoryApiModelToJson(this);

  QuizHistoryEntity toEntity() => QuizHistoryEntity(
    resultId: resultId,
    quiz: quiz.toEntity(),
    totalQuestions: totalQuestions,
    correctAnswers: correctAnswers,
    wrongAnswers: wrongAnswers,
    accuracy: accuracy,
    timeTaken: timeTaken,
    completedAt: DateTime.parse(completedAt),
  );
}

@JsonSerializable()
class QuizResultDetailApiModel extends QuizHistoryApiModel {
  final String aiFeedback;
  final List<QuestionStatApiModel> questionStats;

  QuizResultDetailApiModel({
    required super.resultId,
    required super.quiz,
    required super.totalQuestions,
    required super.correctAnswers,
    required super.wrongAnswers,
    required super.accuracy,
    required super.timeTaken,
    required super.completedAt,
    required this.aiFeedback,
    required this.questionStats,
  });

  factory QuizResultDetailApiModel.fromJson(Map<String, dynamic> json) =>
      _$QuizResultDetailApiModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$QuizResultDetailApiModelToJson(this);

  QuizResultDetailEntity toDetailEntity() => QuizResultDetailEntity(
    resultId: resultId,
    quiz: quiz.toEntity(),
    totalQuestions: totalQuestions,
    correctAnswers: correctAnswers,
    wrongAnswers: wrongAnswers,
    accuracy: accuracy,
    timeTaken: timeTaken,
    completedAt: DateTime.parse(completedAt),
    aiFeedback: aiFeedback,
    questionStats: questionStats.map((q) => q.toEntity()).toList(),
  );
}