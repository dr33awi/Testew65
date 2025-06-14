// lib/app/themes/theme_constants.dart
import 'package:flutter/material.dart';

/// ثوابت الثيم الموحد - نظام تصميم بسيط وأنيق
class ThemeConstants {
  ThemeConstants._();

  // ===== الألوان الأساسية (مبسطة) =====
  // لون أساسي واحد مع تدرجاته
  static const Color primary = Color(0xFF0B8457); // أخضر إسلامي أنيق
  static const Color primaryLight = Color(0xFF4DB381);
  static const Color primaryDark = Color(0xFF076842);
  
  // ===== الألوان المحايدة (للخلفيات والنصوص) =====
  static const Color neutral0 = Color(0xFFFFFFFF); // أبيض نقي
  static const Color neutral50 = Color(0xFFFAFAFA); // خلفية التطبيق
  static const Color neutral100 = Color(0xFFF5F5F5); // خلفية ثانوية
  static const Color neutral200 = Color(0xFFEEEEEE); // حدود وفواصل
  static const Color neutral300 = Color(0xFFE0E0E0); // حدود داكنة
  static const Color neutral400 = Color(0xFFBDBDBD); // أيقونات غير نشطة
  static const Color neutral500 = Color(0xFF9E9E9E); // نص ثانوي
  static const Color neutral600 = Color(0xFF757575); // نص ثانوي داكن
  static const Color neutral700 = Color(0xFF616161); // نص عادي
  static const Color neutral800 = Color(0xFF424242); // نص رئيسي
  static const Color neutral900 = Color(0xFF212121); // نص العناوين

  // ===== الألوان الدلالية (بسيطة) =====
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ===== ألوان الوضع الفاتح =====
  static const Color lightBackground = neutral50;
  static const Color lightSurface = neutral0;
  static const Color lightCard = neutral0;
  static const Color lightDivider = neutral200;
  static const Color lightTextPrimary = neutral900;
  static const Color lightTextSecondary = neutral600;
  static const Color lightTextHint = neutral500;

  // ===== ألوان الوضع الداكن =====
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF252525);
  static const Color darkDivider = Color(0xFF373737);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  static const Color darkTextHint = Color(0xFF757575);

  // ===== الخطوط =====
  static const String fontFamilyArabic = 'Cairo';
  static const String fontFamilyQuran = 'Amiri';
  static const String fontFamily = fontFamilyArabic;

  // ===== أوزان الخطوط =====
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ===== أحجام النصوص =====
  static const double textSizeXs = 11.0;
  static const double textSizeSm = 12.0;
  static const double textSizeMd = 14.0;
  static const double textSizeLg = 16.0;
  static const double textSizeXl = 18.0;
  static const double textSize2xl = 20.0;
  static const double textSize3xl = 24.0;
  static const double textSize4xl = 28.0;
  static const double textSize5xl = 32.0;

  // ===== المسافات (نظام 4pt) =====
  static const double space0 = 0.0;
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;

  // ===== نصف القطر =====
  static const double radiusNone = 0.0;
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 999.0;

  // ===== الحدود =====
  static const double borderNone = 0.0;
  static const double borderThin = 0.5;
  static const double borderLight = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;

  // ===== نقاط التوقف =====
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 1024.0;
  static const double breakpointDesktop = 1440.0;

  // ===== أحجام الأيقونات =====
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 28.0;
  static const double iconXl = 32.0;
  static const double icon2xl = 40.0;

  // ===== الارتفاعات =====
  static const double heightXs = 32.0;
  static const double heightSm = 36.0;
  static const double heightMd = 40.0;
  static const double heightLg = 48.0;
  static const double heightXl = 56.0;
  static const double height2xl = 64.0;

  // ===== مكونات خاصة =====
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 56.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double fabSize = 56.0;

  // ===== الظلال (مبسطة) =====
  static const double elevationNone = 0.0;
  static const double elevationSm = 1.0;
  static const double elevationMd = 2.0;
  static const double elevationLg = 4.0;
  static const double elevationXl = 8.0;
  static const double elevation2 = 2.0;
  // ===== الشفافية =====
  static const double opacity5 = 0.05;
  static const double opacity10 = 0.10;
  static const double opacity20 = 0.20;
  static const double opacity30 = 0.30;
  static const double opacity50 = 0.50;
  static const double opacity70 = 0.70;
  static const double opacity90 = 0.90;

  // ===== مدد الحركات =====
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 400);

  // ===== منحنيات الحركة =====
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSharp = Curves.easeInOutCubic;
  static const Curve curveSmooth = Curves.easeOutCubic;

  // ===== الظلال الجاهزة (مبسطة) =====
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withOpacity(0.07),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // ===== الأيقونات =====
  static const IconData iconPrayer = Icons.mosque;
  static const IconData iconAthkar = Icons.auto_awesome;
  static const IconData iconQuran = Icons.menu_book;
  static const IconData iconQibla = Icons.explore;
  static const IconData iconTasbih = Icons.radio_button_checked;
  static const IconData iconDua = Icons.pan_tool;
  static const IconData iconFavorite = Icons.favorite;
  static const IconData iconFavoriteOutline = Icons.favorite_border;
  static const IconData iconShare = Icons.share;
  static const IconData iconCopy = Icons.content_copy;
  static const IconData iconSettings = Icons.settings;
  static const IconData iconNotifications = Icons.notifications;

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

  static Color divider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkDivider
        : lightDivider;
  }

  /// ألوان مخصصة للأقسام (بسيطة)
  static Color getSectionColor(String sectionId) {
    switch (sectionId) {
      case 'prayer_times':
        return primary;
      case 'athkar':
        return success;
      case 'quran':
        return info;
      case 'qibla':
        return warning;
      case 'tasbih':
        return primary;
      case 'dua':
        return info;
      default:
        return primary;
    }
  }

  /// الحصول على ظل حسب الارتفاع
  static List<BoxShadow> shadowForElevation(double elevation) {
    if (elevation <= 0) return [];
    if (elevation <= 2) return shadowSm;
    if (elevation <= 4) return shadowMd;
    return shadowLg;
  }

  /// ألوان الصلوات (بسيطة وموحدة)
  static Color getPrayerColor(String name) {
    // استخدام نفس اللون الأساسي مع تدرجات خفيفة
    return primary;
  }

  /// أيقونات الصلوات
  static IconData getPrayerIcon(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return Icons.dark_mode;
      case 'dhuhr':
      case 'الظهر':
        return Icons.light_mode;
      case 'asr':
      case 'العصر':
        return Icons.wb_cloudy;
      case 'maghrib':
      case 'المغرب':
        return Icons.wb_twilight;
      case 'isha':
      case 'العشاء':
        return Icons.bedtime;
      case 'sunrise':
      case 'الشروق':
        return Icons.wb_sunny;
      default:
        return Icons.access_time;
    }
  }
}