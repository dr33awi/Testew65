// lib/core/theme/theme_notifier.dart
import 'package:flutter/material.dart';
import 'package:athkar_app/core/infrastructure/services/storage/storage_service.dart';
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  final StorageService _storage;
  
  ThemeNotifier(this._storage) : super(ThemeMode.system) {
    _loadTheme();
  }
  
  void _loadTheme() {
    final isDark = _storage.getBool('theme_mode') ?? false;
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
  
  Future<void> toggleTheme() async {
    final isDark = value == ThemeMode.dark;
    value = isDark ? ThemeMode.light : ThemeMode.dark;
    await _storage.setBool('theme_mode', !isDark);
  }
  
  Future<void> setTheme(bool isDark) async {
    value = isDark ? ThemeMode.dark : ThemeMode.light;
    await _storage.setBool('theme_mode', isDark);
  }
  
  bool get isDarkMode => value == ThemeMode.dark;
}