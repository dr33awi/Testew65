// lib/app/themes/app_theme.dart - عربي وداكن فقط
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// استيراد جميع مكونات الثيم
import 'core/app_colors.dart';
import 'core/app_text_styles.dart';
import 'core/app_theme_constants.dart';

// إعادة تصدير المكونات للوصول السهل
export 'core/app_colors.dart';
export 'core/app_text_styles.dart';
export 'core/app_theme_constants.dart';
export 'core/app_extensions.dart';
export 'core/theme_notifier.dart';
export 'widgets/unified_widgets.dart';

/// نظام الثيم الإسلامي - الوضع الداكن فقط
class AppTheme {
  AppTheme._();
  
  // ========== الثيم الداكن الوحيد ==========
  
  /// الثيم الداكن الإسلامي
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // الألوان الأساسية
    primarySwatch: AppColors.primary.toMaterialColor(),
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.black,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.black,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: Colors.black,
      outline: AppColors.outline,
      shadow: Colors.black87,
      surfaceVariant: AppColors.quranBackground,
    ),
    
    // خلفية التطبيق
    scaffoldBackgroundColor: AppColors.background,
    
    // ثيم النصوص
    textTheme: _createTextTheme(),
    
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
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      centerTitle: true,
    ),
    
    // ثيم البطاقات
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: AppThemeConstants.elevationSm,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
      ),
      margin: const EdgeInsets.all(AppThemeConstants.space3),
    ),
    
    // ثيم الأزرار
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        elevation: AppThemeConstants.elevationSm,
        shadowColor: AppColors.primary.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeConstants.space5,
          vertical: AppThemeConstants.space3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        ),
        textStyle: AppTextStyles.button,
        minimumSize: const Size(80, AppThemeConstants.buttonHeightMedium),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeConstants.space4,
          vertical: AppThemeConstants.space2,
        ),
        textStyle: AppTextStyles.buttonSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusSm),
        ),
      ),
    ),
    
    // ثيم الأيقونات
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: AppThemeConstants.iconMd,
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.black,
      size: AppThemeConstants.iconMd,
    ),
    
    // ثيم حقول الإدخال
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
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
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textHint,
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
    
    // ثيم الحوارات
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      elevation: AppThemeConstants.elevationLg,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusXl),
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      actionsPadding: const EdgeInsets.all(AppThemeConstants.space4),
    ),
    
    // ثيم القوائم السفلية
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      elevation: AppThemeConstants.elevationLg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppThemeConstants.radiusXl),
        ),
      ),
      constraints: const BoxConstraints(
        maxHeight: AppThemeConstants.bottomSheetMaxHeight,
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
      iconColor: AppColors.textSecondary,
      textColor: AppColors.textPrimary,
    ),
    
    // ثيم الفواصل
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: AppThemeConstants.borderWidthThin,
      space: AppThemeConstants.space4,
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
      checkColor: WidgetStateProperty.all(Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusXs),
      ),
    ),
    
    // ثيم أشرطة التمرير
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.textTertiary.withValues(alpha: 0.6)),
      trackColor: WidgetStateProperty.all(AppColors.divider),
      radius: const Radius.circular(AppThemeConstants.radiusSm),
      thickness: WidgetStateProperty.all(6.0),
    ),
    
    // ثيم الشرائح
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.divider,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withValues(alpha: 0.1),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: AppTextStyles.caption.copyWith(color: Colors.black),
    ),
    
    // ثيم شريط التنقل السفلي
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiary,
      elevation: AppThemeConstants.elevationMd,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: AppTextStyles.primaryFontFamily,
        fontSize: AppTextStyles.size12,
        fontWeight: AppTextStyles.medium,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: AppTextStyles.primaryFontFamily,
        fontSize: AppTextStyles.size12,
        fontWeight: AppTextStyles.regular,
      ),
    ),
    
    // ثيم التابات
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 3),
      ),
      labelStyle: TextStyle(
        fontFamily: AppTextStyles.primaryFontFamily,
        fontSize: AppTextStyles.size14,
        fontWeight: AppTextStyles.semiBold,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: AppTextStyles.primaryFontFamily,
        fontSize: AppTextStyles.size14,
        fontWeight: AppTextStyles.regular,
      ),
    ),
    
    // ثيم الـ SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: AppThemeConstants.elevationMd,
    ),
    
    // ثيم الـ FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
      elevation: AppThemeConstants.elevationMd,
      shape: CircleBorder(),
    ),
  );
  
  // ========== TextTheme Builder ==========
  
  static TextTheme _createTextTheme() {
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
  
  // ========== دوال مساعدة للثيم الإسلامي ==========
  
  /// الحصول على ثيم مخصص للمحتوى الديني
  static ThemeData getReligiousTheme({
    required BuildContext context,
    required String contentType,
  }) {
    final baseTheme = theme;
    final backgroundColor = AppColors.getReligiousBackground(contentType);
    
    return baseTheme.copyWith(
      cardTheme: baseTheme.cardTheme.copyWith(
        color: backgroundColor,
      ),
      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: AppTextStyles.getReligiousTextStyle(contentType),
        bodyMedium: AppTextStyles.getReligiousTextStyle(contentType),
      ),
    );
  }
  
  /// الحصول على ثيم مخصص للصلوات
  static ThemeData getPrayerTheme({
    required BuildContext context,
    required String prayerName,
  }) {
    final baseTheme = theme;
    final prayerColor = AppColors.getPrayerColor(prayerName);
    
    return baseTheme.copyWith(
      primaryColor: prayerColor,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: prayerColor,
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: prayerColor.withValues(alpha: 0.1),
      ),
    );
  }
  
  /// الحصول على ثيم متجاوب حسب حجم الشاشة
  static ThemeData getResponsiveTheme({
    required BuildContext context,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseTheme = theme;
    
    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: AppTextStyles.getResponsiveTextStyle(screenWidth, AppTextStyles.bodyLarge),
        bodyMedium: AppTextStyles.getResponsiveTextStyle(screenWidth, AppTextStyles.bodyMedium),
        titleLarge: AppTextStyles.getResponsiveTextStyle(screenWidth, AppTextStyles.titleLarge),
        headlineMedium: AppTextStyles.getResponsiveTextStyle(screenWidth, AppTextStyles.headlineMedium),
      ),
      cardTheme: baseTheme.cardTheme.copyWith(
        margin: EdgeInsets.all(AppThemeConstants.getResponsiveSpacing(screenWidth)),
      ),
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
  static const Color tertiary = AppColors.tertiary;
  static const Color success = AppColors.success;
  static const Color warning = AppColors.warning;
  static const Color error = AppColors.error;
  static const Color info = AppColors.info;
  
  // ألوان إسلامية سريعة
  static const Color islamicGreen = AppColors.islamicGreen;
  static const Color islamicGold = AppColors.islamicGold;
  static const Color islamicBrown = AppColors.islamicBrown;
  
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
  static const Curve curveQuick = AppThemeConstants.curveQuick;
  
  // ارتفاعات سريعة
  static const double elevationSm = AppThemeConstants.elevationSm;
  static const double elevationMd = AppThemeConstants.elevationMd;
  static const double elevationLg = AppThemeConstants.elevationLg;
  
  // ظلال سريعة
  static List<BoxShadow> get shadowSm => AppThemeConstants.shadowSm;
  static List<BoxShadow> get shadowMd => AppThemeConstants.shadowMd;
  static List<BoxShadow> get shadowLg => AppThemeConstants.shadowLg;
  static List<BoxShadow> get islamicCardShadow => AppThemeConstants.islamicCardShadow;
  
  // ألوان النصوص
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textHint = AppColors.textHint;
  
  // ألوان إضافية للنصوص الدينية
  static const Color religiousText = AppColors.textReligious;
}