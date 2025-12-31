import 'package:adaptive_quiz/features/auth/presentation/pages/login_screen.dart';
import 'package:adaptive_quiz/screens/onboarding_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SizedBox.expand(
        child: Container(
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
      ),
      nextScreen: OnboardingScreen(),
      splashIconSize: double.infinity,
      backgroundColor: Colors.transparent,
      duration: 2500,
    );
  }
}
