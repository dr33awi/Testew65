// lib/core/infrastructure/services/logging/logger_service.dart

/// Log levels for controlling logging verbosity
enum LogLevel {
  /// No logging
  none(0, 'NONE'),
  
  /// Error messages only
  error(1, 'ERROR'),
  
  /// Warning and error messages
  warning(2, 'WARN'),
  
  /// Informational, warning, and error messages
  info(3, 'INFO'),
  
  /// Debug, informational, warning, and error messages
  debug(4, 'DEBUG'),
  
  /// All messages including verbose/trace
  verbose(5, 'VERBOSE');
  
  final int value;
  final String label;
  
  const LogLevel(this.value, this.label);
  
  /// Check if this level should log for the given level
  bool shouldLog(LogLevel level) => value >= level.value;
  
  /// Get log level from string
  static LogLevel fromString(String level) {
    return LogLevel.values.firstWhere(
      (l) => l.label.toLowerCase() == level.toLowerCase(),
      orElse: () => LogLevel.info,
    );
  }
}

/// Log level configuration
class LogConfig {
  static LogLevel _currentLevel = LogLevel.info;
  
  /// Get current log level
  static LogLevel get currentLevel => _currentLevel;
  
  /// Set current log level
  static void setLevel(LogLevel level) {
    _currentLevel = level;
  }
  
  /// Check if should log for given level
  static bool shouldLog(LogLevel level) {
    return _currentLevel.shouldLog(level);
  }
}

/// ANSI color codes for terminal output
class LogColors {
  LogColors._();
  
  static const String reset = '\x1B[0m';
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
  
  /// Get color for log level
  static String getColor(LogLevel level) {
    switch (level) {
      case LogLevel.error:
        return red;
      case LogLevel.warning:
        return yellow;
      case LogLevel.info:
        return green;
      case LogLevel.debug:
        return blue;
      case LogLevel.verbose:
        return cyan;
      case LogLevel.none:
        return reset;
    }
  }
  
  /// Colorize text
  static String colorize(String text, LogLevel level) {
    return '${getColor(level)}$text$reset';
  }
}

/// Abstract logger service interface
/// Provides logging functionality across the application
abstract class LoggerService {
  /// Log debug information
  /// Used for detailed debugging information
  void debug({required String message, dynamic data});
  
  /// Log general information
  /// Used for general app flow information
  void info({required String message, dynamic data});
  
  /// Log warning messages
  /// Used for potentially harmful situations
  void warning({required String message, dynamic data});
  
  /// Log error messages
  /// Used for error events with optional stack trace
  void error({required String message, dynamic error, StackTrace? stackTrace});
  
  /// Log analytics event
  /// Used for tracking user actions and app events
  void logEvent(String eventName, {Map<String, dynamic>? parameters});
  
  /// Set user property for analytics
  void setUserProperty(String name, String value);
  
  /// Clear all logs (if applicable)
  Future<void> clearLogs();
}