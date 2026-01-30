import 'dart:io';

import 'package:adaptive_quiz/common/navigation_bar.dart';
import 'package:adaptive_quiz/core/api/api_endpoint.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/book_screen.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/homepage_screen.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_viewmodel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const BookScreen(),
    // ResultScreenPage(),
    Center(child: Text("Results Page", style: TextStyle(fontSize: 28))),
  ];

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    ImageProvider profileImage;

    if (profileState.localImagePath != null) {
      profileImage = FileImage(File(profileState.localImagePath!));
    } else if (profileState.imageUrl != null) {
      profileImage = NetworkImage(
        profileState.imageUrl!.startsWith("http")
            ? profileState.imageUrl!
            : "${ApiEndpoints.baseUrl.replaceAll('/api/', '')}${profileState.imageUrl}",
      );
    } else {
      profileImage = const AssetImage("assets/image/logo.png");
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/image/logo.png',
          width: 120,
        ),
        actions: [
          IconButton(onPressed:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
              icon: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: profileImage,
              ))
        ],
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
