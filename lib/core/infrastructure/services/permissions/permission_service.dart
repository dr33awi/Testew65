// lib/core/infrastructure/services/permissions/permission_service.dart

import 'dart:async';


/// أنواع الأذونات المطلوبة لتطبيق الأذكار
enum AppPermissionType {
  location,           // لحساب أوقات الصلاة
  notification,       // للتذكيرات
  doNotDisturb,      // لتخصيص أوقات التذكير
  batteryOptimization, // لضمان عمل التطبيق
  storage,           // لحفظ وتصدير الأذكار
  unknown,
}

/// حالة الإذن
enum AppPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
  provisional,
  unknown,
}

/// أنواع صفحات الإعدادات
enum AppSettingsType {
  app,
  location,
  notification,
  battery,
  accessibility,
  storage,
}

/// نتيجة طلب أذونات متعددة
class PermissionBatchResult {
  final Map<AppPermissionType, AppPermissionStatus> results;
  final bool allGranted;
  final List<AppPermissionType> deniedPermissions;
  final bool wasCancelled;

  PermissionBatchResult({
    required this.results,
    required this.allGranted,
    required this.deniedPermissions,
    this.wasCancelled = false,
  });

  factory PermissionBatchResult.cancelled() => PermissionBatchResult(
    results: {},
    allGranted: false,
    deniedPermissions: [],
    wasCancelled: true,
  );
}

/// معلومات تقدم طلب الأذونات
class PermissionProgress {
  final int current;
  final int total;
  final AppPermissionType currentPermission;

  PermissionProgress({
    required this.current,
    required this.total,
    required this.currentPermission,
  });

  double get percentage => (current / total) * 100;
}

/// إحصائيات الأذونات
class PermissionStats {
  final int totalRequests;
  final int grantedCount;
  final int deniedCount;
  final double acceptanceRate;
  final String? mostDeniedPermission;

  PermissionStats({
    required this.totalRequests,
    required this.grantedCount,
    required this.deniedCount,
    required this.acceptanceRate,
    this.mostDeniedPermission,
  });
}

/// واجهة خدمة الأذونات الموحدة
abstract class PermissionService {
  // الطلبات الأساسية
  Future<AppPermissionStatus> requestPermission(AppPermissionType permission);
  Future<PermissionBatchResult> requestMultiplePermissions({
    required List<AppPermissionType> permissions,
    Function(PermissionProgress)? onProgress,
    bool showExplanationDialog = true,
  });
  
  // فحص الحالة
  Future<AppPermissionStatus> checkPermissionStatus(AppPermissionType permission);
  Future<Map<AppPermissionType, AppPermissionStatus>> checkAllPermissions();
  
  // الإعدادات
  Future<bool> openAppSettings([AppSettingsType? settingsPage]);
  Future<bool> shouldShowPermissionRationale(AppPermissionType permission);
  Future<bool> isPermissionPermanentlyDenied(AppPermissionType permission);
  
  // المساعدات
  String getPermissionDescription(AppPermissionType permission);
  String getPermissionName(AppPermissionType permission);
  String getPermissionIcon(AppPermissionType permission);
  bool isPermissionAvailable(AppPermissionType permission);
  
  // Stream للاستماع لتغييرات الأذونات
  Stream<PermissionChange> get permissionChanges;
  
  // Analytics
  Future<PermissionStats> getPermissionStats();
  
  // Cache
  void clearPermissionCache();
  
  // تنظيف الموارد
  Future<void> dispose();
}

/// تغيير في حالة الإذن
class PermissionChange {
  final AppPermissionType permission;
  final AppPermissionStatus oldStatus;
  final AppPermissionStatus newStatus;
  final DateTime timestamp;

  PermissionChange({
    required this.permission,
    required this.oldStatus,
    required this.newStatus,
    required this.timestamp,
  });
}