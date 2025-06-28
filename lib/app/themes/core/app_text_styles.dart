// lib/app/themes/core/app_text_styles.dart (محسن)
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// نظام الخطوط الإسلامي المحسن - مع الحفاظ على الأسماء الأصلية
class AppTextStyles {
  AppTextStyles._();
  
  // ========== الخطوط المحسنة ==========
  
  /// خط النص الأساسي (محسن للعربية)
  static const String primaryFontFamily = 'Tajawal';    // محسن من Cairo
  
  /// خط النص الثانوي (للنصوص الدينية)
  static const String secondaryFontFamily = 'Amiri Quran'; // محسن من Amiri
  
  /// خط الأرقام (للعدادات والأوقات)
  static const String numbersFontFamily = 'Cairo';      // مناسب للأرقام
  
  // ========== أوزان الخطوط (كما هي) ==========
  
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
  
  // ========== أحجام الخطوط المحسنة ==========
  
  static const double size10 = 10.0;
  static const double size12 = 12.0;
  static const double size14 = 14.0;
  static const double size16 = 16.0;
  static const double size18 = 18.0;
  static const double size20 = 20.0;
  static const double size24 = 24.0;
  static const double size28 = 28.0;
  static const double size32 = 32.0;
  static const double size36 = 36.0;
  static const double size48 = 48.0;
  static const double size60 = 60.0;
  static const double size72 = 72.0;
  
  // ========== ارتفاع الأسطر المحسن للعربية ==========
  
  static const double lineHeightTight = 1.2;    // للعناوين
  static const double lineHeightNormal = 1.5;   // محسن للعربية (كان 1.4)
  static const double lineHeightRelaxed = 1.7;  // محسن للنصوص الطويلة
  static const double lineHeightLoose = 2.0;    // للنصوص الدينية
  
  // ========== تباعد الأحرف ==========
  
  static const double letterSpacingTight = -0.3;   // محسن
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.3;     // محسن للعربية
  static const double letterSpacingWider = 0.6;    // محسن
  
  // ========== العناوين الرئيسية المحسنة ==========
  
  /// عنوان كبير جداً (محسن)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size60,        // مصغر قليلاً من 72
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: AppColors.textPrimary,
  );
  
  /// عنوان كبير (محسن)
  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size48,        // مصغر قليلاً من 60
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: AppColors.textPrimary,
  );
  
  /// عنوان متوسط (محسن)
  static const TextStyle displaySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size36,        // مصغر قليلاً من 48
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  // ========== العناوين الفرعية المحسنة ==========
  
  /// عنوان رئيسي للشاشات (محسن)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size32,        // مصغر من 36
    fontWeight: bold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان فرعي كبير (محسن)
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size24,        // مناسب للعربية
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان فرعي صغير (محسن)
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size20,        // مصغر من 28
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  // ========== عناوين الأقسام المحسنة ==========
  
  /// عنوان قسم كبير (محسن)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size20,        // مناسب للعربية
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان قسم متوسط (محسن)
  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size18,        // محسن
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان قسم صغير (محسن)
  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  // ========== النصوص الأساسية المحسنة ==========
  
  /// نص كبير (محسن للعربية)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,        // مناسب للقراءة
    fontWeight: regular,
    height: lineHeightRelaxed, // محسن للعربية
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// نص متوسط (النص الأساسي - محسن)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,
    fontWeight: regular,
    height: lineHeightNormal,  // محسن للعربية
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// نص صغير (محسن)
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: regular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textSecondary,
  );
  
  // ========== النصوص الإضافية المحسنة ==========
  
  /// تسمية كبيرة (محسن)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: AppColors.textPrimary,
  );
  
  /// تسمية متوسطة (محسن)
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: AppColors.textPrimary,
  );
  
  /// تسمية صغيرة (محسن)
  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size10,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWider,
    color: AppColors.textSecondary,
  );
  
  // ========== النصوص التفسيرية المحسنة ==========
  
  /// نص تفسيري (محسن)
  static const TextStyle caption = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: regular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textTertiary,
  );
  
  /// نص صغير جداً (محسن)
  static const TextStyle overline = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size10,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWider,
    color: AppColors.textTertiary,
  );
  
  // ========== النصوص الدينية المتخصصة (جديدة ومحسنة) ==========
  
  /// نص الآيات القرآنية (محسن للوضوح)
  static const TextStyle islamic = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: size18,        // محسن للقراءة
    fontWeight: regular,
    height: lineHeightLoose, // مسافة أكبر للوضوح
    letterSpacing: letterSpacingWide, // تباعد مناسب للعربية
    color: AppColors.textReligious,
  );
  
  /// نص الأحاديث الشريفة (جديد)
  static const TextStyle hadith = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: medium,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textReligious,
    fontStyle: FontStyle.italic,
  );
  
  /// نص الأذكار (جديد)
  static const TextStyle dhikr = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: medium,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textReligious,
  );
  
  /// نص للأرقام والأوقات (محسن)
  static const TextStyle numbers = TextStyle(
    fontFamily: numbersFontFamily,
    fontSize: size20,        // مناسب للقراءة
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  /// نص للعدادات الكبيرة (محسن)
  static const TextStyle counter = TextStyle(
    fontFamily: numbersFontFamily,
    fontSize: size36,        // مصغر قليلاً من 48
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  /// نص أوقات الصلاة (جديد)
  static const TextStyle prayerTime = TextStyle(
    fontFamily: numbersFontFamily,
    fontSize: size24,
    fontWeight: bold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  // ========== أنماط الأزرار المحسنة ==========
  
  /// نص الأزرار الأساسية (محسن)
  static const TextStyle button = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,        // محسن للعربية
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: Colors.white,
  );
  
  /// نص الأزرار الثانوية (محسن)
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: AppColors.primary,
  );
  
  /// نص الأزرار الصغيرة (محسن)
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWider,
    color: Colors.white,
  );
  
  // ========== دوال الإنشاء المحسنة ==========
  
  /// إنشاء TextTheme للوضع الفاتح (محسن)
  static TextTheme get lightTextTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
  
  /// إنشاء TextTheme للوضع الداكن (محسن)
  static TextTheme get darkTextTheme => lightTextTheme.copyWith(
    displayLarge: displayLarge.copyWith(color: AppColors.textPrimaryDark),
    displayMedium: displayMedium.copyWith(color: AppColors.textPrimaryDark),
    displaySmall: displaySmall.copyWith(color: AppColors.textPrimaryDark),
    headlineLarge: headlineLarge.copyWith(color: AppColors.textPrimaryDark),
    headlineMedium: headlineMedium.copyWith(color: AppColors.textPrimaryDark),
    headlineSmall: headlineSmall.copyWith(color: AppColors.textPrimaryDark),
    titleLarge: titleLarge.copyWith(color: AppColors.textPrimaryDark),
    titleMedium: titleMedium.copyWith(color: AppColors.textPrimaryDark),
    titleSmall: titleSmall.copyWith(color: AppColors.textPrimaryDark),
    bodyLarge: bodyLarge.copyWith(color: AppColors.textPrimaryDark),
    bodyMedium: bodyMedium.copyWith(color: AppColors.textPrimaryDark),
    bodySmall: bodySmall.copyWith(color: AppColors.textSecondaryDark),
    labelLarge: labelLarge.copyWith(color: AppColors.textPrimaryDark),
    labelMedium: labelMedium.copyWith(color: AppColors.textPrimaryDark),
    labelSmall: labelSmall.copyWith(color: AppColors.textSecondaryDark),
  );
  
  // ========== دوال مساعدة للنصوص العربية (جديدة) ==========
  
  /// الحصول على نمط النص المناسب للمحتوى الديني
  static TextStyle getReligiousTextStyle(String type, {bool isDark = false}) {
    final baseColor = isDark ? AppColors.textReligiousDark : AppColors.textReligious;
    
    switch (type.toLowerCase()) {
      case 'quran':
      case 'ayah':
        return islamic.copyWith(color: baseColor);
      case 'hadith':
        return hadith.copyWith(color: baseColor);
      case 'dhikr':
      case 'adhkar':
        return dhikr.copyWith(color: baseColor);
      case 'dua':
        return bodyLarge.copyWith(
          color: baseColor,
          height: lineHeightRelaxed,
        );
      default:
        return bodyMedium.copyWith(color: baseColor);
    }
  }
  
  /// الحصول على نمط العداد المناسب
  static TextStyle getCounterStyle(int value) {
    if (value >= 1000) {
      return counter.copyWith(fontSize: size28); // أصغر للأرقام الكبيرة
    } else if (value >= 100) {
      return counter.copyWith(fontSize: size32);
    } else {
      return counter; // الحجم الكامل للأرقام الصغيرة
    }
  }
  
  /// نمط نص متجاوب حسب حجم الشاشة
  static TextStyle getResponsiveTextStyle(double screenWidth, TextStyle baseStyle) {
    double scaleFactor = 1.0;
    
    if (screenWidth < 360) {
      scaleFactor = 0.9; // شاشات صغيرة
    } else if (screenWidth > 600) {
      scaleFactor = 1.1; // شاشات كبيرة (تابلت)
    }
    
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? size14) * scaleFactor,
    );
  }
}

/// Extension methods لأنماط النصوص (محسنة ومبسطة)
extension TextStyleExtensions on TextStyle {
  // ========== أوزان الخطوط ==========
  
  TextStyle get thin => copyWith(fontWeight: AppTextStyles.thin);
  TextStyle get light => copyWith(fontWeight: AppTextStyles.light);
  TextStyle get regular => copyWith(fontWeight: AppTextStyles.regular);
  TextStyle get medium => copyWith(fontWeight: AppTextStyles.medium);
  TextStyle get semiBold => copyWith(fontWeight: AppTextStyles.semiBold);
  TextStyle get bold => copyWith(fontWeight: AppTextStyles.bold);
  
  // ========== الألوان ==========
  
  TextStyle primary([Color? color]) => 
      copyWith(color: color ?? AppColors.primary);
  TextStyle secondary([Color? color]) => 
      copyWith(color: color ?? AppColors.secondary);
  TextStyle success([Color? color]) => 
      copyWith(color: color ?? AppColors.success);
  TextStyle warning([Color? color]) => 
      copyWith(color: color ?? AppColors.warning);
  TextStyle error([Color? color]) => 
      copyWith(color: color ?? AppColors.error);
  
  // ========== التأثيرات ==========
  
  /// تطبيق الشفافية
  TextStyle withOpacity(double opacity) => 
      copyWith(color: color?.withValues(alpha: opacity));
  
  /// تطبيق الظلال (مبسط)
  TextStyle withShadow({
    Color shadowColor = Colors.black,
    double opacity = 0.3,
    Offset offset = const Offset(0, 1),
    double blurRadius = 2,
  }) => copyWith(
    shadows: [
      Shadow(
        color: shadowColor.withValues(alpha: opacity),
        offset: offset,
        blurRadius: blurRadius,
      ),
    ],
  );
  
  // ========== أنماط خاصة ==========
  
  /// تطبيق خط النصوص الإسلامية
  TextStyle get islamic => copyWith(
    fontFamily: AppTextStyles.secondaryFontFamily,
    height: AppTextStyles.lineHeightLoose,
    letterSpacing: AppTextStyles.letterSpacingWide,
  );
  
  /// تطبيق خط الأرقام
  TextStyle get numbers => copyWith(
    fontFamily: AppTextStyles.numbersFontFamily,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
  
  /// نمط للنصوص العربية (جديد)
  TextStyle get arabic => copyWith(
    height: AppTextStyles.lineHeightRelaxed,
    letterSpacing: AppTextStyles.letterSpacingNormal,
  );
  
  /// نمط للعناوين المهمة (جديد)
  TextStyle get important => copyWith(
    fontWeight: AppTextStyles.bold,
    color: AppColors.primary,
  );
}