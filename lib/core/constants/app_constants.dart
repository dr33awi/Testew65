// lib/core/constants/app_constants.dart

/// ثوابت التطبيق الخاصة بتطبيق الأذكار
/// يحتوي فقط على الثوابت الخاصة بالتطبيق وليس الثيم
class AppConstants {
  AppConstants._();
  
  // ===== معلومات التطبيق =====
  static const String appName = 'تطبيق الأذكار';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // ===== اللغات =====
  static const String defaultLanguage = 'ar';
  static const List<String> supportedLanguages = ['ar', 'en'];
  
  // ===== مفاتيح التخزين الخاصة بالتطبيق =====
  static const String storagePrefix = 'athkar_';
  static const String settingsKey = '${storagePrefix}settings';
  static const String userPreferencesKey = '${storagePrefix}user_preferences';
  static const String themeKey = '${storagePrefix}theme';
  static const String localeKey = '${storagePrefix}locale';
  static const String onboardingKey = '${storagePrefix}onboarding_completed';
  static const String favoritesKey = '${storagePrefix}favorites';
  static const String athkarProgressKey = '${storagePrefix}athkar_progress';
  static const String lastReadKey = '${storagePrefix}last_read';
  static const String tasbihCounterKey = '${storagePrefix}tasbih_counter';
  static const String bookmarksKey = '${storagePrefix}bookmarks';
  static const String dailyGoalsKey = '${storagePrefix}daily_goals';
  
  // ===== ميزات التطبيق =====
  static const bool enableAthkarReminders = true;
  static const bool enablePrayerTimes = true;
  static const bool enableQibla = true;
  static const bool enableTasbih = true;
  static const bool enableQuran = true;
  static const bool enableDua = true;
  
  // ===== إعدادات افتراضية خاصة بالتطبيق =====
  static const int defaultPageSize = 20;
  static const int maxRecentItems = 10;
  static const int defaultDailyAthkarGoal = 100;
  static const int defaultTasbihGoal = 33;
  
  // ===== URLs =====
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportEmail = 'support@athkarapp.com';
  
  // ===== مسارات الأصول =====
  static const String assetsPath = 'assets';
  static const String imagesPath = '$assetsPath/images';
  static const String soundsPath = '$assetsPath/sounds';
  static const String dataPath = '$assetsPath/data';
  
  // ===== ملفات البيانات =====
  static const String athkarDataFile = '$dataPath/athkar.json';
  static const String duaDataFile = '$dataPath/dua.json';
  static const String prayerTimesDataFile = '$dataPath/prayer_times.json';
}