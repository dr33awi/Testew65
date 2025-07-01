// lib/app/themes/theme_constants.dart - النسخة المبسطة (بدون ألوان)
import 'package:flutter/material.dart';
import 'core/systems/app_color_system.dart';

/// ثوابت الثيم - المقاييس والأحجام والأيقونات فقط
/// الألوان منقولة إلى AppColorSystem
class ThemeConstants {
  ThemeConstants._();

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

  // ===== المسافات =====
  static const double space0 = 0.0;
  static const double space1 = 4.0;   // xs
  static const double space2 = 8.0;   // sm
  static const double space3 = 12.0;  // md
  static const double space4 = 16.0;  // lg
  static const double space5 = 20.0;  // xl
  static const double space6 = 24.0;  // 2xl
  static const double space8 = 32.0;  // 3xl
  static const double space10 = 40.0; // 4xl
  static const double space12 = 48.0; // 5xl
  static const double space16 = 64.0; // 6xl

  // ===== نصف القطر =====
  static const double radiusNone = 0.0;
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  static const double radius3xl = 28.0;
  static const double radiusFull = 999.0;

  // ===== الحدود =====
  static const double borderNone = 0.0;
  static const double borderThin = 0.5;
  static const double borderLight = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;
  static const double borderHeavy = 3.0;

  // ===== نقاط التوقف للتصميم المتجاوب =====
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 1024.0;
  static const double breakpointDesktop = 1440.0;
  static const double breakpointWide = 1920.0;
  
  // ===== أحجام الأيقونات =====
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double icon2xl = 48.0;
  static const double icon3xl = 56.0;

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
  static const double bottomNavHeight = 64.0;
  static const double buttonHeight = 52.0;
  static const double inputHeight = 56.0;
  static const double fabSize = 56.0;
  static const double fabSizeMini = 40.0;

  // ===== الظلال =====
  static const double elevationNone = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation6 = 6.0;
  static const double elevation8 = 8.0;
  static const double elevation12 = 12.0;
  static const double elevation16 = 16.0;

  // ===== الشفافية =====
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

  // ===== مدد الحركات =====
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationVerySlow = Duration(milliseconds: 600);
  static const Duration durationExtraSlow = Duration(milliseconds: 1000);

  // ===== منحنيات الحركة =====
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSharp = Curves.easeInOutCubic;
  static const Curve curveSmooth = Curves.easeInOutQuint;
  static const Curve curveBounce = Curves.elasticOut;
  static const Curve curveOvershoot = Curves.easeOutBack;
  static const Curve curveAnticipate = Curves.easeInBack;

  // ===== الظلال الجاهزة =====
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: AppColorSystem.primary.withValues(alpha: opacity5),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: AppColorSystem.primary.withValues(alpha: opacity10),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: AppColorSystem.primary.withValues(alpha: opacity10),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowXl = [
    BoxShadow(
      color: AppColorSystem.primary.withValues(alpha: opacity20),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> shadowInner = [
    BoxShadow(
      color: AppColorSystem.primary.withValues(alpha: opacity10),
      blurRadius: 4,
      offset: const Offset(0, -2),
      spreadRadius: -2,
    ),
  ];

  // ===== الأيقونات =====
  static const IconData iconPrayer = Icons.mosque;
  static const IconData iconPrayerTime = Icons.access_time;
  static const IconData iconQibla = Icons.explore;
  static const IconData iconAdhan = Icons.volume_up;

  static const IconData iconAthkar = Icons.menu_book;
  static const IconData iconMorningAthkar = Icons.wb_sunny;
  static const IconData iconEveningAthkar = Icons.nights_stay;
  static const IconData iconSleepAthkar = Icons.bedtime;

  static const IconData iconFavorite = Icons.favorite;
  static const IconData iconFavoriteOutline = Icons.favorite_border;
  static const IconData iconShare = Icons.share;
  static const IconData iconCopy = Icons.content_copy;
  static const IconData iconSettings = Icons.settings;
  static const IconData iconNotifications = Icons.notifications;

  // ===== Avatar Sizes =====
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 64.0;

  // ===== ثوابت الإشعارات =====
  static const String athkarNotificationChannel = 'athkar_channel';
  static const String prayerNotificationChannel = 'prayer_channel';
  
  // ===== ثوابت الوقت =====
  static const Duration defaultCacheDuration = Duration(hours: 24);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  
  // ===== إعدادات البطارية =====
  static const int defaultMinBatteryLevel = 15;
  static const int criticalBatteryLevel = 5;

  // ===== دوال الألوان - تستدعي AppColorSystem =====
  
  /// الحصول على اللون حسب الثيم
  static Color background(BuildContext context) => AppColorSystem.getBackground(context);
  static Color surface(BuildContext context) => AppColorSystem.getSurface(context);
  static Color card(BuildContext context) => AppColorSystem.getCard(context);
  static Color textPrimary(BuildContext context) => AppColorSystem.getTextPrimary(context);
  static Color textSecondary(BuildContext context) => AppColorSystem.getTextSecondary(context);
  static Color divider(BuildContext context) => AppColorSystem.getDivider(context);

  // ===== دوال الصلوات - تستدعي AppColorSystem =====
  
  /// الحصول على لون حسب اسم الصلاة
  static Color getPrayerColor(String name) => AppColorSystem.getPrayerColor(name);
  
  /// الحصول على تدرج حسب وقت الصلاة
  static LinearGradient prayerGradient(String prayerName) => AppColorSystem.getPrayerGradient(prayerName);
  
  /// الحصول على تدرج حسب الوقت
  static LinearGradient getTimeBasedGradient() => AppColorSystem.getTimeBasedGradient();

  /// الحصول على أيقونة حسب اسم الصلاة
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

  // ===== دوال التدرجات - تستدعي AppColorSystem =====
  
  /// الحصول على تدرج خلفية الأذكار حسب الوضع
  static LinearGradient getAthkarBackgroundGradient(BuildContext context) => 
      AppColorSystem.getAthkarBackgroundGradient(context);

  /// الحصول على تدرج خلفية التطبيق
  static LinearGradient getAppBackgroundGradient(BuildContext context) => 
      AppColorSystem.getAppBackgroundGradient(context);

  /// إنشاء تدرج مخصص
  static LinearGradient customGradient({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
  }) => AppColorSystem.customGradient(
    colors: colors,
    begin: begin,
    end: end,
    stops: stops,
  );

  /// الحصول على ظل حسب الارتفاع
  static List<BoxShadow> shadowForElevation(double elevation) {
    if (elevation <= 0) return [];
    if (elevation <= 2) return shadowSm;
    if (elevation <= 4) return shadowMd;
    if (elevation <= 8) return shadowLg;
    return shadowXl;
  }
}