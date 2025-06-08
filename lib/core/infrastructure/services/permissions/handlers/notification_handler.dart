// lib/core/infrastructure/services/permissions/handlers/notification_handler.dart

import 'package:permission_handler/permission_handler.dart' as handler;
import '../permission_service.dart';
import 'permission_handler_base.dart';

class NotificationPermissionHandler extends PermissionHandlerBase {
  @override
  handler.Permission? get nativePermission => handler.Permission.notification;
  
  @override
  AppPermissionType get permissionType => AppPermissionType.notification;
  
  @override
  bool get isAvailable => true;
  
  @override
  Future<AppPermissionStatus> request() async {
    final status = await nativePermission!.request();
    return mapFromNativeStatus(status);
  }
  
  @override
  Future<AppPermissionStatus> check() async {
    final status = await nativePermission!.status;
    return mapFromNativeStatus(status);
  }
}