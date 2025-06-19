// lib/app/themes/theme_constants.dart
import 'package:flutter/material.dart';

/// كلاس يحتوي على جميع الثوابت المستخدمة في التطبيق
/// هذا الملف يوحد جميع القيم الثابتة المستخرجة من الملفات الموجودة
class ThemeConstants {
  ThemeConstants._();

  // ===== الألوان الأساسية - الهوية البصرية الجديدة =====
  static const Color primary = Color(0xFF5D7052); // أخضر زيتي أنيق
  static const Color primaryLight = Color(0xFF7A8B6F); // أخضر زيتي فاتح
  static const Color primaryDark = Color(0xFF445A3B); // أخضر زيتي داكن
  static const Color primarySoft = Color(0xFF8FA584); // أخضر زيتي ناعم
  
  // ===== الألوان الثانوية =====
  static const Color accent = Color(0xFFB8860B); // ذهبي دافئ
  static const Color accentLight = Color(0xFFDAA520); // ذهبي فاتح
  static const Color accentDark = Color(0xFF996515); // ذهبي داكن
  
  // ===== اللون الثالث =====
  static const Color tertiary = Color(0xFF8B6F47); // بني دافئ
  static const Color tertiaryLight = Color(0xFFA68B5B); // بني فاتح
  static const Color tertiaryDark = Color(0xFF6B5637); // بني داكن

  // ===== الألوان الدلالية =====
  static const Color success = Color(0xFF5D7052); // نفس اللون الأساسي للتناسق
  static const Color successLight = Color(0xFF7A8B6F); // أخضر زيتي فاتح للنجاح
  static const Color error = Color(0xFFB85450); // أحمر مخملي ناعم
  static const Color errorLight = Color(0xFFC76B67); // أحمر فاتح للخطأ
  static const Color warning = Color(0xFFD4A574); // برتقالي دافئ
  static const Color warningLight = Color(0xFFE8C899); // برتقالي فاتح للتحذير
  static const Color info = Color(0xFF6B8E9F); // أزرق رمادي
  static const Color infoLight = Color(0xFF8FA9B8); // أزرق رمادي فاتح للمعلومات

  // ===== ألوان الوضع الفاتح =====
  static const Color lightBackground = Color(0xFFFAFAF8); // خلفية دافئة
  static const Color lightSurface = Color(0xFFF5F5F0); // سطح دافئ
  static const Color lightCard = Color(0xFFFFFFFF); // بطاقات بيضاء
  static const Color lightDivider = Color(0xFFE0DDD4); // فواصل دافئة
  static const Color lightTextPrimary = Color(0xFF2D2D2D); // نص أساسي
  static const Color lightTextSecondary = Color(0xFF5F5F5F); // نص ثانوي
  static const Color lightTextHint = Color(0xFF8F8F8F); // نص تلميحي
  
  // ===== ألوان الوضع الداكن =====
  static const Color darkBackground = Color(0xFF1A1F1A); // خلفية داكنة دافئة
  static const Color darkSurface = Color(0xFF242B24); // سطح داكن
  static const Color darkCard = Color(0xFF2D352D); // بطاقات داكنة
  static const Color darkDivider = Color(0xFF3A453A); // فواصل داكنة
  static const Color darkTextPrimary = Color(0xFFF5F5F0); // نص فاتح
  static const Color darkTextSecondary = Color(0xFFBDBDB0); // نص ثانوي
  static const Color darkTextHint = Color(0xFF8A8A80); // نص تلميحي

  // ==================== التدرجات اللونية الجديدة ====================
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tertiaryGradient = LinearGradient(
    colors: [tertiary, tertiaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرجات خاصة بالميزات
  static const LinearGradient athkarGradient = LinearGradient(
    colors: [primarySoft, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient prayerGradient = LinearGradient(
    colors: [prayerActive, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient qiblaGradient = LinearGradient(
    colors: [qiblaAccent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tasbihGradient = LinearGradient(
    colors: [tasbihAccent, tertiaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // تدرجات دافئة للخلفيات
  static const LinearGradient warmBackgroundGradient = LinearGradient(
    colors: [lightBackground, lightSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient warmCardGradient = LinearGradient(
    colors: [lightCard, athkarBackground],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== المساحات والحشو ====================
  
  /// المساحات الأساسية (مستخرجة من الاستخدام الفعلي)
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space12 = 48.0;

  // ==================== أحجام الأيقونات ====================
  
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double icon2xl = 48.0;

  // ==================== الزوايا المنحنية ====================
  
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 20.0;
  static const double radius3xl = 24.0;
  static const double radiusFull = 9999.0;

  // ==================== الحدود ====================
  
  static const double borderLight = 1.0;
  static const double borderMedium = 2.0;
  static const double borderHeavy = 3.0;

  // ==================== الارتفاعات (الظلال) ====================
  
  static const double elevation1 = 2.0;
  static const double elevation2 = 4.0;
  static const double elevation3 = 8.0;
  static const double elevation4 = 12.0;
  static const double elevation5 = 16.0;

  // ==================== أحجام الخطوط ====================
  
  static const double textSizeXs = 10.0;
  static const double textSizeSm = 12.0;
  static const double textSizeMd = 14.0;
  static const double textSizeLg = 16.0;
  static const double textSizeXl = 18.0;
  static const double textSize2xl = 20.0;
  static const double textSize3xl = 24.0;
  static const double textSize4xl = 32.0;
  static const double textSize5xl = 48.0;

  // ==================== أوزان الخطوط ====================
  
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ==================== عائلات الخطوط ====================
  
  static const String fontFamilyArabic = 'Cairo';
  static const String fontFamilyQuran = 'Amiri';
  static const String fontFamily = fontFamilyArabic;

  // ==================== أوزان الخطوط ====================
  
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ==================== ألوان خاصة بالميزات ====================
  
  static const Color athkarBackground = Color(0xFFF0F4EC); // خلفية الأذكار
  static const Color prayerActive = Color(0xFF5D7052); // الصلاة النشطة
  static const Color qiblaAccent = Color(0xFFB8860B); // لون القبلة
  static const Color tasbihAccent = Color(0xFF8B6F47); // لون التسبيح

  // ==================== ثوابت خاصة بالتطبيق ====================
  
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationExtraSlow = Duration(milliseconds: 800);

  // ==================== منحنيات الحركة ====================
  
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSmooth = Curves.easeInOutCubic;
  static const Curve curveBounce = Curves.elasticOut;

  // ==================== ثوابت خاصة بالتطبيق ====================

  /// أحجام مخصصة للعناصر
  static const double appBarHeight = 60.0;
  static const double bottomNavHeight = 70.0;
  static const double cardMinHeight = 80.0;
  static const double buttonHeight = 48.0;

  /// مساحات مخصصة للتخطيط
  static const double screenPadding = space4;
  static const double sectionSpacing = space6;
  static const double itemSpacing = space3;
  static const double defaultCardPadding = space5;
  static const double defaultMargin = space4;
  static const double defaultBorderRadius = radius2xl;
  static const double defaultElevation = elevation2;

  /// أحجام أيقونات مخصصة
  static const double prayerIconSize = iconLg;
  static const double categoryIconSize = iconLg;
  static const double appBarIconSize = iconMd;
  static const double buttonIconSize = iconSm;

  // ==================== ألوان إضافية ====================
  
  static const Color backgroundOverlay = Color(0x80000000);
  static const Color cardOverlay = Color(0x10000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ==================== المساعدات للمساحات ====================
  
  /// Extensions للمساحات مع أدوات سهلة
  static Widget get space1 => SizedBox(height: space1);
  static Widget get space2 => SizedBox(height: space2);
  static Widget get space3 => SizedBox(height: space3);
  static Widget get space4 => SizedBox(height: space4);
  static Widget get space5 => SizedBox(height: space5);
  static Widget get space6 => SizedBox(height: space6);
  static Widget get space8 => SizedBox(height: space8);
  static Widget get space12 => SizedBox(height: space12);
}

/// Extension للمساحات مع .h و .w
extension ThemeSpacingExtension on double {
  Widget get h => SizedBox(height: this);
  Widget get w => SizedBox(width: this);
  Widget get sliverBox => SliverToBoxAdapter(child: SizedBox(height: this));
}

/// Extension لتسهيل استخدام المساحات
extension ThemeSpacing on num {
  Widget get h => SizedBox(height: toDouble());
  Widget get w => SizedBox(width: toDouble());
  Widget get sliverBox => SliverToBoxAdapter(child: SizedBox(height: toDouble()));
}