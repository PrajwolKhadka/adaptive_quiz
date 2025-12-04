import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFBEE1FA),
            ],
          ),
        ),
        child: Center(
          child: Lottie.asset("assets/lottie/splash.json"),
        ),
      ),
      nextScreen: Scaffold(
        body: Center(
          child: Text(
            "Next Screen Placeholder",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      duration: 3000,
    );
  }
}
