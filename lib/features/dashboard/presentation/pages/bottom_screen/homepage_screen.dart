import 'package:adaptive_quiz/widget/my_gradient_button.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourceState = ref.watch(resourceViewModelProvider);

    // Filter only RESOURCE type (not BOOK)
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
                                  MyGradientButton(
                                    text: "Start Quiz",
                                    onPressed: () {},
                                    color: Colors.transparent,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF5DA0FF),
                                        Color(0xFF1D61E7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    fontSize: 26,
                                    paddingHorizontal: 40,
                                    paddingVertical: 20,
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
                                  const SizedBox(height: 30),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      width: 190,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF5DA0FF),
                                            Color(0xFF1D61E7)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: MyGradientButton(
                                        text: "Start Quiz",
                                        onPressed: () {},
                                        color: Colors.transparent,
                                      ),
                                    ),
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
                                // Icon based on format
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

                                // Title + description
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

                                // Format badge
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