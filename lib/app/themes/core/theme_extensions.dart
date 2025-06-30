// lib/app/themes/core/theme_extensions.dart - محسن مع إزالة SnackBarExtension المكرر
import 'package:athkar_app/app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import '../theme_constants.dart';

/// Extensions لتسهيل الوصول للثيم مع ضمان التطابق الكامل
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // ===== الألوان الأساسية - مضمونة التطابق مع ThemeConstants =====
  
  /// اللون الأساسي - نفس ThemeConstants.primary بالضبط
  Color get primaryColor => ThemeConstants.primary;
  
  /// اللون الأساسي الفاتح - نفس ThemeConstants.primaryLight بالضبط
  Color get primaryLightColor => ThemeConstants.primaryLight;
  
  /// اللون الأساسي الداكن - نفس ThemeConstants.primaryDark بالضبط
  Color get primaryDarkColor => ThemeConstants.primaryDark;

  // ===== الألوان الثانوية =====
  
  /// اللون الثانوي (الذهبي) - نفس ThemeConstants.accent بالضبط
  Color get accentColor => ThemeConstants.accent;
  
  /// اللون الثانوي الفاتح
  Color get accentLightColor => ThemeConstants.accentLight;
  
  /// اللون الثانوي الداكن
  Color get accentDarkColor => ThemeConstants.accentDark;

  // ===== اللون الثالث (البني) =====
  
  /// اللون الثالث - نفس ThemeConstants.tertiary بالضبط
  Color get tertiaryColor => ThemeConstants.tertiary;
  
  /// اللون الثالث الفاتح
  Color get tertiaryLightColor => ThemeConstants.tertiaryLight;
  
  /// اللون الثالث الداكن
  Color get tertiaryDarkColor => ThemeConstants.tertiaryDark;

  // ===== الألوان الدلالية - مطابقة تماماً لـ ThemeConstants =====
  
  /// لون النجاح - نفس ThemeConstants.success (= primary) بالضبط
  Color get successColor => ThemeConstants.success;
  
  /// لون النجاح الفاتح
  Color get successLightColor => ThemeConstants.successLight;
  
  /// لون الخطأ - نفس ThemeConstants.error بالضبط
  Color get errorColor => ThemeConstants.error;
  
  /// لون التحذير - نفس ThemeConstants.warning بالضبط
  Color get warningColor => ThemeConstants.warning;
  
  /// لون التحذير الفاتح
  Color get warningLightColor => ThemeConstants.warningLight;
  
  /// لون المعلومات - نفس ThemeConstants.info بالضبط
  Color get infoColor => ThemeConstants.info;
  
  /// لون المعلومات الفاتح
  Color get infoLightColor => ThemeConstants.infoLight;

  // ===== ألوان الخلفيات والأسطح =====
  
  /// لون الخلفية الرئيسية
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  
  /// لون السطح - متجاوب مع الوضع الليلي/النهاري
  Color get surfaceColor => isDarkMode 
      ? ThemeConstants.darkTextPrimary  // أبيض في الوضع الليلي
      : Colors.white;                   // أبيض في النهاري
  
  /// لون البطاقات
  Color get cardColor => theme.cardTheme.color ?? ThemeConstants.card(this);
  
  /// لون الفواصل
  Color get dividerColor => theme.dividerTheme.color ?? ThemeConstants.divider(this);

  // ===== ألوان النصوص =====
  
  /// لون النص الأساسي
  Color get textPrimaryColor => ThemeConstants.textPrimary(this);
  
  /// لون النص الثانوي
  Color get textSecondaryColor => ThemeConstants.textSecondary(this);

  // ===== التدرجات الأساسية - نفس ThemeConstants بالضبط =====
  
  /// التدرج الأساسي - نفس ThemeConstants.primaryGradient بالضبط
  LinearGradient get primaryGradient => ThemeConstants.primaryGradient;
  
  /// التدرج الثانوي - نفس ThemeConstants.accentGradient بالضبط
  LinearGradient get accentGradient => ThemeConstants.accentGradient;
  
  /// التدرج الثالث - نفس ThemeConstants.tertiaryGradient بالضبط
  LinearGradient get tertiaryGradient => ThemeConstants.tertiaryGradient;
  
  /// تدرج النجاح
  LinearGradient get successGradient => const LinearGradient(
    colors: [ThemeConstants.success, ThemeConstants.successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== دوال الـ gradients المتخصصة - نفس ThemeConstants =====
  
  /// الحصول على تدرج حسب اسم الصلاة
  LinearGradient prayerGradient(String prayerName) => 
    ThemeConstants.prayerGradient(prayerName);
  
  /// الحصول على تدرج حسب الوقت
  LinearGradient getTimeBasedGradient({DateTime? dateTime}) => 
    ThemeConstants.getTimeBasedGradient();
  
  /// الحصول على لون حسب اسم الصلاة
  Color getPrayerColor(String prayerName) => 
    ThemeConstants.getPrayerColor(prayerName);
  
  /// الحصول على أيقونة حسب اسم الصلاة
  IconData getPrayerIcon(String prayerName) =>
    ThemeConstants.getPrayerIcon(prayerName);

  // ===== دوال الفئات المبسطة =====
  
  /// الحصول على لون فئة الأذكار
  Color getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
        return ThemeConstants.primary;
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
        return ThemeConstants.accent;
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
        return ThemeConstants.tertiary;
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return ThemeConstants.primaryLight;
      default:
        return ThemeConstants.primary;
    }
  }
  
  /// الحصول على تدرج فئة الأذكار
  LinearGradient getCategoryGradient(String categoryId) {
    final color = getCategoryColor(categoryId);
    return LinearGradient(
      colors: [color, color.darken(0.1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // ===== حالة الثيم =====
  
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;

  // ===== أنماط النصوص - مباشرة من TextTheme =====
  
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
  /// ✅ إنشاء لون بشفافية - مُصحح لـ Flutter 3.27+
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

  /// الحصول على لون متباين للنص
  Color get contrastingTextColor {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  /// تحويل إلى Material Color
  MaterialColor toMaterialColor() {
    final strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    final swatch = <int, Color>{};
    
    for (var i = 0; i < strengths.length; i++) {
      final strength = strengths[i];
      swatch[(strength * 1000).round()] = i < 5
          ? lighten(strength)
          : darken(strength - 0.5);
    }
    
    return MaterialColor(value, swatch);
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

  EdgeInsets get copyWith => EdgeInsets.only(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
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

  /// ✅ إضافة تأثير تلاشي - مُصحح
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

// ✅ SnackBar Extensions - في ملف منفصل ولكن ستوضع هنا حتى يصلح المشروع
// سيتم استيرادها من AppSnackBar مباشرة في الـ screens
extension SnackBarHelperExtension on BuildContext {
  void showSuccessSnackBar(
    String message, {
    Duration? duration, 
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    // سيتم استدعاء AppSnackBar.showSuccess مباشرة في الشاشات
    // هذا extension للمساعدة فقط
  }

  void showErrorSnackBar(
    String message, {
    Duration? duration, 
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    // سيتم استدعاء AppSnackBar.showError مباشرة في الشاشات
  }

  void showInfoSnackBar(
    String message, {
    Duration? duration, 
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    // سيتم استدعاء AppSnackBar.showInfo مباشرة في الشاشات
  }

  void showWarningSnackBar(
    String message, {
    Duration? duration, 
    SnackBarAction? action,
    bool enableGlass = true,
  }) {
    // سيتم استدعاء AppSnackBar.showWarning مباشرة في الشاشات
  }

  void showLoadingSnackBar(String message, {bool enableGlass = true}) {
    // سيتم استدعاء AppSnackBar.showLoading مباشرة في الشاشات
  }

  void hideSnackBars() {
    // سيتم استدعاء AppSnackBar.hideAll مباشرة في الشاشات
  }
}