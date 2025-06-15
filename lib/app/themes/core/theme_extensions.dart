// lib/app/themes/core/theme_extensions.dart
import 'package:flutter/material.dart';
import '../theme_constants.dart';
import '../text_styles.dart';

/// Extensions لتسهيل الوصول للثيم
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // الألوان الأساسية
  Color get primaryColor => theme.primaryColor;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  Color get surfaceColor => colorScheme.surface;
  Color get surfaceVariant => ThemeConstants.surfaceVariant(this);
  Color get cardColor => theme.cardTheme.color ?? ThemeConstants.card(this);
  Color get errorColor => colorScheme.error;
  Color get dividerColor => theme.dividerTheme.color ?? ThemeConstants.divider(this);
  Color get outlineColor => ThemeConstants.outline(this);

  // ألوان النصوص
  Color get textPrimaryColor => ThemeConstants.textPrimary(this);
  Color get textSecondaryColor => ThemeConstants.textSecondary(this);
  Color get textHintColor => ThemeConstants.textHint(this);

  // الألوان الدلالية
  Color get successColor => ThemeConstants.success;
  Color get warningColor => ThemeConstants.warning;
  Color get infoColor => ThemeConstants.info;

  // ألوان إضافية من ColorScheme
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get secondaryColor => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;
  Color get tertiaryColor => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;

  // حالة الثيم
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;

  // أنماط النصوص - مباشرة من TextTheme
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

  // أنماط خاصة
  TextStyle get quranStyle => AppTextStyles.quran;
  TextStyle get athkarStyle => AppTextStyles.athkar;
  TextStyle get duaStyle => AppTextStyles.dua;

  // معلومات الشاشة
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // نوع الجهاز
  bool get isMobile => screenWidth < ThemeConstants.breakpointMobile;
  bool get isTablet => screenWidth >= ThemeConstants.breakpointMobile && screenWidth < ThemeConstants.breakpointTablet;
  bool get isDesktop => screenWidth >= ThemeConstants.breakpointTablet;
  bool get isWideScreen => screenWidth >= ThemeConstants.breakpointWide;

  // الحشوات المتجاوبة
  EdgeInsets get responsivePadding {
    if (isMobile) return const EdgeInsets.all(ThemeConstants.space4);
    if (isTablet) return const EdgeInsets.all(ThemeConstants.space6);
    if (isDesktop) return const EdgeInsets.all(ThemeConstants.space8);
    return const EdgeInsets.all(ThemeConstants.space10);
  }

  // معلومات النظام
  bool get isIOS => theme.platform == TargetPlatform.iOS;
  bool get isAndroid => theme.platform == TargetPlatform.android;
  bool get isMacOS => theme.platform == TargetPlatform.macOS;
  bool get isWindows => theme.platform == TargetPlatform.windows;
  bool get isLinux => theme.platform == TargetPlatform.linux;
  bool get isFuchsia => theme.platform == TargetPlatform.fuchsia;
  bool get isWeb => identical(0, 0.0); // Web platform check

  // لوحة المفاتيح
  bool get isKeyboardOpen => viewInsets.bottom > 0;
  double get keyboardHeight => viewInsets.bottom;

  // المناطق الآمنة
  double get safeTop => screenPadding.top;
  double get safeBottom => screenPadding.bottom;
  double get safeLeft => screenPadding.left;
  double get safeRight => screenPadding.right;

  // الاتجاه
  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  // حجم النص
  double get textScaleFactor => MediaQuery.textScaleFactorOf(this);
  
  // الوضع عالي التباين
  bool get isHighContrast => MediaQuery.highContrastOf(this);
  
  // تقليل الحركة
  bool get isReducedMotion => MediaQuery.disableAnimationsOf(this);
}

/// Extensions للألوان
extension ColorExtensions on Color {
  /// إنشاء لون بشفافية
  Color withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withValues(alpha: opacity);
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
        : ThemeConstants.neutral900;
  }

  /// مزج لونين
  Color blend(Color other, double amount) {
    assert(amount >= 0 && amount <= 1);
    return Color.lerp(this, other, amount)!;
  }

  /// تحويل إلى Hex
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
}

/// Extensions للنصوص
extension TextStyleExtensions on TextStyle {
  // الأوزان
  TextStyle get thin => copyWith(fontWeight: ThemeConstants.thin);
  TextStyle get extraLight => copyWith(fontWeight: ThemeConstants.extraLight);
  TextStyle get light => copyWith(fontWeight: ThemeConstants.light);
  TextStyle get regular => copyWith(fontWeight: ThemeConstants.regular);
  TextStyle get medium => copyWith(fontWeight: ThemeConstants.medium);
  TextStyle get semiBold => copyWith(fontWeight: ThemeConstants.semiBold);
  TextStyle get bold => copyWith(fontWeight: ThemeConstants.bold);
  TextStyle get extraBold => copyWith(fontWeight: ThemeConstants.extraBold);
  TextStyle get black => copyWith(fontWeight: ThemeConstants.black);

  // الحجم
  TextStyle size(double fontSize) => copyWith(fontSize: fontSize);
  
  // اللون
  TextStyle textColor(Color color) => copyWith(color: color);
  
  // الارتفاع
  TextStyle withHeight(double height) => copyWith(height: height);
  
  // التباعد
  TextStyle withSpacing(double letterSpacing) => copyWith(letterSpacing: letterSpacing);
  
  // الأنماط
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get overline => copyWith(decoration: TextDecoration.overline);
  
  // إزالة التزيين
  TextStyle get noDecoration => copyWith(decoration: TextDecoration.none);
  
  // التحكم في الأسطر
  TextStyle withMaxLines(int maxLines) => copyWith(overflow: TextOverflow.ellipsis);
  
  // العائلة
  TextStyle withFontFamily(String fontFamily) => copyWith(fontFamily: fontFamily);
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

  EdgeInsets multiply(double factor) => EdgeInsets.only(
    left: left * factor,
    top: top * factor,
    right: right * factor,
    bottom: bottom * factor,
  );

  EdgeInsets get onlyHorizontal => EdgeInsets.only(left: left, right: right);
  EdgeInsets get onlyVertical => EdgeInsets.only(top: top, bottom: bottom);
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
  BorderRadius get leftCircular => BorderRadius.only(
    topLeft: Radius.circular(toDouble()),
    bottomLeft: Radius.circular(toDouble()),
  );
  BorderRadius get rightCircular => BorderRadius.only(
    topRight: Radius.circular(toDouble()),
    bottomRight: Radius.circular(toDouble()),
  );

  // Duration
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get hours => Duration(hours: toInt());
  Duration get days => Duration(days: toInt());

  // نسبة مئوية
  double get percent => this / 100;
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

  /// تقسيم القائمة إلى مجموعات
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }

  /// الحصول على عنصر آمن
  T? safeAt(int index) => index >= 0 && index < length ? this[index] : null;

  /// الحصول على أول عنصر يطابق الشرط أو null
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}

/// Extensions للـ Maps
extension MapExtensions<K, V> on Map<K, V> {
  /// الحصول على قيمة بمفتاح آمن
  V? safeGet(K key) => containsKey(key) ? this[key] : null;

  /// تحديث قيمة إذا كان المفتاح موجود
  void updateIfExists(K key, V Function(V) update) {
    if (containsKey(key)) {
      this[key] = update(this[key] as V);
    }
  }
}

/// Extensions للـ Strings
extension StringExtensions on String {
  /// التحقق من أن النص فارغ أو يحتوي على مسافات فقط
  bool get isBlank => trim().isEmpty;
  
  /// التحقق من أن النص ليس فارغاً
  bool get isNotBlank => !isBlank;
  
  /// تحويل أول حرف إلى كبير
  String get capitalize => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  
  /// تحويل كل كلمة لتبدأ بحرف كبير
  String get title => split(' ').map((word) => word.capitalize).join(' ');
  
  /// إزالة المسافات الزائدة
  String get normalizeSpaces => replaceAll(RegExp(r'\s+'), ' ').trim();
  
  /// قص النص مع إضافة ...
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
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
    BoxConstraints? constraints,
    AlignmentGeometry? alignment,
  }) => Container(
    padding: padding,
    margin: margin,
    decoration: decoration,
    color: color,
    width: width,
    height: height,
    constraints: constraints,
    alignment: alignment,
    child: this,
  );

  /// إضافة InkWell
  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
  }) => InkWell(
    onTap: onTap,
    onLongPress: onLongPress,
    onDoubleTap: onDoubleTap,
    borderRadius: borderRadius,
    splashColor: splashColor,
    highlightColor: highlightColor,
    child: this,
  );

  /// إضافة GestureDetector
  Widget gesture({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    GestureDragUpdateCallback? onPanUpdate,
    GestureDragEndCallback? onPanEnd,
  }) => GestureDetector(
    onTap: onTap,
    onLongPress: onLongPress,
    onDoubleTap: onDoubleTap,
    onPanUpdate: onPanUpdate,
    onPanEnd: onPanEnd,
    child: this,
  );

  /// إضافة تأثير تلاشي
  Widget opacity(double opacity) => Opacity(
    opacity: opacity,
    child: this,
  );

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

  /// إضافة ClipRRect
  Widget clipRRect(double radius) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: this,
  );

  /// إضافة ClipOval
  Widget get clipOval => ClipOval(child: this);

  /// إضافة Card
  Widget card({
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? color,
    ShapeBorder? shape,
    EdgeInsetsGeometry? padding,
  }) => Card(
    margin: margin,
    elevation: elevation,
    color: color,
    shape: shape,
    child: padding != null ? Padding(padding: padding, child: this) : this,
  );

  /// إضافة Align
  Widget align(AlignmentGeometry alignment) => Align(
    alignment: alignment,
    child: this,
  );

  /// إضافة FittedBox
  Widget get fitted => FittedBox(child: this);

  /// إضافة Hero animation
  Widget hero(String tag) => Hero(tag: tag, child: this);

  /// إخفاء/إظهار Widget
  Widget visible(bool isVisible, {Widget? replacement}) => Visibility(
    visible: isVisible,
    replacement: replacement ?? const SizedBox.shrink(),
    child: this,
  );

  /// إضافة Positioned
  Widget positioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) => Positioned(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
    width: width,
    height: height,
    child: this,
  );

  /// إضافة SafeArea
  Widget get safeArea => SafeArea(child: this);

  /// إضافة SingleChildScrollView
  Widget get scrollable => SingleChildScrollView(child: this);

  /// إضافة Shimmer effect
  Widget shimmer({
    required Color baseColor,
    required Color highlightColor,
  }) => AnimatedContainer(
    duration: const Duration(milliseconds: 1500),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [baseColor, highlightColor, baseColor],
        stops: const [0.0, 0.5, 1.0],
      ),
    ),
    child: this,
  );
}

/// Extensions للـ BuildContext - إضافية
extension BuildContextExtensions on BuildContext {
  /// عرض SnackBar سريع
  void showSnackBar(String message, {Duration? duration, SnackBarAction? action}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
        action: action,
      ),
    );
  }

  /// التنقل
  Future<T?> push<T>(Widget page) => Navigator.push<T>(
    this,
    MaterialPageRoute(builder: (_) => page),
  );

  Future<T?> pushReplacement<T>(Widget page) => Navigator.pushReplacement<T, T>(
    this,
    MaterialPageRoute(builder: (_) => page),
  );

  void pop<T>([T? result]) => Navigator.pop(this, result);

  /// عرض Dialog سريع
  Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) => showDialog<T>(
    context: this,
    barrierDismissible: barrierDismissible,
    builder: (_) => child,
  );

  /// عرض BottomSheet
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) => showModalBottomSheet<T>(
    context: this,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (_) => child,
  );

  /// الحصول على arguments من Route
  T? getArguments<T>() => ModalRoute.of(this)?.settings.arguments as T?;
}