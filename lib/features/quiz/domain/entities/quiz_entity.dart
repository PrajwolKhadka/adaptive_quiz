import 'package:equatable/equatable.dart';

class ActiveQuizEntity extends Equatable {
  final bool available;
  final String? quizId;
  final String? subject;
  final DateTime? endTime;

  const ActiveQuizEntity({
    required this.available,
    this.quizId,
    this.subject,
    this.endTime,
  });

  @override
  List<Object?> get props => [available, quizId, subject, endTime];
}

class QuizOptionEntity extends Equatable {
  final String key;
  final String text;

  const QuizOptionEntity({required this.key, required this.text});

  @override
  List<Object?> get props => [key, text];
}

class QuizProgressEntity extends Equatable {
  final int answered;
  final int total;

  const QuizProgressEntity({required this.answered, required this.total});

  @override
  List<Object?> get props => [answered, total];
}

class QuizQuestionEntity extends Equatable {
  final String id;
  final String text;
  final List<QuizOptionEntity> options;
  final String difficulty;
  final String subject;
  final QuizProgressEntity progress;

  const QuizQuestionEntity({
    required this.id,
    required this.text,
    required this.options,
    required this.difficulty,
    required this.subject,
    required this.progress,
  });

  @override
  List<Object?> get props =>
      [id, text, options, difficulty, subject, progress];
}

class QuizResultEntity extends Equatable {
  final bool done;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int timeTakenSeconds;
  final String aiFeedback;

  const QuizResultEntity({
    required this.done,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.timeTakenSeconds,
    required this.aiFeedback,
  });

  @override
  List<Object?> get props => [
    done,
    totalQuestions,
    correctAnswers,
    wrongAnswers,
    timeTakenSeconds,
    aiFeedback,
  ];
}

class SubmitAnswerEntity extends Equatable {
  final bool correct;
  const SubmitAnswerEntity({required this.correct});

  @override
  List<Object?> get props => [correct];
}