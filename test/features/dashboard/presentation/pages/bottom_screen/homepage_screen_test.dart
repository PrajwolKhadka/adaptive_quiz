import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/homepage_screen.dart';
import 'package:adaptive_quiz/widget/my_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreen basic UI test', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));


    expect(find.byType(Container), findsWidgets);

    expect(find.byType(MyGradientButton), findsWidgets);
    expect(find.text('Start Quiz'), findsWidgets);

    expect(find.text('Quiz Preparation'), findsOneWidget);

    expect(find.text('Math Tricks'), findsOneWidget);
    expect(find.text('Science Basics'), findsOneWidget);
    expect(find.text('History Tips'), findsOneWidget);
    expect(find.text('English Grammar'), findsOneWidget);
    expect(find.text('Chemistry'), findsOneWidget);

    await tester.tap(find.text('Math Tricks'));
    await tester.pump();

  });
}
