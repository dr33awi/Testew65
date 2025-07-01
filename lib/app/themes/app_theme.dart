// lib/app/themes/app_theme.dart - النسخة المبسطة الموحدة (مرجع رئيسي فقط)
// استيراد هذا الملف فقط للحصول على جميع مكونات الثيم

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ===== استيراد المكونات الأساسية =====
import 'theme_constants.dart';
import 'text_styles.dart';

// ===== تصدير كل شيء للاستخدام الخارجي =====

// الأساسيات
export 'theme_constants.dart';
export 'text_styles.dart';
export 'core/theme_notifier.dart';
export 'core/theme_extensions.dart';

// الأنظمة الموحدة
export 'core/systems/app_color_system.dart';
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
export 'widgets/cards/index.dart'; // تصدير موحد لجميع البطاقات

// الحوارات والنوافذ المنبثقة
export 'widgets/dialogs/app_info_dialog.dart';

// مكونات التغذية الراجعة
export 'widgets/feedback/app_snackbar.dart' hide SnackBarExtension;
export 'widgets/feedback/app_notice_card.dart';

// مكونات الحالة
export 'widgets/states/app_empty_state.dart';

// الرسوم المتحركة
export 'widgets/animations/animated_press.dart';

// الأدوات المساعدة
export 'widgets/utils/category_helper.dart';
export 'widgets/utils/quote_helper.dart';

// مكتبات الرسوم المتحركة الخارجية
export 'package:flutter_staggered_animations/flutter_staggered_animations.dart'
    show
        AnimationConfiguration,
        AnimationLimiter,
        FadeInAnimation,
        SlideAnimation,
        ScaleAnimation,
        FlipAnimation;

// ===== نظام الثيم الأساسي =====

/// نظام الثيم الموحد للتطبيق
class AppTheme {
  AppTheme._();

  /// الثيم الفاتح
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    primaryColor: ThemeConstants.primary,
    backgroundColor: ThemeConstants.lightBackground,
    surfaceColor: ThemeConstants.lightSurface,
    cardColor: ThemeConstants.lightCard,
    textPrimaryColor: ThemeConstants.lightTextPrimary,
    textSecondaryColor: ThemeConstants.lightTextSecondary,
    dividerColor: ThemeConstants.lightDivider,
  );

  /// الثيم الداكن
  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    primaryColor: ThemeConstants.primaryLight,
    backgroundColor: ThemeConstants.darkBackground,
    surfaceColor: ThemeConstants.darkSurface,
    cardColor: ThemeConstants.darkCard,
    textPrimaryColor: ThemeConstants.darkTextPrimary,
    textSecondaryColor: ThemeConstants.darkTextSecondary,
    dividerColor: ThemeConstants.darkDivider,
  );

  /// بناء الثيم
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
    final Color onSecondaryColor = _getContrastingTextColor(ThemeConstants.accent);

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
        secondary: ThemeConstants.accent,
        onSecondary: onSecondaryColor,
        tertiary: ThemeConstants.accentLight,
        onTertiary: _getContrastingTextColor(ThemeConstants.accentLight),
        error: ThemeConstants.error,
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
    );
  }

  /// مساعد للحصول على لون النص المتباين
  static Color _getContrastingTextColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }
}