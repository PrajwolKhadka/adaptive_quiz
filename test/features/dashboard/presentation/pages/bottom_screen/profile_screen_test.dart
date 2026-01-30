import 'dart:io';

import 'package:adaptive_quiz/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';
// import 'package:adaptive_quiz/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_viewmodel_provider.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/state/profile_state.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createWidget(ProfileState state) {
    return ProviderScope(
      overrides: [
        profileViewModelProvider.overrideWith(
          () => FakeProfileViewModel(state),
        ),
      ],
      child: const MaterialApp(home: ProfileScreen()),
    );
  }

  testWidgets('ProfileScreen shows user info correctly', (tester) async {
    final fakeState = ProfileState(
      isLoading: false,
      fullName: 'John Doe',
      email: 'john@example.com',
      className: 'BSc CSIT',
      imageUrl: null,
      localImagePath: null,
      error: null,
    );

    await tester.pumpWidget(createWidget(fakeState));

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
    expect(find.text('BSc CSIT'), findsOneWidget);

    expect(find.text('Upload Profile Picture'), findsNothing);

    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('Upload button appears when local image is selected', (
    tester,
  ) async {
    final fakeState = ProfileState(
      isLoading: false,
      fullName: 'Jane Doe',
      email: 'jane@example.com',
      className: 'Class 10',
      localImagePath: '/fake/path/image.png',
      imageUrl: null,
      error: null,
    );

    await tester.pumpWidget(createWidget(fakeState));

    expect(find.text('Upload Profile Picture'), findsOneWidget);
  });

  testWidgets('Loading indicator is shown when loading', (tester) async {
    final fakeState = ProfileState(isLoading: true);

    await tester.pumpWidget(createWidget(fakeState));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

class FakeProfileViewModel extends ProfileViewModel {
  final ProfileState fakeState;

  FakeProfileViewModel(this.fakeState);

  @override
  ProfileState build() {
    return fakeState;
  }

  @override
  Future<void> pickImage(_) async {}

  @override
  Future<void> uploadProfilePicture() async {}

  @override
  Future<void> logout(BuildContext context) async {}
}
