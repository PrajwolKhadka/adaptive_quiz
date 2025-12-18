import 'package:adaptive_quiz/theme/theme_data.dart';
import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maanak Quiz App',
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashScreen(),
    );
  }
}
