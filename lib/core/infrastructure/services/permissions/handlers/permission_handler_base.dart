// lib/core/infrastructure/services/permissions/handlers/permission_handler_base.dart

import 'package:permission_handler/permission_handler.dart' as handler;
import '../permission_service.dart';

/// Base class for permission handlers
abstract class PermissionHandlerBase {
  /// Get the native permission type
  handler.Permission? get nativePermission;
  
  /// Get the app permission type
  AppPermissionType get permissionType;
  
  /// Check if permission is available on current platform
  bool get isAvailable;
  
  /// Request permission with custom logic
  Future<AppPermissionStatus> request();
  
  /// Check permission status with custom logic
  Future<AppPermissionStatus> check();
  
  /// Convert native status to app status
  AppPermissionStatus mapFromNativeStatus(handler.PermissionStatus status) {
    if (status.isGranted) return AppPermissionStatus.granted;
    if (status.isDenied) return AppPermissionStatus.denied;
    if (status.isPermanentlyDenied) return AppPermissionStatus.permanentlyDenied;
    if (status.isRestricted) return AppPermissionStatus.restricted;
    if (status.isLimited) return AppPermissionStatus.limited;
    if (status.isProvisional) return AppPermissionStatus.provisional;
    return AppPermissionStatus.unknown;
  }
}