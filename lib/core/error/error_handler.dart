// lib/core/error/error_handler.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'exceptions.dart';
import 'failure.dart';
import '../infrastructure/services/logging/logger_service.dart';

/// Generic error handler for the application
class AppErrorHandler {
  final LoggerService _logger;
  
  AppErrorHandler(this._logger);
  
  /// Handle any type of error with appropriate error handling
  Future<T?> handleError<T>(
    Future<T> Function() operation, {
    String? operationName,
    Function(Failure)? onError,
    T? defaultValue,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      final failure = _mapErrorToFailure(e, stackTrace);
      _logError(operationName ?? 'unknown_operation', e, stackTrace);
      
      if (onError != null) {
        onError(failure);
      }
      
      return defaultValue;
    }
  }
  
  /// Execute operation with result handling
  Future<Result<T>> executeOperation<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    try {
      final result = await operation();
      return Result.success(result);
    } catch (e, stackTrace) {
      final failure = _mapErrorToFailure(e, stackTrace);
      _logError(operationName ?? 'unknown_operation', e, stackTrace);
      return Result.failure(failure);
    }
  }
  
  /// Map exceptions to failures
  Failure _mapErrorToFailure(dynamic error, StackTrace? stackTrace) {
    if (error is SocketException || error is NetworkException) {
      return NetworkFailure(
        message: 'Unable to connect to the internet. Please check your connection.',
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is TimeoutException) {
      return NetworkFailure(
        message: 'The operation took too long. Please try again.',
        code: 'TIMEOUT',
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is DataLoadException) {
      return StorageFailure(
        message: 'Error loading data: ${error.message}',
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is DataUpdateException) {
      return StorageFailure(
        message: 'Error updating data: ${error.message}',
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is DataNotFoundException) {
      return StorageFailure(
        message: 'Requested data not found: ${error.message}',
        code: error.code ?? 'NOT_FOUND',
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is LocationException) {
      return ServiceFailure(
        message: 'Location service error: ${error.message}',
        serviceName: 'LocationService',
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is NotificationException) {
      return ServiceFailure(
        message: 'Notification service error: ${error.message}',
        serviceName: 'NotificationService',
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is StorageException) {
      return StorageFailure(
        message: 'Storage error: ${error.message}',
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is PermissionException) {
      return PermissionFailure(
        message: 'Permission error: ${error.message}',
        permissionType: error.code ?? 'unknown',
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is ValidationException) {
      return ValidationFailure(
        message: error.message,
        field: error.field ?? 'unknown',
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      );
    } else if (error is FormatException) {
      return ValidationFailure(
        message: 'Invalid format: ${error.message}',
        field: 'format',
        originalError: error,
        stackTrace: stackTrace,
      );
    }
    
    return UnknownFailure(
      message: 'An unexpected error occurred. Please try again.',
      originalError: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Get user-friendly error message
  String getUserFriendlyMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is StorageFailure) {
      return 'Unable to access data. Please try again.';
    } else if (failure is PermissionFailure) {
      return 'Permission required to continue.';
    } else if (failure is ServiceFailure) {
      return 'Service temporarily unavailable.';
    } else if (failure is ValidationFailure) {
      return failure.message;
    }
    
    return 'Something went wrong. Please try again.';
  }
  
  /// Log error details
  void _logError(String operation, dynamic error, StackTrace? stackTrace) {
    _logger.error(
      message: 'Error in operation: $operation',
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Show error snackbar
  static void showErrorSnackBar(
    BuildContext context, 
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: action ?? SnackBarAction(
          label: 'Dismiss',
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  
  /// Show error dialog
  static Future<bool> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? primaryButtonText,
    VoidCallback? onPrimaryAction,
    String? secondaryButtonText,
    VoidCallback? onSecondaryAction,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (secondaryButtonText != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
                onSecondaryAction?.call();
              },
              child: Text(secondaryButtonText),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
              onPrimaryAction?.call();
            },
            child: Text(primaryButtonText ?? 'OK'),
          ),
        ],
      ),
    ) ?? false;
  }
  
  /// Show retry dialog
  static Future<bool> showRetryDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onRetry,
    String retryText = 'Retry',
    String cancelText = 'Cancel',
  }) async {
    return await showErrorDialog(
      context,
      title: title,
      message: message,
      primaryButtonText: retryText,
      onPrimaryAction: onRetry,
      secondaryButtonText: cancelText,
    );
  }
}

/// Result wrapper for operations
class Result<T> {
  final T? data;
  final Failure? failure;
  
  const Result._({this.data, this.failure});
  
  factory Result.success(T data) => Result._(data: data);
  factory Result.failure(Failure failure) => Result._(failure: failure);
  
  bool get isSuccess => data != null;
  bool get isFailure => failure != null;
  
  R fold<R>(
    R Function(Failure) onFailure,
    R Function(T) onSuccess,
  ) {
    if (failure != null) {
      return onFailure(failure!);
    } else if (data != null) {
      return onSuccess(data as T);
    } else {
      throw StateError('Result must have either data or failure');
    }
  }
}