// import 'package:adaptive_quiz/features/quiz/presentation/pages/quiz_screen.dart';
// import 'package:adaptive_quiz/features/quiz/presentation/providers/quiz_provider.dart';
// import 'package:adaptive_quiz/widget/my_gradient_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../domain/entities/resource_entity.dart';
// import '../../providers/resource_provider.dart';
//
// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});
//
//   void _launchURL(BuildContext context, String url) async {
//     final Uri uri = Uri.parse(url);
//     final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
//     if (!launched && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not open the link")),
//       );
//     }
//   }
//
//   Future<void> _startQuiz(BuildContext context, WidgetRef ref) async {
//     // Show loading spinner
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(
//         child: CircularProgressIndicator(color: Colors.white),
//       ),
//     );
//
//     await ref.read(quizViewModelProvider.notifier).checkActiveQuiz();
//
//     if (!context.mounted) return;
//     Navigator.pop(context); // close spinner
//
//     final state = ref.read(quizViewModelProvider);
//
//     if (state.activeQuiz?.available == true) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const QuizScreen()),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Row(
//             children: [
//               Icon(Icons.event_busy_rounded, color: Colors.orange),
//               SizedBox(width: 10),
//               Text("No Quiz Available"),
//             ],
//           ),
//           content: const Text(
//             "There is no active quiz scheduled for your class at this moment.\n\nPlease check back later.",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final resourceState = ref.watch(resourceViewModelProvider);
//
//     // Filter only RESOURCE type (not BOOK)
//     final resources = resourceState.resources
//         .where((r) => r.type == ResourceType.resource)
//         .toList();
//
//     return SizedBox.expand(
//       child: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFFFFFFF), Color(0xFFBEE1FA)],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── Hero Card ──────────────────────────────────
//                 Card(
//                   elevation: 6,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   color: const Color(0xFF223061),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         final isWide = constraints.maxWidth > 600;
//                         return isWide
//                             ? Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.center,
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                                 children: [
//                                   const Text(
//                                     '"Trust yourself, you know more than\nyou think you do."',
//                                     style: TextStyle(
//                                       fontSize: 32,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                       fontFamily: 'Freeman',
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   const SizedBox(height: 20),
//                                   MyGradientButton(
//                                     text: "Start Quiz",
//                                     onPressed: () =>
//                                         _startQuiz(context, ref),
//                                     color: Colors.transparent,
//                                     gradient: const LinearGradient(
//                                       colors: [
//                                         Color(0xFF5DA0FF),
//                                         Color(0xFF1D61E7)
//                                       ],
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                     ),
//                                     fontSize: 26,
//                                     paddingHorizontal: 40,
//                                     paddingVertical: 20,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             SizedBox(
//                               width: 300,
//                               height: 280,
//                               child: Image.asset(
//                                 'assets/image/graduate_child.png',
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ],
//                         )
//                             : Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Text(
//                                     '"Trust yourself, you know more than you think you do."',
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                       fontFamily: 'Freeman',
//                                     ),
//                                   ),
//                                   const SizedBox(height: 30),
//                                   Align(
//                                     alignment: Alignment.center,
//                                     child: Container(
//                                       padding: const EdgeInsets.all(2),
//                                       width: 190,
//                                       alignment: Alignment.center,
//                                       decoration: BoxDecoration(
//                                         gradient: const LinearGradient(
//                                           colors: [
//                                             Color(0xFF5DA0FF),
//                                             Color(0xFF1D61E7)
//                                           ],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         ),
//                                         borderRadius:
//                                         BorderRadius.circular(12),
//                                       ),
//                                       child: MyGradientButton(
//                                         text: "Start Quiz",
//                                         onPressed: () =>
//                                             _startQuiz(context, ref),
//                                         color: Colors.transparent,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               width: 150,
//                               height: 220,
//                               child: Image.asset(
//                                   'assets/image/graduate_child.png'),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 // ── Resources Section ──────────────────────────
//                 const Text(
//                   "Quiz Preparation",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 if (resourceState.isLoading)
//                   const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(32),
//                       child: CircularProgressIndicator(),
//                     ),
//                   )
//                 else if (resourceState.error != null)
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(32),
//                       child: Column(
//                         children: [
//                           Text(
//                             "Failed to load resources",
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                           const SizedBox(height: 12),
//                           TextButton(
//                             onPressed: () => ref
//                                 .read(resourceViewModelProvider.notifier)
//                                 .loadResources(),
//                             child: const Text("Retry"),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 else if (resources.isEmpty)
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(32),
//                         child: Text(
//                           "No resources available yet.",
//                           style: TextStyle(color: Colors.grey[500]),
//                         ),
//                       ),
//                     )
//                   else
//                     Column(
//                       children: resources.map((resource) {
//                         return GestureDetector(
//                           onTap: () {
//                             final url = resource.format == ResourceFormat.link
//                                 ? resource.linkUrl
//                                 : resource.fileUrl;
//                             if (url != null && url.isNotEmpty) {
//                               _launchURL(context, url);
//                             }
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.only(bottom: 12),
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 6,
//                                   offset: Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               children: [
//                                 // Icon based on format
//                                 Container(
//                                   width: 60,
//                                   height: 60,
//                                   decoration: BoxDecoration(
//                                     color: resource.format == ResourceFormat.pdf
//                                         ? Colors.red.shade50
//                                         : Colors.blue.shade50,
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Icon(
//                                     resource.format == ResourceFormat.pdf
//                                         ? Icons.picture_as_pdf_rounded
//                                         : Icons.link_rounded,
//                                     size: 32,
//                                     color: resource.format == ResourceFormat.pdf
//                                         ? Colors.red
//                                         : Colors.blue,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//
//                                 // Title + description
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         resource.title,
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       if (resource.description != null &&
//                                           resource.description!
//                                               .isNotEmpty) ...[
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           resource.description!,
//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.grey,
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ],
//                                   ),
//                                 ),
//
//                                 // Format badge
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: resource.format == ResourceFormat.pdf
//                                         ? Colors.red.shade50
//                                         : Colors.blue.shade50,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     resource.format == ResourceFormat.pdf
//                                         ? 'PDF'
//                                         : 'Link',
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.bold,
//                                       color:
//                                       resource.format == ResourceFormat.pdf
//                                           ? Colors.red
//                                           : Colors.blue,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:adaptive_quiz/features/quiz/presentation/pages/quiz_screen.dart';
import 'package:adaptive_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/resource_entity.dart';
import '../../providers/resource_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the link")),
      );
    }
  }

  Future<void> _startQuiz(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    await ref.read(quizViewModelProvider.notifier).checkActiveQuiz();

    if (!context.mounted) return;
    Navigator.pop(context);

    final state = ref.read(quizViewModelProvider);

    if (state.activeQuiz?.available == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuizScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.event_busy_rounded, color: Colors.orange),
              SizedBox(width: 10),
              Text("No Quiz Available"),
            ],
          ),
          content: const Text(
            "There is no active quiz scheduled for your class at this moment.\n\nPlease check back later.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourceState = ref.watch(resourceViewModelProvider);

    final resources = resourceState.resources
        .where((r) => r.type == ResourceType.resource)
        .toList();

    return SizedBox.expand(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFBEE1FA)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Card ──────────────────────────────────
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: const Color(0xFF223061),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 600;
                        return isWide
                            ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '"Trust yourself, you know more than\nyou think you do."',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Freeman',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  _StartQuizButton(
                                    onTap: () =>
                                        _startQuiz(context, ref),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 300,
                              height: 280,
                              child: Image.asset(
                                'assets/image/graduate_child.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        )
                            : Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '"Trust yourself, you know more than you think you do."',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Freeman',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _StartQuizButton(
                                    onTap: () =>
                                        _startQuiz(context, ref),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              height: 220,
                              child: Image.asset(
                                  'assets/image/graduate_child.png'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Resources Section ──────────────────────────
                const Text(
                  "Quiz Preparation",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                if (resourceState.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (resourceState.error != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Text(
                            "Failed to load resources",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => ref
                                .read(resourceViewModelProvider.notifier)
                                .loadResources(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (resources.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          "No resources available yet.",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: resources.map((resource) {
                        return GestureDetector(
                          onTap: () {
                            final url = resource.format == ResourceFormat.link
                                ? resource.linkUrl
                                : resource.fileUrl;
                            if (url != null && url.isNotEmpty) {
                              _launchURL(context, url);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
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
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: resource.format == ResourceFormat.pdf
                                        ? Colors.red.shade50
                                        : Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    resource.format == ResourceFormat.pdf
                                        ? Icons.picture_as_pdf_rounded
                                        : Icons.link_rounded,
                                    size: 32,
                                    color: resource.format == ResourceFormat.pdf
                                        ? Colors.red
                                        : Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resource.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (resource.description != null &&
                                          resource.description!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          resource.description!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: resource.format == ResourceFormat.pdf
                                        ? Colors.red.shade50
                                        : Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    resource.format == ResourceFormat.pdf
                                        ? 'PDF'
                                        : 'Link',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: resource.format == ResourceFormat.pdf
                                          ? Colors.red
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Polished Start Quiz Button ────────────────────────────────────────
class _StartQuizButton extends StatefulWidget {
  final VoidCallback onTap;
  const _StartQuizButton({required this.onTap});

  @override
  State<_StartQuizButton> createState() => _StartQuizButtonState();
}

class _StartQuizButtonState extends State<_StartQuizButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.06,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap();
  }
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5DA0FF), Color(0xFF1A4FD8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D61E7).withOpacity(0.55),
                blurRadius: 16,
                spreadRadius: -2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                "Start Quiz",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}