// lib/app/themes/abstractions/semantic_theme.dart
// طبقة الدلالات - تربط المعنى بالشكل

import 'package:flutter/material.dart';
import 'theme_contract.dart';

/// نظام الثيم الدلالي - يركز على المعنى وليس الشكل
/// مثال: "لون الخطر" بدلاً من "أحمر"
class SemanticTheme {
  final AppThemeContract _theme;
  
  const SemanticTheme(this._theme);
  
  // ==================== الحالات الدلالية ====================
  
  /// ألوان الحالات
  Color get dangerColor => _theme.errorColor;
  Color get safetyColor => _theme.successColor;
  Color get cautionColor => _theme.warningColor;
  Color get neutralColor => _theme.textSecondary;
  Color get emphasizedColor => _theme.primaryColor;
  
  /// ألوان الأهمية
  Color get criticalColor => _theme.errorColor;
  Color get importantColor => _theme.warningColor;
  Color get normalColor => _theme.textPrimary;
  Color get subtleColor => _theme.textSecondary;
  
  /// ألوان التفاعل
  Color get interactiveColor => _theme.primaryColor;
  Color get activeColor => _theme.primaryColor;
  Color get inactiveColor => _theme.textHint;
  Color get disabledColor => _theme.textHint;
  
  // ==================== السياقات الإسلامية ====================
  
  /// ألوان الصلاة
  Color get prayerActiveColor => _theme.primaryColor;
  Color get prayerUpcomingColor => _theme.warningColor;
  Color get prayerCompletedColor => _theme.successColor;
  Color get prayerMissedColor => _theme.errorColor;
  
  /// ألوان المحتوى الديني
  Color get quranColor => _theme.primaryColor;
  Color get hadithColor => _theme.secondaryColor;
  Color get duaColor => _theme.primaryColor;
  Color get athkarColor => _theme.successColor;
  
  /// ألوان الإنجازات
  Color get achievementColor => _theme.successColor;
  Color get progressColor => _theme.warningColor;
  Color get goalColor => _theme.primaryColor;
  
  // ==================== المساحات الدلالية ====================
  
  /// مساحات التخطيط
  double get tinySpace => _theme.spacingSmall / 2;
  double get compactSpace => _theme.spacingSmall;
  double get comfortableSpace => _theme.spacingMedium;
  double get spaciousSpace => _theme.spacingLarge;
  double get generousSpace => _theme.spacingExtraLarge;
  
  /// مساحات المكونات
  double get buttonSpacing => _theme.spacingMedium;
  double get cardSpacing => _theme.spacingLarge;
  double get sectionSpacing => _theme.spacingExtraLarge;
  double get pageSpacing => _theme.spacingLarge;
  
  // ==================== الأحجام الدلالية ====================
  
  /// أحجام الأيقونات
  double get decorativeIconSize => _theme.iconSizeSmall;
  double get functionalIconSize => _theme.iconSizeMedium;
  double get prominentIconSize => _theme.iconSizeLarge;
  
  /// أحجام التفاعل
  double get minimumTouchSize => 44.0; // iOS/Android minimum
  double get comfortableTouchSize => _theme.buttonHeight;
  double get generousTouchSize => _theme.buttonHeight * 1.2;
  
  // ==================== التأثيرات الدلالية ====================
  
  /// ظلال حسب الأهمية
  List<BoxShadow> get subtleShadow => _theme.shadowLight;
  List<BoxShadow> get noticeableShadow => _theme.shadowMedium;
  List<BoxShadow> get prominentShadow => _theme.shadowHeavy;
  
  /// زوايا حسب النوع
  BorderRadius get gentleRadius => _theme.borderRadiusSmall;
  BorderRadius get friendlyRadius => _theme.borderRadiusMedium;
  BorderRadius get modernRadius => _theme.borderRadiusLarge;
  BorderRadius get cardRadius => _theme.borderRadiusCard;
  
  // ==================== أنماط النصوص الدلالية ====================
  
  /// أنماط حسب الأهمية
  TextStyle get heroTextStyle => _theme.headlineStyle;
  TextStyle get prominentTextStyle => _theme.titleStyle;
  TextStyle get readableTextStyle => _theme.bodyStyle;
  TextStyle get supportingTextStyle => _theme.captionStyle;
  TextStyle get actionTextStyle => _theme.buttonStyle;
  
  /// أنماط إسلامية
  TextStyle get sacredTextStyle => _theme.quranStyle;
  TextStyle get religiousTextStyle => _theme.hadithStyle;
  
  // ==================== حالات التفاعل ====================
  
  /// ألوان الاستجابة
  Color getResponseColor(ResponseType type) {
    return switch (type) {
      ResponseType.success => safetyColor,
      ResponseType.error => dangerColor,
      ResponseType.warning => cautionColor,
      ResponseType.info => emphasizedColor,
      ResponseType.neutral => neutralColor,
    };
  }
  
  /// ألوان حسب الحالة
  Color getStateColor(ComponentState state) {
    return switch (state) {
      ComponentState.active => activeColor,
      ComponentState.inactive => inactiveColor,
      ComponentState.disabled => disabledColor,
      ComponentState.loading => emphasizedColor,
      ComponentState.error => dangerColor,
    };
  }
  
  /// ألوان المحتوى الديني
  Color getReligiousContentColor(ReligiousContentType type) {
    return switch (type) {
      ReligiousContentType.quran => quranColor,
      ReligiousContentType.hadith => hadithColor,
      ReligiousContentType.dua => duaColor,
      ReligiousContentType.athkar => athkarColor,
    };
  }
  
  // ==================== Builders للتصميم ====================
  
  /// بناء تدرج حسب السياق
  LinearGradient buildContextGradient(ContentContext context) {
    return switch (context) {
      ContentContext.prayer => _theme.primaryGradient,
      ContentContext.quran => _theme.primaryGradient,
      ContentContext.athkar => _theme.primaryGradient,
      ContentContext.general => _theme.timeBasedGradient,
    };
  }
  
  /// بناء ظل حسب الأهمية
  List<BoxShadow> buildImportanceShadow(ImportanceLevel level) {
    return switch (level) {
      ImportanceLevel.low => subtleShadow,
      ImportanceLevel.medium => noticeableShadow,
      ImportanceLevel.high => prominentShadow,
      ImportanceLevel.critical => prominentShadow,
    };
  }
  
  /// بناء نمط نص حسب الغرض
  TextStyle buildPurposeTextStyle(TextPurpose purpose) {
    return switch (purpose) {
      TextPurpose.hero => heroTextStyle,
      TextPurpose.title => prominentTextStyle,
      TextPurpose.body => readableTextStyle,
      TextPurpose.caption => supportingTextStyle,
      TextPurpose.action => actionTextStyle,
      TextPurpose.sacred => sacredTextStyle,
      TextPurpose.religious => religiousTextStyle,
    };
  }
}

// ==================== Enums للدلالات ====================

enum ResponseType {
  success,
  error, 
  warning,
  info,
  neutral,
}

enum ComponentState {
  active,
  inactive,
  disabled,
  loading,
  error,
}

enum ReligiousContentType {
  quran,
  hadith,
  dua,
  athkar,
}

enum ContentContext {
  prayer,
  quran,
  athkar,
  general,
}

enum ImportanceLevel {
  low,
  medium,
  high,
  critical,
}

enum TextPurpose {
  hero,
  title,
  body,
  caption,
  action,
  sacred,
  religious,
}

/// Extension للوصول للثيم الدلالي
extension SemanticThemeExtension on BuildContext {
  SemanticTheme get semantic => SemanticTheme(appTheme);
}