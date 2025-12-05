import 'package:flutter/material.dart';

class MyGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final Color? color;
  final double? fontSize;
  final double? paddingVertical;
  final double? paddingHorizontal;

  const MyGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.color,
    this.fontSize,
    this.paddingVertical,
    this.paddingHorizontal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical ?? 12,
          horizontal: paddingHorizontal ?? 24,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? color ?? Colors.blue : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize ?? 16,
          ),
        ),
      ),
    );
  }
}
