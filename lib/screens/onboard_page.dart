import 'package:flutter/material.dart';

class OnboardPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const OnboardPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            flex: 4,
            child: Image.asset(image, height: 260)),

        const SizedBox(height: 40),

        Flexible(
          flex: 3,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          subtitle,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
