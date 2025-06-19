// lib/app/themes/flutter_theme_config.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

/// إعداد ثيم Flutter الرسمي ليتوافق مع تصميم التطبيق
class FlutterThemeConfig {
  FlutterThemeConfig._();

  /// ثيم فاتح
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // الألوان الأساسية
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppTheme.primary,
        brightness: Brightness.light,
        primary: AppTheme.primary,
        secondary: AppTheme.accent,
        tertiary: AppTheme.tertiary,
        surface: AppTheme.lightSurface,
        background: AppTheme.lightBackground,
        error: AppTheme.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppTheme.lightTextPrimary,
        onBackground: AppTheme.lightTextPrimary,
        onError: Colors.white,
        outline: AppTheme.lightDivider,
        surfaceVariant: AppTheme.lightCard,
      ),

      // الخطوط
      fontFamily: AppTheme.fontFamily,
      textTheme: _buildTextTheme(Brightness.light),
      
      // شريط التطبيق
      appBarTheme: AppBarTheme(
        backgroundColor: AppTheme.lightBackground,
        foregroundColor: AppTheme.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTheme.titleLarge.copyWith(
          color: AppTheme.lightTextPrimary,
          fontWeight: AppTheme.bold,
        ),
        iconTheme: const IconThemeData(
          color: AppTheme.lightTextPrimary,
        ),
      ),

      // البطاقات
      cardTheme: CardTheme(
        color: AppTheme.lightCard,
        elevation: AppTheme.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius2xl),
        ),
        margin: const EdgeInsets.all(AppTheme.space2),
      ),

      // الأزرار المرفوعة
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          elevation: AppTheme.elevation2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          textStyle: AppTheme.labelLarge.copyWith(
            fontWeight: AppTheme.semiBold,
          ),
        ),
      ),

      // الأزرار المحددة
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primary,
          side: const BorderSide(color: AppTheme.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          textStyle: AppTheme.labelLarge.copyWith(
            fontWeight: AppTheme.semiBold,
          ),
        ),
      ),

      // الأزرار النصية
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          textStyle: AppTheme.labelLarge.copyWith(
            fontWeight: AppTheme.semiBold,
          ),
        ),
      ),

      // حقول النص
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTheme.lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          borderSide: BorderSide(
            color: AppTheme.lightDivider.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          borderSide: BorderSide(
            color: AppTheme.lightDivider.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          borderSide: const BorderSide(
            color: AppTheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          borderSide: const BorderSide(
            color: AppTheme.error,
          ),
        ),
        contentPadding: const EdgeInsets.all(AppTheme.space4),
        hintStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.lightTextSecondary,
        ),
        labelStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.lightTextSecondary,
        ),
      ),

      // مفاتيح التبديل
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTheme.primary;
          }
          return AppTheme.lightTextSecondary.withOpacity(0.5);
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTheme.primary.withOpacity(0.3);
          }
          return AppTheme.lightDivider;
        }),
      ),

      // أشرطة التمرير
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(
          AppTheme.lightTextSecondary.withOpacity(0.3),
        ),
        radius: const Radius.circular(AppTheme.radiusSm),
        thickness: MaterialStateProperty.all(6.0),
      ),

      // الحوارات
      dialogTheme: DialogTheme(
        backgroundColor: AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        elevation: AppTheme.elevation4,
        titleTextStyle: AppTheme.headlineSmall.copyWith(
          color: AppTheme.lightTextPrimary,
          fontWeight: AppTheme.bold,
        ),
        contentTextStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.lightTextSecondary,
        ),
      ),

      // أشرطة الإشعارات
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTheme.lightTextPrimary,
        contentTextStyle: AppTheme.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppTheme.elevation3,
      ),

      // الفواصل
      dividerTheme: const DividerThemeData(
        color: AppTheme.lightDivider,
        thickness: 1,
        space: 1,
      ),

      // شرائح التبويب
      tabBarTheme: TabBarTheme(
        labelColor: AppTheme.primary,
        unselectedLabelColor: AppTheme.lightTextSecondary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppTheme.primary,
            width: 2,
          ),
        ),
        labelStyle: AppTheme.labelLarge.copyWith(
          fontWeight: AppTheme.semiBold,
        ),
        unselectedLabelStyle: AppTheme.labelLarge,
      ),

      // شرائط التقدم
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppTheme.primary,
        linearTrackColor: AppTheme.lightDivider,
        circularTrackColor: AppTheme.lightDivider,
      ),

      // القوائم المنسدلة
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.lightTextPrimary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.lightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      ),

      // أزرار الراديو
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTheme.primary;
          }
          return AppTheme.lightTextSecondary;
        }),
      ),

      // مربعات الاختيار
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppTheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: const BorderSide(
          color: AppTheme.lightTextSecondary,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXs),
        ),
      ),

      // الأيقونات
      iconTheme: const IconThemeData(
        color: AppTheme.lightTextSecondary,
        size: AppTheme.iconMd,
      ),

      // قوائم العناصر
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space4,
          vertical: AppTheme.space2,
        ),
        titleTextStyle: AppTheme.bodyLarge.copyWith(
          color: AppTheme.lightTextPrimary,
          fontWeight: AppTheme.medium,
        ),
        subtitleTextStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.lightTextSecondary,
        ),
        iconColor: AppTheme.lightTextSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
      ),

      // الشرائح السفلية
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppTheme.lightCard,
        elevation: AppTheme.elevation4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusXl),
          ),
        ),
      ),

      // الرقائق
      chipTheme: ChipThemeData(
        backgroundColor: AppTheme.lightCard,
        selectedColor: AppTheme.primary.withOpacity(0.1),
        disabledColor: AppTheme.lightDivider,
        deleteIconColor: AppTheme.lightTextSecondary,
        labelStyle: AppTheme.bodySmall.copyWith(
          color: AppTheme.lightTextPrimary,
        ),
        side: BorderSide(
          color: AppTheme.lightDivider.withOpacity(0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space3,
          vertical: AppTheme.space2,
        ),
      ),

      // شرائط التطبيق السفلية
      bottomAppBarTheme: const BottomAppBarTheme(
        color: AppTheme.lightCard,
        elevation: AppTheme.elevation3,
        shape: CircularNotchedRectangle(),
      ),

      // شرائط التنقل السفلية
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppTheme.lightCard,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: AppTheme.elevation3,
        selectedLabelStyle: AppTheme.labelSmall.copyWith(
          fontWeight: AppTheme.semiBold,
        ),
        unselectedLabelStyle: AppTheme.labelSmall,
      ),

      // أزرار العمل العائمة
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: AppTheme.elevation3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
      ),
    );
  }

  /// ثيم داكن
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppTheme.primary,
        brightness: Brightness.dark,
        primary: AppTheme.primaryLight,
        secondary: AppTheme.accentLight,
        tertiary: AppTheme.tertiaryLight,
        surface: AppTheme.darkSurface,
        background: AppTheme.darkBackground,
        error: AppTheme.errorLight,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: AppTheme.darkTextPrimary,
        onBackground: AppTheme.darkTextPrimary,
        onError: Colors.black,
        outline: AppTheme.darkDivider,
        surfaceVariant: AppTheme.darkCard,
      ),

      textTheme: _buildTextTheme(Brightness.dark),

      appBarTheme: lightTheme.appBarTheme?.copyWith(
        backgroundColor: AppTheme.darkBackground,
        foregroundColor: AppTheme.darkTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTheme.titleLarge.copyWith(
          color: AppTheme.darkTextPrimary,
          fontWeight: AppTheme.bold,
        ),
        iconTheme: const IconThemeData(
          color: AppTheme.darkTextPrimary,
        ),
      ),

      cardTheme: lightTheme.cardTheme?.copyWith(
        color: AppTheme.darkCard,
      ),

      inputDecorationTheme: lightTheme.inputDecorationTheme?.copyWith(
        fillColor: AppTheme.darkCard,
        hintStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.darkTextSecondary,
        ),
        labelStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.darkTextSecondary,
        ),
      ),

      dialogTheme: lightTheme.dialogTheme?.copyWith(
        backgroundColor: AppTheme.darkCard,
        titleTextStyle: AppTheme.headlineSmall.copyWith(
          color: AppTheme.darkTextPrimary,
          fontWeight: AppTheme.bold,
        ),
        contentTextStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.darkTextSecondary,
        ),
      ),

      snackBarTheme: lightTheme.snackBarTheme?.copyWith(
        backgroundColor: AppTheme.darkCard,
        contentTextStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.darkTextPrimary,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppTheme.darkDivider,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: AppTheme.darkTextSecondary,
        size: AppTheme.iconMd,
      ),

      listTileTheme: lightTheme.listTileTheme?.copyWith(
        titleTextStyle: AppTheme.bodyLarge.copyWith(
          color: AppTheme.darkTextPrimary,
          fontWeight: AppTheme.medium,
        ),
        subtitleTextStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.darkTextSecondary,
        ),
        iconColor: AppTheme.darkTextSecondary,
      ),

      bottomSheetTheme: lightTheme.bottomSheetTheme?.copyWith(
        backgroundColor: AppTheme.darkCard,
      ),

      chipTheme: lightTheme.chipTheme?.copyWith(
        backgroundColor: AppTheme.darkCard,
        labelStyle: AppTheme.bodySmall.copyWith(
          color: AppTheme.darkTextPrimary,
        ),
      ),

      bottomAppBarTheme: lightTheme.bottomAppBarTheme?.copyWith(
        color: AppTheme.darkCard,
      ),

      bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme?.copyWith(
        backgroundColor: AppTheme.darkCard,
        unselectedItemColor: AppTheme.darkTextSecondary,
      ),

      scrollbarTheme: lightTheme.scrollbarTheme?.copyWith(
        thumb