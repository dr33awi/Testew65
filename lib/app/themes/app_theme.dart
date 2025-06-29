// lib/app/themes/app_theme.dart - النظام المبسط الكامل مع الحفاظ على التصميم
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نظام الثيم الإسلامي المبسط - داكن فقط
class AppTheme {
  AppTheme._();

  // ========== الألوان الأساسية ==========
  
  /// الألوان الإسلامية الأساسية
  static const Color primary = Color(0xFF5D7052);        // أخضر زيتي أنيق
  static const Color primaryLight = Color(0xFF7A8E6F);
  static const Color primaryDark = Color(0xFF4A5A41);
  
  static const Color secondary = Color(0xFFB8860B);       // ذهبي دافئ
  static const Color secondaryLight = Color(0xFFDAA520);
  static const Color secondaryDark = Color(0xFF9A7209);
  
  static const Color accent = Color(0xFF8D5524);          // بني دافئ
  static const Color tertiary = Color(0xFF4F5D6B);       // أزرق رمادي
  
  // ألوان الحالة
  static const Color success = primary;
  static const Color warning = secondary;
  static const Color error = Color(0xFFD04848);
  static const Color info = Color(0xFF4A86B8);
  
  // ألوان النصوص
  static const Color textPrimary = Color(0xFFF5F5F0);
  static const Color textSecondary = Color(0xFFE0E0D6);
  static const Color textTertiary = Color(0xFFC4C4B8);
  static const Color textHint = Color(0xFFA8A898);
  static const Color textReligious = Color(0xFFF8F8F3);
  
  // ألوان الخلفيات
  static const Color background = Color(0xFF1A1F1A);
  static const Color surface = Color(0xFF232A23);
  static const Color card = Color(0xFF2D352D);
  
  // ألوان الحدود
  static const Color divider = Color(0xFF3A4239);
  static const Color border = Color(0xFF4A524A);
  
  // ========== الخطوط العربية ==========
  
  static const String primaryFont = 'Tajawal';
  static const String religiousFont = 'Amiri Quran';
  static const String numbersFont = 'Cairo';
  
  // أوزان الخطوط
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  // ========== أنماط النصوص الأساسية ==========
  
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
  
  static const TextStyle caption = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: regular,
    height: 1.4,
    color: textTertiary,
  );
  
  // النصوص الدينية
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
  
  // المسافات
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  
  // الحواف والانحناءات
  static const double radiusXs = 2.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 10.0;
  static const double radiusLg = 14.0;
  static const double radiusXl = 18.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 1000.0;
  
  // أحجام الأيقونات
  static const double iconSm = 16.0;
  static const double iconMd = 22.0;
  static const double iconLg = 28.0;
  static const double iconXl = 36.0;
  
  // الارتفاعات والظلال
  static const double elevationSm = 2.0;
  static const double elevationMd = 6.0;
  static const double elevationLg = 12.0;
  
  // أحجام الأزرار
  static const double buttonHeight = 44.0;
  static const double buttonHeightLarge = 52.0;
  
  // مدد الحركة
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
  
  // ظل خاص للبطاقات الإسلامية
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
  
  // ========== الثيم الرئيسي ==========
  
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // الألوان الأساسية
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
    
    // ثيم النصوص
    textTheme: const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelMedium: labelMedium,
    ),
    
    // ثيم الشريط العلوي
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
    
    // ثيم البطاقات - المحافظة على التصميم الحالي
    cardTheme: CardThemeData(
      color: card,
      elevation: elevationSm,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLg),
      ),
      margin: const EdgeInsets.all(space3),
    ),
    
    // ثيم الأزرار - نفس التصميم
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
    
    // ثيم الأيقونات
    iconTheme: const IconThemeData(
      color: textSecondary,
      size: iconMd,
    ),
    
    // ثيم حقول الإدخال
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
    
    // ثيم الحوارات
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
    
    // ثيم القوائم السفلية
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surface,
      elevation: elevationLg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radiusXl),
        ),
      ),
    ),
    
    // ثيم القوائم
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
    
    // ثيم الفواصل
    dividerTheme: const DividerThemeData(
      color: divider,
      thickness: 0.5,
      space: space4,
    ),
    
    // ثيم مؤشرات التقدم
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primary,
      linearTrackColor: divider,
      circularTrackColor: divider,
    ),
    
    // ثيم الـ SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: bodyMedium.copyWith(color: Colors.black),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radiusMd)),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: elevationMd,
    ),
    
    // ثيم الـ FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.black,
      elevation: elevationMd,
    ),
  );
  
  // ========== دوال مساعدة بسيطة ==========
  
  /// ألوان الصلوات
  static const Map<String, Color> prayerColors = {
    'الفجر': Color(0xFF6B7BA8),
    'الشروق': secondary,
    'الظهر': Color(0xFFD08C47),
    'العصر': accent,
    'المغرب': Color(0xFF9B6B9B),
    'العشاء': tertiary,
  };
  
  /// ألوان الفئات
  static const Map<String, Color> categoryColors = {
    'اوقات_الصلاة': primary,
    'الاذكار': accent,
    'القبلة': tertiary,
    'التسبيح': secondary,
    'القران': Color(0xFF4A6B4A),
    'الادعية': Color(0xFF8B7355),
    'المفضلة': Color(0xFFCC8E35),
    'الاعدادات': Color(0xFF6B7BA8),
  };
  
  /// الحصول على لون الصلاة
  static Color getPrayerColor(String prayerName) {
    return prayerColors[prayerName] ?? primary;
  }
  
  /// الحصول على لون الفئة
  static Color getCategoryColor(String categoryId) {
    return categoryColors[categoryId] ?? primary;
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
}

// ========== Extensions بسيطة ومفيدة ==========

extension AppThemeExtensions on BuildContext {
  /// الثيم الحالي
  ThemeData get theme => Theme.of(this);
  
  /// الألوان السريعة
  Color get primaryColor => AppTheme.primary;
  Color get secondaryColor => AppTheme.secondary;
  Color get backgroundColor => AppTheme.background;
  Color get surfaceColor => AppTheme.surface;
  Color get cardColor => AppTheme.card;
  
  /// النصوص السريعة
  TextStyle get headlineLarge => AppTheme.headlineLarge;
  TextStyle get headlineMedium => AppTheme.headlineMedium;
  TextStyle get titleLarge => AppTheme.titleLarge;
  TextStyle get titleMedium => AppTheme.titleMedium;
  TextStyle get bodyLarge => AppTheme.bodyLarge;
  TextStyle get bodyMedium => AppTheme.bodyMedium;
  TextStyle get bodySmall => AppTheme.bodySmall;
  
  /// النصوص الدينية
  TextStyle get quranStyle => AppTheme.quranStyle;
  TextStyle get dhikrStyle => AppTheme.dhikrStyle;
  TextStyle get numbersStyle => AppTheme.numbersStyle;
  
  /// معلومات الشاشة
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  
  /// التحقق من نوع الجهاز
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;
  
  /// الحصول على لون الصلاة
  Color getPrayerColor(String prayerName) => AppTheme.getPrayerColor(prayerName);
  
  /// الحصول على لون الفئة
  Color getCategoryColor(String categoryId) => AppTheme.getCategoryColor(categoryId);
  
  /// الحصول على خلفية دينية
  Color getReligiousBackground(String type) => AppTheme.getReligiousBackground(type);
}

extension AppColorExtensions on Color {
  /// تفتيح اللون
  Color lighten([double amount = 0.1]) => AppTheme.lighten(this, amount);
  
  /// تغميق اللون
  Color darken([double amount = 0.1]) => AppTheme.darken(this, amount);
  
  /// مع شفافية
  Color withAlpha(double alpha) => withValues(alpha: alpha);
}

extension AppSpacingExtensions on double {
  /// تحويل إلى مساحة أفقية
  Widget get w => SizedBox(width: this);
  
  /// تحويل إلى مساحة عمودية
  Widget get h => SizedBox(height: this);
  
  /// تحويل إلى حشو شامل
  EdgeInsets get padding => EdgeInsets.all(this);
  
  /// تحويل إلى حشو أفقي
  EdgeInsets get paddingH => EdgeInsets.symmetric(horizontal: this);
  
  /// تحويل إلى حشو عمودي
  EdgeInsets get paddingV => EdgeInsets.symmetric(vertical: this);
  
  /// تحويل إلى نصف قطر
  BorderRadius get radius => BorderRadius.circular(this);
}

// ========== دوال مساعدة للكروت ==========

/// أدوات مساعدة للكروت الموحدة
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
  
/// الحصول على أيقونة مناسبة للصلوات
static IconData getPrayerIcon(String prayer) {
  switch (prayer.toLowerCase()) {
    case 'الفجر':
    case 'fajr':
      return Icons.wb_twilight;
    case 'الشروق':
    case 'sunrise':
      return Icons.wb_sunny;
    case 'الظهر':
    case 'dhuhr':
      return Icons.light_mode;
    case 'العصر':
    case 'asr':
      return Icons.wb_cloudy;
    case 'المغرب':
    case 'maghrib':
      return Icons.wb_incandescent;
    case 'العشاء':
    case 'isha':
      return Icons.nightlight_round;
    default:
      return Icons.access_time;
  }
}
  
  /// تنسيق الأرقام الكبيرة
  static String formatLargeNumber(int number) {
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
      return '$hoursس $minutesد';
    } else {
      return '$minutesد';
    }
  }
}