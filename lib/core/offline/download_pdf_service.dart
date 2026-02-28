import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadedPdf {
  final String id;
  final String title;
  final String localPath;
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

  static Future<Directory> _downloadsDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/downloaded_pdfs');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  static Future<List<DownloadedPdf>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final List<DownloadedPdf> result = [];

    for (final item in raw) {
      try {
        final pdf = DownloadedPdf.fromJson(jsonDecode(item));
        if (await File(pdf.localPath).exists()) {
          result.add(pdf);
        }
      } catch (_) {}
    }

    // Sort newest first
    result.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return result;
  }

  static Future<bool> isDownloaded(String url) async {
    final all = await getAll();
    final id = _idFromUrl(url);
    return all.any((p) => p.id == id);
  }

  static Future<DownloadedPdf> save({
    required String url,
    required String title,
    required String tempPath,
  }) async {
    final dir = await _downloadsDir();
    final id = _idFromUrl(url);
    final permanentPath = '${dir.path}/$id.pdf';

    await File(tempPath).copy(permanentPath);

    final pdf = DownloadedPdf(
      id: id,
      title: title,
      localPath: permanentPath,
      savedAt: DateTime.now(),
    );

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

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
      final file = File(toDelete.localPath);
      if (await file.exists()) await file.delete();

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

  static String _idFromUrl(String url) {
    final uri = Uri.tryParse(url);
    final segment = uri?.pathSegments.lastOrNull ?? url;
    final name = segment
        .replaceAll(RegExp(r'[^\w]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .toLowerCase();
    return name.isEmpty ? 'pdf_${url.hashCode.abs()}' : name;
  }
}
