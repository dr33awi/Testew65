// lib/app/themes/app_theme.dart - إصلاح DialogTheme
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ===== استيراد المكونات الأساسية =====
import 'theme_constants.dart';
import 'text_styles.dart';
import 'core/systems/app_color_system.dart';

// ===== تصدير كل شيء للاستخدام الخارجي =====

// الأساسيات - النظام الجديد
export 'theme_constants.dart';
export 'text_styles.dart';
export 'core/theme_notifier.dart';
export 'core/theme_extensions.dart';

// الأنظمة الموحدة
export 'core/systems/app_color_system.dart'; // المصدر الأساسي للألوان
export 'core/systems/app_size_system.dart';
export 'core/systems/app_shadow_system.dart';
export 'core/systems/app_container_builder.dart';
export 'core/systems/glass_effect.dart';

// المكونات الأساسية  
export 'widgets/core/app_button.dart';
export 'widgets/core/app_text_field.dart';
export 'widgets/core/app_loading.dart';

// مكونات التخطيط
export 'widgets/layout/app_bar.dart';

// البطاقات الموحدة
export 'widgets/cards/index.dart';

// الحوارات والنوافذ المنبثقة
export 'widgets/dialogs/app_info_dialog.dart';

// مكونات التغذية الراجعة
export 'widgets/feedback/app_snackbar.dart';
export 'widgets/feedback/app_notice_card.dart';

// مكونات الحالة
export 'widgets/states/app_empty_state.dart';

// الرسوم المتحركة
export 'widgets/animations/animated_press.dart';

// مكتبات الرسوم المتحركة الخارجية
export 'package:flutter_staggered_animations/flutter_staggered_animations.dart'
    show
        AnimationConfiguration,
        AnimationLimiter,
        FadeInAnimation,
        SlideAnimation,
        ScaleAnimation,
        FlipAnimation;

/// نظام الثيم الموحد للتطبيق - يستخدم AppColorSystem
class AppTheme {
  AppTheme._();

  /// الثيم الفاتح - محدث لاستخدام AppColorSystem
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    primaryColor: AppColorSystem.primary,
    backgroundColor: AppColorSystem.lightBackground,
    surfaceColor: AppColorSystem.lightSurface,
    cardColor: AppColorSystem.lightCard,
    textPrimaryColor: AppColorSystem.lightTextPrimary,
    textSecondaryColor: AppColorSystem.lightTextSecondary,
    dividerColor: AppColorSystem.lightDivider,
  );

  /// الثيم الداكن - محدث لاستخدام AppColorSystem
  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    primaryColor: AppColorSystem.primaryLight,
    backgroundColor: AppColorSystem.darkBackground,
    surfaceColor: AppColorSystem.darkSurface,
    cardColor: AppColorSystem.darkCard,
    textPrimaryColor: AppColorSystem.darkTextPrimary,
    textSecondaryColor: AppColorSystem.darkTextSecondary,
    dividerColor: AppColorSystem.darkDivider,
  );

  /// بناء الثيم - محدث لاستخدام AppColorSystem والألوان الجديدة
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color backgroundColor,
    required Color surfaceColor,
    required Color cardColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color dividerColor,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final Color onPrimaryColor = _getContrastingTextColor(primaryColor);
    final Color onSecondaryColor = _getContrastingTextColor(AppColorSystem.accent);

    final textTheme = AppTextStyles.createTextTheme(
      color: textPrimaryColor,
      secondaryColor: textSecondaryColor,
    );

    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      useMaterial3: true,
      fontFamily: ThemeConstants.fontFamily,
      
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: AppColorSystem.accent,
        onSecondary: onSecondaryColor,
        tertiary: AppColorSystem.tertiary,
        onTertiary: _getContrastingTextColor(AppColorSystem.tertiary),
        error: AppColorSystem.error,
        onError: Colors.white,
        surface: backgroundColor,
        onSurface: textPrimaryColor,
        surfaceContainerHighest: cardColor,
        onSurfaceVariant: textSecondaryColor,
        outline: dividerColor,
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h4.copyWith(color: textPrimaryColor),
        iconTheme: IconThemeData(
          color: textPrimaryColor,
          size: ThemeConstants.iconMd,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: backgroundColor,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: ThemeConstants.elevationNone,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
      
      textTheme: textTheme,
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          elevation: ThemeConstants.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space6,
            vertical: ThemeConstants.space4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(ThemeConstants.heightLg, ThemeConstants.buttonHeight),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        fillColor: surfaceColor.withValues(
          alpha: isDark ? ThemeConstants.opacity10 : ThemeConstants.opacity50
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          borderSide: BorderSide(
            color: dividerColor,
            width: ThemeConstants.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          borderSide: BorderSide(
            color: primaryColor,
            width: ThemeConstants.borderThick,
          ),
        ),
      ),
      
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: ThemeConstants.borderLight,
        space: ThemeConstants.space1,
      ),
      
      iconTheme: IconThemeData(
        color: textPrimaryColor,
        size: ThemeConstants.iconMd,
      ),
      
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: dividerColor.withValues(alpha: ThemeConstants.opacity50),
        circularTrackColor: dividerColor.withValues(alpha: ThemeConstants.opacity50),
      ),

      // ===== إضافات جديدة للمكونات =====
      
      // SnackBar Theme - محدث
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColorSystem.darkCard : AppColorSystem.lightCard,
        contentTextStyle: AppTextStyles.body2.copyWith(color: textPrimaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: ThemeConstants.elevation4,
      ),

      // Dialog Theme - تم إصلاح النوع
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
        elevation: ThemeConstants.elevation16,
        titleTextStyle: AppTextStyles.h4.copyWith(color: textPrimaryColor),
        contentTextStyle: AppTextStyles.body1.copyWith(color: textSecondaryColor),
      ),

      // Bottom Sheet Theme - جديد
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ThemeConstants.radiusXl),
            topRight: Radius.circular(ThemeConstants.radiusXl),
          ),
        ),
        elevation: ThemeConstants.elevation16,
      ),

      // FloatingActionButton Theme - محدث
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: ThemeConstants.elevation6,
        focusElevation: ThemeConstants.elevation8,
        hoverElevation: ThemeConstants.elevation8,
        highlightElevation: ThemeConstants.elevation12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.fabSize / 2),
        ),
      ),

      // Navigation Bar Theme - جديد
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        indicatorColor: primaryColor.withValues(alpha: ThemeConstants.opacity20),
        labelTextStyle: WidgetStateProperty.all(
          AppTextStyles.label2.copyWith(color: textSecondaryColor),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primaryColor, size: ThemeConstants.iconMd);
          }
          return IconThemeData(color: textSecondaryColor, size: ThemeConstants.iconMd);
        }),
        height: ThemeConstants.bottomNavHeight,
        elevation: ThemeConstants.elevation4,
      ),

      // Chip Theme - جديد
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: primaryColor.withValues(alpha: ThemeConstants.opacity20),
        disabledColor: dividerColor,
        labelStyle: AppTextStyles.label2.copyWith(color: textPrimaryColor),
        secondaryLabelStyle: AppTextStyles.label2.copyWith(color: textSecondaryColor),
        brightness: brightness,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
      ),
    );
  }

  /// مساعد للحصول على لون النص المتباين
  static Color _getContrastingTextColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  // ===== دوال مساعدة إضافية =====

  /// الحصول على ثيم مخصص بلون أساسي مختلف
  static ThemeData getCustomTheme({
    required Brightness brightness,
    required Color primaryColor,
    Color? accentColor,
    Color? backgroundColor,
  }) {
    final bool isDark = brightness == Brightness.dark;
    
    return _buildTheme(
      brightness: brightness,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor ?? (isDark 
          ? AppColorSystem.darkBackground 
          : AppColorSystem.lightBackground),
      surfaceColor: isDark 
          ? AppColorSystem.darkSurface 
          : AppColorSystem.lightSurface,
      cardColor: isDark 
          ? AppColorSystem.darkCard 
          : AppColorSystem.lightCard,
      textPrimaryColor: isDark 
          ? AppColorSystem.darkTextPrimary 
          : AppColorSystem.lightTextPrimary,
      textSecondaryColor: isDark 
          ? AppColorSystem.darkTextSecondary 
          : AppColorSystem.lightTextSecondary,
      dividerColor: isDark 
          ? AppColorSystem.darkDivider 
          : AppColorSystem.lightDivider,
    );
  }

  /// الحصول على ثيم مع تدرج خلفية
  static ThemeData getGradientTheme({
    required Brightness brightness,
    required LinearGradient backgroundGradient,
  }) {
    final baseTheme = brightness == Brightness.dark ? darkTheme : lightTheme;
    
    return baseTheme.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
    );
  }

  /// التحقق من توافق اللون مع الثيم
  static bool isColorCompatible(Color color, Brightness brightness) {
    final colorBrightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark 
        ? colorBrightness == Brightness.light 
        : colorBrightness == Brightness.dark;
  }

  /// الحصول على لون متوافق مع الثيم
  static Color getCompatibleColor(Color color, Brightness brightness) {
    if (isColorCompatible(color, brightness)) {
      return color;
    }
    
    return brightness == Brightness.dark 
        ? AppColorSystem.primaryLight 
        : AppColorSystem.primary;
  }
}