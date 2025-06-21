// lib/features/settings/services/settings_services_manager.dart (مصحح)

import 'package:flutter/material.dart';
import 'package:athkar_app/core/infrastructure/services/storage/storage_service.dart';
import 'package:athkar_app/core/infrastructure/services/permissions/permission_service.dart';
import 'package:athkar_app/core/infrastructure/services/logging/logger_service.dart';
import 'package:athkar_app/core/infrastructure/services/device/battery/battery_service.dart';
import 'package:athkar_app/core/infrastructure/services/notifications/notification_manager.dart';
import 'package:athkar_app/features/prayer_times/services/prayer_times_service.dart';
import 'package:athkar_app/app/themes/app_theme.dart';

/// مدير موحد لجميع إعدادات التطبيق
/// يوفر واجهة سهلة للوصول وتحديث الإعدادات من جميع أجزاء التطبيق
class SettingsServicesManager {
  final StorageService _storage;
  final PermissionService _permissionService;
  final LoggerService _logger;
  final NotificationManager _notificationManager;
  final BatteryService _batteryService;
  final PrayerTimesService _prayerTimesService; // إضافة المعامل المفقود

  // Settings Keys
  static const String _themeKey = 'app_theme_mode';
  static const String _languageKey = 'app_language';
  static const String _fontSizeKey = 'app_font_size';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _quietTimeStartKey = 'quiet_time_start';
  static const String _quietTimeEndKey = 'quiet_time_end';
  static const String _minBatteryLevelKey = 'min_battery_level';
  static const String _autoBackupKey = 'auto_backup_enabled';
  static const String _dataCompressionKey = 'data_compression_enabled';
  static const String _analyticsEnabledKey = 'analytics_enabled';
  static const String _crashReportingKey = 'crash_reporting_enabled';

  SettingsServicesManager({
    required StorageService storage,
    required PermissionService permissionService,
    required LoggerService logger,
    required NotificationManager notificationManager,
    required BatteryService batteryService,
    required PrayerTimesService prayerTimesService, // إضافة المعامل
  })  : _storage = storage,
        _permissionService = permissionService,
        _logger = logger,
        _notificationManager = notificationManager,
        _batteryService = batteryService,
        _prayerTimesService = prayerTimesService {
    _initializeSettings();
  }

  /// تهيئة الإعدادات عند بداية التطبيق
  void _initializeSettings() {
    _logger.debug(message: '[SettingsManager] تهيئة إعدادات التطبيق');
    
    // تحميل وتطبيق السمة المحفوظة
    _loadAndApplyTheme();
    
    // تحميل إعدادات الإشعارات
    _loadNotificationSettings();
    
    _logger.info(message: '[SettingsManager] تم تهيئة جميع الإعدادات');
  }

  // ==================== Theme Settings ====================

  /// الحصول على وضع السمة الحالي
  ThemeMode getThemeMode() {
    final themeString = _storage.getString(_themeKey) ?? 'system';
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// تحديث وضع السمة
  Future<bool> setThemeMode(ThemeMode mode) async {
    try {
      String themeString;
      switch (mode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }

      final success = await _storage.setString(_themeKey, themeString);
      if (success) {
        AppTheme.setThemeMode(mode);
        _logger.info(
          message: '[SettingsManager] تم تحديث وضع السمة',
          data: {'theme': themeString},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث وضع السمة',
        error: e,
      );
      return false;
    }
  }

  void _loadAndApplyTheme() {
    final themeMode = getThemeMode();
    AppTheme.setThemeMode(themeMode);
    _logger.debug(
      message: '[SettingsManager] تم تطبيق السمة المحفوظة',
      data: {'theme': themeMode.toString()},
    );
  }

  // ==================== Language Settings ====================

  /// الحصول على اللغة الحالية
  String getLanguage() {
    return _storage.getString(_languageKey) ?? 'ar';
  }

  /// تحديث اللغة
  Future<bool> setLanguage(String languageCode) async {
    try {
      final success = await _storage.setString(_languageKey, languageCode);
      if (success) {
        _logger.info(
          message: '[SettingsManager] تم تحديث اللغة',
          data: {'language': languageCode},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث اللغة',
        error: e,
      );
      return false;
    }
  }

  // ==================== Display Settings ====================

  /// الحصول على حجم الخط
  double getFontSize() {
    return _storage.getDouble(_fontSizeKey) ?? 1.0;
  }

  /// تحديث حجم الخط
  Future<bool> setFontSize(double size) async {
    try {
      final success = await _storage.setDouble(_fontSizeKey, size);
      if (success) {
        _logger.info(
          message: '[SettingsManager] تم تحديث حجم الخط',
          data: {'fontSize': size},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث حجم الخط',
        error: e,
      );
      return false;
    }
  }

  // ==================== Notification Settings ====================

  /// فحص حالة الإشعارات
  bool areNotificationsEnabled() {
    return _storage.getBool(_notificationsEnabledKey) ?? true;
  }

  /// تفعيل/تعطيل الإشعارات
  Future<bool> setNotificationsEnabled(bool enabled) async {
    try {
      final success = await _storage.setBool(_notificationsEnabledKey, enabled);
      if (success) {
        await _notificationManager.setEnabled(enabled);
        _logger.info(
          message: '[SettingsManager] تم تحديث حالة الإشعارات',
          data: {'enabled': enabled},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث حالة الإشعارات',
        error: e,
      );
      return false;
    }
  }

  /// فحص حالة الاهتزاز
  bool isVibrationEnabled() {
    return _storage.getBool(_vibrationEnabledKey) ?? true;
  }

  /// تفعيل/تعطيل الاهتزاز
  Future<bool> setVibrationEnabled(bool enabled) async {
    try {
      final success = await _storage.setBool(_vibrationEnabledKey, enabled);
      if (success) {
        _logger.info(
          message: '[SettingsManager] تم تحديث حالة الاهتزاز',
          data: {'enabled': enabled},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث حالة الاهتزاز',
        error: e,
      );
      return false;
    }
  }

  /// الحصول على وقت بداية الهدوء
  TimeOfDay? getQuietTimeStart() {
    final timeString = _storage.getString(_quietTimeStartKey);
    return _parseTimeOfDay(timeString);
  }

  /// الحصول على وقت نهاية الهدوء
  TimeOfDay? getQuietTimeEnd() {
    final timeString = _storage.getString(_quietTimeEndKey);
    return _parseTimeOfDay(timeString);
  }

  /// تحديث وقت الهدوء
  Future<bool> setQuietTime({
    TimeOfDay? start,
    TimeOfDay? end,
  }) async {
    try {
      bool success = true;
      
      if (start != null) {
        success &= await _storage.setString(
          _quietTimeStartKey,
          _formatTimeOfDay(start),
        );
      }
      
      if (end != null) {
        success &= await _storage.setString(
          _quietTimeEndKey,
          _formatTimeOfDay(end),
        );
      }

      if (success) {
        await _notificationManager.setQuietTime(start: start, end: end);
        _logger.info(
          message: '[SettingsManager] تم تحديث وقت الهدوء',
          data: {
            'start': start != null ? _formatTimeOfDay(start) : null,
            'end': end != null ? _formatTimeOfDay(end) : null,
          },
        );
      }
      
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث وقت الهدوء',
        error: e,
      );
      return false;
    }
  }

  void _loadNotificationSettings() {
    // تطبيق إعدادات الإشعارات المحفوظة
    // سيتم تحميل الإعدادات من NotificationManager مباشرة
  }

  // ==================== Battery Settings ====================

  /// الحصول على الحد الأدنى لمستوى البطارية
  int getMinBatteryLevel() {
    return _storage.getInt(_minBatteryLevelKey) ?? 15;
  }

  /// تحديث الحد الأدنى لمستوى البطارية
  Future<bool> setMinBatteryLevel(int level) async {
    try {
      final success = await _storage.setInt(_minBatteryLevelKey, level);
      if (success) {
        await _batteryService.setMinimumBatteryLevel(level);
        await _notificationManager.setMinBatteryLevel(level);
        _logger.info(
          message: '[SettingsManager] تم تحديث الحد الأدنى للبطارية',
          data: {'level': level},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث الحد الأدنى للبطارية',
        error: e,
      );
      return false;
    }
  }

  // ==================== Data Settings ====================

  /// فحص حالة النسخ الاحتياطي التلقائي
  bool isAutoBackupEnabled() {
    return _storage.getBool(_autoBackupKey) ?? false;
  }

  /// تفعيل/تعطيل النسخ الاحتياطي التلقائي
  Future<bool> setAutoBackupEnabled(bool enabled) async {
    try {
      final success = await _storage.setBool(_autoBackupKey, enabled);
      if (success) {
        _logger.info(
          message: '[SettingsManager] تم تحديث النسخ الاحتياطي التلقائي',
          data: {'enabled': enabled},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث النسخ الاحتياطي التلقائي',
        error: e,
      );
      return false;
    }
  }

  /// فحص حالة ضغط البيانات
  bool isDataCompressionEnabled() {
    return _storage.getBool(_dataCompressionKey) ?? true;
  }

  /// تفعيل/تعطيل ضغط البيانات
  Future<bool> setDataCompressionEnabled(bool enabled) async {
    try {
      final success = await _storage.setBool(_dataCompressionKey, enabled);
      if (success) {
        _logger.info(
          message: '[SettingsManager] تم تحديث ضغط البيانات',
          data: {'enabled': enabled},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث ضغط البيانات',
        error: e,
      );
      return false;
    }
  }

  // ==================== Privacy Settings ====================

  /// فحص حالة Analytics
  bool isAnalyticsEnabled() {
    return _storage.getBool(_analyticsEnabledKey) ?? true;
  }

  /// تفعيل/تعطيل Analytics
  Future<bool> setAnalyticsEnabled(bool enabled) async {
    try {
      final success = await _storage.setBool(_analyticsEnabledKey, enabled);
      if (success) {
        _logger.info(
          message: '[SettingsManager] تم تحديث Analytics',
          data: {'enabled': enabled},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث Analytics',
        error: e,
      );
      return false;
    }
  }

  /// فحص حالة تقارير الأخطاء
  bool isCrashReportingEnabled() {
    return _storage.getBool(_crashReportingKey) ?? true;
  }

  /// تفعيل/تعطيل تقارير الأخطاء
  Future<bool> setCrashReportingEnabled(bool enabled) async {
    try {
      final success = await _storage.setBool(_crashReportingKey, enabled);
      if (success) {
        _logger.info(
          message: '[SettingsManager] تم تحديث تقارير الأخطاء',
          data: {'enabled': enabled},
        );
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تحديث تقارير الأخطاء',
        error: e,
      );
      return false;
    }
  }

  // ==================== Permission Management ====================

  /// فحص جميع الأذونات
  Future<Map<AppPermissionType, AppPermissionStatus>> checkAllPermissions() async {
    try {
      return await _permissionService.checkAllPermissions();
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في فحص الأذونات',
        error: e,
      );
      return {};
    }
  }

  /// طلب إذن محدد
  Future<AppPermissionStatus> requestPermission(AppPermissionType permission) async {
    try {
      return await _permissionService.requestPermission(permission);
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في طلب الإذن',
        error: e,
      );
      return AppPermissionStatus.unknown;
    }
  }

  /// فتح إعدادات التطبيق
  Future<bool> openAppSettings() async {
    try {
      return await _permissionService.openAppSettings();
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في فتح إعدادات التطبيق',
        error: e,
      );
      return false;
    }
  }

  // ==================== Data Management ====================

  /// الحصول على حجم البيانات
  Future<int> getDataSize() async {
    try {
      return await _storage.getStorageSize();
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في الحصول على حجم البيانات',
        error: e,
      );
      return 0;
    }
  }

  /// مسح جميع البيانات
  Future<bool> clearAllData() async {
    try {
      final success = await _storage.clear();
      if (success) {
        _logger.info(message: '[SettingsManager] تم مسح جميع البيانات');
        // إعادة تهيئة الإعدادات الافتراضية
        _initializeSettings();
      }
      return success;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في مسح البيانات',
        error: e,
      );
      return false;
    }
  }

  /// إعادة تعيين الإعدادات إلى القيم الافتراضية
  Future<bool> resetToDefaults() async {
    try {
      // إعادة تعيين الإعدادات الأساسية
      await setThemeMode(ThemeMode.system);
      await setLanguage('ar');
      await setFontSize(1.0);
      await setNotificationsEnabled(true);
      await setVibrationEnabled(true);
      await setMinBatteryLevel(15);
      await setAutoBackupEnabled(false);
      await setDataCompressionEnabled(true);
      await setAnalyticsEnabled(true);
      await setCrashReportingEnabled(true);

      _logger.info(message: '[SettingsManager] تم إعادة تعيين الإعدادات');
      return true;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في إعادة تعيين الإعدادات',
        error: e,
      );
      return false;
    }
  }

  /// إنشاء نسخة احتياطية من الإعدادات
  Future<Map<String, dynamic>?> exportSettings() async {
    try {
      final settings = <String, dynamic>{
        'theme_mode': getThemeMode().toString(),
        'language': getLanguage(),
        'font_size': getFontSize(),
        'notifications_enabled': areNotificationsEnabled(),
        'vibration_enabled': isVibrationEnabled(),
        'quiet_time_start': _formatTimeOfDayForExport(getQuietTimeStart()),
        'quiet_time_end': _formatTimeOfDayForExport(getQuietTimeEnd()),
        'min_battery_level': getMinBatteryLevel(),
        'auto_backup': isAutoBackupEnabled(),
        'data_compression': isDataCompressionEnabled(),
        'analytics_enabled': isAnalyticsEnabled(),
        'crash_reporting': isCrashReportingEnabled(),
        'export_date': DateTime.now().toIso8601String(),
      };

      _logger.info(message: '[SettingsManager] تم تصدير الإعدادات');
      return settings;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تصدير الإعدادات',
        error: e,
      );
      return null;
    }
  }

  /// استيراد الإعدادات من نسخة احتياطية
  Future<bool> importSettings(Map<String, dynamic> settings) async {
    try {
      // استيراد الإعدادات مع التحقق من صحتها
      if (settings['theme_mode'] != null) {
        final themeMode = _parseThemeMode(settings['theme_mode']);
        if (themeMode != null) await setThemeMode(themeMode);
      }

      if (settings['language'] != null) {
        await setLanguage(settings['language']);
      }

      if (settings['font_size'] != null) {
        await setFontSize(settings['font_size'].toDouble());
      }

      if (settings['notifications_enabled'] != null) {
        await setNotificationsEnabled(settings['notifications_enabled']);
      }

      if (settings['vibration_enabled'] != null) {
        await setVibrationEnabled(settings['vibration_enabled']);
      }

      if (settings['min_battery_level'] != null) {
        await setMinBatteryLevel(settings['min_battery_level']);
      }

      _logger.info(message: '[SettingsManager] تم استيراد الإعدادات');
      return true;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في استيراد الإعدادات',
        error: e,
      );
      return false;
    }
  }

  // ==================== Helper Methods ====================

  TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null) return null;
    
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      _logger.warning(
        message: '[SettingsManager] خطأ في تحليل الوقت',
        data: {'timeString': timeString, 'error': e.toString()},
      );
    }
    return null;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
           '${time.minute.toString().padLeft(2, '0')}';
  }

  String? _formatTimeOfDayForExport(TimeOfDay? time) {
    if (time == null) return null;
    return _formatTimeOfDay(time);
  }

  ThemeMode? _parseThemeMode(String themeModeString) {
    switch (themeModeString.toLowerCase()) {
      case 'thememode.light':
      case 'light':
        return ThemeMode.light;
      case 'thememode.dark':
      case 'dark':
        return ThemeMode.dark;
      case 'thememode.system':
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }

  /// التنظيف عند إغلاق التطبيق
  Future<void> dispose() async {
    _logger.debug(message: '[SettingsManager] تنظيف الموارد');
    // يمكن إضافة أي تنظيف مطلوب هنا
  }
}