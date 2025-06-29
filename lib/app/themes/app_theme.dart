// lib/app/themes/app_theme.dart - النواة المركزية المحسنة مع دمج جميع الدوال المساعدة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نظام الثيم الإسلامي المركزي - يحتوي على كل شيء
class AppTheme {
  AppTheme._();

  // ========== الألوان الأساسية ==========
  
  static const Color primary = Color(0xFF5D7052);
  static const Color primaryLight = Color(0xFF7A8E6F);
  static const Color primaryDark = Color(0xFF4A5A41);
  
  static const Color secondary = Color(0xFFB8860B);
  static const Color secondaryLight = Color(0xFFDAA520);
  static const Color secondaryDark = Color(0xFF9A7209);
  
  static const Color accent = Color(0xFF8D5524);
  static const Color tertiary = Color(0xFF4F5D6B);
  
  static const Color success = primary;
  static const Color warning = secondary;
  static const Color error = Color(0xFFD04848);
  static const Color info = Color(0xFF4A86B8);
  
  static const Color textPrimary = Color(0xFFF5F5F0);
  static const Color textSecondary = Color(0xFFE0E0D6);
  static const Color textTertiary = Color(0xFFC4C4B8);
  static const Color textHint = Color(0xFFA8A898);
  static const Color textReligious = Color(0xFFF8F8F3);
  
  static const Color background = Color(0xFF1A1F1A);
  static const Color surface = Color(0xFF232A23);
  static const Color card = Color(0xFF2D352D);
  
  static const Color divider = Color(0xFF3A4239);
  static const Color border = Color(0xFF4A524A);

  // ========== الخطوط ==========
  
  static const String primaryFont = 'Tajawal';
  static const String religiousFont = 'Amiri Quran';
  static const String numbersFont = 'Cairo';
  
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ========== أنماط النصوص ==========
  
  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 48,
    fontWeight: bold,
    height: 1.2,
    color: textPrimary,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 36,
    fontWeight: bold,
    height: 1.2,
    color: textPrimary,
  );
  
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: bold,
    height: 1.3,
    color: textPrimary,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 28,
    fontWeight: semiBold,
    height: 1.3,
    color: textPrimary,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: semiBold,
    height: 1.4,
    color: textPrimary,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 18,
    fontWeight: medium,
    height: 1.4,
    color: textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: regular,
    height: 1.6,
    color: textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
    color: textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: regular,
    height: 1.4,
    color: textSecondary,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 0.3,
    color: textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 11,
    fontWeight: regular,
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
  );
  
  static const TextStyle quranStyle = TextStyle(
    fontFamily: religiousFont,
    fontSize: 18,
    fontWeight: regular,
    height: 2.0,
    letterSpacing: 0.5,
    color: textReligious,
  );
  
  static const TextStyle dhikrStyle = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16,
    fontWeight: medium,
    height: 1.7,
    color: textReligious,
  );
  
  static const TextStyle numbersStyle = TextStyle(
    fontFamily: numbersFont,
    fontSize: 20,
    fontWeight: semiBold,
    height: 1.2,
    color: primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ========== الثوابت التصميمية ==========
  
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  
  static const double radiusXs = 2.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 10.0;
  static const double radiusLg = 14.0;
  static const double radiusXl = 18.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 1000.0;
  
  static const double iconSm = 16.0;
  static const double iconMd = 22.0;
  static const double iconLg = 28.0;
  static const double iconXl = 36.0;
  
  static const double elevationSm = 2.0;
  static const double elevationMd = 6.0;
  static const double elevationLg = 12.0;
  
  static const double buttonHeight = 44.0;
  static const double buttonHeightLarge = 52.0;
  
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ========== الظلال ==========
  
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.16),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 12,
      offset: const Offset(0, 6),
      spreadRadius: 1,
    ),
  ];

  // ========== التدرجات ==========
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient oliveGoldGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========== البيانات المركزية ==========
  
  /// ألوان الصلوات - مركزية
  static const Map<String, Color> prayerColors = {
    'الفجر': Color(0xFF6B7BA8),
    'الشروق': secondary,
    'الظهر': Color(0xFFD08C47),
    'العصر': accent,
    'المغرب': Color(0xFF9B6B9B),
    'العشاء': tertiary,
  };
  
  /// ألوان الفئات - مركزية
  static const Map<String, Color> categoryColors = {
    'morning': primary,
    'الصباح': primary,
    'evening': accent,
    'المساء': accent,
    'sleep': tertiary,
    'النوم': tertiary,
    'prayer': primary,
    'الصلاة': primary,
    'eating': secondary,
    'الطعام': secondary,
    'travel': info,
    'السفر': info,
    'quran': Color(0xFF4A6B4A),
    'القرآن': Color(0xFF4A6B4A),
    'tasbih': secondary,
    'التسبيح': secondary,
    'dua': Color(0xFF8B7355),
    'الدعاء': Color(0xFF8B7355),
    'general': primary,
    'عامة': primary,
    'اوقات_الصلاة': primary,
    'الاذكار': accent,
    'القبلة': tertiary,
    'قبلة': tertiary,
    'تسبيح': secondary,
    'القران': Color(0xFF4A6B4A),
    'الادعية': Color(0xFF8B7355),
    'المفضلة': Color(0xFFCC8E35),
    'الاعدادات': Color(0xFF6B7BA8),
  };

  /// أيقونات الصلوات - مركزية
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

  /// أيقونات الفئات - مركزية
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

  /// أولويات الصلوات - مركزية
  static const Map<String, int> prayerPriorities = {
    'الفجر': 1,
    'fajr': 1,
    'الشروق': 2,
    'sunrise': 2,
    'الظهر': 3,
    'dhuhr': 3,
    'العصر': 4,
    'asr': 4,
    'المغرب': 5,
    'maghrib': 5,
    'العشاء': 6,
    'isha': 6,
  };

  /// أولويات الفئات - مركزية
  static const Map<String, int> categoryPriorities = {
    'morning': 1,
    'الصباح': 1,
    'evening': 2,
    'المساء': 2,
    'prayer': 3,
    'الصلاة': 3,
    'sleep': 4,
    'النوم': 4,
    'eating': 5,
    'الطعام': 5,
    'quran': 6,
    'القرآن': 6,
    'tasbih': 7,
    'التسبيح': 7,
    'dua': 8,
    'الدعاء': 8,
    'general': 99,
    'عامة': 99,
  };

  // ========== الدوال المساعدة المدمجة ==========
  
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

  /// تنسيق الأرقام الكبيرة - مدمج
  static String formatLargeNumber(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}م';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}ك';
    }
    return number.toString();
  }

  /// تنسيق المدة الزمنية - مدمج
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}س ${minutes}د';
    } else {
      return '${minutes}د';
    }
  }

  /// تنسيق وقت الصلاة - مدمج
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

  /// ترتيب القوائم بناءً على الأولوية - عام ومفيد
  static List<T> sortByPriority<T>(
    List<T> items,
    int Function(T) getPriorityFunction,
  ) {
    final sortedList = List<T>.from(items);
    sortedList.sort((a, b) => getPriorityFunction(a).compareTo(getPriorityFunction(b)));
    return sortedList;
  }

  /// فلترة بناءً على النص - عام ومفيد
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

  /// التحقق من صحة وقت الصلاة - مدمج
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

  /// التحقق من الفئات الأساسية - مدمج
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

  /// التحقق من الصلوات الرئيسية - مدمج
  static bool isMainPrayer(String prayerName) {
    const mainPrayers = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
    return mainPrayers.contains(prayerName);
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

  // ========== الثيم الرئيسي ==========
  
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
      onTertiary: Colors.black,
      surface: surface,
      onSurface: textPrimary,
      error: error,
      onError: Colors.black,
      outline: border,
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
        fontSize: 20,
        fontWeight: semiBold,
        color: textPrimary,
      ),
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: card,
      elevation: elevationSm,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLg),
      ),
      margin: const EdgeInsets.all(space3),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.black,
        elevation: elevationSm,
        shadowColor: primary.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(
          horizontal: space5,
          vertical: space3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        minimumSize: const Size(80, buttonHeight),
        textStyle: const TextStyle(
          fontFamily: primaryFont,
          fontSize: 14,
          fontWeight: semiBold,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(
          horizontal: space4,
          vertical: space2,
        ),
        textStyle: const TextStyle(
          fontFamily: primaryFont,
          fontSize: 14,
          fontWeight: medium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),
    ),
    
    iconTheme: const IconThemeData(
      color: textSecondary,
      size: iconMd,
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: error),
      ),
      contentPadding: const EdgeInsets.all(space4),
      hintStyle: bodyMedium.copyWith(color: textHint),
      labelStyle: bodyMedium.copyWith(color: textSecondary),
    ),
    
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      elevation: elevationLg,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusXl),
      ),
      titleTextStyle: titleLarge,
      contentTextStyle: bodyMedium,
    ),
    
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surface,
      elevation: elevationLg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radiusXl),
        ),
      ),
    ),
    
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: space4,
        vertical: space2,
      ),
      titleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontSize: 16,
        fontWeight: medium,
        color: textPrimary,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontSize: 14,
        fontWeight: regular,
        color: textSecondary,
      ),
      iconColor: textSecondary,
    ),
    
    dividerTheme: const DividerThemeData(
      color: divider,
      thickness: 0.5,
      space: space4,
    ),
    
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: divider,
      circularTrackColor: divider,
    ),
    
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: bodyMedium.copyWith(color: Colors.black),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radiusMd)),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: elevationMd,
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.black,
      elevation: elevationMd,
    ),
  );
}

// ========== CardHelper محسّن ومدمج ==========

/// أدوات البطاقات الموحدة
class CardHelper {
  CardHelper._();
  
  /// تزيين الكرت الأساسي الموحد
  static BoxDecoration getCardDecoration({
    Color? color,
    bool useGradient = false,
    List<Color>? gradientColors,
    double borderRadius = AppTheme.radiusLg,
  }) {
    if (useGradient) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors ?? [
            color ?? AppTheme.primary,
            (color ?? AppTheme.primary).darken(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppTheme.shadowMd,
      );
    }
    
    return BoxDecoration(
      color: AppTheme.card,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppTheme.divider.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: AppTheme.shadowSm,
    );
  }
  
  /// التحقق من نوع النص للخط المناسب
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
}

// ========== Extensions محسّنة ==========

extension AppThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  
  Color get primaryColor => AppTheme.primary;
  Color get secondaryColor => AppTheme.secondary;
  Color get backgroundColor => AppTheme.background;
  Color get surfaceColor => AppTheme.surface;
  Color get cardColor => AppTheme.card;
  
  TextStyle get headlineLarge => AppTheme.headlineLarge;
  TextStyle get headlineMedium => AppTheme.headlineMedium;
  TextStyle get headlineSmall => AppTheme.headlineSmall;
  TextStyle get titleLarge => AppTheme.titleLarge;
  TextStyle get titleMedium => AppTheme.titleMedium;
  TextStyle get bodyLarge => AppTheme.bodyLarge;
  TextStyle get bodyMedium => AppTheme.bodyMedium;
  TextStyle get bodySmall => AppTheme.bodySmall;
  TextStyle get labelMedium => AppTheme.labelMedium;
  TextStyle get labelSmall => AppTheme.labelSmall;
  
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