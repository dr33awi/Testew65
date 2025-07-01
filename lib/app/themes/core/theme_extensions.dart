// lib/app/themes/core/theme_extensions.dart - النسخة المصححة
import 'package:flutter/material.dart';
import '../theme_constants.dart';
import 'systems/app_color_system.dart';
import 'systems/app_icons_system.dart';
import 'systems/app_size_system.dart';

/// Extensions مفيدة - تستخدم الأنظمة الجديدة
extension ThemeExtension on BuildContext {
  // ===== الوصول المباشر للثيم =====
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // ===== حالة الثيم =====
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;

  // ===== الألوان الأساسية من AppColorSystem =====
  Color get primaryColor => AppColorSystem.primary;
  Color get primaryLightColor => AppColorSystem.primaryLight;
  Color get primaryDarkColor => AppColorSystem.primaryDark;
  Color get accentColor => AppColorSystem.accent;
  Color get accentLightColor => AppColorSystem.accentLight;
  Color get accentDarkColor => AppColorSystem.accentDark;
  Color get tertiaryColor => AppColorSystem.tertiary;
  Color get tertiaryLightColor => AppColorSystem.tertiaryLight;
  Color get tertiaryDarkColor => AppColorSystem.tertiaryDark;

  // ===== الألوان الدلالية =====
  Color get successColor => AppColorSystem.success;
  Color get successLightColor => AppColorSystem.successLight;
  Color get errorColor => AppColorSystem.error;
  Color get warningColor => AppColorSystem.warning;
  Color get warningLightColor => AppColorSystem.warningLight;
  Color get infoColor => AppColorSystem.info;
  Color get infoLightColor => AppColorSystem.infoLight;

  // ===== ألوان الخلفيات والأسطح =====
  Color get backgroundColor => AppColorSystem.getBackground(this);
  Color get surfaceColor => AppColorSystem.getSurface(this);
  Color get cardColor => AppColorSystem.getCard(this);
  Color get dividerColor => AppColorSystem.getDivider(this);
  Color get textPrimaryColor => AppColorSystem.getTextPrimary(this);
  Color get textSecondaryColor => AppColorSystem.getTextSecondary(this);

  // ===== التدرجات الأساسية =====
  LinearGradient get primaryGradient => AppColorSystem.primaryGradient;
  LinearGradient get accentGradient => AppColorSystem.accentGradient;
  LinearGradient get tertiaryGradient => AppColorSystem.tertiaryGradient;

  // ===== دوال الألوان المتخصصة =====
  LinearGradient prayerGradient(String prayerName) => 
    AppColorSystem.getPrayerGradient(prayerName);
  LinearGradient getTimeBasedGradient({DateTime? dateTime}) => 
    AppColorSystem.getTimeBasedGradient();
  Color getPrayerColor(String prayerName) => 
    AppColorSystem.getPrayerColor(prayerName);
  IconData getPrayerIcon(String prayerName) =>
    AppIconsSystem.getPrayerIcon(prayerName);

  // ===== دوال الفئات والاقتباسات =====
  Color getCategoryColor(String categoryId) {
    return AppColorSystem.getCategoryColor(categoryId);
  }
  
  LinearGradient getCategoryGradient(String categoryId) {
    return AppColorSystem.getCategoryGradient(categoryId);
  }

  // ===== معلومات الشاشة =====
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // ===== نوع الجهاز =====
  bool get isMobile => screenWidth < ThemeConstants.breakpointMobile;
  bool get isTablet => screenWidth >= ThemeConstants.breakpointMobile && screenWidth < ThemeConstants.breakpointTablet;
  bool get isDesktop => screenWidth >= ThemeConstants.breakpointTablet;

  // ===== الحجم المتجاوب =====
  ComponentSize get responsiveSize => AppSizeSystem.getResponsiveSize(this);

  // ===== الحشوات المتجاوبة =====
  EdgeInsets get responsivePadding {
    if (isMobile) return const EdgeInsets.all(ThemeConstants.space4);
    if (isTablet) return const EdgeInsets.all(ThemeConstants.space6);
    return const EdgeInsets.all(ThemeConstants.space8);
  }

  // ===== معلومات النظام =====
  bool get isIOS => theme.platform == TargetPlatform.iOS;
  bool get isAndroid => theme.platform == TargetPlatform.android;

  // ===== لوحة المفاتيح =====
  bool get isKeyboardOpen => viewInsets.bottom > 0;
  double get keyboardHeight => viewInsets.bottom;

  // ===== المناطق الآمنة =====
  double get safeTop => screenPadding.top;
  double get safeBottom => screenPadding.bottom;
}

/// Extensions للألوان - محدثة
extension ColorExtensions on Color {
  Color withOpacitySafe(double opacity) {
    final safeOpacity = opacity.clamp(0.0, 1.0);
    return withValues(alpha: safeOpacity);
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Color get contrastingTextColor {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }
}

/// Extensions للنصوص
extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: ThemeConstants.bold);
  TextStyle get semiBold => copyWith(fontWeight: ThemeConstants.semiBold);
  TextStyle get medium => copyWith(fontWeight: ThemeConstants.medium);
  TextStyle get regular => copyWith(fontWeight: ThemeConstants.regular);
  TextStyle get light => copyWith(fontWeight: ThemeConstants.light);

  TextStyle size(double fontSize) => copyWith(fontSize: fontSize);
  TextStyle textColor(Color color) => copyWith(color: color);
  TextStyle withHeight(double height) => copyWith(height: height);
  TextStyle withSpacing(double letterSpacing) => copyWith(letterSpacing: letterSpacing);
  
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
}

/// Extensions للأرقام - مفيدة للتطوير السريع
extension NumberExtensions on num {
  // مسافات
  SizedBox get w => SizedBox(width: toDouble());
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get wh => SizedBox(width: toDouble(), height: toDouble());

  // حشوات
  EdgeInsets get all => EdgeInsets.all(toDouble());
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get left => EdgeInsets.only(left: toDouble());
  EdgeInsets get top => EdgeInsets.only(top: toDouble());
  EdgeInsets get right => EdgeInsets.only(right: toDouble());
  EdgeInsets get bottom => EdgeInsets.only(bottom: toDouble());

  // زوايا دائرية
  BorderRadius get circular => BorderRadius.circular(toDouble());
  BorderRadius get topCircular => BorderRadius.only(
    topLeft: Radius.circular(toDouble()),
    topRight: Radius.circular(toDouble()),
  );
  BorderRadius get bottomCircular => BorderRadius.only(
    bottomLeft: Radius.circular(toDouble()),
    bottomRight: Radius.circular(toDouble()),
  );
}

/// Extensions للـ Widgets - مفيدة للتطوير السريع
extension WidgetExtensions on Widget {
  /// إضافة padding
  Widget padded(EdgeInsetsGeometry padding) => Padding(
    padding: padding,
    child: this,
  );

  /// توسيط Widget
  Widget get centered => Center(child: this);

  /// إضافة Expanded
  Widget get expanded => Expanded(child: this);

  /// إضافة Flexible
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) => Flexible(
    flex: flex,
    fit: fit,
    child: this,
  );

  /// إضافة تأثير تلاشي
  Widget opacity(double opacity) {
    final safeOpacity = opacity.clamp(0.0, 1.0);
    return Opacity(
      opacity: safeOpacity,
      child: this,
    );
  }

  /// إضافة دوران
  Widget rotate(double angle) => Transform.rotate(
    angle: angle,
    child: this,
  );

  /// إضافة تحجيم
  Widget scale(double scale) => Transform.scale(
    scale: scale,
    child: this,
  );
}

/// Extensions للفئات والألوان - بديل للـ Utils المحذوفة
extension StringThemeExtension on String {
  /// الحصول على لون الفئة/الصلاة
  Color getCategoryColor(BuildContext? context) {
    return AppColorSystem.getCategoryColor(this);
  }
  
  /// الحصول على لون فاتح للفئة
  Color getCategoryLightColor() {
    return AppColorSystem.getCategoryLightColor(this);
  }
  
  /// الحصول على لون داكن للفئة
  Color getCategoryDarkColor() {
    return AppColorSystem.getCategoryDarkColor(this);
  }
  
  /// الحصول على تدرج الفئة/الصلاة
  LinearGradient getCategoryGradient() {
    return AppColorSystem.getCategoryGradient(this);
  }
  
  /// الحصول على تدرج فاتح للفئة
  LinearGradient getCategoryLightGradient() {
    return AppColorSystem.getCategoryLightGradient(this);
  }
  
  /// الحصول على تدرج ثلاثي للفئة
  LinearGradient getCategoryTripleGradient() {
    return AppColorSystem.getCategoryTripleGradient(this);
  }
  
  /// الحصول على أيقونة الفئة/الصلاة
  IconData getCategoryIcon() {
    return AppIconsSystem.getCategoryIcon(this);
  }

  /// الحصول على لون للصلاة (مرادف)
  Color get prayerColor => AppColorSystem.getPrayerColor(this);
  
  /// الحصول على تدرج للصلاة (مرادف)
  LinearGradient get prayerGradient => AppColorSystem.getPrayerGradient(this);
  
  /// الحصول على أيقونة للصلاة (مرادف)
  IconData get prayerIcon => AppIconsSystem.getPrayerIcon(this);
}

/// Extension لـ AppColorSystem في String - للراحة
extension AppColorExtension on String {
  /// الوصول السريع للألوان
  Color get categoryColor => AppColorSystem.getCategoryColor(this);
  Color get categoryLightColor => AppColorSystem.getCategoryLightColor(this);
  Color get categoryDarkColor => AppColorSystem.getCategoryDarkColor(this);
  LinearGradient get categoryGradient => AppColorSystem.getCategoryGradient(this);
}

/// Extension لـ AppIconsSystem في String - للراحة (اسم مختلف لتجنب التضارب)
extension AppIconsThemeExtension on String {
  /// الوصول السريع للأيقونات
  IconData get categoryIcon => AppIconsSystem.getCategoryIcon(this);
  IconData get prayerIcon => AppIconsSystem.getPrayerIcon(this);
  IconData get quoteTypeIcon => AppIconsSystem.getQuoteTypeIcon(this);
  IconData get stateIcon => AppIconsSystem.getStateIcon(this);
}