import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/homepage_screen.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quiz_entity.dart';
import '../providers/quiz_provider.dart';
import '../state/quiz_state.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    super.initState();
    // If quiz already completed this session, skip lobby → show result
    final existing = ref.read(quizViewModelProvider);
    if (existing.result != null) {
      Future.microtask(
              () => ref.read(quizViewModelProvider.notifier).showExistingResult());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizViewModelProvider);

    return Scaffold(

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFBEE1FA),
            ],
          ),
        ),
        child: SafeArea(
          child: switch (state.status) {
            QuizStatus.idle     => _LobbyView(state: state),
            QuizStatus.noQuiz   => const _NoQuizView(),
            QuizStatus.loading  => const _LoadingView(),
            QuizStatus.question => _QuestionView(state: state),
            QuizStatus.answered => _QuestionView(state: state),
            QuizStatus.finished => _ResultView(state: state),
            QuizStatus.error    => _ErrorView(state: state),
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Loading
// ─────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFF1D61E7),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Loading...",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Lobby
// ─────────────────────────────────────────────
class _LobbyView extends ConsumerWidget {
  final QuizState state;
  const _LobbyView({required this.state});

  String _timeRemaining(DateTime? endTime) {
    if (endTime == null) return "";
    final diff = endTime.difference(DateTime.now());
    if (diff.isNegative) return "Ended";
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    if (h > 0) return "${h}h ${m}m left";
    return "${m}m left";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quiz = state.activeQuiz;
    final timeLeft = _timeRemaining(quiz?.endTime);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          ),

          const Spacer(),

          // Subject label
          if (quiz?.subject != null)
            Text(
              quiz!.subject!.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D61E7),
                letterSpacing: 1.5,
              ),
            ),

          const SizedBox(height: 10),

          const Text(
            "Ready to\nbegin?",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              height: 1.1,
              letterSpacing: -1.0,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            "Questions adapt to your level as you go.\nDo your best — every answer helps.",
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),

          const SizedBox(height: 28),

          // Info row
          Row(
            children: [
              if (timeLeft.isNotEmpty) ...[
                const Icon(Icons.access_time_rounded,
                    size: 15, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 5),
                Text(
                  timeLeft,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
              ],
              const Icon(Icons.psychology_rounded,
                  size: 15, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 5),
              const Text(
                "Adaptive difficulty",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Start button
          GestureDetector(
            onTap: () =>
                ref.read(quizViewModelProvider.notifier).startQuiz(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Start Quiz",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// No Quiz
// ─────────────────────────────────────────────
class _NoQuizView extends ConsumerWidget {
  const _NoQuizView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          ),
          const Spacer(),
          const Text(
            "No quiz\navailable",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              height: 1.1,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "There's no quiz scheduled for your class right now.\nCheck back later.",
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                ref.read(quizViewModelProvider.notifier).checkActiveQuiz(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Refresh",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Question
// ─────────────────────────────────────────────
class _QuestionView extends ConsumerWidget {
  final QuizState state;
  const _QuestionView({required this.state});

  Color _difficultyColor(String d) => switch (d.toUpperCase()) {
    'VERY EASY' => const Color(0xFF16A34A),
    'EASY'      => const Color(0xFF22C55E),
    'MEDIUM'    => const Color(0xFFD97706),
    'HARD'      => const Color(0xFFEA580C),
    'VERY HARD' => const Color(0xFFDC2626),
    _           => const Color(0xFF6B7280),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = state.currentQuestion!;
    final answered = state.status == QuizStatus.answered;
    final progress = q.progress;

    return Column(
      children: [
        // ── Top bar ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              // Progress fraction
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
              // Progress bar
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (progress.answered + 1) / progress.total,
                    backgroundColor: const Color(0xFFF3F4F6),
                    valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF1D61E7)),
                    minHeight: 5,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Timer
              Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 14, color: Color(0xFF9CA3AF)),
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

        // Divider
        const Divider(color: Color(0xFFF3F4F6), height: 1),

        // ── Scrollable body ──────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject + difficulty
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
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _difficultyColor(q.difficulty)
                            .withOpacity(0.08),
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

                // Question text
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

                // Options
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
                      trailing = const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF22C55E), size: 20);
                    } else if (isSelected && state.wasCorrect == false) {
                      bg = const Color(0xFFFEF2F2);
                      border = const Color(0xFFEF4444);
                      keyBg = const Color(0xFFEF4444);
                      keyText = Colors.white;
                      optionText = const Color(0xFFB91C1C);
                      trailing = const Icon(Icons.cancel_rounded,
                          color: Color(0xFFEF4444), size: 20);
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
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: border, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          // Key
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

                // Feedback + Next
                if (answered) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: state.wasCorrect == true
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      state.wasCorrect == true
                          ? "✓  Correct!"
                          : "✗  Incorrect",
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
                    onTap: () => ref
                        .read(quizViewModelProvider.notifier)
                        .nextQuestion(),
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

// ─────────────────────────────────────────────
// Result
// ─────────────────────────────────────────────
class _ResultView extends ConsumerWidget {
  final QuizState state;
  const _ResultView({required this.state});

  String _formatTime(int s) =>
      '${s ~/ 60}m ${s % 60}s';

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
          // Accuracy number
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

          // Stat row
          Row(
            children: [
              _stat("Score",
                  "${result.correctAnswers}/${result.totalQuestions}",
                  const Color(0xFF111827)),
              _divider(),
              _stat("Time", _formatTime(result.timeTakenSeconds),
                  const Color(0xFF111827)),
              _divider(),
              _stat("Wrong", "${result.wrongAnswers}",
                  const Color(0xFFDC2626)),
            ],
          ),

          const SizedBox(height: 32),

          // Thin divider
          const Divider(color: Color(0xFFF3F4F6)),

          const SizedBox(height: 24),

          // AI Feedback label
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

          // Back to Home
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

  Widget _stat(String label, String value, Color color) {
    return Expanded(
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
  }

  Widget _divider() => Container(
    width: 1,
    height: 36,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: const Color(0xFFE5E7EB),
  );
}

// ─────────────────────────────────────────────
// Error
// ─────────────────────────────────────────────
class _ErrorView extends ConsumerWidget {
  final QuizState state;
  const _ErrorView({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          ),
          const Spacer(),
          const Text(
            "Something\nwent wrong",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              height: 1.1,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            state.error ?? "Please try again.",
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () =>
                ref.read(quizViewModelProvider.notifier).checkActiveQuiz(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Try Again",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}