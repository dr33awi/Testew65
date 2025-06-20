// lib/app/themes/index.dart
// النقطة الواحدة لاستيراد نظام الثيم المبسط

// ==================== الملفات الأساسية ====================
export 'theme_constants.dart';
export 'typography.dart';
export 'widgets.dart';
export 'app_theme.dart';

// ==================== Extensions مفيدة ====================

import 'package:flutter/material.dart';
import 'theme_constants.dart';
import 'typography.dart';

/// Extension methods لسهولة الوصول للثيم
extension BuildContextTheme on BuildContext {
  // ==================== الثيم العام ====================
  
  /// الحصول على الثيم الحالي
  ThemeData get theme => Theme.of(this);
  
  /// الحصول على نظام الألوان
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// الحصول على نظام النصوص
  TextTheme get textTheme => theme.textTheme;
  
  /// فحص إذا كان الوضع الداكن نشط
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  // ==================== الألوان السريعة ====================
  
  /// اللون الأساسي
  Color get primaryColor => isDarkMode ? ThemeConstants.primaryLight : ThemeConstants.primary;
  
  /// اللون الثانوي
  Color get secondaryColor => isDarkMode ? ThemeConstants.secondaryLight : ThemeConstants.secondary;
  
  /// لون الخلفية
  Color get backgroundColor => isDarkMode ? ThemeConstants.darkBackground : ThemeConstants.lightBackground;
  
  /// لون السطح
  Color get surfaceColor => isDarkMode ? ThemeConstants.darkSurface : ThemeConstants.lightSurface;
  
  /// لون البطاقة
  Color get cardColor => isDarkMode ? ThemeConstants.darkCard : ThemeConstants.lightCard;
  
  /// لون النص الأساسي
  Color get textColor => isDarkMode ? ThemeConstants.darkText : ThemeConstants.lightText;
  
  /// لون النص الثانوي
  Color get secondaryTextColor => isDarkMode ? ThemeConstants.darkTextSecondary : ThemeConstants.lightTextSecondary;
  
  /// لون النص التوضيحي
  Color get hintTextColor => isDarkMode ? ThemeConstants.darkTextHint : ThemeConstants.lightTextHint;
  
  /// لون الحدود
  Color get borderColor => isDarkMode ? ThemeConstants.darkBorder : ThemeConstants.lightBorder;
  
  /// لون الخطأ
  Color get errorColor => ThemeConstants.error;
  
  /// لون النجاح
  Color get successColor => ThemeConstants.success;
  
  /// لون التحذير
  Color get warningColor => ThemeConstants.warning;
  
  /// لون المعلومات
  Color get infoColor => ThemeConstants.info;
  
  // ==================== النصوص السريعة ====================
  
  /// نص العنوان الكبير
  TextStyle get headingStyle => AppTypography.heading.copyWith(color: textColor);
  
  /// نص العنوان
  TextStyle get titleStyle => AppTypography.title.copyWith(color: textColor);
  
  /// نص العنوان الفرعي
  TextStyle get subtitleStyle => AppTypography.subtitle.copyWith(color: textColor);
  
  /// نص الجسم
  TextStyle get bodyStyle => AppTypography.body.copyWith(color: textColor);
  
  /// نص التوضيح
  TextStyle get captionStyle => AppTypography.caption.copyWith(color: secondaryTextColor);
  
  /// نص الأزرار
  TextStyle get buttonStyle => AppTypography.button.copyWith(color: textColor);
  
  // نصوص إسلامية
  TextStyle get quranStyle => AppTypography.quran.copyWith(color: textColor);
  TextStyle get hadithStyle => AppTypography.hadith.copyWith(color: textColor);
  TextStyle get duaStyle => AppTypography.dua.copyWith(color: textColor);
  TextStyle get tasbihStyle => AppTypography.tasbih.copyWith(color: textColor);
  
  // ==================== المسافات والأحجام ====================
  
  /// مساحة صغيرة
  double get smallPadding => ThemeConstants.spaceSm;
  
  /// مساحة متوسطة
  double get mediumPadding => ThemeConstants.spaceMd;
  
  /// مساحة كبيرة
  double get largePadding => ThemeConstants.spaceLg;
  
  /// زاوية مدورة صغيرة
  double get smallRadius => ThemeConstants.radiusSm;
  
  /// زاوية مدورة متوسطة
  double get mediumRadius => ThemeConstants.radiusMd;
  
  /// زاوية مدورة كبيرة
  double get largeRadius => ThemeConstants.radiusLg;
  
  // ==================== الرسائل السريعة ====================
  
  /// عرض رسالة نجاح
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
        ),
      ),
    );
  }
  
  /// عرض رسالة خطأ
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
        ),
      ),
    );
  }
  
  /// عرض رسالة تحذير
  void showWarningMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
        ),
      ),
    );
  }
  
  /// عرض رسالة معلومات
  void showInfoMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
        ),
      ),
    );
  }
  
  /// عرض رسالة عادية
  void showMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mediumRadius),
        ),
      ),
    );
  }
}

/// Extension methods للمسافات السريعة
extension SpacingExtension on double {
  /// مساحة عمودية
  Widget get verticalSpace => SizedBox(height: this);
  
  /// مساحة أفقية
  Widget get horizontalSpace => SizedBox(width: this);
  
  /// حشو متساوي من جميع الجهات
  EdgeInsets get paddingAll => EdgeInsets.all(this);
  
  /// حشو أفقي
  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: this);
  
  /// حشو عمودي
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: this);
  
  /// زاوية مدورة
  BorderRadius get borderRadius => BorderRadius.circular(this);
  
  /// زاوية مدورة للراديوس
  Radius get radius => Radius.circular(this);
}

/// Extension methods للـ Widget
extension WidgetExtensions on Widget {
  /// إضافة حشو متساوي
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
  
  /// إضافة Opacity
  Widget opacity(double opacity) => Opacity(opacity: opacity, child: this);
  
  /// إضافة Visibility
  Widget visible(bool visible) => Visibility(visible: visible, child: this);
  
  /// إضافة ClipRRect
  Widget clipRRect(double radius) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
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
}

/// Extension methods للقوائم
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
  
  /// إضافة مساحات عمودية بين العناصر
  List<Widget> separatedVertical(double height) {
    return separated(SizedBox(height: height));
  }
  
  /// إضافة مساحات أفقية بين العناصر
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

/// Extension methods للألوان
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
    return '#${(0xFF000000 | value).toRadixString(16).substring(2).toUpperCase()}';
  }
}