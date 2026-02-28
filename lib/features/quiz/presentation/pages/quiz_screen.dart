import 'package:adaptive_quiz/features/quiz/presentation/pages/quiz_active_views.dart';
import 'package:adaptive_quiz/features/quiz/presentation/pages/quiz_lobby_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final existing = ref.read(quizViewModelProvider);
    if (existing.result != null) {
      Future.microtask(
        () => ref.read(quizViewModelProvider.notifier).showExistingResult(),
      );
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
            colors: [Color(0xFFFFFFFF), Color(0xFFBEE1FA)],
          ),
        ),
        child: SafeArea(
          child: switch (state.status) {
            QuizStatus.idle => QuizLobbyView(state: state),
            QuizStatus.noQuiz => const QuizNoQuizView(),
            QuizStatus.loading => const QuizLoadingView(),
            QuizStatus.question => QuizQuestionView(state: state),
            QuizStatus.answered => QuizQuestionView(state: state),
            QuizStatus.finished => QuizResultView(state: state),
            QuizStatus.error => QuizErrorView(state: state),
          },
        ),
      ),
    );
  }
}
