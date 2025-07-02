// lib/app/themes/app_theme.dart - النسخة المحسنة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// استيراد الأنظمة الموحدة
import 'theme_constants.dart';
import 'text_styles.dart';
import 'core/systems/app_color_system.dart';

// تصدير الأنظمة الموحدة
export 'theme_constants.dart';
export 'text_styles.dart';
export 'core/theme_notifier.dart';
export 'core/theme_extensions.dart';

// الأنظمة الموحدة
export 'core/systems/app_color_system.dart';
export 'core/systems/app_icons_system.dart';
export 'core/systems/app_size_system.dart';
export 'core/systems/app_shadow_system.dart';
export 'core/systems/app_container_builder.dart';
export 'core/systems/glass_effect.dart';

// المساعد المبسط
export 'core/helpers/category_helper.dart';

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

/// نظام الثيم الموحد للتطبيق - نسخة محسنة
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    colorSystem: _LightColorSystem(),
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    colorSystem: _DarkColorSystem(),
  );

  /// بناء الثيم - منطق موحد مع معالجة أخطاء محسنة
  static ThemeData _buildTheme({
    required Brightness brightness,
    required _ColorSystemInterface colorSystem,
  }) {
    try {
      final textTheme = AppTextStyles.createTextTheme(
        color: colorSystem.textPrimary,
        secondaryColor: colorSystem.textSecondary,
      );

      return ThemeData(
        brightness: brightness,
        primaryColor: colorSystem.primary,
        scaffoldBackgroundColor: colorSystem.background,
        useMaterial3: true,
        fontFamily: ThemeConstants.fontFamily,
        
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: colorSystem.primary,
          onPrimary: colorSystem.onPrimary,
          secondary: AppColorSystem.accent,
          onSecondary: _getContrastingTextColor(AppColorSystem.accent),
          tertiary: AppColorSystem.tertiary,
          onTertiary: _getContrastingTextColor(AppColorSystem.tertiary),
          error: AppColorSystem.error,
          onError: Colors.white,
          surface: colorSystem.background,
          onSurface: colorSystem.textPrimary,
          surfaceContainerHighest: colorSystem.card,
          onSurfaceVariant: colorSystem.textSecondary,
          outline: colorSystem.divider,
        ),
        
        appBarTheme: _buildAppBarTheme(colorSystem),
        cardTheme: _buildCardTheme(colorSystem),
        textTheme: textTheme,
        elevatedButtonTheme: _buildElevatedButtonTheme(colorSystem),
        inputDecorationTheme: _buildInputDecorationTheme(colorSystem),
        dividerTheme: _buildDividerTheme(colorSystem),
        iconTheme: _buildIconTheme(colorSystem),
        progressIndicatorTheme: _buildProgressIndicatorTheme(colorSystem),
        snackBarTheme: _buildSnackBarTheme(colorSystem),
        dialogTheme: _buildDialogTheme(colorSystem),
        bottomSheetTheme: _buildBottomSheetTheme(colorSystem),
        floatingActionButtonTheme: _buildFABTheme(colorSystem),
        navigationBarTheme: _buildNavigationBarTheme(colorSystem),
        chipTheme: _buildChipTheme(colorSystem, brightness),
      );
    } catch (e) {
      // في حالة حدوث خطأ، إرجاع ثيم أساسي
      assert(() {
        print('خطأ في بناء الثيم: $e');
        return true;
      }());
      
      return _createFallbackTheme(brightness);
    }
  }

  /// إنشاء ثيم احتياطي في حالة الأخطاء
  static ThemeData _createFallbackTheme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primarySwatch: Colors.green,
      fontFamily: ThemeConstants.fontFamily,
    );
  }

  // دوال بناء المكونات - كما هي مع تحسين بسيط في التعليقات
  static AppBarTheme _buildAppBarTheme(_ColorSystemInterface colors) {
    return AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.h4.copyWith(color: colors.textPrimary),
      iconTheme: IconThemeData(
        color: colors.textPrimary,
        size: ThemeConstants.iconMd,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: colors.statusBarIconBrightness,
        systemNavigationBarColor: colors.background,
        systemNavigationBarIconBrightness: colors.statusBarIconBrightness,
      ),
    );
  }

  static CardThemeData _buildCardTheme(_ColorSystemInterface colors) {
    return CardThemeData(
      color: colors.card,
      elevation: ThemeConstants.elevationNone,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(_ColorSystemInterface colors) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
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
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(_ColorSystemInterface colors) {
    return InputDecorationTheme(
      fillColor: colors.surface.withOpacity(colors.fillOpacity),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space4,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: BorderSide(
          color: colors.divider,
          width: ThemeConstants.borderLight,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        borderSide: BorderSide(
          color: colors.primary,
          width: ThemeConstants.borderThick,
        ),
      ),
    );
  }

  static DividerThemeData _buildDividerTheme(_ColorSystemInterface colors) {
    return DividerThemeData(
      color: colors.divider,
      thickness: ThemeConstants.borderLight,
      space: ThemeConstants.space1,
    );
  }

  static IconThemeData _buildIconTheme(_ColorSystemInterface colors) {
    return IconThemeData(
      color: colors.textPrimary,
      size: ThemeConstants.iconMd,
    );
  }

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme(_ColorSystemInterface colors) {
    return ProgressIndicatorThemeData(
      color: colors.primary,
      linearTrackColor: colors.divider.withOpacity(ThemeConstants.opacity50),
      circularTrackColor: colors.divider.withOpacity(ThemeConstants.opacity50),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(_ColorSystemInterface colors) {
    return SnackBarThemeData(
      backgroundColor: colors.card,
      contentTextStyle: AppTextStyles.body2.copyWith(color: colors.textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: ThemeConstants.elevation4,
    );
  }

  static DialogThemeData _buildDialogTheme(_ColorSystemInterface colors) {
    return DialogThemeData(
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      elevation: ThemeConstants.elevation16,
      titleTextStyle: AppTextStyles.h4.copyWith(color: colors.textPrimary),
      contentTextStyle: AppTextStyles.body1.copyWith(color: colors.textSecondary),
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(_ColorSystemInterface colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ThemeConstants.radiusXl),
          topRight: Radius.circular(ThemeConstants.radiusXl),
        ),
      ),
      elevation: ThemeConstants.elevation16,
    );
  }

  static FloatingActionButtonThemeData _buildFABTheme(_ColorSystemInterface colors) {
    return FloatingActionButtonThemeData(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      elevation: ThemeConstants.elevation6,
      focusElevation: ThemeConstants.elevation8,
      hoverElevation: ThemeConstants.elevation8,
      highlightElevation: ThemeConstants.elevation12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.fabSize / 2),
      ),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(_ColorSystemInterface colors) {
    return NavigationBarThemeData(
      backgroundColor: colors.card,
      indicatorColor: colors.primary.withOpacity(ThemeConstants.opacity20),
      labelTextStyle: WidgetStateProperty.all(
        AppTextStyles.label2.copyWith(color: colors.textSecondary),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: colors.primary, size: ThemeConstants.iconMd);
        }
        return IconThemeData(color: colors.textSecondary, size: ThemeConstants.iconMd);
      }),
      height: ThemeConstants.bottomNavHeight,
      elevation: ThemeConstants.elevation4,
    );
  }

  static ChipThemeData _buildChipTheme(_ColorSystemInterface colors, Brightness brightness) {
    return ChipThemeData(
      backgroundColor: colors.surface,
      selectedColor: colors.primary.withOpacity(ThemeConstants.opacity20),
      disabledColor: colors.divider,
      labelStyle: AppTextStyles.label2.copyWith(color: colors.textPrimary),
      secondaryLabelStyle: AppTextStyles.label2.copyWith(color: colors.textSecondary),
      brightness: brightness,
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space3,
        vertical: ThemeConstants.space2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
      ),
    );
  }

  static Color _getContrastingTextColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  // دوال مساعدة محسنة مع معالجة أخطاء أفضل

  /// الحصول على ثيم مخصص بلون أساسي مختلف
  static ThemeData getCustomTheme({
    required Brightness brightness,
    required Color primaryColor,
    Color? backgroundColor,
  }) {
    try {
      final isDark = brightness == Brightness.dark;
      final customColorSystem = _CustomColorSystem(
        primary: primaryColor,
        background: backgroundColor ?? (isDark 
            ? AppColorSystem.darkBackground 
            : AppColorSystem.lightBackground),
        isDark: isDark,
      );
      
      return _buildTheme(
        brightness: brightness,
        colorSystem: customColorSystem,
      );
    } catch (e) {
      // في حالة الخطأ، إرجاع الثيم الافتراضي
      return brightness == Brightness.dark ? darkTheme : lightTheme;
    }
  }

  /// التحقق من توافق اللون مع الثيم
  static bool isColorCompatible(Color color, Brightness brightness) {
    try {
      final colorBrightness = ThemeData.estimateBrightnessForColor(color);
      return brightness == Brightness.dark 
          ? colorBrightness == Brightness.light 
          : colorBrightness == Brightness.dark;
    } catch (e) {
      return false;
    }
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

// واجهات مساعدة داخلية - كما هي
abstract class _ColorSystemInterface {
  Color get primary;
  Color get onPrimary;
  Color get background;
  Color get surface;
  Color get card;
  Color get divider;
  Color get textPrimary;
  Color get textSecondary;
  Brightness get statusBarIconBrightness;
  double get fillOpacity;
}

class _LightColorSystem implements _ColorSystemInterface {
  @override
  Color get primary => AppColorSystem.primary;
  @override
  Color get onPrimary => AppTheme._getContrastingTextColor(primary);
  @override
  Color get background => AppColorSystem.lightBackground;
  @override
  Color get surface => AppColorSystem.lightSurface;
  @override
  Color get card => AppColorSystem.lightCard;
  @override
  Color get divider => AppColorSystem.lightDivider;
  @override
  Color get textPrimary => AppColorSystem.lightTextPrimary;
  @override
  Color get textSecondary => AppColorSystem.lightTextSecondary;
  @override
  Brightness get statusBarIconBrightness => Brightness.dark;
  @override
  double get fillOpacity => ThemeConstants.opacity50;
}

class _DarkColorSystem implements _ColorSystemInterface {
  @override
  Color get primary => AppColorSystem.primaryLight;
  @override
  Color get onPrimary => AppTheme._getContrastingTextColor(primary);
  @override
  Color get background => AppColorSystem.darkBackground;
  @override
  Color get surface => AppColorSystem.darkSurface;
  @override
  Color get card => AppColorSystem.darkCard;
  @override
  Color get divider => AppColorSystem.darkDivider;
  @override
  Color get textPrimary => AppColorSystem.darkTextPrimary;
  @override
  Color get textSecondary => AppColorSystem.darkTextSecondary;
  @override
  Brightness get statusBarIconBrightness => Brightness.light;
  @override
  double get fillOpacity => ThemeConstants.opacity10;
}

class _CustomColorSystem implements _ColorSystemInterface {
  final Color _primary;
  final Color _background;
  final bool _isDark;

  _CustomColorSystem({
    required Color primary,
    required Color background,
    required bool isDark,
  }) : _primary = primary, _background = background, _isDark = isDark;

  @override
  Color get primary => _primary;
  @override
  Color get onPrimary => AppTheme._getContrastingTextColor(_primary);
  @override
  Color get background => _background;
  @override
  Color get surface => _isDark ? AppColorSystem.darkSurface : AppColorSystem.lightSurface;
  @override
  Color get card => _isDark ? AppColorSystem.darkCard : AppColorSystem.lightCard;
  @override
  Color get divider => _isDark ? AppColorSystem.darkDivider : AppColorSystem.lightDivider;
  @override
  Color get textPrimary => _isDark ? AppColorSystem.darkTextPrimary : AppColorSystem.lightTextPrimary;
  @override
  Color get textSecondary => _isDark ? AppColorSystem.darkTextSecondary : AppColorSystem.lightTextSecondary;
  @override
  Brightness get statusBarIconBrightness => _isDark ? Brightness.light : Brightness.dark;
  @override
  double get fillOpacity => _isDark ? ThemeConstants.opacity10 : ThemeConstants.opacity50;
}