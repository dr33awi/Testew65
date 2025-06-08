// lib/core/infrastructure/services/permissions/handlers/storage_handler.dart

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import '../permission_service.dart';
import 'permission_handler_base.dart';

class StoragePermissionHandler extends PermissionHandlerBase {
  @override
  handler.Permission? get nativePermission {
    if (Platform.isAndroid) return handler.Permission.storage;
    if (Platform.isIOS) return handler.Permission.photos;
    return null;
  }
  
  @override
  AppPermissionType get permissionType => AppPermissionType.storage;
  
  @override
  bool get isAvailable => true;
  
  @override
  Future<AppPermissionStatus> request() async {
    if (Platform.isAndroid) {
      // Android 13+ doesn't need storage permission
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return AppPermissionStatus.granted;
      }
    }
    
    final status = await nativePermission!.request();
    return mapFromNativeStatus(status);
  }
  
  @override
  Future<AppPermissionStatus> check() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return AppPermissionStatus.granted;
      }
    }
    
    final status = await nativePermission!.status;
    return mapFromNativeStatus(status);
  }
}