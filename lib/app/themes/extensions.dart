// lib/app/themes/extensions.dart
import 'package:flutter/material.dart';
import 'theme_constants.dart';

// ==================== Theme Extensions ====================

extension BuildContextTheme on BuildContext {
  // الثيم العام
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  // الألوان السريعة
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  Color get cardColor => theme.cardTheme.color!;
  Color get textColor => colorScheme.onSurface;
  Color get secondaryTextColor => isDarkMode 
      ? ThemeConstants.darkTextSecondary 
      : ThemeConstants.lightTextSecondary;
  Color get borderColor => isDarkMode 
      ? ThemeConstants.darkBorder 
      : ThemeConstants.lightBorder;
  Color get surfaceColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;
  
  // الأحجام السريعة
  double get smallPadding => ThemeConstants.spaceSm;
  double get mediumPadding => ThemeConstants.spaceMd;
  double get largePadding => ThemeConstants.spaceLg;
  
  double get borderRadius => ThemeConstants.radiusMd;
  double get cardRadius => ThemeConstants.radiusLg;
  
  // مساعدات الرسائل
  void showMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.success,
      ),
    );
  }
  
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.error,
      ),
    );
  }
  
  void showWarningMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.warning,
      ),
    );
  }
  
  void showInfoMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.info,
      ),
    );
  }
}

// ==================== Spacing Extensions ====================

extension SpacingExtension on double {
  Widget get h => SizedBox(height: this);
  Widget get w => SizedBox(width: this);
  
  EdgeInsets get paddingAll => EdgeInsets.all(this);
  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: this);
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: this);
  EdgeInsets get paddingTop => EdgeInsets.only(top: this);
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: this);
  EdgeInsets get paddingLeft => EdgeInsets.only(left: this);
  EdgeInsets get paddingRight => EdgeInsets.only(right: this);
  
  BorderRadius get borderRadius => BorderRadius.circular(this);
  Radius get radius => Radius.circular(this);
}

// ==================== Widget Extensions ====================

extension WidgetExtensions on Widget {
  /// إضافة حشو للWidget
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  /// إضافة حشو أفقي
  Widget paddingHorizontal(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  /// إضافة حشو عمودي
  Widget paddingVertical(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  /// إضافة حشو مخصص
  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// إضافة هامش
  Widget marginAll(double margin) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: this,
    );
  }

  /// إضافة هامش أفقي
  Widget marginHorizontal(double margin) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: this,
    );
  }

  /// إضافة هامش عمودي
  Widget marginVertical(double margin) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      child: this,
    );
  }

  /// جعل Widget مرن
  Widget get expanded => Expanded(child: this);
  
  /// جعل Widget مرن بـ flex محدد
  Widget flex(int flex) => Expanded(flex: flex, child: this);
  
  /// جعل Widget مرن ومرن
  Widget get flexible => Flexible(child: this);
  
  /// توسيط Widget
  Widget get center => Center(child: this);
  
  /// محاذاة Widget
  Widget align(AlignmentGeometry alignment) => Align(
    alignment: alignment,
    child: this,
  );
  
  /// إضافة Hero tag
  Widget hero(String tag) => Hero(tag: tag, child: this);
  
  /// إضافة Opacity
  Widget opacity(double opacity) => Opacity(opacity: opacity, child: this);
  
  /// إضافة Visibility
  Widget visible(bool visible) => Visibility(visible: visible, child: this);
  
  /// إضافة ClipRRect
  Widget clipRRect(double radius) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: this,
  );
  
  /// إضافة Container مع خصائص
  Widget container({
    Color? color,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
  }) => Container(
    color: color,
    width: width,
    height: height,
    padding: padding,
    margin: margin,
    decoration: decoration,
    child: this,
  );
  
  /// إضافة Card
  Widget card({
    Color? color,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) => Card(
    color: color,
    elevation: elevation,
    margin: margin,
    child: this,
  );
  
  /// إضافة InkWell
  Widget inkWell({
    VoidCallback? onTap,
    BorderRadius? borderRadius,
  }) => InkWell(
    onTap: onTap,
    borderRadius: borderRadius,
    child: this,
  );
  
  /// إضافة GestureDetector
  Widget onTap(VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: this,
  );
  
  /// إضافة SafeArea
  Widget get safeArea => SafeArea(child: this);
  
  /// إضافة SingleChildScrollView
  Widget get scrollable => SingleChildScrollView(child: this);
  
  /// إضافة Expanded داخل Column أو Row
  Widget get expand => Expanded(child: this);
}

// ==================== Color Extensions ====================

extension ColorExtensions on Color {
  /// الحصول على لون أفتح
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// الحصول على لون أغمق
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// الحصول على لون شفاف
  Color withAlpha(double alpha) {
    return withValues(alpha: alpha);
  }
  
  /// تحويل إلى نص hex
  String toHex() {
    return '#${value.toRadixString(16).substring(2).toUpperCase()}';
  }
}

// ==================== String Extensions ====================

extension StringExtensions on String {
  /// فحص النص العربي
  bool get isArabic {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(this);
  }
  
  /// الحصول على اتجاه النص
  TextDirection get textDirection {
    return isArabic ? TextDirection.rtl : TextDirection.ltr;
  }
  
  /// تحويل النص إلى widget
  Widget toText({
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      this,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: textDirection,
    );
  }
}

// ==================== List Extensions ====================

extension ListWidgetExtensions on List<Widget> {
  /// إضافة مساحات بين العناصر
  List<Widget> separated(Widget separator) {
    if (isEmpty) return this;
    
    final result = <Widget>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
  
  /// إضافة مساحات عمودية
  List<Widget> separatedVertical(double height) {
    return separated(SizedBox(height: height));
  }
  
  /// إضافة مساحات أفقية
  List<Widget> separatedHorizontal(double width) {
    return separated(SizedBox(width: width));
  }
  
  /// تحويل إلى Column
  Widget toColumn({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: this,
    );
  }
  
  /// تحويل إلى Row
  Widget toRow({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: this,
    );
  }
  
  /// تحويل إلى Wrap
  Widget toWrap({
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0.0,
    double runSpacing = 0.0,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
  }) {
    return Wrap(
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      children: this,
    );
  }
}