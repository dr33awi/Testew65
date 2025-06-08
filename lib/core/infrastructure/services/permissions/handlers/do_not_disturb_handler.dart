// lib/core/infrastructure/services/permissions/handlers/do_not_disturb_handler.dart

import 'dart:io';
import 'package:permission_handler/permission_handler.dart' as handler;
import '../permission_service.dart';
import 'permission_handler_base.dart';

class DoNotDisturbHandler extends PermissionHandlerBase {
  @override
  handler.Permission? get nativePermission => 
      Platform.isAndroid ? handler.Permission.accessNotificationPolicy : null;
  
  @override
  AppPermissionType get permissionType => AppPermissionType.doNotDisturb;
  
  @override
  bool get isAvailable => Platform.isAndroid;
  
  @override
  Future<AppPermissionStatus> request() async {
    if (!isAvailable) return AppPermissionStatus.unknown;
    
    final status = await nativePermission!.request();
    return mapFromNativeStatus(status);
  }
  
  @override
  Future<AppPermissionStatus> check() async {
    if (!isAvailable) return AppPermissionStatus.unknown;
    
    final status = await nativePermission!.status;
    return mapFromNativeStatus(status);
  }
}