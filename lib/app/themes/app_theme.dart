// TODO Implement this library.// lib/app/themes/simple/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';

/// نظام الثيم المبسط للتطبيق الإسلامي
/// كل ما تحتاجه في مكان واحد - بساطة وفعالية
class AppTheme {
  AppTheme._();

  // ==================== الثابتات ====================
  
  static const double borderRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // ==================== الثيم الفاتح ====================
  
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: AppTypography.primaryFont,
    
    // الألوان
    colorScheme: AppColors.lightColorScheme,
    scaffoldBackgroundColor: AppColors.lightBackground,
    
    // النصوص
    textTheme: AppTypography.createTextTheme(
      AppColors.lightText,
      AppColors.lightTextSecondary,
    ),
    
    // شريط التطبيق
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightText,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: AppColors.lightText,
        fontSize: AppTypography.sizeTitle,
        fontWeight: AppTypography.semiBold,
        fontFamily: AppTypography.primaryFont,
      ),
    ),
    
    // البطاقات
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      margin: const EdgeInsets.all(8),
    ),
    
    // الأزرار المرفوعة
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 2,
        textStyle: AppTypography.button,
      ),
    ),
    
    // الأزرار المحددة
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 2),
        minimumSize: const Size(0, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        textStyle: AppTypography.button,
      ),
    ),
    
    // الأزرار النصية
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        minimumSize: const Size(0, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        textStyle: AppTypography.button,
      ),
    ),
    
    // حقول النص
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightCard,
      contentPadding: const EdgeInsets.all(paddingMedium),
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      
      hintStyle: AppTypography.body.copyWith(
        color: AppColors.lightTextHint,
      ),
      
      labelStyle: AppTypography.body.copyWith(
        color: AppColors.lightTextSecondary,
      ),
    ),
    
    // الـ FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    
    // التنقل السفلي
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // الحوارات
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      elevation: 8,
    ),
    
    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.lightText,
      contentTextStyle: AppTypography.body.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // الأيقونات
    iconTheme: const IconThemeData(
      color: AppColors.lightTextSecondary,
      size: iconSize,
    ),
    
    // المفاتيح
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.lightTextHint;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary.withOpacity(0.3);
        }
        return AppColors.lightBorder;
      }),
    ),
    
    // مربعات الاختيار
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),
    
    // الفواصل
    dividerTheme: const DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 1,
      space: 1,
    ),
    
    // القوائم
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
  
  // ==================== الثيم الداكن ====================
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppTypography.primaryFont,
    
    // الألوان
    colorScheme: AppColors.darkColorScheme,
    scaffoldBackgroundColor: AppColors.darkBackground,
    
    // النصوص
    textTheme: AppTypography.createTextTheme(
      AppColors.darkText,
      AppColors.darkTextSecondary,
    ),
    
    // شريط التطبيق
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        color: AppColors.darkText,
        fontSize: AppTypography.sizeTitle,
        fontWeight: AppTypography.semiBold,
        fontFamily: AppTypography.primaryFont,
      ),
    ),
    
    // البطاقات
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      margin: const EdgeInsets.all(8),
    ),
    
    // الأزرار المرفوعة
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.black,
        minimumSize: const Size(0, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 4,
        textStyle: AppTypography.button,
      ),
    ),
    
    // الأزرار المحددة
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight, width: 2),
        minimumSize: const Size(0, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        textStyle: AppTypography.button,
      ),
    ),
    
    // الأزرار النصية
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        minimumSize: const Size(0, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        textStyle: AppTypography.button,
      ),
    ),
    
    // حقول النص
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkCard,
      contentPadding: const EdgeInsets.all(paddingMedium),
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      
      hintStyle: AppTypography.body.copyWith(
        color: AppColors.darkTextHint,
      ),
      
      labelStyle: AppTypography.body.copyWith(
        color: AppColors.darkTextSecondary,
      ),
    ),
    
    // الـ FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: Colors.black,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    
    // التنقل السفلي
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // الحوارات
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      elevation: 12,
    ),
    
    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkText,
      contentTextStyle: AppTypography.body.copyWith(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // الأيقونات
    iconTheme: const IconThemeData(
      color: AppColors.darkTextSecondary,
      size: iconSize,
    ),
    
    // المفاتيح
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.darkTextHint;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight.withOpacity(0.3);
        }
        return AppColors.darkBorder;
      }),
    ),
    
    // مربعات الاختيار
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.black),
    ),
    
    // الفواصل
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
      space: 1,
    ),
    
    // القوائم
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
  
  // ==================== مدير الثيم ====================
  
  static ValueNotifier<ThemeMode> themeModeNotifier = 
      ValueNotifier(ThemeMode.system);
  
  static void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
    // يمكن إضافة حفظ في SharedPreferences هنا
  }
  
  static void toggleTheme() {
    final currentMode = themeModeNotifier.value;
    final newMode = currentMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    setThemeMode(newMode);
  }
  
  // ==================== التدرجات ====================
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient getPrayerGradient(String prayerName) {
    final color = AppColors.getPrayerColor(prayerName);
    return LinearGradient(
      colors: [color, color.withOpacity(0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

// ==================== Extensions للسهولة ====================

extension BuildContextTheme on BuildContext {
  // الثيم العام
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  // الألوان السريعة
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  Color get cardColor => theme.cardTheme.color!;
  Color get textColor => colorScheme.onSurface;
  Color get secondaryTextColor => isDarkMode 
      ? AppColors.darkTextSecondary 
      : AppColors.lightTextSecondary;
  
  // الأحجام السريعة
  double get smallPadding => AppTheme.paddingSmall;
  double get mediumPadding => AppTheme.paddingMedium;
  double get largePadding => AppTheme.paddingLarge;
  
  double get borderRadius => AppTheme.borderRadius;
  double get cardRadius => AppTheme.cardRadius;
  
  // النصوص الإسلامية
  TextStyle get quranTextStyle => AppTypography.quran.copyWith(
    color: textColor,
  );
  
  TextStyle get hadithTextStyle => AppTypography.hadith.copyWith(
    color: textColor,
  );
  
  TextStyle get duaTextStyle => AppTypography.dua.copyWith(
    color: textColor,
  );
  
  TextStyle get tasbihTextStyle => AppTypography.tasbih.copyWith(
    color: textColor,
  );
  
  // مساعدات سريعة
  void showMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  void showSuccessMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }
  
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}