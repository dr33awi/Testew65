// lib/app/themes/theme_constants.dart
import 'package:flutter/material.dart';

/// ثوابت الثيم الموحد للتطبيق
/// جميع القيم الثابتة في مكان واحد
class ThemeConstants {
  ThemeConstants._();

  // ==================== الألوان الأساسية ====================
  
  /// اللون الأساسي - أخضر زيتي هادئ
  static const Color primary = Color(0xFF2E7D57);
  static const Color primaryLight = Color(0xFF4CAF79);
  static const Color primaryDark = Color(0xFF1E5A3E);
  static const Color primarySoft = Color(0xFF7CB89B);
  
  /// اللون الثانوي - ذهبي أنيق
  static const Color secondary = Color(0xFFD4AF37);
  static const Color secondaryLight = Color(0xFFE6C76A);
  static const Color secondaryDark = Color(0xFFB8941F);
  
  /// اللون الثالث - بني دافئ
  static const Color tertiary = Color(0xFF8B6B47);
  static const Color tertiaryLight = Color(0xFFA68B6B);
  static const Color tertiaryDark = Color(0xFF6B4B2F);
  
  /// اللون الرابع - أزرق هادئ
  static const Color accent = Color(0xFF5DADE2);
  static const Color accentLight = Color(0xFF85C1E9);
  static const Color accentDark = Color(0xFF3498DB);
  
  // ==================== ألوان الحالة ====================
  
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);
  
  // ==================== الوضع الفاتح ====================
  
  static const Color lightBackground = Color(0xFFFAFAF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE8E8E8);
  
  static const Color lightText = Color(0xFF2C3E50);
  static const Color lightTextSecondary = Color(0xFF7F8C8D);
  static const Color lightTextHint = Color(0xFFBDC3C7);
  
  // ==================== الوضع الداكن ====================
  
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkCard = Color(0xFF383838);
  static const Color darkBorder = Color(0xFF4A4A4A);
  
  static const Color darkText = Color(0xFFECF0F1);
  static const Color darkTextSecondary = Color(0xFFBDC3C7);
  static const Color darkTextHint = Color(0xFF7F8C8D);
  
  // ==================== الأحجام والمسافات ====================
  
  /// المسافات
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space10 = 40.0;
  static const double space12 = 48.0;
  
  /// نصف المسافات (للتفاصيل الدقيقة)
  static const double spaceHalf = 2.0;
  static const double space1Half = 6.0;
  static const double space2Half = 10.0;
  static const double space3Half = 14.0;
  
  /// الزوايا المدورة
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 20.0;
  static const double radius3xl = 24.0;
  static const double radiusFull = 999.0;
  
  /// أحجام الأيقونات
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double icon2xl = 48.0;
  
  /// أحجام الأزرار
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  
  // ==================== الخطوط ====================
  
  /// عائلات الخطوط
  static const String fontFamily = 'Cairo';
  static const String fontFamilyArabic = 'Amiri';
  static const String fontFamilyQuran = 'Uthmanic';
  
  /// أحجام الخطوط
  static const double fontSizeXs = 10.0;
  static const double fontSizeSm = 12.0;
  static const double fontSizeMd = 14.0;
  static const double fontSizeLg = 16.0;
  static const double fontSizeXl = 18.0;
  static const double fontSize2xl = 20.0;
  static const double fontSize3xl = 24.0;
  static const double fontSize4xl = 28.0;
  static const double fontSize5xl = 32.0;
  
  /// أوزان الخطوط
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  
  // ==================== الظلال ====================
  
  static final List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  
  static final List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];
  
  static final List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
  ];
  
  static final List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      offset: const Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
  ];
  
  // ==================== التدرجات اللونية ====================
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==================== المدد الزمنية ====================
  
  static const Duration durationQuick = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationVerySlow = Duration(milliseconds: 800);
  
  // ==================== منحنيات الحركة ====================
  
  static const Curve curveEaseIn = Curves.easeIn;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveEaseInOut = Curves.easeInOut;
  static const Curve curveBounce = Curves.bounceOut;
  static const Curve curveElastic = Curves.elasticOut;
  
  // ==================== أحجام الشاشة ====================
  
  static const double breakpointSm = 640;
  static const double breakpointMd = 768;
  static const double breakpointLg = 1024;
  static const double breakpointXl = 1280;
  
  // ==================== ثوابت خاصة بالتطبيق ====================
  
  /// ارتفاع AppBar
  static const double appBarHeight = 56.0;
  
  /// ارتفاع TabBar
  static const double tabBarHeight = 48.0;
  
  /// ارتفاع BottomNavigationBar
  static const double bottomNavHeight = 60.0;
  
  /// حد أقصى لعرض المحتوى
  static const double maxContentWidth = 1200.0;
  
  /// حد أدنى للمساحة الجانبية
  static const double minSidePadding = 16.0;
  
  // ==================== تشكيلات جاهزة ====================
  
  /// حشو الشاشة الافتراضي
  static const EdgeInsets screenPadding = EdgeInsets.all(space4);
  
  /// حشو البطاقة الافتراضي
  static const EdgeInsets cardPadding = EdgeInsets.all(space5);
  
  /// حشو العنصر الافتراضي
  static const EdgeInsets itemPadding = EdgeInsets.symmetric(
    horizontal: space4,
    vertical: space3,
  );
  
  /// حشو الزر الافتراضي
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: space6,
    vertical: space3,
  );
}

// ==================== Extensions للسهولة ====================

/// Extension للمساحات
extension SpacingExtension on double {
  Widget get h => SizedBox(height: this);
  Widget get w => SizedBox(width: this);
}

/// Extension للسياق
extension ThemeContextExtension on BuildContext {
  // الثيم
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  // الألوان السريعة
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  Color get surfaceColor => colorScheme.surface;
  Color get cardColor => theme.cardTheme.color ?? colorScheme.surface;
  Color get textColor => colorScheme.onSurface;
  Color get textSecondaryColor => isDarkMode 
      ? ThemeConstants.darkTextSecondary 
      : ThemeConstants.lightTextSecondary;
  Color get dividerColor => theme.dividerColor;
  Color get errorColor => colorScheme.error;
  
  // النصوص السريعة
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
  
  // مساعدات الرسائل
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.success,
      ),
    );
  }
  
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.error,
      ),
    );
  }
  
  void showWarningSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.warning,
      ),
    );
  }
  
  void showInfoSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: ThemeConstants.info,
      ),
    );
  }
  
  void showWarning(String message) => showWarningSnackBar(message);
}

/// Extension للنصوص
extension TextStyleExtension on TextStyle? {
  TextStyle? get light => this?.copyWith(fontWeight: ThemeConstants.light);
  TextStyle? get regular => this?.copyWith(fontWeight: ThemeConstants.regular);
  TextStyle? get medium => this?.copyWith(fontWeight: ThemeConstants.medium);
  TextStyle? get semiBold => this?.copyWith(fontWeight: ThemeConstants.semiBold);
  TextStyle? get bold => this?.copyWith(fontWeight: ThemeConstants.bold);
  TextStyle? get extraBold => this?.copyWith(fontWeight: ThemeConstants.extraBold);
  
  TextStyle? withColor(Color color) => this?.copyWith(color: color);
  TextStyle? withSize(double size) => this?.copyWith(fontSize: size);
  TextStyle? withHeight(double height) => this?.copyWith(height: height);
}