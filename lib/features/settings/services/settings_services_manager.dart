// lib/features/settings/services/settings_services_manager.dart (منظف)

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
  final PrayerTimesService _prayerTimesService;

  // Settings Keys - مفاتيح الإعدادات المطلوبة فقط
  static const String _themeKey = 'app_theme_mode';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _quietTimeStartKey = 'quiet_time_start';
  static const String _quietTimeEndKey = 'quiet_time_end';
  static const String _minBatteryLevelKey = 'min_battery_level';

  SettingsServicesManager({
    required StorageService storage,
    required PermissionService permissionService,
    required LoggerService logger,
    required NotificationManager notificationManager,
    required BatteryService batteryService,
    required PrayerTimesService prayerTimesService,
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

  // ==================== Basic Data Management ====================

  /// الحصول على حجم البيانات (للعرض فقط)
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

  /// إعادة تعيين الإعدادات إلى القيم الافتراضية
  Future<bool> resetToDefaults() async {
    try {
      // إعادة تعيين الإعدادات الأساسية فقط
      await setThemeMode(ThemeMode.system);
      await setNotificationsEnabled(true);
      await setVibrationEnabled(true);
      await setMinBatteryLevel(15);

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

  /// إنشاء نسخة احتياطية مبسطة من الإعدادات الأساسية
  Future<Map<String, dynamic>?> exportBasicSettings() async {
    try {
      final settings = <String, dynamic>{
        'theme_mode': getThemeMode().toString(),
        'notifications_enabled': areNotificationsEnabled(),
        'vibration_enabled': isVibrationEnabled(),
        'quiet_time_start': _formatTimeOfDayForExport(getQuietTimeStart()),
        'quiet_time_end': _formatTimeOfDayForExport(getQuietTimeEnd()),
        'min_battery_level': getMinBatteryLevel(),
        'export_date': DateTime.now().toIso8601String(),
      };

      _logger.info(message: '[SettingsManager] تم تصدير الإعدادات الأساسية');
      return settings;
    } catch (e) {
      _logger.error(
        message: '[SettingsManager] خطأ في تصدير الإعدادات',
        error: e,
      );
      return null;
    }
  }

  /// استيراد الإعدادات الأساسية من نسخة احتياطية
  Future<bool> importBasicSettings(Map<String, dynamic> settings) async {
    try {
      // استيراد الإعدادات مع التحقق من صحتها
      if (settings['theme_mode'] != null) {
        final themeMode = _parseThemeMode(settings['theme_mode']);
        if (themeMode != null) await setThemeMode(themeMode);
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

      _logger.info(message: '[SettingsManager] تم استيراد الإعدادات الأساسية');
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