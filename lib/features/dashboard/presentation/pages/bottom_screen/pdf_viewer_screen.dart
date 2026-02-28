// import 'dart:io';
// import 'package:adaptive_quiz/core/api/api_endpoint.dart';
// import 'package:adaptive_quiz/core/sensors/shake_detector.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
//
// class PdfViewerScreen extends StatefulWidget {
//   final String url;
//   final String title;
//
//   const PdfViewerScreen({
//     super.key,
//     required this.url,
//     required this.title,
//   });
//
//   @override
//   State<PdfViewerScreen> createState() => _PdfViewerScreenState();
// }
//
// class _PdfViewerScreenState extends State<PdfViewerScreen> {
//   String? _localPath;
//   bool _isLoading = true;
//   String? _error;
//   int _currentPage = 0;
//   int _totalPages = 0;
//   PDFViewController? _pdfController;
//   bool _isClosing = false;
//
//   late final ShakeDetector _shakeDetector;
//
//   @override
//   void initState() {
//     super.initState();
//     _downloadPdf();
//
//     // Sensor 2: shake → close PDF
//     _shakeDetector = ShakeDetector(
//       onShake: _onShake,
//       threshold: 6.0,
//       debounceMs: 1500,
//     );
//     _shakeDetector.start();
//   }
//
//   @override
//   void dispose() {
//     _shakeDetector.dispose();
//     super.dispose();
//   }
//
//   void _onShake() {
//     if (!mounted || _isClosing) return;
//     _isClosing = true;
//     _showToast("Closing PDF...", const Color(0xFF111827));
//     Future.delayed(const Duration(milliseconds: 400), () {
//       if (mounted) Navigator.of(context).pop();
//     });
//   }
//
//   String _buildUrl(String rawUrl) {
//
//     final serverBase = ApiEndpoints.serverUrl; // "http://192.168.1.70:5000" or "http://10.0.2.2:5000"
//
//     if (rawUrl.startsWith('/')) {
//       final base = serverBase.endsWith('/')
//           ? serverBase.substring(0, serverBase.length - 1)
//           : serverBase;
//       return '$base$rawUrl';
//     }
//
//     try {
//       final incoming = Uri.parse(rawUrl);
//       final server = Uri.parse(serverBase);
//       final fixed = incoming.replace(
//         scheme: server.scheme,
//         host: server.host,
//         port: server.port,
//       );
//       return fixed.toString();
//     } catch (_) {
//       return rawUrl;
//     }
//   }
//
//   Future<void> _downloadPdf() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _error = null;
//       });
//
//       final finalUrl = _buildUrl(widget.url);
//       debugPrint("📄 PDF URL: $finalUrl");
//
//       final dir = await getTemporaryDirectory();
//       final filePath =
//           '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf';
//
//       await Dio(
//         BaseOptions(
//           connectTimeout: const Duration(seconds: 15),
//           receiveTimeout: const Duration(seconds: 30),
//         ),
//       ).download(finalUrl, filePath);
//
//       if (!mounted) return;
//       setState(() {
//         _localPath = filePath;
//         _isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("PDF Error: $e");
//       if (!mounted) return;
//       setState(() {
//         _error = "Failed to load PDF.\n\nMake sure you're on the same network as the server.";
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _showToast(String message, Color color) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.vibration, color: Colors.white, size: 15),
//             const SizedBox(width: 7),
//             Text(message, style: const TextStyle(fontSize: 13)),
//           ],
//         ),
//         duration: const Duration(milliseconds: 900),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: color,
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Padding(
//             padding: EdgeInsets.all(12),
//             child: Icon(Icons.arrow_back, color: Color(0xFF111827)),
//           ),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.title,
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF111827),
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             if (_totalPages > 0)
//               Text(
//                 "${_currentPage + 1} / $_totalPages",
//                 style: const TextStyle(
//                   fontSize: 11,
//                   color: Color(0xFF9CA3AF),
//                 ),
//               ),
//           ],
//         ),
//       ),
//       body: _buildBody(),
//     );
//   }
//
//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 28,
//               height: 28,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2.5,
//                 color: Color(0xFF1D61E7),
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               "Loading PDF...",
//               style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
//             ),
//           ],
//         ),
//       );
//     }
//
//     if (_error != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline,
//                   color: Color(0xFFEF4444), size: 48),
//               const SizedBox(height: 16),
//               const Text(
//                 "Failed to load PDF",
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 _error!,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                     fontSize: 13, color: Color(0xFF6B7280)),
//               ),
//               const SizedBox(height: 24),
//               GestureDetector(
//                 onTap: _downloadPdf,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 24, vertical: 13),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF111827),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Text(
//                     "Retry",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return PDFView(
//       filePath: _localPath!,
//       enableSwipe: true,
//       swipeHorizontal: false,
//       autoSpacing: true,
//       pageSnap: true,
//       onRender: (pages) {
//         if (mounted) setState(() => _totalPages = pages ?? 0);
//       },
//       onPageChanged: (page, total) {
//         if (mounted) {
//           setState(() {
//             _currentPage = page ?? 0;
//             _totalPages = total ?? 0;
//           });
//         }
//       },
//       onViewCreated: (controller) => _pdfController = controller,
//       onError: (e) {
//         if (mounted) setState(() => _error = e.toString());
//       },
//     );
//   }
// }

import 'dart:io';
import 'package:adaptive_quiz/core/api/api_endpoint.dart';
import 'package:adaptive_quiz/core/offline/download_pdf_service.dart';
import 'package:adaptive_quiz/core/sensors/shake_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  /// Pass true when opening an already-downloaded local file
  /// (in that case [url] is the local file path, not a network URL)
  final bool isOffline;

  const PdfViewerScreen({
    super.key,
    required this.url,
    required this.title,
    this.isOffline = false,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localPath;
  bool _isLoading = true;
  String? _error;
  int _currentPage = 0;
  int _totalPages = 0;
  PDFViewController? _pdfController;
  bool _isClosing = false;

  // Download/save state
  bool _isSaving = false;
  bool _alreadySaved = false;

  late final ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();

    if (widget.isOffline) {
      // Already a local path — open directly
      _localPath = widget.url;
      _isLoading = false;
      _alreadySaved = true;
    } else {
      _downloadPdf();
      _checkIfAlreadySaved();
    }

    // Sensor 2: shake → close PDF
    _shakeDetector = ShakeDetector(
      onShake: _onShake,
      threshold: 6.0,
      debounceMs: 1500,
    );
    _shakeDetector.start();
  }

  @override
  void dispose() {
    _shakeDetector.dispose();
    super.dispose();
  }

  Future<void> _checkIfAlreadySaved() async {
    final saved = await DownloadedPdfService.isDownloaded(widget.url);
    if (mounted) setState(() => _alreadySaved = saved);
  }

  // ── Shake: close PDF ─────────────────────────────────────────
  void _onShake() {
    if (!mounted || _isClosing) return;
    _isClosing = true;
    _showToast("Closing PDF...", const Color(0xFF111827));
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  // ── Build correct URL ─────────────────────────────────────────
  String _buildUrl(String rawUrl) {
    final serverBase = ApiEndpoints.serverUrl;
    if (rawUrl.startsWith('/')) {
      final base = serverBase.endsWith('/')
          ? serverBase.substring(0, serverBase.length - 1)
          : serverBase;
      return '$base$rawUrl';
    }
    try {
      final incoming = Uri.parse(rawUrl);
      final server = Uri.parse(serverBase);
      return incoming
          .replace(scheme: server.scheme, host: server.host, port: server.port)
          .toString();
    } catch (_) {
      return rawUrl;
    }
  }

  // ── Download PDF to temp ──────────────────────────────────────
  Future<void> _downloadPdf() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final finalUrl = _buildUrl(widget.url);
      debugPrint("📄 PDF URL: $finalUrl");

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf';

      await Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
        ),
      ).download(finalUrl, filePath);

      if (!mounted) return;
      setState(() {
        _localPath = filePath;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("PDF Error: $e");
      if (!mounted) return;
      setState(() {
        _error =
        "Failed to load PDF.\n\nMake sure you're on the same network as the server.";
        _isLoading = false;
      });
    }
  }

  // ── Save for offline ──────────────────────────────────────────
  Future<void> _saveForOffline() async {
    if (_localPath == null || _isSaving || _alreadySaved) return;
    setState(() => _isSaving = true);

    try {
      await DownloadedPdfService.save(
        url: widget.url,
        title: widget.title,
        tempPath: _localPath!,
      );
      if (mounted) {
        setState(() {
          _alreadySaved = true;
          _isSaving = false;
        });
        _showToast("Saved for offline reading", const Color(0xFF16A34A));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showToast("Failed to save", const Color(0xFFEF4444));
      }
    }
  }

  void _showToast(String message, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 13)),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.arrow_back, color: Color(0xFF111827)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (_totalPages > 0)
              Text(
                "${_currentPage + 1} / $_totalPages",
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
          ],
        ),
        actions: [
          // Download button — only shown for online PDFs that loaded
          if (!widget.isOffline && !_isLoading && _error == null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _isSaving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF1D61E7),
                ),
              )
                  : GestureDetector(
                onTap: _alreadySaved ? null : _saveForOffline,
                child: Icon(
                  _alreadySaved
                      ? Icons.download_done_rounded
                      : Icons.download_rounded,
                  color: _alreadySaved
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF1D61E7),
                  size: 24,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF1D61E7),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Loading PDF...",
              style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Color(0xFFEF4444), size: 48),
              const SizedBox(height: 16),
              const Text(
                "Failed to load PDF",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _downloadPdf,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 13),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PDFView(
      filePath: _localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageSnap: true,
      onRender: (pages) {
        if (mounted) setState(() => _totalPages = pages ?? 0);
      },
      onPageChanged: (page, total) {
        if (mounted) {
          setState(() {
            _currentPage = page ?? 0;
            _totalPages = total ?? 0;
          });
        }
      },
      onViewCreated: (controller) => _pdfController = controller,
      onError: (e) {
        if (mounted) setState(() => _error = e.toString());
      },
    );
  }
}