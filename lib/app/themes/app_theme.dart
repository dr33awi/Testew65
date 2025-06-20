// lib/app/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_constants.dart';
import 'typography.dart';

/// نظام الثيم الموحد للتطبيق الإسلامي - مبسط ونظيف
class AppTheme {
  AppTheme._();

  // ==================== مدير الثيم ====================
  
  static ValueNotifier<ThemeMode> themeModeNotifier = 
      ValueNotifier(ThemeMode.system);
  
  static void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }
  
  static void toggleTheme() {
    final currentMode = themeModeNotifier.value;
    final newMode = currentMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    setThemeMode(newMode);
  }
  
  static bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;
  
  // ==================== الثيم الفاتح ====================
  
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: ThemeConstants.fontPrimary,
    
    // الألوان
    colorScheme: ThemeConstants.lightColorScheme,
    scaffoldBackgroundColor: ThemeConstants.lightBackground,
    
    // النصوص
    textTheme: AppTypography.createTextTheme(
      ThemeConstants.lightText,
      ThemeConstants.lightTextSecondary,
    ),
    
    // شريط التطبيق
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeConstants.lightSurface,
      foregroundColor: ThemeConstants.lightText,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: AppTypography.title.copyWith(
        color: ThemeConstants.lightText,
      ),
      iconTheme: const IconThemeData(
        color: ThemeConstants.lightText,
      ),
    ),
    
    // البطاقات
    cardTheme: CardThemeData(
      color: ThemeConstants.lightCard,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spaceSm,
        vertical: ThemeConstants.spaceSm / 2,
      ),
    ),
    
    // الأزرار المرفوعة
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeConstants.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        elevation: 2,
        shadowColor: ThemeConstants.primary.withValues(alpha: 0.3),
        textStyle: AppTypography.button,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spaceMd,
        ),
      ),
    ),
    
    // الأزرار المحددة
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ThemeConstants.primary,
        side: const BorderSide(color: ThemeConstants.primary, width: 2),
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: AppTypography.button,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spaceMd,
        ),
      ),
    ),
    
    // الأزرار النصية
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ThemeConstants.primary,
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: AppTypography.button,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spaceMd,
        ),
      ),
    ),
    
    // أزرار الأيقونات
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: ThemeConstants.lightText,
        backgroundColor: Colors.transparent,
        minimumSize: const Size(ThemeConstants.buttonHeightSm, ThemeConstants.buttonHeightSm),
        padding: const EdgeInsets.all(ThemeConstants.spaceSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
        ),
      ),
    ),
    
    // حقول النص
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ThemeConstants.lightCard,
      contentPadding: const EdgeInsets.all(ThemeConstants.spaceMd),
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.lightBorder),
      ),
      
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.lightBorder),
      ),
      
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.primary, width: 2),
      ),
      
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.error),
      ),
      
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.error, width: 2),
      ),
      
      hintStyle: AppTypography.body.copyWith(
        color: ThemeConstants.lightTextHint,
      ),
      
      labelStyle: AppTypography.body.copyWith(
        color: ThemeConstants.lightTextSecondary,
      ),
      
      errorStyle: AppTypography.caption.copyWith(
        color: ThemeConstants.error,
      ),
    ),
    
    // الـ FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeConstants.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.radiusLg)),
      ),
    ),
    
    // التنقل السفلي
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ThemeConstants.lightSurface,
      selectedItemColor: ThemeConstants.primary,
      unselectedItemColor: ThemeConstants.lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontWeight: ThemeConstants.fontSemiBold,
        fontSize: ThemeConstants.fontSizeXs,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: ThemeConstants.fontRegular,
        fontSize: ThemeConstants.fontSizeXs,
      ),
    ),
    
    // الحوارات
    dialogTheme: DialogThemeData(
      backgroundColor: ThemeConstants.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      elevation: 8,
      titleTextStyle: AppTypography.title.copyWith(
        color: ThemeConstants.lightText,
      ),
      contentTextStyle: AppTypography.body.copyWith(
        color: ThemeConstants.lightText,
      ),
    ),
    
    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ThemeConstants.lightText,
      contentTextStyle: AppTypography.body.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      actionTextColor: ThemeConstants.primary,
    ),
    
    // الأيقونات
    iconTheme: const IconThemeData(
      color: ThemeConstants.lightTextSecondary,
      size: ThemeConstants.iconMd,
    ),
    
    // المفاتيح
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primary;
        }
        if (states.contains(WidgetState.disabled)) {
          return ThemeConstants.lightTextHint;
        }
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primary.withValues(alpha: 0.3);
        }
        if (states.contains(WidgetState.disabled)) {
          return ThemeConstants.lightBorder;
        }
        return ThemeConstants.lightBorder;
      }),
    ),
    
    // مربعات الاختيار
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      ),
    ),
    
    // أزرار الراديو
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primary;
        }
        return ThemeConstants.lightTextSecondary;
      }),
    ),
    
    // الفواصل
    dividerTheme: const DividerThemeData(
      color: ThemeConstants.lightBorder,
      thickness: 1,
      space: 1,
    ),
    
    // القوائم
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spaceMd,
        vertical: ThemeConstants.spaceSm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      tileColor: Colors.transparent,
      selectedTileColor: ThemeConstants.primary.withValues(alpha: 0.1),
      iconColor: ThemeConstants.lightTextSecondary,
      textColor: ThemeConstants.lightText,
    ),
    
    // شرائح التمرير
    sliderTheme: SliderThemeData(
      activeTrackColor: ThemeConstants.primary,
      inactiveTrackColor: ThemeConstants.lightBorder,
      thumbColor: ThemeConstants.primary,
      overlayColor: ThemeConstants.primary.withValues(alpha: 0.2),
      valueIndicatorColor: ThemeConstants.primary,
      valueIndicatorTextStyle: AppTypography.caption.copyWith(
        color: Colors.white,
      ),
    ),
    
    // شريط التقدم
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ThemeConstants.primary,
      linearTrackColor: ThemeConstants.lightBorder,
      circularTrackColor: ThemeConstants.lightBorder,
    ),
    
    // شرائح البحث
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStateProperty.all(ThemeConstants.lightCard),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      side: WidgetStateProperty.all(
        const BorderSide(color: ThemeConstants.lightBorder),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
      textStyle: WidgetStateProperty.all(AppTypography.body),
      hintStyle: WidgetStateProperty.all(
        AppTypography.body.copyWith(color: ThemeConstants.lightTextHint),
      ),
    ),
  );
  
  // ==================== الثيم الداكن ====================
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: ThemeConstants.fontPrimary,
    
    // الألوان
    colorScheme: ThemeConstants.darkColorScheme,
    scaffoldBackgroundColor: ThemeConstants.darkBackground,
    
    // النصوص
    textTheme: AppTypography.createTextTheme(
      ThemeConstants.darkText,
      ThemeConstants.darkTextSecondary,
    ),
    
    // شريط التطبيق
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeConstants.darkSurface,
      foregroundColor: ThemeConstants.darkText,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: AppTypography.title.copyWith(
        color: ThemeConstants.darkText,
      ),
      iconTheme: const IconThemeData(
        color: ThemeConstants.darkText,
      ),
    ),
    
    // البطاقات
    cardTheme: CardThemeData(
      color: ThemeConstants.darkCard,
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spaceSm,
        vertical: ThemeConstants.spaceSm / 2,
      ),
    ),
    
    // الأزرار المرفوعة
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeConstants.primaryLight,
        foregroundColor: Colors.black,
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        elevation: 4,
        shadowColor: ThemeConstants.primaryLight.withValues(alpha: 0.3),
        textStyle: AppTypography.button,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spaceMd,
        ),
      ),
    ),
    
    // الأزرار المحددة
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ThemeConstants.primaryLight,
        side: const BorderSide(color: ThemeConstants.primaryLight, width: 2),
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: AppTypography.button,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spaceMd,
        ),
      ),
    ),
    
    // الأزرار النصية
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ThemeConstants.primaryLight,
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: AppTypography.button,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spaceMd,
        ),
      ),
    ),
    
    // أزرار الأيقونات
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: ThemeConstants.darkText,
        backgroundColor: Colors.transparent,
        minimumSize: const Size(ThemeConstants.buttonHeightSm, ThemeConstants.buttonHeightSm),
        padding: const EdgeInsets.all(ThemeConstants.spaceSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
        ),
      ),
    ),
    
    // حقول النص
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ThemeConstants.darkCard,
      contentPadding: const EdgeInsets.all(ThemeConstants.spaceMd),
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.darkBorder),
      ),
      
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.darkBorder),
      ),
      
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.primaryLight, width: 2),
      ),
      
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.error),
      ),
      
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(color: ThemeConstants.error, width: 2),
      ),
      
      hintStyle: AppTypography.body.copyWith(
        color: ThemeConstants.darkTextHint,
      ),
      
      labelStyle: AppTypography.body.copyWith(
        color: ThemeConstants.darkTextSecondary,
      ),
      
      errorStyle: AppTypography.caption.copyWith(
        color: ThemeConstants.error,
      ),
    ),
    
    // الـ FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeConstants.primaryLight,
      foregroundColor: Colors.black,
      elevation: 6,
      focusElevation: 8,
      hoverElevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.radiusLg)),
      ),
    ),
    
    // التنقل السفلي
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ThemeConstants.darkSurface,
      selectedItemColor: ThemeConstants.primaryLight,
      unselectedItemColor: ThemeConstants.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontWeight: ThemeConstants.fontSemiBold,
        fontSize: ThemeConstants.fontSizeXs,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: ThemeConstants.fontRegular,
        fontSize: ThemeConstants.fontSizeXs,
      ),
    ),
    
    // الحوارات
    dialogTheme: DialogThemeData(
      backgroundColor: ThemeConstants.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      elevation: 12,
      titleTextStyle: AppTypography.title.copyWith(
        color: ThemeConstants.darkText,
      ),
      contentTextStyle: AppTypography.body.copyWith(
        color: ThemeConstants.darkText,
      ),
    ),
    
    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ThemeConstants.darkText,
      contentTextStyle: AppTypography.body.copyWith(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      actionTextColor: ThemeConstants.primaryLight,
    ),
    
    // الأيقونات
    iconTheme: const IconThemeData(
      color: ThemeConstants.darkTextSecondary,
      size: ThemeConstants.iconMd,
    ),
    
    // المفاتيح
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primaryLight;
        }
        if (states.contains(WidgetState.disabled)) {
          return ThemeConstants.darkTextHint;
        }
        return ThemeConstants.darkCard;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primaryLight.withValues(alpha: 0.3);
        }
        if (states.contains(WidgetState.disabled)) {
          return ThemeConstants.darkBorder;
        }
        return ThemeConstants.darkBorder;
      }),
    ),
    
    // مربعات الاختيار
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      ),
    ),
    
    // أزرار الراديو
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primaryLight;
        }
        return ThemeConstants.darkTextSecondary;
      }),
    ),
    
    // الفواصل
    dividerTheme: const DividerThemeData(
      color: ThemeConstants.darkBorder,
      thickness: 1,
      space: 1,
    ),
    
    // القوائم
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spaceMd,
        vertical: ThemeConstants.spaceSm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      tileColor: Colors.transparent,
      selectedTileColor: ThemeConstants.primaryLight.withValues(alpha: 0.1),
      iconColor: ThemeConstants.darkTextSecondary,
      textColor: ThemeConstants.darkText,
    ),
    
    // شرائح التمرير
    sliderTheme: SliderThemeData(
      activeTrackColor: ThemeConstants.primaryLight,
      inactiveTrackColor: ThemeConstants.darkBorder,
      thumbColor: ThemeConstants.primaryLight,
      overlayColor: ThemeConstants.primaryLight.withValues(alpha: 0.2),
      valueIndicatorColor: ThemeConstants.primaryLight,
      valueIndicatorTextStyle: AppTypography.caption.copyWith(
        color: Colors.black,
      ),
    ),
    
    // شريط التقدم
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: ThemeConstants.primaryLight,
      linearTrackColor: ThemeConstants.darkBorder,
      circularTrackColor: ThemeConstants.darkBorder,
    ),
    
    // شرائح البحث
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStateProperty.all(ThemeConstants.darkCard),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      side: WidgetStateProperty.all(
        const BorderSide(color: ThemeConstants.darkBorder),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
      textStyle: WidgetStateProperty.all(AppTypography.body),
      hintStyle: WidgetStateProperty.all(
        AppTypography.body.copyWith(color: ThemeConstants.darkTextHint),
      ),
    ),
  );
  
  // ==================== دوال مساعدة ====================
  
  /// الحصول على الثيم الحالي
  static ThemeData getCurrentTheme(BuildContext context) {
    return Theme.of(context);
  }
  
  /// فحص إذا كان الثيم الداكن نشط
  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
  
  /// الحصول على اللون الأساسي للثيم الحالي
  static Color getPrimaryColor(BuildContext context) {
    return isDarkTheme(context) 
        ? ThemeConstants.primaryLight 
        : ThemeConstants.primary;
  }
  
  /// الحصول على لون النص الأساسي للثيم الحالي
  static Color getTextColor(BuildContext context) {
    return isDarkTheme(context) 
        ? ThemeConstants.darkText 
        : ThemeConstants.lightText;
  }
  
  /// الحصول على لون الخلفية للثيم الحالي
  static Color getBackgroundColor(BuildContext context) {
    return isDarkTheme(context) 
        ? ThemeConstants.darkBackground 
        : ThemeConstants.lightBackground;
  }
  
  /// الحصول على لون السطح للثيم الحالي
  static Color getSurfaceColor(BuildContext context) {
    return isDarkTheme(context) 
        ? ThemeConstants.darkSurface 
        : ThemeConstants.lightSurface;
  }
}