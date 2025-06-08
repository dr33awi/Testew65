// lib/core/infrastructure/services/storage/storage_service.dart

/// Abstract storage service interface
/// Provides local storage functionality for the application
abstract class StorageService {
  /// Save string value
  Future<bool> setString(String key, String value);
  
  /// Get string value
  String? getString(String key);
  
  /// Save boolean value
  Future<bool> setBool(String key, bool value);
  
  /// Get boolean value
  bool? getBool(String key);
  
  /// Save integer value
  Future<bool> setInt(String key, int value);
  
  /// Get integer value
  int? getInt(String key);
  
  /// Save double value
  Future<bool> setDouble(String key, double value);
  
  /// Get double value
  double? getDouble(String key);
  
  /// Save string list
  Future<bool> setStringList(String key, List<String> value);
  
  /// Get string list
  List<String>? getStringList(String key);
  
  /// Save map data
  Future<bool> setMap(String key, Map<String, dynamic> value);
  
  /// Get map data
  Map<String, dynamic>? getMap(String key);
  
  /// Save object as JSON
  Future<bool> setObject<T>(String key, T object, Map<String, dynamic> Function(T) toJson);
  
  /// Get object from JSON
  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson);
  
  /// Remove specific key
  Future<bool> remove(String key);
  
  /// Clear all storage
  Future<bool> clear();
  
  /// Check if key exists
  bool containsKey(String key);
  
  /// Get all keys
  Set<String> getKeys();
  
  /// Get storage size (if available)
  Future<int> getStorageSize();
  
  /// Reload storage (refresh from disk)
  Future<void> reload();
}