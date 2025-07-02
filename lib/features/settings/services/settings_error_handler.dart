// lib/features/settings/services/settings_error_handler.dart

import 'package:athkar_app/core/infrastructure/services/permissions/permission_service.dart';
import 'package:athkar_app/features/settings/models/app_settings.dart';
import 'package:flutter/material.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/error/failure.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';

/// معالج الأخطاء المخصص للإعدادات
class SettingsErrorHandler {
  final AppErrorHandler _errorHandler;
  final LoggerService _logger;
  
  SettingsErrorHandler({
    required AppErrorHandler errorHandler,
    required LoggerService logger,
  }) : _errorHandler = errorHandler,
       _logger = logger;
  
  /// معالجة أخطاء تحميل الإعدادات
  Future<T?> handleSettingsLoad<T>(
    Future<T> Function() operation, {
    String operationName = 'settings_load',
  }) async {
    return await _errorHandler.handleError(
      operation,
      operationName: operationName,
      onError: (failure) => _handleSettingsFailure(failure),
    );
  }
  
  /// معالجة أخطاء حفظ الإعدادات
  Future<bool> handleSettingsSave(
    Future<bool> Function() operation, {
    String operationName = 'settings_save',
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      _logger.error(
        message: '[SettingsErrorHandler] فشل حفظ الإعدادات',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
  
  /// معالجة أخطاء الأذونات
  Future<T?> handlePermissionOperation<T>(
    Future<T> Function() operation, {
    String operationName = 'permission_operation',
  }) async {
    return await _errorHandler.handleError(
      operation,
      operationName: operationName,
      onError: (failure) => _handlePermissionFailure(failure),
    );
  }
  
  void _handleSettingsFailure(Failure failure) {
    _logger.error(
      message: '[SettingsErrorHandler] فشل في عملية الإعدادات',
      error: failure.toString(),
    );
  }
  
  void _handlePermissionFailure(Failure failure) {
    _logger.error(
      message: '[SettingsErrorHandler] فشل في عملية الأذونات',
      error: failure.toString(),
    );
  }
  
  /// عرض رسالة خطأ للمستخدم
  static void showError(BuildContext context, String message) {
    AppErrorHandler.showErrorSnackBar(context, message);
  }
  
  /// عرض dialog خطأ
  static Future<bool> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) async {
    return await AppErrorHandler.showErrorDialog(
      context,
      title: title,
      message: message,
      primaryButtonText: actionText ?? 'موافق',
      onPrimaryAction: onAction,
    );
  }
}

// ==================== Extensions مفيدة ====================

/// Extension لـ BuildContext لسهولة الوصول
extension SettingsContextExtension on BuildContext {
  /// عرض رسالة نجاح
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  /// عرض رسالة خطأ
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  /// عرض رسالة تحذير
  void showWarningMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Extension للإعدادات
extension AppSettingsExtension on AppSettings {
  /// التحقق من اكتمال الإعدادات
  bool get isComplete {
    return notificationsEnabled && locationEnabled;
  }
  
  /// الحصول على نسبة الاكتمال
  double get completionPercentage {
    int completed = 0;
    int total = 5; // عدد الإعدادات المهمة
    
    if (notificationsEnabled) completed++;
    if (locationEnabled) completed++;
    if (batteryOptimizationDisabled) completed++;
    if (vibrationEnabled) completed++;
    if (isDarkMode != null) completed++;
    
    return (completed / total) * 100;
  }
  
  /// الحصول على الإعدادات المفقودة
  List<String> get missingSettings {
    final missing = <String>[];
    
    if (!notificationsEnabled) missing.add('الإشعارات');
    if (!locationEnabled) missing.add('الموقع');
    if (!batteryOptimizationDisabled) missing.add('تحسين البطارية');
    
    return missing;
  }
}

// ==================== Constants للإعدادات ====================

class SettingsConstants {
  SettingsConstants._();
  
  // مدة التأخير للعمليات
  static const Duration loadDelay = Duration(milliseconds: 300);
  static const Duration saveDelay = Duration(milliseconds: 150);
  static const Duration refreshDelay = Duration(milliseconds: 500);
  
  // رسائل الخطأ الافتراضية
  static const String defaultLoadError = 'فشل تحميل الإعدادات';
  static const String defaultSaveError = 'فشل حفظ الإعدادات';
  static const String defaultPermissionError = 'فشل في طلب الإذن';
  
  // رسائل النجاح الافتراضية
  static const String defaultSaveSuccess = 'تم حفظ الإعدادات بنجاح';
  static const String defaultPermissionSuccess = 'تم منح الإذن بنجاح';
  
  // حدود التحكم
  static const int maxRetries = 3;
  static const Duration timeoutDuration = Duration(seconds: 10);
  
  // مفاتيح التخزين الإضافية
  static const String settingsVersionKey = 'settings_version';
  static const String lastUpdateKey = 'last_settings_update';
  static const String errorLogKey = 'settings_error_log';
}

// ==================== Utils للإعدادات ====================

class SettingsUtils {
  SettingsUtils._();
  
  /// تحويل AppPermissionType إلى نص عربي
  static String getPermissionDisplayName(AppPermissionType permission) {
    switch (permission) {
      case AppPermissionType.notification:
        return 'الإشعارات';
      case AppPermissionType.location:
        return 'الموقع';
      case AppPermissionType.batteryOptimization:
        return 'تحسين البطارية';
      case AppPermissionType.storage:
        return 'التخزين';
      case AppPermissionType.doNotDisturb:
        return 'عدم الإزعاج';
      default:
        return 'غير معروف';
    }
  }
  
  /// تحويل AppPermissionStatus إلى نص عربي
  static String getPermissionStatusDisplayName(AppPermissionStatus status) {
    switch (status) {
      case AppPermissionStatus.granted:
        return 'ممنوح';
      case AppPermissionStatus.denied:
        return 'مرفوض';
      case AppPermissionStatus.permanentlyDenied:
        return 'مرفوض نهائياً';
      case AppPermissionStatus.restricted:
        return 'مقيد';
      case AppPermissionStatus.limited:
        return 'محدود';
      case AppPermissionStatus.provisional:
        return 'مؤقت';
      default:
        return 'غير معروف';
    }
  }
  
  /// الحصول على لون حسب حالة الإذن
  static Color getPermissionStatusColor(AppPermissionStatus status) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Colors.green;
      case AppPermissionStatus.denied:
        return Colors.orange;
      case AppPermissionStatus.permanentlyDenied:
        return Colors.red;
      case AppPermissionStatus.restricted:
        return Colors.grey;
      case AppPermissionStatus.limited:
        return Colors.yellow;
      case AppPermissionStatus.provisional:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
  
  /// الحصول على أيقونة حسب حالة الإذن
  static IconData getPermissionStatusIcon(AppPermissionStatus status) {
    switch (status) {
      case AppPermissionStatus.granted:
        return Icons.check_circle;
      case AppPermissionStatus.denied:
        return Icons.cancel;
      case AppPermissionStatus.permanentlyDenied:
        return Icons.block;
      case AppPermissionStatus.restricted:
        return Icons.warning;
      case AppPermissionStatus.limited:
        return Icons.timer;
      case AppPermissionStatus.provisional:
        return Icons.schedule;
      default:
        return Icons.help_outline;
    }
  }
  
  /// تنسيق تاريخ ووقت آخر تحديث
  static String formatLastUpdate(DateTime? dateTime) {
    if (dateTime == null) return 'لم يتم التحديث بعد';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return 'منذ ${(difference.inDays / 7).floor()} أسبوع';
    }
  }
  
  /// التحقق من صحة الإعدادات
  static List<String> validateSettings(AppSettings settings) {
    final errors = <String>[];
    
    // يمكن إضافة قواعد التحقق هنا
    // مثال: التحقق من التناسق بين الإعدادات
    
    if (settings.soundEnabled && !settings.notificationsEnabled) {
      errors.add('لا يمكن تفعيل الصوت بدون تفعيل الإشعارات');
    }
    
    if (settings.vibrationEnabled && !settings.notificationsEnabled) {
      errors.add('لا يمكن تفعيل الاهتزاز بدون تفعيل الإشعارات');
    }
    
    return errors;
  }
  
  /// دمج الإعدادات مع التحقق من التعارضات
  static AppSettings mergeSettings(AppSettings current, AppSettings updates) {
    // دمج الإعدادات مع حل التعارضات
    var merged = current.copyWith(
      isDarkMode: updates.isDarkMode,
      notificationsEnabled: updates.notificationsEnabled,
      soundEnabled: updates.soundEnabled,
      vibrationEnabled: updates.vibrationEnabled,
      locationEnabled: updates.locationEnabled,
      batteryOptimizationDisabled: updates.batteryOptimizationDisabled,
    );
    
    // حل التعارضات
    if (!merged.notificationsEnabled) {
      merged = merged.copyWith(
        soundEnabled: false,
        vibrationEnabled: false,
      );
    }
    
    return merged;
  }
}

// ==================== Validators للإعدادات ====================

class SettingsValidators {
  SettingsValidators._();
  
  /// التحقق من صحة إعدادات الإشعارات
  static bool validateNotificationSettings({
    required bool notificationsEnabled,
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) {
    if (soundEnabled && !notificationsEnabled) return false;
    if (vibrationEnabled && !notificationsEnabled) return false;
    return true;
  }
  
  /// التحقق من صحة إعدادات الموقع
  static bool validateLocationSettings({
    required bool locationEnabled,
    dynamic location,
  }) {
    if (locationEnabled && location == null) return false;
    return true;
  }
  
  /// التحقق الشامل من صحة الإعدادات
  static ValidationResult validateAllSettings(AppSettings settings) {
    final errors = <String>[];
    final warnings = <String>[];
    
    // التحقق من الإشعارات
    if (!validateNotificationSettings(
      notificationsEnabled: settings.notificationsEnabled,
      soundEnabled: settings.soundEnabled,
      vibrationEnabled: settings.vibrationEnabled,
    )) {
      errors.add('إعدادات الإشعارات غير متسقة');
    }
    
    // التحقق من الموقع
    if (!validateLocationSettings(
      locationEnabled: settings.locationEnabled,
      location: null, // يجب تمرير الموقع الفعلي
    )) {
      warnings.add('الموقع مفعل لكن لم يتم تحديده');
    }
    
    // تحذيرات الأداء
    if (!settings.batteryOptimizationDisabled) {
      warnings.add('تحسين البطارية غير مفعل - قد يؤثر على التذكيرات');
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}

/// نتيجة التحقق من صحة الإعدادات
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  
  ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });
  
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;
  String get summary => 'أخطاء: ${errors.length}, تحذيرات: ${warnings.length}';
}

// ==================== Migration للإعدادات ====================

class SettingsMigration {
  static const int currentVersion = 1;
  
  /// ترقية الإعدادات للإصدار الجديد
  static AppSettings migrateSettings(
    Map<String, dynamic> oldSettings,
    int fromVersion,
  ) {
    var settings = oldSettings;
    
    // ترقية من الإصدار 0 إلى 1
    if (fromVersion < 1) {
      settings = _migrateToV1(settings);
    }
    
    // يمكن إضافة المزيد من الترقيات هنا
    
    return AppSettings.fromJson(settings);
  }
  
  static Map<String, dynamic> _migrateToV1(Map<String, dynamic> settings) {
    // إضافة الحقول الجديدة مع القيم الافتراضية
    settings['batteryOptimizationDisabled'] ??= false;
    
    // تحويل الحقول القديمة
    if (settings.containsKey('darkMode')) {
      settings['isDarkMode'] = settings['darkMode'];
      settings.remove('darkMode');
    }
    
    return settings;
  }
}