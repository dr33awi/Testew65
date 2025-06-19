// lib/app/themes/core/theme_notifier.dart
import 'package:flutter/material.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';

/// مدير الثيم للتطبيق
class ThemeNotifier extends ChangeNotifier {
  final StorageService _storage;
  
  static const String _themeKey = 'app_theme_mode';
  static const String _languageKey = 'app_language';
  
  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'ar';
  
  ThemeNotifier(this._storage) {
    _loadThemeSettings();
  }

  /// الثيم الحالي
  ThemeMode get themeMode => _themeMode;
  
  /// اللغة الحالية
  String get language => _language;
  
  /// هل الثيم داكن؟
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  /// هل الثيم فاتح؟
  bool get isLightMode => _themeMode == ThemeMode.light;
  
  /// هل الثيم يتبع النظام؟
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// تحديد الثيم
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _storage.setString(_themeKey, mode.name);
      notifyListeners();
    }
  }

  /// تبديل الثيم بين فاتح وداكن
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// تحديد اللغة
  Future<void> setLanguage(String languageCode) async {
    if (_language != languageCode) {
      _language = languageCode;
      await _storage.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }

  /// تحميل إعدادات الثيم من التخزين
  Future<void> _loadThemeSettings() async {
    try {
      // تحميل الثيم
      final themeString = _storage.getString(_themeKey);
      if (themeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.name == themeString,
          orElse: () => ThemeMode.system,
        );
      }

      // تحميل اللغة
      final language = _storage.getString(_languageKey);
      if (language != null) {
        _language = language;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في تحميل إعدادات الثيم: $e');
    }
  }

  /// إعادة تعيين الإعدادات للافتراضية
  Future<void> resetToDefaults() async {
    await setThemeMode(ThemeMode.system);
    await setLanguage('ar');
  }

  /// تنظيف الموارد
  @override
  void dispose() {
    super.dispose();
  }
}