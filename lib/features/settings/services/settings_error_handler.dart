// lib/features/settings/services/settings_error_handler.dart (مُنظف)

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