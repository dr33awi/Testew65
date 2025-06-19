// lib/app/themes/theme_config.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/colors.dart';
import 'core/spacing.dart';
import 'core/typography.dart';
import 'core/gradients.dart';

/// التكوين المُحسَّن والموحد للثيم
/// يستخدم نظام cache لتحسين الأداء
class AppThemeConfig {
  AppThemeConfig._();

  // ==================== Cache للثيمات ====================
  
  static ThemeData? _lightTheme;
  static ThemeData? _darkTheme;
  static ThemeExtension<AppThemeExtension>? _themeExtension;

  /// إعادة تعيين Cache
  static void clearCache() {
    _lightTheme = null;
    _darkTheme = null;
    _themeExtension = null;
  }

  // ==================== الثيم الفاتح ====================
  
  static ThemeData get lightTheme {
    return _lightTheme ??= _buildLightTheme();
  }

  static ThemeData _buildLightTheme() {
    final colorScheme = AppColors.lightColorScheme;
    final textTheme = AppTypography.buildLightTextTheme(
      AppColors.lightTextPrimary,
      AppColors.lightTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamilyDefault,
      textTheme: textTheme,
      
      // شريط التطبيق
      appBarTheme: _buildAppBarTheme(true),
      
      // البطاقات
      cardTheme: _buildCardTheme(true),
      
      // الأزرار
      elevatedButtonTheme: _buildElevatedButtonTheme(true),
      outlinedButtonTheme: _buildOutlinedButtonTheme(true),
      textButtonTheme: _buildTextButtonTheme(true),
      
      // حقول النص
      inputDecorationTheme: _buildInputDecorationTheme(true),
      
      // المكونات الأخرى
      switchTheme: _buildSwitchTheme(true),
      checkboxTheme: _buildCheckboxTheme(true),
      radioTheme: _buildRadioTheme(true),
      sliderTheme: _buildSliderTheme(true),
      
      // الحوارات والقوائم
      dialogTheme: _buildDialogTheme(true),
      snackBarTheme: _buildSnackBarTheme(true),
      bottomSheetTheme: _buildBottomSheetTheme(true),
      
      // التنقل
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(true),
      navigationBarTheme: _buildNavigationBarTheme(true),
      
      // الأخرى
      dividerTheme: _buildDividerTheme(true),
      iconTheme: _buildIconTheme(true),
      listTileTheme: _buildListTileTheme(true),
      chipTheme: _buildChipTheme(true),
      floatingActionButtonTheme: _buildFABTheme(true),
      scrollbarTheme: _buildScrollbarTheme(true),
      
      // الإعدادات العامة
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // إضافة Theme Extension
      extensions: [themeExtension],
    );
  }

  // ==================== الثيم الداكن ====================
  
  static ThemeData get darkTheme {
    return _darkTheme ??= _buildDarkTheme();
  }

  static ThemeData _buildDarkTheme() {
    final colorScheme = AppColors.darkColorScheme;
    final textTheme = AppTypography.buildDarkTextTheme(
      AppColors.darkTextPrimary,
      AppColors.darkTextSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamilyDefault,
      textTheme: textTheme,
      
      // شريط التطبيق
      appBarTheme: _buildAppBarTheme(false),
      
      // البطاقات
      cardTheme: _buildCardTheme(false),
      
      // الأزرار
      elevatedButtonTheme: _buildElevatedButtonTheme(false),
      outlinedButtonTheme: _buildOutlinedButtonTheme(false),
      textButtonTheme: _buildTextButtonTheme(false),
      
      // حقول النص
      inputDecorationTheme: _buildInputDecorationTheme(false),
      
      // المكونات الأخرى
      switchTheme: _buildSwitchTheme(false),
      checkboxTheme: _buildCheckboxTheme(false),
      radioTheme: _buildRadioTheme(false),
      sliderTheme: _buildSliderTheme(false),
      
      // الحوارات والقوائم
      dialogTheme: _buildDialogTheme(false),
      snackBarTheme: _buildSnackBarTheme(false),
      bottomSheetTheme: _buildBottomSheetTheme(false),
      
      // التنقل
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(false),
      navigationBarTheme: _buildNavigationBarTheme(false),
      
      // الأخرى
      dividerTheme: _buildDividerTheme(false),
      iconTheme: _buildIconTheme(false),
      listTileTheme: _buildListTileTheme(false),
      chipTheme: _buildChipTheme(false),
      floatingActionButtonTheme: _buildFABTheme(false),
      scrollbarTheme: _buildScrollbarTheme(false),
      
      // الإعدادات العامة
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // إضافة Theme Extension
      extensions: [themeExtension],
    );
  }

  // ==================== Theme Extension ====================
  
  static AppThemeExtension get themeExtension {
    return _themeExtension ??= const AppThemeExtension();
  }

  // ==================== بناة المكونات ====================

  static AppBarTheme _buildAppBarTheme(bool isLight) {
    return AppBarTheme(
      backgroundColor: isLight ? AppColors.lightBackground : AppColors.darkBackground,
      foregroundColor: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        fontWeight: AppTypography.bold,
      ),
      iconTheme: IconThemeData(
        color: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
        size: AppSpacing.iconMd,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      ),
    );
  }

  static CardTheme _buildCardTheme(bool isLight) {
    return CardTheme(
      color: isLight ? AppColors.lightCard : AppColors.darkCard,
      elevation: AppSpacing.elevation2,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.circularXxl,
      ),
      shadowColor: Colors.black.withValues(alpha: isLight ? 0.1 : 0.3),
      margin: AppSpacing.allMd,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(bool isLight) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: AppSpacing.elevation2,
        padding: AppSpacing.buttonPaddingInsets,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        textStyle: AppTypography.buttonText,
        shadowColor: AppColors.primary.withValues(alpha: 0.3),
        minimumSize: Size(0, AppSpacing.buttonHeightMd),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(bool isLight) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: AppSpacing.borderMedium),
        padding: AppSpacing.buttonPaddingInsets,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        textStyle: AppTypography.buttonText,
        minimumSize: Size(0, AppSpacing.buttonHeightMd),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(bool isLight) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: AppSpacing.buttonPaddingInsets,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        textStyle: AppTypography.buttonText,
        minimumSize: Size(0, AppSpacing.buttonHeightMd),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(bool isLight) {
    final borderColor = isLight 
        ? AppColors.lightDivider.withValues(alpha: 0.5)
        : AppColors.darkDivider.withValues(alpha: 0.5);
    
    return InputDecorationTheme(
      filled: true,
      fillColor: isLight ? AppColors.lightCard : AppColors.darkCard,
      border: OutlineInputBorder(
        borderRadius: AppSpacing.inputBorderRadiusValue,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.inputBorderRadiusValue,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.inputBorderRadiusValue,
        borderSide: const BorderSide(color: AppColors.primary, width: AppSpacing.borderMedium),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.inputBorderRadiusValue,
        borderSide: const BorderSide(color: AppColors.error, width: AppSpacing.borderThin),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.inputBorderRadiusValue,
        borderSide: const BorderSide(color: AppColors.error, width: AppSpacing.borderMedium),
      ),
      contentPadding: AppSpacing.allLg,
      hintStyle: AppTypography.hintText.copyWith(
        color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
      ),
      labelStyle: AppTypography.labelText.copyWith(
        color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
      ),
      errorStyle: AppTypography.errorText.copyWith(color: AppColors.error),
    );
  }

  static SwitchThemeData _buildSwitchTheme(bool isLight) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return isLight 
            ? AppColors.lightTextSecondary.withValues(alpha: 0.5)
            : AppColors.darkTextSecondary.withValues(alpha: 0.5);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary.withValues(alpha: 0.3);
        }
        return isLight ? AppColors.lightDivider : AppColors.darkDivider;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return AppColors.primary.withValues(alpha: 0.1);
        }
        return null;
      }),
    );
  }

  static CheckboxThemeData _buildCheckboxTheme(bool isLight) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(
        color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
        width: AppSpacing.borderMedium,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.circularXs,
      ),
      overlayColor: WidgetStateProperty.all(
        AppColors.primary.withValues(alpha: 0.1),
      ),
    );
  }

  static RadioThemeData _buildRadioTheme(bool isLight) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary;
      }),
      overlayColor: WidgetStateProperty.all(
        AppColors.primary.withValues(alpha: 0.1),
      ),
    );
  }

  static SliderThemeData _buildSliderTheme(bool isLight) {
    return SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: isLight ? AppColors.lightDivider : AppColors.darkDivider,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withValues(alpha: 0.1),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(color: Colors.white),
    );
  }

  static DialogTheme _buildDialogTheme(bool isLight) {
    return DialogTheme(
      backgroundColor: isLight ? AppColors.lightCard : AppColors.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.circularXxl,
      ),
      elevation: AppSpacing.elevation4,
      titleTextStyle: AppTypography.headlineSmall.copyWith(
        color: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
      ),
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
      ),
      insetPadding: AppSpacing.allXxl,
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(bool isLight) {
    return SnackBarThemeData(
      backgroundColor: isLight ? AppColors.lightTextPrimary : AppColors.darkCard,
      contentTextStyle: AppTypography.bodyMedium.copyWith(
        color: isLight ? Colors.white : AppColors.darkTextPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.circularXl,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: AppSpacing.elevation3,
      actionTextColor: AppColors.primary,
      insetPadding: AppSpacing.allLg,
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(bool isLight) {
    return BottomSheetThemeData(
      backgroundColor: isLight ? AppColors.lightCard : AppColors.darkCard,
      elevation: AppSpacing.elevation4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXxl)),
      ),
      modalBackgroundColor: isLight ? AppColors.lightCard : AppColors.darkCard,
      modalElevation: AppSpacing.elevation5,
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(bool isLight) {
    return BottomNavigationBarThemeData(
      backgroundColor: isLight ? AppColors.lightCard : AppColors.darkCard,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: AppSpacing.elevation3,
      selectedLabelStyle: AppTypography.labelSmall.semiBold,
      unselectedLabelStyle: AppTypography.labelSmall.regular,
      selectedIconTheme: const IconThemeData(
        color: AppColors.primary,
        size: AppSpacing.iconMd,
      ),
      unselectedIconTheme: IconThemeData(
        color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
        size: AppSpacing.iconMd,
      ),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(bool isLight) {
    return NavigationBarThemeData(
      backgroundColor: isLight ? AppColors.lightCard : AppColors.darkCard,
      elevation: AppSpacing.elevation3,
      height: AppSpacing.bottomNavHeight,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppTypography.labelSmall.semiBold.copyWith(color: AppColors.primary);
        }
        return AppTypography.labelSmall.regular.copyWith(
          color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary, size: AppSpacing.iconMd);
        }
        return IconThemeData(
          color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
          size: AppSpacing.iconMd,
        );
      }),
      indicatorColor: AppColors.primary.withValues(alpha: 0.1),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: AppSpacing.circularXl,
      ),
    );
  }

  static DividerThemeData _buildDividerTheme(bool isLight) {
    return DividerThemeData(
      color: isLight ? AppColors.lightDivider : AppColors.darkDivider,
      thickness: AppSpacing.borderThin,
      space: AppSpacing.borderThin,
      indent: 0,
      endIndent: 0,
    );
  }

  static IconThemeData _buildIconTheme(bool isLight) {
    return IconThemeData(
      color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
      size: AppSpacing.iconMd,
    );
  }

  static ListTileThemeData _buildListTileTheme(bool isLight) {
    return ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      titleTextStyle: AppTypography.titleMedium.copyWith(
        color: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
      ),
      subtitleTextStyle: AppTypography.bodySmall.copyWith(
        color: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
      ),
      iconColor: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.circularXl,
      ),
      tileColor: Colors.transparent,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
    );
  }

  static ChipThemeData _buildChipTheme(bool isLight) {
    return ChipThemeData(
      backgroundColor: isLight ? AppColors.lightCard : AppColors.darkCard,
      selectedColor: AppColors.primary.withValues(alpha: 0.1),
      disabledColor: isLight ? AppColors.lightDivider : AppColors.darkDivider,
      deleteIconColor: isLight ? AppColors.lightTextSecondary : AppColors.darkTextSecondary,
      labelStyle: AppTypography.labelMedium.copyWith(
        color: isLight ? AppColors.lightTextPrimary : AppColors.darkTextPrimary,
      ),
      side: BorderSide(
        color: isLight 
            ? AppColors.lightDivider.withValues(alpha: 0.5)
            : AppColors.darkDivider.withValues(alpha: 0.5),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      elevation: 0,
      pressElevation: AppSpacing.elevation1,
    );
  }

  static FloatingActionButtonThemeData _buildFABTheme(bool isLight) {
    return FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: AppSpacing.elevation3,
      focusElevation: AppSpacing.elevation4,
      hoverElevation: AppSpacing.elevation4,
      highlightElevation: AppSpacing.elevation5,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.circularXl,
      ),
    );
  }

  static ScrollbarThemeData _buildScrollbarTheme(bool isLight) {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(
        isLight 
            ? AppColors.lightTextSecondary.withValues(alpha: 0.3)
            : AppColors.darkTextSecondary.withValues(alpha: 0.3),
      ),
      radius: const Radius.circular(AppSpacing.radiusSm),
      thickness: WidgetStateProperty.all(6.0),
      crossAxisMargin: 4.0,
      mainAxisMargin: 8.0,
    );
  }
}

// ==================== Theme Extension ====================

/// Theme Extension لإضافة قيم مخصصة للثيم
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    this.gradients = const AppGradientsExtension(),
    this.shadows = const AppShadowsExtension(),
    this.islamic = const IslamicThemeExtension(),
  });

  final AppGradientsExtension gradients;
  final AppShadowsExtension shadows;
  final IslamicThemeExtension islamic;

  @override
  AppThemeExtension copyWith({
    AppGradientsExtension? gradients,
    AppShadowsExtension? shadows,
    IslamicThemeExtension? islamic,
  }) {
    return AppThemeExtension(
      gradients: gradients ?? this.gradients,
      shadows: shadows ?? this.shadows,
      islamic: islamic ?? this.islamic,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      gradients: gradients.lerp(other.gradients, t),
      shadows: shadows.lerp(other.shadows, t),
      islamic: islamic.lerp(other.islamic, t),
    );
  }
}

/// Extension للتدرجات اللونية
@immutable
class AppGradientsExtension extends ThemeExtension<AppGradientsExtension> {
  const AppGradientsExtension({
    this.primary = AppGradients.primary,
    this.secondary = AppGradients.secondary,
    this.tertiary = AppGradients.tertiary,
    this.success = AppGradients.success,
    this.error = AppGradients.error,
    this.warning = AppGradients.warning,
    this.info = AppGradients.info,
  });

  final LinearGradient primary;
  final LinearGradient secondary;
  final LinearGradient tertiary;
  final LinearGradient success;
  final LinearGradient error;
  final LinearGradient warning;
  final LinearGradient info;

  @override
  AppGradientsExtension copyWith({
    LinearGradient? primary,
    LinearGradient? secondary,
    LinearGradient? tertiary,
    LinearGradient? success,
    LinearGradient? error,
    LinearGradient? warning,
    LinearGradient? info,
  }) {
    return AppGradientsExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  AppGradientsExtension lerp(ThemeExtension<AppGradientsExtension>? other, double t) {
    if (other is! AppGradientsExtension) return this;
    return this; // التدرجات لا تحتاج lerp
  }
}

/// Extension للظلال
@immutable
class AppShadowsExtension extends ThemeExtension<AppShadowsExtension> {
  const AppShadowsExtension({
    this.sm = AppSpacing.shadowSm,
    this.md = AppSpacing.shadowMd,
    this.lg = AppSpacing.shadowLg,
    this.xl = AppSpacing.shadowXl,
    this.xxl = AppSpacing.shadowXxl,
  });

  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;
  final List<BoxShadow> xl;
  final List<BoxShadow> xxl;

  @override
  AppShadowsExtension copyWith({
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
    List<BoxShadow>? xl,
    List<BoxShadow>? xxl,
  }) {
    return AppShadowsExtension(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppShadowsExtension lerp(ThemeExtension<AppShadowsExtension>? other, double t) {
    if (other is! AppShadowsExtension) return this;
    return this; // الظلال لا تحتاج lerp
  }
}

/// Extension خاص بالتطبيق الإسلامي
@immutable
class IslamicThemeExtension extends ThemeExtension<IslamicThemeExtension> {
  const IslamicThemeExtension({
    this.quranTextStyle = AppTypography.quranText,
    this.hadithTextStyle = AppTypography.hadithText,
    this.duaTextStyle = AppTypography.duaText,
    this.prayerNameStyle = AppTypography.prayerNameText,
    this.prayerTimeStyle = AppTypography.prayerTimeText,
  });

  final TextStyle quranTextStyle;
  final TextStyle hadithTextStyle;
  final TextStyle duaTextStyle;
  final TextStyle prayerNameStyle;
  final TextStyle prayerTimeStyle;

  @override
  IslamicThemeExtension copyWith({
    TextStyle? quranTextStyle,
    TextStyle? hadithTextStyle,
    TextStyle? duaTextStyle,
    TextStyle? prayerNameStyle,
    TextStyle? prayerTimeStyle,
  }) {
    return IslamicThemeExtension(
      quranTextStyle: quranTextStyle ?? this.quranTextStyle,
      hadithTextStyle: hadithTextStyle ?? this.hadithTextStyle,
      duaTextStyle: duaTextStyle ?? this.duaTextStyle,
      prayerNameStyle: prayerNameStyle ?? this.prayerNameStyle,
      prayerTimeStyle: prayerTimeStyle ?? this.prayerTimeStyle,
    );
  }

  @override
  IslamicThemeExtension lerp(ThemeExtension<IslamicThemeExtension>? other, double t) {
    if (other is! IslamicThemeExtension) return this;
    return IslamicThemeExtension(
      quranTextStyle: TextStyle.lerp(quranTextStyle, other.quranTextStyle, t)!,
      hadithTextStyle: TextStyle.lerp(hadithTextStyle, other.hadithTextStyle, t)!,
      duaTextStyle: TextStyle.lerp(duaTextStyle, other.duaTextStyle, t)!,
      prayerNameStyle: TextStyle.lerp(prayerNameStyle, other.prayerNameStyle, t)!,
      prayerTimeStyle: TextStyle.lerp(prayerTimeStyle, other.prayerTimeStyle, t)!,
    );
  }
}