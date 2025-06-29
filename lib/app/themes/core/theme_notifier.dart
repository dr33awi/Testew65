// lib/app/themes/core/theme_notifier.dart - عربي وداكن فقط مع إصلاح setTheme
import 'package:flutter/material.dart';
import 'package:athkar_app/core/infrastructure/services/storage/storage_service.dart';

/// مدير حالة الثيم الإسلامي - عربي وداكن فقط
class ThemeNotifier extends ChangeNotifier {
  final StorageService _storage;
  
  static const String _autoThemeKey = 'app_auto_theme';
  static const String _prayerThemeKey = 'app_prayer_theme';
  static const String _currentPrayerKey = 'app_current_prayer';
  
  bool _autoThemeEnabled = false;        // ثيم تلقائي حسب الوقت
  bool _prayerBasedTheme = false;        // ثيم حسب الصلاة
  String _currentPrayer = 'عام';         // الصلاة الحالية
  
  ThemeNotifier(this._storage) {
    _loadThemeSettings();
    _setupAutoTheme();
  }
  
  // ========== Getters ==========
  
  /// الثيم دائماً داكن
  bool get isDarkMode => true;
  bool get isLightMode => false;
  
  /// اللغة دائماً عربية
  String get language => 'ar';
  
  bool get autoThemeEnabled => _autoThemeEnabled;
  bool get prayerBasedTheme => _prayerBasedTheme;
  String get currentPrayer => _currentPrayer;
  
  /// الثيم دائماً داكن
  ThemeMode get themeMode => ThemeMode.dark;
  
  // ========== إدارة الثيم ==========
  
  /// تحميل إعدادات الثيم المحفوظة
  Future<void> _loadThemeSettings() async {
    try {
      _autoThemeEnabled = _storage.getBool(_autoThemeKey) ?? false;
      _prayerBasedTheme = _storage.getBool(_prayerThemeKey) ?? false;
      _currentPrayer = _storage.getString(_currentPrayerKey) ?? 'عام';
      
      notifyListeners();
      debugPrint('ThemeNotifier: تم تحميل الإعدادات - تلقائي: $_autoThemeEnabled، حسب الصلاة: $_prayerBasedTheme');
    } catch (e) {
      debugPrint('خطأ في تحميل إعدادات الثيم: $e');
    }
  }
  
  /// تحديث الثيم (للتوافق مع الكود القديم) - الإصلاح المطلوب
  Future<void> setTheme(bool isDarkMode) async {
    // الثيم دائماً داكن، لكن يمكن تسجيل التغيير
    debugPrint('ThemeNotifier: محاولة تغيير الثيم إلى ${isDarkMode ? "داكن" : "فاتح"} - الثيم دائماً داكن');
    
    // يمكن حفظ التفضيل حتى لو لم يتم تطبيقه
    try {
      await _storage.setBool('user_preferred_dark_mode', isDarkMode);
      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في حفظ تفضيل الثيم: $e');
    }
  }
  
  // ========== الثيم التلقائي ==========
  
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
  
  /// تطبيق الثيم التلقائي حسب الوقت (للتأثيرات البصرية فقط)
  void _applyAutoTheme({bool notify = true}) {
    if (!_autoThemeEnabled) return;
    
    final hour = DateTime.now().hour;
    
    // يمكن استخدام هذا لتغيير شدة الألوان أو التأثيرات البصرية
    // بدلاً من تغيير الثيم من فاتح إلى داكن
    if (notify) {
      notifyListeners();
    }
    
    debugPrint('ThemeNotifier: تم تطبيق التأثيرات التلقائية للساعة: $hour');
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
  
  // ========== الثيم حسب الصلاة ==========
  
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
  Future<void> updateCurrentPrayer(String prayerName) async {
    try {
      if (_currentPrayer != prayerName) {
        _currentPrayer = prayerName;
        await _storage.setString(_currentPrayerKey, _currentPrayer);
        
        if (_prayerBasedTheme) {
          notifyListeners();
        }
        
        debugPrint('ThemeNotifier: تم تحديث الصلاة الحالية إلى: $prayerName');
      }
    } catch (e) {
      debugPrint('خطأ في تحديث الصلاة الحالية: $e');
    }
  }
  
  // ========== دوال مساعدة ==========
  
  /// الحصول على معلومات الثيم الحالي
  Map<String, dynamic> get themeInfo => {
    'isDarkMode': true,
    'language': 'ar',
    'autoThemeEnabled': _autoThemeEnabled,
    'prayerBasedTheme': _prayerBasedTheme,
    'currentPrayer': _currentPrayer,
  };
  
  /// الحصول على وقت التحديث التالي للثيم التلقائي
  DateTime? get nextThemeUpdate {
    if (!_autoThemeEnabled) return null;
    
    final now = DateTime.now();
    // التحديث كل ساعة
    return DateTime(now.year, now.month, now.day, now.hour + 1);
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
  
  // ========== دوال الأدوات ==========
  
  /// إعادة تعيين الإعدادات للافتراضي
  Future<void> resetToDefaults() async {
    try {
      _autoThemeEnabled = false;
      _prayerBasedTheme = false;
      _currentPrayer = 'عام';
      
      await _storage.setBool(_autoThemeKey, _autoThemeEnabled);
      await _storage.setBool(_prayerThemeKey, _prayerBasedTheme);
      await _storage.setString(_currentPrayerKey, _currentPrayer);
      
      notifyListeners();
      debugPrint('ThemeNotifier: تم إعادة تعيين جميع إعدادات الثيم للافتراضي');
    } catch (e) {
      debugPrint('خطأ في إعادة تعيين الإعدادات: $e');
    }
  }
  
  /// نسخ الإعدادات الحالية
  Map<String, dynamic> exportSettings() {
    return {
      'autoThemeEnabled': _autoThemeEnabled,
      'prayerBasedTheme': _prayerBasedTheme,
      'currentPrayer': _currentPrayer,
      'version': '1.0',
    };
  }
  
  /// استيراد إعدادات محفوظة
  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      _autoThemeEnabled = settings['autoThemeEnabled'] ?? false;
      _prayerBasedTheme = settings['prayerBasedTheme'] ?? false;
      _currentPrayer = settings['currentPrayer'] ?? 'عام';
      
      // حفظ الإعدادات الجديدة
      await _storage.setBool(_autoThemeKey, _autoThemeEnabled);
      await _storage.setBool(_prayerThemeKey, _prayerBasedTheme);
      await _storage.setString(_currentPrayerKey, _currentPrayer);
      
      notifyListeners();
      debugPrint('ThemeNotifier: تم استيراد الإعدادات بنجاح');
    } catch (e) {
      debugPrint('خطأ في استيراد الإعدادات: $e');
    }
  }
  
  /// الحصول على شدة اللون حسب الوقت (للتأثيرات البصرية)
  double get timeBasedIntensity {
    final hour = DateTime.now().hour;
    
    if (hour >= 6 && hour < 12) {
      return 0.8; // صباح - شدة متوسطة
    } else if (hour >= 12 && hour < 18) {
      return 1.0; // نهار - شدة عالية
    } else if (hour >= 18 && hour < 22) {
      return 0.6; // مساء - شدة منخفضة
    } else {
      return 0.4; // ليل - شدة منخفضة جداً
    }
  }
  
  /// الحصول على نوع التأثير البصري حسب الوقت
  String get currentTimeEffect {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 7) {
      return 'فجر'; // تأثيرات الفجر
    } else if (hour >= 7 && hour < 12) {
      return 'صباح'; // تأثيرات الصباح
    } else if (hour >= 12 && hour < 15) {
      return 'ظهر'; // تأثيرات الظهر
    } else if (hour >= 15 && hour < 18) {
      return 'عصر'; // تأثيرات العصر
    } else if (hour >= 18 && hour < 20) {
      return 'مغرب'; // تأثيرات المغرب
    } else {
      return 'ليل'; // تأثيرات الليل
    }
  }
  
  // ========== دوال الصلوات ==========
  
  /// قائمة الصلوات المتاحة
  static const List<String> availablePrayers = [
    'عام',
    'الفجر',
    'الشروق',
    'الظهر',
    'العصر',
    'المغرب',
    'العشاء',
  ];
  
  /// التحقق من صحة اسم الصلاة
  bool isValidPrayerName(String prayerName) {
    return availablePrayers.contains(prayerName);
  }
  
  /// الحصول على الصلاة التالية
  String getNextPrayer() {
    final currentIndex = availablePrayers.indexOf(_currentPrayer);
    if (currentIndex == -1 || currentIndex == availablePrayers.length - 1) {
      return availablePrayers[1]; // الفجر
    }
    return availablePrayers[currentIndex + 1];
  }
  
  /// الحصول على الصلاة السابقة
  String getPreviousPrayer() {
    final currentIndex = availablePrayers.indexOf(_currentPrayer);
    if (currentIndex <= 1) {
      return availablePrayers.last; // العشاء
    }
    return availablePrayers[currentIndex - 1];
  }
  
  // ========== التنظيف ==========
  
  @override
  void dispose() {
    debugPrint('ThemeNotifier: تم التخلص من المورد');
    super.dispose();
  }
}

/// Extension methods لسهولة الاستخدام
extension ThemeNotifierExtensions on ThemeNotifier {
  /// التحقق من كون الوقت الحالي مناسب للتأثيرات الهادئة
  bool get isQuietTime {
    final hour = DateTime.now().hour;
    return hour < 6 || hour >= 22;
  }
  
  /// التحقق من كون الوقت الحالي وقت نشاط
  bool get isActiveTime => !isQuietTime;
  
  /// الحصول على اسم الثيم الحالي
  String get currentThemeName {
    if (autoThemeEnabled && prayerBasedTheme) {
      return 'تلقائي + $currentPrayer';
    } else if (autoThemeEnabled) {
      return 'تلقائي ($currentTimeEffect)';
    } else if (prayerBasedTheme) {
      return 'ثيم $currentPrayer';
    } else {
      return 'ثيم داكن ثابت';
    }
  }
  
  /// الحصول على وصف مختصر للإعدادات
  String get settingsDescription {
    final List<String> features = [];
    
    if (autoThemeEnabled) features.add('تلقائي');
    if (prayerBasedTheme) features.add('حسب الصلاة');
    
    if (features.isEmpty) {
      return 'ثيم داكن ثابت';
    } else {
      return 'ثيم داكن - ${features.join("، ")}';
    }
  }
  
  /// الحصول على درجة السطوع المناسبة للوقت الحالي
  double get currentBrightness {
    if (!autoThemeEnabled) return 1.0;
    
    final hour = DateTime.now().hour;
    
    if (hour >= 22 || hour < 6) {
      return 0.3; // ليل - سطوع منخفض جداً
    } else if (hour >= 6 && hour < 8) {
      return 0.5; // فجر وصباح مبكر - سطوع منخفض
    } else if (hour >= 8 && hour < 18) {
      return 0.8; // نهار - سطوع متوسط
    } else {
      return 0.6; // مساء - سطوع منخفض نوعاً ما
    }
  }
  
  /// تحديد ما إذا كان يجب استخدام تأثيرات بصرية متقدمة
  bool get shouldUseAdvancedEffects {
    return autoThemeEnabled || prayerBasedTheme;
  }
}