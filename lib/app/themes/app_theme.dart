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
export 'widgets/animations/animated_press.dart';

// Animation exports
export 'package:flutter_staggered_animations/flutter_staggered_animations.dart'
    show
        AnimationConfiguration,
        AnimationLimiter,
        FadeInAnimation,
        SlideAnimation,
        ScaleAnimation,
        FlipAnimation;

/// نظام الثيم الموحد للتطبيق - تصميم عصري 2025
class AppTheme {
  AppTheme._();

  /// الثيم الفاتح
  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    primaryColor: ThemeConstants.primary,
    primaryContainer: ThemeConstants.primaryContainer,
    onPrimaryContainer: ThemeConstants.onPrimaryContainer,
    secondary: ThemeConstants.secondary,
    secondaryContainer: ThemeConstants.secondaryContainer,
    onSecondaryContainer: ThemeConstants.onSecondaryContainer,
    backgroundColor: ThemeConstants.lightBackground,
    surfaceColor: ThemeConstants.lightSurface,
    surfaceVariant: ThemeConstants.lightSurfaceVariant,
    cardColor: ThemeConstants.lightCard,
    textPrimaryColor: ThemeConstants.lightTextPrimary,
    textSecondaryColor: ThemeConstants.lightTextSecondary,
    dividerColor: ThemeConstants.lightDivider,
    outlineColor: ThemeConstants.lightOutline,
  );

  /// الثيم الداكن
  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    primaryColor: ThemeConstants.primaryLight,
    primaryContainer: ThemeConstants.primaryDark,
    onPrimaryContainer: ThemeConstants.primaryLight,
    secondary: ThemeConstants.secondaryLight,
    secondaryContainer: ThemeConstants.secondaryDark,
    onSecondaryContainer: ThemeConstants.secondaryLight,
    backgroundColor: ThemeConstants.darkBackground,
    surfaceColor: ThemeConstants.darkSurface,
    surfaceVariant: ThemeConstants.darkSurfaceVariant,
    cardColor: ThemeConstants.darkCard,
    textPrimaryColor: ThemeConstants.darkTextPrimary,
    textSecondaryColor: ThemeConstants.darkTextSecondary,
    dividerColor: ThemeConstants.darkDivider,
    outlineColor: ThemeConstants.darkOutline,
  );

  /// بناء الثيم
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color primaryContainer,
    required Color onPrimaryContainer,
    required Color secondary,
    required Color secondaryContainer,
    required Color onSecondaryContainer,
    required Color backgroundColor,
    required Color surfaceColor,
    required Color surfaceVariant,
    required Color cardColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color dividerColor,
    required Color outlineColor,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final Color onPrimaryColor = isDark ? ThemeConstants.neutral950 : ThemeConstants.neutral0;
    final Color onSecondaryColor = isDark ? ThemeConstants.neutral950 : ThemeConstants.neutral0;
    
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
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondaryColor,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: ThemeConstants.tertiary,
        onTertiary: ThemeConstants.neutral0,
        tertiaryContainer: ThemeConstants.tertiaryContainer,
        onTertiaryContainer: ThemeConstants.onTertiaryContainer,
        error: ThemeConstants.error,
        onError: ThemeConstants.neutral0,
        errorContainer: ThemeConstants.errorContainer,
        onErrorContainer: ThemeConstants.neutral950,
        surface: surfaceColor,
        onSurface: textPrimaryColor,
        surfaceContainerHighest: cardColor,
        onSurfaceVariant: textSecondaryColor,
        outline: outlineColor,
        outlineVariant: dividerColor,
        shadow: const Color(0x1A000000),
        scrim: const Color(0x4D000000),
        inverseSurface: isDark ? ThemeConstants.neutral100 : ThemeConstants.neutral900,
        onInverseSurface: isDark ? ThemeConstants.neutral900 : ThemeConstants.neutral100,
        inversePrimary: isDark ? ThemeConstants.primaryDark : ThemeConstants.primaryLight,
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: isDark ? 2 : 1,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h4.copyWith(color: textPrimaryColor),
        iconTheme: IconThemeData(
          color: textPrimaryColor,
          size: ThemeConstants.iconMd,
        ),
        actionsIconTheme: IconThemeData(
          color: textSecondaryColor,
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
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
        shadowColor: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05),
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
          maximumSize: const Size(double.infinity, ThemeConstants.buttonHeight),
          shadowColor: primaryColor.withValues(alpha: 0.2),
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return 2;
            if (states.contains(WidgetState.hovered)) return 4;
            return 0;
          }),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(
            color: primaryColor,
            width: ThemeConstants.borderMedium,
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
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: ThemeConstants.elevationMd,
        focusElevation: ThemeConstants.elevationLg,
        hoverElevation: ThemeConstants.elevationLg,
        highlightElevation: ThemeConstants.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        extendedSizeConstraints: const BoxConstraints(
          minHeight: ThemeConstants.fabSize,
          minWidth: ThemeConstants.fabSize,
        ),
        sizeConstraints: const BoxConstraints(
          minHeight: ThemeConstants.fabSize,
          minWidth: ThemeConstants.fabSize,
          maxHeight: ThemeConstants.fabSize,
          maxWidth: ThemeConstants.fabSize,
        ),
      ),
      
      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        fillColor: surfaceVariant,
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
            color: Colors.transparent,
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
          color: textSecondaryColor.withValues(alpha: ThemeConstants.opacity60),
        ),
        labelStyle: AppTextStyles.body2.copyWith(color: textSecondaryColor),
        errorStyle: AppTextStyles.caption.copyWith(color: ThemeConstants.error),
        prefixIconColor: textSecondaryColor,
        suffixIconColor: textSecondaryColor,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
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
        linearMinHeight: 4,
        refreshBackgroundColor: cardColor,
      ),
      
      // Navigation Themes
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: isDark ? 8 : 4,
        selectedLabelStyle: AppTextStyles.label2.copyWith(
          fontWeight: ThemeConstants.semiBold,
        ),
        unselectedLabelStyle: AppTextStyles.label2,
        selectedIconTheme: const IconThemeData(size: ThemeConstants.iconMd),
        unselectedIconTheme: const IconThemeData(size: ThemeConstants.iconMd),
        enableFeedback: true,
      ),
      
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        indicatorColor: primaryColor.withValues(alpha: 0.1),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primaryColor, size: ThemeConstants.iconMd);
          }
          return IconThemeData(color: textSecondaryColor, size: ThemeConstants.iconMd);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.label2.copyWith(
              color: primaryColor,
              fontWeight: ThemeConstants.semiBold,
            );
          }
          return AppTextStyles.label2.copyWith(color: textSecondaryColor);
        }),
        elevation: isDark ? 8 : 4,
        height: ThemeConstants.bottomNavHeight,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        deleteIconColor: textSecondaryColor,
        disabledColor: dividerColor,
        selectedColor: primaryColor.withValues(alpha: 0.15),
        secondarySelectedColor: secondary.withValues(alpha: 0.15),
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
        side: BorderSide.none,
        elevation: 0,
        pressElevation: 2,
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
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(ThemeConstants.borderThick),
          ),
        ),
        labelStyle: AppTextStyles.label1.copyWith(
          fontWeight: ThemeConstants.semiBold,
        ),
        unselectedLabelStyle: AppTextStyles.label1,
        dividerColor: Colors.transparent,
        splashFactory: InkSparkle.splashFactory,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        titleTextStyle: AppTextStyles.h5.copyWith(color: textPrimaryColor),
        contentTextStyle: AppTextStyles.body2.copyWith(color: textSecondaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        ),
        elevation: ThemeConstants.elevationXl,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        actionsPadding: const EdgeInsets.all(ThemeConstants.space4),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ThemeConstants.radius2xl),
          ),
        ),
        elevation: ThemeConstants.elevationXl,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        dragHandleColor: dividerColor,
        dragHandleSize: const Size(40, 4),
        surfaceTintColor: Colors.transparent,
      ),
      
      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? ThemeConstants.neutral800 : ThemeConstants.neutral900,
        contentTextStyle: AppTextStyles.body2.copyWith(
          color: ThemeConstants.neutral0,
        ),
        actionTextColor: isDark ? ThemeConstants.primaryLight : ThemeConstants.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        elevation: ThemeConstants.elevationMd,
        width: 400,
        insetPadding: const EdgeInsets.all(ThemeConstants.space4),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          return isDark ? ThemeConstants.neutral600 : ThemeConstants.neutral400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor.withValues(alpha: 0.5);
          }
          return isDark ? ThemeConstants.darkDivider : ThemeConstants.neutral300;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        thumbIcon: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.check, size: 12, color: Colors.white);
          }
          return null;
        }),
        splashRadius: ThemeConstants.space5,
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
        splashRadius: ThemeConstants.space5,
      ),
      
      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryColor;
          if (states.contains(WidgetState.disabled)) return dividerColor;
          return textSecondaryColor;
        }),
        splashRadius: ThemeConstants.space5,
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withValues(alpha: 0.2),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withValues(alpha: 0.15),
        valueIndicatorColor: primaryColor,
        valueIndicatorTextStyle: AppTextStyles.caption.copyWith(color: onPrimaryColor),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8,
          pressedElevation: 4,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),
      
      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: primaryColor.withValues(alpha: 0.05),
        iconColor: textSecondaryColor,
        textColor: textPrimaryColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        selectedColor: primaryColor,
        enableFeedback: true,
      ),
      
      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? ThemeConstants.neutral700 : ThemeConstants.neutral800,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
          boxShadow: ThemeConstants.shadowMd,
        ),
        textStyle: AppTextStyles.caption.copyWith(
          color: ThemeConstants.neutral0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space2,
        ),
        preferBelow: true,
        verticalOffset: ThemeConstants.space2,
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(seconds: 2),
      ),
      
      // Badge Theme
      badgeTheme: BadgeThemeData(
        backgroundColor: ThemeConstants.error,
        textColor: ThemeConstants.neutral0,
        textStyle: AppTextStyles.caption.copyWith(
          fontWeight: ThemeConstants.semiBold,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space1_5,
          vertical: ThemeConstants.space0_5,
        ),
        alignment: AlignmentDirectional.topEnd,
        offset: const Offset(-2, 2),
      ),
      
      // Page Transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      
      // Visual Density
      visualDensity: VisualDensity.comfortable,
      
      // Splash Factory
      splashFactory: InkSparkle.splashFactory,
      
      // Highlight Color
      highlightColor: primaryColor.withValues(alpha: 0.08),
      
      // Splash Color
      splashColor: primaryColor.withValues(alpha: 0.12),
      
      // Hover Color
      hoverColor: primaryColor.withValues(alpha: 0.04),
      
      // Focus Color
      focusColor: primaryColor.withValues(alpha: 0.12),
      
      // Disable Color
      disabledColor: textSecondaryColor.withValues(alpha: 0.38),
      
      // Unselected Widget Color
      unselectedWidgetColor: textSecondaryColor,
      
      // Shadow Color
      shadowColor: Colors.black.withValues(alpha: 0.1),
      
      // Canvas Color
      canvasColor: backgroundColor,
      
      // Indicator Color
      indicatorColor: primaryColor,
    );
  }
}