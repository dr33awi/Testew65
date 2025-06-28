// lib/app/themes/core/theme_notifier.dart (محسن)
import 'package:flutter/material.dart';
import 'package:athkar_app/core/infrastructure/services/storage/storage_service.dart';

/// مدير حالة الثيم الإسلامي المحسن
class ThemeNotifier extends ChangeNotifier {
  final StorageService _storage;
  
  static const String _themeKey = 'app_theme_mode';
  static const String _languageKey = 'app_language';
  static const String _autoThemeKey = 'app_auto_theme';    // جديد
  static const String _prayerThemeKey = 'app_prayer_theme'; // جديد
  
  bool _isDarkMode = false;
  String _language = 'ar';
  bool _autoThemeEnabled = false;        // جديد - ثيم تلقائي
  bool _prayerBasedTheme = false;        // جديد - ثيم حسب الصلاة
  String _currentPrayer = 'general';     // جديد - الصلاة الحالية
  
  ThemeNotifier(this._storage) {
    _loadThemeSettings();
    _setupAutoTheme(); // جديد
  }
  
  // ========== Getters المحسنة ==========
  
  bool get isDarkMode => _isDarkMode;
  bool get isLightMode => !_isDarkMode;
  String get language => _language;
  bool get autoThemeEnabled => _autoThemeEnabled;        // جديد
  bool get prayerBasedTheme => _prayerBasedTheme;        // جديد
  String get currentPrayer => _currentPrayer;           // جديد
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  
  // ========== إدارة الثيم المحسنة ==========
  
  /// تحميل إعدادات الثيم المحفوظة (محسن)
  Future<void> _loadThemeSettings() async {
    try {
      _isDarkMode = _storage.getBool(_themeKey) ?? false;
      _language = _storage.getString(_languageKey) ?? 'ar';
      _autoThemeEnabled = _storage.getBool(_autoThemeKey) ?? false;     // جديد
      _prayerBasedTheme = _storage.getBool(_prayerThemeKey) ?? false;   // جديد
      
      // تطبيق الثيم التلقائي إذا كان مفعلاً
      if (_autoThemeEnabled) {
        _applyAutoTheme(notify: false);
      }
      
      notifyListeners();
      debugPrint('ThemeNotifier: تم تحميل الإعدادات - داكن: $_isDarkMode، لغة: $_language، تلقائي: $_autoThemeEnabled');
    } catch (e) {
      debugPrint('خطأ في تحميل إعدادات الثيم: $e');
    }
  }
  
  /// تبديل الثيم بين الفاتح والداكن (محسن)
  Future<void> toggleTheme() async {
    try {
      // إيقاف الثيم التلقائي عند التبديل اليدوي
      if (_autoThemeEnabled) {
        await setAutoTheme(false);
      }
      
      _isDarkMode = !_isDarkMode;
      await _storage.setBool(_themeKey, _isDarkMode);
      notifyListeners();
      
      debugPrint('ThemeNotifier: تم تغيير الثيم إلى: ${_isDarkMode ? "داكن" : "فاتح"}');
    } catch (e) {
      debugPrint('خطأ في تبديل الثيم: $e');
      // الإرجاع للحالة السابقة في حالة الخطأ
      _isDarkMode = !_isDarkMode;
    }
  }
  
  /// تعيين الثيم مباشرة (محسن)
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      final isDark = mode == ThemeMode.dark;
      if (_isDarkMode != isDark) {
        // إيقاف الثيم التلقائي عند التعيين اليدوي
        if (_autoThemeEnabled) {
          await setAutoTheme(false);
        }
        
        _isDarkMode = isDark;
        await _storage.setBool(_themeKey, _isDarkMode);
        notifyListeners();
        
        debugPrint('ThemeNotifier: تم تعيين الثيم إلى: ${_isDarkMode ? "داكن" : "فاتح"}');
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
  
  // ========== الثيم التلقائي (جديد) ==========
  
  /// تفعيل/إلغاء الثيم التلقائي
  Future<void> setAutoTheme(bool enabled) async {
    try {
      if (_autoThemeEnabled != enabled) {
        _autoThemeEnabled = enabled;
        await _storage.setBool(_autoThemeKey, _autoThemeEnabled);
        
        if (enabled) {
          _applyAutoTheme();
        }
        
        notifyListeners();
        debugPrint('ThemeNotifier: الثيم التلقائي ${enabled ? "مفعل" : "مُلغى"}');
      }
    } catch (e) {
      debugPrint('خطأ في تفعيل الثيم التلقائي: $e');
    }
  }
  
  /// تطبيق الثيم التلقائي حسب الوقت
  void _applyAutoTheme({bool notify = true}) {
    if (!_autoThemeEnabled) return;
    
    final hour = DateTime.now().hour;
    final shouldBeDark = hour < 6 || hour >= 19; // داكن من 7 مساءً إلى 6 صباحاً
    
    if (_isDarkMode != shouldBeDark) {
      _isDarkMode = shouldBeDark;
      _storage.setBool(_themeKey, _isDarkMode); // حفظ بدون await للأداء
      
      if (notify) {
        notifyListeners();
      }
      
      debugPrint('ThemeNotifier: تم تطبيق الثيم التلقائي - ${_isDarkMode ? "داكن" : "فاتح"}');
    }
  }
  
  /// إعداد مراقب الثيم التلقائي
  void _setupAutoTheme() {
    // فحص الثيم التلقائي كل دقيقة
    Stream.periodic(const Duration(minutes: 1)).listen((_) {
      if (_autoThemeEnabled) {
        _applyAutoTheme();
      }
    });
  }
  
  // ========== الثيم حسب الصلاة (جديد) ==========
  
  /// تفعيل/إلغاء الثيم حسب الصلاة
  Future<void> setPrayerBasedTheme(bool enabled) async {
    try {
      if (_prayerBasedTheme != enabled) {
        _prayerBasedTheme = enabled;
        await _storage.setBool(_prayerThemeKey, _prayerBasedTheme);
        notifyListeners();
        
        debugPrint('ThemeNotifier: الثيم حسب الصلاة ${enabled ? "مفعل" : "مُلغى"}');
      }
    } catch (e) {
      debugPrint('خطأ في تفعيل الثيم حسب الصلاة: $e');
    }
  }
  
  /// تحديث الصلاة الحالية
  void updateCurrentPrayer(String prayerName) {
    if (_currentPrayer != prayerName) {
      _currentPrayer = prayerName;
      
      if (_prayerBasedTheme) {
        notifyListeners();
      }
      
      debugPrint('ThemeNotifier: تم تحديث الصلاة الحالية إلى: $prayerName');
    }
  }
  
  // ========== إدارة اللغة المحسنة ==========
  
  /// تغيير اللغة (محسن)
  Future<void> setLanguage(String newLanguage) async {
    try {
      if (['ar', 'en'].contains(newLanguage) && _language != newLanguage) {
        _language = newLanguage;
        await _storage.setString(_languageKey, _language);
        notifyListeners();
        
        debugPrint('ThemeNotifier: تم تغيير اللغة إلى: $newLanguage');
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
  
  // ========== دوال مساعدة جديدة ==========
  
  /// التحقق من إمكانية تطبيق الثيم التلقائي
  bool get canApplyAutoTheme {
    final hour = DateTime.now().hour;
    final shouldBeDark = hour < 6 || hour >= 19;
    return _isDarkMode != shouldBeDark;
  }
  
  /// الحصول على معلومات الثيم الحالي
  Map<String, dynamic> get themeInfo => {
    'isDarkMode': _isDarkMode,
    'language': _language,
    'autoThemeEnabled': _autoThemeEnabled,
    'prayerBasedTheme': _prayerBasedTheme,
    'currentPrayer': _currentPrayer,
    'canApplyAutoTheme': canApplyAutoTheme,
  };
  
  /// الحصول على وقت التبديل التالي للثيم التلقائي
  DateTime? get nextThemeSwitch {
    if (!_autoThemeEnabled) return null;
    
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour < 6) {
      // التبديل للفاتح في الساعة 6 صباحاً
      return DateTime(now.year, now.month, now.day, 6);
    } else if (hour < 19) {
      // التبديل للداكن في الساعة 7 مساءً
      return DateTime(now.year, now.month, now.day, 19);
    } else {
      // التبديل للفاتح في اليوم التالي الساعة 6 صباحاً
      return DateTime(now.year, now.month, now.day + 1, 6);
    }
  }
  
  /// إعادة تطبيق الثيم بناءً على الإعدادات الحالية
  Future<void> refreshTheme() async {
    try {
      if (_autoThemeEnabled) {
        _applyAutoTheme();
      } else {
        notifyListeners();
      }
      debugPrint('ThemeNotifier: تم تحديث الثيم');
    } catch (e) {
      debugPrint('خطأ في تحديث الثيم: $e');
    }
  }
  
  // ========== دوال الأدوات المحسنة ==========
  
  /// إعادة تعيين الإعدادات للافتراضي (محسن)
  Future<void> resetToDefaults() async {
    try {
      _isDarkMode = false;
      _language = 'ar';
      _autoThemeEnabled = false;
      _prayerBasedTheme = false;
      _currentPrayer = 'general';
      
      await _storage.setBool(_themeKey, _isDarkMode);
      await _storage.setString(_languageKey, _language);
      await _storage.setBool(_autoThemeKey, _autoThemeEnabled);
      await _storage.setBool(_prayerThemeKey, _prayerBasedTheme);
      
      notifyListeners();
      debugPrint('ThemeNotifier: تم إعادة تعيين جميع إعدادات الثيم للافتراضي');
    } catch (e) {
      debugPrint('خطأ في إعادة تعيين الإعدادات: $e');
    }
  }
  
  /// نسخ الإعدادات الحالية
  Map<String, dynamic> exportSettings() {
    return {
      'isDarkMode': _isDarkMode,
      'language': _language,
      'autoThemeEnabled': _autoThemeEnabled,
      'prayerBasedTheme': _prayerBasedTheme,
      'currentPrayer': _currentPrayer,
      'version': '1.0', // لضمان التوافق المستقبلي
    };
  }
  
  /// استيراد إعدادات محفوظة
  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      _isDarkMode = settings['isDarkMode'] ?? false;
      _language = settings['language'] ?? 'ar';
      _autoThemeEnabled = settings['autoThemeEnabled'] ?? false;
      _prayerBasedTheme = settings['prayerBasedTheme'] ?? false;
      _currentPrayer = settings['currentPrayer'] ?? 'general';
      
      // حفظ الإعدادات الجديدة
      await _storage.setBool(_themeKey, _isDarkMode);
      await _storage.setString(_languageKey, _language);
      await _storage.setBool(_autoThemeKey, _autoThemeEnabled);
      await _storage.setBool(_prayerThemeKey, _prayerBasedTheme);
      
      notifyListeners();
      debugPrint('ThemeNotifier: تم استيراد الإعدادات بنجاح');
    } catch (e) {
      debugPrint('خطأ في استيراد الإعدادات: $e');
    }
  }
  
  // ========== التنظيف ==========
  
  @override
  void dispose() {
    debugPrint('ThemeNotifier: تم التخلص من المورد');
    super.dispose();
  }
}

/// Extension methods لسهولة الاستخدام (جديدة)
extension ThemeNotifierExtensions on ThemeNotifier {
  /// التحقق من كون الوقت الحالي مناسب للثيم الداكن
  bool get isNightTime {
    final hour = DateTime.now().hour;
    return hour < 6 || hour >= 19;
  }
  
  /// التحقق من كون الوقت الحالي مناسب للثيم الفاتح  
  bool get isDayTime => !isNightTime;
  
  /// الحصول على اسم الثيم الحالي
  String get currentThemeName {
    if (autoThemeEnabled) {
      return 'تلقائي (${isDarkMode ? "داكن" : "فاتح"})';
    } else if (prayerBasedTheme) {
      return 'حسب الصلاة ($currentPrayer)';
    } else {
      return isDarkMode ? 'داكن' : 'فاتح';
    }
  }
  
  /// الحصول على وصف مختصر للإعدادات
  String get settingsDescription {
    final List<String> features = [];
    
    if (autoThemeEnabled) features.add('تلقائي');
    if (prayerBasedTheme) features.add('حسب الصلاة');
    if (language == 'en') features.add('إنجليزي');
    
    if (features.isEmpty) {
      return isDarkMode ? 'ثيم داكن' : 'ثيم فاتح';
    } else {
      return '${isDarkMode ? "داكن" : "فاتح"} - ${features.join("، ")}';
    }
  }
}