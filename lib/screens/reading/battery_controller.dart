import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:battery_plus/battery_plus.dart';

/// Manages battery level listening and subscription.
class BatteryController {
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _subscription;

  int batteryLevel = 100;
  VoidCallback? onBatteryChanged;

  /// Starts listening to battery changes.
  void init() {
    _getInitialBattery();
    _subscription = _battery.onBatteryStateChanged.listen((state) async {
      await _updateBatteryLevel();
    });
  }

  /// Cancels the battery status subscription.
  void dispose() {
    _subscription?.cancel();
  }

  Future<void> _getInitialBattery() async {
    try {
      batteryLevel = await _battery.batteryLevel;
      onBatteryChanged?.call();
    } catch (e) {
      debugPrint('Error getting initial battery level: $e');
    }
  }

  Future<void> _updateBatteryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      if (batteryLevel != level) {
        batteryLevel = level;
        onBatteryChanged?.call();
      }
    } catch (e) {
      debugPrint('Error updating battery level: $e');
    }
  }
}
