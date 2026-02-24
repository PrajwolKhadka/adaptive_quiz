// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionStatApiModel _$QuestionStatApiModelFromJson(
        Map<String, dynamic> json) =>
    QuestionStatApiModel(
      questionId: json['questionId'] as String,
      correct: json['correct'] as bool,
      timeTaken: (json['timeTaken'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionStatApiModelToJson(
        QuestionStatApiModel instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'correct': instance.correct,
      'timeTaken': instance.timeTaken,
    };

QuizInfoApiModel _$QuizInfoApiModelFromJson(Map<String, dynamic> json) =>
    QuizInfoApiModel(
      id: json['id'] as String,
      subject: json['subject'] as String,
      classLevel: (json['classLevel'] as num).toInt(),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
    );

Map<String, dynamic> _$QuizInfoApiModelToJson(QuizInfoApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'classLevel': instance.classLevel,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

QuizHistoryApiModel _$QuizHistoryApiModelFromJson(Map<String, dynamic> json) =>
    QuizHistoryApiModel(
      resultId: json['resultId'] as String,
      quiz: QuizInfoApiModel.fromJson(json['quiz'] as Map<String, dynamic>),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      correctAnswers: (json['correctAnswers'] as num).toInt(),
      wrongAnswers: (json['wrongAnswers'] as num).toInt(),
      accuracy: (json['accuracy'] as num).toDouble(),
      timeTaken: (json['timeTaken'] as num).toInt(),
      completedAt: json['completedAt'] as String,
    );

Map<String, dynamic> _$QuizHistoryApiModelToJson(
        QuizHistoryApiModel instance) =>
    <String, dynamic>{
      'resultId': instance.resultId,
      'quiz': instance.quiz,
      'totalQuestions': instance.totalQuestions,
      'correctAnswers': instance.correctAnswers,
      'wrongAnswers': instance.wrongAnswers,
      'accuracy': instance.accuracy,
      'timeTaken': instance.timeTaken,
      'completedAt': instance.completedAt,
    };

QuizResultDetailApiModel _$QuizResultDetailApiModelFromJson(
        Map<String, dynamic> json) =>
    QuizResultDetailApiModel(
      resultId: json['resultId'] as String,
      quiz: QuizInfoApiModel.fromJson(json['quiz'] as Map<String, dynamic>),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      correctAnswers: (json['correctAnswers'] as num).toInt(),
      wrongAnswers: (json['wrongAnswers'] as num).toInt(),
      accuracy: (json['accuracy'] as num).toDouble(),
      timeTaken: (json['timeTaken'] as num).toInt(),
      completedAt: json['completedAt'] as String,
      aiFeedback: json['aiFeedback'] as String,
      questionStats: (json['questionStats'] as List<dynamic>)
          .map((e) => QuestionStatApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizResultDetailApiModelToJson(
        QuizResultDetailApiModel instance) =>
    <String, dynamic>{
      'resultId': instance.resultId,
      'quiz': instance.quiz,
      'totalQuestions': instance.totalQuestions,
      'correctAnswers': instance.correctAnswers,
      'wrongAnswers': instance.wrongAnswers,
      'accuracy': instance.accuracy,
      'timeTaken': instance.timeTaken,
      'completedAt': instance.completedAt,
      'aiFeedback': instance.aiFeedback,
      'questionStats': instance.questionStats,
    };
