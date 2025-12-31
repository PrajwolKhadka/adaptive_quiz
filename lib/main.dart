import 'package:adaptive_quiz/app/app.dart';
import 'package:adaptive_quiz/core/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open boxes
  final hiveService = HiveService();
  await hiveService.initHive();

  // Wrap the app with ProviderScope for Riverpod
  runApp(
    ProviderScope(
      overrides: [
        // You can override providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}
