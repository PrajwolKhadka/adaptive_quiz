// lib/widget/my_gradient_button.dart

import 'package:flutter/material.dart';

class MyGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Gradient? gradient;
  final double fontSize;
  final double paddingHorizontal;
  final double paddingVertical;
  final bool showLoadingIndicator;

  const MyGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.white,
    this.gradient,
    this.fontSize = 16,
    this.paddingHorizontal = 20,
    this.paddingVertical = 12,
    this.showLoadingIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !showLoadingIndicator;

    return Container(
      decoration: BoxDecoration(
        gradient: gradient ??
            (isEnabled
                ? const LinearGradient(
              colors: [Color(0xFF5DA0FF), Color(0xFF1D61E7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : LinearGradient(
              colors: [Colors.grey.shade400, Colors.grey.shade500],
            )),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: paddingVertical,
            ),
            child: showLoadingIndicator
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Text(
              text,
              style: TextStyle(
                color: isEnabled ? Colors.white : Colors.grey.shade300,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}