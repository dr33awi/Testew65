// lib/app/themes/core/app_theme_constants.dart (محسن ومبسط)
import 'package:flutter/material.dart';

/// ثوابت التصميم الإسلامي المحسنة - مع الحفاظ على الأسماء الأصلية
class AppThemeConstants {
  AppThemeConstants._();
  
  // ========== المسافات المحسنة والمبسطة ==========
  
  static const double space0 = 0.0;
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;   // حذف space7 لتبسيط
  static const double space10 = 40.0;  // إضافة مفيدة
  static const double space12 = 48.0;
  static const double space16 = 64.0;
  static const double space20 = 80.0;
  static const double space24 = 96.0;
  
  // ========== أنصاف الأقطار المحسنة ==========
  
  static const double radiusNone = 0.0;
  static const double radiusXs = 2.0;
  static const double radiusSm = 6.0;    // محسن من 4 للمظهر الأفضل
  static const double radiusMd = 10.0;   // محسن من 8
  static const double radiusLg = 14.0;   // محسن من 12
  static const double radiusXl = 18.0;   // محسن من 16
  static const double radius2xl = 24.0;  // محسن من 20
  static const double radius3xl = 30.0;  // محسن من 24
  static const double radiusFull = 1000.0; // مبسط من 9999
  
  // ========== أحجام الأيقونات المحسنة ==========
  
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 22.0;     // محسن من 20
  static const double iconLg = 28.0;     // محسن من 24
  static const double iconXl = 36.0;     // محسن من 32
  static const double icon2xl = 48.0;
  static const double icon3xl = 64.0;
  
  // ========== الارتفاعات المبسطة ==========
  
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 6.0;    // محسن من 4
  static const double elevationLg = 12.0;   // محسن من 8
  static const double elevationXl = 20.0;   // محسن من 12
  // حذف الارتفاعات الإضافية لتبسيط
  
  // ========== عرض الحدود المحسنة ==========
  
  static const double borderWidthNone = 0.0;
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double borderWidthThick = 2.0;
  static const double borderWidthExtra = 3.0;   // محسن من 4
  
  // ========== الشفافية المبسطة ==========
  
  static const double opacityDisabled = 0.4;
  static const double opacityMuted = 0.6;
  static const double opacitySubtle = 0.8;
  static const double opacityFull = 1.0;
  
  // ========== أوقات الحركة المحسنة ==========
  
  static const Duration durationFast = Duration(milliseconds: 200);    // محسن من 150
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800); // محسن من 1000
  
  // ========== منحنيات الحركة المبسطة ==========
  
  static const Curve curveSmooth = Curves.easeInOutCubic;
  static const Curve curveBounce = Curves.bounceOut;
  static const Curve curveElastic = Curves.elasticOut;
  static const Curve curveQuick = Curves.easeOut;      // جديد للحركات السريعة
  
  // ========== أحجام الشاشات المحسنة ==========
  
  static const double screenMobile = 600.0;    // مبسط
  static const double screenTablet = 1024.0;   // مبسط
  static const double screenDesktop = 1440.0;  // مبسط
  
  // ========== ارتفاعات الشريط العلوي ==========
  
  static const double appBarHeightSmall = 56.0;
  static const double appBarHeightMedium = 64.0;   // الأكثر استخداماً
  static const double appBarHeightLarge = 72.0;
  static const double appBarHeightExtended = 120.0;
  
  // ========== ارتفاعات القوائم السفلية ==========
  
  static const double bottomNavHeight = 60.0;
  static const double bottomSheetMinHeight = 200.0;
  static const double bottomSheetMaxHeight = 600.0;
  
  // ========== أحجام الأزرار المحسنة ==========
  
  static const double buttonHeightSmall = 36.0;    // محسن من 32
  static const double buttonHeightMedium = 44.0;   // محسن من 40
  static const double buttonHeightLarge = 52.0;    // محسن من 48
  static const double buttonHeightXLarge = 60.0;   // محسن من 56
  
  static const double buttonWidthSmall = 80.0;
  static const double buttonWidthMedium = 120.0;
  static const double buttonWidthLarge = 160.0;
  static const double buttonWidthFull = double.infinity;
  
  // ========== أحجام البطاقات المحسنة ==========
  
  static const double cardMinHeight = 80.0;
  static const double cardMaxHeight = 400.0;
  static const double cardDefaultPadding = space4;
  static const double cardCompactPadding = space3;
  static const double cardSpaciousPadding = space6;
  
  // ========== أحجام خاصة للتطبيق الإسلامي (جديدة) ==========
  
  /// أحجام البطاقات الدينية
  static const double quranCardMinHeight = 120.0;
  static const double dhikrCardMinHeight = 100.0;
  static const double prayerCardHeight = 80.0;
  
  /// أحجام العدادات
  static const double counterSize = 120.0;
  static const double counterSizeLarge = 160.0;
  static const double tasbihCounterSize = 200.0;
  
  /// أحجام الأيقونات الإسلامية
  static const double mosqueIconSize = 32.0;
  static const double qiblaIconSize = 48.0;
  static const double prayerIconSize = 24.0;
  
  // ========== الأيقونات الإسلامية المحسنة ==========
  
  static const IconData iconHome = Icons.home_rounded;
  static const IconData iconSettings = Icons.settings_rounded;
  static const IconData iconNotifications = Icons.notifications_rounded;
  static const IconData iconPrayerTime = Icons.mosque_rounded;      // محسن
  static const IconData iconAthkar = Icons.menu_book_rounded;       // محسن
  static const IconData iconQibla = Icons.explore_rounded;          // محسن
  static const IconData iconTasbih = Icons.touch_app_rounded;       // محسن
  static const IconData iconQuran = Icons.book_rounded;             // محسن
  static const IconData iconDua = Icons.favorite_border_rounded;    // محسن
  
  // أيقونات إضافية مفيدة
  static const IconData iconCheck = Icons.check_circle_rounded;
  static const IconData iconError = Icons.error_rounded;
  static const IconData iconWarning = Icons.warning_rounded;
  static const IconData iconInfo = Icons.info_rounded;
  static const IconData iconShare = Icons.share_rounded;
  static const IconData iconBookmark = Icons.bookmark_rounded;
  static const IconData iconRefresh = Icons.refresh_rounded;
  
  // ========== الظلال المحسنة والمبسطة ==========
  
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),   // محسن
      blurRadius: 4,                                  // محسن
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),   // محسن
      blurRadius: 8,                                  // محسن
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.16),   // محسن
      blurRadius: 16,                                 // محسن
      offset: const Offset(0, 8),
    ),
  ];
  
  // ظلال خاصة للبطاقات الإسلامية (جديدة)
  static List<BoxShadow> get islamicCardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 12,
      offset: const Offset(0, 6),
      spreadRadius: 1,
    ),
  ];
  
  // ========== الحدود المحسنة ==========
  
  static Border get borderThin => Border.all(
    color: Colors.grey.withValues(alpha: 0.2),     // محسن
    width: borderWidthThin,
  );
  
  static Border get borderNormal => Border.all(
    color: Colors.grey.withValues(alpha: 0.3),     // محسن
    width: borderWidthNormal,
  );
  
  static Border get borderThick => Border.all(
    color: Colors.grey.withValues(alpha: 0.4),     // محسن
    width: borderWidthThick,
  );
  
  // ========== دوال التجاوب المحسنة ==========
  
  /// تحديد نوع الجهاز بناءً على العرض (مبسط)
  static DeviceType getDeviceType(double width) {
    if (width < screenMobile) return DeviceType.mobile;
    if (width < screenTablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }
  
  /// تحديد عدد الأعمدة بناءً على العرض (محسن)
  static int getGridColumns(double width) {
    if (width < 400) return 1;      // هواتف صغيرة
    if (width < 600) return 2;      // هواتف عادية
    if (width < 900) return 3;      // تابلت صغير
    if (width < 1200) return 4;     // تابلت كبير
    return 5;                       // سطح المكتب
  }
  
  /// تحديد المسافة بناءً على نوع الجهاز (محسن)
  static double getResponsiveSpacing(double width) {
    switch (getDeviceType(width)) {
      case DeviceType.mobile:
        return space3;
      case DeviceType.tablet:
        return space4;
      case DeviceType.desktop:
        return space6;
    }
  }
  
  /// تحديد حجم الخط بناءً على نوع الجهاز (محسن)
  static double getResponsiveFontSize(double width, double baseFontSize) {
    switch (getDeviceType(width)) {
      case DeviceType.mobile:
        return baseFontSize;
      case DeviceType.tablet:
        return baseFontSize * 1.1;
      case DeviceType.desktop:
        return baseFontSize * 1.2;
    }
  }
  
  /// الحصول على حجم مناسب للعدادات (جديد)
  static double getCounterSize(double screenWidth) {
    if (screenWidth < 360) return 100.0;     // شاشات صغيرة
    if (screenWidth < 600) return counterSize; // عادي
    return counterSizeLarge;                   // كبير للتابلت
  }
  
  /// الحصول على ارتفاع مناسب للبطاقات (جديد)
  static double getCardHeight(String cardType, double screenWidth) {
    final isLarge = screenWidth > screenMobile;
    
    switch (cardType) {
      case 'quran':
        return isLarge ? quranCardMinHeight * 1.2 : quranCardMinHeight;
      case 'dhikr':
        return isLarge ? dhikrCardMinHeight * 1.2 : dhikrCardMinHeight;
      case 'prayer':
        return isLarge ? prayerCardHeight * 1.2 : prayerCardHeight;
      default:
        return cardMinHeight;
    }
  }
}

/// أنواع الأجهزة (مبسط)
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// أحجام التحميل
enum LoadingSize {
  small,
  medium,
  large,
}

/// أنواع الإشعارات
enum NotificationType {
  success,
  error,
  warning,
  info,
}

/// أنواع البطاقات الإسلامية (جديد)
enum IslamicCardType {
  quran,
  hadith,
  dhikr,
  prayer,
  dua,
  general,
}

/// Extension methods للمسافات (محسنة ومبسطة)
extension SpacingExtensions on double {
  /// تحويل إلى SizedBox أفقي
  Widget get w => SizedBox(width: this);
  
  /// تحويل إلى SizedBox عمودي
  Widget get h => SizedBox(height: this);
  
  /// تحويل إلى Padding
  EdgeInsets get padding => EdgeInsets.all(this);
  EdgeInsets get paddingH => EdgeInsets.symmetric(horizontal: this);
  EdgeInsets get paddingV => EdgeInsets.symmetric(vertical: this);
  EdgeInsets get paddingTop => EdgeInsets.only(top: this);
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: this);
  EdgeInsets get paddingLeft => EdgeInsets.only(left: this);
  EdgeInsets get paddingRight => EdgeInsets.only(right: this);
  
  /// تحويل إلى BorderRadius
  BorderRadius get radius => BorderRadius.circular(this);
  Radius get radiusValue => Radius.circular(this);
  
  /// تحويل إلى SliverToBoxAdapter مع SizedBox
  Widget get sliverBox => SliverToBoxAdapter(child: SizedBox(height: this));
}

/// Extension methods للألوان الإسلامية (جديدة)
extension IslamicSpacingExtensions on AppThemeConstants {
  /// الحصول على مسافة مناسبة للمحتوى الديني
  static double getReligiousSpacing(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'quran':
      case 'ayah':
        return AppThemeConstants.space6;  // مسافة أكبر للآيات
      case 'dhikr':
      case 'adhkar':
        return AppThemeConstants.space4;  // مسافة متوسطة للأذكار
      case 'hadith':
        return AppThemeConstants.space5;  // مسافة مناسبة للأحاديث
      default:
        return AppThemeConstants.space4;  // المسافة الافتراضية
    }
  }
  
  /// الحصول على نصف قطر مناسب للبطاقات الإسلامية
  static double getIslamicCardRadius(IslamicCardType cardType) {
    switch (cardType) {
      case IslamicCardType.quran:
        return AppThemeConstants.radiusLg;  // أكبر للقرآن
      case IslamicCardType.prayer:
        return AppThemeConstants.radiusMd;  // متوسط للصلوات
      default:
        return AppThemeConstants.radiusMd;  // افتراضي
    }
  }
}

/// مساعدين للتجاوب (محسنة)
class ResponsiveHelper {
  ResponsiveHelper._();
  
  /// التحقق من نوع الجهاز
  static bool isMobile(double width) => width < AppThemeConstants.screenMobile;
  static bool isTablet(double width) => width >= AppThemeConstants.screenMobile && width < AppThemeConstants.screenTablet;
  static bool isDesktop(double width) => width >= AppThemeConstants.screenTablet;
  
  /// الحصول على قيمة متجاوبة
  static T getResponsiveValue<T>({
    required double screenWidth,
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isMobile(screenWidth)) return mobile;
    if (isTablet(screenWidth)) return tablet;
    return desktop;
  }
  
  /// الحصول على عدد الأعمدة المناسب للشبكة
  static int getResponsiveColumns(double screenWidth, {int maxColumns = 4}) {
    final columns = AppThemeConstants.getGridColumns(screenWidth);
    return columns > maxColumns ? maxColumns : columns;
  }
}