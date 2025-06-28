// lib/app/themes/app_theme.dart (محسن مع الحفاظ على البنية الأصلية)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// استيراد جميع مكونات الثيم المحسنة
import 'core/app_colors.dart';
import 'core/app_text_styles.dart';
import 'core/app_theme_constants.dart';

// إعادة تصدير المكونات للوصول السهل (كما هو)
export 'core/app_colors.dart';
export 'core/app_text_styles.dart';
export 'core/app_theme_constants.dart';
export 'core/app_extensions.dart';
export 'core/theme_notifier.dart';
export 'widgets/unified_widgets.dart';

/// الثيم الإسلامي المحسن - مع الحفاظ على الأسماء والبنية الأصلية
class AppTheme {
  AppTheme._();
  
  // ========== الثيمات الأساسية المحسنة ==========
  
  /// الثيم الفاتح (محسن للهوية الإسلامية)
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // الألوان الأساسية المحسنة
    primarySwatch: AppColors.primary.toMaterialColor(),
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.tertiary,           // جديد - البني الإسلامي
      onTertiary: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.outline,
      shadow: Colors.black26,
      surfaceVariant: AppColors.quranBackground,  // جديد - للمحتوى الديني
    ),
    
    // خلفية السكافولد
    scaffoldBackgroundColor: AppColors.backgroundLight,
    
    // ثيم النصوص المحسن
    textTheme: _createLightTextTheme(),
    
    // ثيم الشريط العلوي المحسن
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
      centerTitle: true,  // إضافة - توسيط العنوان للعربية
    ),
    
    // ثيم البطاقات المحسن
    cardTheme: CardThemeData(
      color: AppColors.cardLight,
      elevation: AppThemeConstants.elevationSm,
      shadowColor: Colors.black.withValues(alpha: 0.1), // محسن
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
      ),
      margin: const EdgeInsets.all(AppThemeConstants.space3), // محسن
    ),
    
    // ثيم الأزرار المحسن
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: AppThemeConstants.elevationSm,
        shadowColor: AppColors.primary.withValues(alpha: 0.3), // إضافة
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeConstants.space5,  // محسن
          vertical: AppThemeConstants.space3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        ),
        textStyle: AppTextStyles.button,
        minimumSize: const Size(80, AppThemeConstants.buttonHeightMedium), // إضافة
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
    
    // ثيم الأيقونات المحسن
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: AppThemeConstants.iconMd,
    ),
    primaryIconTheme: const IconThemeData(
      color: Colors.white,
      size: AppThemeConstants.iconMd,
    ),
    
    // ثيم حقول الإدخال المحسن للعربية
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
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textHint,
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
    
    // ثيم الحوارات المحسن
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation: AppThemeConstants.elevationLg,
      shadowColor: Colors.black.withValues(alpha: 0.2), // محسن
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusXl), // محسن
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      actionsPadding: const EdgeInsets.all(AppThemeConstants.space4), // إضافة
    ),
    
    // ثيم القوائم السفلية المحسن
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation: AppThemeConstants.elevationLg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppThemeConstants.radiusXl),
        ),
      ),
      constraints: const BoxConstraints(
        maxHeight: AppThemeConstants.bottomSheetMaxHeight,
      ), // إضافة
    ),
    
    // ثيم القوائم المحسن للعربية
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
      space: AppThemeConstants.space4, // محسن
    ),
    
    // ثيم مؤشرات التقدم المحسن
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.divider,
      circularTrackColor: AppColors.divider,
    ),
    
    // ثيم المفاتيح المحسن
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusXs),
      ),
    ),
    
    // ثيم أشرطة التمرير
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.textTertiary.withValues(alpha: 0.6)),
      trackColor: WidgetStateProperty.all(AppColors.divider),
      radius: const Radius.circular(AppThemeConstants.radiusSm),
      thickness: WidgetStateProperty.all(6.0), // محسن
    ),
    
    // ثيم الشرائح
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.divider,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withValues(alpha: 0.1),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: AppTextStyles.caption.copyWith(color: Colors.white),
    ),
    
    // ثيم شريط التنقل السفلي المحسن
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
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
    
    // ثيم التابات المحسن
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 3), // محسن
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
    
    // ثيم الـ SnackBar المحسن
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: AppThemeConstants.elevationMd,
    ),
    
    // ثيم الـ FloatingActionButton المحسن
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: AppThemeConstants.elevationMd,
      shape: CircleBorder(),
    ),
  );
  
  /// الثيم الداكن المحسن
  static ThemeData get darkTheme => lightTheme.copyWith(
    brightness: Brightness.dark,
    
    // الألوان للوضع الداكن المحسن
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.outlineDark,
      shadow: Colors.black54,
      surfaceVariant: AppColors.surfaceDark, // للمحتوى الديني في الوضع الداكن
    ),
    
    // خلفية السكافولد للوضع الداكن
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
      centerTitle: true,
    ),
    
    // ثيم البطاقات للوضع الداكن
    cardTheme: CardThemeData(
      color: AppColors.cardDark,
      elevation: AppThemeConstants.elevationSm,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
      ),
      margin: const EdgeInsets.all(AppThemeConstants.space3),
    ),
    
    // ثيم الحوارات للوضع الداكن
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: AppThemeConstants.elevationLg,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusXl),
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
    ),
    
    // ثيم القوائم السفلية للوضع الداكن
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: AppThemeConstants.elevationLg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppThemeConstants.radiusXl),
        ),
      ),
    ),
    
    // ثيم شريط التنقل السفلي للوضع الداكن
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textTertiaryDark,
      elevation: AppThemeConstants.elevationMd,
      type: BottomNavigationBarType.fixed,
    ),
    
    // ثيم حقول الإدخال للوضع الداكن
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        borderSide: const BorderSide(color: AppColors.borderDark),
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
        color: AppColors.textHintDark,
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondaryDark,
      ),
    ),
  );
  
  // ========== TextTheme Builders المحسنة ==========
  
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
  
  // ========== دوال مساعدة للثيم الإسلامي (جديدة) ==========
  
  /// الحصول على ثيم مخصص للمحتوى الديني
  static ThemeData getReligiousTheme({
    required BuildContext context,
    required String contentType,
    bool isDark = false,
  }) {
    final baseTheme = isDark ? darkTheme : lightTheme;
    final backgroundColor = AppColors.getReligiousBackground(contentType, isDark: isDark);
    
    return baseTheme.copyWith(
      cardTheme: baseTheme.cardTheme.copyWith(
        color: backgroundColor,
      ),
      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: AppTextStyles.getReligiousTextStyle(contentType, isDark: isDark),
        bodyMedium: AppTextStyles.getReligiousTextStyle(contentType, isDark: isDark),
      ),
    );
  }
  
  /// الحصول على ثيم مخصص للصلوات
  static ThemeData getPrayerTheme({
    required BuildContext context,
    required String prayerName,
    bool isDark = false,
  }) {
    final baseTheme = isDark ? darkTheme : lightTheme;
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
    bool isDark = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseTheme = isDark ? darkTheme : lightTheme;
    
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

// ========== ثوابت سريعة للوصول (محسنة) ==========

/// ثوابت سريعة للاستخدام في التطبيق - محسنة مع الحفاظ على الأسماء
class ThemeConstants {
  ThemeConstants._();
  
  // ألوان سريعة محسنة
  static const Color primary = AppColors.primary;
  static const Color secondary = AppColors.secondary;
  static const Color accent = AppColors.accent;
  static const Color tertiary = AppColors.tertiary;        // جديد
  static const Color success = AppColors.success;
  static const Color warning = AppColors.warning;
  static const Color error = AppColors.error;
  static const Color info = AppColors.info;
  
  // ألوان إسلامية سريعة (جديدة)
  static const Color islamicGreen = AppColors.islamicGreen;
  static const Color islamicGold = AppColors.islamicGold;
  static const Color islamicBrown = AppColors.islamicBrown;
  
  // مسافات سريعة (كما هي)
  static const double space1 = AppThemeConstants.space1;
  static const double space2 = AppThemeConstants.space2;
  static const double space3 = AppThemeConstants.space3;
  static const double space4 = AppThemeConstants.space4;
  static const double space5 = AppThemeConstants.space5;
  static const double space6 = AppThemeConstants.space6;
  static const double space8 = AppThemeConstants.space8;
  
  // أنصاف أقطار سريعة محسنة
  static const double radiusSm = AppThemeConstants.radiusSm;
  static const double radiusMd = AppThemeConstants.radiusMd;
  static const double radiusLg = AppThemeConstants.radiusLg;
  static const double radiusXl = AppThemeConstants.radiusXl;
  static const double radius2xl = AppThemeConstants.radius2xl;
  static const double radiusFull = AppThemeConstants.radiusFull;
  
  // أيقونات سريعة محسنة
  static const double iconSm = AppThemeConstants.iconSm;
  static const double iconMd = AppThemeConstants.iconMd;
  static const double iconLg = AppThemeConstants.iconLg;
  static const double iconXl = AppThemeConstants.iconXl;
  static const double icon2xl = AppThemeConstants.icon2xl;
  
  // أيقونات التطبيق المخصصة محسنة
  static const IconData iconHome = AppThemeConstants.iconHome;
  static const IconData iconSettings = AppThemeConstants.iconSettings;
  static const IconData iconNotifications = AppThemeConstants.iconNotifications;
  static const IconData iconPrayerTime = AppThemeConstants.iconPrayerTime;
  static const IconData iconAthkar = AppThemeConstants.iconAthkar;
  static const IconData iconQibla = AppThemeConstants.iconQibla;
  static const IconData iconTasbih = AppThemeConstants.iconTasbih;
  static const IconData iconQuran = AppThemeConstants.iconQuran;
  static const IconData iconDua = AppThemeConstants.iconDua;
  
  // أوزان الخطوط سريعة (كما هي)
  static const FontWeight light = AppTextStyles.light;
  static const FontWeight regular = AppTextStyles.regular;
  static const FontWeight medium = AppTextStyles.medium;
  static const FontWeight semiBold = AppTextStyles.semiBold;
  static const FontWeight bold = AppTextStyles.bold;
  
  // مدد الحركة سريعة محسنة
  static const Duration durationFast = AppThemeConstants.durationFast;
  static const Duration durationNormal = AppThemeConstants.durationNormal;
  static const Duration durationSlow = AppThemeConstants.durationSlow;
  
  // منحنيات الحركة سريعة محسنة
  static const Curve curveSmooth = AppThemeConstants.curveSmooth;
  static const Curve curveBounce = AppThemeConstants.curveBounce;
  static const Curve curveElastic = AppThemeConstants.curveElastic;
  static const Curve curveQuick = AppThemeConstants.curveQuick;   // جديد
  
  // ارتفاعات سريعة (كما هي)
  static const double elevationSm = AppThemeConstants.elevationSm;
  static const double elevationMd = AppThemeConstants.elevationMd;
  static const double elevationLg = AppThemeConstants.elevationLg;
  
  // ظلال سريعة محسنة
  static List<BoxShadow> get shadowSm => AppThemeConstants.shadowSm;
  static List<BoxShadow> get shadowMd => AppThemeConstants.shadowMd;
  static List<BoxShadow> get shadowLg => AppThemeConstants.shadowLg;
  static List<BoxShadow> get islamicCardShadow => AppThemeConstants.islamicCardShadow; // جديد
  
  // ألوان النصوص للوضع الفاتح (كما هي)
  static const Color lightTextPrimary = AppColors.textPrimary;
  static const Color lightTextSecondary = AppColors.textSecondary;
  static const Color lightTextHint = AppColors.textHint;
  
  // ألوان النصوص للوضع الداكن (كما هي)
  static const Color darkTextPrimary = AppColors.textPrimaryDark;
  static const Color darkTextSecondary = AppColors.textSecondaryDark;
  static const Color darkTextHint = AppColors.textHintDark;
  
  // ألوان إضافية للنصوص الدينية (جديدة)
  static const Color religiousTextLight = AppColors.textReligious;
  static const Color religiousTextDark = AppColors.textReligiousDark;
}
