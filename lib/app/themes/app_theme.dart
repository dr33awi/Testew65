// lib/app/themes/app_theme.dart - النواة المحسّنة مع Glassmorphism
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نظام الثيم الإسلامي المحسّن مع Glassmorphism - هوية بصرية متكاملة
class AppTheme {
  AppTheme._();

  // ========== نظام الألوان المحسّن ==========
  
  // الألوان الأساسية المطورة
  static const Color primary = Color(0xFF5D7052);
  static const Color primaryLight = Color(0xFF7A8E6F);
  static const Color primaryDark = Color(0xFF4A5A41);
  
  static const Color secondary = Color(0xFFB8860B);
  static const Color secondaryLight = Color(0xFFDAA520);
  static const Color secondaryDark = Color(0xFF9A7209);
  
  static const Color accent = Color(0xFF8D5524);
  static const Color tertiary = Color(0xFF4F5D6B);
  
  // ألوان حالة محسّنة
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // نظام ألوان النص المطور
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFE2E8F0);
  static const Color textTertiary = Color(0xFFCBD5E1);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textReligious = Color(0xFFFEF7FF);
  
  // خلفيات Glassmorphism
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155);
  static const Color card = Color(0xFF475569);
  
  // ألوان متقدمة للتأثيرات
  static const Color glassOverlay = Color(0x10FFFFFF);
  static const Color glassStroke = Color(0x20FFFFFF);
  static const Color shadowColor = Color(0x40000000);
  
  static const Color divider = Color(0xFF374151);
  static const Color border = Color(0xFF4B5563);

  // ========== الخطوط المحسّنة ==========
  
  static const String primaryFont = 'Tajawal';
  static const String religiousFont = 'Amiri Quran';
  static const String numbersFont = 'Cairo';
  
  static const FontWeight ultraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ========== أنماط النصوص المحسّنة ==========
  
  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 56,
    fontWeight: extraBold,
    height: 1.1,
    color: textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 44,
    fontWeight: bold,
    height: 1.15,
    color: textPrimary,
    letterSpacing: -0.25,
  );
  
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 36,
    fontWeight: bold,
    height: 1.2,
    color: textPrimary,
    letterSpacing: -0.25,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: semiBold,
    height: 1.3,
    color: textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.3,
    color: textPrimary,
    letterSpacing: 0,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 22,
    fontWeight: semiBold,
    height: 1.35,
    color: textPrimary,
    letterSpacing: 0,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: medium,
    height: 1.4,
    color: textPrimary,
    letterSpacing: 0.15,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: regular,
    height: 1.6,
    color: textPrimary,
    letterSpacing: 0.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
    color: textPrimary,
    letterSpacing: 0.25,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: regular,
    height: 1.4,
    color: textSecondary,
    letterSpacing: 0.4,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 0.5,
    color: textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 0.5,
    color: textSecondary,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: regular,
    height: 1.4,
    color: textTertiary,
    letterSpacing: 0.4,
  );
  
  // أنماط النصوص الدينية المحسّنة
  static const TextStyle quranStyle = TextStyle(
    fontFamily: religiousFont,
    fontSize: 20,
    fontWeight: regular,
    height: 2.2,
    letterSpacing: 1.0,
    color: textReligious,
    wordSpacing: 2.0,
  );
  
  static const TextStyle dhikrStyle = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: medium,
    height: 1.8,
    color: textReligious,
    letterSpacing: 0.5,
  );
  
  static const TextStyle numbersStyle = TextStyle(
    fontFamily: numbersFont,
    fontSize: 22,
    fontWeight: bold,
    height: 1.2,
    color: primary,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: 0.5,
  );

  // ========== ثوابت التصميم المحسّنة ==========
  
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  
  // زوايا محسّنة مع انحناءات أكثر عصرية
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 28.0;
  static const double radius3xl = 36.0;
  static const double radiusFull = 1000.0;
  
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double icon2xl = 48.0;
  
  // ارتفاعات محسّنة
  static const double elevationXs = 1.0;
  static const double elevationSm = 3.0;
  static const double elevationMd = 8.0;
  static const double elevationLg = 16.0;
  static const double elevationXl = 24.0;
  
  static const double buttonHeight = 48.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonHeightSmall = 40.0;
  
  // مدد الحركة المحسّنة
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);
  static const Duration durationExtra = Duration(milliseconds: 500);

  // ========== ظلال Glassmorphism المتقدمة ==========
  
  static List<BoxShadow> get glassShadowSm => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 10,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.05),
      blurRadius: 1,
      offset: const Offset(0, 1),
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get glassShadowMd => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 25,
      offset: const Offset(0, 8),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.08),
      blurRadius: 2,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> get glassShadowLg => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 50,
      offset: const Offset(0, 20),
      spreadRadius: -12,
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.1),
      blurRadius: 3,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get shadowSm => glassShadowSm;
  static List<BoxShadow> get shadowMd => glassShadowMd;
  static List<BoxShadow> get shadowLg => glassShadowLg;

  // ========== تدرجات Glassmorphism المتقدمة ==========
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5D7052),
      Color(0xFF4A5A41),
      Color(0xFF3A4A31),
    ],
    stops: [0.0, 0.6, 1.0],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB8860B),
      Color(0xFF9A7209),
      Color(0xFF7A5A05),
    ],
    stops: [0.0, 0.6, 1.0],
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x20FFFFFF),
      Color(0x10FFFFFF),
      Color(0x05FFFFFF),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient oliveGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF5D7052),
      Color(0xFF7A8E6F),
      Color(0xFFB8860B),
      Color(0xFF9A7209),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  // تدرجات خلفية متحركة
  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.topLeft,
    radius: 1.5,
    colors: [
      Color(0xFF1E293B),
      Color(0xFF0F172A),
      Color(0xFF020617),
    ],
    stops: [0.0, 0.6, 1.0],
  );

  // ========== البيانات المركزية المحسّنة ==========
  
  /// ألوان الصلوات المحسّنة
  static const Map<String, Color> prayerColors = {
    'الفجر': Color(0xFF6366F1),     // بنفسجي هادئ
    'الشروق': Color(0xFFF59E0B),   // ذهبي مشرق
    'الظهر': Color(0xFFEF4444),    // أحمر دافئ
    'العصر': Color(0xFFEAB308),    // أصفر ذهبي
    'المغرب': Color(0xFF8B5CF6),   // بنفسجي عميق
    'العشاء': Color(0xFF06B6D4),   // أزرق ليلي
  };
  
  /// ألوان الفئات المحسّنة
  static const Map<String, Color> categoryColors = {
    'morning': Color(0xFF10B981),
    'الصباح': Color(0xFF10B981),
    'evening': Color(0xFF8B5CF6),
    'المساء': Color(0xFF8B5CF6),
    'sleep': Color(0xFF6366F1),
    'النوم': Color(0xFF6366F1),
    'prayer': Color(0xFF059669),
    'الصلاة': Color(0xFF059669),
    'eating': Color(0xFFF59E0B),
    'الطعام': Color(0xFFF59E0B),
    'travel': Color(0xFF3B82F6),
    'السفر': Color(0xFF3B82F6),
    'quran': Color(0xFF059669),
    'القرآن': Color(0xFF059669),
    'tasbih': Color(0xFFEAB308),
    'التسبيح': Color(0xFFEAB308),
    'dua': Color(0xFF8B5CF6),
    'الدعاء': Color(0xFF8B5CF6),
    'general': Color(0xFF6B7280),
    'عامة': Color(0xFF6B7280),
  };

  /// أيقونات الصلوات (بدون تغيير)
  static const Map<String, IconData> prayerIcons = {
    'الفجر': Icons.wb_twilight,
    'fajr': Icons.wb_twilight,
    'الشروق': Icons.wb_sunny,
    'sunrise': Icons.wb_sunny,
    'الظهر': Icons.light_mode,
    'dhuhr': Icons.light_mode,
    'العصر': Icons.wb_cloudy,
    'asr': Icons.wb_cloudy,
    'المغرب': Icons.wb_incandescent,
    'maghrib': Icons.wb_incandescent,
    'العشاء': Icons.nightlight_round,
    'isha': Icons.nightlight_round,
  };

  /// أيقونات الفئات (بدون تغيير)
  static const Map<String, IconData> categoryIcons = {
    'morning': Icons.wb_sunny,
    'الصباح': Icons.wb_sunny,
    'evening': Icons.wb_incandescent,
    'المساء': Icons.wb_incandescent,
    'sleep': Icons.nightlight_round,
    'النوم': Icons.nightlight_round,
    'prayer': Icons.mosque,
    'الصلاة': Icons.mosque,
    'eating': Icons.restaurant,
    'الطعام': Icons.restaurant,
    'travel': Icons.flight,
    'السفر': Icons.flight,
    'quran': Icons.menu_book,
    'القرآن': Icons.menu_book,
    'tasbih': Icons.fingerprint,
    'التسبيح': Icons.fingerprint,
    'dua': Icons.volunteer_activism,
    'الدعاء': Icons.volunteer_activism,
    'general': Icons.book,
    'عامة': Icons.book,
  };

  /// أولويات الصلوات (بدون تغيير)
  static const Map<String, int> prayerPriorities = {
    'الفجر': 1, 'fajr': 1,
    'الشروق': 2, 'sunrise': 2,
    'الظهر': 3, 'dhuhr': 3,
    'العصر': 4, 'asr': 4,
    'المغرب': 5, 'maghrib': 5,
    'العشاء': 6, 'isha': 6,
  };

  /// أولويات الفئات (بدون تغيير)
  static const Map<String, int> categoryPriorities = {
    'morning': 1, 'الصباح': 1,
    'evening': 2, 'المساء': 2,
    'prayer': 3, 'الصلاة': 3,
    'sleep': 4, 'النوم': 4,
    'eating': 5, 'الطعام': 5,
    'quran': 6, 'القرآن': 6,
    'tasbih': 7, 'التسبيح': 7,
    'dua': 8, 'الدعاء': 8,
    'general': 99, 'عامة': 99,
  };

  // ========== الدوال المركزية (بدون تغيير) ==========
  
  /// الحصول على لون الصلاة
  static Color getPrayerColor(String prayerName) {
    return prayerColors[prayerName] ?? primary;
  }
  
  /// الحصول على لون الفئة
  static Color getCategoryColor(String categoryId) {
    return categoryColors[categoryId] ?? primary;
  }

  /// الحصول على أيقونة الصلاة
  static IconData getPrayerIcon(String prayerName) {
    return prayerIcons[prayerName.toLowerCase()] ?? Icons.access_time;
  }

  /// الحصول على أيقونة الفئة
  static IconData getCategoryIcon(String categoryId) {
    return categoryIcons[categoryId.toLowerCase()] ?? Icons.book;
  }

  /// الحصول على أولوية الصلاة
  static int getPrayerPriority(String prayerName) {
    return prayerPriorities[prayerName.toLowerCase()] ?? 99;
  }

  /// الحصول على أولوية الفئة
  static int getCategoryPriority(String categoryId) {
    return categoryPriorities[categoryId.toLowerCase()] ?? 99;
  }

  // ========== دوال التنسيق (بدون تغيير) ==========

  /// تنسيق الأرقام الكبيرة
  static String formatLargeNumber(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}م';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}ك';
    }
    return number.toString();
  }

  /// تنسيق المدة الزمنية
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}س ${minutes}د';
    } else {
      return '${minutes}د';
    }
  }

  /// تنسيق وقت الصلاة
  static String formatPrayerTime(DateTime time, {bool use24Hour = false}) {
    if (use24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'م' : 'ص';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    }
  }

  // ========== دوال الترتيب والفلترة (بدون تغيير) ==========

  /// ترتيب القوائم بناءً على الأولوية
  static List<T> sortByPriority<T>(
    List<T> items,
    int Function(T) getPriorityFunction,
  ) {
    final sortedList = List<T>.from(items);
    sortedList.sort((a, b) => getPriorityFunction(a).compareTo(getPriorityFunction(b)));
    return sortedList;
  }

  /// فلترة بناءً على النص
  static List<T> filterByText<T>(
    List<T> items,
    String searchText,
    List<String> Function(T) getSearchableTexts,
  ) {
    if (searchText.isEmpty) return items;
    
    final lowerSearchText = searchText.toLowerCase().trim();
    
    return items.where((item) {
      return getSearchableTexts(item).any((text) =>
          text.toLowerCase().contains(lowerSearchText));
    }).toList();
  }

  // ========== دوال التحقق (بدون تغيير) ==========

  /// التحقق من صحة وقت الصلاة
  static bool isValidPrayerTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length < 2) return false;
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      return hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;
    } catch (e) {
      return false;
    }
  }

  /// التحقق من الفئات الأساسية
  static bool isEssentialCategory(String categoryId) {
    const essentialCategories = {
      'morning', 'الصباح',
      'evening', 'المساء', 
      'sleep', 'النوم',
      'prayer', 'الصلاة',
      'eating', 'الطعام',
    };
    return essentialCategories.contains(categoryId.toLowerCase());
  }

  /// التحقق من الصلوات الرئيسية
  static bool isMainPrayer(String prayerName) {
    const mainPrayers = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
    return mainPrayers.contains(prayerName);
  }

  // ========== دوال الألوان المحسّنة ==========

  /// تفتيح اللون
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
  
  /// تغميق اللون
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  /// الحصول على خلفية مناسبة للمحتوى الديني
  static Color getReligiousBackground(String type) {
    switch (type) {
      case 'قران':
      case 'آية':
        return const Color(0xFF1E2A1E);
      case 'ذكر':
      case 'اذكار':
        return const Color(0xFF252E25);
      case 'حديث':
        return const Color(0xFF2A251E);
      case 'دعاء':
        return const Color(0xFF2D2419);
      default:
        return surface;
    }
  }

  // ========== دوال Glassmorphism الجديدة ==========

  /// إنشاء تأثير زجاج متقدم
  static BoxDecoration createGlassEffect({
    Color? backgroundColor,
    double borderRadius = radiusLg,
    double opacity = 0.1,
    bool addBorder = true,
    bool addShadow = true,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          (backgroundColor ?? Colors.white).withValues(alpha: opacity * 1.2),
          (backgroundColor ?? Colors.white).withValues(alpha: opacity * 0.8),
          (backgroundColor ?? Colors.white).withValues(alpha: opacity * 0.4),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: addBorder ? Border.all(
        color: glassStroke,
        width: 1,
      ) : null,
      boxShadow: addShadow ? glassShadowMd : null,
    );
  }

  /// إنشاء backdrop filter للتأثير الزجاجي
  static Widget createBackdropBlur({
    required Widget child,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
  }) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
  }

  /// إنشاء تأثير حركة متقدم
  static Widget createFloatingAnimation({
    required Widget child,
    Duration duration = durationExtra,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -2 + (2 * value)),
          child: child,
        );
      },
      child: child,
    );
  }

  // ========== الثيم الرئيسي المحسّن ==========
  
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    primaryColor: primary,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      onPrimary: Colors.black,
      secondary: secondary,
      onSecondary: Colors.black,
      tertiary: tertiary,
      onTertiary: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      error: error,
      onError: Colors.white,
      outline: border,
      surfaceContainerHighest: surfaceLight,
    ),
    
    scaffoldBackgroundColor: background,
    
    textTheme: const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    ),
    
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimary,
      titleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontSize: 22,
        fontWeight: semiBold,
        color: textPrimary,
        letterSpacing: 0,
      ),
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: Colors.transparent,
      elevation: 0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXl),
      ),
      margin: const EdgeInsets.all(space3),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: space6,
          vertical: space4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
        ),
        minimumSize: const Size(120, buttonHeight),
        textStyle: const TextStyle(
          fontFamily: primaryFont,
          fontSize: 16,
          fontWeight: semiBold,
          letterSpacing: 0.5,
        ),
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return primary.withValues(alpha: 0.8);
          }
          return primary;
        }),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(
          horizontal: space5,
          vertical: space3,
        ),
        textStyle: const TextStyle(
          fontFamily: primaryFont,
          fontSize: 14,
          fontWeight: medium,
          letterSpacing: 0.25,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
    ),
    
    iconTheme: const IconThemeData(
      color: textSecondary,
      size: iconMd,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: glassStroke),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: glassStroke),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusXl),
        borderSide: const BorderSide(color: error),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: space5,
        vertical: space4,
      ),
      hintStyle: bodyMedium.copyWith(color: textHint),
      labelStyle: bodyMedium.copyWith(color: textSecondary),
    ),
    
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius2xl),
      ),
      titleTextStyle: titleLarge,
      contentTextStyle: bodyMedium,
    ),
    
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: space5,
        vertical: space3,
      ),
      titleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontSize: 16,
        fontWeight: medium,
        color: textPrimary,
        letterSpacing: 0.25,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontSize: 14,
        fontWeight: regular,
        color: textSecondary,
        letterSpacing: 0.25,
      ),
      iconColor: textSecondary,
      minVerticalPadding: space2,
    ),
    
    dividerTheme: const DividerThemeData(
      color: divider,
      thickness: 0.5,
      space: space5,
    ),
    
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: divider,
      circularTrackColor: divider,
    ),
    
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.transparent,
      contentTextStyle: bodyMedium.copyWith(color: textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXl),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.black,
      elevation: elevationMd,
      shape: CircleBorder(),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: primary,
      unselectedItemColor: textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}

// ========== CardHelper محسّن مع Glassmorphism ==========

/// أدوات البطاقات الموحدة مع تأثيرات متقدمة
class CardHelper {
  CardHelper._();
  
  /// تزيين الكرت مع Glassmorphism
  static BoxDecoration getCardDecoration({
    Color? color,
    bool useGradient = false,
    List<Color>? gradientColors,
    double borderRadius = AppTheme.radiusXl,
    bool useGlass = true,
    double glassOpacity = 0.1,
  }) {
    if (useGlass) {
      return AppTheme.createGlassEffect(
        backgroundColor: color ?? Colors.white,
        borderRadius: borderRadius,
        opacity: glassOpacity,
      );
    }
    
    if (useGradient) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors ?? [
            color ?? AppTheme.primary,
            AppTheme.darken(color ?? AppTheme.primary, 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppTheme.glassShadowMd,
      );
    }
    
    return BoxDecoration(
      color: color ?? AppTheme.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppTheme.glassStroke,
        width: 1,
      ),
      boxShadow: AppTheme.glassShadowSm,
    );
  }
  
  /// التحقق من نوع النص للخط المناسب (بدون تغيير)
  static TextStyle getTextStyle(String type, {TextStyle? baseStyle}) {
    switch (type.toLowerCase()) {
      case 'quran':
      case 'قران':
      case 'آية':
        return AppTheme.quranStyle;
      case 'dhikr':
      case 'ذكر':
      case 'اذكار':
        return AppTheme.dhikrStyle;
      case 'numbers':
      case 'ارقام':
      case 'عدد':
        return AppTheme.numbersStyle;
      default:
        return baseStyle ?? AppTheme.bodyMedium;
    }
  }

  /// إنشاء تأثير احترافي للكروت
  static Widget createProfessionalCard({
    required Widget child,
    bool useFloating = true,
    bool useGlass = true,
    double borderRadius = AppTheme.radiusXl,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    Widget cardWidget = Container(
      margin: margin ?? const EdgeInsets.all(AppTheme.space3),
      padding: padding ?? const EdgeInsets.all(AppTheme.space5),
      decoration: getCardDecoration(
        borderRadius: borderRadius,
        useGlass: useGlass,
      ),
      child: child,
    );

    if (useGlass) {
      cardWidget = AppTheme.createBackdropBlur(
        sigmaX: 12,
        sigmaY: 12,
        child: cardWidget,
      );
    }

    if (useFloating) {
      cardWidget = AppTheme.createFloatingAnimation(
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}

// ========== Extensions محسّنة (بدون تغيير في الأسماء) ==========

extension AppThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  
  Color get primaryColor => AppTheme.primary;
  Color get secondaryColor => AppTheme.secondary;
  Color get backgroundColor => AppTheme.background;
  Color get surfaceColor => AppTheme.surface;
  Color get cardColor => AppTheme.card;
  
  TextStyle get headlineLarge => AppTheme.headlineLarge;
  TextStyle get headlineMedium => AppTheme.headlineMedium;
  TextStyle get titleLarge => AppTheme.titleLarge;
  TextStyle get titleMedium => AppTheme.titleMedium;
  TextStyle get bodyLarge => AppTheme.bodyLarge;
  TextStyle get bodyMedium => AppTheme.bodyMedium;
  TextStyle get bodySmall => AppTheme.bodySmall;
  TextStyle get labelMedium => AppTheme.labelMedium;
  
  TextStyle get quranStyle => AppTheme.quranStyle;
  TextStyle get dhikrStyle => AppTheme.dhikrStyle;
  TextStyle get numbersStyle => AppTheme.numbersStyle;
  
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;
  
  Color getPrayerColor(String prayerName) => AppTheme.getPrayerColor(prayerName);
  Color getCategoryColor(String categoryId) => AppTheme.getCategoryColor(categoryId);
  Color getReligiousBackground(String type) => AppTheme.getReligiousBackground(type);
}

extension AppColorExtensions on Color {
  Color lighten([double amount = 0.1]) => AppTheme.lighten(this, amount);
  Color darken([double amount = 0.1]) => AppTheme.darken(this, amount);
  Color withAlpha(double alpha) => withValues(alpha: alpha);
}

extension AppSpacingExtensions on double {
  Widget get w => SizedBox(width: this);
  Widget get h => SizedBox(height: this);
  EdgeInsets get padding => EdgeInsets.all(this);
  EdgeInsets get paddingH => EdgeInsets.symmetric(horizontal: this);
  EdgeInsets get paddingV => EdgeInsets.symmetric(vertical: this);
  BorderRadius get radius => BorderRadius.circular(this);
}