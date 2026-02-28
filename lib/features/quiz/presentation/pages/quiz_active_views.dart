import 'package:adaptive_quiz/features/dashboard/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_provider.dart';
import '../state/quiz_state.dart';

class QuizQuestionView extends ConsumerWidget {
  final QuizState state;
  const QuizQuestionView({super.key, required this.state});

  Color _difficultyColor(String d) => switch (d.toUpperCase()) {
    'VERY EASY' => const Color(0xFF16A34A),
    'EASY' => const Color(0xFF22C55E),
    'MEDIUM' => const Color(0xFFD97706),
    'HARD' => const Color(0xFFEA580C),
    'VERY HARD' => const Color(0xFFDC2626),
    _ => const Color(0xFF6B7280),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = state.currentQuestion!;
    final answered = state.status == QuizStatus.answered;
    final progress = q.progress;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${progress.answered + 1}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    TextSpan(
                      text: " / ${progress.total}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (progress.answered + 1) / progress.total,
                    backgroundColor: const Color(0xFFF3F4F6),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF1D61E7)),
                    minHeight: 5,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    size: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${state.questionTimer}s",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: Color(0xFFF3F4F6), height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      q.subject,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _difficultyColor(q.difficulty).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        q.difficulty,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _difficultyColor(q.difficulty),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  q.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    height: 1.45,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 28),
                ...q.options.map((option) {
                  final isSelected = state.selectedOption == option.key;

                  Color bg, border, keyBg, keyText, optionText;
                  Widget? trailing;

                  if (answered) {
                    if (isSelected && state.wasCorrect == true) {
                      bg = const Color(0xFFF0FDF4);
                      border = const Color(0xFF22C55E);
                      keyBg = const Color(0xFF22C55E);
                      keyText = Colors.white;
                      optionText = const Color(0xFF15803D);
                      trailing = const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF22C55E),
                        size: 20,
                      );
                    } else if (isSelected && state.wasCorrect == false) {
                      bg = const Color(0xFFFEF2F2);
                      border = const Color(0xFFEF4444);
                      keyBg = const Color(0xFFEF4444);
                      keyText = Colors.white;
                      optionText = const Color(0xFFB91C1C);
                      trailing = const Icon(
                        Icons.cancel_rounded,
                        color: Color(0xFFEF4444),
                        size: 20,
                      );
                    } else {
                      bg = Colors.white;
                      border = const Color(0xFFF3F4F6);
                      keyBg = const Color(0xFFF9FAFB);
                      keyText = const Color(0xFFD1D5DB);
                      optionText = const Color(0xFFD1D5DB);
                    }
                  } else {
                    if (isSelected) {
                      bg = const Color(0xFFEFF6FF);
                      border = const Color(0xFF1D61E7);
                      keyBg = const Color(0xFF1D61E7);
                      keyText = Colors.white;
                      optionText = const Color(0xFF1D4ED8);
                    } else {
                      bg = Colors.white;
                      border = const Color(0xFFE5E7EB);
                      keyBg = const Color(0xFFF9FAFB);
                      keyText = const Color(0xFF9CA3AF);
                      optionText = const Color(0xFF374151);
                    }
                  }

                  return GestureDetector(
                    onTap: answered || state.isSubmitting
                        ? null
                        : () => ref
                              .read(quizViewModelProvider.notifier)
                              .submitAnswer(option.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: keyBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                option.key.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: keyText,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option.text,
                              style: TextStyle(
                                fontSize: 15,
                                color: optionText,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                          if (trailing != null) ...[
                            const SizedBox(width: 8),
                            trailing,
                          ],
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                if (answered) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: state.wasCorrect == true
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      state.wasCorrect == true ? "✓  Correct!" : "✗  Incorrect",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: state.wasCorrect == true
                            ? const Color(0xFF15803D)
                            : const Color(0xFFB91C1C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () =>
                        ref.read(quizViewModelProvider.notifier).nextQuestion(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          "Next Question →",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class QuizResultView extends ConsumerWidget {
  final QuizState state;
  const QuizResultView({super.key, required this.state});

  String _formatTime(int s) => '${s ~/ 60}m ${s % 60}s';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = state.result!;
    final accuracy = result.totalQuestions == 0
        ? 0.0
        : (result.correctAnswers / result.totalQuestions) * 100;

    final Color accentColor;
    final String headline;
    final String subline;

    if (accuracy >= 80) {
      accentColor = const Color(0xFF16A34A);
      headline = "Excellent work!";
      subline = "You're performing at a high level.";
    } else if (accuracy >= 50) {
      accentColor = const Color(0xFFD97706);
      headline = "Good effort!";
      subline = "Keep practicing to improve further.";
    } else {
      accentColor = const Color(0xFFDC2626);
      headline = "Keep going!";
      subline = "Every attempt makes you stronger.";
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${accuracy.toStringAsFixed(0)}%",
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: accentColor,
              letterSpacing: -3,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            headline,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subline,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _stat(
                "Score",
                "${result.correctAnswers}/${result.totalQuestions}",
                const Color(0xFF111827),
              ),
              _divider(),
              _stat(
                "Time",
                _formatTime(result.timeTakenSeconds),
                const Color(0xFF111827),
              ),
              _divider(),
              _stat("Wrong", "${result.wrongAnswers}", const Color(0xFFDC2626)),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFF3F4F6)),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF1D61E7),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "AI Feedback",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            result.aiFeedback,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainScreen()),
              (_) => false,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color color) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  Widget _divider() => Container(
    width: 1,
    height: 36,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: const Color(0xFFE5E7EB),
  );
}
