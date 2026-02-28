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
    if (mounted)
      setState(() {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        ),
      );
    }
  }

  void _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open the link")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final resourceState = ref.watch(resourceViewModelProvider);
    final books = resourceState.resources
        .where((r) => r.type == ResourceType.book)
        .where(
          (r) => r.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
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
                                horizontal: 6,
                                vertical: 2,
                              ),
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
                      onSearchChanged: (v) => setState(() => _searchQuery = v),
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
