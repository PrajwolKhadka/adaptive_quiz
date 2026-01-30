import 'package:adaptive_quiz/features/auth/presentation/pages/change_password_screen.dart';
import 'package:adaptive_quiz/features/auth/presentation/pages/login_screen.dart';
import 'package:adaptive_quiz/features/auth/presentation/state/auth_state.dart';
import 'package:adaptive_quiz/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for the Notifier
class MockAuthViewModel extends Notifier<AuthState>
    with Mock
    implements AuthViewModel {
  @override
  AuthState build() => AuthState.initial();
}

void main() {
  late MockAuthViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockAuthViewModel();
  });

  // Helper function to wrap the widget in necessary providers
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [authViewModelProvider.overrideWith(() => mockViewModel)],
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('Should display all UI elements correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Sign in to your\nAccount'), findsOneWidget);
      expect(
        find.byType(TextFormField),
        findsNWidgets(2),
      ); // Email and Password
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets(
      'Should show validation errors when clicking login with empty fields',
      (tester) async {
        await tester.pumpWidget(createTestWidget());

        await tester.tap(find.text('Login'));
        await tester.pump(); // Start validation frame

        expect(find.text('Email required'), findsOneWidget);
        expect(find.text('Password required'), findsOneWidget);
      },
    );

    testWidgets('Should call login on ViewModel when form is valid', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Mock the login method to do nothing (it's a void function)
      when(
        () => mockViewModel.login(any(), any(), any()),
      ).thenAnswer((_) async {});

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@student.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      await tester.tap(find.text('Login'));
      await tester.pump();

      verify(
        () => mockViewModel.login('test@student.com', 'password123', any()),
      ).called(1);
    });

    testWidgets('Should show SnackBar when state has an error', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Simulate a state change to error
      mockViewModel.state = const AuthState(
        isLoading: false,
        error: 'Invalid Credentials',
      );

      // Pump to trigger ref.listen
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid Credentials'), findsOneWidget);
    });
  });
}
