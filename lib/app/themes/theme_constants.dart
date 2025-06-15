// lib/app/themes/theme_constants.dart
import 'package:flutter/material.dart';

/// كل ثوابت الثيم في ملف واحد
class ThemeConstants {
  ThemeConstants._();

  // ===== الألوان الأساسية =====
  static const Color primary = Color(0xFF0B8457);
  static const Color primaryLight = Color(0xFF1FA06D);
  static const Color primaryDark = Color(0xFF076842);
  static const Color primarySoft = Color(0xFF4DB381);

  // ===== الألوان الثانوية =====
  static const Color accent = Color(0xFF2ECC71);
  static const Color accentLight = Color(0xFF5DADE2);
  static const Color accentDark = Color(0xFF27AE60);

  // ===== الألوان الدلالية =====
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);

  // ===== ألوان الوضع الفاتح =====
  static const Color lightBackground = Color(0xFFFCFDFC);
  static const Color lightSurface = Color(0xFFF5FAF8);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextHint = Color(0xFF9E9E9E);

  // ===== ألوان الوضع الداكن =====
  static const Color darkBackground = Color(0xFF0A1F17);
  static const Color darkSurface = Color(0xFF0D2920);
  static const Color darkCard = Color(0xFF122A20);
  static const Color darkDivider = Color(0xFF2A3F35);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkTextHint = Color(0xFF757575);

  // ===== ألوان خاصة =====
  static const Color athkarBackground = Color(0xFFF0F9F4);
  static const Color prayerActive = Color(0xFF1FA06D);
  static const Color qiblaAccent = Color(0xFF0B8457);
  static const Color tasbihAccent = Color(0xFF4DB381);

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
  static const double radiusFull = 999.0;

  // ===== الحدود =====
  static const double borderNone = 0.0;
  static const double borderThin = 0.5;
  static const double borderLight = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;

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
  static const Duration durationVerySlow = Duration(milliseconds: 600);
  static const Duration durationExtraSlow = Duration(milliseconds: 1000);

  // ===== منحنيات الحركة =====
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSharp = Curves.easeInOutCubic;
  static const Curve curveSmooth = Curves.easeInOutQuint;
  static const Curve curveBounce = Curves.elasticOut;
  static const Curve curveOvershoot = Curves.easeOutBack;
  static const Curve curveAnticipate = Curves.easeInBack;

  // ===== التدرجات اللونية =====
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentLight, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرجات الصلاة
  static const LinearGradient fajrGradient = LinearGradient(
    colors: [Color(0xFF2C5F7C), Color(0xFF6A8CAF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient dhuhrGradient = LinearGradient(
    colors: [Color(0xFFFFD662), Color(0xFFFFAA00)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient asrGradient = LinearGradient(
    colors: [Color(0xFFFF8C42), Color(0xFFFF6B6B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient maghribGradient = LinearGradient(
    colors: [Color(0xFF355C7D), Color(0xFF6C5B7B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient ishaGradient = LinearGradient(
    colors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ===== خرائط الألوان والأيقونات للصلوات =====
  static const Map<String, Color> _prayerColorMap = {
    'fajr': Color(0xFF1A237E),
    'dhuhr': Color(0xFFFF6F00),
    'asr': Color(0xFF00897B),
    'maghrib': Color(0xFFE65100),
    'isha': Color(0xFF4A148C),
    'sunrise': Color(0xFFFFB300),
    'الفجر': Color(0xFF1A237E),
    'الظهر': Color(0xFFFF6F00),
    'العصر': Color(0xFF00897B),
    'المغرب': Color(0xFFE65100),
    'العشاء': Color(0xFF4A148C),
    'الشروق': Color(0xFFFFB300),
  };

  static const Map<String, IconData> _prayerIconMap = {
    'fajr': Icons.dark_mode,
    'dhuhr': Icons.light_mode,
    'asr': Icons.wb_cloudy,
    'maghrib': Icons.wb_twilight,
    'isha': Icons.bedtime,
    'sunrise': Icons.wb_sunny,
    'الفجر': Icons.dark_mode,
    'الظهر': Icons.light_mode,
    'العصر': Icons.wb_cloudy,
    'المغرب': Icons.wb_twilight,
    'العشاء': Icons.bedtime,
    'الشروق': Icons.wb_sunny,
  };

  // ===== الظلال الجاهزة =====
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withOpacity(opacity10),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withOpacity(opacity10),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withOpacity(opacity10),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Colors.black.withOpacity(opacity20),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // ===== الأيقونات =====
  // أيقونات الصلاة
  static const IconData iconPrayer = Icons.mosque;
  static const IconData iconPrayerTime = Icons.access_time;
  static const IconData iconQibla = Icons.explore;
  static const IconData iconAdhan = Icons.volume_up;

  // أيقونات الأذكار
  static const IconData iconAthkar = Icons.menu_book;
  static const IconData iconMorningAthkar = Icons.wb_sunny;
  static const IconData iconEveningAthkar = Icons.nights_stay;
  static const IconData iconSleepAthkar = Icons.bedtime;

  // أيقونات عامة
  static const IconData iconFavorite = Icons.favorite;
  static const IconData iconFavoriteOutline = Icons.favorite_border;
  static const IconData iconShare = Icons.share;
  static const IconData iconCopy = Icons.content_copy;
  static const IconData iconSettings = Icons.settings;
  static const IconData iconNotifications = Icons.notifications;

  // ===== Avatar Sizes (من reusable_components) =====
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 64.0;

  // ===== ثوابت الإشعارات (من app_constants) =====
  static const String athkarNotificationChannel = 'athkar_channel';
  static const String prayerNotificationChannel = 'prayer_channel';
  
  // ===== ثوابت الوقت =====
  static const Duration defaultCacheDuration = Duration(hours: 24);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  
  // ===== إعدادات البطارية =====
  static const int defaultMinBatteryLevel = 15;
  static const int criticalBatteryLevel = 5;

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

  /// الحصول على تدرج حسب وقت الصلاة
  static LinearGradient prayerGradient(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return fajrGradient;
      case 'dhuhr':
      case 'الظهر':
        return dhuhrGradient;
      case 'asr':
      case 'العصر':
        return asrGradient;
      case 'maghrib':
      case 'المغرب':
        return maghribGradient;
      case 'isha':
      case 'العشاء':
        return ishaGradient;
      default:
        return primaryGradient;
    }
  }

  /// الحصول على لون حسب اسم الصلاة
  static Color getPrayerColor(String name) {
    return _prayerColorMap[name.toLowerCase()] ?? const Color(0xFF607D8B);
  }

  /// الحصول على أيقونة حسب اسم الصلاة
  static IconData getPrayerIcon(String name) {
    return _prayerIconMap[name.toLowerCase()] ?? Icons.access_time;
  }

  /// إنشاء تدرج مخصص
  static LinearGradient customGradient({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
    );
  }

  /// الحصول على ظل حسب الارتفاع
  static List<BoxShadow> shadowForElevation(double elevation) {
    if (elevation <= 0) return [];
    if (elevation <= 2) return shadowSm;
    if (elevation <= 4) return shadowMd;
    if (elevation <= 8) return shadowLg;
    return shadowXl;
  }
}