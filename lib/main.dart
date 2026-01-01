import 'package:adaptive_quiz/app/app.dart';
import 'package:adaptive_quiz/core/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.init();

  runApp(
    ProviderScope(
      overrides: [
      ],
      child: const MyApp(),
    ),
  );
}
