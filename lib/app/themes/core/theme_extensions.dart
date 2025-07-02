// lib/app/themes/core/theme_extensions.dart - مُصحح لحل تعارض responsivePadding

import 'package:flutter/material.dart';
import '../theme_constants.dart';
import 'systems/app_color_system.dart';
import 'systems/app_icons_system.dart';
import 'systems/app_size_system.dart';
import 'helpers/category_helper.dart';
import 'helpers/theme_utils.dart';

/// Extension رئيسي للـ BuildContext - مُبسط ومُنظف
extension AppThemeExtension on BuildContext {
  // ===== الوصول المباشر للثيم =====
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // ===== حالة الثيم =====
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;

  // ===== الألوان الأساسية - بدون تكرار =====
  Color get primaryColor => AppColorSystem.primary;
  Color get primaryLightColor => AppColorSystem.primaryLight;
  Color get primaryDarkColor => AppColorSystem.primaryDark;
  Color get accentColor => AppColorSystem.accent;
  Color get tertiaryColor => AppColorSystem.tertiary;

  // ===== الألوان الدلالية =====
  Color get successColor => AppColorSystem.success;
  Color get errorColor => AppColorSystem.error;
  Color get warningColor => AppColorSystem.warning;
  Color get infoColor => AppColorSystem.info;

  // ===== ألوان سياقية - استخدام ThemeUtils =====
  Color get backgroundColor => ThemeUtils.getContextualColor(
    this,
    lightColor: AppColorSystem.lightBackground,
    darkColor: AppColorSystem.darkBackground,
  );

  Color get surfaceColor => ThemeUtils.getContextualColor(
    this,
    lightColor: AppColorSystem.lightSurface,
    darkColor: AppColorSystem.darkSurface,
  );

  Color get cardColor => ThemeUtils.getContextualColor(
    this,
    lightColor: AppColorSystem.lightCard,
    darkColor: AppColorSystem.darkCard,
  );

  Color get dividerColor => ThemeUtils.getContextualColor(
    this,
    lightColor: AppColorSystem.lightDivider,
    darkColor: AppColorSystem.darkDivider,
  );

  Color get textPrimaryColor => ThemeUtils.getContextualColor(
    this,
    lightColor: AppColorSystem.lightTextPrimary,
    darkColor: AppColorSystem.darkTextPrimary,
  );

  Color get textSecondaryColor => ThemeUtils.getContextualColor(
    this,
    lightColor: AppColorSystem.lightTextSecondary,
    darkColor: AppColorSystem.darkTextSecondary,
  );

  // ===== التدرجات الأساسية =====
  LinearGradient get primaryGradient => AppColorSystem.primaryGradient;
  LinearGradient get accentGradient => AppColorSystem.accentGradient;
  LinearGradient get tertiaryGradient => AppColorSystem.tertiaryGradient;

  // ===== دوال الألوان - مبسطة =====
  Color getColor(String key) => AppColorSystem.getColor(key);
  LinearGradient getGradient(String key) => AppColorSystem.getGradient(key);
  
  /// الحصول على لون مع fallback
  Color getColorSafe(String key, [Color? fallback]) => 
      AppColorSystem.getColorOrFallback(key, fallback ?? primaryColor);

  // ===== معلومات الشاشة - مع حماية =====
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // ===== نوع الجهاز - استخدام ThemeUtils =====
  ThemeDeviceType get deviceType => ThemeUtils.getDeviceType(this);
  bool get isMobile => deviceType == ThemeDeviceType.mobile;
  bool get isTablet => deviceType == ThemeDeviceType.tablet;
  bool get isDesktop => deviceType == ThemeDeviceType.desktop;

  // ===== الحجم المتجاوب =====
  ComponentSize get responsiveSize => AppSizeSystem.getResponsiveSize(this);

  // ===== الحشوات المتجاوبة - استخدام ThemeUtils مع اسم مختلف =====
  EdgeInsets get appResponsivePadding => ThemeUtils.getResponsivePadding(this); // ✅ اسم مختلف لتجنب التعارض
  EdgeInsets get appResponsiveMargin => ThemeUtils.getResponsiveMargin(this);   // ✅ اسم مختلف لتجنب التعارض

  // ===== لوحة المفاتيح =====
  bool get isKeyboardOpen => viewInsets.bottom > 0;
  double get keyboardHeight => viewInsets.bottom;

  // ===== المناطق الآمنة =====
  double get safeTop => screenPadding.top;
  double get safeBottom => screenPadding.bottom;
}

/// Extension للألوان - مُبسط باستخدام ThemeUtils
extension ColorExtensions on Color {
  /// شفافية آمنة - استخدام ThemeUtils
  Color withOpacitySafe(double opacity) => ThemeUtils.applyOpacity(this, opacity);

  /// تفتيح اللون - استخدام ThemeUtils
  Color lighten([double amount = 0.1]) => ThemeUtils.lightenColor(this, amount);

  /// تغميق اللون - استخدام ThemeUtils
  Color darken([double amount = 0.1]) => ThemeUtils.darkenColor(this, amount);

  /// الحصول على لون النص المتباين - استخدام ThemeUtils
  Color get contrastingTextColor => ThemeUtils.getContrastingTextColor(this);

  /// نسخ شفافة
  Color get transparent => withValues(alpha: 0.0);
  Color get semiTransparent => withValues(alpha: 0.5);
  
  /// ألوان شائعة بشفافيات مختلفة
  Color get subtle => withValues(alpha: 0.1);
  Color get light => withValues(alpha: 0.3);
  Color get medium => withValues(alpha: 0.6);
  Color get strong => withValues(alpha: 0.8);

  /// تحليل اللون
  bool get isLight => computeLuminance() > 0.5;
  bool get isDark => !isLight;
  
  /// الحصول على لون متكامل (مكمل)
  Color get complementary {
    try {
      final hsl = HSLColor.fromColor(this);
      final complementaryHue = (hsl.hue + 180) % 360;
      return hsl.withHue(complementaryHue).toColor();
    } catch (e) {
      return this;
    }
  }
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
  
  /// ظلال النص - استخدام ThemeUtils
  TextStyle withShadow({
    Color color = Colors.black,
    double opacity = 0.3,
    Offset offset = const Offset(0, 1),
    double blurRadius = 2,
  }) {
    return ThemeUtils.getTextStyleWithShadow(
      this, 
      this.color ?? Colors.black,
      withShadow: true,
      shadowOpacity: opacity,
    );
  }

  /// نمط النص حسب السياق
  TextStyle forContext(BuildContext context, {bool isSecondary = false}) {
    final themeColor = isSecondary 
        ? context.textSecondaryColor 
        : context.textPrimaryColor;
    return copyWith(color: themeColor);
  }
}

/// Extension للأرقام - للتطوير السريع
extension NumberExtensions on num {
  // مسافات
  SizedBox get w => SizedBox(width: toDouble());
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get wh => SizedBox(width: toDouble(), height: toDouble());

  // حشوات - استخدام ThemeUtils
  EdgeInsets get all => ThemeUtils.createPadding(all: toDouble());
  EdgeInsets get horizontal => ThemeUtils.createPadding(horizontal: toDouble());
  EdgeInsets get vertical => ThemeUtils.createPadding(vertical: toDouble());
  EdgeInsets get left => ThemeUtils.createPadding(left: toDouble());
  EdgeInsets get top => ThemeUtils.createPadding(top: toDouble());
  EdgeInsets get right => ThemeUtils.createPadding(right: toDouble());
  EdgeInsets get bottom => ThemeUtils.createPadding(bottom: toDouble());

  // زوايا دائرية - استخدام ThemeUtils
  BorderRadius get circular => ThemeUtils.createBorderRadius(all: toDouble());
  BorderRadius get topCircular => ThemeUtils.createBorderRadius(
    topLeft: toDouble(),
    topRight: toDouble(),
  );
  BorderRadius get bottomCircular => ThemeUtils.createBorderRadius(
    bottomLeft: toDouble(),
    bottomRight: toDouble(),
  );
  
  // تحويلات مفيدة
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
}

/// Extension للـ Widgets - مُبسط
extension WidgetExtensions on Widget {
  /// إضافة padding
  Widget padded(EdgeInsetsGeometry padding) => Padding(
    padding: padding,
    child: this,
  );

  /// padding ذكي حسب حجم الشاشة - استخدام ThemeUtils مع اسم محدد
  Widget withAppResponsivePadding(BuildContext context) => Padding(  // ✅ اسم مختلف لتجنب التعارض
    padding: context.appResponsivePadding,
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

  /// إضافة تأثير تلاشي - استخدام ThemeUtils
  Widget opacity(double opacity) => Opacity(
    opacity: ThemeUtils.safeOpacity(opacity),
    child: this,
  );

  /// إضافة margin - استخدام ThemeUtils
  Widget margin(EdgeInsetsGeometry margin) => Container(
    margin: margin,
    child: this,
  );

  /// تطبيق شرط
  Widget conditional(bool condition, Widget Function(Widget) builder) {
    return condition ? builder(this) : this;
  }

  /// إضافة gesture detector مبسط
  Widget onTap(VoidCallback? onTap) {
    if (onTap == null) return this;
    return GestureDetector(onTap: onTap, child: this);
  }
}

/// Extension موحد للـ String - مُبسط ومُنظف
extension StringAppExtension on String {
  // ===== الألوان من AppColorSystem =====
  Color get color => AppColorSystem.getColor(this);
  Color get lightColor => AppColorSystem.getLightColor(this);
  Color get darkColor => AppColorSystem.getDarkColor(this);
  
  /// الحصول على لون مع fallback
  Color colorOr(Color fallback) => AppColorSystem.getColorOrFallback(this, fallback);
  
  // للتوافق مع الكود الموجود
  Color get categoryColor => AppColorSystem.getCategoryColor(this);
  Color get prayerColor => AppColorSystem.getPrayerColor(this);
  Color get quoteColor => AppColorSystem.getQuoteColor(this);
  
  // ===== الأيقونات من AppIconsSystem =====
  IconData get categoryIcon => AppIconsSystem.getCategoryIcon(this);
  IconData get prayerIcon => AppIconsSystem.getPrayerIcon(this);
  IconData get quoteTypeIcon => AppIconsSystem.getQuoteTypeIcon(this);
  IconData get stateIcon => AppIconsSystem.getStateIcon(this);
  
  // ===== التدرجات من AppColorSystem =====
  LinearGradient get gradient => AppColorSystem.getGradient(this);
  LinearGradient get categoryGradient => AppColorSystem.getCategoryGradient(this);
  LinearGradient get prayerGradient => AppColorSystem.getPrayerGradient(this);
  LinearGradient get lightGradient => AppColorSystem.getLightGradient(this);
  
  // ===== خصائص الفئات من CategoryHelper =====
  String get categoryDescription => CategoryHelper.getCategoryDescription(this);
  bool get shouldAutoEnable => CategoryHelper.shouldAutoEnable(this);
  TimeOfDay get defaultReminderTime => CategoryHelper.getDefaultReminderTime(this);
  int get categoryPriority => CategoryHelper.getCategoryPriority(this);
  
  // ===== دوال مساعدة - استخدام ThemeUtils =====
  /// الحصول على لون الظل
  Color colorShadow([double opacity = 0.3]) => 
      AppColorSystem.getColor(this).withValues(alpha: ThemeUtils.safeOpacity(opacity));
      
  /// التحقق من وجود اللون
  bool get hasColor => AppColorSystem.hasColor(this);
  
  // ===== تحويلات آمنة =====
  int? get toIntSafe => int.tryParse(this);
  double? get toDoubleSafe => double.tryParse(this);

  /// التحقق من كون النص فارغ
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => isNotEmpty;
  
  /// تحويل أول حرف إلى كبير
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Extension لأحجام المكونات - مُبسط
extension ComponentSizeExtension on ComponentSize {
  /// الحصول على الارتفاع
  double get height => AppSizeSystem.getHeight(this);
  double get width => AppSizeSystem.getWidth(this);
  double get iconSize => AppSizeSystem.getIconSize(this);
  double get fontSize => AppSizeSystem.getFontSize(this);
  EdgeInsets get padding => AppSizeSystem.getPadding(this);
  double get borderRadius => AppSizeSystem.getBorderRadius(this);
  ComponentSizes get sizes => AppSizeSystem.getSizes(this);
  ButtonSizes get buttonSizes => AppSizeSystem.getButtonSizes(this);
  InputSizes get inputSizes => AppSizeSystem.getInputSizes(this);
  CardSizes get cardSizes => AppSizeSystem.getCardSizes(this);
  LoadingSizes get loadingSizes => AppSizeSystem.getLoadingSizes(this);
  DialogSizes get dialogSizes => AppSizeSystem.getDialogSizes(this);

  /// التحقق من كون الحجم صغير/كبير
  bool get isSmall => index <= ComponentSize.sm.index;
  bool get isLarge => index >= ComponentSize.lg.index;
}

/// Extension للسياق للحصول على التخطيط المتجاوب - استخدام ThemeUtils
extension ResponsiveSizeExtension on BuildContext {
  ComponentSize get responsiveSize => AppSizeSystem.getResponsiveSize(this);
  
  CrossAxisAlignment get responsiveAlignment {
    return isMobile ? CrossAxisAlignment.stretch : CrossAxisAlignment.center;
  }
  
  /// عدد الأعمدة المناسب - استخدام ThemeUtils
  int responsiveColumns({
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) => ThemeUtils.getResponsiveColumns(
    this,
    mobileColumns: mobile,
    tabletColumns: tablet,
    desktopColumns: desktop,
  );
}