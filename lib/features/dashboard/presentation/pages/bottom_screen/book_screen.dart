// // import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/pdf_viewer_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:url_launcher/url_launcher.dart';
// //
// // import '../../../domain/entities/resource_entity.dart';
// // import '../../providers/resource_provider.dart';
// //
// // class BookScreen extends ConsumerStatefulWidget {
// //   const BookScreen({super.key});
// //
// //   @override
// //   ConsumerState<BookScreen> createState() => _BookScreenState();
// // }
// //
// // class _BookScreenState extends ConsumerState<BookScreen> {
// //   final TextEditingController _searchController = TextEditingController();
// //   String _searchQuery = "";
// //
// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _launchURL(BuildContext context, String url) async {
// //     final Uri uri = Uri.parse(url);
// //     final launched =
// //     await launchUrl(uri, mode: LaunchMode.externalApplication);
// //
// //     if (!launched && context.mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Could not open the link")),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final resourceState = ref.watch(resourceViewModelProvider);
// //
// //     // Filter books + search filter
// //     final books = resourceState.resources
// //         .where((r) => r.type == ResourceType.book)
// //         .where((r) =>
// //         r.title.toLowerCase().contains(_searchQuery.toLowerCase()))
// //         .toList();
// //
// //     return SizedBox.expand(
// //       child: Container(
// //         width: double.infinity,
// //         height: double.infinity,
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [Color(0xFFFFFFFF), Color(0xFFBEE1FA)],
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: Column(
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
// //                 child: TextField(
// //                   controller: _searchController,
// //                   onChanged: (value) {
// //                     setState(() {
// //                       _searchQuery = value;
// //                     });
// //                   },
// //                   decoration: InputDecoration(
// //                     hintText: "Search books...",
// //                     prefixIcon: const Icon(Icons.search),
// //                     suffixIcon: _searchQuery.isNotEmpty
// //                         ? IconButton(
// //                       icon: const Icon(Icons.clear),
// //                       onPressed: () {
// //                         _searchController.clear();
// //                         setState(() {
// //                           _searchQuery = "";
// //                         });
// //                       },
// //                     )
// //                         : null,
// //                     filled: true,
// //                     fillColor: Colors.white,
// //                     contentPadding:
// //                     const EdgeInsets.symmetric(vertical: 0),
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(14),
// //                       borderSide: BorderSide.none,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //
// //               Expanded(
// //                 child: resourceState.isLoading
// //                     ? const Center(child: CircularProgressIndicator())
// //                     : resourceState.error != null
// //                     ? Center(
// //                   child: Column(
// //                     mainAxisAlignment:
// //                     MainAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         "Failed to load books",
// //                         style: TextStyle(
// //                             color: Colors.grey[600]),
// //                       ),
// //                       const SizedBox(height: 12),
// //                       TextButton(
// //                         onPressed: () => ref
// //                             .read(resourceViewModelProvider
// //                             .notifier)
// //                             .loadResources(),
// //                         child: const Text("Retry"),
// //                       ),
// //                     ],
// //                   ),
// //                 )
// //                     : books.isEmpty
// //                     ? Center(
// //                   child: Text(
// //                     _searchQuery.isEmpty
// //                         ? "No books available yet."
// //                         : "No results found.",
// //                     style: TextStyle(
// //                         color: Colors.grey[500]),
// //                   ),
// //                 )
// //                     : ListView.builder(
// //                   padding:
// //                   const EdgeInsets.all(12),
// //                   itemCount: books.length,
// //                   itemBuilder: (context, index) {
// //                     final book = books[index];
// //
// //                     return GestureDetector(
// //                       onTap: () {
// //                         if (book.format ==
// //                             ResourceFormat.pdf &&
// //                             book.fileUrl != null) {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) =>
// //                                   PdfViewerScreen(
// //                                     url: book.fileUrl!,
// //                                     title: book.title,
// //                                   ),
// //                             ),
// //                           );
// //                         } else if (book.format ==
// //                             ResourceFormat.link &&
// //                             book.linkUrl != null) {
// //                           _launchURL(
// //                               context, book.linkUrl!);
// //                         }
// //                       },
// //                       child: Card(
// //                         elevation: 3,
// //                         shape:
// //                         RoundedRectangleBorder(
// //                           borderRadius:
// //                           BorderRadius.circular(
// //                               16),
// //                         ),
// //                         margin:
// //                         const EdgeInsets.only(
// //                             bottom: 16),
// //                         child: Container(
// //                           decoration:
// //                           BoxDecoration(
// //                             borderRadius:
// //                             BorderRadius
// //                                 .circular(16),
// //                             color:
// //                             const Color(0xFF223061),
// //                           ),
// //                           child: Padding(
// //                             padding:
// //                             const EdgeInsets
// //                                 .all(12),
// //                             child: Row(
// //                               children: [
// //                                 // Book Icon Box
// //                                 Container(
// //                                   height: 120,
// //                                   width: 90,
// //                                   decoration:
// //                                   BoxDecoration(
// //                                     borderRadius:
// //                                     BorderRadius
// //                                         .circular(
// //                                         8),
// //                                     color: Colors
// //                                         .white12,
// //                                   ),
// //                                   child: Column(
// //                                     mainAxisAlignment:
// //                                     MainAxisAlignment
// //                                         .center,
// //                                     children: [
// //                                       Icon(
// //                                         book.format ==
// //                                             ResourceFormat
// //                                                 .pdf
// //                                             ? Icons
// //                                             .picture_as_pdf_rounded
// //                                             : Icons
// //                                             .menu_book_rounded,
// //                                         size: 48,
// //                                         color: book.format ==
// //                                             ResourceFormat
// //                                                 .pdf
// //                                             ? Colors
// //                                             .red
// //                                             .shade300
// //                                             : Colors
// //                                             .white70,
// //                                       ),
// //                                       const SizedBox(
// //                                           height: 6),
// //                                       Text(
// //                                         book.format ==
// //                                             ResourceFormat
// //                                                 .pdf
// //                                             ? "PDF"
// //                                             : "Link",
// //                                         style:
// //                                         const TextStyle(
// //                                           fontSize:
// //                                           11,
// //                                           color: Colors
// //                                               .white60,
// //                                           fontWeight:
// //                                           FontWeight
// //                                               .bold,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //
// //                                 const SizedBox(
// //                                     width: 16),
// //
// //                                 // Title + Description
// //                                 Expanded(
// //                                   child: Column(
// //                                     crossAxisAlignment:
// //                                     CrossAxisAlignment
// //                                         .start,
// //                                     children: [
// //                                       Text(
// //                                         book.title,
// //                                         style:
// //                                         const TextStyle(
// //                                           fontSize:
// //                                           18,
// //                                           fontWeight:
// //                                           FontWeight
// //                                               .bold,
// //                                           color: Colors
// //                                               .white,
// //                                         ),
// //                                       ),
// //                                       if (book
// //                                           .description !=
// //                                           null &&
// //                                           book.description!
// //                                               .isNotEmpty)
// //                                         Padding(
// //                                           padding:
// //                                           const EdgeInsets
// //                                               .only(
// //                                               top:
// //                                               8),
// //                                           child: Text(
// //                                             book
// //                                                 .description!,
// //                                             maxLines:
// //                                             3,
// //                                             overflow:
// //                                             TextOverflow
// //                                                 .ellipsis,
// //                                             style:
// //                                             const TextStyle(
// //                                               fontSize:
// //                                               13,
// //                                               color: Colors
// //                                                   .white60,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:adaptive_quiz/core/offline/download_pdf_service.dart';
// import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/pdf_viewer_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../domain/entities/resource_entity.dart';
// import '../../providers/resource_provider.dart';
//
// class BookScreen extends ConsumerStatefulWidget {
//   const BookScreen({super.key});
//
//   @override
//   ConsumerState<BookScreen> createState() => _BookScreenState();
// }
//
// class _BookScreenState extends ConsumerState<BookScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//
//   // Offline downloads
//   List<DownloadedPdf> _downloads = [];
//   bool _downloadsLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       if (_tabController.index == 1) _loadDownloads();
//     });
//     _loadDownloads();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadDownloads() async {
//     setState(() => _downloadsLoading = true);
//     final list = await DownloadedPdfService.getAll();
//     if (mounted) setState(() {
//       _downloads = list;
//       _downloadsLoading = false;
//     });
//   }
//
//   Future<void> _deleteDownload(String id) async {
//     await DownloadedPdfService.delete(id);
//     await _loadDownloads();
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text("Removed from downloads"),
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: const Color(0xFF111827),
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//         ),
//       );
//     }
//   }
//
//   void _launchURL(BuildContext context, String url) async {
//     final Uri uri = Uri.parse(url);
//     final launched =
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//     if (!launched && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not open the link")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final resourceState = ref.watch(resourceViewModelProvider);
//     final books = resourceState.resources
//         .where((r) => r.type == ResourceType.book)
//         .where((r) =>
//         r.title.toLowerCase().contains(_searchQuery.toLowerCase()))
//         .toList();
//
//     return SizedBox.expand(
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFFFFFFF), Color(0xFFBEE1FA)],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // ── Tab bar ──────────────────────────────────────
//               Container(
//                 color: Colors.white,
//                 child: TabBar(
//                   controller: _tabController,
//                   labelColor: const Color(0xFF1D61E7),
//                   unselectedLabelColor: const Color(0xFF9CA3AF),
//                   indicatorColor: const Color(0xFF1D61E7),
//                   indicatorWeight: 2.5,
//                   labelStyle: const TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 14,
//                   ),
//                   tabs: [
//                     const Tab(text: "Books"),
//                     Tab(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Text("Downloads"),
//                           if (_downloads.isNotEmpty) ...[
//                             const SizedBox(width: 6),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF1D61E7),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Text(
//                                 '${_downloads.length}',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     // ── Tab 1: Books (online) ─────────────────
//                     _BooksTab(
//                       books: books,
//                       resourceState: resourceState,
//                       searchController: _searchController,
//                       searchQuery: _searchQuery,
//                       onSearchChanged: (v) =>
//                           setState(() => _searchQuery = v),
//                       onLaunchUrl: _launchURL,
//                       onRefresh: () => ref
//                           .read(resourceViewModelProvider.notifier)
//                           .loadResources(),
//                     ),
//
//                     // ── Tab 2: Downloads (offline) ────────────
//                     _DownloadsTab(
//                       downloads: _downloads,
//                       isLoading: _downloadsLoading,
//                       onDelete: _deleteDownload,
//                       onRefresh: _loadDownloads,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Books Tab ─────────────────────────────────────────────────────
// class _BooksTab extends StatelessWidget {
//   final List<dynamic> books;
//   final dynamic resourceState;
//   final TextEditingController searchController;
//   final String searchQuery;
//   final ValueChanged<String> onSearchChanged;
//   final void Function(BuildContext, String) onLaunchUrl;
//   final VoidCallback onRefresh;
//
//   const _BooksTab({
//     required this.books,
//     required this.resourceState,
//     required this.searchController,
//     required this.searchQuery,
//     required this.onSearchChanged,
//     required this.onLaunchUrl,
//     required this.onRefresh,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Search bar
//         Padding(
//           padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
//           child: TextField(
//             controller: searchController,
//             onChanged: onSearchChanged,
//             decoration: InputDecoration(
//               hintText: "Search books...",
//               prefixIcon: const Icon(Icons.search),
//               suffixIcon: searchQuery.isNotEmpty
//                   ? IconButton(
//                 icon: const Icon(Icons.clear),
//                 onPressed: () => onSearchChanged(''),
//               )
//                   : null,
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: const EdgeInsets.symmetric(vertical: 0),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ),
//
//         Expanded(
//           child: resourceState.isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : resourceState.error != null
//               ? Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Failed to load books",
//                     style:
//                     TextStyle(color: Colors.grey[600])),
//                 const SizedBox(height: 12),
//                 TextButton(
//                   onPressed: onRefresh,
//                   child: const Text("Retry"),
//                 ),
//               ],
//             ),
//           )
//               : books.isEmpty
//               ? Center(
//             child: Text(
//               searchQuery.isEmpty
//                   ? "No books available yet."
//                   : "No results found.",
//               style: TextStyle(color: Colors.grey[500]),
//             ),
//           )
//               : ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               final book = books[index];
//               return _BookCard(
//                 book: book,
//                 onLaunchUrl: onLaunchUrl,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _BookCard extends StatelessWidget {
//   final dynamic book;
//   final void Function(BuildContext, String) onLaunchUrl;
//
//   const _BookCard({required this.book, required this.onLaunchUrl});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (book.format == ResourceFormat.pdf && book.fileUrl != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => PdfViewerScreen(
//                 url: book.fileUrl!,
//                 title: book.title,
//               ),
//             ),
//           );
//         } else if (book.format == ResourceFormat.link &&
//             book.linkUrl != null) {
//           onLaunchUrl(context, book.linkUrl!);
//         }
//       },
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16)),
//         margin: const EdgeInsets.only(bottom: 16),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             color: const Color(0xFF223061),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 // Icon box
//                 Container(
//                   height: 100,
//                   width: 80,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.white12,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         book.format == ResourceFormat.pdf
//                             ? Icons.picture_as_pdf_rounded
//                             : Icons.menu_book_rounded,
//                         size: 40,
//                         color: book.format == ResourceFormat.pdf
//                             ? Colors.red.shade300
//                             : Colors.white70,
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         book.format == ResourceFormat.pdf
//                             ? "PDF"
//                             : "Link",
//                         style: const TextStyle(
//                           fontSize: 11,
//                           color: Colors.white60,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         book.title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       if (book.description != null &&
//                           book.description!.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 6),
//                           child: Text(
//                             book.description!,
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.white60,
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: const [
//                           Icon(Icons.download_rounded,
//                               size: 13, color: Colors.white38),
//                           SizedBox(width: 4),
//                           Text(
//                             "Tap to open",
//                             style: TextStyle(
//                                 fontSize: 11, color: Colors.white38),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Downloads Tab ─────────────────────────────────────────────────
// class _DownloadsTab extends StatelessWidget {
//   final List<DownloadedPdf> downloads;
//   final bool isLoading;
//   final Future<void> Function(String id) onDelete;
//   final VoidCallback onRefresh;
//
//   const _DownloadsTab({
//     required this.downloads,
//     required this.isLoading,
//     required this.onDelete,
//     required this.onRefresh,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (downloads.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.download_for_offline_outlined,
//                   size: 64, color: Colors.grey[300]),
//               const SizedBox(height: 20),
//               Text(
//                 "No downloads yet",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "Open any PDF book and tap ↓ in the top-right corner to save it for offline reading.",
//                 textAlign: TextAlign.center,
//                 style:
//                 TextStyle(fontSize: 13, color: Colors.black),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return RefreshIndicator(
//       onRefresh: () async => onRefresh(),
//       child: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: downloads.length,
//         itemBuilder: (context, index) {
//           final pdf = downloads[index];
//           return _DownloadedPdfCard(
//             pdf: pdf,
//             onDelete: () => onDelete(pdf.id),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _DownloadedPdfCard extends StatelessWidget {
//   final DownloadedPdf pdf;
//   final VoidCallback onDelete;
//
//   const _DownloadedPdfCard(
//       {required this.pdf, required this.onDelete});
//
//   String _formatDate(DateTime dt) {
//     final now = DateTime.now();
//     final diff = now.difference(dt);
//     if (diff.inDays == 0) return "Today";
//     if (diff.inDays == 1) return "Yesterday";
//     return "${dt.day}/${dt.month}/${dt.year}";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => PdfViewerScreen(
//               url: pdf.localPath,
//               title: pdf.title,
//               isOffline: true, // ← opens from local file, no network
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: const [
//             BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 6,
//                 offset: Offset(0, 3)),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Icon
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: Colors.red.shade50,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(Icons.picture_as_pdf_rounded,
//                   color: Colors.red.shade400, size: 26),
//             ),
//
//             const SizedBox(width: 14),
//
//             // Info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     pdf.title,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF111827),
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.wifi_off_rounded,
//                           size: 12, color: Color(0xFF16A34A)),
//                       const SizedBox(width: 4),
//                       Text(
//                         "Available offline · ${_formatDate(pdf.savedAt)}",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             // Delete button
//             GestureDetector(
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (_) => AlertDialog(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16)),
//                     title: const Text("Remove download?"),
//                     content: Text(
//                         "\"${pdf.title}\" will be removed from your device."),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text("Cancel"),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           onDelete();
//                         },
//                         child: const Text(
//                           "Remove",
//                           style:
//                           TextStyle(color: Color(0xFFEF4444)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(6),
//                 child: Icon(Icons.delete_outline_rounded,
//                     color: Colors.grey[400], size: 22),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:adaptive_quiz/core/offline/download_pdf_service.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/resource_entity.dart';
import '../../providers/resource_provider.dart';
import './book_widgets.dart';

class BookScreen extends ConsumerStatefulWidget {
  const BookScreen({super.key});

  @override
  ConsumerState<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends ConsumerState<BookScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Offline downloads
  List<DownloadedPdf> _downloads = [];
  bool _downloadsLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1) _loadDownloads();
    });
    _loadDownloads();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDownloads() async {
    setState(() => _downloadsLoading = true);
    final list = await DownloadedPdfService.getAll();
    if (mounted) setState(() {
      _downloads = list;
      _downloadsLoading = false;
    });
  }

  Future<void> _deleteDownload(String id) async {
    await DownloadedPdfService.delete(id);
    await _loadDownloads();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Removed from downloads"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF111827),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        ),
      );
    }
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
    final books = resourceState.resources
        .where((r) => r.type == ResourceType.book)
        .where((r) =>
        r.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return SizedBox.expand(
      child: Container(
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
              // ── Tab bar ──────────────────────────────────────
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF1D61E7),
                  unselectedLabelColor: const Color(0xFF9CA3AF),
                  indicatorColor: const Color(0xFF1D61E7),
                  indicatorWeight: 2.5,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  tabs: [
                    const Tab(text: "Books"),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Downloads"),
                          if (_downloads.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D61E7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_downloads.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ── Tab 1: Books (online) ─────────────────
                    BooksTab(
                      books: books,
                      resourceState: resourceState,
                      searchController: _searchController,
                      searchQuery: _searchQuery,
                      onSearchChanged: (v) =>
                          setState(() => _searchQuery = v),
                      onLaunchUrl: _launchURL,
                      onRefresh: () => ref
                          .read(resourceViewModelProvider.notifier)
                          .loadResources(),
                    ),

                    // ── Tab 2: Downloads (offline) ────────────
                    DownloadsTab(
                      downloads: _downloads,
                      isLoading: _downloadsLoading,
                      onDelete: _deleteDownload,
                      onRefresh: _loadDownloads,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}