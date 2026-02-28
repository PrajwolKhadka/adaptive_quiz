import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents a PDF that has been saved permanently on the device.
class DownloadedPdf {
  final String id;        // unique key (url-based)
  final String title;
  final String localPath; // permanent file path
  final DateTime savedAt;

  DownloadedPdf({
    required this.id,
    required this.title,
    required this.localPath,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'localPath': localPath,
    'savedAt': savedAt.toIso8601String(),
  };

  factory DownloadedPdf.fromJson(Map<String, dynamic> json) => DownloadedPdf(
    id: json['id'],
    title: json['title'],
    localPath: json['localPath'],
    savedAt: DateTime.parse(json['savedAt']),
  );
}

class DownloadedPdfService {
  static const _key = 'downloaded_pdfs';

  // ── Get the permanent downloads directory ───────────────────────
  static Future<Directory> _downloadsDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/downloaded_pdfs');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  // ── Load all saved PDFs ─────────────────────────────────────────
  static Future<List<DownloadedPdf>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final List<DownloadedPdf> result = [];

    for (final item in raw) {
      try {
        final pdf = DownloadedPdf.fromJson(jsonDecode(item));
        // Only include if file still exists on disk
        if (await File(pdf.localPath).exists()) {
          result.add(pdf);
        }
      } catch (_) {}
    }

    // Sort newest first
    result.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return result;
  }

  // ── Check if a URL is already downloaded ───────────────────────
  static Future<bool> isDownloaded(String url) async {
    final all = await getAll();
    final id = _idFromUrl(url);
    return all.any((p) => p.id == id);
  }

  // ── Save a downloaded temp file permanently ─────────────────────
  /// Call this after Dio downloads to temp. Copies to permanent dir.
  static Future<DownloadedPdf> save({
    required String url,
    required String title,
    required String tempPath,
  }) async {
    final dir = await _downloadsDir();
    final id = _idFromUrl(url);
    final permanentPath = '${dir.path}/$id.pdf';

    // Copy from temp to permanent location
    await File(tempPath).copy(permanentPath);

    final pdf = DownloadedPdf(
      id: id,
      title: title,
      localPath: permanentPath,
      savedAt: DateTime.now(),
    );

    // Persist metadata
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    // Remove old entry for same id if exists
    existing.removeWhere((item) {
      try {
        return DownloadedPdf.fromJson(jsonDecode(item)).id == id;
      } catch (_) {
        return false;
      }
    });

    existing.add(jsonEncode(pdf.toJson()));
    await prefs.setStringList(_key, existing);

    return pdf;
  }

  // ── Delete a saved PDF ──────────────────────────────────────────
  static Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    DownloadedPdf? toDelete;
    try {
      final raw = existing.firstWhere((item) {
        try {
          return DownloadedPdf.fromJson(jsonDecode(item)).id == id;
        } catch (_) {
          return false;
        }
      });
      toDelete = DownloadedPdf.fromJson(jsonDecode(raw));
    } catch (_) {}

    if (toDelete != null) {
      // Delete file from disk
      final file = File(toDelete.localPath);
      if (await file.exists()) await file.delete();

      // Remove from prefs
      existing.removeWhere((item) {
        try {
          return DownloadedPdf.fromJson(jsonDecode(item)).id == id;
        } catch (_) {
          return false;
        }
      });
      await prefs.setStringList(_key, existing);
    }
  }

  // ── Stable ID from URL ──────────────────────────────────────────
  static String _idFromUrl(String url) {
    // Use last path segment without extension as base, sanitized
    final uri = Uri.tryParse(url);
    final segment = uri?.pathSegments.lastOrNull ?? url;
    final name = segment
        .replaceAll(RegExp(r'[^\w]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .toLowerCase();
    return name.isEmpty ? 'pdf_${url.hashCode.abs()}' : name;
  }
}