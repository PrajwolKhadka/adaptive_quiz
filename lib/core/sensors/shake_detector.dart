import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';

class ShakeDetector {
  final VoidCallback onShake;

  /// Shake threshold in m/s²
  final double threshold;

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
