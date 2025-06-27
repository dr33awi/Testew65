// lib/app/themes/core/theme_notifier.dart
import 'package:flutter/material.dart';
import 'package:athkar_app/core/infrastructure/services/storage/storage_service.dart';

/// مدير حالة الثيم
class ThemeNotifier extends ChangeNotifier {
  final StorageService _storage;
  
  static const String _themeKey = 'app_theme_mode';
  static const String _languageKey = 'app_language';
  
  bool _isDarkMode = false;
  String _language = 'ar';
  
  ThemeNotifier(this._storage) {
    _loadThemeSettings();
  }
  
  // ========== Getters ==========
  
  bool get isDarkMode => _isDarkMode;
  bool get isLightMode => !_isDarkMode;
  String get language => _language;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  
  // ========== Theme Management ==========
  
  /// تحميل إعدادات الثيم المحفوظة
  Future<void> _loadThemeSettings() async {
    try {
      _isDarkMode = _storage.getBool(_themeKey) ?? false;
      _language = _storage.getString(_languageKey) ?? 'ar';
      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في تحميل إعدادات الثيم: $e');
    }
  }
  
  /// تبديل الثيم بين الفاتح والداكن
  Future<void> toggleTheme() async {
    try {
      _isDarkMode = !_isDarkMode;
      await _storage.setBool(_themeKey, _isDarkMode);
      notifyListeners();
      
      debugPrint('تم تغيير الثيم إلى: ${_isDarkMode ? "داكن" : "فاتح"}');
    } catch (e) {
      debugPrint('خطأ في تبديل الثيم: $e');
      // الإرجاع للحالة السابقة في حالة الخطأ
      _isDarkMode = !_isDarkMode;
    }
  }
  
  /// تعيين الثيم مباشرة
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final isDark = mode == ThemeMode.dark;
      if (_isDarkMode != isDark) {
        _isDarkMode = isDark;
        await _storage.setBool(_themeKey, _isDarkMode);
        notifyListeners();
        
        debugPrint('تم تعيين الثيم إلى: ${_isDarkMode ? "داكن" : "فاتح"}');
      }
    } catch (e) {
      debugPrint('خطأ في تعيين الثيم: $e');
    }
  }
  
  /// تعيين الثيم الفاتح
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }
  
  /// تعيين الثيم الداكن
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }
  
  // ========== Language Management ==========
  
  /// تغيير اللغة
  Future<void> setLanguage(String newLanguage) async {
    try {
      if (['ar', 'en'].contains(newLanguage) && _language != newLanguage) {
        _language = newLanguage;
        await _storage.setString(_languageKey, _language);
        notifyListeners();
        
        debugPrint('تم تغيير اللغة إلى: $newLanguage');
      }
    } catch (e) {
      debugPrint('خطأ في تغيير اللغة: $e');
    }
  }
  
  /// تبديل اللغة بين العربية والإنجليزية
  Future<void> toggleLanguage() async {
    final newLanguage = _language == 'ar' ? 'en' : 'ar';
    await setLanguage(newLanguage);
  }
  
  // ========== Utility Methods ==========
  
  /// إعادة تعيين الإعدادات للافتراضي
  Future<void> resetToDefaults() async {
    try {
      _isDarkMode = false;
      _language = 'ar';
      
      await _storage.setBool(_themeKey, _isDarkMode);
      await _storage.setString(_languageKey, _language);
      
      notifyListeners();
      debugPrint('تم إعادة تعيين إعدادات الثيم للافتراضي');
    } catch (e) {
      debugPrint('خطأ في إعادة تعيين الإعدادات: $e');
    }
  }
  
  /// تطبيق ثيم تلقائي حسب وقت اليوم
  Future<void> setAutoTheme() async {
    final hour = DateTime.now().hour;
    final shouldBeDark = hour < 6 || hour >= 18; // داكن من 6 مساءً إلى 6 صباحاً
    
    if (_isDarkMode != shouldBeDark) {
      await setThemeMode(shouldBeDark ? ThemeMode.dark : ThemeMode.light);
    }
  }
  
  /// التحقق من إمكانية تطبيق الثيم التلقائي
  bool get canApplyAutoTheme {
    final hour = DateTime.now().hour;
    final shouldBeDark = hour < 6 || hour >= 18;
    return _isDarkMode != shouldBeDark;
  }
  
  // ========== Disposal ==========
  
  @override
  void dispose() {
    debugPrint('ThemeNotifier disposed');
    super.dispose();
  }
}