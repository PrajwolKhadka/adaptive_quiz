import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_quiz/core/services/storage/user_session_service.dart';

void main() {
  late UserSessionService sessionService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sessionService = UserSessionService();
  });

  test('should save and retrieve token correctly', () async {
    await sessionService.saveStudentSession(
      token: 'test_token',
      studentId: '123',
      fullName: 'Ram Shyam',
      email: 'ram@test.com',
      className: 'Grade 10',
    );

    final token = await sessionService.getToken();

    expect(token, 'test_token');
  });

  test('should save and retrieve remote profile image', () async {
    await sessionService.saveRemoteProfileImage('http://image.com/profile.png');

    final imageUrl = await sessionService.getRemoteProfileImage();

    expect(imageUrl, 'http://image.com/profile.png');
  });

  test('should return true when user is logged in', () async {
    await sessionService.saveStudentSession(
      token: 'valid_token',
      studentId: '1',
      fullName: 'Test User',
      email: 'test@email.com',
      className: 'Grade 9',
    );

    final isLoggedIn = await sessionService.isLoggedIn();

    expect(isLoggedIn, true);
  });

  test('should clear session correctly', () async {
    await sessionService.saveStudentSession(
      token: 'token',
      studentId: '1',
      fullName: 'Test',
      email: 'test@test.com',
      className: 'Grade 8',
    );

    await sessionService.clearSession();

    final token = await sessionService.getToken();

    expect(token, isNull);
  });
}
