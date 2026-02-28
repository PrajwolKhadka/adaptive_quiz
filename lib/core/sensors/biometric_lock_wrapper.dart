import 'package:flutter/material.dart';
import 'biometric_service.dart';
import 'app_lock_service.dart';

class BiometricLockWrapper extends StatefulWidget {
  final Widget child;
  const BiometricLockWrapper({super.key, required this.child});

  @override
  State<BiometricLockWrapper> createState() => _BiometricLockWrapperState();
}

class _BiometricLockWrapperState extends State<BiometricLockWrapper>
    with WidgetsBindingObserver {
  bool _locked = false;
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // On startup: user le applock rakheko xa vane auxa
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final enabled = await AppLockService.isEnabled();
      if (enabled) {
        setState(() => _locked = true);
        _unlock();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // Always arm when going to background
      final enabled = await AppLockService.isEnabled();
      if (enabled) setState(() => _locked = true);
    } else if (state == AppLifecycleState.resumed && _locked) {
      _unlock();
    }
  }

  Future<void> _unlock() async {
    if (_authenticating) return;
    setState(() => _authenticating = true);

    final available = await BiometricService.isAvailable();
    if (!available) {
      if (mounted) {
        setState(() {
          _locked = false;
          _authenticating = false;
        });
      }
      return;
    }

    final authenticated = await BiometricService.authenticate();
    if (mounted) {
      setState(() {
        _locked = !authenticated;
        _authenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_locked)
          Positioned.fill(
            child: _LockScreen(
              isAuthenticating: _authenticating,
              onUnlock: _unlock,
            ),
          ),
      ],
    );
  }
}

// ── Lock overlay ──────────────────────────────────────────────────
class _LockScreen extends StatelessWidget {
  final bool isAuthenticating;
  final VoidCallback onUnlock;

  const _LockScreen({required this.isAuthenticating, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1D61E7).withOpacity(0.08),
                  ),
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    size: 44,
                    color: Color(0xFF1D61E7),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "App Locked",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Authenticate to continue using the app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                if (isAuthenticating)
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFF1D61E7),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: onUnlock,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fingerprint_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Unlock",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
