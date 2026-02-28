import 'package:adaptive_quiz/core/sensors/biometric_lock_wrapper.dart';
import 'package:adaptive_quiz/features/auth/presentation/pages/change_password_screen.dart';
import 'package:adaptive_quiz/features/auth/presentation/pages/forgotpassword_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adaptive_quiz/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:adaptive_quiz/features/auth/presentation/state/auth_state.dart';
import 'package:adaptive_quiz/core/services/storage/user_session_service.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/main_screen.dart';
import '../../../../common/my_snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;

  final UserSessionService sessionService = UserSessionService();

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    ref.read(authViewModelProvider.notifier).login(
      emailController.text.trim(),
      passwordController.text.trim(),
      (isFirstLogin, token) async {
        setState(() => isLoading = false);
        if (isFirstLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
          );
        } else {
          showMySnackBar(context: context, message: "Login Successful");
          Navigator.pushReplacement(
            context,
            // MaterialPageRoute(builder: (_) => const MainScreen()),
            MaterialPageRoute(
              builder: (_) => const BiometricLockWrapper(child: MainScreen()),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (prev, next) {
      if (next.error != null) {
        setState(() => isLoading = false);
        showMySnackBar(
          context: context,
          message: next.error!,
          color: Colors.red,
        );
      }
    });

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFBEE1FA)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // Logo
                  Image.asset(
                    'assets/image/logo.png',
                    height: 72,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 48),

                  // Headline
                  const Text(
                    "Sign in to your\naccount",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      height: 1.1,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Enter your school-provided credentials to continue.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _fieldLabel("Email address"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF111827),
                    ),
                    decoration: _inputDecoration("you@school.edu"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Email is required" : null,
                  ),

                  const SizedBox(height: 20),

                  _fieldLabel("Password"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF111827),
                    ),
                    decoration: _inputDecoration("••••••••").copyWith(
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF9CA3AF),
                          size: 20,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Password is required" : null,
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      ),
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D61E7),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login button
                  GestureDetector(
                    onTap: isLoading ? null : handleLogin,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: isLoading
                            ? const Color(0xFF6B7280)
                            : const Color(0xFF111827),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1D61E7), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
    );
  }
}
