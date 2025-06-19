// lib/app/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_constants.dart';
import 'text_styles.dart' as app_text_styles;
import 'core/theme_extensions.dart';

// ===== التصديرات الموحدة =====
export 'theme_constants.dart';
// تم حذف export 'text_styles.dart' لحل التضارب
export 'core/theme_extensions.dart';

// Widgets exports
export 'widgets/cards/app_card.dart';
export 'widgets/dialogs/app_info_dialog.dart';
export 'widgets/feedback/app_snackbar.dart';
export 'widgets/feedback/app_notice_card.dart';
export 'widgets/layout/app_bar.dart';
export 'widgets/states/app_empty_state.dart';
export 'widgets/core/app_button.dart';
export 'widgets/core/app_text_field.dart';
export 'widgets/core/app_loading.dart';

// Animation exports
export 'widgets/animations/animated_press.dart';
export 'package:flutter_staggered_animations/flutter_staggered_animations.dart'
    show
        AnimationConfiguration,
        AnimationLimiter,
        FadeInAnimation,
        SlideAnimation,
        ScaleAnimation,
        FlipAnimation;

/// نظام الثيم الموحد والمحسن للتطبيق
class AppTheme {
  AppTheme._();

  // ===== الثيمات الرئيسية =====
  
  /// الثيم الفاتح المحسن
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    colorConfig: _LightColorConfig(),
  );

  /// الثيم الداكن المحسن
  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    colorConfig: _DarkColorConfig(),
  );

  // ===== بناء الثيم الموحد =====
  static ThemeData _buildTheme({
    required Brightness brightness,
    required _ColorConfig colorConfig,
  }) {
    final isDark = brightness == Brightness.dark;
    
    // إنشاء ColorScheme محسن
    final colorScheme = _createColorScheme(brightness, colorConfig);
    
    // إنشاء TextTheme
    final textTheme = app_text_styles.AppTextStyles.createTextTheme(
      color: colorConfig.textPrimary,
      secondaryColor: colorConfig.textSecondary,
    );

    return ThemeData(
      // الإعدادات الأساسية
      brightness: brightness,
      useMaterial3: true,
      fontFamily: ThemeConstants.fontFamily,
      
      // نظام الألوان
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorConfig.background,
      
      // نظام النصوص
      textTheme: textTheme,
      
      // مكونات الواجهة
      appBarTheme: _createAppBarTheme(colorConfig, isDark),
      cardTheme: _createCardTheme(colorConfig),
      elevatedButtonTheme: _createElevatedButtonTheme(colorConfig),
      outlinedButtonTheme: _createOutlinedButtonTheme(colorConfig),
      textButtonTheme: _createTextButtonTheme(colorConfig),
      inputDecorationTheme: _createInputDecorationTheme(colorConfig, isDark),
      dividerTheme: _createDividerTheme(colorConfig),
      iconTheme: _createIconTheme(colorConfig),
      progressIndicatorTheme: _createProgressIndicatorTheme(colorConfig),
      bottomNavigationBarTheme: _createBottomNavigationBarTheme(colorConfig),
      chipTheme: _createChipTheme(colorConfig, brightness),
      tabBarTheme: _createTabBarTheme(colorConfig),
      floatingActionButtonTheme: _createFABTheme(colorConfig),
      dialogTheme: _createDialogTheme(colorConfig),
      switchTheme: _createSwitchTheme(colorConfig, isDark),
      checkboxTheme: _createCheckboxTheme(colorConfig, isDark),
      radioTheme: _createRadioTheme(colorConfig),
      sliderTheme: _createSliderTheme(colorConfig),
      tooltipTheme: _createTooltipTheme(colorConfig, isDark),
      
      // تحسينات الأداء والتفاعل
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // الخصائص المحسنة
      visualDensity: VisualDensity.adaptivePlatformDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  // ===== إنشاء ColorScheme =====
  static ColorScheme _createColorScheme(Brightness brightness, _ColorConfig config) {
    return ColorScheme(
      brightness: brightness,
      primary: ThemeConstants.primary,
      onPrimary: ThemeConstants.primary.contrastingTextColor,
      secondary: ThemeConstants.accent,
      onSecondary: ThemeConstants.accent.contrastingTextColor,
      tertiary: ThemeConstants.tertiary,
      onTertiary: ThemeConstants.tertiary.contrastingTextColor,
      error: ThemeConstants.error,
      onError: Colors.white,
      surface: config.background,
      onSurface: config.textPrimary,
      surfaceContainerHighest: config.card,
      onSurfaceVariant: config.textSecondary,
      outline: config.divider,
      inverseSurface: config.textPrimary,
      onInverseSurface: config.background,
    );
  }

  // ===== مكونات الثيم المحسنة =====
  
  static AppBarTheme _createAppBarTheme(_ColorConfig config, bool isDark) {
    return AppBarTheme(
      backgroundColor: config.background,
      foregroundColor: config.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: app_text_styles.AppTextStyles.h4.copyWith(color: config.textPrimary),
      iconTheme: IconThemeData(
        color: config.textPrimary,
        size: ThemeConstants.iconMd,
      ),
      actionsIconTheme: IconThemeData(
        color: config.textPrimary,
        size: ThemeConstants.iconMd,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: config.background,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  static CardThemeData _createCardTheme(_ColorConfig config) {
    return CardThemeData(
      color: config.card,
      elevation: ThemeConstants.elevationNone,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      shadowColor: ThemeConstants.primary.withValues(alpha: 0.1),
    );
  }

  static ElevatedButtonThemeData _createElevatedButtonTheme(_ColorConfig config) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeConstants.primary,
        foregroundColor: ThemeConstants.primary.contrastingTextColor,
        disabledBackgroundColor: config.textSecondary.withValues(alpha: 0.3),
        disabledForegroundColor: config.textSecondary.withValues(alpha: 0.7),
        elevation: 0,
        shadowColor: ThemeConstants.primary.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space6,
          vertical: ThemeConstants.space4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: app_text_styles.AppTextStyles.button,
        minimumSize: const Size(ThemeConstants.heightLg, ThemeConstants.buttonHeight),
      ),
    );
  }

  static OutlinedButtonThemeData _createOutlinedButtonTheme(_ColorConfig config) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ThemeConstants.primary,
        side: BorderSide(
          color: ThemeConstants.primary,
          width: ThemeConstants.borderMedium,
        ),
        disabledForegroundColor: config.textSecondary.withValues(alpha: 0.7),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space6,
          vertical: ThemeConstants.space4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: app_text_styles.AppTextStyles.button,
        minimumSize: const Size(ThemeConstants.heightLg, ThemeConstants.buttonHeight),
      ),
    );
  }

  static TextButtonThemeData _createTextButtonTheme(_ColorConfig config) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ThemeConstants.primary,
        disabledForegroundColor: config.textSecondary.withValues(alpha: 0.7),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: app_text_styles.AppTextStyles.button,
      ),
    );
  }

  static InputDecorationTheme _createInputDecorationTheme(_ColorConfig config, bool isDark) {
    return InputDecorationTheme(
      fillColor: config.surface.withValues(
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
          color: config.divider,
          width: ThemeConstants.borderLight,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: BorderSide(
          color: config.divider,
          width: ThemeConstants.borderLight,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: BorderSide(
          color: ThemeConstants.primary,
          width: ThemeConstants.borderThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(
          color: ThemeConstants.error,
          width: ThemeConstants.borderLight,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: const BorderSide(
          color: ThemeConstants.error,
          width: ThemeConstants.borderThick,
        ),
      ),
      hintStyle: app_text_styles.AppTextStyles.body2.copyWith(
        color: config.textSecondary.withValues(alpha: ThemeConstants.opacity70),
      ),
      labelStyle: app_text_styles.AppTextStyles.body2.copyWith(color: config.textSecondary),
      errorStyle: app_text_styles.AppTextStyles.caption.copyWith(color: ThemeConstants.error),
      alignLabelWithHint: true,
    );
  }

  static DividerThemeData _createDividerTheme(_ColorConfig config) {
    return DividerThemeData(
      color: config.divider,
      thickness: ThemeConstants.borderLight,
      space: ThemeConstants.space1,
    );
  }

  static IconThemeData _createIconTheme(_ColorConfig config) {
    return IconThemeData(
      color: config.textPrimary,
      size: ThemeConstants.iconMd,
    );
  }

  static ProgressIndicatorThemeData _createProgressIndicatorTheme(_ColorConfig config) {
    return ProgressIndicatorThemeData(
      color: ThemeConstants.primary,
      linearTrackColor: config.divider.withValues(alpha: ThemeConstants.opacity50),
      circularTrackColor: config.divider.withValues(alpha: ThemeConstants.opacity50),
    );
  }

  static BottomNavigationBarThemeData _createBottomNavigationBarTheme(_ColorConfig config) {
    return BottomNavigationBarThemeData(
      backgroundColor: config.card,
      selectedItemColor: ThemeConstants.primary,
      unselectedItemColor: config.textSecondary.withValues(alpha: ThemeConstants.opacity70),
      type: BottomNavigationBarType.fixed,
      elevation: ThemeConstants.elevation8,
      selectedLabelStyle: app_text_styles.AppTextStyles.label2.copyWith(
        fontWeight: ThemeConstants.semiBold,
      ),
      unselectedLabelStyle: app_text_styles.AppTextStyles.label2,
      selectedIconTheme: const IconThemeData(size: ThemeConstants.iconMd),
      unselectedIconTheme: const IconThemeData(size: ThemeConstants.iconMd),
    );
  }

  static ChipThemeData _createChipTheme(_ColorConfig config, Brightness brightness) {
    return ChipThemeData(
      backgroundColor: config.surface,
      deleteIconColor: config.textSecondary,
      disabledColor: config.textSecondary.withValues(alpha: ThemeConstants.opacity30),
      selectedColor: ThemeConstants.primary,
      secondarySelectedColor: ThemeConstants.accent,
      labelPadding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space2),
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space3,
        vertical: ThemeConstants.space1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
      ),
      labelStyle: app_text_styles.AppTextStyles.label2.copyWith(color: config.textPrimary),
      secondaryLabelStyle: app_text_styles.AppTextStyles.label2.copyWith(
        color: ThemeConstants.primary.contrastingTextColor
      ),
      brightness: brightness,
    );
  }

  static TabBarThemeData _createTabBarTheme(_ColorConfig config) {
    return TabBarThemeData(
      labelColor: ThemeConstants.primary,
      unselectedLabelColor: config.textSecondary.withValues(alpha: ThemeConstants.opacity70),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: ThemeConstants.primary,
          width: ThemeConstants.borderThick,
        ),
      ),
      labelStyle: app_text_styles.AppTextStyles.label1.copyWith(
        fontWeight: ThemeConstants.semiBold,
      ),
      unselectedLabelStyle: app_text_styles.AppTextStyles.label1,
    );
  }

  static FloatingActionButtonThemeData _createFABTheme(_ColorConfig config) {
    return FloatingActionButtonThemeData(
      backgroundColor: ThemeConstants.primary,
      foregroundColor: ThemeConstants.primary.contrastingTextColor,
      elevation: ThemeConstants.elevation4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
    );
  }

  static DialogThemeData _createDialogTheme(_ColorConfig config) {
    return DialogThemeData(
      backgroundColor: config.card,
      titleTextStyle: app_text_styles.AppTextStyles.h5.copyWith(color: config.textPrimary),
      contentTextStyle: app_text_styles.AppTextStyles.body2.copyWith(color: config.textSecondary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      elevation: ThemeConstants.elevation8,
    );
  }

  static SwitchThemeData _createSwitchTheme(_ColorConfig config, bool isDark) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return ThemeConstants.primary;
        if (states.contains(WidgetState.disabled)) return config.surface;
        return isDark ? config.textSecondary : config.textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity50);
        }
        if (states.contains(WidgetState.disabled)) {
          return config.surface.withValues(alpha: ThemeConstants.opacity50);
        }
        return config.textSecondary.withValues(alpha: ThemeConstants.opacity30);
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity10);
        }
        return null;
      }),
    );
  }

  static CheckboxThemeData _createCheckboxTheme(_ColorConfig config, bool isDark) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return ThemeConstants.primary;
        if (states.contains(WidgetState.disabled)) return config.surface;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(ThemeConstants.primary.contrastingTextColor),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            width: ThemeConstants.borderMedium,
            color: config.textSecondary.withValues(alpha: ThemeConstants.opacity50),
          );
        }
        return BorderSide(
          width: ThemeConstants.borderMedium,
          color: ThemeConstants.primary,
        );
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity10);
        }
        return null;
      }),
    );
  }

  static RadioThemeData _createRadioTheme(_ColorConfig config) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return ThemeConstants.primary;
        if (states.contains(WidgetState.disabled)) {
          return config.textSecondary.withValues(alpha: ThemeConstants.opacity50);
        }
        return config.textSecondary;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity10);
        }
        return null;
      }),
    );
  }

  static SliderThemeData _createSliderTheme(_ColorConfig config) {
    return SliderThemeData(
      activeTrackColor: ThemeConstants.primary,
      inactiveTrackColor: ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity30),
      thumbColor: ThemeConstants.primary,
      overlayColor: ThemeConstants.primary.withValues(alpha: ThemeConstants.opacity20),
      valueIndicatorColor: ThemeConstants.primary.darken(0.1),
      valueIndicatorTextStyle: app_text_styles.AppTextStyles.caption.copyWith(
        color: ThemeConstants.primary.contrastingTextColor
      ),
    );
  }

  static TooltipThemeData _createTooltipTheme(_ColorConfig config, bool isDark) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: (isDark ? config.surface : config.surface)
            .withValues(alpha: ThemeConstants.opacity90),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      ),
      textStyle: app_text_styles.AppTextStyles.caption.copyWith(color: config.textPrimary),
      preferBelow: false,
    );
  }
}

// ===== نماذج تكوين الألوان =====

abstract class _ColorConfig {
  Color get background;
  Color get surface;
  Color get card;
  Color get divider;
  Color get textPrimary;
  Color get textSecondary;
}

class _LightColorConfig implements _ColorConfig {
  @override
  Color get background => ThemeConstants.lightBackground;
  
  @override
  Color get surface => ThemeConstants.lightSurface;
  
  @override
  Color get card => ThemeConstants.lightCard;
  
  @override
  Color get divider => ThemeConstants.lightDivider;
  
  @override
  Color get textPrimary => ThemeConstants.lightTextPrimary;
  
  @override
  Color get textSecondary => ThemeConstants.lightTextSecondary;
}

class _DarkColorConfig implements _ColorConfig {
  @override
  Color get background => ThemeConstants.darkBackground;
  
  @override
  Color get surface => ThemeConstants.darkSurface;
  
  @override
  Color get card => ThemeConstants.darkCard;
  
  @override
  Color get divider => ThemeConstants.darkDivider;
  
  @override
  Color get textPrimary => ThemeConstants.darkTextPrimary;
  
  @override
  Color get textSecondary => ThemeConstants.darkTextSecondary;
}