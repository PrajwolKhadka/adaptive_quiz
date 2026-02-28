import 'package:flutter/material.dart';
import 'package:adaptive_quiz/core/offline/download_pdf_service.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/pdf_viewer_screen.dart';
import '../../../domain/entities/resource_entity.dart';

// ── Books Tab ─────────────────────────────────────────────────────
class BooksTab extends StatelessWidget {
  final List<dynamic> books;
  final dynamic resourceState;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final void Function(BuildContext, String) onLaunchUrl;
  final VoidCallback onRefresh;

  const BooksTab({
    required this.books,
    required this.resourceState,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onLaunchUrl,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: "Search books...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => onSearchChanged(''),
              )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: resourceState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : resourceState.error != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Failed to load books",
                    style:
                    TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onRefresh,
                  child: const Text("Retry"),
                ),
              ],
            ),
          )
              : books.isEmpty
              ? Center(
            child: Text(
              searchQuery.isEmpty
                  ? "No books available yet."
                  : "No results found.",
              style: TextStyle(color: Colors.grey[500]),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                book: book,
                onLaunchUrl: onLaunchUrl,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Single Book Card ─────────────────────────────────────────────
class BookCard extends StatelessWidget {
  final dynamic book;
  final void Function(BuildContext, String) onLaunchUrl;

  const BookCard({required this.book, required this.onLaunchUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (book.format == ResourceFormat.pdf && book.fileUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfViewerScreen(
                url: book.fileUrl!,
                title: book.title,
              ),
            ),
          );
        } else if (book.format == ResourceFormat.link &&
            book.linkUrl != null) {
          onLaunchUrl(context, book.linkUrl!);
        }
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF223061),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        book.format == ResourceFormat.pdf
                            ? Icons.picture_as_pdf_rounded
                            : Icons.menu_book_rounded,
                        size: 40,
                        color: book.format == ResourceFormat.pdf
                            ? Colors.red.shade300
                            : Colors.white70,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        book.format == ResourceFormat.pdf
                            ? "PDF"
                            : "Link",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (book.description != null &&
                          book.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            book.description!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.download_rounded,
                              size: 13, color: Colors.white38),
                          SizedBox(width: 4),
                          Text(
                            "Tap to open",
                            style: TextStyle(
                                fontSize: 11, color: Colors.white38),
                          ),
                        ],
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
  }
}

// ── Downloads Tab ───────────────────────────────────────────────
class DownloadsTab extends StatelessWidget {
  final List<DownloadedPdf> downloads;
  final bool isLoading;
  final Future<void> Function(String id) onDelete;
  final VoidCallback onRefresh;

  const DownloadsTab({
    required this.downloads,
    required this.isLoading,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (downloads.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.download_for_offline_outlined,
                  size: 64, color: Colors.grey[300]),
              const SizedBox(height: 20),
              Text(
                "No downloads yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Open any PDF book and tap ↓ in the top-right corner to save it for offline reading.",
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: 13, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: downloads.length,
        itemBuilder: (context, index) {
          final pdf = downloads[index];
          return DownloadedPdfCard(pdf: pdf, onDelete: () => onDelete(pdf.id));
        },
      ),
    );
  }
}

class DownloadedPdfCard extends StatelessWidget {
  final DownloadedPdf pdf;
  final VoidCallback onDelete;

  const DownloadedPdfCard({required this.pdf, required this.onDelete});

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return "Today";
    if (diff.inDays == 1) return "Yesterday";
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PdfViewerScreen(
              url: pdf.localPath,
              title: pdf.title,
              isOffline: true,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.picture_as_pdf_rounded,
                  color: Colors.red.shade400, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pdf.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          size: 12, color: Color(0xFF16A34A)),
                      const SizedBox(width: 4),
                      Text(
                        "Available offline · ${_formatDate(pdf.savedAt)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text("Remove download?"),
                    content: Text("\"${pdf.title}\" will be removed from your device."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                        child: const Text(
                          "Remove",
                          style: TextStyle(color: Color(0xFFEF4444)),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.delete_outline_rounded,
                    color: Colors.grey[400], size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}