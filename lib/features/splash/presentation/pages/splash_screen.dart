import 'package:adaptive_quiz/features/dashboard/presentation/pages/main_screen.dart';
import 'package:adaptive_quiz/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../auth/presentation/pages/login_screen.dart';


// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   final UserSessionService sessionService = UserSessionService();
//
//   @override
//   void initState() {
//     super.initState();
//     _navigateToNext();
//   }
//
//   void _navigateToNext() async {
//     await Future.delayed(const Duration(seconds: 2));
//
//     final isLoggedIn = await sessionService.isLoggedIn();
//     if (isLoggedIn) {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => const MainScreen()));
//     } else {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSplashScreen(
//       splash: SizedBox.expand(
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xFFFFFFFF),
//                 Color(0xFFBEE1FA),
//               ],
//             ),
//           ),
//           child: Center(
//             child: Lottie.asset("assets/lottie/splash.json"),
//           ),
//         ),
//       ),
//       nextScreen: OnboardingScreen(),
//       splashIconSize: double.infinity,
//       backgroundColor: Colors.transparent,
//       duration: 2500,
//     );
//   }
// }

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

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isLoggedIn = await sessionService.isLoggedIn();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
        isLoggedIn ? const MainScreen() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
    );
  }
}

