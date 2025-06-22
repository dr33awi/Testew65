// lib/features/settings/services/settings_services_manager.dart (مُنظف)

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
  
  // Controllers للحالة
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
  
  AppSettings get currentSettings => _currentSettings;
  ServiceStatus get currentStatus => _currentStatus;
  PermissionService get permissionService => _permissionService;
  BatteryService get batteryService => _batteryService;
  NotificationManager get notificationManager => _notificationManager;
  
  Stream<AppSettings> get settingsStream {
    try {
      _ensureControllersInitialized();
      final controller = _settingsController;
      if (controller != null && !controller.isClosed) {
        return controller.stream;
      } else {
        _logger.error(message: '[SettingsServicesManager] فشل في إنشاء settings controller');
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
  
  Stream<ServiceStatus> get serviceStatusStream {
    try {
      _ensureControllersInitialized();
      final controller = _serviceStatusController;
      if (controller != null && !controller.isClosed) {
        return controller.stream;
      } else {
        _logger.error(message: '[SettingsServicesManager] فشل في إنشاء service status controller');
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
  
  // ==================== تهيئة Controllers ====================
  
  void _ensureControllersInitialized() {
    if (_isDisposed) {
      _logger.warning(message: '[SettingsServicesManager] محاولة استخدام مدير محذوف');
      return;
    }
    
    try {
      final currentSettingsController = _settingsController;
      if (currentSettingsController == null || currentSettingsController.isClosed) {
        _logger.debug(message: '[SettingsServicesManager] إنشاء settings controller جديد');
        
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
        
        Future.microtask(() {
          final controller = _settingsController;
          if (controller != null && !controller.isClosed) {
            controller.add(_currentSettings);
          }
        });
      }
      
      final currentServiceController = _serviceStatusController;
      if (currentServiceController == null || currentServiceController.isClosed) {
        _logger.debug(message: '[SettingsServicesManager] إنشاء service status controller جديد');
        
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
      _ensureControllersInitialized();
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
      _permissionSubscription?.cancel();
      _batterySubscription?.cancel();
      
      _permissionSubscription = _permissionService.permissionChanges.listen(
        _handlePermissionChange,
        onError: (error) {
          _logger.error(
            message: '[SettingsServicesManager] خطأ في stream الأذونات',
            error: error,
          );
        },
        cancelOnError: false,
      );
      
      _batterySubscription = _batteryService.getBatteryStateStream().listen(
        _handleBatteryChange,
        onError: (error) {
          _logger.error(
            message: '[SettingsServicesManager] خطأ في stream البطارية',
            error: error,
          );
        },
        cancelOnError: false,
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
      _updateServiceStatus();
    } catch (e) {
      _logger.error(
        message: '[SettingsServicesManager] خطأ في معالجة تغيير البطارية',
        error: e,
      );
    }
  }
  
  // ==================== تحميل وحفظ الإعدادات ====================
  
  Future<SettingsLoadResult> loadSettings() async {
    if (_isDisposed) {
      return SettingsLoadResult.failure('المدير محذوف');
    }
    
    _logger.info(message: '[SettingsServicesManager] بدء تحميل الإعدادات');
    
    try {
      _ensureControllersInitialized();
      
      final savedSettings = await _loadSavedSettings();
      final serviceStatus = await _loadServiceStatus();
      final mergedSettings = await _mergeSettingsWithServices(savedSettings);
      
      _currentSettings = mergedSettings;
      _currentStatus = serviceStatus;
      
      _notifyListeners();
      
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
  
  void _notifyListeners() {
    if (_isDisposed) return;
    
    try {
      final settingsController = _settingsController;
      if (settingsController != null && !settingsController.isClosed) {
        settingsController.add(_currentSettings);
      }
      
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
  
  Future<bool> saveSettings(AppSettings settings) async {
    if (_isDisposed) return false;
    
    _logger.info(
      message: '[SettingsServicesManager] حفظ الإعدادات',
      data: settings.toJson(),
    );
    
    try {
      final saved = await _storage.setObject(_settingsKey, settings, (s) => s.toJson());
      if (!saved) {
        _logger.warning(message: '[SettingsServicesManager] فشل في حفظ الإعدادات في التخزين');
        return false;
      }
      
      await _applySettingsToServices(settings);
      
      _currentSettings = settings;
      _notifyListeners();
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
      if (settings.isDarkMode != _themeNotifier.isDarkMode) {
        await _themeNotifier.setTheme(settings.isDarkMode);
      }
      
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
  
  Future<LocationUpdateResult> updatePrayerLocation() async {
    if (_isDisposed) {
      return LocationUpdateResult.failure('المدير محذوف');
    }
    
    _logger.info(message: '[SettingsServicesManager] تحديث موقع الصلاة');
    
    try {
      final location = await _prayerService.getCurrentLocation();
      await _prayerService.updatePrayerTimes();
      
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
      
      final newSettings = _currentSettings.copyWith(
        batteryOptimizationDisabled: isOptimized,
      );
      await saveSettings(newSettings);
      
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
  

  
  // ==================== إدارة الإعدادات والتنقل ====================
  
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
  
  // ==================== تحديث حالة الخدمات ====================
  
  Future<void> _updateServiceStatus() async {
    if (_isDisposed) return;
    
    try {
      _currentStatus = await _loadServiceStatus();
      
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
  

  
  // ==================== تنظيف الموارد ====================
  
  Future<void> dispose() async {
    if (_isDisposed) return;
    
    _logger.info(message: '[SettingsServicesManager] تنظيف الموارد');
    
    _isDisposed = true;
    
    try {
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