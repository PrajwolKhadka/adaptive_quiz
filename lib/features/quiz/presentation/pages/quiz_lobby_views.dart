import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quiz_provider.dart';
import '../state/quiz_state.dart';

class QuizLoadingView extends StatelessWidget {
  const QuizLoadingView();

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

class QuizLobbyView extends ConsumerWidget {
  final QuizState state;
  const QuizLobbyView({super.key, required this.state});

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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          ),
          const Spacer(),
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
          Row(
            children: [
              if (timeLeft.isNotEmpty) ...[
                const Icon(
                  Icons.access_time_rounded,
                  size: 15,
                  color: Color(0xFF9CA3AF),
                ),
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
              const Icon(
                Icons.psychology_rounded,
                size: 15,
                color: Color(0xFF9CA3AF),
              ),
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
          GestureDetector(
            onTap: () => ref.read(quizViewModelProvider.notifier).startQuiz(),
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

class QuizNoQuizView extends ConsumerWidget {
  const QuizNoQuizView({super.key});

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

class QuizErrorView extends ConsumerWidget {
  final QuizState state;
  const QuizErrorView({super.key, required this.state});

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
