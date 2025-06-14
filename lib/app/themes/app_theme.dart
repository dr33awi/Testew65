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

/// نظام الثيم الموحد للتطبيق - بسيط وأنيق
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
    final Color onPrimaryColor = ThemeConstants.neutral0;
    
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
        secondary: primaryColor,
        onSecondary: onPrimaryColor,
        tertiary: ThemeConstants.info,
        onTertiary: onPrimaryColor,
        error: ThemeConstants.error,
        onError: onPrimaryColor,
        surface: surfaceColor,
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
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        shadowColor: Colors.black.withOpacity(0.05),
      ),
      
      // Text Theme
      textTheme: AppTextStyles.createTextTheme(
        color: textPrimaryColor,
        secondaryColor: textSecondaryColor,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space6,
            vertical: ThemeConstants.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(0, ThemeConstants.buttonHeight),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(
            color: primaryColor,
            width: ThemeConstants.borderLight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space6,
            vertical: ThemeConstants.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(0, ThemeConstants.buttonHeight),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
            vertical: ThemeConstants.space2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      
      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        fillColor: isDark ? ThemeConstants.darkSurface : ThemeConstants.neutral100,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space4,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          borderSide: BorderSide.none,
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
            width: ThemeConstants.borderMedium,
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
            width: ThemeConstants.borderMedium,
          ),
        ),
        hintStyle: AppTextStyles.body2.copyWith(
          color: textSecondaryColor.withOpacity(ThemeConstants.opacity70),
        ),
        labelStyle: AppTextStyles.body2.copyWith(color: textSecondaryColor),
        errorStyle: AppTextStyles.caption.copyWith(color: ThemeConstants.error),
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
        linearTrackColor: dividerColor,
        circularTrackColor: dividerColor,
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTextStyles.label2.copyWith(
          fontWeight: ThemeConstants.semiBold,
        ),
        unselectedLabelStyle: AppTextStyles.label2,
        selectedIconTheme: const IconThemeData(size: ThemeConstants.iconMd),
        unselectedIconTheme: const IconThemeData(size: ThemeConstants.iconMd),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? ThemeConstants.darkSurface : ThemeConstants.neutral100,
        deleteIconColor: textSecondaryColor,
        disabledColor: dividerColor,
        selectedColor: primaryColor.withOpacity(0.2),
        secondarySelectedColor: primaryColor.withOpacity(0.2),
        labelPadding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space2),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        ),
        labelStyle: AppTextStyles.label2.copyWith(color: textPrimaryColor),
        secondaryLabelStyle: AppTextStyles.label2.copyWith(color: primaryColor),
        brightness: brightness,
      ),
      
      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondaryColor,
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
        elevation: ThemeConstants.elevationMd,
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
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
        elevation: ThemeConstants.elevationXl,
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return isDark ? ThemeConstants.neutral600 : ThemeConstants.neutral400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return isDark ? ThemeConstants.darkDivider : ThemeConstants.neutral300;
        }),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          if (states.contains(WidgetState.disabled)) return dividerColor;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(onPrimaryColor),
        side: WidgetStateBorderSide.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              width: ThemeConstants.borderMedium,
              color: dividerColor,
            );
          }
          return BorderSide(
            width: ThemeConstants.borderMedium,
            color: states.contains(WidgetState.selected) ? primaryColor : textSecondaryColor,
          );
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
        ),
      ),
      
      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          if (states.contains(WidgetState.disabled)) return dividerColor;
          return textSecondaryColor;
        }),
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withOpacity(0.3),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.2),
        valueIndicatorColor: primaryColor,
        valueIndicatorTextStyle: AppTextStyles.caption.copyWith(color: onPrimaryColor),
      ),
    );
  }
}