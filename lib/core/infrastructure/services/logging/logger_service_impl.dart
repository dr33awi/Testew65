// lib/core/infrastructure/services/logging/logger_service_impl.dart

import 'package:flutter/foundation.dart';
import 'logger_service.dart';

/// Implementation of LoggerService
/// Uses print statements in debug mode and can be extended for production logging
class LoggerServiceImpl implements LoggerService {
  static const String _tag = 'AthkarApp';
  
  // ANSI color codes for terminal
  static const String _resetColor = '\x1B[0m';
  static const String _debugColor = '\x1B[34m'; // Blue
  static const String _infoColor = '\x1B[32m';  // Green
  static const String _warningColor = '\x1B[33m'; // Yellow
  static const String _errorColor = '\x1B[31m'; // Red
  
  @override
  void debug({required String message, dynamic data}) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      print('$_debugColor[$_tag] $timestamp 📘 DEBUG: $message$_resetColor');
      if (data != null) {
        print('$_debugColor   └─ Data: $data$_resetColor');
      }
    }
  }

  @override
  void info({required String message, dynamic data}) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      print('$_infoColor[$_tag] $timestamp 📗 INFO: $message$_resetColor');
      if (data != null) {
        print('$_infoColor   └─ Data: $data$_resetColor');
      }
    }
  }

  @override
  void warning({required String message, dynamic data}) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      print('$_warningColor[$_tag] $timestamp 📙 WARNING: $message$_resetColor');
      if (data != null) {
        print('$_warningColor   └─ Data: $data$_resetColor');
      }
    }
    
    // In production, you might want to send warnings to a crash reporting service
    _logToProduction('warning', message, data);
  }

  @override
  void error({required String message, dynamic error, StackTrace? stackTrace}) {
    final timestamp = _getTimestamp();
    
    if (kDebugMode) {
      print('$_errorColor[$_tag] $timestamp 📕 ERROR: $message$_resetColor');
      print('$_errorColor   ├─ Error: $error$_resetColor');
      if (stackTrace != null) {
        print('$_errorColor   └─ StackTrace: $stackTrace$_resetColor');
      }
    }
    
    // Always log errors to production service
    _logErrorToProduction(message, error, stackTrace);
  }
  
  @override
  void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      print('$_infoColor[$_tag] $timestamp 📊 EVENT: $eventName$_resetColor');
      if (parameters != null && parameters.isNotEmpty) {
        print('$_infoColor   └─ Parameters: $parameters$_resetColor');
      }
    }
    
    // Send to analytics service in production
    _logEventToAnalytics(eventName, parameters);
  }
  
  @override
  void setUserProperty(String name, String value) {
    if (kDebugMode) {
      print('$_infoColor[$_tag] 👤 USER_PROPERTY: $name = $value$_resetColor');
    }
    
    // Set user property in analytics service
    _setAnalyticsUserProperty(name, value);
  }
  
  @override
  Future<void> clearLogs() async {
    if (kDebugMode) {
      print('$_infoColor[$_tag] 🗑️ Logs cleared$_resetColor');
    }
    
    // Clear any persisted logs if applicable
    await _clearPersistedLogs();
  }
  
  /// Get formatted timestamp
  String _getTimestamp() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
           '${now.minute.toString().padLeft(2, '0')}:'
           '${now.second.toString().padLeft(2, '0')}';
  }
  
  /// Log to production service (e.g., Sentry, Crashlytics)
  void _logToProduction(String level, String message, dynamic data) {
    if (kDebugMode) return;

    // Replace the following with calls to a real production logging service
    print('[$_tag][$level] $message');
    if (data != null) {
      print('[$_tag][$level] Data: $data');
    }
  }
  
  /// Log error to production crash reporting service
  void _logErrorToProduction(String message, dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) return;

    // Replace the following with calls to a crash reporting service
    print('[$_tag] ERROR: $message');
    print('[$_tag]   ├─ Error: $error');
    if (stackTrace != null) {
      print('[$_tag]   └─ StackTrace: $stackTrace');
    }
  }
  
  /// Log event to analytics service
  void _logEventToAnalytics(String eventName, Map<String, dynamic>? parameters) {
    if (kDebugMode) return;

    // Replace the following with calls to an analytics service
    print('[$_tag] EVENT: $eventName');
    if (parameters != null && parameters.isNotEmpty) {
      print('[$_tag]   Parameters: $parameters');
    }
  }
  
  /// Set user property in analytics service
  void _setAnalyticsUserProperty(String name, String value) {
    if (kDebugMode) return;

    // Replace the following with calls to an analytics service
    print('[$_tag] USER_PROPERTY: $name = $value');
  }
  
  /// Clear persisted logs
  Future<void> _clearPersistedLogs() async {
    if (kDebugMode) return;

    // Clear logs from persistence layer if implemented
  }
}