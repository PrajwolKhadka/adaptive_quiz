import 'package:adaptive_quiz/common/navigation_bar.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/book_screen.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/homepage_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const BookScreen(),
    // ResultScreenPage(),
    Center(child: Text("Results Page", style: TextStyle(fontSize: 28))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/image/logo.png',
          width: 120,
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: const[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: "Books"),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: "Result"),
          ],
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF88A4E0),
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index){
            setState(() {
              _selectedIndex = index;
            });
        },
      )
    );
  }
}
