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
        surfaceVariant: AppTheme.lightCard,
        shadow: Colors.black.withOpacity(0.1),
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
        shape: const RoundedRectangleBorder(
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
        margin: const EdgeInsets.all(AppTheme.space2),
        shadowColor: Colors.black.withOpacity(0.1),
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
          textStyle: AppTheme.labelLarge.copyWith(
            fontWeight: AppTheme.semiBold,
          ),
          shadowColor: AppTheme.primary.withOpacity(0.3),
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
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
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
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          borderSide: BorderSide(
            color: AppTheme.lightDivider.withOpacity(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          borderSide: BorderSide(
            color: AppTheme.lightDivider.withOpacity(0.5),
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
        hintStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.lightTextSecondary,
        ),
        labelStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.lightTextSecondary,
        ),
      ),

      // مفاتيح التبديل
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primary;
          }
          return AppTheme.lightTextSecondary.withOpacity(0.5);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.primary.withOpacity(0.3);
          }
          return AppTheme.lightDivider;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppTheme.primary.withOpacity(0.1);
          }
          return null;
        }),
      ),

      // أشرطة التمرير
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          AppTheme.lightTextSecondary.withOpacity(0.3),
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
        titleTextStyle: AppTheme.headlineSmall.copyWith(
          color: AppTheme.lightTextPrimary,
          fontWeight: AppTheme.bold,
        ),
        contentTextStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.lightTextSecondary,
        ),
        insetPadding: const EdgeInsets.all(AppTheme.space6),
      ),

      // أشرطة الإشعارات
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTheme.lightTextPrimary,
        contentTextStyle: AppTheme.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppTheme.elevation3,
        actionTextColor: AppTheme.primary,
        insetPadding: const EdgeInsets.all(AppTheme.space4),
        margin: const EdgeInsets.all(AppTheme.space4),
      ),

      // الفواصل
      dividerTheme: DividerThemeData(
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
          borderSide: BorderSide(
            color: AppTheme.primary,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        labelStyle: AppTheme.labelLarge.copyWith(
          fontWeight: AppTheme.semiBold,
        ),
        unselectedLabelStyle: AppTheme.labelLarge,
        overlayColor: WidgetStateProperty.all(
          AppTheme.primary.withOpacity(0.1),
        ),
      ),

      // شرائط التقدم
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppTheme.primary,
        linearTrackColor: AppTheme.lightDivider,
        circularTrackColor: AppTheme.lightDivider,
        refreshBackgroundColor: AppTheme.lightCard,
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
          AppTheme.primary.withOpacity(0.1),
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
          AppTheme.primary.withOpacity(0.1),
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
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        tileColor: Colors.transparent,
        selectedTileColor: AppTheme.primary.withOpacity(0.1),
      ),

      // الشرائح السفلية
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppTheme.lightCard,
        elevation: AppTheme.elevation4,
        shape: const RoundedRectangleBorder(
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
        selectedIconTheme: const IconThemeData(
          color: AppTheme.primary,
          size: AppTheme.iconMd,
        ),
        unselectedIconTheme: const IconThemeData(
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

      // التحديد
      selectionTheme: SelectionThemeData(
        cursorColor: AppTheme.primary,
        selectionColor: AppTheme.primary.withOpacity(0.3),
        selectionHandleColor: AppTheme.primary,
      ),

      // أشرطة التحديد
      sliderTheme: SliderThemeData(
        activeTrackColor: AppTheme.primary,
        inactiveTrackColor: AppTheme.lightDivider,
        thumbColor: AppTheme.primary,
        overlayColor: AppTheme.primary.withOpacity(0.1),
        valueIndicatorColor: AppTheme.primary,
        valueIndicatorTextStyle: AppTheme.bodySmall.copyWith(
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
            return AppTheme.labelSmall.copyWith(
              color: AppTheme.primary,
              fontWeight: AppTheme.semiBold,
            );
          }
          return AppTheme.labelSmall.copyWith(
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
        indicatorColor: AppTheme.primary.withOpacity(0.1),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
      ),

      // شرائط التطبيق العلوية
      topAppBarTheme: AppBarTheme(
        backgroundColor: AppTheme.lightBackground,
        foregroundColor: AppTheme.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: AppTheme.elevation1,
        shadowColor: Colors.black.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
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
        surfaceVariant: AppTheme.darkCard,
        shadow: Colors.black.withOpacity(0.3),
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
        shadowColor: Colors.black.withOpacity(0.3),
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
        selectedTileColor: AppTheme.primaryLight.withOpacity(0.1),
      ),

      bottomSheetTheme: lightTheme.bottomSheetTheme?.copyWith(
        backgroundColor: AppTheme.darkCard,
        modalBackgroundColor: AppTheme.darkCard,
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
        selectedIconTheme: const IconThemeData(
          color: AppTheme.primaryLight,
          size: AppTheme.iconMd,
        ),
      ),

      navigationBarTheme: lightTheme.navigationBarTheme?.copyWith(
        backgroundColor: AppTheme.darkCard,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTheme.labelSmall.copyWith(
              color: AppTheme.primaryLight,
              fontWeight: AppTheme.semiBold,
            );
          }
          return AppTheme.labelSmall.copyWith(
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
        indicatorColor: AppTheme.primaryLight.withOpacity(0.1),
      ),

      scrollbarTheme: lightTheme.scrollbarTheme?.copyWith(
        thumbColor: WidgetStateProperty.all(
          AppTheme.darkTextSecondary.withOpacity(0.3),
        ),
      ),

      topAppBarTheme: lightTheme.topAppBarTheme?.copyWith(
        backgroundColor: AppTheme.darkBackground,
        foregroundColor: AppTheme.darkTextPrimary,
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
      displayLarge: AppTheme.displayLarge.copyWith(color: baseColor),
      displayMedium: AppTheme.displayLarge.copyWith(
        color: baseColor,
        fontSize: AppTheme.textSize4xl,
      ),
      displaySmall: AppTheme.displaySmall.copyWith(color: baseColor),
      
      // Headline styles
      headlineLarge: AppTheme.headlineLarge.copyWith(color: baseColor),
      headlineMedium: AppTheme.headlineMedium.copyWith(color: baseColor),
      headlineSmall: AppTheme.headlineSmall.copyWith(color: baseColor),
      
      // Title styles
      titleLarge: AppTheme.titleLarge.copyWith(color: baseColor),
      titleMedium: AppTheme.titleMedium.copyWith(color: baseColor),
      titleSmall: AppTheme.titleSmall.copyWith(color: baseColor),
      
      // Body styles
      bodyLarge: AppTheme.bodyLarge.copyWith(color: baseColor),
      bodyMedium: AppTheme.bodyMedium.copyWith(color: baseColor),
      bodySmall: AppTheme.bodySmall.copyWith(color: secondaryColor),
      
      // Label styles
      labelLarge: AppTheme.labelLarge.copyWith(color: baseColor),
      labelMedium: AppTheme.labelMedium.copyWith(color: secondaryColor),
      labelSmall: AppTheme.labelSmall.copyWith(color: secondaryColor),
    );
  }
}