// lib/app/themes/core/theme_extensions.dart - منظفة ومبسطة
import 'package:flutter/material.dart';
import '../theme_constants.dart';
import '../text_styles.dart';
import 'systems/app_color_system.dart';
import 'systems/app_size_system.dart';

/// Extensions لتسهيل الوصول للثيم مع ضمان التطابق الكامل
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // ===== الألوان الأساسية - مطابقة تماماً لـ ThemeConstants =====
  
  Color get primaryColor => ThemeConstants.primary;
  Color get primaryLightColor => ThemeConstants.primaryLight;
  Color get primaryDarkColor => ThemeConstants.primaryDark;
  Color get accentColor => ThemeConstants.accent;
  Color get accentLightColor => ThemeConstants.accentLight;
  Color get accentDarkColor => ThemeConstants.accentDark;
  Color get tertiaryColor => ThemeConstants.tertiary;
  Color get tertiaryLightColor => ThemeConstants.tertiaryLight;
  Color get tertiaryDarkColor => ThemeConstants.tertiaryDark;

  // ===== الألوان الدلالية =====
  
  Color get successColor => ThemeConstants.success;
  Color get successLightColor => ThemeConstants.successLight;
  Color get errorColor => ThemeConstants.error;
  Color get warningColor => ThemeConstants.warning;
  Color get warningLightColor => ThemeConstants.warningLight;
  Color get infoColor => ThemeConstants.info;
  Color get infoLightColor => ThemeConstants.infoLight;

  // ===== ألوان الخلفيات والأسطح =====
  
  Color get backgroundColor => ThemeConstants.background(this);
  Color get surfaceColor => ThemeConstants.surface(this);
  Color get cardColor => ThemeConstants.card(this);
  Color get dividerColor => ThemeConstants.divider(this);
  Color get textPrimaryColor => ThemeConstants.textPrimary(this);
  Color get textSecondaryColor => ThemeConstants.textSecondary(this);

  // ===== التدرجات الأساسية =====
  
  LinearGradient get primaryGradient => ThemeConstants.primaryGradient;
  LinearGradient get accentGradient => ThemeConstants.accentGradient;
  LinearGradient get tertiaryGradient => ThemeConstants.tertiaryGradient;

  // ===== دوال ThemeConstants المتخصصة =====
  
  LinearGradient prayerGradient(String prayerName) => 
    ThemeConstants.prayerGradient(prayerName);
  LinearGradient getTimeBasedGradient({DateTime? dateTime}) => 
    ThemeConstants.getTimeBasedGradient();
  Color getPrayerColor(String prayerName) => 
    ThemeConstants.getPrayerColor(prayerName);
  IconData getPrayerIcon(String prayerName) =>
    ThemeConstants.getPrayerIcon(prayerName);

  // ===== دوال الفئات المبسطة =====
  
  Color getCategoryColor(String categoryId) {
    return AppColorSystem.getPrimaryColor(categoryId);
  }
  
  LinearGradient getCategoryGradient(String categoryId) {
    return AppColorSystem.getGradient(categoryId);
  }

  // ===== حالة الثيم =====
  
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;

  // ===== أنماط النصوص المباشرة =====
  
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;

  // ===== أنماط خاصة =====
  
  TextStyle get quranStyle => AppTextStyles.quran;
  TextStyle get athkarStyle => AppTextStyles.athkar;
  TextStyle get duaStyle => AppTextStyles.dua;

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

/// Extensions للألوان - موحدة مع إصلاح withValues
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

  MaterialColor toMaterialColor() {
    final strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    final swatch = <int, Color>{};
    
    for (var i = 0; i < strengths.length; i++) {
      final strength = strengths[i];
      swatch[(strength * 1000).round()] = i < 5
          ? lighten(strength)
          : darken(strength - 0.5);
    }
    
    return MaterialColor(toARGB32(), swatch);
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

/// Extensions للحواف
extension EdgeInsetsExtensions on EdgeInsets {
  EdgeInsets add(EdgeInsets other) => EdgeInsets.only(
    left: left + other.left,
    top: top + other.top,
    right: right + other.right,
    bottom: bottom + other.bottom,
  );

  EdgeInsets subtract(EdgeInsets other) => EdgeInsets.only(
    left: (left - other.left).clamp(0.0, double.infinity),
    top: (top - other.top).clamp(0.0, double.infinity),
    right: (right - other.right).clamp(0.0, double.infinity),
    bottom: (bottom - other.bottom).clamp(0.0, double.infinity),
  );
}

/// Extensions للأرقام - لإنشاء widgets بسرعة
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

  /// إنشاء SliverToBoxAdapter للمسافات العمودية
  Widget get sliverBox => SliverToBoxAdapter(
    child: SizedBox(height: toDouble()),
  );
  
  /// إنشاء SliverToBoxAdapter للمسافات الأفقية
  Widget get sliverBoxHorizontal => SliverToBoxAdapter(
    child: SizedBox(width: toDouble()),
  );
}

/// Extensions للـ Lists
extension ListExtensions<T> on List<T> {
  /// فصل العناصر بـ separator
  List<T> separated(T separator) {
    if (isEmpty) return this;
    
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}

/// Extensions للـ Widgets
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

  /// إضافة حاوية
  Widget container({
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxDecoration? decoration,
    Color? color,
    double? width,
    double? height,
  }) => Container(
    padding: padding,
    margin: margin,
    decoration: decoration,
    color: color,
    width: width,
    height: height,
    child: this,
  );

  /// إضافة InkWell
  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    BorderRadius? borderRadius,
  }) => InkWell(
    onTap: onTap,
    onLongPress: onLongPress,
    borderRadius: borderRadius,
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

/// Extensions للـ SnackBar - مبسطة (ستستدعي AppSnackBar مباشرة)
extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message, {SnackBarAction? action}) {
    // سيتم استدعاء AppSnackBar.showSuccess مباشرة في الشاشات
  }

  void showErrorSnackBar(String message, {SnackBarAction? action}) {
    // سيتم استدعاء AppSnackBar.showError مباشرة في الشاشات
  }

  void showInfoSnackBar(String message, {SnackBarAction? action}) {
    // سيتم استدعاء AppSnackBar.showInfo مباشرة في الشاشات
  }

  void showSnackBar(String message, {
    IconData? icon,
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    // سيتم استدعاء AppSnackBar.show مباشرة في الشاشات
  }

  void hideSnackBars() {
    // سيتم استدعاء AppSnackBar.hideAll مباشرة في الشاشات
  }
}