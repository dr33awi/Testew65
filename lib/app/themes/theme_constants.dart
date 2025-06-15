// lib/app/themes/theme_constants.dart
import 'package:flutter/material.dart';

/// ثوابت الثيم الموحد - تصميم عصري 2025
class ThemeConstants {
  ThemeConstants._();

  // ===== الألوان الأساسية - نظام لوني حديث =====
  // اللون الأساسي - أخضر عصري مع تدرجات ناعمة
  static const Color primary = Color(0xFF00C896); // أخضر نابض بالحياة
  static const Color primaryLight = Color(0xFF5EFFC1);
  static const Color primaryDark = Color(0xFF00A076);
  static const Color primaryContainer = Color(0xFFE8FFF7);
  static const Color onPrimaryContainer = Color(0xFF002117);
  
  // اللون الثانوي - بنفسجي عصري
  static const Color secondary = Color(0xFF7C4DFF);
  static const Color secondaryLight = Color(0xFFB47CFF);
  static const Color secondaryDark = Color(0xFF3700B3);
  static const Color secondaryContainer = Color(0xFFF3E5FF);
  static const Color onSecondaryContainer = Color(0xFF21005D);
  
  // اللون الثالث - برتقالي دافئ
  static const Color tertiary = Color(0xFFFF6B6B);
  static const Color tertiaryLight = Color(0xFFFF9999);
  static const Color tertiaryDark = Color(0xFFCC5555);
  static const Color tertiaryContainer = Color(0xFFFFE5E5);
  static const Color onTertiaryContainer = Color(0xFF410E0B);

  // ===== الألوان المحايدة - درجات رمادية حديثة =====
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFFAFBFC); // خلفية فاتحة جداً
  static const Color neutral100 = Color(0xFFF4F6F8);
  static const Color neutral200 = Color(0xFFE9ECEF);
  static const Color neutral300 = Color(0xFFDEE2E6);
  static const Color neutral400 = Color(0xFFCED4DA);
  static const Color neutral500 = Color(0xFFADB5BD);
  static const Color neutral600 = Color(0xFF6C757D);
  static const Color neutral700 = Color(0xFF495057);
  static const Color neutral800 = Color(0xFF343A40);
  static const Color neutral900 = Color(0xFF212529);
  static const Color neutral950 = Color(0xFF0A0D10); // أسود عميق

  // ===== الألوان الدلالية - ألوان حديثة =====
  static const Color success = Color(0xFF10B981); // أخضر زمردي
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);
  static const Color successContainer = Color(0xFFD1FAE5);
  
  static const Color error = Color(0xFFEF4444); // أحمر حديث
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEE2E2);
  
  static const Color warning = Color(0xFFF59E0B); // برتقالي كهرماني
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFEF3C7);
  
  static const Color info = Color(0xFF3B82F6); // أزرق سماوي
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);
  static const Color infoContainer = Color(0xFFDBEAFE);

  // ===== ألوان الوضع الفاتح =====
  static const Color lightBackground = neutral50;
  static const Color lightSurface = neutral0;
  static const Color lightSurfaceVariant = neutral100;
  static const Color lightCard = neutral0;
  static const Color lightDivider = Color(0x1A212529); // 10% opacity
  static const Color lightOutline = neutral300;
  static const Color lightTextPrimary = neutral900;
  static const Color lightTextSecondary = neutral600;
  static const Color lightTextHint = neutral500;
  static const Color lightTextDisabled = neutral400;

  // ===== ألوان الوضع الداكن =====
  static const Color darkBackground = Color(0xFF0F1419); // خلفية داكنة حديثة
  static const Color darkSurface = Color(0xFF1A1F26);
  static const Color darkSurfaceVariant = Color(0xFF22272E);
  static const Color darkCard = Color(0xFF1C2128);
  static const Color darkDivider = Color(0x1AFFFFFF); // 10% opacity
  static const Color darkOutline = Color(0xFF373E47);
  static const Color darkTextPrimary = Color(0xFFF7F9FB);
  static const Color darkTextSecondary = Color(0xFFADBBC6);
  static const Color darkTextHint = Color(0xFF8B98A5);
  static const Color darkTextDisabled = Color(0xFF636E7B);

  // ===== الخطوط =====
  static const String fontFamilyArabic = 'Cairo';
  static const String fontFamilyQuran = 'Amiri';
  static const String fontFamilyEnglish = 'Inter';
  static const String fontFamily = fontFamilyArabic;

  // ===== أوزان الخطوط =====
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ===== أحجام النصوص - نظام حديث =====
  static const double textSizeXs = 11.0;
  static const double textSizeSm = 13.0;
  static const double textSizeMd = 15.0;
  static const double textSizeLg = 17.0;
  static const double textSizeXl = 20.0;
  static const double textSize2xl = 24.0;
  static const double textSize3xl = 30.0;
  static const double textSize4xl = 36.0;
  static const double textSize5xl = 48.0;
  static const double textSize6xl = 60.0;
  static const double textSize7xl = 72.0;

  // ===== المسافات - نظام 4pt محدث =====
  static const double space0 = 0.0;
  static const double space0_5 = 2.0;
  static const double space1 = 4.0;
  static const double space1_5 = 6.0;
  static const double space2 = 8.0;
  static const double space2_5 = 10.0;
  static const double space3 = 12.0;
  static const double space3_5 = 14.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space7 = 28.0;
  static const double space8 = 32.0;
  static const double space9 = 36.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space14 = 56.0;
  static const double space16 = 64.0;
  static const double space20 = 80.0;

  // ===== نصف القطر - أشكال أكثر نعومة =====
  static const double radiusNone = 0.0;
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 28.0;
  static const double radius3xl = 36.0;
  static const double radiusFull = 999.0;

  // ===== الحدود =====
  static const double borderNone = 0.0;
  static const double borderThin = 0.5;
  static const double borderLight = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;
  static const double borderHeavy = 3.0;

  // ===== نقاط التوقف =====
  static const double breakpointMobile = 428.0; // iPhone 14 Pro Max
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1280.0;
  static const double breakpointWide = 1920.0;

  // ===== أحجام الأيقونات =====
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 28.0;
  static const double iconXl = 32.0;
  static const double icon2xl = 40.0;
  static const double icon3xl = 48.0;

  // ===== الارتفاعات =====
  static const double heightXs = 32.0;
  static const double heightSm = 36.0;
  static const double heightMd = 40.0;
  static const double heightLg = 48.0;
  static const double heightXl = 56.0;
  static const double height2xl = 64.0;
  static const double height3xl = 72.0;

  // ===== مكونات خاصة =====
  static const double appBarHeight = 64.0;
  static const double bottomNavHeight = 72.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double fabSize = 56.0;
  static const double chipHeight = 32.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 72.0;

  // ===== الظلال - نظام حديث =====
  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;
  static const double elevation2xl = 24.0;
  
  // Aliases for compatibility
  static const double elevation2 = elevationSm;

  // ===== الشفافية =====
  static const double opacity0 = 0.0;
  static const double opacity5 = 0.05;
  static const double opacity10 = 0.10;
  static const double opacity20 = 0.20;
  static const double opacity30 = 0.30;
  static const double opacity40 = 0.40;
  static const double opacity50 = 0.50;
  static const double opacity60 = 0.60;
  static const double opacity70 = 0.70;
  static const double opacity80 = 0.80;
  static const double opacity90 = 0.90;
  static const double opacity95 = 0.95;
  static const double opacity100 = 1.0;

  // ===== مدد الحركات =====
  static const Duration durationInstant = Duration(milliseconds: 50);
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationXSlow = Duration(milliseconds: 600);

  // ===== منحنيات الحركة =====
  static const Curve curveDefault = Curves.easeInOutCubic;
  static const Curve curveSharp = Curves.easeInOutQuart;
  static const Curve curveSmooth = Curves.easeOutExpo;
  static const Curve curveBounce = Curves.elasticOut;
  static const Curve curveOvershoot = Curves.elasticOut;

  // ===== الظلال الجاهزة - نظام حديث =====
  static List<BoxShadow> get shadowXs => [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: const Color(0x0F000000),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0x05000000),
      blurRadius: 1,
      offset: const Offset(0, 0),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0x05000000),
      blurRadius: 3,
      offset: const Offset(0, 0),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: const Color(0x05000000),
      blurRadius: 6,
      offset: const Offset(0, 0),
    ),
  ];

  static List<BoxShadow> get shadowXl => [
    BoxShadow(
      color: const Color(0x0D000000),
      blurRadius: 30,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: const Color(0x08000000),
      blurRadius: 10,
      offset: const Offset(0, 0),
    ),
  ];

  static List<BoxShadow> get shadow2xl => [
    BoxShadow(
      color: const Color(0x19000000),
      blurRadius: 50,
      offset: const Offset(0, 20),
    ),
  ];

  // ===== ظلال ملونة =====
  static List<BoxShadow> coloredShadow(Color color, {double opacity = 0.3}) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  // ===== الأيقونات =====
  static const IconData iconPrayer = Icons.mosque;
  static const IconData iconAthkar = Icons.auto_awesome;
  static const IconData iconQuran = Icons.menu_book;
  static const IconData iconQibla = Icons.explore;
  static const IconData iconTasbih = Icons.radio_button_checked;
  static const IconData iconDua = Icons.pan_tool;
  static const IconData iconFavorite = Icons.favorite_rounded;
  static const IconData iconFavoriteOutline = Icons.favorite_outline_rounded;
  static const IconData iconShare = Icons.share_rounded;
  static const IconData iconCopy = Icons.content_copy_rounded;
  static const IconData iconSettings = Icons.settings_rounded;
  static const IconData iconNotifications = Icons.notifications_rounded;
  static const IconData iconNotificationsOutline = Icons.notifications_outlined;
  static const IconData iconDarkMode = Icons.dark_mode_rounded;
  static const IconData iconLightMode = Icons.light_mode_rounded;

  // ===== دوال مساعدة =====
  
  /// الحصول على اللون حسب الثيم
  static Color background(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }

  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : lightSurface;
  }

  static Color surfaceVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceVariant
        : lightSurfaceVariant;
  }

  static Color card(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCard
        : lightCard;
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }

  static Color textHint(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextHint
        : lightTextHint;
  }

  static Color divider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkDivider
        : lightDivider;
  }

  static Color outline(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkOutline
        : lightOutline;
  }

  /// ألوان الصلوات - نظام لوني موحد
  static const Map<String, Color> prayerColors = {
    'fajr': Color(0xFF4F46E5), // Indigo
    'sunrise': Color(0xFFF59E0B), // Amber
    'dhuhr': Color(0xFFEAB308), // Yellow
    'asr': Color(0xFF14B8A6), // Teal
    'maghrib': Color(0xFFF97316), // Orange
    'isha': Color(0xFF8B5CF6), // Purple
  };

  static Color getPrayerColor(String name) {
    return prayerColors[name.toLowerCase()] ?? primary;
  }

  /// أيقونات الصلوات
  static IconData getPrayerIcon(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return Icons.nightlight_round;
      case 'sunrise':
      case 'الشروق':
        return Icons.wb_sunny;
      case 'dhuhr':
      case 'الظهر':
        return Icons.wb_sunny_outlined;
      case 'asr':
      case 'العصر':
        return Icons.wb_twilight;
      case 'maghrib':
      case 'المغرب':
        return Icons.wb_twilight_outlined;
      case 'isha':
      case 'العشاء':
        return Icons.bedtime_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  /// الحصول على ظل حسب الارتفاع
  static List<BoxShadow> shadowForElevation(double elevation) {
    if (elevation <= 0) return [];
    if (elevation <= 1) return shadowXs;
    if (elevation <= 2) return shadowSm;
    if (elevation <= 4) return shadowMd;
    if (elevation <= 8) return shadowLg;
    if (elevation <= 16) return shadowXl;
    return shadow2xl;
  }

  /// ألوان التدرج الحديثة
  static List<Color> get primaryGradient => [primary, primaryDark];
  static List<Color> get secondaryGradient => [secondary, secondaryDark];
  static List<Color> get successGradient => [success, successDark];
  static List<Color> get errorGradient => [error, errorDark];
  static List<Color> get warningGradient => [warning, warningDark];
  static List<Color> get infoGradient => [info, infoDark];
  
  /// تدرجات خاصة
  static List<Color> get sunriseGradient => [
    const Color(0xFFFF6B6B),
    const Color(0xFFFFD93D),
  ];
  
  static List<Color> get sunsetGradient => [
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
  ];
  
  static List<Color> get nightGradient => [
    const Color(0xFF2C3E50),
    const Color(0xFF3498DB),
  ];
  
  static List<Color> get oceanGradient => [
    const Color(0xFF2E3192),
    const Color(0xFF1BFFFF),
  ];
}