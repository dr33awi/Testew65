// lib/app/themes/core/app_theme_constants.dart - ثوابت التصميم العربي
import 'package:flutter/material.dart';

/// ثوابت التصميم الإسلامي المحسنة للتطبيقات العربية
class AppThemeConstants {
  AppThemeConstants._();
  
  // ========== المسافات الأساسية ==========
  
  static const double space0 = 0.0;   // بدون مسافة
  static const double space1 = 4.0;   // مسافة صغيرة جداً
  static const double space2 = 8.0;   // مسافة صغيرة
  static const double space3 = 12.0;  // مسافة متوسطة صغيرة
  static const double space4 = 16.0;  // مسافة متوسطة (الأساسية)
  static const double space5 = 20.0;  // مسافة متوسطة كبيرة
  static const double space6 = 24.0;  // مسافة كبيرة
  static const double space8 = 32.0;  // مسافة كبيرة جداً
  static const double space10 = 40.0; // مسافة إضافية
  static const double space12 = 48.0; // مسافة للأقسام
  static const double space16 = 64.0; // مسافة للصفحات
  static const double space20 = 80.0; // مسافة للتخطيطات الكبيرة
  static const double space24 = 96.0; // مسافة للشاشات
  
  // ========== أنصاف الأقطار للعناصر ==========
  
  static const double radiusNone = 0.0;  // بدون انحناء
  static const double radiusXs = 2.0;    // انحناء صغير جداً
  static const double radiusSm = 6.0;    // انحناء صغير
  static const double radiusMd = 10.0;   // انحناء متوسط (الأساسي)
  static const double radiusLg = 14.0;   // انحناء كبير
  static const double radiusXl = 18.0;   // انحناء كبير جداً
  static const double radius2xl = 24.0;  // انحناء إضافي
  static const double radius3xl = 30.0;  // انحناء للعناصر الخاصة
  static const double radiusFull = 1000.0; // دائري كامل
  
  // ========== أحجام الأيقونات ==========
  
  static const double iconXs = 12.0;   // أيقونة صغيرة جداً
  static const double iconSm = 16.0;   // أيقونة صغيرة
  static const double iconMd = 22.0;   // أيقونة متوسطة (الأساسية)
  static const double iconLg = 28.0;   // أيقونة كبيرة
  static const double iconXl = 36.0;   // أيقونة كبيرة جداً
  static const double icon2xl = 48.0;  // أيقونة للعناوين
  static const double icon3xl = 64.0;  // أيقونة للشعارات
  
  // ========== الارتفاعات والظلال ==========
  
  static const double elevationNone = 0.0;  // بدون ارتفاع
  static const double elevationSm = 2.0;    // ارتفاع صغير
  static const double elevationMd = 6.0;    // ارتفاع متوسط
  static const double elevationLg = 12.0;   // ارتفاع كبير
  static const double elevationXl = 20.0;   // ارتفاع كبير جداً
  
  // ========== عرض الحدود ==========
  
  static const double borderWidthNone = 0.0;    // بدون حدود
  static const double borderWidthThin = 0.5;    // حدود رفيعة
  static const double borderWidthNormal = 1.0;  // حدود عادية
  static const double borderWidthThick = 2.0;   // حدود سميكة
  static const double borderWidthExtra = 3.0;   // حدود سميكة جداً
  
  // ========== مستويات الشفافية ==========
  
  static const double opacityDisabled = 0.4;  // شفافية العناصر المعطلة
  static const double opacityMuted = 0.6;     // شفافية العناصر الثانوية
  static const double opacitySubtle = 0.8;    // شفافية خفيفة
  static const double opacityFull = 1.0;      // عدم شفافية
  
  // ========== أوقات الحركة والانتقالات ==========
  
  static const Duration durationFast = Duration(milliseconds: 200);    // حركة سريعة
  static const Duration durationNormal = Duration(milliseconds: 300);  // حركة عادية
  static const Duration durationSlow = Duration(milliseconds: 500);    // حركة بطيئة
  static const Duration durationVerySlow = Duration(milliseconds: 800); // حركة بطيئة جداً
  
  // ========== منحنيات الحركة ==========
  
  static const Curve curveSmooth = Curves.easeInOutCubic;  // منحنى ناعم
  static const Curve curveBounce = Curves.bounceOut;       // منحنى ارتدادي
  static const Curve curveElastic = Curves.elasticOut;     // منحنى مرن
  static const Curve curveQuick = Curves.easeOut;          // منحنى سريع
  
  // ========== أحجام الشاشات للتجاوب ==========
  
  static const double screenMobile = 600.0;   // شاشة الهاتف المحمول
  static const double screenTablet = 1024.0;  // شاشة الجهاز اللوحي
  static const double screenDesktop = 1440.0; // شاشة سطح المكتب
  
  // ========== ارتفاعات الشريط العلوي ==========
  
  static const double appBarHeightSmall = 56.0;    // شريط علوي صغير
  static const double appBarHeightMedium = 64.0;   // شريط علوي متوسط (الأساسي)
  static const double appBarHeightLarge = 72.0;    // شريط علوي كبير
  static const double appBarHeightExtended = 120.0; // شريط علوي ممدد
  
  // ========== ارتفاعات القوائم السفلية ==========
  
  static const double bottomNavHeight = 60.0;           // ارتفاع شريط التنقل السفلي
  static const double bottomSheetMinHeight = 200.0;     // أقل ارتفاع للقائمة السفلية
  static const double bottomSheetMaxHeight = 600.0;     // أعلى ارتفاع للقائمة السفلية
  
  // ========== أحجام الأزرار ==========
  
  static const double buttonHeightSmall = 36.0;   // زر صغير
  static const double buttonHeightMedium = 44.0;  // زر متوسط (الأساسي)
  static const double buttonHeightLarge = 52.0;   // زر كبير
  static const double buttonHeightXLarge = 60.0;  // زر كبير جداً
  
  static const double buttonWidthSmall = 80.0;         // عرض زر صغير
  static const double buttonWidthMedium = 120.0;       // عرض زر متوسط
  static const double buttonWidthLarge = 160.0;        // عرض زر كبير
  static const double buttonWidthFull = double.infinity; // عرض كامل
  
  // ========== أحجام البطاقات ==========
  
  static const double cardMinHeight = 80.0;         // أقل ارتفاع للبطاقة
  static const double cardMaxHeight = 400.0;        // أعلى ارتفاع للبطاقة
  static const double cardDefaultPadding = space4;  // حشو افتراضي للبطاقة
  static const double cardCompactPadding = space3;  // حشو مضغوط للبطاقة
  static const double cardSpaciousPadding = space6; // حشو واسع للبطاقة
  
  // ========== أحجام العناصر الإسلامية المتخصصة ==========
  
  /// أحجام البطاقات الدينية
  static const double quranCardMinHeight = 120.0;   // أقل ارتفاع لبطاقة القرآن
  static const double dhikrCardMinHeight = 100.0;   // أقل ارتفاع لبطاقة الأذكار
  static const double prayerCardHeight = 80.0;      // ارتفاع بطاقة الصلاة
  
  /// أحجام العدادات
  static const double counterSize = 120.0;          // حجم العداد العادي
  static const double counterSizeLarge = 160.0;     // حجم العداد الكبير
  static const double tasbihCounterSize = 200.0;    // حجم عداد التسبيح
  
  /// أحجام الأيقونات الإسلامية
  static const double mosqueIconSize = 32.0;        // أيقونة المسجد
  static const double qiblaIconSize = 48.0;         // أيقونة القبلة
  static const double prayerIconSize = 24.0;        // أيقونة الصلاة
  
  // ========== الأيقونات الإسلامية المعيارية ==========
  
  static const IconData iconHome = Icons.home_rounded;                  // الرئيسية
  static const IconData iconSettings = Icons.settings_rounded;         // الإعدادات
  static const IconData iconNotifications = Icons.notifications_rounded; // الإشعارات
  static const IconData iconPrayerTime = Icons.mosque_rounded;          // أوقات الصلاة
  static const IconData iconAthkar = Icons.menu_book_rounded;           // الأذكار
  static const IconData iconQibla = Icons.explore_rounded;              // القبلة
  static const IconData iconTasbih = Icons.touch_app_rounded;           // التسبيح
  static const IconData iconQuran = Icons.book_rounded;                 // القرآن
  static const IconData iconDua = Icons.favorite_border_rounded;        // الأدعية
  
  // أيقونات إضافية مفيدة
  static const IconData iconCheck = Icons.check_circle_rounded;         // علامة صح
  static const IconData iconError = Icons.error_rounded;                // خطأ
  static const IconData iconWarning = Icons.warning_rounded;            // تحذير
  static const IconData iconInfo = Icons.info_rounded;                  // معلومات
  static const IconData iconShare = Icons.share_rounded;                // مشاركة
  static const IconData iconBookmark = Icons.bookmark_rounded;          // إشارة مرجعية
  static const IconData iconRefresh = Icons.refresh_rounded;            // تحديث
  
  // ========== الظلال المحسنة ==========
  
  /// ظل صغير للعناصر البسيطة
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  /// ظل متوسط للعناصر العادية
  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  /// ظل كبير للعناصر المهمة
  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.16),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  /// ظل خاص للبطاقات الإسلامية
  static List<BoxShadow> get islamicCardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 12,
      offset: const Offset(0, 6),
      spreadRadius: 1,
    ),
  ];
  
  // ========== الحدود المحددة مسبقاً ==========
  
  /// حدود رفيعة
  static Border get borderThin => Border.all(
    color: Colors.grey.withValues(alpha: 0.2),
    width: borderWidthThin,
  );
  
  /// حدود عادية
  static Border get borderNormal => Border.all(
    color: Colors.grey.withValues(alpha: 0.3),
    width: borderWidthNormal,
  );
  
  /// حدود سميكة
  static Border get borderThick => Border.all(
    color: Colors.grey.withValues(alpha: 0.4),
    width: borderWidthThick,
  );
  
  // ========== دوال التجاوب والتكيف ==========
  
  /// تحديد نوع الجهاز بناءً على عرض الشاشة
  static DeviceType getDeviceType(double width) {
    if (width < screenMobile) return DeviceType.mobile;
    if (width < screenTablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }
  
  /// تحديد عدد الأعمدة المناسب للشبكة
  static int getGridColumns(double width) {
    if (width < 400) return 1;      // هواتف صغيرة - عمود واحد
    if (width < 600) return 2;      // هواتف عادية - عمودان
    if (width < 900) return 3;      // أجهزة لوحية صغيرة - ثلاثة أعمدة
    if (width < 1200) return 4;     // أجهزة لوحية كبيرة - أربعة أعمدة
    return 5;                       // سطح المكتب - خمسة أعمدة
  }
  
  /// تحديد المسافة المناسبة حسب نوع الجهاز
  static double getResponsiveSpacing(double width) {
    switch (getDeviceType(width)) {
      case DeviceType.mobile:
        return space3;   // مسافة صغيرة للهواتف
      case DeviceType.tablet:
        return space4;   // مسافة متوسطة للأجهزة اللوحية
      case DeviceType.desktop:
        return space6;   // مسافة كبيرة لسطح المكتب
    }
  }
  
  /// تحديد حجم الخط المناسب حسب نوع الجهاز
  static double getResponsiveFontSize(double width, double baseFontSize) {
    switch (getDeviceType(width)) {
      case DeviceType.mobile:
        return baseFontSize;        // الحجم الأساسي للهواتف
      case DeviceType.tablet:
        return baseFontSize * 1.1;  // أكبر قليلاً للأجهزة اللوحية
      case DeviceType.desktop:
        return baseFontSize * 1.2;  // أكبر لسطح المكتب
    }
  }
  
  /// الحصول على حجم مناسب للعدادات
  static double getCounterSize(double screenWidth) {
    if (screenWidth < 360) return 100.0;      // شاشات صغيرة جداً
    if (screenWidth < 600) return counterSize; // حجم عادي للهواتف
    return counterSizeLarge;                   // حجم كبير للأجهزة اللوحية
  }
  
  /// الحصول على ارتفاع مناسب للبطاقات
  static double getCardHeight(String cardType, double screenWidth) {
    final isLarge = screenWidth > screenMobile;
    
    switch (cardType) {
      case 'قران':
        return isLarge ? quranCardMinHeight * 1.2 : quranCardMinHeight;
      case 'ذكر':
        return isLarge ? dhikrCardMinHeight * 1.2 : dhikrCardMinHeight;
      case 'صلاة':
        return isLarge ? prayerCardHeight * 1.2 : prayerCardHeight;
      default:
        return cardMinHeight;
    }
  }
}

/// أنواع الأجهزة للتجاوب
enum DeviceType {
  mobile,   // الهاتف المحمول
  tablet,   // الجهاز اللوحي
  desktop,  // سطح المكتب
}

/// أحجام مؤشرات التحميل
enum LoadingSize {
  small,   // صغير
  medium,  // متوسط
  large,   // كبير
}

/// أنواع الإشعارات
enum NotificationType {
  success,  // نجاح
  error,    // خطأ
  warning,  // تحذير
  info,     // معلومات
}

/// أنواع البطاقات الإسلامية
enum IslamicCardType {
  quran,    // قرآن
  hadith,   // حديث
  dhikr,    // ذكر
  prayer,   // صلاة
  dua,      // دعاء
  general,  // عام
}

/// Extension methods للمسافات والأحجام
extension SpacingExtensions on double {
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
  
  /// تحويل إلى حشو علوي
  EdgeInsets get paddingTop => EdgeInsets.only(top: this);
  
  /// تحويل إلى حشو سفلي
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: this);
  
  /// تحويل إلى حشو يساري
  EdgeInsets get paddingLeft => EdgeInsets.only(left: this);
  
  /// تحويل إلى حشو يميني
  EdgeInsets get paddingRight => EdgeInsets.only(right: this);
  
  /// تحويل إلى نصف قطر دائري
  BorderRadius get radius => BorderRadius.circular(this);
  
  /// تحويل إلى قيمة نصف قطر
  Radius get radiusValue => Radius.circular(this);
  
  /// تحويل إلى SliverToBoxAdapter مع مساحة عمودية
  Widget get sliverBox => SliverToBoxAdapter(child: SizedBox(height: this));
}

/// Extension methods للعناصر الإسلامية
extension IslamicSpacingExtensions on AppThemeConstants {
  /// الحصول على مسافة مناسبة للمحتوى الديني
  static double getReligiousSpacing(String contentType) {
    switch (contentType) {
      case 'قران':
      case 'آية':
        return AppThemeConstants.space6;  // مسافة أكبر للآيات القرآنية
      case 'ذكر':
      case 'اذكار':
        return AppThemeConstants.space4;  // مسافة متوسطة للأذكار
      case 'حديث':
        return AppThemeConstants.space5;  // مسافة مناسبة للأحاديث
      default:
        return AppThemeConstants.space4;  // المسافة الافتراضية
    }
  }
  
  /// الحصول على نصف قطر مناسب للبطاقات الإسلامية
  static double getIslamicCardRadius(IslamicCardType cardType) {
    switch (cardType) {
      case IslamicCardType.quran:
        return AppThemeConstants.radiusLg;  // انحناء أكبر للقرآن
      case IslamicCardType.prayer:
        return AppThemeConstants.radiusMd;  // انحناء متوسط للصلوات
      default:
        return AppThemeConstants.radiusMd;  // انحناء افتراضي
    }
  }
}

/// مساعدين للتجاوب والتكيف
class ResponsiveHelper {
  ResponsiveHelper._();
  
  /// التحقق من كون الجهاز هاتف محمول
  static bool isMobile(double width) => width < AppThemeConstants.screenMobile;
  
  /// التحقق من كون الجهاز جهاز لوحي
  static bool isTablet(double width) => width >= AppThemeConstants.screenMobile && width < AppThemeConstants.screenTablet;
  
  /// التحقق من كون الجهاز سطح مكتب
  static bool isDesktop(double width) => width >= AppThemeConstants.screenTablet;
  
  /// الحصول على قيمة متجاوبة حسب نوع الجهاز
  static T getResponsiveValue<T>({
    required double screenWidth,
    required T mobile,    // قيمة للهاتف المحمول
    required T tablet,    // قيمة للجهاز اللوحي
    required T desktop,   // قيمة لسطح المكتب
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