// lib/app/themes/theme_constants.dart - مُحدث مع خلفية التطبيق المناسبة
import 'package:flutter/material.dart';

/// كل ثوابت الثيم في ملف واحد
class ThemeConstants {
  ThemeConstants._();

  // ===== الألوان الأساسية - الهوية البصرية الجديدة =====
  static const Color primary = Color(0xFF5D7052); // أخضر زيتي أنيق
  static const Color primaryLight = Color(0xFF7A8B6F); // أخضر زيتي فاتح
  static const Color primaryDark = Color(0xFF445A3B); // أخضر زيتي داكن
  static const Color primarySoft = Color(0xFF8FA584); // أخضر زيتي ناعم

  // ===== الألوان الثانوية =====
  static const Color accent = Color(0xFFB8860B); // ذهبي دافئ
  static const Color accentLight = Color(0xFFDAA520); // ذهبي فاتح
  static const Color accentDark = Color(0xFF996515); // ذهبي داكن
  
  // ===== اللون الثالث - البني المحدث =====
  static const Color tertiary = Color(0xFF8B6F47); // بني دافئ - اللون الأساسي
  static const Color tertiaryLight = Color(0xFFA68B5B); // بني فاتح
  static const Color tertiaryDark = Color(0xFF6B5637); // بني داكن
  static const Color tertiarySoft = Color(0xFFB8A082); // بني ناعم - إضافة جديدة

  // ===== الألوان الدلالية =====
  static const Color success = Color(0xFF5D7052); // نفس اللون الأساسي للتناسق
  static const Color successLight = Color(0xFF7A8B6F); // أخضر زيتي فاتح للنجاح
  static const Color error = Color(0xFFB85450); // أحمر مخملي ناعم
  static const Color warning = Color(0xFFD4A574); // برتقالي دافئ
  static const Color warningLight = Color(0xFFE8C899); // برتقالي فاتح للتحذير
  static const Color info = Color(0xFF6B8E9F); // أزرق رمادي
  static const Color infoLight = Color(0xFF8FA9B8); // أزرق رمادي فاتح للمعلومات

  // ===== خلفيات التطبيق المحدثة =====
  
  // خلفية التطبيق الرئيسية - لون دافئ وهادئ يتناسب مع الهوية
  static const Color appBackground = Color(0xFFF8F6F0); // بيج فاتح دافئ
  static const Color appBackgroundSecondary = Color(0xFFF2F0E8); // بيج أغمق قليلاً
  
  // خلفيات الوضع الليلي الدافئة
  static const Color darkAppBackground = Color(0xFF1C1F1B); // خلفية ليلية دافئة
  static const Color darkAppBackgroundSecondary = Color(0xFF252A24); // خلفية ليلية ثانوية
  
  // ===== ألوان الوضع الفاتح - محدثة =====
  static const Color lightBackground = appBackground; // استخدام خلفية التطبيق الجديدة
  static const Color lightSurface = Color(0xFFF5F3EB); // سطح دافئ متناسق
  static const Color lightCard = Color(0xFFFFFFFF); // بطاقات بيضاء
  static const Color lightDivider = Color(0xFFE0DDD4); // فواصل دافئة
  static const Color lightTextPrimary = Color(0xFF2D2D2D); // نص أساسي
  static const Color lightTextSecondary = Color(0xFF5F5F5F); // نص ثانوي
  static const Color lightTextHint = Color(0xFF8F8F8F); // نص تلميحي

  // ===== ألوان الوضع الداكن - محدثة ودافئة =====
  static const Color darkBackground = Color(0xFF1C1F1B); // خلفية داكنة دافئة بلمسة خضراء
  static const Color darkSurface = Color(0xFF252A24); // سطح داكن دافئ
  static const Color darkCard = Color(0xFF2E342D); // بطاقات داكنة دافئة
  static const Color darkDivider = Color(0xFF3C453B); // فواصل داكنة مع دفء
  static const Color darkTextPrimary = Color(0xFFF7F5F0); // نص فاتح دافئ
  static const Color darkTextSecondary = Color(0xFFC0BDB0); // نص ثانوي دافئ
  static const Color darkTextHint = Color(0xFF8D8A80); // نص تلميحي دافئ

  // ===== ألوان خاصة بالميزات =====
  static const Color athkarBackground = Color(0xFFF0F4EC); // خلفية الأذكار
  static const Color prayerActive = Color(0xFF5D7052); // الصلاة النشطة
  static const Color qiblaAccent = Color(0xFFB8860B); // لون القبلة
  static const Color tasbihAccent = Color(0xFF8B6F47); // لون التسبيح

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

  // ===== التدرجات اللونية المحدثة =====
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

  // تدرجات خاصة بالخلفيات - محدثة مع خلفية التطبيق الجديدة
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      appBackground,
      appBackgroundSecondary,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // تدرج خلفية ليلية محدث ودافئ
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF1C1F1B), // الخلفية الداكنة الجديدة
      Color(0xFF252A24), // السطح الداكن الجديد
      Color(0xFF2E342D), // لون البطاقات الداكن
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.6, 1.0],
  );

  // تدرج خلفية ناعم لصفحات خاصة
  static const LinearGradient softBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFFFBF9F3), // أفتح
      appBackground,     // الأساسي
      appBackgroundSecondary, // أغمق قليلاً
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  // تدرج خلفية للأذكار
  static const LinearGradient athkarBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFFF5F3EB),
      athkarBackground,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // تدرج خلفية الأذكار للوضع الليلي
  static const LinearGradient darkAthkarBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF252A24), // سطح داكن دافئ
      Color(0xFF2E342D), // بطاقات داكنة دافئة
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ===== التدرجات المحدثة للصلوات =====
  static const LinearGradient fajrGradient = LinearGradient(
    colors: [Color(0xFF5D7052), Color(0xFF445A3B)], // أخضر زيتي
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dhuhrGradient = LinearGradient(
    colors: [Color(0xFFDAA520), Color(0xFFB8860B)], // ذهبي
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient asrGradient = LinearGradient(
    colors: [Color(0xFF8FA584), Color(0xFF7A8B6F)], // أخضر زيتي فاتح
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient maghribGradient = LinearGradient(
    colors: [Color(0xFFA68B5B), Color(0xFF8B6F47)], // بني دافئ متدرج
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ishaGradient = LinearGradient(
    colors: [Color(0xFF3A453A), Color(0xFF2D352D)], // داكن أنيق
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    colors: [Color(0xFFE8C899), Color(0xFFDAA520)], // ذهبي فاتح
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== الظلال الجاهزة المحسنة =====
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

  static List<BoxShadow> shadowInner = [
    BoxShadow(
      color: primary.withOpacity(opacity10),
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

  // ===== دوال مساعدة محدثة =====
  
  /// الحصول على خلفية التطبيق الرئيسية
  static Color getAppBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkAppBackground  // الخلفية الليلية الدافئة الجديدة
        : appBackground; // استخدام خلفية التطبيق الجديدة
  }

  /// الحصول على خلفية التطبيق الثانوية
  static Color getAppBackgroundSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkAppBackgroundSecondary // الخلفية الليلية الثانوية الجديدة
        : appBackgroundSecondary;
  }
  
  /// الحصول على اللون حسب الثيم
  static Color background(BuildContext context) {
    return getAppBackground(context);
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

  /// الحصول على تدرج خلفية الأذكار حسب الوضع
  static LinearGradient getAthkarBackgroundGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkAthkarBackgroundGradient
        : athkarBackgroundGradient;
  }

  /// الحصول على تدرج خلفية التطبيق
  static LinearGradient getAppBackgroundGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackgroundGradient
        : backgroundGradient;
  }

  /// الحصول على تدرج ناعم للخلفية
  static LinearGradient getSoftBackgroundGradient(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      // تدرج ليلي ناعم ودافئ
      return const LinearGradient(
        colors: [
          Color(0xFF1C1F1B), // الأساسي
          Color(0xFF252A24), // متوسط
          Color(0xFF2E342D), // أغمق
          Color(0xFF363D35), // الأغمق للعمق
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.3, 0.7, 1.0],
      );
    }
    return softBackgroundGradient;
  }

  /// الحصول على تدرج حسب وقت الصلاة - محدث
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
      case 'sunrise':
      case 'الشروق':
        return sunriseGradient;
      default:
        return primaryGradient;
    }
  }

  /// الحصول على لون حسب اسم الصلاة - محدث
  static Color getPrayerColor(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return const Color(0xFF5D7052);
      case 'dhuhr':
      case 'الظهر':
        return const Color(0xFFB8860B);
      case 'asr':
      case 'العصر':
        return const Color(0xFF7A8B6F);
      case 'maghrib':
      case 'المغرب':
        return tertiary;
      case 'isha':
      case 'العشاء':
        return const Color(0xFF3A453A);
      case 'sunrise':
      case 'الشروق':
        return const Color(0xFFDAA520);
      default:
        return primary;
    }
  }

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

  /// الحصول على تدرج حسب الوقت
  static LinearGradient getTimeBasedGradient() {
    final hour = DateTime.now().hour;
    
    if (hour < 5) {
      return const LinearGradient(
        colors: [darkCard, darkBackground],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 8) {
      return fajrGradient;
    } else if (hour < 12) {
      return const LinearGradient(
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