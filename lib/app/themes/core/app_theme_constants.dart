// lib/app/themes/core/app_theme_constants.dart
import 'package:flutter/material.dart';

/// ثوابت التصميم الموحدة للتطبيق
class AppThemeConstants {
  AppThemeConstants._();
  
  // ========== المسافات ==========
  
  static const double space0 = 0.0;
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space7 = 28.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  static const double space16 = 64.0;
  static const double space20 = 80.0;
  static const double space24 = 96.0;
  
  // ========== أنصاف الأقطار ==========
  
  static const double radiusNone = 0.0;
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 20.0;
  static const double radius3xl = 24.0;
  static const double radiusFull = 9999.0;
  
  // ========== أحجام الأيقونات ==========
  
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double icon2xl = 48.0;
  static const double icon3xl = 64.0;
  
  // ========== الارتفاعات (Elevations) ==========
  
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 12.0;
  static const double elevation2xl = 16.0;
  static const double elevation3xl = 24.0;
  
  // ========== عرض الحدود ==========
  
  static const double borderWidthNone = 0.0;
  static const double borderWidthThin = 0.5;
  static const double borderWidthNormal = 1.0;
  static const double borderWidthThick = 2.0;
  static const double borderWidthExtra = 4.0;
  
  // ========== الشفافية ==========
  
  static const double opacityDisabled = 0.4;
  static const double opacityMuted = 0.6;
  static const double opacitySubtle = 0.8;
  static const double opacityFull = 1.0;
  
  // ========== أوقات الحركة ==========
  
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 1000);
  
  // ========== منحنيات الحركة ==========
  
  static const Curve curveLinear = Curves.linear;
  static const Curve curveEase = Curves.ease;
  static const Curve curveEaseIn = Curves.easeIn;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveEaseInOut = Curves.easeInOut;
  static const Curve curveSmooth = Curves.easeInOutCubic;
  static const Curve curveBounce = Curves.bounceOut;
  static const Curve curveElastic = Curves.elasticOut;
  
  // ========== أحجام الشاشات ==========
  
  static const double screenXs = 480.0;   // الهواتف الصغيرة
  static const double screenSm = 640.0;   // الهواتف الكبيرة
  static const double screenMd = 768.0;   // الأجهزة اللوحية الصغيرة
  static const double screenLg = 1024.0;  // الأجهزة اللوحية الكبيرة
  static const double screenXl = 1280.0;  // سطح المكتب الصغير
  static const double screen2xl = 1536.0; // سطح المكتب الكبير
  
  // ========== ارتفاعات الشريط العلوي ==========
  
  static const double appBarHeightSmall = 56.0;
  static const double appBarHeightMedium = 64.0;
  static const double appBarHeightLarge = 72.0;
  static const double appBarHeightExtended = 120.0;
  
  // ========== ارتفاعات القوائم السفلية ==========
  
  static const double bottomNavHeight = 60.0;
  static const double bottomSheetMinHeight = 200.0;
  static const double bottomSheetMaxHeight = 600.0;
  
  // ========== أحجام الأزرار ==========
  
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightMedium = 40.0;
  static const double buttonHeightLarge = 48.0;
  static const double buttonHeightXLarge = 56.0;
  
  static const double buttonWidthSmall = 80.0;
  static const double buttonWidthMedium = 120.0;
  static const double buttonWidthLarge = 160.0;
  static const double buttonWidthFull = double.infinity;
  
  // ========== أحجام البطاقات ==========
  
  static const double cardMinHeight = 80.0;
  static const double cardMaxHeight = 400.0;
  static const double cardDefaultPadding = space4;
  static const double cardCompactPadding = space3;
  static const double cardSpaciousPadding = space6;
  
  // ========== أحجام الصور ==========
  
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeXLarge = 96.0;
  
  static const double iconContainerSizeSmall = 40.0;
  static const double iconContainerSizeMedium = 56.0;
  static const double iconContainerSizeLarge = 72.0;
  static const double iconContainerSizeXLarge = 96.0;
  
  // ========== الحد الأقصى للعرض ==========
  
  static const double maxWidthContent = 1200.0;
  static const double maxWidthCard = 400.0;
  static const double maxWidthDialog = 600.0;
  static const double maxWidthSidebar = 300.0;
  
  // ========== الأيقونات الافتراضية ==========
  
  static const IconData iconHome = Icons.home_rounded;
  static const IconData iconSettings = Icons.settings_rounded;
  static const IconData iconSearch = Icons.search_rounded;
  static const IconData iconNotifications = Icons.notifications_rounded;
  static const IconData iconProfile = Icons.person_rounded;
  static const IconData iconBack = Icons.arrow_back_rounded;
  static const IconData iconForward = Icons.arrow_forward_rounded;
  static const IconData iconClose = Icons.close_rounded;
  static const IconData iconCheck = Icons.check_rounded;
  static const IconData iconAdd = Icons.add_rounded;
  static const IconData iconRemove = Icons.remove_rounded;
  static const IconData iconEdit = Icons.edit_rounded;
  static const IconData iconDelete = Icons.delete_rounded;
  static const IconData iconShare = Icons.share_rounded;
  static const IconData iconFavorite = Icons.favorite_rounded;
  static const IconData iconBookmark = Icons.bookmark_rounded;
  static const IconData iconDownload = Icons.download_rounded;
  static const IconData iconUpload = Icons.upload_rounded;
  static const IconData iconRefresh = Icons.refresh_rounded;
  static const IconData iconSync = Icons.sync_rounded;
  static const IconData iconInfo = Icons.info_rounded;
  static const IconData iconWarning = Icons.warning_rounded;
  static const IconData iconError = Icons.error_rounded;
  static const IconData iconSuccess = Icons.check_circle_rounded;
  
  // أيقونات التطبيق المخصصة
  static const IconData iconPrayerTime = Icons.mosque_rounded;
  static const IconData iconAthkar = Icons.menu_book_rounded;
  static const IconData iconQibla = Icons.explore_rounded;
  static const IconData iconTasbih = Icons.touch_app_rounded;
  static const IconData iconQuran = Icons.book_rounded;
  static const IconData iconDua = Icons.favorite_rounded;
  
  // ========== الظلال المحددة مسبقاً ==========
  
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 6,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 12,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 20,
      offset: const Offset(0, 12),
    ),
  ];
  
  // ========== الحدود المحددة مسبقاً ==========
  
  static Border borderThin = Border.all(
    color: Colors.grey.withValues(alpha: 0.3),
    width: borderWidthThin,
  );
  
  static Border borderNormal = Border.all(
    color: Colors.grey.withValues(alpha: 0.3),
    width: borderWidthNormal,
  );
  
  static Border borderThick = Border.all(
    color: Colors.grey.withValues(alpha: 0.3),
    width: borderWidthThick,
  );
  
  // ========== التدرجات الشائعة ==========
  
  static const LinearGradient gradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black26],
  );
  
  static const LinearGradient gradientHorizontal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.transparent, Colors.black26],
  );
  
  static const RadialGradient gradientRadial = RadialGradient(
    colors: [Colors.transparent, Colors.black26],
  );
  
  // ========== معايير الاستجابة ==========
  
  /// تحديد نوع الجهاز بناءً على العرض
  static DeviceType getDeviceType(double width) {
    if (width < screenSm) return DeviceType.mobile;
    if (width < screenLg) return DeviceType.tablet;
    return DeviceType.desktop;
  }
  
  /// تحديد عدد الأعمدة بناءً على العرض
  static int getGridColumns(double width) {
    if (width < screenSm) return 2;
    if (width < screenMd) return 3;
    if (width < screenLg) return 4;
    return 5;
  }
  
  /// تحديد المسافة بناءً على نوع الجهاز
  static double getResponsiveSpacing(double width) {
    if (width < screenSm) return space3;
    if (width < screenLg) return space4;
    return space6;
  }
  
  /// تحديد حجم الخط بناءً على نوع الجهاز
  static double getResponsiveFontSize(double width, double baseFontSize) {
    final scaleFactor = getDeviceType(width) == DeviceType.mobile ? 1.0 :
                       getDeviceType(width) == DeviceType.tablet ? 1.2 : 1.4;
    return baseFontSize * scaleFactor;
  }
}

/// أنواع الأجهزة
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

/// Extension methods للمسافات
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
  
  /// تحويل إلى Margin
  EdgeInsets get margin => EdgeInsets.all(this);
  EdgeInsets get marginH => EdgeInsets.symmetric(horizontal: this);
  EdgeInsets get marginV => EdgeInsets.symmetric(vertical: this);
  EdgeInsets get marginTop => EdgeInsets.only(top: this);
  EdgeInsets get marginBottom => EdgeInsets.only(bottom: this);
  EdgeInsets get marginLeft => EdgeInsets.only(left: this);
  EdgeInsets get marginRight => EdgeInsets.only(right: this);
  
  /// تحويل إلى BorderRadius
  BorderRadius get radius => BorderRadius.circular(this);
  Radius get radiusValue => Radius.circular(this);
  
  /// تحويل إلى SliverToBoxAdapter مع SizedBox
  Widget get sliverBox => SliverToBoxAdapter(child: SizedBox(height: this));
}