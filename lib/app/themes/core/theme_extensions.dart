// lib/app/themes/core/theme_extensions.dart - النسخة المُبسطة والموحدة
import 'package:flutter/material.dart';
import '../theme_constants.dart';
import 'systems/app_color_system.dart';
import 'systems/app_icons_system.dart';
import 'systems/app_size_system.dart';

/// Extension رئيسي للـ BuildContext - كل شيء في مكان واحد
extension AppThemeExtension on BuildContext {
  // ===== الوصول المباشر للثيم =====
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // ===== حالة الثيم =====
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;

  // ===== الألوان الأساسية =====
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

  // ===== دوال الألوان والتدرجات =====
  Color getColor(String key) => AppColorSystem.getColor(key);
  LinearGradient getGradient(String key) => AppColorSystem.getGradient(key);
  LinearGradient getTimeBasedGradient() => AppColorSystem.getTimeBasedGradient();

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

/// Extension للألوان - مُبسط ومُحسن
extension ColorExtensions on Color {
  /// إضافة شفافية آمنة
  Color withOpacitySafe(double opacity) {
    final safeOpacity = opacity.clamp(0.0, 1.0);
    return withValues(alpha: safeOpacity);
  }

  /// تفتيح اللون
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// تغميق اللون
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// الحصول على لون النص المتباين
  Color get contrastingTextColor {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  /// الحصول على نسخة شفافة
  Color get transparent => withValues(alpha: 0.0);
  Color get semiTransparent => withValues(alpha: 0.5);
}

/// Extension للنصوص - مُبسط
extension TextStyleExtensions on TextStyle {
  // أوزان الخط
  TextStyle get bold => copyWith(fontWeight: ThemeConstants.bold);
  TextStyle get semiBold => copyWith(fontWeight: ThemeConstants.semiBold);
  TextStyle get medium => copyWith(fontWeight: ThemeConstants.medium);
  TextStyle get regular => copyWith(fontWeight: ThemeConstants.regular);
  TextStyle get light => copyWith(fontWeight: ThemeConstants.light);

  // تعديلات النص
  TextStyle size(double fontSize) => copyWith(fontSize: fontSize);
  TextStyle textColor(Color color) => copyWith(color: color);
  TextStyle withHeight(double height) => copyWith(height: height);
  TextStyle withSpacing(double letterSpacing) => copyWith(letterSpacing: letterSpacing);
  
  // أنماط النص
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
}

/// Extension للأرقام - للتطوير السريع
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

/// Extension للـ Widgets - للتطوير السريع
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

/// Extension موحد للـ String - كل شيء في مكان واحد
extension StringAppExtension on String {
  // ===== الألوان =====
  Color get color => AppColorSystem.getColor(this);
  Color get lightColor => AppColorSystem.getLightColor(this);
  Color get darkColor => AppColorSystem.getDarkColor(this);
  
  // للتوافق مع الكود الموجود
  Color get categoryColor => AppColorSystem.getCategoryColor(this);
  Color get prayerColor => AppColorSystem.getPrayerColor(this);
  Color get quoteColor => AppColorSystem.getQuoteColor(this);
  
  // ===== الأيقونات =====
  IconData get categoryIcon => AppIconsSystem.getCategoryIcon(this);
  IconData get prayerIcon => AppIconsSystem.getPrayerIcon(this);
  IconData get quoteTypeIcon => AppIconsSystem.getQuoteTypeIcon(this);
  IconData get stateIcon => AppIconsSystem.getStateIcon(this);
  
  // ===== التدرجات =====
  LinearGradient get gradient => AppColorSystem.getGradient(this);
  LinearGradient get categoryGradient => AppColorSystem.getCategoryGradient(this);
  LinearGradient get prayerGradient => AppColorSystem.getPrayerGradient(this);
  LinearGradient get lightGradient => AppColorSystem.getLightGradient(this);
  LinearGradient get tripleGradient => AppColorSystem.getTripleGradient(this);
  
  // ===== دوال مساعدة =====
  /// الحصول على لون الظل
  Color colorShadow([double opacity = 0.3]) => 
      AppColorSystem.getColor(this).withValues(alpha: opacity);
      
  /// التحقق من وجود اللون
  bool get hasColor => AppColorSystem.hasColor(this);
}