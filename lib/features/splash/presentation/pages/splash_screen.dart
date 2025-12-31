import 'package:adaptive_quiz/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/user_session_service.dart';
import '../../../auth/presentation/pages/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserSessionService sessionService = UserSessionService();

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = await sessionService.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Adaptive Quiz",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
