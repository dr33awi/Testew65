// lib/features/settings/models/app_settings.dart
/// نموذج إعدادات التطبيق
class AppSettings {
  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final double fontSize;
  final bool locationEnabled;
  final bool batteryOptimizationDisabled;

  const AppSettings({
    this.isDarkMode = false,
    this.language = 'ar',
    this.notificationsEnabled = false,
    this.soundEnabled = false,
    this.vibrationEnabled = true,
    this.fontSize = 16.0,
    this.locationEnabled = false,
    this.batteryOptimizationDisabled = false,
  });

  /// إنشاء نسخة جديدة مع تغيير بعض القيم
  AppSettings copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    double? fontSize,
    bool? locationEnabled,
    bool? batteryOptimizationDisabled,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      fontSize: fontSize ?? this.fontSize,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      batteryOptimizationDisabled: batteryOptimizationDisabled ?? this.batteryOptimizationDisabled,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'fontSize': fontSize,
      'locationEnabled': locationEnabled,
      'batteryOptimizationDisabled': batteryOptimizationDisabled,
    };
  }

  /// إنشاء من JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] ?? false,
      language: json['language'] ?? 'ar',
      notificationsEnabled: json['notificationsEnabled'] ?? false,
      soundEnabled: json['soundEnabled'] ?? false,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      fontSize: (json['fontSize'] ?? 16.0).toDouble(),
      locationEnabled: json['locationEnabled'] ?? false,
      batteryOptimizationDisabled: json['batteryOptimizationDisabled'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.isDarkMode == isDarkMode &&
        other.language == language &&
        other.notificationsEnabled == notificationsEnabled &&
        other.soundEnabled == soundEnabled &&
        other.vibrationEnabled == vibrationEnabled &&
        other.fontSize == fontSize &&
        other.locationEnabled == locationEnabled &&
        other.batteryOptimizationDisabled == batteryOptimizationDisabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      isDarkMode,
      language,
      notificationsEnabled,
      soundEnabled,
      vibrationEnabled,
      fontSize,
      locationEnabled,
      batteryOptimizationDisabled,
    );
  }

  @override
  String toString() {
    return 'AppSettings('
        'isDarkMode: $isDarkMode, '
        'language: $language, '
        'notificationsEnabled: $notificationsEnabled, '
        'soundEnabled: $soundEnabled, '
        'vibrationEnabled: $vibrationEnabled, '
        'fontSize: $fontSize, '
        'locationEnabled: $locationEnabled, '
        'batteryOptimizationDisabled: $batteryOptimizationDisabled'
        ')';
  }
}