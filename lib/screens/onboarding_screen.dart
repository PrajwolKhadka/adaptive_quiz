import 'package:adaptive_quiz/screens/onboard_page.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_quiz/screens/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => isLastPage = index == 2);
                },
                children: const [
                  OnboardPage(
                    image: "assets/image/on1.png",
                    title: "Smarter Evaluation Starts Here",
                    subtitle: "AI-driven analysis to help you learn more about your abilities.",
                  ),
                  OnboardPage(
                    image: "assets/image/on2.png",
                    title: "Unified Learning Experience",
                    subtitle: "Access assessments, practice tools, and\ninsights—all in one hub.",
                  ),
                  OnboardPage(
                    image: "assets/image/on3.png",
                    title: "Let’s Get Started",
                    subtitle: "Unlock personalized assessments and tools designed just for you.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(150,0,0,0),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Colors.blue,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isLastPage) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(isLastPage ? "Get Started" : "Next"),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
