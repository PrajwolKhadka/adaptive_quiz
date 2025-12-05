import 'package:adaptive_quiz/widget/my_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Map<String, String>> quizVideos = [
    {
      "title": "Math Tricks",
      "desc": "Learn amazing math shortcuts for faster calculation.",
      "link": "https://www.youtube.com/watch?v=example1"
    },
    {
      "title": "Science Basics",
      "desc": "Understand core science concepts easily.",
      "link": "https://www.youtube.com/watch?v=example2"
    },
    {
      "title": "History Tips",
      "desc": "Quick revision tips for history exams.",
      "link": "https://www.youtube.com/watch?v=example3"
    },
    {
      "title": "English Grammar",
      "desc": "Improve your grammar with easy exercises.",
      "link": "https://www.youtube.com/watch?v=example4"
    },
    {
      "title": "General Knowledge",
      "desc": "Boost your GK with daily updates.",
      "link": "https://www.youtube.com/watch?v=example5"
    },
  ];

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the link")),
      );
    }
  }


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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: const Color(0xFF223061),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 600;
                        return isWide
                            ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '"Trust yourself, you know more than\nyou think you do."',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Freeman',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  MyGradientButton(
                                    text: "Start Quiz",
                                    onPressed: () {},
                                    color: Colors.transparent,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF5DA0FF), Color(0xFF1D61E7)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    fontSize: 26,
                                    paddingHorizontal: 40,
                                    paddingVertical: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 300,
                              height: 280,
                              child: Image.asset(
                                'assets/image/graduate_child.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        )
                            : Column(
                          children: [
                            SizedBox(
                              height: 180,
                              child: Image.asset(
                                'assets/image/graduate_child.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '"Trust yourself, you know more than you think you do."',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Freeman',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            MyGradientButton(
                              text: "Start Quiz",
                              onPressed: () {},
                              color: Colors.transparent,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF5DA0FF), Color(0xFF1D61E7)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Quiz Preparation",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Column(
                  children: quizVideos.map((video) {
                    return GestureDetector(
                      onTap: () => _launchURL(video['link']!),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.play_arrow, size: 40),
                            ),
                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    video['desc']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
