// lib/app/components/app_text.dart
// مكون النص الموحد للتطبيق

import 'package:athkar_app/app/themes/typography.dart';
import 'package:athkar_app/app/themes/widgets.dart';
import 'package:flutter/material.dart';


/// نص التطبيق الموحد
/// لتغيير أنماط النصوص في التطبيق، عدل هنا فقط!
class AppText extends StatelessWidget {
  final String text;
  final AppTextStyle style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;

  const AppText(
    this.text, {
    super.key,
    this.style = AppTextStyle.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
  });

  /// عنوان كبير
  factory AppText.heading({
    required String text,
    Color? color,
    TextAlign? textAlign,
  }) {
    return AppText(
      text,
      style: AppTextStyle.heading,
      color: color,
      textAlign: textAlign,
    );
  }

  /// عنوان متوسط
  factory AppText.title({
    required String text,
    Color? color,
    TextAlign? textAlign,
  }) {
    return AppText(
      text,
      style: AppTextStyle.title,
      color: color,
      textAlign: textAlign,
    );
  }

  /// عنوان فرعي
  factory AppText.subtitle({
    required String text,
    Color? color,
    TextAlign? textAlign,
  }) {
    return AppText(
      text,
      style: AppTextStyle.subtitle,
      color: color,
      textAlign: textAlign,
    );
  }

  /// نص عادي
  factory AppText.body({
    required String text,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    return AppText(
      text,
      style: AppTextStyle.body,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  /// نص صغير
  factory AppText.caption({
    required String text,
    Color? color,
    TextAlign? textAlign,
  }) {
    return AppText(
      text,
      style: AppTextStyle.caption,
      color: color,
      textAlign: textAlign,
    );
  }

  /// تسمية
  factory AppText.label({
    required String text,
    Color? color,
    TextAlign? textAlign,
  }) {
    return AppText(
      text,
      style: AppTextStyle.label,
      color: color,
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = _getTextStyle(context);
    
    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: _getTextDirection(),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    // هنا يمكنك تغيير التنفيذ الداخلي!
    
TextStyle baseStyle = switch (style) {
  AppTextStyle.heading => AppTypography.heading,
  AppTextStyle.title => AppTypography.title,
  AppTextStyle.subtitle => AppTypography.subtitle,
  AppTextStyle.body => AppTypography.body,
  AppTextStyle.bodyLarge => AppTypography.bodyLarge,
  AppTextStyle.caption => AppTypography.caption,
  AppTextStyle.label => AppTypography.button, // استخدام button بدلاً من labelText
};

    // تطبيق اللون المخصص
    if (color != null) {
      baseStyle = baseStyle.copyWith(color: color);
    } else {
      // لون افتراضي حسب الثيم
      final isDark = Theme.of(context).brightness == Brightness.dark;
      baseStyle = baseStyle.copyWith(
        color: isDark ? Colors.white : Colors.black87,
      );
    }

    // تطبيق الحجم المخصص
    if (fontSize != null) {
      baseStyle = baseStyle.copyWith(fontSize: fontSize);
    }

    return baseStyle;
  }

  TextDirection _getTextDirection() {
    // تحديد اتجاه النص تلقائياً
    if (_isArabicText(text)) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  bool _isArabicText(String text) {
    // فحص بسيط للنصوص العربية
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }
}

/// نص إسلامي متخصص
class AppIslamicText extends StatelessWidget {
  final String text;
  final AppIslamicTextType type;
  final Color? color;
  final TextAlign? textAlign;
  final double? fontSize;

  const AppIslamicText({
    super.key,
    required this.text,
    required this.type,
    this.color,
    this.textAlign,
    this.fontSize,
  });

  /// آية قرآنية
  factory AppIslamicText.quran({
    required String text,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
  }) {
    return AppIslamicText(
      text: text,
      type: AppIslamicTextType.quran,
      color: color,
      textAlign: textAlign ?? TextAlign.center,
      fontSize: fontSize,
    );
  }

  /// حديث شريف
  factory AppIslamicText.hadith({
    required String text,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
  }) {
    return AppIslamicText(
      text: text,
      type: AppIslamicTextType.hadith,
      color: color,
      textAlign: textAlign ?? TextAlign.center,
      fontSize: fontSize,
    );
  }

  /// دعاء
  factory AppIslamicText.dua({
    required String text,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
  }) {
    return AppIslamicText(
      text: text,
      type: AppIslamicTextType.dua,
      color: color,
      textAlign: textAlign ?? TextAlign.center,
      fontSize: fontSize,
    );
  }

  /// تسبيح
  factory AppIslamicText.tasbih({
    required String text,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
  }) {
    return AppIslamicText(
      text: text,
      type: AppIslamicTextType.tasbih,
      color: color,
      textAlign: textAlign ?? TextAlign.center,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    // استخدام النظام المبسط داخلياً
    return IslamicText(
      text: text,
      type: _convertType(),
      color: color,
      textAlign: textAlign,
      fontSize: fontSize,
    );
  }

  IslamicTextType _convertType() {
    return switch (type) {
      AppIslamicTextType.quran => IslamicTextType.quran,
      AppIslamicTextType.hadith => IslamicTextType.hadith,
      AppIslamicTextType.dua => IslamicTextType.dua,
      AppIslamicTextType.tasbih => IslamicTextType.tasbih,
    };
  }
}

/// نص منسق مع أيقونة
class AppRichText extends StatelessWidget {
  final String text;
  final IconData? icon;
  final AppTextStyle style;
  final Color? color;
  final Color? iconColor;
  final TextAlign? textAlign;

  const AppRichText({
    super.key,
    required this.text,
    this.icon,
    this.style = AppTextStyle.body,
    this.color,
    this.iconColor,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: _getIconSize(),
            color: iconColor ?? color,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: AppText(
            text,
            style: style,
            color: color,
            textAlign: textAlign,
          ),
        ),
      ],
    );
  }

  double _getIconSize() {
    return switch (style) {
      AppTextStyle.heading => 28.0,
      AppTextStyle.title => 24.0,
      AppTextStyle.subtitle => 20.0,
      AppTextStyle.body => 18.0,
      AppTextStyle.bodyLarge => 20.0,
      AppTextStyle.caption => 14.0,
      AppTextStyle.label => 16.0,
    };
  }
}

/// أنماط النصوص
enum AppTextStyle {
  heading,    // عنوان كبير
  title,      // عنوان
  subtitle,   // عنوان فرعي
  body,       // نص عادي
  bodyLarge,  // نص كبير
  caption,    // تسمية توضيحية
  label,      // تسمية
}

/// أنواع النصوص الإسلامية
enum AppIslamicTextType {
  quran,      // قرآن
  hadith,     // حديث
  dua,        // دعاء
  tasbih,     // تسبيح
}