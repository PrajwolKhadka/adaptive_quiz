import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/splash/presentation/pages/splash_screen.dart';
import '../core/services/storage/user_session_service.dart';
import '../core/sensors/biometric_lock_wrapper.dart';
import '../features/dashboard/presentation/pages/main_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';

class SplashRouter extends ConsumerStatefulWidget {
  const SplashRouter({super.key});

  @override
  ConsumerState<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends ConsumerState<SplashRouter> {
  bool _loaded = false;
  Widget? _nextScreen;

  @override
  void initState() {
    super.initState();
    _handleRouting();
  }

  Future<void> _handleRouting() async {
    await Future.delayed(const Duration(seconds: 2));
    // wait for splash animation

    final session = UserSessionService();
    final token = session.getToken();

    if (token == null) {
      _nextScreen = const LoginScreen();
    } else {
      _nextScreen = const BiometricLockWrapper(child: MainScreen());
    }

    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const SplashScreen();
    }

    return _nextScreen ?? const LoginScreen();
  }
}
