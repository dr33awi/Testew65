// lib/features/settings/models/app_settings.dart (محدث بدون اللغة وحجم الخط)
/// نموذج إعدادات التطبيق
class AppSettings {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool locationEnabled;
  final bool batteryOptimizationDisabled;

  const AppSettings({
    this.isDarkMode = false,
    this.notificationsEnabled = false,
    this.soundEnabled = false,
    this.vibrationEnabled = true,
    this.locationEnabled = false,
    this.batteryOptimizationDisabled = false,
  });

  /// إنشاء نسخة جديدة مع تغيير بعض القيم
  AppSettings copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? locationEnabled,
    bool? batteryOptimizationDisabled,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      batteryOptimizationDisabled: batteryOptimizationDisabled ?? this.batteryOptimizationDisabled,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'locationEnabled': locationEnabled,
      'batteryOptimizationDisabled': batteryOptimizationDisabled,
    };
  }

  /// إنشاء من JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? false,
      soundEnabled: json['soundEnabled'] ?? false,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      locationEnabled: json['locationEnabled'] ?? false,
      batteryOptimizationDisabled: json['batteryOptimizationDisabled'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.isDarkMode == isDarkMode &&
        other.notificationsEnabled == notificationsEnabled &&
        other.soundEnabled == soundEnabled &&
        other.vibrationEnabled == vibrationEnabled &&
        other.locationEnabled == locationEnabled &&
        other.batteryOptimizationDisabled == batteryOptimizationDisabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      isDarkMode,
      notificationsEnabled,
      soundEnabled,
      vibrationEnabled,
      locationEnabled,
      batteryOptimizationDisabled,
    );
  }

  @override
  String toString() {
    return 'AppSettings('
        'isDarkMode: $isDarkMode, '
        'notificationsEnabled: $notificationsEnabled, '
        'soundEnabled: $soundEnabled, '
        'vibrationEnabled: $vibrationEnabled, '
        'locationEnabled: $locationEnabled, '
        'batteryOptimizationDisabled: $batteryOptimizationDisabled'
        ')';
  }
}