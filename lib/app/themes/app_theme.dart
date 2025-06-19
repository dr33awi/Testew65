// lib/app/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

/// نظام الثيم الجديد للتطبيق الإسلامي
/// يحتوي على جميع الألوان والأنماط المستخدمة حالياً
class AppTheme {
  AppTheme._();

  // ==================== الألوان الأساسية ====================
  
  /// الألوان الأساسية
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primarySoft = Color(0xFF81C784);
  
  static const Color accent = Color(0xFF00796B);
  static const Color accentLight = Color(0xFF4DB6AC);
  static const Color accentDark = Color(0xFF004D40);
  
  static const Color tertiary = Color(0xFF5D4037);
  static const Color tertiaryLight = Color(0xFF8D6E63);
  static const Color tertiaryDark = Color(0xFF3E2723);

  /// ألوان الحالة
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF42A5F5);

  /// الخلفيات والأسطح
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);

  /// النصوص
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  /// الحدود والفواصل
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color darkDivider = Color(0xFF404040);

  // ==================== التدرجات اللونية ====================
  
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

  // ==================== تدرجات حسب الوقت ====================
  
  static LinearGradient getTimeBasedGradient({DateTime? dateTime}) {
    final time = dateTime ?? DateTime.now();
    final hour = time.hour;
    
    if (hour < 5) {
      return const LinearGradient(
        colors: [darkBackground, darkCard],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 8) {
      return const LinearGradient(
        colors: [primaryDark, primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 12) {
      return accentGradient;
    } else if (hour < 15) {
      return primaryGradient;
    } else if (hour < 17) {
      return const LinearGradient(
        colors: [primaryLight, primarySoft],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 20) {
      return tertiaryGradient;
    } else {
      return const LinearGradient(
        colors: [primaryDark, primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  // ==================== ألوان الصلوات ====================
  
  static Color getPrayerColor(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        return const Color(0xFF5C6BC0);
      case 'الظهر':
      case 'dhuhr':
        return const Color(0xFFFFB74D);
      case 'العصر':
      case 'asr':
        return const Color(0xFFFF8A65);
      case 'المغرب':
      case 'maghrib':
        return const Color(0xFFAB47BC);
      case 'العشاء':
      case 'isha':
        return const Color(0xFF5E35B1);
      default:
        return primary;
    }
  }

  static LinearGradient prayerGradient(String prayerName) {
    final color = getPrayerColor(prayerName);
    return LinearGradient(
      colors: [color, color.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static IconData getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        return Icons.wb_twilight;
      case 'الظهر':
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'العصر':
      case 'asr':
        return Icons.wb_cloudy;
      case 'المغرب':
      case 'maghrib':
        return Icons.wb_twilight;
      case 'العشاء':
      case 'isha':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }

  // ==================== القياسات والمساحات ====================
  
  /// المساحات
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;
  static const double space12 = 48.0;

  /// أحجام الأيقونات
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double icon2xl = 48.0;

  /// الزوايا المنحنية
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radius2xl = 20.0;
  static const double radius3xl = 24.0;
  static const double radiusFull = 9999.0;

  /// الحدود
  static const double borderLight = 1.0;
  static const double borderMedium = 2.0;
  static const double borderHeavy = 3.0;

  /// الارتفاعات (المستويات)
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

  /// أوزان الخطوط
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  /// العائلات
  static const String fontFamily = 'Cairo';
  static const String fontFamilyArabic = 'Amiri';
  static const String fontFamilyQuran = 'Uthmanic';

  // ==================== مدة الحركات ====================
  
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationExtraSlow = Duration(milliseconds: 800);

  /// منحنيات الحركة
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSmooth = Curves.easeInOutCubic;
  static const Curve curveBounce = Curves.elasticOut;

  // ==================== الظلال ====================
  
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowXl => [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  // ==================== أنماط البطاقات ====================
  
  /// بطاقة أساسية
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: lightCard,
    borderRadius: BorderRadius.circular(radius2xl),
    border: Border.all(
      color: lightDivider.withOpacity(0.2),
      width: borderLight,
    ),
    boxShadow: shadowMd,
  );

  /// بطاقة مع تدرج لوني
  static BoxDecoration cardGradientDecoration(List<Color> colors) => BoxDecoration(
    borderRadius: BorderRadius.circular(radius2xl),
    gradient: LinearGradient(
      colors: colors.map((c) => c.withOpacity(0.9)).toList(),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
      width: borderLight,
    ),
    boxShadow: [
      BoxShadow(
        color: colors[0].withOpacity(0.3),
        blurRadius: 25,
        offset: const Offset(0, 12),
        spreadRadius: 2,
      ),
    ],
  );

  /// بطاقة مع تأثير الزجاج المضبب
  static BoxDecoration get glassCardDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(radius2xl),
    border: Border.all(
      color: Colors.white.withOpacity(0.2),
      width: borderLight,
    ),
  );

  /// بطاقة مرفوعة (elevated)
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: lightCard,
    borderRadius: BorderRadius.circular(radiusXl),
    boxShadow: shadowXl,
  );

  // ==================== أنماط الأزرار ====================
  
  /// زر مضغوط بتأثير
  static BoxDecoration pressedButtonDecoration(Color color) => BoxDecoration(
    gradient: LinearGradient(
      colors: [color, color.withOpacity(0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(radiusLg),
    boxShadow: [
      BoxShadow(
        color: color.withOpacity(0.3),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );

  /// زر دائري كبير (للمسبحة)
  static BoxDecoration circularButtonDecoration(List<Color> colors) => BoxDecoration(
    gradient: LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: colors[0].withOpacity(0.4),
        blurRadius: 30,
        spreadRadius: 5,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );

  // ==================== أنماط النصوص ====================
  
  static TextStyle get displayLarge => const TextStyle(
    fontSize: textSize5xl,
    fontWeight: bold,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static TextStyle get displaySmall => const TextStyle(
    fontSize: textSize4xl,
    fontWeight: bold,
    height: 1.2,
  );

  static TextStyle get headlineLarge => const TextStyle(
    fontSize: textSize3xl,
    fontWeight: bold,
    height: 1.2,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontSize: textSize2xl,
    fontWeight: semiBold,
    height: 1.3,
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontSize: textSizeXl,
    fontWeight: semiBold,
    height: 1.3,
  );

  static TextStyle get titleLarge => const TextStyle(
    fontSize: textSizeLg,
    fontWeight: semiBold,
    height: 1.3,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontSize: textSizeMd,
    fontWeight: medium,
    height: 1.4,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontSize: textSizeSm,
    fontWeight: medium,
    height: 1.4,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: textSizeLg,
    fontWeight: regular,
    height: 1.5,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontSize: textSizeMd,
    fontWeight: regular,
    height: 1.5,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: textSizeSm,
    fontWeight: regular,
    height: 1.4,
  );

  static TextStyle get labelLarge => const TextStyle(
    fontSize: textSizeMd,
    fontWeight: medium,
    height: 1.3,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontSize: textSizeSm,
    fontWeight: medium,
    height: 1.3,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontSize: textSizeXs,
    fontWeight: medium,
    height: 1.2,
  );

  // ==================== أنماط النصوص العربية ====================
  
  static TextStyle get arabicDisplayLarge => displayLarge.copyWith(
    fontFamily: fontFamilyArabic,
    height: 1.8,
  );

  static TextStyle get quranText => const TextStyle(
    fontSize: textSizeXl,
    fontWeight: regular,
    height: 2.0,
    fontFamily: fontFamilyQuran,
  );

  static TextStyle get hadithText => const TextStyle(
    fontSize: textSizeLg,
    fontWeight: regular,
    height: 1.8,
    fontFamily: fontFamilyArabic,
  );

  static TextStyle get duaText => const TextStyle(
    fontSize: textSizeLg,
    fontWeight: medium,
    height: 1.8,
    fontFamily: fontFamilyArabic,
  );

  // ==================== تأثيرات بصرية ====================
  
  /// تأثير الزجاج المضبب
  static Widget glassEffect({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius2xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: child,
      ),
    );
  }

  /// حاوية بتأثير التوهج
  static Widget glowContainer({
    required Widget child,
    required Color glowColor,
    double glowRadius = 20,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius2xl),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.5),
            blurRadius: glowRadius,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }

  // ==================== المساعدات ====================
  
  /// تحويل الارتفاع إلى SizedBox
  static Widget heightBox(double height) => SizedBox(height: height);
  static Widget widthBox(double width) => SizedBox(width: width);

  /// مساعدات للمساحات الشائعة
  static Widget get space1H => heightBox(space1);
  static Widget get space2H => heightBox(space2);
  static Widget get space3H => heightBox(space3);
  static Widget get space4H => heightBox(space4);
  static Widget get space5H => heightBox(space5);
  static Widget get space6H => heightBox(space6);
  static Widget get space8H => heightBox(space8);
  static Widget get space12H => heightBox(space12);

  static Widget get space1W => widthBox(space1);
  static Widget get space2W => widthBox(space2);
  static Widget get space3W => widthBox(space3);
  static Widget get space4W => widthBox(space4);
  static Widget get space5W => widthBox(space5);
  static Widget get space6W => widthBox(space6);
  static Widget get space8W => widthBox(space8);
  static Widget get space12W => widthBox(space12);

  /// SliverBox للمساحات
  static Widget get space1Sliver => SliverToBoxAdapter(child: space1H);
  static Widget get space2Sliver => SliverToBoxAdapter(child: space2H);
  static Widget get space3Sliver => SliverToBoxAdapter(child: space3H);
  static Widget get space4Sliver => SliverToBoxAdapter(child: space4H);
  static Widget get space6Sliver => SliverToBoxAdapter(child: space6H);
  static Widget get space8Sliver => SliverToBoxAdapter(child: space8H);

  // ==================== Extension Methods ====================
}

/// Extension لتسهيل الوصول للألوان من خلال BuildContext
extension AppThemeExtension on BuildContext {
  // الألوان
  Color get primaryColor => AppTheme.primary;
  Color get accentColor => AppTheme.accent;
  Color get backgroundColor => _isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground;
  Color get surfaceColor => _isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface;
  Color get cardColor => _isDarkMode ? AppTheme.darkCard : AppTheme.lightCard;
  Color get textPrimaryColor => _isDarkMode ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
  Color get textSecondaryColor => _isDarkMode ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary;
  Color get dividerColor => _isDarkMode ? AppTheme.darkDivider : AppTheme.lightDivider;
  Color get errorColor => AppTheme.error;
  Color get successColor => AppTheme.success;
  Color get warningColor => AppTheme.warning;
  Color get infoColor => AppTheme.info;

  bool get _isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // أنماط النصوص
  TextStyle? get displayLarge => AppTheme.displayLarge.copyWith(color: textPrimaryColor);
  TextStyle? get displaySmall => AppTheme.displaySmall.copyWith(color: textPrimaryColor);
  TextStyle? get headlineLarge => AppTheme.headlineLarge.copyWith(color: textPrimaryColor);
  TextStyle? get headlineMedium => AppTheme.headlineMedium.copyWith(color: textPrimaryColor);
  TextStyle? get headlineSmall => AppTheme.headlineSmall.copyWith(color: textPrimaryColor);
  TextStyle? get titleLarge => AppTheme.titleLarge.copyWith(color: textPrimaryColor);
  TextStyle? get titleMedium => AppTheme.titleMedium.copyWith(color: textPrimaryColor);
  TextStyle? get titleSmall => AppTheme.titleSmall.copyWith(color: textPrimaryColor);
  TextStyle? get bodyLarge => AppTheme.bodyLarge.copyWith(color: textPrimaryColor);
  TextStyle? get bodyMedium => AppTheme.bodyMedium.copyWith(color: textPrimaryColor);
  TextStyle? get bodySmall => AppTheme.bodySmall.copyWith(color: textPrimaryColor);
  TextStyle? get labelLarge => AppTheme.labelLarge.copyWith(color: textPrimaryColor);
  TextStyle? get labelMedium => AppTheme.labelMedium.copyWith(color: textPrimaryColor);
  TextStyle? get labelSmall => AppTheme.labelSmall.copyWith(color: textPrimaryColor);

  // النصوص العربية
  TextStyle? get arabicDisplayLarge => AppTheme.arabicDisplayLarge.copyWith(color: textPrimaryColor);
  TextStyle? get quranText => AppTheme.quranText.copyWith(color: textPrimaryColor);
  TextStyle? get hadithText => AppTheme.hadithText.copyWith(color: textPrimaryColor);
  TextStyle? get duaText => AppTheme.duaText.copyWith(color: textPrimaryColor);

  // التدرجات اللونية
  LinearGradient get primaryGradient => AppTheme.primaryGradient;
  LinearGradient get accentGradient => AppTheme.accentGradient;
  LinearGradient get timeBasedGradient => AppTheme.getTimeBasedGradient();

  // أنماط البطاقات
  BoxDecoration get cardDecoration => AppTheme.cardDecoration.copyWith(
    color: cardColor,
    border: Border.all(
      color: dividerColor.withOpacity(0.2),
      width: AppTheme.borderLight,
    ),
  );

  BoxDecoration cardGradientDecoration(List<Color> colors) => 
      AppTheme.cardGradientDecoration(colors);

  BoxDecoration get glassCardDecoration => AppTheme.glassCardDecoration;
  BoxDecoration get elevatedCardDecoration => AppTheme.elevatedCardDecoration.copyWith(
    color: cardColor,
  );

  // الظلال
  List<BoxShadow> get shadowSm => AppTheme.shadowSm;
  List<BoxShadow> get shadowMd => AppTheme.shadowMd;
  List<BoxShadow> get shadowLg => AppTheme.shadowLg;
  List<BoxShadow> get shadowXl => AppTheme.shadowXl;

  // المساعدات
  Widget glassEffect({required Widget child}) => AppTheme.glassEffect(child: child);
  Widget glowContainer({required Widget child, required Color glowColor, double glowRadius = 20}) => 
      AppTheme.glowContainer(child: child, glowColor: glowColor, glowRadius: glowRadius);
}

/// Extension للألوان
extension ColorExtension on Color {
  /// تفتيح اللون
  Color lighten(double amount) {
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// تغميق اللون
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// إضافة شفافية
  Color withOpacity(double opacity) {
    return withAlpha((255.0 * opacity).round());
  }
}

/// Extension للنصوص
extension TextStyleExtension on TextStyle {
  TextStyle get light => copyWith(fontWeight: AppTheme.light);
  TextStyle get regular => copyWith(fontWeight: AppTheme.regular);
  TextStyle get medium => copyWith(fontWeight: AppTheme.medium);
  TextStyle get semiBold => copyWith(fontWeight: AppTheme.semiBold);
  TextStyle get bold => copyWith(fontWeight: AppTheme.bold);
}

/// Extension للمساعدات العامة  
extension NumExtension on num {
  Widget get h => SizedBox(height: toDouble());
  Widget get w => SizedBox(width: toDouble());
  Widget get sliverBox => SliverToBoxAdapter(child: SizedBox(height: toDouble()));
}