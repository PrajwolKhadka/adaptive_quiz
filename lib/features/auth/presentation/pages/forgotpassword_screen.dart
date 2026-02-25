import 'package:adaptive_quiz/core/providers/common_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoint.dart';
import '../../../../common/my_snackbar.dart';
import 'login_screen.dart';
import 'package:dio/dio.dart';

// ─────────────────────────────────────────────────────────────────
// Forgot Password Screen  (2 steps in one screen)
// Step 1: enter email → POST /auth/student-forgot-password
// Step 2: enter OTP + new password → PUT /auth/student-reset-password
// ─────────────────────────────────────────────────────────────────
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  // Step 1
  final _emailKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  // Step 2
  final _resetKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _otpSent = false; // false = step 1, true = step 2

  @override
  void dispose() {
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Step 1: send OTP ───────────────────────────────────────────
  Future<void> _sendOtp() async {
    if (!_emailKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': _emailCtrl.text.trim()},
      );
      setState(() => _otpSent = true);
      if (mounted) {
        showMySnackBar(
          context: context,
          message: "OTP sent to your email",
        );
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? "Failed to send OTP";
      if (mounted) {
        showMySnackBar(context: context, message: msg, color: Colors.red);
      }
    } catch (e) {
      if (mounted) {
        showMySnackBar(
            context: context,
            message: "Something went wrong",
            color: Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_resetKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.put(
        ApiEndpoints.resetPassword,
        data: {
          'email': _emailCtrl.text.trim(),
          'otp': _otpCtrl.text.trim(),
          'newPassword': _newPasswordCtrl.text,
        },
      );
      if (mounted) {
        showMySnackBar(
          context: context,
          message: "Password reset successfully. Please login.",
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false,
        );
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data?['message'] ?? "Invalid or expired OTP";
      if (mounted) {
        showMySnackBar(context: context, message: msg, color: Colors.red);
      }
    } catch (e) {
      if (mounted) {
        showMySnackBar(
            context: context,
            message: "Something went wrong",
            color: Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Color(0xFF111827)),
                  ),

                  const SizedBox(height: 40),

                  _StepIndicator(step: _otpSent ? 2 : 1),

                  const SizedBox(height: 32),

                  Text(
                    _otpSent ? "Reset\npassword" : "Forgot\npassword?",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _otpSent
                        ? "Enter the OTP sent to ${_emailCtrl.text.trim()} and your new password."
                        : "Enter your registered email. We'll send a 6-digit OTP to reset your password.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 36),

                  if (!_otpSent) ...[
                    Form(
                      key: _emailKey,
                      child: Column(
                        children: [
                          _Field(
                            controller: _emailCtrl,
                            label: "Email address",
                            hint: "you@school.edu",
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Email is required";
                              }
                              if (!v.contains('@')) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),
                          _PrimaryButton(
                            label: "Send OTP",
                            isLoading: _isLoading,
                            onTap: _sendOtp,
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (_otpSent) ...[
                    Form(
                      key: _resetKey,
                      child: Column(
                        children: [
                          _Field(
                            controller: _otpCtrl,
                            label: "6-digit OTP",
                            hint: "123456",
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "OTP is required";
                              }
                              if (v.length < 6) return "Enter 6-digit OTP";
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          _Field(
                            controller: _newPasswordCtrl,
                            label: "New password",
                            hint: "Min. 8 characters",
                            obscureText: _obscureNew,
                            suffixIcon: GestureDetector(
                              onTap: () =>
                                  setState(() => _obscureNew = !_obscureNew),
                              child: Icon(
                                _obscureNew
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF9CA3AF),
                                size: 20,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Password is required";
                              }
                              if (v.length < 8) {
                                return "Minimum 8 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          _Field(
                            controller: _confirmCtrl,
                            label: "Confirm password",
                            hint: "Re-enter password",
                            obscureText: _obscureConfirm,
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm),
                              child: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF9CA3AF),
                                size: 20,
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (v != _newPasswordCtrl.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 28),

                          _PrimaryButton(
                            label: "Reset Password",
                            isLoading: _isLoading,
                            onTap: _resetPassword,
                          ),

                          const SizedBox(height: 16),

                          Center(
                            child: GestureDetector(
                              onTap: _isLoading ? null : _sendOtp,
                              child: const Text(
                                "Didn't receive OTP? Resend",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF1D61E7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int step;
  const _StepIndicator({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dot(active: step >= 1, label: "Email"),
        _line(active: step >= 2),
        _dot(active: step >= 2, label: "Reset"),
      ],
    );
  }

  Widget _dot({required bool active, required String label}) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(0xFF1D61E7)
                : const Color(0xFFE5E7EB),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: active
                ? const Color(0xFF1D61E7)
                : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _line({required bool active}) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 14, left: 6, right: 6),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF1D61E7)
              : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int? maxLength;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          validator: validator,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF111827),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFD1D5DB),
              fontSize: 15,
            ),
            counterText: "",
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Color(0xFF1D61E7), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color:
          isLoading ? const Color(0xFF6B7280) : const Color(0xFF111827),
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
              : Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}