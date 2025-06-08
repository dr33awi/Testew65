// lib/core/error/failure.dart

abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Storage-related failures
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Permission-related failures
class PermissionFailure extends Failure {
  final String permissionType;
  
  const PermissionFailure({
    required super.message,
    required this.permissionType,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Service-related failures
class ServiceFailure extends Failure {
  final String serviceName;
  
  const ServiceFailure({
    required super.message,
    required this.serviceName,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Validation failures
class ValidationFailure extends Failure {
  final String field;
  
  const ValidationFailure({
    required super.message,
    required this.field,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Unknown failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'حدث خطأ غير متوقع',
    super.code,
    super.originalError,
    super.stackTrace,
  });
}