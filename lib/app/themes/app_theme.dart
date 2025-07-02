// lib/app/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_constants.dart';
import 'text_styles.dart';
import 'core/theme_extensions.dart';

// ===== Barrel Exports =====
export 'theme_constants.dart';
export 'text_styles.dart';
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
export 'package:flutter_staggered_animations/flutter_staggered_animations.dart'
    show
        AnimationConfiguration,
        AnimationLimiter,
        FadeInAnimation,
        SlideAnimation,
        ScaleAnimation,
        FlipAnimation;

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
    final Color onPrimaryColor = primaryColor.contrastingTextColor;
    final Color onSecondaryColor = ThemeConstants.accent.contrastingTextColor;

    // Create text theme
    final textTheme = _createTextTheme(textPrimaryColor, textSecondaryColor);

    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      useMaterial3: true,
      fontFamily: ThemeConstants.fontFamily,
      
      // ColorScheme
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        secondary: ThemeConstants.accent,
        onSecondary: onSecondaryColor,
        tertiary: ThemeConstants.accentLight,
        onTertiary: ThemeConstants.accentLight.contrastingTextColor,
        error: ThemeConstants.error,
        onError: Colors.white,
        surface: backgroundColor,
        onSurface: textPrimaryColor,
        surfaceContainerHighest: cardColor,
        onSurfaceVariant: textSecondaryColor,
        outline: dividerColor,
      ),
      
      // AppBar Theme
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
      
      // Card Theme
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: ThemeConstants.elevationNone,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
      
      // Text Theme
      textTheme: textTheme,
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _elevatedButtonStyle(primaryColor, onPrimaryColor),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _outlinedButtonStyle(primaryColor),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: _textButtonStyle(primaryColor),
      ),
      
      // Input Theme
      inputDecorationTheme: _inputDecorationTheme(
        isDark: isDark,
        primaryColor: primaryColor,
        surfaceColor: surfaceColor,
        dividerColor: dividerColor,
        textSecondaryColor: textSecondaryColor,
      ),
      
      // Other Themes
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
      
      // Page Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor.withValues(alpha: ThemeConstants.opacity70),
        type: BottomNavigationBarType.fixed,
        elevation: ThemeConstants.elevation8,
        selectedLabelStyle: AppTextStyles.label2.copyWith(
          fontWeight: ThemeConstants.semiBold,
        ),
        unselectedLabelStyle: AppTextStyles.label2,
        selectedIconTheme: const IconThemeData(size: ThemeConstants.iconMd),
        unselectedIconTheme: const IconThemeData(size: ThemeConstants.iconMd),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        deleteIconColor: textSecondaryColor,
        disabledColor: ThemeConstants.lightTextHint.withValues(alpha: ThemeConstants.opacity30),
        selectedColor: primaryColor,
        secondarySelectedColor: ThemeConstants.accent,
        labelPadding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space2),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
        labelStyle: AppTextStyles.label2.copyWith(color: textPrimaryColor),
        secondaryLabelStyle: AppTextStyles.label2.copyWith(color: onPrimaryColor),
        brightness: brightness,
      ),
      
      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondaryColor.withValues(alpha: ThemeConstants.opacity70),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: primaryColor,
            width: ThemeConstants.borderThick,
          ),
        ),
        labelStyle: AppTextStyles.label1.copyWith(
          fontWeight: ThemeConstants.semiBold,
        ),
        unselectedLabelStyle: AppTextStyles.label1,
      ),
      
      // FAB Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: ThemeConstants.elevation4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        titleTextStyle: AppTextStyles.h5.copyWith(color: textPrimaryColor),
        contentTextStyle: AppTextStyles.body2.copyWith(color: textSecondaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        elevation: ThemeConstants.elevation8,
      ),
      
      // Switch Theme
      switchTheme: _switchTheme(isDark, primaryColor),
      
      // Checkbox Theme
      checkboxTheme: _checkboxTheme(isDark, primaryColor, onPrimaryColor),
      
      // Radio Theme
      radioTheme: _radioTheme(primaryColor, textSecondaryColor),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withValues(alpha: ThemeConstants.opacity30),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withValues(alpha: ThemeConstants.opacity20),
        valueIndicatorColor: primaryColor.darken(0.1),
        valueIndicatorTextStyle: AppTextStyles.caption.copyWith(color: onPrimaryColor),
      ),
      
      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: (isDark ? ThemeConstants.darkSurface : ThemeConstants.lightSurface)
              .withValues(alpha: ThemeConstants.opacity90),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
        ),
        textStyle: AppTextStyles.caption.copyWith(color: textPrimaryColor),
        preferBelow: false,
      ),
    );
  }

  // ===== Private Helper Methods =====
  
  static TextTheme _createTextTheme(Color primaryColor, Color secondaryColor) {
    // Using a map to reduce repetition
    final styles = {
      'displayLarge': AppTextStyles.h1,
      'displayMedium': AppTextStyles.h2,
      'displaySmall': AppTextStyles.h3,
      'headlineLarge': AppTextStyles.h1,
      'headlineMedium': AppTextStyles.h2,
      'headlineSmall': AppTextStyles.h3,
      'titleLarge': AppTextStyles.h4,
      'titleMedium': AppTextStyles.h5,
      'titleSmall': AppTextStyles.h5.copyWith(fontSize: ThemeConstants.textSizeMd),
      'bodyLarge': AppTextStyles.body1,
      'bodyMedium': AppTextStyles.body2,
      'bodySmall': AppTextStyles.caption,
      'labelLarge': AppTextStyles.label1,
      'labelMedium': AppTextStyles.label2,
      'labelSmall': AppTextStyles.caption,
    };
    
    return TextTheme(
      displayLarge: styles['displayLarge']!.copyWith(color: primaryColor),
      displayMedium: styles['displayMedium']!.copyWith(color: primaryColor),
      displaySmall: styles['displaySmall']!.copyWith(color: primaryColor),
      headlineLarge: styles['headlineLarge']!.copyWith(color: primaryColor),
      headlineMedium: styles['headlineMedium']!.copyWith(color: primaryColor),
      headlineSmall: styles['headlineSmall']!.copyWith(color: primaryColor),
      titleLarge: styles['titleLarge']!.copyWith(color: primaryColor),
      titleMedium: styles['titleMedium']!.copyWith(color: primaryColor),
      titleSmall: styles['titleSmall']!.copyWith(color: primaryColor),
      bodyLarge: styles['bodyLarge']!.copyWith(color: primaryColor),
      bodyMedium: styles['bodyMedium']!.copyWith(color: secondaryColor),
      bodySmall: styles['bodySmall']!.copyWith(color: secondaryColor),
      labelLarge: styles['labelLarge']!.copyWith(color: primaryColor),
      labelMedium: styles['labelMedium']!.copyWith(color: secondaryColor),
      labelSmall: styles['labelSmall']!.copyWith(color: secondaryColor),
    );
  }

  // ===== Button Styles =====
  
  static ButtonStyle _elevatedButtonStyle(Color primaryColor, Color onPrimaryColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
      disabledBackgroundColor: ThemeConstants.lightTextHint.withValues(alpha: ThemeConstants.opacity30),
      disabledForegroundColor: ThemeConstants.lightTextHint.withValues(alpha: ThemeConstants.opacity70),
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
    );
  }

  static ButtonStyle _outlinedButtonStyle(Color primaryColor) {
    return OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: BorderSide(
        color: primaryColor,
        width: ThemeConstants.borderMedium,
      ),
      disabledForegroundColor: ThemeConstants.lightTextHint.withValues(alpha: ThemeConstants.opacity70),
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space6,
        vertical: ThemeConstants.space4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      textStyle: AppTextStyles.button,
      minimumSize: const Size(ThemeConstants.heightLg, ThemeConstants.buttonHeight),
    );
  }

  static ButtonStyle _textButtonStyle(Color primaryColor) {
    return TextButton.styleFrom(
      foregroundColor: primaryColor,
      disabledForegroundColor: ThemeConstants.lightTextHint.withValues(alpha: ThemeConstants.opacity70),
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      textStyle: AppTextStyles.button,
    );
  }

  // ===== Input Decoration Theme =====
  
  static InputDecorationTheme _inputDecorationTheme({
    required bool isDark,
    required Color primaryColor,
    required Color surfaceColor,
    required Color dividerColor,
    required Color textSecondaryColor,
  }) {
    return InputDecorationTheme(
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
      enabledBorder: OutlineInputBorder(
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
      hintStyle: AppTextStyles.body2.copyWith(
        color: textSecondaryColor.withValues(alpha: ThemeConstants.opacity70),
      ),
      labelStyle: AppTextStyles.body2.copyWith(color: textSecondaryColor),
      errorStyle: AppTextStyles.caption.copyWith(color: ThemeConstants.error),
      alignLabelWithHint: true,
    );
  }

  // ===== Switch Theme =====
  
  static SwitchThemeData _switchTheme(bool isDark, Color primaryColor) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryColor;
        if (states.contains(WidgetState.disabled)) {
          return isDark ? ThemeConstants.darkSurface : ThemeConstants.lightSurface;
        }
        return isDark ? ThemeConstants.darkTextSecondary : ThemeConstants.lightTextHint;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor.withValues(alpha: ThemeConstants.opacity50);
        }
        if (states.contains(WidgetState.disabled)) {
          return (isDark ? ThemeConstants.darkSurface : ThemeConstants.lightSurface)
              .withValues(alpha: ThemeConstants.opacity50);
        }
        return (isDark ? ThemeConstants.darkTextSecondary : ThemeConstants.lightTextHint)
            .withValues(alpha: ThemeConstants.opacity30);
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return primaryColor.withValues(alpha: ThemeConstants.opacity10);
        }
        return null;
      }),
    );
  }

  // ===== Checkbox Theme =====
  
  static CheckboxThemeData _checkboxTheme(
    bool isDark,
    Color primaryColor,
    Color onPrimaryColor,
  ) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryColor;
        if (states.contains(WidgetState.disabled)) {
          return isDark ? ThemeConstants.darkSurface : ThemeConstants.lightSurface;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryColor),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            width: ThemeConstants.borderMedium,
            color: (isDark ? ThemeConstants.darkTextSecondary : ThemeConstants.lightTextHint)
                .withValues(alpha: ThemeConstants.opacity50),
          );
        }
        return BorderSide(
          width: ThemeConstants.borderMedium,
          color: primaryColor,
        );
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return primaryColor.withValues(alpha: ThemeConstants.opacity10);
        }
        return null;
      }),
    );
  }

  // ===== Radio Theme =====
  
  static RadioThemeData _radioTheme(Color primaryColor, Color textSecondaryColor) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryColor;
        if (states.contains(WidgetState.disabled)) {
          return textSecondaryColor.withValues(alpha: ThemeConstants.opacity50);
        }
        return textSecondaryColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
          return primaryColor.withValues(alpha: ThemeConstants.opacity10);
        }
        return null;
      }),
    );
  }
}