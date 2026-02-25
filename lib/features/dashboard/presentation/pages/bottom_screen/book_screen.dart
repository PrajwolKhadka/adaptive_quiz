// import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/pdf_viewer_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../domain/entities/resource_entity.dart';
// import '../../providers/resource_provider.dart';
//
// class BookScreen extends ConsumerWidget {
//   const BookScreen({super.key});
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
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final resourceState = ref.watch(resourceViewModelProvider);
//
//     // Filter only BOOK type
//     final books = resourceState.resources
//         .where((r) => r.type == ResourceType.book)
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
//           child: resourceState.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : resourceState.error != null
//               ? Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Failed to load books",
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 12),
//                 TextButton(
//                   onPressed: () => ref
//                       .read(resourceViewModelProvider.notifier)
//                       .loadResources(),
//                   child: const Text("Retry"),
//                 ),
//               ],
//             ),
//           )
//               : books.isEmpty
//               ? Center(
//             child: Text(
//               "No books available yet.",
//               style: TextStyle(color: Colors.grey[500]),
//             ),
//           )
//               : ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               final book = books[index];
//               return GestureDetector(
//                 onTap: () {
//                     if (book.format == ResourceFormat.pdf && book.fileUrl != null) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => PdfViewerScreen(
//                             url: book.fileUrl!,
//                             title: book.title,
//                           ),
//                         ),
//                       );
//                     } else if (book.format == ResourceFormat.link && book.linkUrl != null) {
//                       _launchURL(context, book.linkUrl!);
//                     }
//                 },
//                 child: Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   margin: const EdgeInsets.only(bottom: 16),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       color: const Color(0xFF223061),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Row(
//                         children: [
//                           // Static book cover placeholder
//                           Container(
//                             height: 120,
//                             width: 90,
//                             decoration: BoxDecoration(
//                               borderRadius:
//                               BorderRadius.circular(8),
//                               color: Colors.white12,
//                             ),
//                             child: Column(
//                               mainAxisAlignment:
//                               MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   book.format ==
//                                       ResourceFormat.pdf
//                                       ? Icons
//                                       .picture_as_pdf_rounded
//                                       : Icons.menu_book_rounded,
//                                   size: 48,
//                                   color: book.format ==
//                                       ResourceFormat.pdf
//                                       ? Colors.red.shade300
//                                       : Colors.white70,
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   book.format ==
//                                       ResourceFormat.pdf
//                                       ? 'PDF'
//                                       : 'Link',
//                                   style: const TextStyle(
//                                     fontSize: 11,
//                                     color: Colors.white60,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           const SizedBox(width: 16),
//
//                           // Title + description
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   book.title,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 if (book.description != null &&
//                                     book.description!
//                                         .isNotEmpty) ...[
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     book.description!,
//                                     style: const TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.white60,
//                                     ),
//                                     maxLines: 3,
//                                     overflow:
//                                     TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                                 const SizedBox(height: 12),
//                                 // Tap hint
//                                 Row(
//                                   children: const [
//                                     Icon(
//                                       Icons.open_in_new,
//                                       size: 14,
//                                       color: Colors.white38,
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       "Tap to open",
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.white38,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/resource_entity.dart';
import '../../providers/resource_provider.dart';

class BookScreen extends ConsumerStatefulWidget {
  const BookScreen({super.key});

  @override
  ConsumerState<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends ConsumerState<BookScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    final launched =
    await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final resourceState = ref.watch(resourceViewModelProvider);

    // Filter books + search filter
    final books = resourceState.resources
        .where((r) => r.type == ResourceType.book)
        .where((r) =>
        r.title.toLowerCase().contains(_searchQuery.toLowerCase()))
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
          child: Column(
            children: [
              // ================= SEARCH BAR =================
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search books...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = "";
                        });
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // ================= CONTENT =================
              Expanded(
                child: resourceState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : resourceState.error != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        "Failed to load books",
                        style: TextStyle(
                            color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => ref
                            .read(resourceViewModelProvider
                            .notifier)
                            .loadResources(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
                    : books.isEmpty
                    ? Center(
                  child: Text(
                    _searchQuery.isEmpty
                        ? "No books available yet."
                        : "No results found.",
                    style: TextStyle(
                        color: Colors.grey[500]),
                  ),
                )
                    : ListView.builder(
                  padding:
                  const EdgeInsets.all(12),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];

                    return GestureDetector(
                      onTap: () {
                        if (book.format ==
                            ResourceFormat.pdf &&
                            book.fileUrl != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PdfViewerScreen(
                                    url: book.fileUrl!,
                                    title: book.title,
                                  ),
                            ),
                          );
                        } else if (book.format ==
                            ResourceFormat.link &&
                            book.linkUrl != null) {
                          _launchURL(
                              context, book.linkUrl!);
                        }
                      },
                      child: Card(
                        elevation: 3,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              16),
                        ),
                        margin:
                        const EdgeInsets.only(
                            bottom: 16),
                        child: Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(16),
                            color:
                            const Color(0xFF223061),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets
                                .all(12),
                            child: Row(
                              children: [
                                // Book Icon Box
                                Container(
                                  height: 120,
                                  width: 90,
                                  decoration:
                                  BoxDecoration(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        8),
                                    color: Colors
                                        .white12,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Icon(
                                        book.format ==
                                            ResourceFormat
                                                .pdf
                                            ? Icons
                                            .picture_as_pdf_rounded
                                            : Icons
                                            .menu_book_rounded,
                                        size: 48,
                                        color: book.format ==
                                            ResourceFormat
                                                .pdf
                                            ? Colors
                                            .red
                                            .shade300
                                            : Colors
                                            .white70,
                                      ),
                                      const SizedBox(
                                          height: 6),
                                      Text(
                                        book.format ==
                                            ResourceFormat
                                                .pdf
                                            ? "PDF"
                                            : "Link",
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          11,
                                          color: Colors
                                              .white60,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                    width: 16),

                                // Title + Description
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        book.title,
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          18,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          color: Colors
                                              .white,
                                        ),
                                      ),
                                      if (book
                                          .description !=
                                          null &&
                                          book.description!
                                              .isNotEmpty)
                                        Padding(
                                          padding:
                                          const EdgeInsets
                                              .only(
                                              top:
                                              8),
                                          child: Text(
                                            book
                                                .description!,
                                            maxLines:
                                            3,
                                            overflow:
                                            TextOverflow
                                                .ellipsis,
                                            style:
                                            const TextStyle(
                                              fontSize:
                                              13,
                                              color: Colors
                                                  .white60,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}