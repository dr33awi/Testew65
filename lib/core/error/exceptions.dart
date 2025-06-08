// lib/core/error/exceptions.dart

/// استثناء أساسي للتطبيق
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// استثناءات البيانات
class DataLoadException extends AppException {
  DataLoadException(super.message, {super.code});
}

class DataUpdateException extends AppException {
  DataUpdateException(super.message, {super.code});
}

class DataNotFoundException extends AppException {
  DataNotFoundException(super.message, {super.code});
}

/// استثناءات الشبكة
class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}

/// استثناءات الخدمات
class LocationException extends AppException {
  LocationException(super.message, {super.code});
}

class NotificationException extends AppException {
  NotificationException(super.message, {super.code});
}

class StorageException extends AppException {
  StorageException(super.message, {super.code});
}

class PermissionException extends AppException {
  PermissionException(super.message, {super.code});
}

/// استثناءات التحقق
class ValidationException extends AppException {
  final String? field;
  
  ValidationException(super.message, {this.field, super.code});
}