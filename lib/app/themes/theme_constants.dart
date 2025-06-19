// lib/app/themes/theme_constants.dart
import 'package:flutter/material.dart';

/// ثوابت الثيم الموحدة - مستقلة وقابلة لإعادة الاستخدام
class ThemeConstants {
  ThemeConstants._();

  // ===== نظام الألوان الموحد =====
  // الألوان الأساسية - الهوية البصرية
  static const Color primary = Color(0xFF5D7052); // أخضر زيتي أنيق
  static const Color primaryLight = Color(0xFF7A8B6F);
  static const Color primaryDark = Color(0xFF445A3B);
  static const Color primarySoft = Color(0xFF8FA584);

  // الألوان الثانوية
  static const Color accent = Color(0xFFB8860B); // ذهبي دافئ
  static const Color accentLight = Color(0xFFDAA520);
  static const Color accentDark = Color(0xFF996515);
  
  static const Color tertiary = Color(0xFF8B6F47); // بني دافئ
  static const Color tertiaryLight = Color(0xFFA68B5B);
  static const Color tertiaryDark = Color(0xFF6B5637);

  // الألوان الدلالية
  static const Color success = Color(0xFF5D7052); // متطابق مع الأساسي للتناسق
  static const Color successLight = Color(0xFF7A8B6F);
  static const Color error = Color(0xFFB85450);
  static const Color warning = Color(0xFFD4A574);
  static const Color warningLight = Color(0xFFE8C899);
  static const Color info = Color(0xFF6B8E9F);
  static const Color infoLight = Color(0xFF8FA9B8);

  // ===== نظام الألوان التكيفي =====
  // الوضع الفاتح
  static const Color lightBackground = Color(0xFFFAFAF8);
  static const Color lightSurface = Color(0xFFF5F5F0);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE0DDD4);
  static const Color lightTextPrimary = Color(0xFF2D2D2D);
  static const Color lightTextSecondary = Color(0xFF5F5F5F);
  static const Color lightTextHint = Color(0xFF8F8F8F);

  // الوضع الداكن
  static const Color darkBackground = Color(0xFF1A1F1A);
  static const Color darkSurface = Color(0xFF242B24);
  static const Color darkCard = Color(0xFF2D352D);
  static const Color darkDivider = Color(0xFF3A453A);
  static const Color darkTextPrimary = Color(0xFFF5F5F0);
  static const Color darkTextSecondary = Color(0xFFBDBDB0);
  static const Color darkTextHint = Color(0xFF8A8A80);

  // ===== نظام النمط =====
  // الخطوط
  static const String fontFamilyArabic = 'Cairo';
  static const String fontFamilyQuran = 'Amiri';
  static const String fontFamily = fontFamilyArabic;

  // أوزان الخطوط
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // أحجام النصوص - نظام موحد
  static const double textSizeXs = 11.0;
  static const double textSizeSm = 12.0;
  static const double textSizeMd = 14.0;
  static const double textSizeLg = 16.0;
  static const double textSizeXl = 18.0;
  static const double textSize2xl = 20.0;
  static const double textSize3xl = 24.0;
  static const double textSize4xl = 28.0;
  static const double textSize5xl = 32.0;

  // ===== نظام المسافات الموحد =====
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

  // ===== نظام الحواف المدورة =====
  static const double radiusNone = 0.0;
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  static const double radius3xl = 28.0;
  static const double radiusFull = 999.0;

  // ===== نظام الحدود =====
  static const double borderNone = 0.0;
  static const double borderThin = 0.5;
  static const double borderLight = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;
  static const double borderHeavy = 3.0;

  // ===== نظام الأبعاد =====
  // الأيقونات
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double icon2xl = 48.0;
  static const double icon3xl = 56.0;

  // الارتفاعات
  static const double heightXs = 32.0;
  static const double heightSm = 36.0;
  static const double heightMd = 40.0;
  static const double heightLg = 48.0;
  static const double heightXl = 56.0;
  static const double height2xl = 64.0;
  static const double height3xl = 72.0;

  // مكونات محددة
  static const double appBarHeight = 64.0;
  static const double bottomNavHeight = 64.0;
  static const double buttonHeight = 52.0;
  static const double inputHeight = 56.0;
  static const double fabSize = 56.0;
  static const double fabSizeMini = 40.0;

  // نقاط التوقف للتصميم المتجاوب
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 1024.0;
  static const double breakpointDesktop = 1440.0;

  // ===== نظام الظلال =====
  static const double elevationNone = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation6 = 6.0;
  static const double elevation8 = 8.0;
  static const double elevation12 = 12.0;
  static const double elevation16 = 16.0;

  // ===== نظام الشفافية =====
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

  // ===== نظام الحركات =====
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationVerySlow = Duration(milliseconds: 600);
  static const Duration durationExtraSlow = Duration(milliseconds: 1000);

  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSharp = Curves.easeInOutCubic;
  static const Curve curveSmooth = Curves.easeInOutQuint;
  static const Curve curveBounce = Curves.elasticOut;
  static const Curve curveOvershoot = Curves.easeOutBack;
  static const Curve curveAnticipate = Curves.easeInBack;

  // ===== نظام التدرجات اللونية =====
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

  static const LinearGradient tertiaryGradient = LinearGradient(
    colors: [tertiaryLight, tertiary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [lightBackground, lightSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [darkBackground, darkSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ===== تدرجات الصلوات =====
  static const LinearGradient fajrGradient = LinearGradient(
    colors: [Color(0xFF445A3B), Color(0xFF5D7052)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient dhuhrGradient = LinearGradient(
    colors: [Color(0xFFDAA520), Color(0xFFB8860B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient asrGradient = LinearGradient(
    colors: [Color(0xFF8FA584), Color(0xFF7A8B6F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient maghribGradient = LinearGradient(
    colors: [Color(0xFFA68B5B), Color(0xFF8B6F47)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient ishaGradient = LinearGradient(
    colors: [Color(0xFF2D352D), Color(0xFF1A1F1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ===== نظام الظلال الجاهزة =====
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: primary.withOpacity(opacity5),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: primary.withOpacity(opacity10),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: primary.withOpacity(opacity10),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowXl = [
    BoxShadow(
      color: primary.withOpacity(opacity20),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  // ===== دوال مساعدة للثيم التكيفي =====
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

  // ===== دوال خاصة بالمحتوى الإسلامي =====
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

  static Color getPrayerColor(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return const Color(0xFF445A3B);
      case 'dhuhr':
      case 'الظهر':
        return const Color(0xFFB8860B);
      case 'asr':
      case 'العصر':
        return const Color(0xFF7A8B6F);
      case 'maghrib':
      case 'المغرب':
        return const Color(0xFF8B6F47);
      case 'isha':
      case 'العشاء':
        return const Color(0xFF2D352D);
      case 'sunrise':
      case 'الشروق':
        return const Color(0xFFDAA520);
      default:
        return primary;
    }
  }

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

  // ===== دوال مساعدة عامة =====
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

  static List<BoxShadow> shadowForElevation(double elevation) {
    if (elevation <= 0) return [];
    if (elevation <= 2) return shadowSm;
    if (elevation <= 4) return shadowMd;
    if (elevation <= 8) return shadowLg;
    return shadowXl;
  }

  static LinearGradient getTimeBasedGradient() {
    final hour = DateTime.now().hour;
    
    if (hour < 5) {
      return LinearGradient(
        colors: [darkCard, darkBackground],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 8) {
      return fajrGradient;
    } else if (hour < 12) {
      return LinearGradient(
        colors: [primaryLight, primarySoft],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 15) {
      return dhuhrGradient;
    } else if (hour < 17) {
      return asrGradient;
    } else if (hour < 20) {
      return maghribGradient;
    } else {
      return ishaGradient;
    }
  }
}