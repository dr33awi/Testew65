// lib/core/infrastructure/services/permissions/handlers/location_handler.dart

import 'package:permission_handler/permission_handler.dart' as handler;
import '../permission_service.dart';
import 'permission_handler_base.dart';

class LocationPermissionHandler extends PermissionHandlerBase {
  @override
  handler.Permission? get nativePermission => handler.Permission.locationWhenInUse;
  
  @override
  AppPermissionType get permissionType => AppPermissionType.location;
  
  @override
  bool get isAvailable => true;
  
  @override
  Future<AppPermissionStatus> request() async {
    // Check if location services are enabled
    final serviceStatus = await handler.Permission.location.serviceStatus;
    if (!serviceStatus.isEnabled) {
      // Location services are disabled
      return AppPermissionStatus.denied;
    }
    
    final status = await nativePermission!.request();
    return mapFromNativeStatus(status);
  }
  
  @override
  Future<AppPermissionStatus> check() async {
    final status = await nativePermission!.status;
    return mapFromNativeStatus(status);
  }
}