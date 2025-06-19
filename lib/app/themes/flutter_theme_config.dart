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
        surfaceContainerHighest: AppTheme.lightCard,
        error: AppTheme.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppTheme.lightTextPrimary,
        onError: Colors.white,
        outline: AppTheme.lightDivider,
        shadow: Colors.black.withValues(alpha: 0.1),
      ),

      // الخطوط
      fontFamily: AppTheme.fontFamily,
      textTheme: _buildTextTheme(Brightness.light),
      
      // شريط التطبيق
      appBarTheme: const AppBarTheme(
        backgroundColor: AppTheme.lightBackground,
        foregroundColor: AppTheme.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontSize: AppTheme.textSizeLg,
          fontWeight: AppTheme.bold,
          color: AppTheme.lightTextPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppTheme.lightTextPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        color: AppTheme.lightCard,
        elevation: AppTheme.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius2xl),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.1),
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
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          textStyle: const TextStyle(
            fontSize: AppTheme.textSizeMd,
            fontWeight: AppTheme.semiBold,
          ),
          shadowColor: AppTheme.primary.withValues(alpha: 0.3),
        ),
      ),

      // الأزرار المحددة
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primary,
          side: const BorderSide(color: AppTheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          textStyle: const TextStyle(
            fontSize: AppTheme.textSizeMd,
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
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          textStyle: const TextStyle(
            fontSize: AppTheme.textSizeMd,
            fontWeight: AppTheme.semiBold,
          ),
        ),
      ),

      // حقول النص
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTheme.lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          borderSide: BorderSide(
            color: AppTheme.lightDivider.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          borderSide: BorderSide(
            color: AppTheme.lightDivider.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          borderSide: const BorderSide(
            color: AppTheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          borderSide: const BorderSide(
            color: AppTheme.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          borderSide: const BorderSide(
            color: AppTheme.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(AppTheme.space4),
        hintStyle: const TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: AppTheme.lightTextSecondary,
        ),
        labelStyle: const TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: AppTheme.lightTextSecondary,
        ),
      ),

      // مفاتيح التبديل
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primary;
          }
          return AppTheme.lightTextSecondary.withValues(alpha: 0.5);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primary.withValues(alpha: 0.3);
          }
          return AppTheme.lightDivider;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppTheme.primary.withValues(alpha: 0.1);
          }
          return null;
        }),
      ),

      // أشرطة التمرير
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          AppTheme.lightTextSecondary.withValues(alpha: 0.3),
        ),
        radius: const Radius.circular(AppTheme.radiusSm),
        thickness: WidgetStateProperty.all(6.0),
        crossAxisMargin: 4.0,
        mainAxisMargin: 8.0,
      ),

      // الحوارات
      dialogTheme: DialogThemeData(
        backgroundColor: AppTheme.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius2xl),
        ),
        elevation: AppTheme.elevation4,
        titleTextStyle: const TextStyle(
          fontSize: AppTheme.textSizeXl,
          fontWeight: AppTheme.bold,
          color: AppTheme.lightTextPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: AppTheme.lightTextSecondary,
        ),
        insetPadding: const EdgeInsets.all(AppTheme.space6),
      ),

      // أشرطة الإشعارات
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTheme.lightTextPrimary,
        contentTextStyle: const TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppTheme.elevation3,
        actionTextColor: AppTheme.primary,
        insetPadding: const EdgeInsets.all(AppTheme.space4),
      ),

      // الفواصل
      dividerTheme: const DividerThemeData(
        color: AppTheme.lightDivider,
        thickness: 1,
        space: 1,
        indent: 0,
        endIndent: 0,
      ),

      // شرائح التبويب
      tabBarTheme: TabBarThemeData(
        labelColor: AppTheme.primary,
        unselectedLabelColor: AppTheme.lightTextSecondary,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(
            color: AppTheme.primary,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        labelStyle: const TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.semiBold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
        ),
        overlayColor: WidgetStateProperty.all(
          AppTheme.primary.withValues(alpha: 0.1),
        ),
      ),

      // شرائط التقدم
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppTheme.primary,
        linearTrackColor: AppTheme.lightDivider,
        circularTrackColor: AppTheme.lightDivider,
        refreshBackgroundColor: AppTheme.lightCard,
      ),

      // القوائم المنسدلة
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: AppTheme.lightTextPrimary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.lightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          ),
          contentPadding: const EdgeInsets.all(AppTheme.space4),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppTheme.lightCard),
          elevation: WidgetStateProperty.all(AppTheme.elevation3),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            ),
          ),
        ),
      ),

      // أزرار الراديو
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primary;
          }
          return AppTheme.lightTextSecondary;
        }),
        overlayColor: WidgetStateProperty.all(
          AppTheme.primary.withValues(alpha: 0.1),
        ),
      ),

      // مربعات الاختيار
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(
          color: AppTheme.lightTextSecondary,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXs),
        ),
        overlayColor: WidgetStateProperty.all(
          AppTheme.primary.withValues(alpha: 0.1),
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
        titleTextStyle: const TextStyle(
          fontSize: AppTheme.textSizeLg,
          fontWeight: AppTheme.medium,
          color: AppTheme.lightTextPrimary,
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: AppTheme.lightTextSecondary,
        ),
        iconColor: AppTheme.lightTextSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: AppTheme.primary.withValues(alpha: 0.1),
      ),

      // الشرائح السفلية
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppTheme.lightCard,
        elevation: AppTheme.elevation4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radius2xl),
          ),
        ),
        modalBackgroundColor: AppTheme.lightCard,
        modalElevation: AppTheme.elevation5,
      ),

      // الرقائق
      chipTheme: ChipThemeData(
        backgroundColor: AppTheme.lightCard,
        selectedColor: AppTheme.primary.withValues(alpha: 0.1),
        disabledColor: AppTheme.lightDivider,
        deleteIconColor: AppTheme.lightTextSecondary,
        labelStyle: const TextStyle(
          fontSize: AppTheme.textSizeSm,
          fontWeight: AppTheme.regular,
          color: AppTheme.lightTextPrimary,
        ),
        side: BorderSide(
          color: AppTheme.lightDivider.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space3,
          vertical: AppTheme.space2,
        ),
        elevation: 0,
        pressElevation: AppTheme.elevation1,
      ),

      // شرائط التطبيق السفلية
      bottomAppBarTheme: const BottomAppBarTheme(
        color: AppTheme.lightCard,
        elevation: AppTheme.elevation3,
        shape: CircularNotchedRectangle(),
        padding: EdgeInsets.symmetric(horizontal: AppTheme.space2),
      ),

      // شرائط التنقل السفلية
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppTheme.lightCard,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: AppTheme.elevation3,
        selectedLabelStyle: TextStyle(
          fontSize: AppTheme.textSizeXs,
          fontWeight: AppTheme.semiBold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppTheme.textSizeXs,
          fontWeight: AppTheme.regular,
        ),
        selectedIconTheme: IconThemeData(
          color: AppTheme.primary,
          size: AppTheme.iconMd,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppTheme.lightTextSecondary,
          size: AppTheme.iconMd,
        ),
      ),

      // أزرار العمل العائمة
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: AppTheme.elevation3,
        focusElevation: AppTheme.elevation4,
        hoverElevation: AppTheme.elevation4,
        highlightElevation: AppTheme.elevation5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
      ),

      // أشرطة التحديد
      sliderTheme: SliderThemeData(
        activeTrackColor: AppTheme.primary,
        inactiveTrackColor: AppTheme.lightDivider,
        thumbColor: AppTheme.primary,
        overlayColor: AppTheme.primary.withValues(alpha: 0.1),
        valueIndicatorColor: AppTheme.primary,
        valueIndicatorTextStyle: const TextStyle(
          fontSize: AppTheme.textSizeSm,
          fontWeight: AppTheme.regular,
          color: Colors.white,
        ),
      ),

      // قوائم التنقل
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppTheme.lightCard,
        elevation: AppTheme.elevation3,
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: AppTheme.textSizeXs,
              fontWeight: AppTheme.semiBold,
              color: AppTheme.primary,
            );
          }
          return const TextStyle(
            fontSize: AppTheme.textSizeXs,
            fontWeight: AppTheme.regular,
            color: AppTheme.lightTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppTheme.primary,
              size: AppTheme.iconMd,
            );
          }
          return const IconThemeData(
            color: AppTheme.lightTextSecondary,
            size: AppTheme.iconMd,
          );
        }),
        indicatorColor: AppTheme.primary.withValues(alpha: 0.1),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
      ),

      // التمديدات والمساحات
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // الخصائص المضافة حديثاً
      extensions: const <ThemeExtension<dynamic>>[],
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
        surfaceContainerHighest: AppTheme.darkCard,
        error: AppTheme.errorLight,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: AppTheme.darkTextPrimary,
        onError: Colors.black,
        outline: AppTheme.darkDivider,
        shadow: Colors.black.withValues(alpha: 0.3),
      ),

      textTheme: _buildTextTheme(Brightness.dark),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppTheme.darkBackground,
        foregroundColor: AppTheme.darkTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontSize: AppTheme.textSizeLg,
          fontWeight: AppTheme.bold,
          color: AppTheme.darkTextPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppTheme.darkTextPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppTheme.darkCard,
        elevation: AppTheme.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius2xl),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        fillColor: AppTheme.darkCard,
        hintStyle: TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: AppTheme.darkTextSecondary,
        ),
        labelStyle: TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: AppTheme.darkTextSecondary,
        ),
      ),

      dialogTheme: const DialogThemeData(
        backgroundColor: AppTheme.darkCard,
        titleTextStyle: TextStyle(
          fontSize: AppTheme.textSizeXl,
          fontWeight: AppTheme.bold,
          color: AppTheme.darkTextPrimary,
        ),
        contentTextStyle: TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: AppTheme.darkTextSecondary,
        ),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppTheme.darkCard,
        contentTextStyle: TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
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

      listTileTheme: ListTileThemeData(
        titleTextStyle: const TextStyle(
          fontSize: AppTheme.textSizeLg,
          fontWeight: AppTheme.medium,
          color: AppTheme.darkTextPrimary,
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: AppTheme.textSizeMd,
          fontWeight: AppTheme.regular,
          color: AppTheme.darkTextSecondary,
        ),
        iconColor: AppTheme.darkTextSecondary,
        selectedTileColor: AppTheme.primaryLight.withValues(alpha: 0.1),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppTheme.darkCard,
        modalBackgroundColor: AppTheme.darkCard,
      ),

      chipTheme: const ChipThemeData(
        backgroundColor: AppTheme.darkCard,
        labelStyle: TextStyle(
          fontSize: AppTheme.textSizeSm,
          fontWeight: AppTheme.regular,
          color: AppTheme.darkTextPrimary,
        ),
      ),

      bottomAppBarTheme: const BottomAppBarTheme(
        color: AppTheme.darkCard,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppTheme.darkCard,
        unselectedItemColor: AppTheme.darkTextSecondary,
        selectedIconTheme: IconThemeData(
          color: AppTheme.primaryLight,
          size: AppTheme.iconMd,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppTheme.darkCard,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: AppTheme.textSizeXs,
              fontWeight: AppTheme.semiBold,
              color: AppTheme.primaryLight,
            );
          }
          return const TextStyle(
            fontSize: AppTheme.textSizeXs,
            fontWeight: AppTheme.regular,
            color: AppTheme.darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppTheme.primaryLight,
              size: AppTheme.iconMd,
            );
          }
          return const IconThemeData(
            color: AppTheme.darkTextSecondary,
            size: AppTheme.iconMd,
          );
        }),
        indicatorColor: AppTheme.primaryLight.withValues(alpha: 0.1),
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          AppTheme.darkTextSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  /// بناء أنماط النصوص
  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseColor = brightness == Brightness.light 
        ? AppTheme.lightTextPrimary 
        : AppTheme.darkTextPrimary;
    
    final secondaryColor = brightness == Brightness.light 
        ? AppTheme.lightTextSecondary 
        : AppTheme.darkTextSecondary;

    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: AppTheme.textSize5xl,
        fontWeight: AppTheme.bold,
        height: 1.1,
        letterSpacing: -0.5,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontSize: AppTheme.textSize4xl,
        fontWeight: AppTheme.bold,
        height: 1.2,
        color: baseColor,
      ),
      displaySmall: TextStyle(
        fontSize: AppTheme.textSize3xl,
        fontWeight: AppTheme.bold,
        height: 1.2,
        color: baseColor,
      ),
      
      // Headline styles
      headlineLarge: TextStyle(
        fontSize: AppTheme.textSize3xl,
        fontWeight: AppTheme.bold,
        height: 1.2,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontSize: AppTheme.textSize2xl,
        fontWeight: AppTheme.semiBold,
        height: 1.3,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontSize: AppTheme.textSizeXl,
        fontWeight: AppTheme.semiBold,
        height: 1.3,
        color: baseColor,
      ),
      
      // Title styles
      titleLarge: TextStyle(
        fontSize: AppTheme.textSizeLg,
        fontWeight: AppTheme.semiBold,
        height: 1.3,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: AppTheme.textSizeMd,
        fontWeight: AppTheme.medium,
        height: 1.4,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontSize: AppTheme.textSizeSm,
        fontWeight: AppTheme.medium,
        height: 1.4,
        color: baseColor,
      ),
      
      // Body styles
      bodyLarge: TextStyle(
        fontSize: AppTheme.textSizeLg,
        fontWeight: AppTheme.regular,
        height: 1.5,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTheme.textSizeMd,
        fontWeight: AppTheme.regular,
        height: 1.5,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontSize: AppTheme.textSizeSm,
        fontWeight: AppTheme.regular,
        height: 1.4,
        color: secondaryColor,
      ),
      
      // Label styles
      labelLarge: TextStyle(
        fontSize: AppTheme.textSizeMd,
        fontWeight: AppTheme.medium,
        height: 1.3,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontSize: AppTheme.textSizeSm,
        fontWeight: AppTheme.medium,
        height: 1.3,
        color: secondaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: AppTheme.textSizeXs,
        fontWeight: AppTheme.medium,
        height: 1.2,
        color: secondaryColor,
      ),
    );
  }
}