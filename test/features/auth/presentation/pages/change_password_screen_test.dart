import 'dart:async';
import 'package:adaptive_quiz/features/auth/presentation/pages/change_password_screen.dart';
import 'package:adaptive_quiz/features/auth/presentation/pages/login_screen.dart';
import 'package:adaptive_quiz/features/auth/presentation/state/auth_state.dart';
import 'package:adaptive_quiz/features/auth/presentation/view_model/auth_view_model.dart'
    hide authViewModelProvider;
import 'package:adaptive_quiz/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthViewModel extends Notifier<AuthState>
    with Mock
    implements AuthViewModel {
  @override
  AuthState build() => AuthState.initial();
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });
  late MockAuthViewModel mockViewModel;
  late MockNavigatorObserver mockObserver;

  setUp(() {
    mockViewModel = MockAuthViewModel();
    mockObserver = MockNavigatorObserver();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [authViewModelProvider.overrideWith(() => mockViewModel)],
      child: MaterialApp(
        home: const ChangePasswordScreen(),
        navigatorObservers: [mockObserver],
      ),
    );
  }

  group('ChangePasswordScreen Tests', () {
    testWidgets('Should show loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Use a Completer to control exactly when the future finishes
      final completer = Completer<void>();
      when(
        () => mockViewModel.changePassword(any()),
      ).thenAnswer((_) => completer.future);

      await tester.enterText(find.byType(TextFormField).at(0), 'Password123');
      await tester.enterText(find.byType(TextFormField).at(1), 'Password123');

      await tester.tap(find.text('Change Password'));

      // Pump twice: once for the tap, once for the first microtask (setState)
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Clean up: complete the future so the widget can finish its logic
      completer.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('Should call changePassword and trigger navigation', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Mock the logic to return success
      when(
        () => mockViewModel.changePassword(any()),
      ).thenAnswer((_) async => Future.value());

      await tester.enterText(find.byType(TextFormField).at(0), 'SecurePass123');
      await tester.enterText(find.byType(TextFormField).at(1), 'SecurePass123');

      await tester.tap(find.text('Change Password'));

      // We use pump() to process the microtasks.
      // If it crashes at UserSessionService, this is where it happens.
      await tester.pumpAndSettle();

      // 3. Verify the method was called
      verify(() => mockViewModel.changePassword('SecurePass123')).called(1);

      // 4. Verify navigation happened (Replacement uses didPush or didRemove)
      verify(() => mockObserver.didPush(any(), any())).called(greaterThan(0));
    });
  });
}
