// lib/features/settings/services/settings_services_manager.dart (مُصلح كاملاً)

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';
import '../../../core/infrastructure/services/notifications/models/notification_models.dart';
import '../../../core/infrastructure/services/device/battery/battery_service.dart';
import '../../../app/themes/core/theme_notifier.dart';
import '../../../features/prayer_times/services/prayer_times_service.dart';
import '../models/app_settings.dart';

/// مدير مركزي لجميع الخدمات المستخدمة في الإعدادات
class SettingsServicesManager {
  // الخدمات الأساسية
  final StorageService _storage;
  final PermissionService _permissionService;
  final LoggerService _logger;
  final ThemeNotifier _themeNotifier;
  final NotificationManager _notificationManager;
  final BatteryService _batteryService;
  final PrayerTimesService _prayerService;
  
  // Controllers للحالة - سيتم إعادة إنشاؤها عند الحاجة
  StreamController<AppSettings>? _settingsController;
  StreamController<ServiceStatus>? _serviceStatusController;
  
  // Subscriptions
  StreamSubscription? _permissionSubscription;
  StreamSubscription? _batterySubscription;
  
  // الإعدادات الحالية
  AppSettings _currentSettings = const AppSettings();
  ServiceStatus _currentStatus = ServiceStatus.initial();
  
  // مفاتيح التخزين
  static const String _settingsKey = 'app_settings';
  static const String _lastSyncKey = 'last_settings_sync';
  
  // حالة المدير
  bool _isDisposed = false;
  bool _isInitialized = false;
  
  SettingsServicesManager({
    required StorageService storage,
    required PermissionService permissionService,
    required LoggerService logger,
    required ThemeNotifier themeNotifier,
    required NotificationManager notificationManager,
    required BatteryService batteryService,
    required PrayerTimesService prayerService,
  }) : _storage = storage,
       _permissionService = permissionService,
       _logger = logger,
       _themeNotifier = themeNotifier,
       _notificationManager = notificationManager,
       _batteryService = batteryService,
       _prayerService = prayerService {
    _initializeManager();
  }
  
  // ==================== Getters ====================
  
  /// الإعدادات الحالية
  AppSettings get currentSettings => _currentSettings;
  
  /// حالة الخدمات الحالية
  ServiceStatus get currentStatus => _currentStatus;
  
  /// Stream للإعدادات - إنشاء controller جديد إذا لم يكن موجود
  Stream<AppSettings> get settingsStream {
    try {
      _ensureControllersInitialized();
      
      final controller = _settingsController;
      if (controller != null && !controller.isClosed) {
        return controller.stream;
      } else {
        _logger.error(message: '[SettingsServicesManager] فشل في إنشاء settings controller');
        // إرجاع stream يحتوي على القيمة الحالية على الأقل
        return Stream.value(_currentSettings);
      }
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في الحصول على settings stream',
        error: e,
      );
      return Stream.value(_currentSettings);
    }
  }
  
  /// Stream لحالة الخدمات - إنشاء controller جديد إذا لم يكن موجود
  Stream<ServiceStatus> get serviceStatusStream {
    try {
      _ensureControllersInitialized();
      
      final controller = _serviceStatusController;
      if (controller != null && !controller.isClosed) {
        return controller.stream;
      } else {
        _logger.error(message: '[SettingsServicesManager] فشل في إنشاء service status controller');
        // إرجاع stream يحتوي على القيمة الحالية على الأقل
        return Stream.value(_currentStatus);
      }
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في الحصول على service status stream',
        error: e,
      );
      return Stream.value(_currentStatus);
    }
  }
  
  /// الوصول لخدمة الأذونات (للاستخدام الخارجي)
  PermissionService get permissionService => _permissionService;
  
  /// الوصول لخدمة البطارية (للاستخدام الخارجي)
  BatteryService get batteryService => _batteryService;
  
  /// الوصول لمدير الإشعارات (للاستخدام الخارجي)
  NotificationManager get notificationManager => _notificationManager;
  
  // ==================== تهيئة Controllers ====================
  
  /// التأكد من تهيئة Controllers
  void _ensureControllersInitialized() {
    if (_isDisposed) {
      _logger.warning(message: '[SettingsServicesManager] محاولة استخدام مدير محذوف');
      return;
    }
    
    try {
      // إنشاء أو إعادة إنشاء settings controller
      final currentSettingsController = _settingsController;
      if (currentSettingsController == null || currentSettingsController.isClosed) {
        _logger.debug(message: '[SettingsServicesManager] إنشاء settings controller جديد');
        
        // إغلاق القديم إذا كان موجود ولم يكن مُغلق
        if (currentSettingsController != null && !currentSettingsController.isClosed) {
          try {
            currentSettingsController.close();
          } catch (e) {
            _logger.warning(
              message: '[SettingsServicesManager] خطأ في إغلاق settings controller القديم',
              data: {'error': e.toString()},
            );
          }
        }
        
        _settingsController = StreamController<AppSettings>.broadcast();
        
        // إرسال القيمة الحالية فوراً للمستمعين الجدد
        Future.microtask(() {
          final controller = _settingsController;
          if (controller != null && !controller.isClosed) {
            controller.add(_currentSettings);
          }
        });
      }
      
      // إنشاء أو إعادة إنشاء service status controller
      final currentServiceController = _serviceStatusController;
      if (currentServiceController == null || currentServiceController.isClosed) {
        _logger.debug(message: '[SettingsServicesManager] إنشاء service status controller جديد');
        
        // إغلاق القديم إذا كان موجود ولم يكن مُغلق
        if (currentServiceController != null && !currentServiceController.isClosed) {
          try {
            currentServiceController.close();
          } catch (e) {
            _logger.warning(
              message: '[SettingsServicesManager] خطأ في إغلاق service status controller القديم',
              data: {'error': e.toString()},
            );
          }
        }
        
        _serviceStatusController = StreamController<ServiceStatus>.broadcast();
        
        // إرسال القيمة الحالية فوراً للمستمعين الجدد
        Future.microtask(() {
          final controller = _serviceStatusController;
          if (controller != null && !controller.isClosed) {
            controller.add(_currentStatus);
          }
        });
      }
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في تهيئة Controllers',
        error: e,
      );
    }
  }
  
  // ==================== التهيئة ====================
  
  void _initializeManager() {
    if (_isDisposed || _isInitialized) return;
    
    try {
      _logger.info(message: '[SettingsServicesManager] تهيئة مدير الخدمات');
      
      // تهيئة Controllers
      _ensureControllersInitialized();
      
      // الاستماع لتغييرات الأذونات
      _initializeSubscriptions();
      
      _isInitialized = true;
      _logger.info(message: '[SettingsServicesManager] تم تهيئة مدير الخدمات بنجاح');
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في تهيئة المدير',
        error: e,
      );
    }
  }
  
  void _initializeSubscriptions() {
    if (_isDisposed) return;
    
    try {
      // إلغاء الاشتراكات القديمة إذا كانت موجودة
      _permissionSubscription?.cancel();
      _batterySubscription?.cancel();
      
      // الاستماع لتغييرات الأذونات
      _permissionSubscription = _permissionService.permissionChanges.listen(
        _handlePermissionChange,
        onError: (error) {
          _logger.error(
            message: '[SettingsServicesManager] خطأ في stream الأذونات',
            error: error,
          );
        },
        cancelOnError: false, // لا تلغي الاشتراك عند حدوث خطأ
      );
      
      // الاستماع لتغييرات البطارية
      _batterySubscription = _batteryService.getBatteryStateStream().listen(
        _handleBatteryChange,
        onError: (error) {
          _logger.error(
            message: '[SettingsServicesManager] خطأ في stream البطارية',
            error: error,
          );
        },
        cancelOnError: false, // لا تلغي الاشتراك عند حدوث خطأ
      );
      
      _logger.debug(message: '[SettingsServicesManager] تم تهيئة الاشتراكات');
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في تهيئة الاشتراكات',
        error: e,
      );
    }
  }
  
  void _handlePermissionChange(PermissionChange change) {
    if (_isDisposed) return;
    
    try {
      _logger.debug(
        message: '[SettingsServicesManager] تغيير في الأذونات',
        data: {
          'permission': change.permission.toString(),
          'oldStatus': change.oldStatus.toString(),
          'newStatus': change.newStatus.toString(),
        },
      );
      
      // تحديث الحالة عند تغيير الأذونات
      _updateServiceStatus();
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في معالجة تغيير الأذونات',
        error: e,
      );
    }
  }
  
  void _handleBatteryChange(BatteryState batteryState) {
    if (_isDisposed) return;
    
    try {
      _logger.debug(
        message: '[SettingsServicesManager] تغيير في حالة البطارية',
        data: batteryState.toJson(),
      );
      
      // تحديث حالة الخدمات
      _updateServiceStatus();
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في معالجة تغيير البطارية',
        error: e,
      );
    }
  }
  
  // ==================== تحميل وحفظ الإعدادات ====================
  
  /// تحميل الإعدادات من التخزين والخدمات
  Future<SettingsLoadResult> loadSettings() async {
    if (_isDisposed) {
      return SettingsLoadResult.failure('المدير محذوف');
    }
    
    _logger.info(message: '[SettingsServicesManager] بدء تحميل الإعدادات');
    
    try {
      // تأكد من تهيئة Controllers
      _ensureControllersInitialized();
      
      // تحميل الإعدادات المحفوظة
      final savedSettings = await _loadSavedSettings();
      
      // تحميل حالة الخدمات الحالية
      final serviceStatus = await _loadServiceStatus();
      
      // دمج الإعدادات مع حالة الخدمات
      final mergedSettings = await _mergeSettingsWithServices(savedSettings);
      
      // تحديث الحالة
      _currentSettings = mergedSettings;
      _currentStatus = serviceStatus;
      
      // إشعار المستمعين إذا كانت Controllers متاحة
      _notifyListeners();
      
      // تسجيل وقت آخر تحديث
      try {
        await _storage.setString(_lastSyncKey, DateTime.now().toIso8601String());
      } catch (e) {
        _logger.warning(
          message: '[SettingsServicesManager] فشل في حفظ وقت التحديث',
          data: {'error': e.toString()},
        );
      }
      
      _logger.info(
        message: '[SettingsServicesManager] تم تحميل الإعدادات بنجاح',
        data: _currentSettings.toJson(),
      );
      
      return SettingsLoadResult.success(_currentSettings, _currentStatus);
    } catch (e, stackTrace) {
      _logger.error(
        message: '[SettingsServicesManager] فشل تحميل الإعدادات',
        error: e,
        stackTrace: stackTrace,
      );
      
      return SettingsLoadResult.failure(e.toString());
    }
  }
  
  /// إشعار جميع المستمعين
  void _notifyListeners() {
    if (_isDisposed) return;
    
    try {
      // إشعار settings listeners
      final settingsController = _settingsController;
      if (settingsController != null && !settingsController.isClosed) {
        settingsController.add(_currentSettings);
      }
      
      // إشعار service status listeners
      final serviceStatusController = _serviceStatusController;
      if (serviceStatusController != null && !serviceStatusController.isClosed) {
        serviceStatusController.add(_currentStatus);
      }
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في إشعار المستمعين',
        error: e,
      );
    }
  }
  
  /// حفظ الإعدادات
  Future<bool> saveSettings(AppSettings settings) async {
    if (_isDisposed) return false;
    
    _logger.info(
      message: '[SettingsServicesManager] حفظ الإعدادات',
      data: settings.toJson(),
    );
    
    try {
      // حفظ الإعدادات في التخزين
      final saved = await _storage.setObject(_settingsKey, settings, (s) => s.toJson());
      if (!saved) {
        _logger.warning(message: '[SettingsServicesManager] فشل في حفظ الإعدادات في التخزين');
        return false;
      }
      
      // تطبيق التغييرات على الخدمات
      await _applySettingsToServices(settings);
      
      // تحديث الحالة الحالية
      _currentSettings = settings;
      
      // إشعار المستمعين
      _notifyListeners();
      
      // تحديث حالة الخدمات
      await _updateServiceStatus();
      
      _logger.info(message: '[SettingsServicesManager] تم حفظ الإعدادات بنجاح');
      return true;
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل حفظ الإعدادات',
        error: e,
      );
      return false;
    }
  }
  
  Future<AppSettings> _loadSavedSettings() async {
    try {
      final savedSettings = _storage.getObject(
        _settingsKey,
        AppSettings.fromJson,
      );
      
      return savedSettings ?? const AppSettings();
    } catch (e) {
      _logger.warning(
        message: '[SettingsServicesManager] فشل تحميل الإعدادات المحفوظة، استخدام الافتراضية',
        data: {'error': e.toString()},
      );
      return const AppSettings();
    }
  }
  
  Future<ServiceStatus> _loadServiceStatus() async {
    try {
      final permissionStatuses = await _permissionService.checkAllPermissions();
      final batteryState = await _batteryService.getCurrentBatteryState();
      final notificationSettings = await _notificationManager.getSettings();
      final currentLocation = _prayerService.currentLocation;
      
      return ServiceStatus(
        permissions: permissionStatuses,
        batteryState: batteryState,
        notificationSettings: notificationSettings,
        locationAvailable: currentLocation != null,
        themeMode: _themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      );
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل تحميل حالة الخدمات',
        error: e,
      );
      return ServiceStatus.initial();
    }
  }
  
  Future<AppSettings> _mergeSettingsWithServices(AppSettings savedSettings) async {
    try {
      // دمج الإعدادات المحفوظة مع حالة الخدمات الحالية
      return savedSettings.copyWith(
        isDarkMode: _themeNotifier.isDarkMode,
        notificationsEnabled: await _permissionService.checkNotificationPermission(),
        locationEnabled: _prayerService.currentLocation != null,
        batteryOptimizationDisabled: await _checkBatteryOptimization(),
      );
    } catch (e) {
      _logger.warning(
        message: '[SettingsServicesManager] فشل في دمج الإعدادات، استخدام المحفوظة',
        data: {'error': e.toString()},
      );
      return savedSettings;
    }
  }
  
  Future<bool> _checkBatteryOptimization() async {
    try {
      final status = await _permissionService.checkPermissionStatus(
        AppPermissionType.batteryOptimization,
      );
      return status == AppPermissionStatus.granted;
    } catch (e) {
      _logger.warning(
        message: '[SettingsServicesManager] فشل في فحص تحسين البطارية',
        data: {'error': e.toString()},
      );
      return false;
    }
  }
  
  Future<void> _applySettingsToServices(AppSettings settings) async {
    try {
      // تطبيق إعدادات الثيم
      if (settings.isDarkMode != _themeNotifier.isDarkMode) {
        await _themeNotifier.setTheme(settings.isDarkMode);
      }
      
      // تطبيق إعدادات الإشعارات
      final currentNotificationSettings = await _notificationManager.getSettings();
      final newNotificationSettings = currentNotificationSettings.copyWith(
        enabled: settings.notificationsEnabled,
        soundEnabled: settings.soundEnabled,
        vibrationEnabled: settings.vibrationEnabled,
      );
      
      await _notificationManager.updateSettings(newNotificationSettings);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل في تطبيق الإعدادات على الخدمات',
        error: e,
      );
    }
  }
  
  // ==================== إدارة الأذونات ====================
  
  /// طلب إذن محدد
  Future<PermissionRequestResult> requestPermission(AppPermissionType permission) async {
    if (_isDisposed) {
      return PermissionRequestResult.failure('المدير محذوف');
    }
    
    _logger.info(
      message: '[SettingsServicesManager] طلب إذن',
      data: {'permission': permission.toString()},
    );
    
    try {
      final status = await _permissionService.requestPermission(permission);
      
      // تحديث الإعدادات حسب النتيجة
      await _updateSettingsAfterPermissionChange(permission, status);
      
      _logger.info(
        message: '[SettingsServicesManager] نتيجة طلب الإذن',
        data: {
          'permission': permission.toString(),
          'status': status.toString(),
        },
      );
      
      return PermissionRequestResult.success(status);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل طلب الإذن',
        error: e,
      );
      
      return PermissionRequestResult.failure(e.toString());
    }
  }
  
  /// طلب أذونات متعددة
  Future<BatchPermissionResult> requestMultiplePermissions(
    List<AppPermissionType> permissions,
    {Function(PermissionProgress)? onProgress}
  ) async {
    if (_isDisposed) {
      return BatchPermissionResult.failure('المدير محذوف');
    }
    
    _logger.info(
      message: '[SettingsServicesManager] طلب أذونات متعددة',
      data: {'permissions': permissions.map((p) => p.toString()).toList()},
    );
    
    try {
      final result = await _permissionService.requestMultiplePermissions(
        permissions: permissions,
        onProgress: onProgress,
      );
      
      // تحديث الإعدادات بناءً على النتائج
      for (final entry in result.results.entries) {
        await _updateSettingsAfterPermissionChange(entry.key, entry.value);
      }
      
      return BatchPermissionResult.fromPermissionBatchResult(result);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل طلب الأذونات المتعددة',
        error: e,
      );
      
      return BatchPermissionResult.failure(e.toString());
    }
  }
  
  Future<void> _updateSettingsAfterPermissionChange(
    AppPermissionType permission,
    AppPermissionStatus status,
  ) async {
    try {
      bool shouldUpdate = false;
      AppSettings newSettings = _currentSettings;
      
      switch (permission) {
        case AppPermissionType.notification:
          final isGranted = status == AppPermissionStatus.granted;
          if (newSettings.notificationsEnabled != isGranted) {
            newSettings = newSettings.copyWith(notificationsEnabled: isGranted);
            shouldUpdate = true;
          }
          break;
          
        case AppPermissionType.location:
          final isGranted = status == AppPermissionStatus.granted;
          if (newSettings.locationEnabled != isGranted) {
            newSettings = newSettings.copyWith(locationEnabled: isGranted);
            shouldUpdate = true;
          }
          break;
          
        case AppPermissionType.batteryOptimization:
          final isGranted = status == AppPermissionStatus.granted;
          if (newSettings.batteryOptimizationDisabled != isGranted) {
            newSettings = newSettings.copyWith(batteryOptimizationDisabled: isGranted);
            shouldUpdate = true;
          }
          break;
          
        default:
          break;
      }
      
      if (shouldUpdate) {
        await saveSettings(newSettings);
      }
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل في تحديث الإعدادات بعد تغيير الإذن',
        error: e,
      );
    }
  }
  
  // ==================== إدارة الخدمات المتخصصة ====================
  
  /// تحديث موقع الصلاة
  Future<LocationUpdateResult> updatePrayerLocation() async {
    if (_isDisposed) {
      return LocationUpdateResult.failure('المدير محذوف');
    }
    
    _logger.info(message: '[SettingsServicesManager] تحديث موقع الصلاة');
    
    try {
      final location = await _prayerService.getCurrentLocation();
      await _prayerService.updatePrayerTimes();
      
      // تحديث الإعدادات
      final newSettings = _currentSettings.copyWith(locationEnabled: true);
      await saveSettings(newSettings);
      
      _logger.info(
        message: '[SettingsServicesManager] تم تحديث موقع الصلاة بنجاح',
        data: {
          'city': location.cityName ?? 'غير محدد',
          'country': location.countryName ?? 'غير محدد',
        },
      );
      
      return LocationUpdateResult.success(location);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل تحديث موقع الصلاة',
        error: e,
      );
      
      return LocationUpdateResult.failure(e.toString());
    }
  }
  
  /// تحسين إعدادات البطارية
  Future<BatteryOptimizationResult> optimizeBatterySettings() async {
    if (_isDisposed) {
      return BatteryOptimizationResult.failure('المدير محذوف');
    }
    
    _logger.info(message: '[SettingsServicesManager] تحسين إعدادات البطارية');
    
    try {
      final status = await _permissionService.requestPermission(
        AppPermissionType.batteryOptimization,
      );
      
      final isOptimized = status == AppPermissionStatus.granted;
      
      // تحديث الإعدادات
      final newSettings = _currentSettings.copyWith(
        batteryOptimizationDisabled: isOptimized,
      );
      await saveSettings(newSettings);
      
      // تحديث إعدادات البطارية في NotificationManager
      if (isOptimized) {
        try {
          await _notificationManager.setMinBatteryLevel(0);
        } catch (e) {
          _logger.warning(
            message: '[SettingsServicesManager] فشل في تحديث إعدادات البطارية في NotificationManager',
            data: {'error': e.toString()},
          );
        }
      }
      
      _logger.info(
        message: '[SettingsServicesManager] نتيجة تحسين البطارية',
        data: {'optimized': isOptimized},
      );
      
      return BatteryOptimizationResult.success(isOptimized);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل تحسين إعدادات البطارية',
        error: e,
      );
      
      return BatteryOptimizationResult.failure(e.toString());
    }
  }
  
  /// مسح الكاش والبيانات المؤقتة
  Future<CacheClearResult> clearApplicationCache() async {
    if (_isDisposed) {
      return CacheClearResult.failure('المدير محذوف');
    }
    
    _logger.info(message: '[SettingsServicesManager] مسح الكاش');
    
    try {
      // مسح كاش الأذونات
      _permissionService.clearPermissionCache();
      
      // مسح البيانات المؤقتة الأخرى
      // يمكن إضافة المزيد من عمليات المسح هنا
      
      _logger.info(message: '[SettingsServicesManager] تم مسح الكاش بنجاح');
      _logger.logEvent('cache_cleared');
      
      return CacheClearResult.success();
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل مسح الكاش',
        error: e,
      );
      
      return CacheClearResult.failure(e.toString());
    }
  }
  
  // ==================== إدارة الإعدادات والتنقل ====================
  
  /// فتح إعدادات التطبيق
  Future<bool> openAppSettings([AppSettingsType? settingsPage]) async {
    _logger.info(
      message: '[SettingsServicesManager] فتح إعدادات التطبيق',
      data: {'settingsPage': settingsPage?.toString() ?? 'app'}
    );
    
    try {
      return await _permissionService.openAppSettings(settingsPage);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل فتح إعدادات التطبيق',
        error: e,
      );
      return false;
    }
  }
  
  /// التحقق من إمكانية إظهار تفسير الإذن
  Future<bool> shouldShowPermissionRationale(AppPermissionType permission) async {
    try {
      return await _permissionService.shouldShowPermissionRationale(permission);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل في فحص permission rationale',
        error: e,
      );
      return false;
    }
  }
  
  /// التحقق من رفض الإذن نهائياً
  Future<bool> isPermissionPermanentlyDenied(AppPermissionType permission) async {
    try {
      return await _permissionService.isPermissionPermanentlyDenied(permission);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل في فحص الرفض النهائي للإذن',
        error: e,
      );
      return false;
    }
  }
  
  /// الحصول على وصف الإذن
  String getPermissionDescription(AppPermissionType permission) {
    try {
      return _permissionService.getPermissionDescription(permission);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل في الحصول على وصف الإذن',
        error: e,
      );
      return 'وصف غير متوفر';
    }
  }
  
  /// الحصول على اسم الإذن
  String getPermissionName(AppPermissionType permission) {
    try {
      return _permissionService.getPermissionName(permission);
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل في الحصول على اسم الإذن',
        error: e,
      );
      return 'اسم غير متوفر';
    }
  }
  
  // ==================== تحديث حالة الخدمات ====================
  
  Future<void> _updateServiceStatus() async {
    if (_isDisposed) return;
    
    try {
      _currentStatus = await _loadServiceStatus();
      
      // إشعار المستمعين إذا كان Controller متاح
      final controller = _serviceStatusController;
      if (controller != null && !controller.isClosed) {
        controller.add(_currentStatus);
      }
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل تحديث حالة الخدمات',
        error: e,
      );
    }
  }
  
  /// فرض تحديث حالة جميع الخدمات
  Future<void> refreshAllServices() async {
    if (_isDisposed) return;
    
    _logger.info(message: '[SettingsServicesManager] تحديث جميع الخدمات');
    
    try {
      await loadSettings();
      await _updateServiceStatus();
      
      _logger.info(message: '[SettingsServicesManager] تم تحديث جميع الخدمات بنجاح');
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل تحديث الخدمات',
        error: e,
      );
    }
  }
  
  // ==================== إحصائيات وتحليلات ====================
  
  /// الحصول على إحصائيات الإعدادات
  Future<SettingsStatistics> getStatistics() async {
    if (_isDisposed) {
      return SettingsStatistics.empty();
    }
    
    try {
      final permissionStats = await _permissionService.getPermissionStats();
      final lastSync = _storage.getString(_lastSyncKey);
      
      return SettingsStatistics(
        lastSyncTime: lastSync != null ? DateTime.tryParse(lastSync) : null,
        permissionStats: permissionStats,
        settingsVersion: _currentSettings.hashCode,
        serviceStatusHealthy: _isServiceStatusHealthy(),
      );
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل الحصول على الإحصائيات',
        error: e,
      );
      
      return SettingsStatistics.empty();
    }
  }
  
  bool _isServiceStatusHealthy() {
    try {
      return _currentStatus.permissions.values
          .where((status) => status == AppPermissionStatus.granted)
          .length >= 2; // على الأقل إذنين مطلوبين
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] فشل في فحص صحة الخدمات',
        error: e,
      );
      return false;
    }
  }
  
  // ==================== تنظيف الموارد ====================
  
  Future<void> dispose() async {
    if (_isDisposed) return;
    
    _logger.info(message: '[SettingsServicesManager] تنظيف الموارد');
    
    _isDisposed = true;
    
    try {
      // إلغاء الاشتراكات بأمان
      final permissionSub = _permissionSubscription;
      if (permissionSub != null) {
        await permissionSub.cancel();
        _permissionSubscription = null;
      }
      
      final batterySub = _batterySubscription;
      if (batterySub != null) {
        await batterySub.cancel();
        _batterySubscription = null;
      }
      
      // إغلاق Controllers بأمان
      final settingsController = _settingsController;
      if (settingsController != null && !settingsController.isClosed) {
        await settingsController.close();
      }
      _settingsController = null;
      
      final serviceStatusController = _serviceStatusController;
      if (serviceStatusController != null && !serviceStatusController.isClosed) {
        await serviceStatusController.close();
      }
      _serviceStatusController = null;
      
      _logger.info(message: '[SettingsServicesManager] تم تنظيف الموارد');
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في تنظيف الموارد',
        error: e,
      );
    }
  }
}

// ==================== Models للنتائج ====================

/// حالة الخدمات
class ServiceStatus {
  final Map<AppPermissionType, AppPermissionStatus> permissions;
  final BatteryState batteryState;
  final NotificationSettings notificationSettings;
  final bool locationAvailable;
  final ThemeMode themeMode;

  ServiceStatus({
    required this.permissions,
    required this.batteryState,
    required this.notificationSettings,
    required this.locationAvailable,
    required this.themeMode,
  });

  factory ServiceStatus.initial() => ServiceStatus(
    permissions: {},
    batteryState: BatteryState(level: 100, isCharging: false, isPowerSaveMode: false),
    notificationSettings: const NotificationSettings(),
    locationAvailable: false,
    themeMode: ThemeMode.light,
  );

  bool get isNotificationEnabled => permissions[AppPermissionType.notification] == AppPermissionStatus.granted;
  bool get isLocationEnabled => permissions[AppPermissionType.location] == AppPermissionStatus.granted;
  bool get isBatteryOptimized => permissions[AppPermissionType.batteryOptimization] == AppPermissionStatus.granted;
}

/// نتيجة تحميل الإعدادات
class SettingsLoadResult {
  final bool isSuccess;
  final AppSettings? settings;
  final ServiceStatus? serviceStatus;
  final String? error;

  SettingsLoadResult._({
    required this.isSuccess,
    this.settings,
    this.serviceStatus,
    this.error,
  });

  factory SettingsLoadResult.success(AppSettings settings, ServiceStatus status) => 
      SettingsLoadResult._(
        isSuccess: true,
        settings: settings,
        serviceStatus: status,
      );

  factory SettingsLoadResult.failure(String error) => 
      SettingsLoadResult._(
        isSuccess: false,
        error: error,
      );
}

/// نتيجة طلب الإذن
class PermissionRequestResult {
  final bool isSuccess;
  final AppPermissionStatus? status;
  final String? error;

  PermissionRequestResult._({
    required this.isSuccess,
    this.status,
    this.error,
  });

  factory PermissionRequestResult.success(AppPermissionStatus status) => 
      PermissionRequestResult._(isSuccess: true, status: status);

  factory PermissionRequestResult.failure(String error) => 
      PermissionRequestResult._(isSuccess: false, error: error);
}

/// نتيجة طلب أذونات متعددة
class BatchPermissionResult {
  final bool isSuccess;
  final Map<AppPermissionType, AppPermissionStatus> results;
  final List<AppPermissionType> deniedPermissions;
  final String? error;

  BatchPermissionResult._({
    required this.isSuccess,
    this.results = const {},
    this.deniedPermissions = const [],
    this.error,
  });

  factory BatchPermissionResult.fromPermissionBatchResult(PermissionBatchResult result) => 
      BatchPermissionResult._(
        isSuccess: !result.wasCancelled,
        results: result.results,
        deniedPermissions: result.deniedPermissions,
      );

  factory BatchPermissionResult.failure(String error) => 
      BatchPermissionResult._(isSuccess: false, error: error);
}

/// نتيجة تحديث الموقع
class LocationUpdateResult {
  final bool isSuccess;
  final dynamic location;
  final String? error;

  LocationUpdateResult._({
    required this.isSuccess,
    this.location,
    this.error,
  });

  factory LocationUpdateResult.success(dynamic location) => 
      LocationUpdateResult._(isSuccess: true, location: location);

  factory LocationUpdateResult.failure(String error) => 
      LocationUpdateResult._(isSuccess: false, error: error);
}

/// نتيجة تحسين البطارية
class BatteryOptimizationResult {
  final bool isSuccess;
  final bool isOptimized;
  final String? error;

  BatteryOptimizationResult._({
    required this.isSuccess,
    this.isOptimized = false,
    this.error,
  });

  factory BatteryOptimizationResult.success(bool isOptimized) => 
      BatteryOptimizationResult._(isSuccess: true, isOptimized: isOptimized);

  factory BatteryOptimizationResult.failure(String error) => 
      BatteryOptimizationResult._(isSuccess: false, error: error);
}

/// نتيجة مسح الكاش
class CacheClearResult {
  final bool isSuccess;
  final String? error;

  CacheClearResult._({
    required this.isSuccess,
    this.error,
  });

  factory CacheClearResult.success() => CacheClearResult._(isSuccess: true);

  factory CacheClearResult.failure(String error) => 
      CacheClearResult._(isSuccess: false, error: error);
}

/// إحصائيات الإعدادات
class SettingsStatistics {
  final DateTime? lastSyncTime;
  final PermissionStats permissionStats;
  final int settingsVersion;
  final bool serviceStatusHealthy;

  SettingsStatistics({
    this.lastSyncTime,
    required this.permissionStats,
    required this.settingsVersion,
    required this.serviceStatusHealthy,
  });

  factory SettingsStatistics.empty() => SettingsStatistics(
    permissionStats: PermissionStats(
      totalRequests: 0,
      grantedCount: 0,
      deniedCount: 0,
      acceptanceRate: 0,
    ),
    settingsVersion: 0,
    serviceStatusHealthy: false,
  );
}