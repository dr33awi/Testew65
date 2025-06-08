// lib/core/infrastructure/services/permissions/handlers/permission_handler_factory.dart

import '../permission_service.dart';
import 'permission_handler_base.dart';
import 'location_handler.dart';
import 'notification_handler.dart';
import 'storage_handler.dart';
import 'battery_handler.dart';
import 'do_not_disturb_handler.dart';

class PermissionHandlerFactory {
  static final Map<AppPermissionType, PermissionHandlerBase> _handlers = {
    AppPermissionType.location: LocationPermissionHandler(),
    AppPermissionType.notification: NotificationPermissionHandler(),
    AppPermissionType.storage: StoragePermissionHandler(),
    AppPermissionType.batteryOptimization: BatteryOptimizationHandler(),
    AppPermissionType.doNotDisturb: DoNotDisturbHandler(),
  };
  
  static PermissionHandlerBase? getHandler(AppPermissionType type) {
    return _handlers[type];
  }
  
  static List<PermissionHandlerBase> getAllHandlers() {
    return _handlers.values.toList();
  }
}