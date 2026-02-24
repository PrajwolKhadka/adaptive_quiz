import 'package:adaptive_quiz/features/dashboard/domain/entities/result_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/result_provider.dart';
import 'result_detail_screen.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s}s';
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_month(date.month)} ${date.year}';
  }

  String _month(int m) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m];
  }

  Color _accuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resultViewModelProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFBEE1FA)],
        ),
      ),
      child: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.error != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.error!,
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref
                    .read(resultViewModelProvider.notifier)
                    .loadHistory(),
                child: const Text("Retry"),
              ),
            ],
          ),
        )
            : state.history.isEmpty
            ? const Center(
          child: Text(
            "No quiz results yet.",
            style: TextStyle(color: Colors.grey),
          ),
        )
            : RefreshIndicator(
          onRefresh: () => ref
              .read(resultViewModelProvider.notifier)
              .loadHistory(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary cards
              _buildSummaryCards(state.history),
              const SizedBox(height: 20),

              const Text(
                "Quiz History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // History list
              ...state.history.map((result) =>
                  _buildHistoryCard(context, ref, result)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(List<QuizHistoryEntity> history) {
    final avgAccuracy = history.isEmpty
        ? 0.0
        : history.map((r) => r.accuracy).reduce((a, b) => a + b) /
        history.length;
    final best = history.isEmpty
        ? 0.0
        : history.map((r) => r.accuracy).reduce((a, b) => a > b ? a : b);
    final subjects =
        history.map((r) => r.quiz.subject).toSet().length;

    return Row(
      children: [
        _summaryCard("Quizzes", "${history.length}"),
        const SizedBox(width: 8),
        _summaryCard("Avg Accuracy", "${avgAccuracy.toStringAsFixed(1)}%"),
        const SizedBox(width: 8),
        _summaryCard("Best", "${best.toStringAsFixed(1)}%"),
        const SizedBox(width: 8),
        _summaryCard("Subjects", "$subjects"),
      ],
    );
  }

  Widget _summaryCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D61E7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
      BuildContext context, WidgetRef ref, QuizHistoryEntity result) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultDetailScreen(
              quizId: result.quiz.id,
              subject: result.quiz.subject,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            // Accuracy circle
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accuracyColor(result.accuracy).withOpacity(0.1),
              ),
              child: Center(
                child: Text(
                  "${result.accuracy.toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _accuracyColor(result.accuracy),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.quiz.subject,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Class ${result.quiz.classLevel} · ${_formatDate(result.completedAt)}",
                    style:
                    const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _chip("${result.correctAnswers}/${result.totalQuestions}",
                          Colors.green),
                      const SizedBox(width: 6),
                      _chip(_formatTime(result.timeTaken), Colors.blue),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}