import 'package:adaptive_quiz/features/dashboard/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MainScreen basic UI test', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: MainScreen())),
    );

    expect(find.byType(Image), findsWidgets);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text("Results Page"), findsNothing);

    await tester.tap(find.text("Books"));
    await tester.pumpAndSettle();
    expect(find.text("Results Page"), findsNothing);

    await tester.tap(find.text("Result"));
    await tester.pumpAndSettle();
    expect(find.text("Results Page"), findsOneWidget);

    await tester.tap(find.text("Home"));
    await tester.pumpAndSettle();
    expect(find.text("Results Page"), findsNothing);
  });

  testWidgets('ProfileScreen navigation on avatar tap', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: MainScreen())),
    );

    await tester.tap(find.byType(CircleAvatar));
    await tester.pump();

    expect(find.byType(MainScreen), findsOneWidget);
  });
}
