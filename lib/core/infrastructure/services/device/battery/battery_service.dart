// lib/core/infrastructure/services/device/battery/battery_service.dart

/// Battery state information
class BatteryState {
  final int level;
  final bool isCharging;
  final bool isPowerSaveMode;
  
  BatteryState({
    required this.level,
    required this.isCharging,
    required this.isPowerSaveMode,
  });
  
  Map<String, dynamic> toJson() => {
    'level': level,
    'isCharging': isCharging,
    'isPowerSaveMode': isPowerSaveMode,
  };
}

/// Battery service interface
abstract class BatteryService {
  /// Get current battery level (0-100)
  Future<int> getBatteryLevel();
  
  /// Check if device is charging
  Future<bool> isCharging();
  
  /// Check if power save mode is enabled
  Future<bool> isPowerSaveMode();
  
  /// Check if notifications can be sent based on battery state
  Future<bool> canSendNotification();
  
  /// Set minimum battery level for notifications
  Future<void> setMinimumBatteryLevel(int level);
  
  /// Get minimum battery level for notifications
  int getMinimumBatteryLevel();
  
  /// Get battery state stream
  Stream<BatteryState> getBatteryStateStream();
  
  /// Get current battery state
  Future<BatteryState> getCurrentBatteryState();
  
  /// Check if battery optimization is enabled
  Future<bool> isBatteryOptimizationEnabled();
  
  /// Dispose resources
  Future<void> dispose();
}
