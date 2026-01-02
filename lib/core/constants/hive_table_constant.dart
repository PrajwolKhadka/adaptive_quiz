class HiveTableConstant {
  HiveTableConstant._();

  static const String dbName = "adaptive_quiz_db";

  // Users / Students
  static const int userTypeId = 0;
  static const String userTable = "user_table";

  // Quizzes
  static const int quizTypeId = 1;
  static const String quizTable = "quiz_table";

  // Questions
  static const int questionTypeId = 2;
  static const String questionTable = "question_table";

  // Results / Scores
  static const int resultTypeId = 3;
  static const String resultTable = "result_table";
}
