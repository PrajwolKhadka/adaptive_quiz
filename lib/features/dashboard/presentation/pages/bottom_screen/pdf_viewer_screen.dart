// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
//
// class PdfViewerScreen extends StatefulWidget {
//   final String url;
//   final String title;
//
//   const PdfViewerScreen({super.key, required this.url, required this.title});
//
//   @override
//   State<PdfViewerScreen> createState() => _PdfViewerScreenState();
// }
//
// class _PdfViewerScreenState extends State<PdfViewerScreen> {
//   String? localPath;
//   bool isLoading = true;
//   String? error;
//   int totalPages = 0;
//   int currentPage = 0;
//
//   String _fixUrl(String url) {
//     String fixed = url.replaceAll('localhost', '10.0.2.2');
//     try {
//       final uri = Uri.parse(fixed);
//       final encodedPath = uri.pathSegments
//           .map((s) => Uri.encodeComponent(s))
//           .join('/');
//       return '${uri.scheme}://${uri.host}:${uri.port}/$encodedPath';
//     } catch (_) {
//       return fixed;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _downloadAndLoad();
//   }
//
//   Future<void> _downloadAndLoad() async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });
//
//     try {
//       final fixedUrl = _fixUrl(widget.url);
//       debugPrint("Downloading PDF: $fixedUrl");
//
//       final dir = await getTemporaryDirectory();
//       // Use timestamp as filename to avoid special character issues
//       final safeFilename = '${DateTime.now().millisecondsSinceEpoch}.pdf';
//       final filePath = '${dir.path}/$safeFilename';
//
//       await Dio().download(fixedUrl, filePath);
//
//       if (!mounted) return;
//       setState(() {
//         localPath = filePath;
//         isLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         error = "Failed to load PDF.\nCheck your connection and try again.";
//         isLoading = false;
//       });
//       debugPrint("PDF download error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title, overflow: TextOverflow.ellipsis),
//         backgroundColor: const Color(0xFF1D61E7),
//         foregroundColor: Colors.white,
//         centerTitle: true,
//         actions: [
//           if (!isLoading && error == null)
//             Padding(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Text(
//                 "${currentPage + 1} / $totalPages",
//                 style: const TextStyle(color: Colors.white, fontSize: 14),
//               ),
//             ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(color: Color(0xFF1D61E7)),
//             SizedBox(height: 16),
//             Text(
//               "Loading PDF...",
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       )
//           : error != null
//           ? Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline,
//                   color: Colors.red, size: 56),
//               const SizedBox(height: 16),
//               Text(
//                 error!,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.red),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: _downloadAndLoad,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text("Retry"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1D61E7),
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )
//           : PDFView(
//         filePath: localPath!,
//         enableSwipe: true,
//         swipeHorizontal: false,
//         autoSpacing: true,
//         pageFling: true,
//         backgroundColor: const Color(0xFFEEEEEE),
//         onRender: (pages) {
//           setState(() => totalPages = pages ?? 0);
//         },
//         onPageChanged: (page, total) {
//           setState(() {
//             currentPage = page ?? 0;
//             totalPages = total ?? 0;
//           });
//         },
//         onError: (e) {
//           setState(() => error = "Failed to render PDF.");
//           debugPrint("PDFView error: $e");
//         },
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool isLoading = true;
  String? error;
  int totalPages = 0;
  int currentPage = 0;

  // 🔥 IMPORTANT: Change this to your PC IP
  static const String physicalDeviceBase =
      "http://192.168.1.70:5000"; // <-- CHANGE THIS

  String _buildCorrectUrl(String originalUrl) {
    try {
      final uri = Uri.parse(originalUrl);

      // If emulator
      if (Platform.isAndroid && _isEmulator()) {
        return originalUrl.replaceAll("localhost", "10.0.2.2");
      }

      // If physical device
      if (Platform.isAndroid && !_isEmulator()) {
        final encodedPath =
        uri.pathSegments.map((e) => Uri.encodeComponent(e)).join('/');

        return "$physicalDeviceBase/$encodedPath";
      }

      return originalUrl;
    } catch (e) {
      return originalUrl;
    }
  }

  bool _isEmulator() {
    return !Platform.environment.containsKey('ANDROID_ROOT');
  }

  @override
  void initState() {
    super.initState();
    _downloadAndLoad();
  }

  Future<void> _downloadAndLoad() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final fixedUrl = _buildCorrectUrl(widget.url);
      debugPrint("Downloading PDF: $fixedUrl");

      final dir = await getTemporaryDirectory();
      final filePath =
          "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf";

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      await dio.download(fixedUrl, filePath);

      if (!mounted) return;

      setState(() {
        localPath = filePath;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      debugPrint("PDF download error: $e");

      setState(() {
        error =
        "Failed to load PDF.\n\nMake sure:\n• Backend is running\n• Same WiFi\n• Correct PC IP\n• Firewall allows port 5000";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, overflow: TextOverflow.ellipsis),
        backgroundColor: const Color(0xFF1D61E7),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          if (!isLoading && error == null)
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "${currentPage + 1} / $totalPages",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF1D61E7)),
            SizedBox(height: 16),
            Text(
              "Loading PDF...",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : error != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Colors.red, size: 56),
              const SizedBox(height: 16),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _downloadAndLoad,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D61E7),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      )
          : PDFView(
        filePath: localPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        backgroundColor: const Color(0xFFEEEEEE),
        onRender: (pages) {
          setState(() => totalPages = pages ?? 0);
        },
        onPageChanged: (page, total) {
          setState(() {
            currentPage = page ?? 0;
            totalPages = total ?? 0;
          });
        },
        onError: (e) {
          debugPrint("PDFView error: $e");
          setState(() => error = "Failed to render PDF.");
        },
      ),
    );
  }
}