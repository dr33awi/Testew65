// lib/app/themes/theme_constants.dart - النسخة المحسنة
import 'package:flutter/material.dart';
import 'core/systems/app_icons_system.dart';

/// ثوابت الثيم - النسخة المحسنة مع تنظيم أفضل ومجموعات منطقية
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

  // قائمة أوزان الخطوط للمطورين
  static const List<FontWeight> fontWeights = [
    light, regular, medium, semiBold, bold
  ];

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

  // مجموعة أحجام النصوص الشائعة
  static const List<double> textSizes = [
    textSizeXs, textSizeSm, textSizeMd, textSizeLg, textSizeXl,
    textSize2xl, textSize3xl, textSize4xl, textSize5xl
  ];

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

  // مجموعة المسافات الشائعة للمطورين
  static const List<double> spaces = [
    space1, space2, space3, space4, space5, space6, space8
  ];

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

  // مجموعة نصف القطر الشائعة
  static const List<double> borderRadii = [
    radiusXs, radiusSm, radiusMd, radiusLg, radiusXl, radius2xl
  ];

  // ===== الحدود =====
  static const double borderNone = 0.0;
  static const double borderThin = 0.5;
  static const double borderLight = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;
  static const double borderHeavy = 3.0;

  // مجموعة سماكات الحدود
  static const List<double> borderWidths = [
    borderThin, borderLight, borderMedium, borderThick, borderHeavy
  ];

  // ===== نقاط التوقف للتصميم المتجاوب =====
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 1024.0;
  static const double breakpointDesktop = 1440.0;
  static const double breakpointWide = 1920.0;
  
  // خريطة نقاط التوقف للمطورين
  static const Map<String, double> breakpoints = {
    'mobile': breakpointMobile,
    'tablet': breakpointTablet,
    'desktop': breakpointDesktop,
    'wide': breakpointWide,
  };
  
  // ===== أحجام الأيقونات =====
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double icon2xl = 48.0;
  static const double icon3xl = 56.0;

  // مجموعة أحجام الأيقونات
  static const List<double> iconSizes = [
    iconXs, iconSm, iconMd, iconLg, iconXl, icon2xl, icon3xl
  ];

  // ===== الارتفاعات =====
  static const double heightXs = 32.0;
  static const double heightSm = 36.0;
  static const double heightMd = 40.0;
  static const double heightLg = 48.0;
  static const double heightXl = 56.0;
  static const double height2xl = 64.0;
  static const double height3xl = 72.0;

  // مجموعة الارتفاعات الشائعة
  static const List<double> heights = [
    heightXs, heightSm, heightMd, heightLg, heightXl, height2xl
  ];

  // ===== مكونات خاصة =====
  static const double appBarHeight = 64.0;
  static const double bottomNavHeight = 64.0;
  static const double buttonHeight = 52.0;
  static const double inputHeight = 56.0;
  static const double fabSize = 56.0;
  static const double fabSizeMini = 40.0;

  // خريطة أحجام المكونات الخاصة
  static const Map<String, double> componentHeights = {
    'appBar': appBarHeight,
    'bottomNav': bottomNavHeight,
    'button': buttonHeight,
    'input': inputHeight,
    'fab': fabSize,
    'fabMini': fabSizeMini,
  };

  // ===== الارتفاعات (Material Design) =====
  static const double elevationNone = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation6 = 6.0;
  static const double elevation8 = 8.0;
  static const double elevation12 = 12.0;
  static const double elevation16 = 16.0;

  // مجموعة الارتفاعات المادية
  static const List<double> elevations = [
    elevationNone, elevation1, elevation2, elevation4, 
    elevation6, elevation8, elevation12, elevation16
  ];

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

  // مجموعة مستويات الشفافية الشائعة
  static const List<double> opacities = [
    opacity10, opacity20, opacity30, opacity50, opacity70, opacity90
  ];

  // خريطة الشفافية مع الأسماء
  static const Map<String, double> opacityLevels = {
    'subtle': opacity10,
    'light': opacity30,
    'medium': opacity50,
    'strong': opacity70,
    'intense': opacity90,
  };

  // ===== مدد الحركات =====
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationVerySlow = Duration(milliseconds: 600);
  static const Duration durationExtraSlow = Duration(milliseconds: 1000);

  // مجموعة مدد الحركات الشائعة
  static const List<Duration> animationDurations = [
    durationInstant, durationFast, durationNormal, 
    durationSlow, durationVerySlow
  ];

  // خريطة مدد الحركات مع الأسماء
  static const Map<String, Duration> durations = {
    'instant': durationInstant,
    'fast': durationFast,
    'normal': durationNormal,
    'slow': durationSlow,
    'verySlow': durationVerySlow,
    'extraSlow': durationExtraSlow,
  };

  // ===== منحنيات الحركة =====
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSharp = Curves.easeInOutCubic;
  static const Curve curveSmooth = Curves.easeInOutQuint;
  static const Curve curveBounce = Curves.elasticOut;
  static const Curve curveOvershoot = Curves.easeOutBack;
  static const Curve curveAnticipate = Curves.easeInBack;

  // مجموعة منحنيات الحركة الشائعة
  static const List<Curve> animationCurves = [
    curveDefault, curveSharp, curveSmooth, curveBounce
  ];

  // خريطة منحنيات الحركة مع الأسماء
  static const Map<String, Curve> curves = {
    'default': curveDefault,
    'sharp': curveSharp,
    'smooth': curveSmooth,
    'bounce': curveBounce,
    'overshoot': curveOvershoot,
    'anticipate': curveAnticipate,
  };

  // ===== Avatar Sizes =====
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 64.0;

  // مجموعة أحجام الصور الشخصية
  static const List<double> avatarSizes = [
    avatarSm, avatarMd, avatarLg, avatarXl
  ];

  // ===== ثوابت التطبيق =====
  static const String athkarNotificationChannel = 'athkar_channel';
  static const String prayerNotificationChannel = 'prayer_channel';
  
  // ===== ثوابت الوقت =====
  static const Duration defaultCacheDuration = Duration(hours: 24);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  
  // ===== إعدادات البطارية =====
  static const int defaultMinBatteryLevel = 15;
  static const int criticalBatteryLevel = 5;

  // ===== مجموعات منطقية للمطورين =====
  
  /// مجموعة القيم الشائعة للتطوير السريع
  static const Map<String, List<double>> commonValues = {
    'spaces': spaces,
    'textSizes': textSizes,
    'iconSizes': iconSizes,
    'borderRadii': borderRadii,
    'elevations': elevations,
    'opacities': opacities,
  };

  /// إعدادات افتراضية مُجمعة
  static const Map<String, double> defaults = {
    'space': space4,
    'textSize': textSizeMd,
    'iconSize': iconMd,
    'borderRadius': radiusMd,
    'elevation': elevation2,
    'opacity': opacity50,
    'borderWidth': borderLight,
  };

  // ===== دوال مساعدة محسنة =====

  /// الحصول على مسافة حسب الاسم
  static double getSpace(String name) {
    switch (name.toLowerCase()) {
      case 'xs': case 'tiny': return space1;
      case 'sm': case 'small': return space2;
      case 'md': case 'medium': return space4;
      case 'lg': case 'large': return space6;
      case 'xl': case 'xlarge': return space8;
      default: return space4; // افتراضي
    }
  }

  /// الحصول على حجم نص حسب الاسم
  static double getTextSize(String name) {
    switch (name.toLowerCase()) {
      case 'xs': case 'tiny': return textSizeXs;
      case 'sm': case 'small': return textSizeSm;
      case 'md': case 'medium': return textSizeMd;
      case 'lg': case 'large': return textSizeLg;
      case 'xl': case 'xlarge': return textSizeXl;
      case '2xl': case 'xxlarge': return textSize2xl;
      case '3xl': case 'xxxlarge': return textSize3xl;
      default: return textSizeMd;
    }
  }

  /// الحصول على حجم أيقونة حسب الاسم
  static double getIconSize(String name) {
    switch (name.toLowerCase()) {
      case 'xs': case 'tiny': return iconXs;
      case 'sm': case 'small': return iconSm;
      case 'md': case 'medium': return iconMd;
      case 'lg': case 'large': return iconLg;
      case 'xl': case 'xlarge': return iconXl;
      case '2xl': case 'xxlarge': return icon2xl;
      default: return iconMd;
    }
  }

  /// الحصول على مدة حركة حسب الاسم
  static Duration getDuration(String name) {
    return durations[name.toLowerCase()] ?? durationNormal;
  }

  /// الحصول على منحنى حركة حسب الاسم
  static Curve getCurve(String name) {
    return curves[name.toLowerCase()] ?? curveDefault;
  }

  /// التحقق من صحة القيم
  static bool isValidSpace(double value) {
    return spaces.contains(value);
  }

  static bool isValidTextSize(double value) {
    return textSizes.contains(value);
  }

  static bool isValidOpacity(double value) {
    return value >= 0.0 && value <= 1.0;
  }

  /// إنشاء EdgeInsets من قيمة واحدة
  static EdgeInsets createPadding(double value) {
    return EdgeInsets.all(value);
  }

  /// إنشاء EdgeInsets غير متماثل
  static EdgeInsets createAsymmetricPadding({
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
    }
    
    return EdgeInsets.only(
      left: left ?? 0,
      top: top ?? 0,
      right: right ?? 0,
      bottom: bottom ?? 0,
    );
  }

  /// إنشاء BorderRadius من قيمة واحدة
  static BorderRadius createBorderRadius(double value) {
    return BorderRadius.circular(value);
  }

  /// إنشاء BorderRadius غير متماثل
  static BorderRadius createAsymmetricBorderRadius({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? 0),
      topRight: Radius.circular(topRight ?? 0),
      bottomLeft: Radius.circular(bottomLeft ?? 0),
      bottomRight: Radius.circular(bottomRight ?? 0),
    );
  }

  // ===== دوال الأيقونات - تستدعي AppIconsSystem =====
  
  /// الحصول على أيقونة حسب اسم الصلاة (للتوافق مع الإصدارات القديمة)
  /// يُنصح باستخدام AppIconsSystem.getPrayerIcon() مباشرة
  @Deprecated('استخدم AppIconsSystem.getPrayerIcon() بدلاً من ذلك')
  static IconData getPrayerIcon(String name) {
    return AppIconsSystem.getPrayerIcon(name);
  }

  /// الحصول على أيقونة حسب الفئة (للتوافق مع الإصدارات القديمة)
  /// يُنصح باستخدام AppIconsSystem.getCategoryIcon() مباشرة
  @Deprecated('استخدم AppIconsSystem.getCategoryIcon() بدلاً من ذلك')
  static IconData getCategoryIcon(String categoryId) {
    return AppIconsSystem.getCategoryIcon(categoryId);
  }

  // ===== دوال التحليل والإحصائيات =====

  /// الحصول على إحصائيات الثوابت
  static Map<String, int> getConstantsStats() {
    return {
      'spaces': spaces.length,
      'textSizes': textSizes.length,
      'iconSizes': iconSizes.length,
      'borderRadii': borderRadii.length,
      'elevations': elevations.length,
      'opacities': opacities.length,
      'durations': durations.length,
      'curves': curves.length,
    };
  }

  /// البحث في الثوابت
  static Map<String, dynamic> searchConstants(String query) {
    final results = <String, dynamic>{};
    final lowerQuery = query.toLowerCase();

    // البحث في المسافات
    for (final space in spaces) {
      if (space.toString().contains(lowerQuery)) {
        results['space_$space'] = space;
      }
    }

    // البحث في أحجام النصوص
    for (final size in textSizes) {
      if (size.toString().contains(lowerQuery)) {
        results['textSize_$size'] = size;
      }
    }

    // يمكن إضافة المزيد من عمليات البحث هنا

    return results;
  }
}