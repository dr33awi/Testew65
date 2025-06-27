// lib/app/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// استيراد جميع مكونات الثيم
import 'core/app_colors.dart';
import 'core/app_text_styles.dart';
import 'core/app_theme_constants.dart';

// إعادة تصدير جميع المكونات للوصول السهل
export 'core/app_colors.dart';
export 'core/app_text_styles.dart';
export 'core/app_theme_constants.dart';
export 'core/app_extensions.dart';
export 'core/theme_notifier.dart';
export 'widgets/unified_widgets.dart';

/// الثيم الموحد للتطبيق
class AppTheme {
  AppTheme._();
  
  // ========== الثيمات الأساسية ==========
  
  /// الثيم الفاتح
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // الألوان الأساسية
    primarySwatch: AppColors.primary.toMaterialColor(),
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.outline,
      shadow: Colors.black26,
    ),
    
    // خلفية السكافولد
    scaffoldBackgroundColor: AppColors.backgroundLight,
    
    // ثيم النصوص
    textTheme: _createLightTextTheme(),
    
    // ثيم الشريط العلوي
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: TextStyle(
        fontFamily: AppTextStyles.primaryFontFamily,
        fontSize: AppTextStyles.size20,
        fontWeight: AppTextStyles.semiBold,
        color: AppColors.textPrimary,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    
    // ثيم البطاقات
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: AppThemeConstants.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
      ),
      margin: const EdgeInsets.all(AppThemeConstants.space2),
    ),
    
    // ثيم الأزرار
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: AppThemeConstants.elevationSm,
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeConstants.space4,
          vertical: AppThemeConstants.space3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeConstants.space4,
          vertical: AppThemeConstants.space3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        ),
        textStyle: AppTextStyles.buttonSecondary,
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeConstants.space3,
          vertical: AppThemeConstants.space2,
        ),
        textStyle: AppTextStyles.buttonSecondary,
      ),
    ),
    
    // ثيم الأيقونات
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: AppThemeConstants.iconMd,
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.white,
      size: AppThemeConstants.iconMd,
    ),
    
    // ثيم حقول الإدخال
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.all(AppThemeConstants.space4),
    ),
    
    // ثيم الحوارات
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation: AppThemeConstants.elevationLg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
    ),
    
    // ثيم القوائم السفلية
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation: AppThemeConstants.elevationLg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppThemeConstants.radiusXl),
        ),
      ),
    ),
    
    // ثيم القوائم
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppThemeConstants.space4,
        vertical: AppThemeConstants.space2,
      ),
      titleTextStyle: TextStyle(
        fontFamily: AppTextStyles.primaryFontFamily,
        fontSize: AppTextStyles.size16,
        fontWeight: AppTextStyles.medium,
        color: AppColors.textPrimary,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: AppTextStyles.primaryFontFamily,
        fontSize: AppTextStyles.size14,
        fontWeight: AppTextStyles.regular,
        color: AppColors.textSecondary,
      ),
    ),
    
    // ثيم الفواصل
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: AppThemeConstants.borderWidthThin,
      space: AppThemeConstants.space2,
    ),
    
    // ثيم مؤشرات التقدم
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.divider,
      circularTrackColor: AppColors.divider,
    ),
    
    // ثيم المفاتيح
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.textTertiary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary.withValues(alpha: 0.5);
        }
        return AppColors.divider;
      }),
    ),
    
    // ثيم أزرار الراديو
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.textTertiary;
      }),
    ),
    
    // ثيم صناديق الاختيار
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),
    
    // ثيم أشرطة التمرير
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.textTertiary),
      trackColor: WidgetStateProperty.all(AppColors.divider),
      radius: const Radius.circular(AppThemeConstants.radiusSm),
    ),
    
    // ثيم الشرائح
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.divider,
      thumbColor: AppColors.primary,
      overlayColor: Color(0x1A0D7377),
    ),
    
    // ثيم شريط التنقل السفلي
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      elevation: AppThemeConstants.elevationMd,
      type: BottomNavigationBarType.fixed,
    ),
    
    // ثيم التابات
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
  );
  
  /// الثيم الداكن
  static ThemeData get darkTheme => lightTheme.copyWith(
    brightness: Brightness.dark,
    
    // الألوان للوضع الداكن
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.accent,
      onTertiary: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.outlineDark,
      shadow: Colors.black54,
    ),
    
    // خلفية السكافولد
    scaffoldBackgroundColor: AppColors.backgroundDark,
    
    // ثيم النصوص للوضع الداكن
    textTheme: _createDarkTextTheme(),
    
    // ثيم الشريط العلوي للوضع الداكن
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimaryDark,
      titleTextStyle: TextStyle(
        fontFamily: AppTextStyles.primaryFontFamily,
        fontSize: AppTextStyles.size20,
        fontWeight: AppTextStyles.semiBold,
        color: AppColors.textPrimaryDark,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    
    // ثيم البطاقات للوضع الداكن
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: AppThemeConstants.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
      ),
      margin: const EdgeInsets.all(AppThemeConstants.space2),
    ),
  );
  
  // ========== TextTheme Builders ==========
  
  static TextTheme _createLightTextTheme() {
    return const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,
      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,
      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    );
  }
  
  static TextTheme _createDarkTextTheme() {
    return _createLightTextTheme().copyWith(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimaryDark),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.textPrimaryDark),
      displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.textPrimaryDark),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimaryDark),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimaryDark),
      headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimaryDark),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimaryDark),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimaryDark),
      titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimaryDark),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimaryDark),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryDark),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryDark),
      labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimaryDark),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryDark),
    );
  }
}

// ========== ثوابت سريعة للوصول ==========

/// ثوابت سريعة للاستخدام في التطبيق
class ThemeConstants {
  ThemeConstants._();
  
  // ألوان سريعة
  static const Color primary = AppColors.primary;
  static const Color secondary = AppColors.secondary;
  static const Color accent = AppColors.accent;
  static const Color success = AppColors.success;
  static const Color warning = AppColors.warning;
  static const Color error = AppColors.error;
  static const Color info = AppColors.info;
  
  // مسافات سريعة
  static const double space1 = AppThemeConstants.space1;
  static const double space2 = AppThemeConstants.space2;
  static const double space3 = AppThemeConstants.space3;
  static const double space4 = AppThemeConstants.space4;
  static const double space5 = AppThemeConstants.space5;
  static const double space6 = AppThemeConstants.space6;
  static const double space8 = AppThemeConstants.space8;
  
  // أنصاف أقطار سريعة
  static const double radiusSm = AppThemeConstants.radiusSm;
  static const double radiusMd = AppThemeConstants.radiusMd;
  static const double radiusLg = AppThemeConstants.radiusLg;
  static const double radiusXl = AppThemeConstants.radiusXl;
  static const double radius2xl = AppThemeConstants.radius2xl;
  static const double radiusFull = AppThemeConstants.radiusFull;
  
  // أيقونات سريعة
  static const double iconSm = AppThemeConstants.iconSm;
  static const double iconMd = AppThemeConstants.iconMd;
  static const double iconLg = AppThemeConstants.iconLg;
  static const double iconXl = AppThemeConstants.iconXl;
  static const double icon2xl = AppThemeConstants.icon2xl;
  
  // أيقونات التطبيق المخصصة
  static const IconData iconHome = AppThemeConstants.iconHome;
  static const IconData iconSettings = AppThemeConstants.iconSettings;
  static const IconData iconNotifications = AppThemeConstants.iconNotifications;
  static const IconData iconPrayerTime = AppThemeConstants.iconPrayerTime;
  static const IconData iconAthkar = AppThemeConstants.iconAthkar;
  static const IconData iconQibla = AppThemeConstants.iconQibla;
  static const IconData iconTasbih = AppThemeConstants.iconTasbih;
  static const IconData iconQuran = AppThemeConstants.iconQuran;
  static const IconData iconDua = AppThemeConstants.iconDua;
  
  // أوزان الخطوط سريعة
  static const FontWeight light = AppTextStyles.light;
  static const FontWeight regular = AppTextStyles.regular;
  static const FontWeight medium = AppTextStyles.medium;
  static const FontWeight semiBold = AppTextStyles.semiBold;
  static const FontWeight bold = AppTextStyles.bold;
  
  // مدد الحركة سريعة
  static const Duration durationFast = AppThemeConstants.durationFast;
  static const Duration durationNormal = AppThemeConstants.durationNormal;
  static const Duration durationSlow = AppThemeConstants.durationSlow;
  
  // منحنيات الحركة سريعة
  static const Curve curveSmooth = AppThemeConstants.curveSmooth;
  static const Curve curveBounce = AppThemeConstants.curveBounce;
  static const Curve curveElastic = AppThemeConstants.curveElastic;
  
  // ارتفاعات سريعة
  static const double elevationSm = AppThemeConstants.elevationSm;
  static const double elevationMd = AppThemeConstants.elevationMd;
  static const double elevationLg = AppThemeConstants.elevationLg;
  
  // ظلال سريعة
  static List<BoxShadow> get shadowSm => AppThemeConstants.shadowSm;
  static List<BoxShadow> get shadowMd => AppThemeConstants.shadowMd;
  static List<BoxShadow> get shadowLg => AppThemeConstants.shadowLg;
  
  // ألوان النصوص للوضع الفاتح
  static const Color lightTextPrimary = AppColors.textPrimary;
  static const Color lightTextSecondary = AppColors.textSecondary;
  static const Color lightTextHint = AppColors.textHint;
  
  // ألوان النصوص للوضع الداكن
  static const Color darkTextPrimary = AppColors.textPrimaryDark;
  static const Color darkTextSecondary = AppColors.textSecondaryDark;
  static const Color darkTextHint = AppColors.textHintDark;
}