import 'package:equatable/equatable.dart';

class QuestionStatEntity extends Equatable {
  final String questionId;
  final bool correct;
  final int timeTaken;

  const QuestionStatEntity({
    required this.questionId,
    required this.correct,
    required this.timeTaken,
  });

  @override
  List<Object?> get props => [questionId, correct, timeTaken];
}

class QuizInfoEntity extends Equatable {
  final String id;
  final String subject;
  final int classLevel;
  final DateTime? startTime;
  final DateTime? endTime;

  const QuizInfoEntity({
    required this.id,
    required this.subject,
    required this.classLevel,
    this.startTime,
    this.endTime,
  });

  @override
  List<Object?> get props => [id, subject, classLevel, startTime, endTime];
}

class QuizHistoryEntity extends Equatable {
  final String resultId;
  final QuizInfoEntity quiz;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double accuracy;
  final int timeTaken;
  final DateTime completedAt;

  const QuizHistoryEntity({
    required this.resultId,
    required this.quiz,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracy,
    required this.timeTaken,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [
    resultId,
    quiz,
    totalQuestions,
    correctAnswers,
    wrongAnswers,
    accuracy,
    timeTaken,
    completedAt,
  ];
}

class QuizResultDetailEntity extends QuizHistoryEntity {
  final String aiFeedback;
  final List<QuestionStatEntity> questionStats;

  const QuizResultDetailEntity({
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

  @override
  List<Object?> get props => [...super.props, aiFeedback, questionStats];
}

// Graph data per subject
class SubjectGraphPoint extends Equatable {
  final DateTime date;
  final double accuracy;
  final int score;
  final int total;

  const SubjectGraphPoint({
    required this.date,
    required this.accuracy,
    required this.score,
    required this.total,
  });

  @override
  List<Object?> get props => [date, accuracy, score, total];
}