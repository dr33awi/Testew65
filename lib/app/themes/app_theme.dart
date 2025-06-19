// lib/app/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

/// نظام الثيم الجديد للتطبيق الإسلامي
/// يحتوي على جميع الألوان والأنماط المستخدمة حالياً
class AppTheme {
  AppTheme._();

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

  /// ألوان الحالة
  static const Color success = Color(0xFF5D7052); // نفس اللون الأساسي للتناسق
  static const Color successLight = Color(0xFF7A8B6F); // أخضر زيتي فاتح للنجاح
  static const Color warning = Color(0xFFD4A574); // برتقالي دافئ
  static const Color warningLight = Color(0xFFE8C899); // برتقالي فاتح للتحذير
  static const Color error = Color(0xFFB85450); // أحمر مخملي ناعم
  static const Color errorLight = Color(0xFFC76B67); // أحمر فاتح للخطأ
  static const Color info = Color(0xFF6B8E9F); // أزرق رمادي
  static const Color infoLight = Color(0xFF8FA9B8); // أزرق رمادي فاتح للمعلومات

  /// الخلفيات والأسطح
  static const Color lightBackground = Color(0xFFFAFAF8); // خلفية دافئة
  static const Color lightSurface = Color(0xFFF5F5F0); // سطح دافئ
  static const Color lightCard = Color(0xFFFFFFFF); // بطاقات بيضاء
  
  static const Color darkBackground = Color(0xFF1A1F1A); // خلفية داكنة دافئة
  static const Color darkSurface = Color(0xFF242B24); // سطح داكن
  static const Color darkCard = Color(0xFF2D352D); // بطاقات داكنة

  /// النصوص
  static const Color lightTextPrimary = Color(0xFF2D2D2D); // نص أساسي
  static const Color lightTextSecondary = Color(0xFF5F5F5F); // نص ثانوي
  static const Color darkTextPrimary = Color(0xFFF5F5F0); // نص فاتح
  static const Color darkTextSecondary = Color(0xFFBDBDB0); // نص ثانوي

  /// الحدود والفواصل
  static const Color lightDivider = Color(0xFFE0DDD4); // فواصل دافئة
  static const Color darkDivider = Color(0xFF3A453A); // فواصل داكنة

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

  // ==================== ألوان الصلوات المحدثة ====================
  
  static Color getPrayerColor(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        return const Color(0xFF6B8E9F); // أزرق رمادي هادئ للفجر
      case 'الظهر':
      case 'dhuhr':
        return const Color(0xFFB8860B); // ذهبي دافئ للظهر
      case 'العصر':
      case 'asr':
        return const Color(0xFFD4A574); // برتقالي دافئ للعصر
      case 'المغرب':
      case 'maghrib':
        return const Color(0xFF8B6F47); // بني دافئ للمغرب
      case 'العشاء':
      case 'isha':
        return const Color(0xFF5D7052); // أخضر زيتي للعشاء
      default:
        return primary;
    }
  }

  static LinearGradient prayerGradient(String prayerName) {
    final color = getPrayerColor(prayerName);
    return LinearGradient(
      colors: [color, color.withValues(alpha: 0.8)],
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
  
  /// المساحات (مستخرجة من الاستخدام الفعلي)
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

  /// الزوايا المنحنية (محسنة من الاستخدام)
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
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowXl => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 15,
      offset: const Offset(0, 8),
    ),
  ];

  // ==================== أنماط البطاقات ====================
  
  /// بطاقة أساسية (مستخرجة من التطبيق)
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: lightCard,
    borderRadius: BorderRadius.circular(radius2xl),
    border: Border.all(
      color: lightDivider.withValues(alpha: 0.2),
      width: borderLight,
    ),
    boxShadow: shadowMd,
  );

  /// بطاقة مع تدرج لوني (كما مستخدم في التطبيق)
  static BoxDecoration cardGradientDecoration(List<Color> colors) => BoxDecoration(
    borderRadius: BorderRadius.circular(radius2xl),
    gradient: LinearGradient(
      colors: colors.map((c) => c.withValues(alpha: 0.9)).toList(),
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.2),
      width: borderLight,
    ),
    boxShadow: [
      BoxShadow(
        color: colors[0].withValues(alpha: 0.3),
        blurRadius: 25,
        offset: const Offset(0, 12),
        spreadRadius: 2,
      ),
    ],
  );

  /// بطاقة مع تأثير الزجاج المضبب (Glass Effect)
  static BoxDecoration get glassCardDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(radius2xl),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.2),
      width: borderLight,
    ),
  );

  /// بطاقة مرفوعة (elevated)
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: lightCard,
    borderRadius: BorderRadius.circular(radiusXl),
    boxShadow: shadowXl,
  );

  // ==================== الثيمات الجاهزة ====================
  
  /// ثيم فاتح
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // الألوان الأساسية
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: accent,
        tertiary: tertiary,
        surface: lightSurface,
        surfaceContainerHighest: lightCard,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onError: Colors.white,
        outline: lightDivider,
        shadow: Colors.black.withValues(alpha: 0.1),
      ),

      // الخطوط
      fontFamily: fontFamily,
      textTheme: _buildTextTheme(Brightness.light),
      
      // شريط التطبيق
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: textSizeLg,
          fontWeight: bold,
          color: lightTextPrimary,
        ),
        iconTheme: IconThemeData(
          color: lightTextPrimary,
        ),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius2xl),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.1),
      ),

      // الأزرار المرفوعة
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: elevation2,
          padding: const EdgeInsets.symmetric(
            horizontal: space4,
            vertical: space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          textStyle: const TextStyle(
            fontSize: textSizeMd,
            fontWeight: semiBold,
          ),
          shadowColor: primary.withValues(alpha: 0.3),
        ),
      ),

      // الحوارات
      dialogTheme: DialogThemeData(
        backgroundColor: lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius2xl),
        ),
        elevation: elevation4,
        titleTextStyle: const TextStyle(
          fontSize: textSizeXl,
          fontWeight: bold,
          color: lightTextPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: textSizeMd,
          color: lightTextSecondary,
        ),
        insetPadding: const EdgeInsets.all(space6),
      ),

      // شرائط الإشعارات
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightTextPrimary,
        contentTextStyle: const TextStyle(
          fontSize: textSizeMd,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: elevation3,
        actionTextColor: primary,
        insetPadding: const EdgeInsets.all(space4),
      ),

      // الفواصل
      dividerTheme: const DividerThemeData(
        color: lightDivider,
        thickness: 1,
        space: 1,
        indent: 0,
        endIndent: 0,
      ),

      // الأيقونات
      iconTheme: const IconThemeData(
        color: lightTextSecondary,
        size: iconMd,
      ),
    );
  }

  /// ثيم داكن
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primaryLight,
        secondary: accentLight,
        tertiary: tertiaryLight,
        surface: darkSurface,
        surfaceContainerHighest: darkCard,
        error: errorLight,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: darkTextPrimary,
        onError: Colors.black,
        outline: darkDivider,
        shadow: Colors.black.withValues(alpha: 0.3),
      ),

      textTheme: _buildTextTheme(Brightness.dark),

      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontSize: textSizeLg,
          fontWeight: bold,
          color: darkTextPrimary,
        ),
        iconTheme: IconThemeData(
          color: darkTextPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        color: darkCard,
        elevation: elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius2xl),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      dialogTheme: const DialogThemeData(
        backgroundColor: darkCard,
        titleTextStyle: TextStyle(
          fontSize: textSizeXl,
          fontWeight: bold,
          color: darkTextPrimary,
        ),
        contentTextStyle: TextStyle(
          fontSize: textSizeMd,
          color: darkTextSecondary,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: darkTextSecondary,
        size: iconMd,
      ),
    );
  }

  /// بناء أنماط النصوص
  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseColor = brightness == Brightness.light 
        ? lightTextPrimary 
        : darkTextPrimary;
    
    final secondaryColor = brightness == Brightness.light 
        ? lightTextSecondary 
        : darkTextSecondary;

    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: textSize5xl,
        fontWeight: bold,
        height: 1.1,
        letterSpacing: -0.5,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontSize: textSize4xl,
        fontWeight: bold,
        height: 1.2,
        color: baseColor,
      ),
      displaySmall: TextStyle(
        fontSize: textSize3xl,
        fontWeight: bold,
        height: 1.2,
        color: baseColor,
      ),
      
      // Headline styles
      headlineLarge: TextStyle(
        fontSize: textSize3xl,
        fontWeight: bold,
        height: 1.2,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontSize: textSize2xl,
        fontWeight: semiBold,
        height: 1.3,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontSize: textSizeXl,
        fontWeight: semiBold,
        height: 1.3,
        color: baseColor,
      ),
      
      // Title styles
      titleLarge: TextStyle(
        fontSize: textSizeLg,
        fontWeight: semiBold,
        height: 1.3,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: textSizeMd,
        fontWeight: medium,
        height: 1.4,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontSize: textSizeSm,
        fontWeight: medium,
        height: 1.4,
        color: baseColor,
      ),
      
      // Body styles
      bodyLarge: TextStyle(
        fontSize: textSizeLg,
        fontWeight: regular,
        height: 1.5,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: textSizeMd,
        fontWeight: regular,
        height: 1.5,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontSize: textSizeSm,
        fontWeight: regular,
        height: 1.4,
        color: secondaryColor,
      ),
      
      // Label styles
      labelLarge: TextStyle(
        fontSize: textSizeMd,
        fontWeight: medium,
        height: 1.3,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: textSizeSm,
        fontWeight: medium,
        height: 1.3,
        color: secondaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: textSizeXs,
        fontWeight: medium,
        height: 1.2,
        color: secondaryColor,
      ),
    );
  }

  // ==================== أنماط النصوص العربية ====================
  
  static TextStyle get arabicDisplayLarge => const TextStyle(
    fontSize: textSize5xl,
    fontWeight: bold,
    height: 1.8,
    fontFamily: fontFamilyArabic,
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
            color: glowColor.withValues(alpha: 0.5),
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

  // ==================== ثوابت جديدة مستخرجة من التطبيق ====================

  /// ثوابت الأنماط (للحفاظ على التوافق)
  static const double defaultCardPadding = space5;
  static const double defaultMargin = space4;
  static const double defaultBorderRadius = radius2xl;
  static const double defaultElevation = elevation2;

  /// أحجام الأيقونات المخصصة
  static const double prayerIconSize = iconLg;
  static const double categoryIconSize = iconLg;
  static const double appBarIconSize = iconMd;
  static const double buttonIconSize = iconSm;

  /// ارتفاعات مخصصة للعناصر
  static const double appBarHeight = 60.0;
  static const double bottomNavHeight = 70.0;
  static const double cardMinHeight = 80.0;
  static const double buttonHeight = 48.0;

  /// مساحات مخصصة للتخطيط
  static const double screenPadding = space4;
  static const double sectionSpacing = space6;
  static const double itemSpacing = space3;
  
  /// ألوان إضافية مستخرجة من التطبيق
  static const Color backgroundOverlay = Color(0x80000000);
  static const Color cardOverlay = Color(0x10000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}

/// Extension لتسهيل الوصول للألوان من خلال BuildContext
extension AppThemeExtension on BuildContext {
  // الألوان الأساسية
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
  bool get isDarkMode => _isDarkMode;

  // أنماط النصوص
  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;

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
      color: dividerColor.withValues(alpha: 0.2),
      width: AppTheme.borderLight,
    ),
  );

  // الظلال
  List<BoxShadow> get shadowSm => AppTheme.shadowSm;
  List<BoxShadow> get shadowMd => AppTheme.shadowMd;
  List<BoxShadow> get shadowLg => AppTheme.shadowLg;
  List<BoxShadow> get shadowXl => AppTheme.shadowXl;
}

/// Extension لتعديل الألوان
extension ColorExtension on Color {
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

/// Extension لأنماط النصوص مع FontWeight
extension TextStyleExtension on TextStyle? {
  TextStyle? get light => this?.copyWith(fontWeight: AppTheme.light);
  TextStyle? get regular => this?.copyWith(fontWeight: AppTheme.regular);
  TextStyle? get medium => this?.copyWith(fontWeight: AppTheme.medium);
  TextStyle? get semiBold => this?.copyWith(fontWeight: AppTheme.semiBold);
  TextStyle? get bold => this?.copyWith(fontWeight: AppTheme.bold);
}