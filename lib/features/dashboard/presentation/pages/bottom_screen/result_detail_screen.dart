import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/result_provider.dart';


class ResultDetailScreen extends ConsumerStatefulWidget {
  final String quizId;
  final String subject;

  const ResultDetailScreen({
    super.key,
    required this.quizId,
    required this.subject,
  });

  @override
  ConsumerState<ResultDetailScreen> createState() =>
      _ResultDetailScreenState();
}

class _ResultDetailScreenState extends ConsumerState<ResultDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(resultViewModelProvider.notifier)
        .loadResultDetail(widget.quizId));
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s}s';
  }

  Color _accuracyColor(double accuracy) {
    if (accuracy >= 80) return Colors.green;
    if (accuracy >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resultViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
        backgroundColor: const Color(0xFF1D61E7),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: state.isLoadingDetail
          ? const Center(child: CircularProgressIndicator())
          : state.detailError != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.detailError!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref
                  .read(resultViewModelProvider.notifier)
                  .loadResultDetail(widget.quizId),
              child: const Text("Retry"),
            ),
          ],
        ),
      )
          : state.detail == null
          ? const Center(child: Text("No result found."))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score cards
            Row(
              children: [
                _scoreCard(
                  "Score",
                  "${state.detail!.correctAnswers}/${state.detail!.totalQuestions}",
                  Colors.blue,
                ),
                const SizedBox(width: 8),
                _scoreCard(
                  "Accuracy",
                  "${state.detail!.accuracy.toStringAsFixed(1)}%",
                  _accuracyColor(state.detail!.accuracy),
                ),
                const SizedBox(width: 8),
                _scoreCard(
                  "Time",
                  _formatTime(state.detail!.timeTaken),
                  Colors.purple,
                ),
                const SizedBox(width: 8),
                _scoreCard(
                  "Wrong",
                  "${state.detail!.wrongAnswers}",
                  Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Performance bar
            _buildPerformanceBar(
              state.detail!.correctAnswers,
              state.detail!.wrongAnswers,
              state.detail!.totalQuestions,
            ),

            const SizedBox(height: 20),

            // AI Feedback
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "🤖 AI Feedback",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.detail!.aiFeedback,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // // Question breakdown
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(16),
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.black12,
            //         blurRadius: 6,
            //         offset: Offset(0, 3),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         "Question Breakdown",
            //         style: TextStyle(
            //           fontSize: 15,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       const SizedBox(height: 12),
            //       ...state.detail!.questionStats
            //           .asMap()
            //           .entries
            //           .map(
            //             (entry) => Padding(
            //           padding:
            //           const EdgeInsets.only(bottom: 8),
            //           child: Row(
            //             children: [
            //               // Number circle
            //               Container(
            //                 width: 30,
            //                 height: 30,
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   color: entry.value.correct
            //                       ? Colors.green
            //                       : Colors.red,
            //                 ),
            //                 child: Center(
            //                   child: Text(
            //                     "${entry.key + 1}",
            //                     style: const TextStyle(
            //                       color: Colors.white,
            //                       fontSize: 12,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(width: 12),
            //               Expanded(
            //                 child: Text(
            //                   entry.value.correct
            //                       ? "Correct"
            //                       : "Incorrect",
            //                   style: TextStyle(
            //                     fontSize: 14,
            //                     color: entry.value.correct
            //                         ? Colors.green
            //                         : Colors.red,
            //                   ),
            //                 ),
            //               ),
            //               Text(
            //                 "${entry.value.timeTaken}s",
            //                 style: const TextStyle(
            //                   fontSize: 12,
            //                   color: Colors.grey,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _scoreCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceBar(int correct, int wrong, int total) {
    final correctRatio = total == 0 ? 0.0 : correct / total;
    final wrongRatio = total == 0 ? 0.0 : wrong / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Performance Overview",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Flexible(
                  flex: (correctRatio * 100).round(),
                  child: Container(height: 14, color: Colors.green),
                ),
                Flexible(
                  flex: (wrongRatio * 100).round(),
                  child: Container(height: 14, color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _legend(Colors.green, "$correct Correct"),
              const SizedBox(width: 16),
              _legend(Colors.red, "$wrong Wrong"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}