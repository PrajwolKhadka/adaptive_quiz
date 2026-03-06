import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports biometrics
  static Future<bool> isAvailable() async {

    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      print("CAN CHECK: $canCheck");
      print("DEVICE SUPPORTED: $isSupported");
      return canCheck && isSupported;
    } on PlatformException {
      return false;
    }
  }

  /// Returns true if authenticated successfully
  // static Future<bool> authenticate() async {
  //   try {
  //     print("AUTHENTICATE CALLED");
  //     return await _auth.authenticate(
  //       localizedReason: 'Confirm your identity to continue',
  //       options: const AuthenticationOptions(
  //         biometricOnly: false, // allow PIN fallback
  //         stickyAuth: true,
  //       ),
  //     );
  //   } on PlatformException {
  //     return false;
  //   }
  // }

  static Future<bool> authenticate() async {
    try {
      final result = await _auth.authenticate(
        localizedReason: 'Confirm your identity to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );


      return result;
    } catch (e) {
      return false;
    }
  }
}