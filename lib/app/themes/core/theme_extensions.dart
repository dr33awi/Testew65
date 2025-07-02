// ===== lib/app/themes/core/theme_extensions.dart - مُصحح =====

import 'package:flutter/material.dart';
import '../theme_constants.dart';
import 'systems/app_color_system.dart';
import 'systems/app_icons_system.dart';
import 'systems/app_size_system.dart';
import 'helpers/category_helper.dart';

/// Extension رئيسي للـ BuildContext - مُصحح مع معالجة أخطاء
extension AppThemeExtension on BuildContext {
  // ===== الوصول المباشر للثيم مع حماية من null =====
  ThemeData get theme {
    try {
      return Theme.of(this);
    } catch (e) {
      return ThemeData.fallback();
    }
  }
  
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

  // ===== ألوان الخلفيات والأسطح - مُصححة =====
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

  // ===== دوال الألوان والتدرجات المُصححة =====
  Color getColor(String key) => AppColorSystem.getColor(key);
  LinearGradient getGradient(String key) => AppColorSystem.getGradient(key);
  
  /// الحصول على لون مع fallback
  Color getColorSafe(String key, [Color? fallback]) => 
      AppColorSystem.getColorOrFallback(key, fallback ?? primaryColor);
  
  /// دالة موحدة للحصول على اللون حسب السياق - ✅ مُصححة
  Color getContextualColor({
    required String key,
    bool isSecondary = false,
    double? opacity,
  }) {
    try {
      Color color = AppColorSystem.getColor(key);
      
      if (isSecondary) {
        color = color.withValues(alpha: 0.7); // ✅ مُصحح
      }
      
      if (opacity != null) {
        color = color.withValues(alpha: opacity.clamp(0.0, 1.0)); // ✅ مُصحح
      }
      
      return color;
    } catch (e) {
      return primaryColor;
    }
  }

  /// الحصول على لون دلالي
  Color getSemanticColor(String type) {
    switch (type.toLowerCase()) {
      case 'success': return successColor;
      case 'error': return errorColor;
      case 'warning': return warningColor;
      case 'info': return infoColor;
      default: return primaryColor;
    }
  }

  // ===== معلومات الشاشة مع حماية =====
  double get screenWidth {
    try {
      return MediaQuery.sizeOf(this).width;
    } catch (e) {
      return 400; // عرض افتراضي آمن
    }
  }
  
  double get screenHeight {
    try {
      return MediaQuery.sizeOf(this).height;
    } catch (e) {
      return 800; // ارتفاع افتراضي آمن
    }
  }
  
  EdgeInsets get screenPadding {
    try {
      return MediaQuery.paddingOf(this);
    } catch (e) {
      return EdgeInsets.zero;
    }
  }
  
  EdgeInsets get viewInsets {
    try {
      return MediaQuery.viewInsetsOf(this);
    } catch (e) {
      return EdgeInsets.zero;
    }
  }

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
  bool get isIOS {
    try {
      return theme.platform == TargetPlatform.iOS;
    } catch (e) {
      return false;
    }
  }
  
  bool get isAndroid {
    try {
      return theme.platform == TargetPlatform.android;
    } catch (e) {
      return false;
    }
  }

  // ===== لوحة المفاتيح =====
  bool get isKeyboardOpen => viewInsets.bottom > 0;
  double get keyboardHeight => viewInsets.bottom;

  // ===== المناطق الآمنة =====
  double get safeTop => screenPadding.top;
  double get safeBottom => screenPadding.bottom;

  // ===== دوال مساعدة إضافية =====
  
  /// التحقق من كفاية التباين
  bool hasGoodContrast(Color foreground, Color background) {
    return AppColorSystem.hasGoodContrast(foreground, background);
  }

  /// اقتراح لون نص مناسب
  Color suggestTextColor(Color backgroundColor) {
    return AppColorSystem.suggestTextColor(backgroundColor);
  }
}

/// Extension للألوان - مُصحح مع withValues
extension ColorExtensions on Color {
  /// إضافة شفافية آمنة - ✅ تفضيل withValues
  Color withOpacitySafe(double opacity) {
    final safeOpacity = opacity.clamp(0.0, 1.0);
    return withValues(alpha: safeOpacity); // ✅ مُصحح
  }

  /// تفتيح اللون - مُصحح
  Color lighten([double amount = 0.1]) {
    try {
      assert(amount >= 0 && amount <= 1);
      final hsl = HSLColor.fromColor(this);
      final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
      return hsl.withLightness(lightness).toColor();
    } catch (e) {
      return this; // إرجاع اللون الأصلي في حالة الخطأ
    }
  }

  /// تغميق اللون - مُصحح
  Color darken([double amount = 0.1]) {
    try {
      assert(amount >= 0 && amount <= 1);
      final hsl = HSLColor.fromColor(this);
      final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
      return hsl.withLightness(lightness).toColor();
    } catch (e) {
      return this;
    }
  }

  /// الحصول على لون النص المتباين - مُصحح
  Color get contrastingTextColor {
    try {
      return ThemeData.estimateBrightnessForColor(this) == Brightness.dark
          ? Colors.white
          : Colors.black87;
    } catch (e) {
      return Colors.white;
    }
  }

  /// الحصول على نسخة شفافة - ✅ مُصححة
  Color get transparent => withValues(alpha: 0.0); // ✅ مُصحح
  Color get semiTransparent => withValues(alpha: 0.5); // ✅ مُصحح
  
  /// ألوان شائعة بشفافيات مختلفة - ✅ مُصححة
  Color get subtle => withValues(alpha: 0.1); // ✅ مُصحح
  Color get light => withValues(alpha: 0.3); // ✅ مُصحح
  Color get medium => withValues(alpha: 0.6); // ✅ مُصحح
  Color get strong => withValues(alpha: 0.8); // ✅ مُصحح

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

/// Extension للنصوص - مُصحح
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
  
  // ظلال النص - ✅ مُصحح
  TextStyle withShadow({
    Color color = Colors.black,
    double opacity = 0.3,
    Offset offset = const Offset(0, 1),
    double blurRadius = 2,
  }) {
    return copyWith(
      shadows: [
        Shadow(
          color: color.withValues(alpha: opacity), // ✅ مُصحح
          offset: offset,
          blurRadius: blurRadius,
        ),
      ],
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
  
  // تحويلات مفيدة
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
}

/// Extension للـ Widgets - مُصحح
extension WidgetExtensions on Widget {
  /// إضافة padding مع دعم responsive
  Widget padded(EdgeInsetsGeometry padding) => Padding(
    padding: padding,
    child: this,
  );

  /// padding ذكي حسب حجم الشاشة
  Widget responsivePadding(BuildContext context) => Padding(
    padding: context.responsivePadding,
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

  /// إضافة تأثير تلاشي - مُصحح
  Widget opacity(double opacity) {
    final safeOpacity = opacity.clamp(0.0, 1.0);
    return Opacity(
      opacity: safeOpacity,
      child: this,
    );
  }

  /// إضافة دوران - مُصحح
  Widget rotate(double angle) {
    try {
      return Transform.rotate(
        angle: angle,
        child: this,
      );
    } catch (e) {
      return this;
    }
  }

  /// إضافة تحجيم - مُصحح
  Widget scale(double scale) {
    try {
      final safeScale = scale.clamp(0.1, 10.0);
      return Transform.scale(
        scale: safeScale,
        child: this,
      );
    } catch (e) {
      return this;
    }
  }

  /// إضافة margin
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

/// Extension موحد للـ String - مُصحح
extension StringAppExtension on String {
  // ===== الألوان من AppColorSystem - مُصحح =====
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
  
  // ===== دوال مساعدة مُصححة =====
  /// الحصول على لون الظل - ✅ مُصحح
  Color colorShadow([double opacity = 0.3]) => 
      AppColorSystem.getColor(this).withValues(alpha: opacity.clamp(0.0, 1.0)); // ✅ مُصحح
      
  /// التحقق من وجود اللون
  bool get hasColor => AppColorSystem.hasColor(this);
  
  /// تحويل آمن للأرقام
  int? get toIntSafe {
    try {
      return int.tryParse(this);
    } catch (e) {
      return null;
    }
  }
  
  double? get toDoubleSafe {
    try {
      return double.tryParse(this);
    } catch (e) {
      return null;
    }
  }

  /// التحقق من كون النص فارغ أو null
  bool get isNullOrEmpty => isEmpty;
  bool get isNotNullOrEmpty => isNotEmpty;
  
  /// تحويل أول حرف إلى كبير
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Extension لأحجام المكونات - مُصحح
extension ComponentSizeExtension on ComponentSize {
  /// الحصول على الارتفاع
  double get height => AppSizeSystem.getHeight(this);
  
  /// الحصول على العرض
  double get width => AppSizeSystem.getWidth(this);
  
  /// الحصول على حجم الأيقونة
  double get iconSize => AppSizeSystem.getIconSize(this);
  
  /// الحصول على حجم الخط
  double get fontSize => AppSizeSystem.getFontSize(this);
  
  /// الحصول على الحشو الداخلي
  EdgeInsets get padding => AppSizeSystem.getPadding(this);
  
  /// الحصول على نصف قطر الحدود
  double get borderRadius => AppSizeSystem.getBorderRadius(this);
  
  /// الحصول على جميع الأحجام
  ComponentSizes get sizes => AppSizeSystem.getSizes(this);
  
  /// الحصول على أحجام الأزرار
  ButtonSizes get buttonSizes => AppSizeSystem.getButtonSizes(this);
  
  /// الحصول على أحجام الإدخال
  InputSizes get inputSizes => AppSizeSystem.getInputSizes(this);
  
  /// الحصول على أحجام البطاقات
  CardSizes get cardSizes => AppSizeSystem.getCardSizes(this);
  
  /// الحصول على أحجام التحميل
  LoadingSizes get loadingSizes => AppSizeSystem.getLoadingSizes(this);
  
  /// الحصول على أحجام الحوارات
  DialogSizes get dialogSizes => AppSizeSystem.getDialogSizes(this);

  /// التحقق من كون الحجم صغير
  bool get isSmall => index <= ComponentSize.sm.index;
  
  /// التحقق من كون الحجم كبير
  bool get isLarge => index >= ComponentSize.lg.index;
}

/// Extension للسياق للحصول على الحجم المتجاوب - مُصحح
extension ResponsiveSizeExtension on BuildContext {
  /// الحصول على الحجم المتجاوب
  ComponentSize get responsiveSize => AppSizeSystem.getResponsiveSize(this);
  
  /// الحصول على التخطيط المناسب للشاشة
  CrossAxisAlignment get responsiveAlignment {
    return isMobile ? CrossAxisAlignment.stretch : CrossAxisAlignment.center;
  }
  
  /// الحصول على عدد الأعمدة المناسب
  int get responsiveColumns {
    if (isMobile) return 1;
    if (isTablet) return 2;
    return 3;
  }
}