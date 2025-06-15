// lib/app/themes/theme_constants.dart
import 'package:flutter/material.dart';

/// ثوابت الثيم الموحد - تصميم احترافي بالأخضر الزيتي
class ThemeConstants {
  ThemeConstants._();

  // ===== الألوان الأساسية - الأخضر الزيتي الاحترافي =====
  // اللون الأساسي - أخضر زيتي أنيق
  static const Color primary = Color(0xFF5D7052); // أخضر زيتي رئيسي
  static const Color primaryLight = Color(0xFF8B9F7E); // أخضر زيتي فاتح
  static const Color primaryDark = Color(0xFF3E4A36); // أخضر زيتي داكن
  static const Color primaryContainer = Color(0xFFF0F4ED); // خلفية فاتحة بلمسة خضراء
  static const Color onPrimaryContainer = Color(0xFF1A2016); // نص على الخلفية الفاتحة
  
  // اللون الثانوي - ذهبي دافئ مكمل للأخضر الزيتي
  static const Color secondary = Color(0xFFB8860B); // ذهبي داكن
  static const Color secondaryLight = Color(0xFFDAA520); // ذهبي فاتح
  static const Color secondaryDark = Color(0xFF8B6914); // ذهبي عميق
  static const Color secondaryContainer = Color(0xFFFFF8E7); // خلفية ذهبية فاتحة
  static const Color onSecondaryContainer = Color(0xFF2A1F00); // نص على الخلفية الذهبية
  
  // اللون الثالث - بني دافئ
  static const Color tertiary = Color(0xFF8B6F47); // بني دافئ
  static const Color tertiaryLight = Color(0xFFA0826D); // بني فاتح
  static const Color tertiaryDark = Color(0xFF5D4E37); // بني داكن
  static const Color tertiaryContainer = Color(0xFFF5E6D3); // خلفية بنية فاتحة
  static const Color onTertiaryContainer = Color(0xFF1F1710); // نص على الخلفية البنية

  // ===== الألوان المحايدة - درجات طبيعية =====
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFFAFBF8); // خلفية فاتحة بلمسة دافئة
  static const Color neutral100 = Color(0xFFF5F6F3);
  static const Color neutral200 = Color(0xFFEBEDE8);
  static const Color neutral300 = Color(0xFFDFE2DB);
  static const Color neutral400 = Color(0xFFCED3C7);
  static const Color neutral500 = Color(0xFFADB5A3);
  static const Color neutral600 = Color(0xFF7C8471);
  static const Color neutral700 = Color(0xFF545B4B);
  static const Color neutral800 = Color(0xFF3A4034);
  static const Color neutral900 = Color(0xFF252921);
  static const Color neutral950 = Color(0xFF141613); // أسود بلمسة خضراء

  // ===== الألوان الدلالية - ألوان طبيعية =====
  static const Color success = Color(0xFF4A7C59); // أخضر نجاح طبيعي
  static const Color successLight = Color(0xFF6B9B7B);
  static const Color successDark = Color(0xFF2F5233);
  static const Color successContainer = Color(0xFFE8F5E9);
  
  static const Color error = Color(0xFFB74C4C); // أحمر طبيعي
  static const Color errorLight = Color(0xFFD47070);
  static const Color errorDark = Color(0xFF8B3A3A);
  static const Color errorContainer = Color(0xFFFDEDED);
  
  static const Color warning = Color(0xFFCC9900); // برتقالي ذهبي
  static const Color warningLight = Color(0xFFE6B333);
  static const Color warningDark = Color(0xFF996600);
  static const Color warningContainer = Color(0xFFFFF4CC);
  
  static const Color info = Color(0xFF5C7893); // أزرق رمادي
  static const Color infoLight = Color(0xFF7A95AF);
  static const Color infoDark = Color(0xFF3E5266);
  static const Color infoContainer = Color(0xFFE8F0F7);

  // ===== ألوان الوضع الفاتح =====
  static const Color lightBackground = Color(0xFFFAFBF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F6F3);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0x1A252921); // 10% opacity
  static const Color lightOutline = Color(0xFFDFE2DB);
  static const Color lightTextPrimary = Color(0xFF252921);
  static const Color lightTextSecondary = Color(0xFF545B4B);
  static const Color lightTextHint = Color(0xFF7C8471);
  static const Color lightTextDisabled = Color(0xFFADB5A3);

  // ===== ألوان الوضع الداكن =====
  static const Color darkBackground = Color(0xFF0E110D); // خلفية داكنة بلمسة خضراء
  static const Color darkSurface = Color(0xFF1A1D18);
  static const Color darkSurfaceVariant = Color(0xFF232621);
  static const Color darkCard = Color(0xFF1F221C);
  static const Color darkDivider = Color(0x1AFFFFFF); // 10% opacity
  static const Color darkOutline = Color(0xFF3A4034);
  static const Color darkTextPrimary = Color(0xFFF5F6F3);
  static const Color darkTextSecondary = Color(0xFFCED3C7);
  static const Color darkTextHint = Color(0xFFADB5A3);
  static const Color darkTextDisabled = Color(0xFF7C8471);

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

  // ===== أحجام النصوص - نظام متدرج =====
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

  // ===== المسافات - نظام 4pt =====
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

  // ===== نصف القطر - أشكال ناعمة =====
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
  static const double breakpointMobile = 428.0;
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

  // ===== الظلال =====
  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;
  static const double elevation2xl = 24.0;
  static const double elevation2 = elevationSm;

  // ===== الشفافية =====
  static const double opacity0 = 0.0;
  static const double opacity5 = 0.05;
  static const double opacity10 = 0.10;
  static const double opacity15 = 0.15;
  static const double opacity20 = 0.20;
  static const double opacity25 = 0.25;
  static const double opacity30 = 0.30;
  static const double opacity40 = 0.40;
  static const double opacity50 = 0.50;
  static const double opacity60 = 0.60;
  static const double opacity70 = 0.70;
  static const double opacity80 = 0.80;
  static const double opacity85 = 0.85;
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

  // ===== الظلال الجاهزة - أنيقة وناعمة =====
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

  /// ألوان الصلوات - ألوان طبيعية متناسقة
  static const Map<String, Color> prayerColors = {
    'fajr': Color(0xFF4A7C59), // أخضر فجر
    'sunrise': Color(0xFFCC9900), // ذهبي شروق
    'dhuhr': Color(0xFFB8860B), // ذهبي ظهر
    'asr': Color(0xFF8B6F47), // بني عصر
    'maghrib': Color(0xFFB74C4C), // أحمر مغرب
    'isha': Color(0xFF5C7893), // أزرق عشاء
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

  /// ألوان التدرج الأنيقة
  static List<Color> get primaryGradient => [primary, primaryDark];
  static List<Color> get secondaryGradient => [secondary, secondaryDark];
  static List<Color> get successGradient => [success, successDark];
  static List<Color> get errorGradient => [error, errorDark];
  static List<Color> get warningGradient => [warning, warningDark];
  static List<Color> get infoGradient => [info, infoDark];
  
  /// تدرجات خاصة بتصميم احترافي
  static List<Color> get sunriseGradient => [
    const Color(0xFFDAA520),
    const Color(0xFFCC9900),
  ];
  
  static List<Color> get sunsetGradient => [
    const Color(0xFFB74C4C),
    const Color(0xFF8B3A3A),
  ];
  
  static List<Color> get nightGradient => [
    const Color(0xFF3E4A36),
    const Color(0xFF252921),
  ];
  
  static List<Color> get natureGradient => [
    const Color(0xFF5D7052),
    const Color(0xFF3E4A36),
  ];
}