import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/homepage_screen.dart';
import 'package:adaptive_quiz/widget/my_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreen basic UI test', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Check the gradient container exists
    expect(find.byType(Container), findsWidgets);

    // Check "Start Quiz" button exists
    expect(find.byType(MyGradientButton), findsWidgets);
    expect(find.text('Start Quiz'), findsWidgets);

    // Check Quiz Preparation text exists
    expect(find.text('Quiz Preparation'), findsOneWidget);

    // Check video titles exist
    expect(find.text('Math Tricks'), findsOneWidget);
    expect(find.text('Science Basics'), findsOneWidget);
    expect(find.text('History Tips'), findsOneWidget);
    expect(find.text('English Grammar'), findsOneWidget);
    expect(find.text('Chemistry'), findsOneWidget);

    // Tap on a video container
    await tester.tap(find.text('Math Tricks'));
    await tester.pump();

    // We cannot actually launch URL in tests, but the tap doesn't crash
  });
}
