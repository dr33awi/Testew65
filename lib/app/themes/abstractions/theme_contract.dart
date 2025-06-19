// lib/app/themes/abstractions/theme_contract.dart
// طبقة التجريد للحماية من التغييرات المستقبلية

import 'package:flutter/material.dart';

/// واجهة الثيم المجردة - لا تتغير مع الوقت
/// هذه الواجهة تحمي الشاشات من تغييرات التنفيذ الداخلي
abstract class AppThemeContract {
  
  // ==================== الألوان الأساسية ====================
  Color get primaryColor;
  Color get secondaryColor;
  Color get backgroundColor;
  Color get surfaceColor;
  Color get errorColor;
  Color get successColor;
  Color get warningColor;
  
  // ==================== ألوان النصوص ====================
  Color get textPrimary;
  Color get textSecondary;
  Color get textHint;
  
  // ==================== التدرجات ====================
  LinearGradient get primaryGradient;
  LinearGradient get timeBasedGradient;
  LinearGradient getPrayerGradient(String prayerName);
  
  // ==================== المساحات ====================
  double get spacingSmall;
  double get spacingMedium;
  double get spacingLarge;
  double get spacingExtraLarge;
  
  // ==================== الأحجام ====================
  double get iconSizeSmall;
  double get iconSizeMedium;
  double get iconSizeLarge;
  double get buttonHeight;
  double get inputHeight;
  
  // ==================== الزوايا ====================
  BorderRadius get borderRadiusSmall;
  BorderRadius get borderRadiusMedium;
  BorderRadius get borderRadiusLarge;
  BorderRadius get borderRadiusCard;
  
  // ==================== الظلال ====================
  List<BoxShadow> get shadowLight;
  List<BoxShadow> get shadowMedium;
  List<BoxShadow> get shadowHeavy;
  
  // ==================== أنماط النصوص ====================
  TextStyle get headlineStyle;
  TextStyle get titleStyle;
  TextStyle get bodyStyle;
  TextStyle get captionStyle;
  TextStyle get buttonStyle;
  TextStyle get quranStyle;
  TextStyle get hadithStyle;
  
  // ==================== المدد الزمنية ====================
  Duration get animationFast;
  Duration get animationNormal;
  Duration get animationSlow;
  
  // ==================== المنحنيات ====================
  Curve get animationCurve;
  Curve get springCurve;
}

/// تنفيذ الواجهة باستخدام النظام الحالي
class AppThemeImplementation implements AppThemeContract {
  final BuildContext _context;
  
  const AppThemeImplementation(this._context);
  
  // ==================== الألوان ====================
  @override
  Color get primaryColor => _context.primaryColor;
  
  @override
  Color get secondaryColor => _context.secondaryColor;
  
  @override
  Color get backgroundColor => _context.backgroundColor;
  
  @override
  Color get surfaceColor => _context.surfaceColor;
  
  @override
  Color get errorColor => _context.errorColor;
  
  @override
  Color get successColor => _context.successColor;
  
  @override
  Color get warningColor => _context.warningColor;
  
  @override
  Color get textPrimary => _context.textPrimaryColor;
  
  @override
  Color get textSecondary => _context.textSecondaryColor;
  
  @override
  Color get textHint => _context.textHintColor;
  
  // ==================== التدرجات ====================
  @override
  LinearGradient get primaryGradient => _context.primaryGradient;
  
  @override
  LinearGradient get timeBasedGradient => _context.timeBasedGradient;
  
  @override
  LinearGradient getPrayerGradient(String prayerName) => 
      _context.prayerGradient(prayerName);
  
  // ==================== المساحات ====================
  @override
  double get spacingSmall => _context.spaceSm;
  
  @override
  double get spacingMedium => _context.spaceMd;
  
  @override
  double get spacingLarge => _context.spaceLg;
  
  @override
  double get spacingExtraLarge => _context.spaceXl;
  
  // ==================== الأحجام ====================
  @override
  double get iconSizeSmall => _context.iconSm;
  
  @override
  double get iconSizeMedium => _context.iconMd;
  
  @override
  double get iconSizeLarge => _context.iconLg;
  
  @override
  double get buttonHeight => _context.buttonHeight;
  
  @override
  double get inputHeight => _context.inputHeight;
  
  // ==================== الزوايا ====================
  @override
  BorderRadius get borderRadiusSmall => _context.radiusSm;
  
  @override
  BorderRadius get borderRadiusMedium => _context.radiusMd;
  
  @override
  BorderRadius get borderRadiusLarge => _context.radiusLg;
  
  @override
  BorderRadius get borderRadiusCard => _context.cardBorderRadius;
  
  // ==================== الظلال ====================
  @override
  List<BoxShadow> get shadowLight => _context.shadowSm;
  
  @override
  List<BoxShadow> get shadowMedium => _context.shadowMd;
  
  @override
  List<BoxShadow> get shadowHeavy => _context.shadowLg;
  
  // ==================== أنماط النصوص ====================
  @override
  TextStyle get headlineStyle => _context.headlineLarge ?? const TextStyle();
  
  @override
  TextStyle get titleStyle => _context.titleLarge ?? const TextStyle();
  
  @override
  TextStyle get bodyStyle => _context.bodyMedium ?? const TextStyle();
  
  @override
  TextStyle get captionStyle => _context.bodySmall ?? const TextStyle();
  
  @override
  TextStyle get buttonStyle => _context.labelLarge ?? const TextStyle();
  
  @override
  TextStyle get quranStyle => _context.quranTextStyle;
  
  @override
  TextStyle get hadithStyle => _context.hadithTextStyle;
  
  // ==================== الحركات ====================
  @override
  Duration get animationFast => AppAnimations.fast;
  
  @override
  Duration get animationNormal => AppAnimations.normal;
  
  @override
  Duration get animationSlow => AppAnimations.slow;
  
  @override
  Curve get animationCurve => AppAnimations.gentle;
  
  @override
  Curve get springCurve => AppAnimations.spring;
}

/// Extension للوصول للثيم المجرد
extension ThemeContractExtension on BuildContext {
  AppThemeContract get appTheme => AppThemeImplementation(this);
}