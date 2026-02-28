import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
/// Listens to the accelerometer and fires [onShake] when a shake
/// is detected. Call [dispose] when done.
class ShakeDetector {
  final VoidCallback onShake;

  /// Shake threshold in m/s² — tune this value if needed.
  /// Lower = more sensitive. 15 is a firm shake.
  final double threshold;

  /// Minimum ms between two shake events (debounce)
  final int debounceMs;

  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);

  ShakeDetector({
    required this.onShake,
    this.threshold = 6.0,
    this.debounceMs = 1500,
  });

  void start() {
    _subscription = accelerometerEventStream().listen((event) {
      final gForce = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      // Subtract gravity (9.8 m/s²) to get net acceleration
      final netAccel = (gForce - 9.8).abs();

      if (netAccel > threshold) {
        final now = DateTime.now();
        final diff = now.difference(_lastShake).inMilliseconds;
        if (diff > debounceMs) {
          _lastShake = now;
          onShake();
        }
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}