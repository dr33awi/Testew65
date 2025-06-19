// lib/app/themes/core/theme_extensions.dart
import 'package:flutter/material.dart';
import '../theme_constants.dart';
import '../text_styles.dart';

/// امتدادات سياق الثيم - وصول موحد لخصائص الثيم
extension ThemeExtension on BuildContext {
  // ===== الثيم الأساسي =====
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // ===== الألوان الأساسية =====
  Color get primaryColor => theme.primaryColor;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  Color get surfaceColor => colorScheme.surface;
  Color get cardColor => theme.cardTheme.color ?? ThemeConstants.card(this);
  Color get errorColor => colorScheme.error;
  Color get dividerColor => theme.dividerTheme.color ?? ThemeConstants.divider(this);

  // ===== ألوان النصوص =====
  Color get textPrimaryColor => ThemeConstants.textPrimary(this);
  Color get textSecondaryColor => ThemeConstants.textSecondary(this);

  // ===== الألوان الدلالية =====
  Color get successColor => ThemeConstants.success;
  Color get warningColor => ThemeConstants.warning;
  Color get infoColor => ThemeConstants.info;

  // ===== حالة الثيم =====
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;

  // ===== أنماط النصوص من TextTheme =====
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

/// امتدادات الألوان - عمليات متقدمة على الألوان
extension ColorExtensions on Color {
  /// تطبيق شفافية آمنة
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

  /// الحصول على لون نص متباين
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

  /// تشبع اللون
  Color saturate([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    final saturation = (hsl.saturation + amount).clamp(0.0, 1.0);
    return hsl.withSaturation(saturation).toColor();
  }

  /// إزالة التشبع
  Color desaturate([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    final saturation = (hsl.saturation - amount).clamp(0.0, 1.0);
    return hsl.withSaturation(saturation).toColor();
  }
}

/// امتدادات أنماط النص - تخصيص سريع
extension TextStyleExtensions on TextStyle {
  // ===== أوزان الخط =====
  TextStyle get bold => copyWith(fontWeight: ThemeConstants.bold);
  TextStyle get semiBold => copyWith(fontWeight: ThemeConstants.semiBold);
  TextStyle get medium => copyWith(fontWeight: ThemeConstants.medium);
  TextStyle get regular => copyWith(fontWeight: ThemeConstants.regular);
  TextStyle get light => copyWith(fontWeight: ThemeConstants.light);

  // ===== خصائص النص =====
  TextStyle size(double fontSize) => copyWith(fontSize: fontSize);
  TextStyle textColor(Color color) => copyWith(color: color);
  TextStyle withHeight(double height) => copyWith(height: height);
  TextStyle withSpacing(double letterSpacing) => copyWith(letterSpacing: letterSpacing);
  
  // ===== تأثيرات النص =====
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
  
  /// ظل للنص
  TextStyle withShadow({
    Color color = Colors.black26,
    Offset offset = const Offset(0, 2),
    double blurRadius = 4,
  }) {
    return copyWith(
      shadows: [
        Shadow(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
        ),
      ],
    );
  }
}

/// امتدادات الحواف - عمليات على EdgeInsets
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

  EdgeInsets scale(double factor) => EdgeInsets.only(
    left: left * factor,
    top: top * factor,
    right: right * factor,
    bottom: bottom * factor,
  );
}

/// امتدادات الأرقام - بناء widgets سريع
extension NumberExtensions on num {
  // ===== مسافات =====
  SizedBox get w => SizedBox(width: toDouble());
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get wh => SizedBox(width: toDouble(), height: toDouble());

  // ===== حشوات =====
  EdgeInsets get all => EdgeInsets.all(toDouble());
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get left => EdgeInsets.only(left: toDouble());
  EdgeInsets get top => EdgeInsets.only(top: toDouble());
  EdgeInsets get right => EdgeInsets.only(right: toDouble());
  EdgeInsets get bottom => EdgeInsets.only(bottom: toDouble());

  // ===== زوايا دائرية =====
  BorderRadius get circular => BorderRadius.circular(toDouble());
  BorderRadius get topCircular => BorderRadius.only(
    topLeft: Radius.circular(toDouble()),
    topRight: Radius.circular(toDouble()),
  );
  BorderRadius get bottomCircular => BorderRadius.only(
    bottomLeft: Radius.circular(toDouble()),
    bottomRight: Radius.circular(toDouble()),
  );

  // ===== Slivers =====
  Widget get sliverBox => SliverToBoxAdapter(
    child: SizedBox(height: toDouble()),
  );
  
  Widget get sliverBoxHorizontal => SliverToBoxAdapter(
    child: SizedBox(width: toDouble()),
  );

  // ===== مدة زمنية =====
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
}

/// امتدادات القوائم - عمليات على Lists
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

  /// إدراج separator بين العناصر
  List<Widget> separatedBy(Widget separator) {
    if (whereType<Widget>().isEmpty) return <Widget>[];
    
    final widgets = whereType<Widget>().toList();
    final result = <Widget>[];
    
    for (var i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}

/// امتدادات الـ Widgets - تحسينات سريعة
extension WidgetExtensions on Widget {
  // ===== التخطيط =====
  Widget padded(EdgeInsetsGeometry padding) => Padding(
    padding: padding,
    child: this,
  );

  Widget get centered => Center(child: this);

  Widget get expanded => Expanded(child: this);

  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) => Flexible(
    flex: flex,
    fit: fit,
    child: this,
  );

  // ===== الحاويات =====
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

  // ===== التفاعل =====
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

  Widget gestureDetector({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
  }) => GestureDetector(
    onTap: onTap,
    onLongPress: onLongPress,
    onDoubleTap: onDoubleTap,
    child: this,
  );

  // ===== التأثيرات =====
  Widget opacity(double opacity) {
    final safeOpacity = opacity.clamp(0.0, 1.0);
    return Opacity(
      opacity: safeOpacity,
      child: this,
    );
  }

  Widget rotate(double angle) => Transform.rotate(
    angle: angle,
    child: this,
  );

  Widget scale(double scale) => Transform.scale(
    scale: scale,
    child: this,
  );

  // ===== الحركات =====
  Widget fadeIn({
    Duration duration = ThemeConstants.durationNormal,
    Curve curve = ThemeConstants.curveDefault,
  }) => AnimatedOpacity(
    opacity: 1.0,
    duration: duration,
    curve: curve,
    child: this,
  );

  Widget slideInFromBottom({
    Duration duration = ThemeConstants.durationNormal,
    Curve curve = ThemeConstants.curveDefault,
  }) => AnimatedSlide(
    offset: Offset.zero,
    duration: duration,
    curve: curve,
    child: this,
  );

  // ===== الأمان =====
  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) => SafeArea(
    top: top,
    bottom: bottom,
    left: left,
    right: right,
    child: this,
  );

  // ===== التمرير =====
  Widget scrollable({
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
  }) => SingleChildScrollView(
    physics: physics,
    padding: padding,
    child: this,
  );

  // ===== الشرطية =====
  Widget conditional(bool condition) => condition ? this : const SizedBox.shrink();

  Widget conditionalWrap(bool condition, Widget Function(Widget) wrapper) {
    return condition ? wrapper(this) : this;
  }
}

/// امتدادات SnackBar - رسائل سريعة
extension SnackBarExtensions on BuildContext {
  void showSuccessSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: ThemeConstants.iconSm),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeConstants.success,
        duration: duration ?? const Duration(milliseconds: ThemeConstants.durationSlow),
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }

  void showErrorSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: ThemeConstants.iconSm),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeConstants.error,
        duration: duration ?? const Duration(milliseconds: ThemeConstants.durationSlow),
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }

  void showInfoSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: ThemeConstants.iconSm),
            ThemeConstants.space2.w,
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ThemeConstants.info,
        duration: duration ?? const Duration(milliseconds: ThemeConstants.durationSlow),
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }

  void showWarningSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.black87, size: ThemeConstants.iconSm),
            ThemeConstants.space2.w,
            Expanded(child: Text(message, style: const TextStyle(color: Colors.black87))),
          ],
        ),
        backgroundColor: ThemeConstants.warning,
        duration: duration ?? const Duration(milliseconds: ThemeConstants.durationSlow),
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }

  void hideSnackBars() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }
}