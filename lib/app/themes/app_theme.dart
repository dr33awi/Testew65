// lib/app/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_constants.dart';
import 'typography.dart';

/// نظام الثيم الموحد للتطبيق الإسلامي
class AppTheme {
  AppTheme._();

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
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeConstants.lightSurface,
      foregroundColor: ThemeConstants.lightText,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: ThemeConstants.lightText,
        fontSize: ThemeConstants.fontSize2xl,
        fontWeight: ThemeConstants.fontSemiBold,
        fontFamily: ThemeConstants.fontPrimary,
      ),
    ),
    
    // البطاقات
    cardTheme: CardThemeData(
      color: ThemeConstants.lightCard,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      margin: const EdgeInsets.all(ThemeConstants.spaceSm),
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
        textStyle: AppTypography.button,
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
      
      hintStyle: AppTypography.body.copyWith(
        color: ThemeConstants.lightTextHint,
      ),
      
      labelStyle: AppTypography.body.copyWith(
        color: ThemeConstants.lightTextSecondary,
      ),
    ),
    
    // الـ FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeConstants.primary,
      foregroundColor: Colors.white,
      elevation: 4,
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
    ),
    
    // الحوارات
    dialogTheme: DialogThemeData(
      backgroundColor: ThemeConstants.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      elevation: 8,
    ),
    
    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ThemeConstants.lightText,
      contentTextStyle: AppTypography.body.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
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
        return ThemeConstants.lightTextHint;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primary.withValues(alpha: 0.3);
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
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeConstants.darkSurface,
      foregroundColor: ThemeConstants.darkText,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        color: ThemeConstants.darkText,
        fontSize: ThemeConstants.fontSize2xl,
        fontWeight: ThemeConstants.fontSemiBold,
        fontFamily: ThemeConstants.fontPrimary,
      ),
    ),
    
    // البطاقات
    cardTheme: CardThemeData(
      color: ThemeConstants.darkCard,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      margin: const EdgeInsets.all(ThemeConstants.spaceSm),
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
        textStyle: AppTypography.button,
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
      
      hintStyle: AppTypography.body.copyWith(
        color: ThemeConstants.darkTextHint,
      ),
      
      labelStyle: AppTypography.body.copyWith(
        color: ThemeConstants.darkTextSecondary,
      ),
    ),
    
    // الـ FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeConstants.primaryLight,
      foregroundColor: Colors.black,
      elevation: 6,
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
    ),
    
    // الحوارات
    dialogTheme: DialogThemeData(
      backgroundColor: ThemeConstants.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      elevation: 12,
    ),
    
    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ThemeConstants.darkText,
      contentTextStyle: AppTypography.body.copyWith(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
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
        return ThemeConstants.darkTextHint;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primaryLight.withValues(alpha: 0.3);
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
    ),
  );
  
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
}