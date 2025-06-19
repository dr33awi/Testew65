// lib/app/themes/text_styles.dart
import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/theme_constants.dart';
/// نظام أنماط النصوص الموحد للتطبيق
class AppTextStyles {
  AppTextStyles._();

  // ===== الأنماط الأساسية للعناوين =====
  static const TextStyle h1 = TextStyle(
    fontSize: ThemeConstants.textSize4xl,
    fontWeight: ThemeConstants.bold,
    height: 1.3,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: ThemeConstants.textSize3xl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.3,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: -0.25,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: ThemeConstants.textSize2xl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.semiBold,
    height: 1.5,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== أنماط النص الأساسي =====
  static const TextStyle body1 = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.regular,
    height: 1.6,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.regular,
    height: 1.6,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle body3 = TextStyle(
    fontSize: ThemeConstants.textSizeSm,
    fontWeight: ThemeConstants.regular,
    height: 1.5,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== أنماط التسميات والعناصر التفاعلية =====
  static const TextStyle label1 = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.medium,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.1,
  );

  static const TextStyle label2 = TextStyle(
    fontSize: ThemeConstants.textSizeSm,
    fontWeight: ThemeConstants.medium,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.1,
  );

  static const TextStyle caption = TextStyle(
    fontSize: ThemeConstants.textSizeXs,
    fontWeight: ThemeConstants.regular,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.4,
  );

  // ===== أنماط الأزرار =====
  static const TextStyle button = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.1,
  );

  // ===== أنماط خاصة بالمحتوى الإسلامي =====
  static const TextStyle quran = TextStyle(
    fontSize: 22,
    fontWeight: ThemeConstants.regular,
    height: 2.2,
    fontFamily: ThemeConstants.fontFamilyQuran,
    letterSpacing: 0.5,
  );

  static const TextStyle athkar = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.regular,
    height: 1.8,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.2,
  );

  static const TextStyle dua = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.regular,
    height: 1.7,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.1,
  );

  static const TextStyle hadith = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.regular,
    height: 1.8,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.1,
  );

  // ===== أنماط العناصر التفاعلية =====
  static const TextStyle link = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.medium,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
    decoration: TextDecoration.underline,
  );

  static const TextStyle chip = TextStyle(
    fontSize: ThemeConstants.textSizeSm,
    fontWeight: ThemeConstants.medium,
    height: 1.2,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.1,
  );

  static const TextStyle badge = TextStyle(
    fontSize: ThemeConstants.textSizeXs,
    fontWeight: ThemeConstants.bold,
    height: 1.0,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: 0.2,
  );

  // ===== أنماط الأرقام والأوقات =====
  static const TextStyle number = TextStyle(
    fontSize: ThemeConstants.textSize2xl,
    fontWeight: ThemeConstants.bold,
    height: 1.0,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: -0.5,
  );

  static const TextStyle time = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.bold,
    height: 1.0,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: -0.25,
  );

  static const TextStyle counter = TextStyle(
    fontSize: ThemeConstants.textSize3xl,
    fontWeight: ThemeConstants.bold,
    height: 1.0,
    fontFamily: ThemeConstants.fontFamily,
    letterSpacing: -0.5,
  );

  // ===== دالة إنشاء TextTheme كاملة =====
  static TextTheme createTextTheme({
    required Color color,
    Color? secondaryColor,
  }) {
    final Color effectiveSecondaryColor = 
        secondaryColor ?? color.withValues(alpha: 0.7);
    
    return TextTheme(
      // Display styles
      displayLarge: h1.copyWith(color: color),
      displayMedium: h2.copyWith(color: color),
      displaySmall: h3.copyWith(color: color),
      
      // Headline styles
      headlineLarge: h1.copyWith(color: color),
      headlineMedium: h2.copyWith(color: color),
      headlineSmall: h3.copyWith(color: color),
      
      // Title styles
      titleLarge: h4.copyWith(color: color),
      titleMedium: h5.copyWith(color: color),
      titleSmall: h5.copyWith(
        color: color, 
        fontSize: ThemeConstants.textSizeMd,
      ),
      
      // Body styles
      bodyLarge: body1.copyWith(color: color),
      bodyMedium: body2.copyWith(color: effectiveSecondaryColor),
      bodySmall: caption.copyWith(color: effectiveSecondaryColor),
      
      // Label styles
      labelLarge: label1.copyWith(color: color),
      labelMedium: label2.copyWith(color: effectiveSecondaryColor),
      labelSmall: caption.copyWith(color: effectiveSecondaryColor),
    );
  }

  // ===== أنماط تفاعلية حسب السياق =====
  
  /// نص للعناوين الرئيسية في الصفحات
  static TextStyle pageTitle(BuildContext context) {
    return h2.copyWith(
      color: ThemeConstants.textPrimary(context),
    );
  }

  /// نص للعناوين الفرعية
  static TextStyle sectionTitle(BuildContext context) {
    return h4.copyWith(
      color: ThemeConstants.textPrimary(context),
    );
  }

  /// نص للمحتوى الرئيسي
  static TextStyle contentText(BuildContext context) {
    return body1.copyWith(
      color: ThemeConstants.textPrimary(context),
    );
  }

  /// نص للمعلومات الثانوية
  static TextStyle secondaryText(BuildContext context) {
    return body2.copyWith(
      color: ThemeConstants.textSecondary(context),
    );
  }

  /// نص للتلميحات
  static TextStyle hintText(BuildContext context) {
    return caption.copyWith(
      color: ThemeConstants.textSecondary(context).withValues(alpha: 0.7),
    );
  }

  /// نص للأخطاء
  static TextStyle errorText(BuildContext context) {
    return caption.copyWith(
      color: ThemeConstants.error,
      fontWeight: ThemeConstants.medium,
    );
  }

  /// نص للنجاح
  static TextStyle successText(BuildContext context) {
    return body2.copyWith(
      color: ThemeConstants.success,
      fontWeight: ThemeConstants.medium,
    );
  }

  /// نص للتحذيرات
  static TextStyle warningText(BuildContext context) {
    return body2.copyWith(
      color: ThemeConstants.warning,
      fontWeight: ThemeConstants.medium,
    );
  }

  /// نص للمعلومات
  static TextStyle infoText(BuildContext context) {
    return body2.copyWith(
      color: ThemeConstants.info,
      fontWeight: ThemeConstants.medium,
    );
  }

  /// نص للروابط
  static TextStyle linkText(BuildContext context) {
    return link.copyWith(
      color: ThemeConstants.primary,
    );
  }

  // ===== أنماط خاصة للمحتوى الإسلامي مع السياق =====
  
  /// نص القرآن الكريم
  static TextStyle quranText(BuildContext context, {Color? color}) {
    return quran.copyWith(
      color: color ?? ThemeConstants.textPrimary(context),
    );
  }

  /// نص الأذكار
  static TextStyle athkarText(BuildContext context, {Color? color}) {
    return athkar.copyWith(
      color: color ?? ThemeConstants.textPrimary(context),
    );
  }

  /// نص الدعاء
  static TextStyle duaText(BuildContext context, {Color? color}) {
    return dua.copyWith(
      color: color ?? ThemeConstants.textPrimary(context),
    );
  }

  /// نص الحديث الشريف
  static TextStyle hadithText(BuildContext context, {Color? color}) {
    return hadith.copyWith(
      color: color ?? ThemeConstants.textPrimary(context),
    );
  }

  // ===== أنماط للعناصر التفاعلية =====
  
  /// نص الرقم/العدد
  static TextStyle numberText(BuildContext context, {Color? color}) {
    return number.copyWith(
      color: color ?? ThemeConstants.primary,
    );
  }

  /// نص الوقت
  static TextStyle timeText(BuildContext context, {Color? color}) {
    return time.copyWith(
      color: color ?? ThemeConstants.textPrimary(context),
    );
  }

  /// نص العداد
  static TextStyle counterText(BuildContext context, {Color? color}) {
    return counter.copyWith(
      color: color ?? ThemeConstants.primary,
    );
  }

  // ===== أنماط للحالات الخاصة =====
  
  /// نص مع ظل (للخلفيات الملونة)
  static TextStyle shadowText(BuildContext context, {
    TextStyle? baseStyle,
    Color? textColor,
    Color shadowColor = Colors.black26,
  }) {
    final style = baseStyle ?? body1;
    return style.copyWith(
      color: textColor ?? Colors.white,
      shadows: [
        Shadow(
          color: shadowColor,
          offset: const Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    );
  }

  /// نص متدرج (للتأثيرات البصرية)
  static TextStyle gradientText(BuildContext context, {
    TextStyle? baseStyle,
    required List<Color> colors,
  }) {
    final style = baseStyle ?? body1;
    // هذا يتطلب ShaderMask في التطبيق
    return style.copyWith(
      foreground: Paint()
        ..shader = LinearGradient(colors: colors).createShader(
          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
        ),
    );
  }

  // ===== دوال مساعدة للتخصيص السريع =====
  
  /// إنشاء نمط مخصص
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize ?? ThemeConstants.textSizeMd,
      fontWeight: fontWeight ?? ThemeConstants.regular,
      color: color,
      height: height ?? 1.4,
      letterSpacing: letterSpacing ?? 0.0,
      decoration: decoration,
      fontFamily: fontFamily ?? ThemeConstants.fontFamily,
    );
  }

  /// تطبيق لون على نمط موجود
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// تطبيق حجم على نمط موجود
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// تطبيق وزن على نمط موجود
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
}