// lib/app/themes/app_theme.dart - الملف الموحد الوحيد للثيم - خالي من الأخطاء
// استيراد هذا الملف فقط للحصول على جميع مكونات الثيم

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// ===== استيراد المكونات الأساسية =====
import 'theme_constants.dart';
import 'text_styles.dart';

// ===== تصدير كل شيء للاستخدام الخارجي =====

// الأساسيات
export 'theme_constants.dart';
export 'text_styles.dart';
export 'core/theme_notifier.dart';

// المكونات الأساسية  
export 'widgets/core/app_button.dart';
export 'widgets/core/app_text_field.dart';
export 'widgets/core/app_loading.dart';

// مكونات التخطيط
export 'widgets/layout/app_bar.dart';

// الحوارات والنوافذ المنبثقة
export 'widgets/dialogs/app_info_dialog.dart';

// مكونات التغذية الراجعة
export 'widgets/feedback/app_snackbar.dart';
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

// ===== الأنظمة الموحدة الجديدة =====

/// نظام الألوان الموحد للتطبيق
class AppColorSystem {
  AppColorSystem._();

  // خريطة الألوان الأساسية - موحدة من جميع المصادر
  static const Map<String, Color> _primaryColors = {
    // فئات الأذكار
    'morning': ThemeConstants.primary,
    'الصباح': ThemeConstants.primary,
    'أذكار الصباح': ThemeConstants.primary,
    'evening': ThemeConstants.accent,
    'المساء': ThemeConstants.accent,
    'أذكار المساء': ThemeConstants.accent,
    'sleep': ThemeConstants.tertiary,
    'النوم': ThemeConstants.tertiary,
    'أذكار النوم': ThemeConstants.tertiary,
    'prayer': ThemeConstants.primaryLight,
    'بعد الصلاة': ThemeConstants.primaryLight,
    'أذكار بعد الصلاة': ThemeConstants.primaryLight,
    
    // فئات التطبيق الرئيسية
    'prayer_times': ThemeConstants.primary,
    'athkar': ThemeConstants.accent,
    'quran': ThemeConstants.tertiary,
    'qibla': ThemeConstants.primaryDark,
    'tasbih': ThemeConstants.accentDark,
    'dua': ThemeConstants.tertiaryDark,
    
    // أنواع الاقتباسات
    'verse': ThemeConstants.primary,
    'آية': ThemeConstants.primary,
    'hadith': ThemeConstants.accent,
    'حديث': ThemeConstants.accent,
    'dua_quote': ThemeConstants.tertiary,
    'دعاء': ThemeConstants.tertiary,
    
    // الصلوات
    'fajr': Color(0xFF5D7052),
    'الفجر': Color(0xFF5D7052),
    'dhuhr': Color(0xFFB8860B),
    'الظهر': Color(0xFFB8860B),
    'asr': Color(0xFF7A8B6F),
    'العصر': Color(0xFF7A8B6F),
    'maghrib': ThemeConstants.tertiary,
    'المغرب': ThemeConstants.tertiary,
    'isha': Color(0xFF3A453A),
    'العشاء': Color(0xFF3A453A),
    'sunrise': Color(0xFFDAA520),
    'الشروق': Color(0xFFDAA520),
    
    // الألوان الدلالية
    'success': ThemeConstants.success,
    'error': ThemeConstants.error,
    'warning': ThemeConstants.warning,
    'info': ThemeConstants.info,
    'primary': ThemeConstants.primary,
  };

  static const Map<String, Color> _lightColors = {
    'morning': ThemeConstants.primaryLight,
    'الصباح': ThemeConstants.primaryLight,
    'evening': ThemeConstants.accentLight,
    'المساء': ThemeConstants.accentLight,
    'sleep': ThemeConstants.tertiaryLight,
    'النوم': ThemeConstants.tertiaryLight,
    'prayer': ThemeConstants.primarySoft,
    'بعد الصلاة': ThemeConstants.primarySoft,
    'fajr': ThemeConstants.primaryLight,
    'الفجر': ThemeConstants.primaryLight,
    'dhuhr': ThemeConstants.accentLight,
    'الظهر': ThemeConstants.accentLight,
    'verse': ThemeConstants.primaryLight,
    'آية': ThemeConstants.primaryLight,
    'hadith': ThemeConstants.accentLight,
    'حديث': ThemeConstants.accentLight,
    'success': ThemeConstants.successLight,
    'warning': ThemeConstants.warningLight,
    'info': ThemeConstants.infoLight,
  };

  static const Map<String, Color> _darkColors = {
    'morning': ThemeConstants.primaryDark,
    'الصباح': ThemeConstants.primaryDark,
    'evening': ThemeConstants.accentDark,
    'المساء': ThemeConstants.accentDark,
    'sleep': ThemeConstants.tertiaryDark,
    'النوم': ThemeConstants.tertiaryDark,
    'prayer': ThemeConstants.primary,
    'بعد الصلاة': ThemeConstants.primary,
    'fajr': ThemeConstants.primaryDark,
    'الفجر': ThemeConstants.primaryDark,
    'dhuhr': ThemeConstants.accentDark,
    'الظهر': ThemeConstants.accentDark,
    'verse': ThemeConstants.primaryDark,
    'آية': ThemeConstants.primaryDark,
    'hadith': ThemeConstants.accentDark,
    'حديث': ThemeConstants.accentDark,
    'success': ThemeConstants.primary,
    'error': ThemeConstants.error,
    'warning': ThemeConstants.warning,
    'info': ThemeConstants.info,
  };

  /// الحصول على اللون الأساسي
  static Color getPrimaryColor(String key) {
    final normalizedKey = key.toLowerCase().trim();
    return _primaryColors[normalizedKey] ?? ThemeConstants.primary;
  }

  /// الحصول على اللون الفاتح
  static Color getLightColor(String key) {
    final normalizedKey = key.toLowerCase().trim();
    return _lightColors[normalizedKey] ?? ThemeConstants.primaryLight;
  }

  /// الحصول على اللون الداكن
  static Color getDarkColor(String key) {
    final normalizedKey = key.toLowerCase().trim();
    return _darkColors[normalizedKey] ?? ThemeConstants.primaryDark;
  }

  /// الحصول على تدرج لوني
  static LinearGradient getGradient(String key) {
    final primary = getPrimaryColor(key);
    final dark = getDarkColor(key);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primary, dark],
    );
  }

  /// الحصول على لون الظل
  static Color getShadowColor(String key, {double opacity = 0.3}) {
    final primary = getPrimaryColor(key);
    return primary.withValues(alpha: opacity);
  }

  /// الحصول على جميع المفاتيح المتاحة
  static List<String> getAllKeys() {
    return _primaryColors.keys.toList();
  }
}

/// نظام الأحجام الموحد
enum ComponentSize { xs, sm, md, lg, xl, xxl }

class AppSizeSystem {
  static const Map<ComponentSize, double> _heights = {
    ComponentSize.xs: 28,
    ComponentSize.sm: 32,
    ComponentSize.md: 40,
    ComponentSize.lg: 48,
    ComponentSize.xl: 56,
    ComponentSize.xxl: 64,
  };

  static const Map<ComponentSize, double> _iconSizes = {
    ComponentSize.xs: 16,
    ComponentSize.sm: 18,
    ComponentSize.md: 20,
    ComponentSize.lg: 24,
    ComponentSize.xl: 28,
    ComponentSize.xxl: 32,
  };

  static const Map<ComponentSize, EdgeInsets> _paddings = {
    ComponentSize.xs: EdgeInsets.all(8),
    ComponentSize.sm: EdgeInsets.all(12),
    ComponentSize.md: EdgeInsets.all(16),
    ComponentSize.lg: EdgeInsets.all(20),
    ComponentSize.xl: EdgeInsets.all(24),
    ComponentSize.xxl: EdgeInsets.all(32),
  };

  static double getHeight(ComponentSize size) => _heights[size]!;
  static double getIconSize(ComponentSize size) => _iconSizes[size]!;
  static EdgeInsets getPadding(ComponentSize size) => _paddings[size]!;
  
  static ComponentSize getResponsiveSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 600) return ComponentSize.sm;
    if (width < 1024) return ComponentSize.md;
    return ComponentSize.lg;
  }
}

/// نظام الظلال الموحد
enum ShadowIntensity { none, light, medium, strong, intense }

class AppShadowSystem {
  static List<BoxShadow> get none => [];
  
  static List<BoxShadow> get light => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get medium => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get strong => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get intense => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> colored({
    required Color color,
    ShadowIntensity intensity = ShadowIntensity.medium,
    double opacity = 0.3,
  }) {
    final blurRadius = intensity == ShadowIntensity.light ? 4.0 :
                     intensity == ShadowIntensity.medium ? 8.0 :
                     intensity == ShadowIntensity.strong ? 16.0 : 24.0;
                     
    final offset = intensity == ShadowIntensity.light ? const Offset(0, 2) :
                  intensity == ShadowIntensity.medium ? const Offset(0, 4) :
                  intensity == ShadowIntensity.strong ? const Offset(0, 8) : const Offset(0, 12);
    
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }

  // ظلال للمكونات المحددة
  static List<BoxShadow> get card => medium;
  static List<BoxShadow> get button => light;
  static List<BoxShadow> get dialog => intense;
}

/// نظام Glass Effect الموحد
enum GlassIntensity { light, medium, strong, extreme }

class GlassEffect extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color? overlayColor;
  final double borderOpacity;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? shadows;
  final GlassIntensity intensity;

  const GlassEffect({
    super.key,
    required this.child,
    this.blur = 10,
    this.overlayColor,
    this.borderOpacity = 0.2,
    this.borderRadius,
    this.padding,
    this.margin,
    this.shadows,
    this.intensity = GlassIntensity.medium,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBlur = _getEffectiveBlur();
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ThemeConstants.radiusLg);
    final effectiveOverlayColor = overlayColor ?? _getDefaultOverlayColor();
    
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: effectiveOverlayColor,
              borderRadius: effectiveBorderRadius,
              border: Border.all(
                color: Colors.white.withValues(alpha: borderOpacity),
                width: 1,
              ),
              boxShadow: shadows,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  double _getEffectiveBlur() {
    switch (intensity) {
      case GlassIntensity.light: return blur * 0.5;
      case GlassIntensity.medium: return blur;
      case GlassIntensity.strong: return blur * 1.5;
      case GlassIntensity.extreme: return blur * 2.0;
    }
  }

  Color _getDefaultOverlayColor() {
    switch (intensity) {
      case GlassIntensity.light: return Colors.white.withValues(alpha: 0.05);
      case GlassIntensity.medium: return Colors.white.withValues(alpha: 0.1);
      case GlassIntensity.strong: return Colors.white.withValues(alpha: 0.15);
      case GlassIntensity.extreme: return Colors.white.withValues(alpha: 0.2);
    }
  }

  // Factory constructors للاستخدام السريع
  factory GlassEffect.card({required Widget child, EdgeInsets? padding}) {
    return GlassEffect(
      intensity: GlassIntensity.light,
      blur: 8,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      child: child,
    );
  }

  factory GlassEffect.dialog({required Widget child, EdgeInsets? padding}) {
    return GlassEffect(
      intensity: GlassIntensity.strong,
      blur: 15,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space6),
      child: child,
    );
  }

  factory GlassEffect.snackbar({required Widget child, EdgeInsets? padding}) {
    return GlassEffect(
      intensity: GlassIntensity.medium,
      blur: 12,
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space3,
      ),
      child: child,
    );
  }

  // دالة مساعدة للتطبيق السريع
  static Widget wrap(Widget child, {
    double blur = 10,
    GlassIntensity intensity = GlassIntensity.medium,
    EdgeInsets? padding,
  }) {
    return GlassEffect(
      blur: blur,
      intensity: intensity,
      padding: padding,
      child: child,
    );
  }

  // Glass مع تدرج لوني
  static Widget withGradient({
    required Widget child,
    required List<Color> gradientColors,
    double blur = 10,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ThemeConstants.radiusLg);
    
    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: effectiveBorderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: effectiveBorderRadius,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// نظام بناء الحاويات الموحد
class AppContainerBuilder {
  AppContainerBuilder._();

  /// حاوية أساسية
  static Widget basic({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    double? borderRadius,
    Border? border,
    List<BoxShadow>? shadows,
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? ThemeConstants.radiusMd),
        border: border,
        boxShadow: shadows,
      ),
      child: child,
    );
  }

  /// حاوية مع تدرج لوني
  static Widget gradient({
    required Widget child,
    required List<Color> colors,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? ThemeConstants.radiusMd),
        boxShadow: shadows ?? AppShadowSystem.medium,
      ),
      child: child,
    );
  }

  /// حاوية زجاجية
  static Widget glass({
    required Widget child,
    double blur = 10,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    GlassIntensity intensity = GlassIntensity.medium,
  }) {
    return GlassEffect(
      blur: blur,
      intensity: intensity,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      margin: margin,
      borderRadius: BorderRadius.circular(borderRadius ?? ThemeConstants.radiusLg),
      child: child,
    );
  }

  /// حاوية زجاجية مع تدرج
  static Widget glassGradient({
    required Widget child,
    required List<Color> colors,
    double blur = 10,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    return GlassEffect.withGradient(
      child: child,
      gradientColors: colors,
      blur: blur,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      borderRadius: BorderRadius.circular(borderRadius ?? ThemeConstants.radiusLg),
    );
  }

  /// حاوية للبطاقات
  static Widget card({
    required Widget child,
    ComponentSize size = ComponentSize.md,
    String? colorKey,
    bool withGlass = false,
    bool withShadow = true,
    EdgeInsets? margin,
  }) {
    final padding = AppSizeSystem.getPadding(size);
    final borderRadius = size == ComponentSize.sm ? 8.0 : 
                        size == ComponentSize.md ? 12.0 : 16.0;
    
    if (withGlass && colorKey != null) {
      return glassGradient(
        colors: [
          AppColorSystem.getPrimaryColor(colorKey).withValues(alpha: 0.9),
          AppColorSystem.getDarkColor(colorKey).withValues(alpha: 0.7),
        ],
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        child: child,
      );
    }
    
    if (colorKey != null) {
      return gradient(
        colors: [
          AppColorSystem.getPrimaryColor(colorKey),
          AppColorSystem.getDarkColor(colorKey),
        ],
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        shadows: withShadow ? AppShadowSystem.colored(
          color: AppColorSystem.getPrimaryColor(colorKey)
        ) : null,
        child: child,
      );
    }
    
    return basic(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      shadows: withShadow ? AppShadowSystem.card : null,
      child: child,
    );
  }

  /// حاوية للإشعارات
  static Widget notification({
    required Widget child,
    required String type,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool withGlass = false,
  }) {
    final color = AppColorSystem.getPrimaryColor(type);
    
    if (withGlass) {
      return glassGradient(
        colors: [
          color.withValues(alpha: 0.9),
          color.withValues(alpha: 0.7),
        ],
        padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
        margin: margin,
        child: child,
      );
    }
    
    return gradient(
      colors: [color, AppColorSystem.getDarkColor(type)],
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      margin: margin,
      shadows: AppShadowSystem.colored(color: color),
      child: child,
    );
  }
}

// ===== أنواع وخصائص البطاقات =====

/// أنواع البطاقات المختلفة
enum CardType {
  normal,   // بطاقة عادية
  athkar,   // بطاقة أذكار
  quote,    // بطاقة اقتباس
  info,     // بطاقة معلومات
}

/// أنماط البطاقات المختلفة
enum CardStyle {
  normal,        // عادي
  gradient,      // متدرج
  glassmorphism, // زجاجي
}

/// إجراءات البطاقة
class CardAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;

  const CardAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = false,
  });
}

/// خصائص البطاقة
class CardProperties {
  // النوع والأسلوب
  final CardType type;
  final CardStyle style;
  
  // المحتوى الأساسي
  final String? title;
  final String? subtitle;
  final String? content;
  final Widget? child;
  
  // الأيقونات والصور
  final IconData? icon;
  final Widget? trailing;
  
  // الألوان والتصميم
  final Color? primaryColor;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  
  // التفاعل
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<CardAction>? actions;
  
  // خصائص إضافية
  final bool showShadow;
  
  // خصائص خاصة بالأذكار
  final int? currentCount;
  final int? totalCount;
  final bool? isFavorite;
  final String? source;
  final String? fadl;
  final VoidCallback? onFavoriteToggle;
  
  // خصائص خاصة بالمعلومات
  final String? value;
  final String? unit;

  const CardProperties({
    this.type = CardType.normal,
    this.style = CardStyle.normal,
    this.title,
    this.subtitle,
    this.content,
    this.child,
    this.icon,
    this.trailing,
    this.primaryColor,
    this.backgroundColor,
    this.gradientColors,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.actions,
    this.showShadow = true,
    this.currentCount,
    this.totalCount,
    this.isFavorite,
    this.source,
    this.fadl,
    this.onFavoriteToggle,
    this.value,
    this.unit,
  });

  /// التحقق من وجود محتوى للعرض
  bool get hasContent {
    return title != null || 
           subtitle != null || 
           content != null || 
           icon != null ||
           child != null;
  }

  /// التحقق من وجود بيانات الأذكار
  bool get hasAthkarData {
    return content != null || 
           title != null ||
           currentCount != null ||
           totalCount != null;
  }

  /// التحقق من صحة البطاقة للعرض
  bool get isValid {
    switch (type) {
      case CardType.athkar:
        return hasAthkarData;
      case CardType.info:
        return title != null || subtitle != null || icon != null;
      default:
        return hasContent;
    }
  }
}

/// Factory لإنشاء البطاقات
class CardFactory {
  CardFactory._();

  /// بطاقة بسيطة
  static CardProperties simple({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    Color? primaryColor,
  }) {
    return CardProperties(
      type: CardType.normal,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      primaryColor: primaryColor,
    );
  }

  /// بطاقة أذكار
  static CardProperties athkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    bool isFavorite = false,
    Color? primaryColor,
    VoidCallback? onTap,
    VoidCallback? onFavoriteToggle,
    List<CardAction>? actions,
  }) {
    return CardProperties(
      type: CardType.athkar,
      style: CardStyle.gradient,
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      isFavorite: isFavorite,
      primaryColor: primaryColor,
      onTap: onTap,
      onFavoriteToggle: onFavoriteToggle,
      actions: actions,
    );
  }

  /// بطاقة اقتباس
  static CardProperties quote({
    required String quote,
    String? author,
    String? category,
    Color? primaryColor,
    List<Color>? gradientColors,
  }) {
    return CardProperties(
      type: CardType.quote,
      style: CardStyle.gradient,
      content: quote,
      source: author,
      subtitle: category,
      primaryColor: primaryColor,
      gradientColors: gradientColors,
    );
  }

  /// بطاقة معلومات
  static CardProperties info({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return CardProperties(
      type: CardType.info,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      primaryColor: iconColor,
      trailing: trailing,
    );
  }

  /// بطاقة فئة زجاجية
  static CardProperties glassCategory({
    required String title,
    required IconData icon,
    required Color primaryColor,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return CardProperties(
      style: CardStyle.glassmorphism,
      title: title,
      icon: icon,
      primaryColor: primaryColor,
      gradientColors: [
        primaryColor.withValues(alpha: 0.95),
        primaryColor.lighten(0.1).withValues(alpha: 0.90),
        primaryColor.darken(0.15).withValues(alpha: 0.85),
      ],
      onTap: onTap,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
      showShadow: true,
    );
  }
}

/// بطاقة موحدة لجميع الاستخدامات
class AppCard extends StatelessWidget {
  final CardProperties properties;

  const AppCard({
    super.key,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    if (!properties.isValid) {
      return AppContainerBuilder.notification(
        type: 'error',
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: ComponentSize.md.iconSize,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'خطأ في بيانات البطاقة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
    final colorKey = _getColorKey();
    final size = _getCardSize();
    
    switch (properties.style) {
      case CardStyle.glassmorphism:
        return _buildGlassCard(context, colorKey, size);
      case CardStyle.gradient:
        return _buildGradientCard(context, colorKey, size);
      default:
        return _buildNormalCard(context, colorKey, size);
    }
  }

  Widget _buildGlassCard(BuildContext context, String colorKey, ComponentSize size) {
    return GestureDetector(
      onTap: properties.onTap,
      onLongPress: properties.onLongPress,
      child: AppContainerBuilder.card(
        size: size,
        colorKey: colorKey,
        withGlass: true,
        withShadow: properties.showShadow,
        margin: _convertMargin(properties.margin),
        child: _buildContent(context, isGlass: true),
      ),
    );
  }

  Widget _buildGradientCard(BuildContext context, String colorKey, ComponentSize size) {
    return GestureDetector(
      onTap: properties.onTap,
      onLongPress: properties.onLongPress,
      child: AppContainerBuilder.card(
        size: size,
        colorKey: colorKey,
        withGlass: false,
        withShadow: properties.showShadow,
        margin: _convertMargin(properties.margin),
        child: _buildContent(context, isGradient: true),
      ),
    );
  }

  Widget _buildNormalCard(BuildContext context, String? colorKey, ComponentSize size) {
    return GestureDetector(
      onTap: properties.onTap,
      onLongPress: properties.onLongPress,
      child: AppContainerBuilder.basic(
        padding: AppSizeSystem.getPadding(size),
        margin: _convertMargin(properties.margin),
        backgroundColor: properties.backgroundColor ?? Theme.of(context).cardTheme.color,
        borderRadius: size == ComponentSize.sm ? 8.0 : 
                      size == ComponentSize.md ? 12.0 : 16.0,
        shadows: properties.showShadow ? AppShadowSystem.card : null,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {bool isGlass = false, bool isGradient = false}) {
    final textColor = (isGlass || isGradient) ? Colors.white : null;

    switch (properties.type) {
      case CardType.athkar:
        return _buildAthkarContent(context, textColor);
      case CardType.quote:
        return _buildQuoteContent(context, textColor);
      case CardType.info:
        return _buildInfoContent(context, textColor);
      default:
        return _buildNormalContent(context, textColor);
    }
  }

  Widget _buildAthkarContent(BuildContext context, Color? textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_hasCounterData()) 
          _buildAthkarHeader(textColor),
        
        if (_hasCounterData() && _hasMainContent())
          const SizedBox(height: 12),
        
        if (_hasMainContent())
          _buildAthkarMainContent(textColor),
        
        if (properties.source != null || properties.fadl != null)
          _buildAthkarFooter(textColor),
      ],
    );
  }

  Widget _buildAthkarHeader(Color? textColor) {
    return Row(
      children: [
        if (properties.currentCount != null && properties.totalCount != null)
          AppContainerBuilder.basic(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            borderRadius: 20,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1,
            ),
            child: Text(
              '${properties.currentCount}/${properties.totalCount}',
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        
        const Spacer(),
        
        if (properties.actions != null && properties.actions!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: properties.actions!.map((action) => 
              Container(
                margin: const EdgeInsets.only(left: 4),
                child: AppContainerBuilder.basic(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  borderRadius: 8,
                  child: IconButton(
                    onPressed: action.onPressed,
                    icon: Icon(action.icon),
                    iconSize: 18,
                    color: textColor ?? Colors.white,
                    tooltip: action.label,
                  ),
                ),
              ),
            ).toList(),
          ),
      ],
    );
  }

  Widget _buildAthkarMainContent(Color? textColor) {
    final content = properties.content ?? properties.title ?? '';
    
    return AppContainerBuilder.basic(
      padding: const EdgeInsets.all(20),
      backgroundColor: Colors.white.withValues(alpha: 0.15),
      borderRadius: 16,
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.3),
        width: 1,
      ),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 20,
          fontWeight: ThemeConstants.semiBold,
          height: 2.0,
        ),
      ),
    );
  }

  Widget _buildAthkarFooter(Color? textColor) {
    return Column(
      children: [
        const SizedBox(height: 16),
        
        if (properties.source != null)
          Center(
            child: AppContainerBuilder.basic(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              borderRadius: 25,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1,
              ),
              child: Text(
                properties.source!,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontWeight: ThemeConstants.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        
        if (properties.fadl != null) ...[
          if (properties.source != null) 
            const SizedBox(height: 12),
          
          AppContainerBuilder.basic(
            padding: const EdgeInsets.all(12),
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            borderRadius: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.star_outline,
                  color: (textColor ?? Colors.white).withValues(alpha: 0.8),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الفضل',
                        style: TextStyle(
                          color: (textColor ?? Colors.white).withValues(alpha: 0.9),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        properties.fadl!,
                        style: TextStyle(
                          color: (textColor ?? Colors.white).withValues(alpha: 0.8),
                          height: 1.4,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuoteContent(BuildContext context, Color? textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (properties.subtitle != null)
          AppContainerBuilder.basic(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            borderRadius: 20,
            child: Text(
              properties.subtitle!,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: ThemeConstants.semiBold,
                fontSize: 12,
              ),
            ),
          ),
        
        if (properties.subtitle != null) 
          const SizedBox(height: 16),
        
        AppContainerBuilder.basic(
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          borderRadius: 16,
          child: Text(
            properties.content ?? properties.title ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 18,
              height: 1.8,
            ),
          ),
        ),
        
        if (properties.source != null) ...[
          const SizedBox(height: 16),
          Center(
            child: AppContainerBuilder.basic(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              borderRadius: 25,
              child: Text(
                properties.source!,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontWeight: ThemeConstants.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoContent(BuildContext context, Color? textColor) {
    return Row(
      children: [
        if (properties.icon != null)
          AppContainerBuilder.basic(
            width: 60,
            height: 60,
            backgroundColor: (properties.primaryColor ?? 
                AppColorSystem.getPrimaryColor('info')).withValues(alpha: 0.1),
            borderRadius: 16,
            child: Icon(
              properties.icon,
              color: properties.primaryColor ?? AppColorSystem.getPrimaryColor('info'),
              size: 24,
            ),
          ),
        
        if (properties.icon != null) 
          const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (properties.title != null)
                Text(
                  properties.title!,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
              if (properties.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  properties.subtitle!,
                  style: TextStyle(
                    color: (textColor ?? Colors.grey).withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        if (properties.trailing != null) 
          properties.trailing!,
      ],
    );
  }

  Widget _buildNormalContent(BuildContext context, Color? textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (properties.icon != null)
          AppContainerBuilder.basic(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(bottom: 16),
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            borderRadius: 28,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 2,
            ),
            child: Icon(
              properties.icon,
              color: textColor ?? Colors.white,
              size: 24,
            ),
          ),
        
        const Spacer(),
        
        if (properties.title != null)
          Text(
            properties.title!,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: ThemeConstants.bold,
              fontSize: 18,
              height: 1.2,
              letterSpacing: 0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        
        if (properties.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            properties.subtitle!,
            style: TextStyle(
              color: (textColor ?? Colors.white).withValues(alpha: 0.9),
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        
        if (properties.content != null) ...[
          const SizedBox(height: 12),
          Text(
            properties.content!,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 14,
            ),
          ),
        ],
        
        if (properties.onTap != null) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppContainerBuilder.basic(
                padding: const EdgeInsets.all(8),
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                borderRadius: 8,
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  EdgeInsets? _convertMargin(EdgeInsetsGeometry? margin) {
    if (margin == null) return null;
    if (margin is EdgeInsets) return margin;
    
    // تحويل تقريبي للـ EdgeInsetsGeometry
    return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  }

  String _getColorKey() {
    if (properties.primaryColor != null) {
      for (final key in AppColorSystem.getAllKeys()) {
        if (AppColorSystem.getPrimaryColor(key) == properties.primaryColor) {
          return key;
        }
      }
    }
    
    switch (properties.type) {
      case CardType.athkar:
        return 'athkar';
      case CardType.quote:
        return 'verse';
      case CardType.info:
        return 'info';
      default:
        return 'primary';
    }
  }
  
  ComponentSize _getCardSize() {
    if (properties.content != null && properties.content!.length > 100) {
      return ComponentSize.lg;
    } else if (properties.type == CardType.athkar) {
      return ComponentSize.lg;
    }
    return ComponentSize.md;
  }
  
  bool _hasCounterData() => 
      properties.currentCount != null || properties.totalCount != null || 
      (properties.actions != null && properties.actions!.isNotEmpty);
  
  bool _hasMainContent() => 
      properties.content != null || properties.title != null;

  // ===== Factory Constructors الأساسية =====

  /// بطاقة بسيطة
  factory AppCard.simple({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: CardFactory.simple(
        title: title,
        subtitle: subtitle,
        icon: icon,
        onTap: onTap,
        primaryColor: primaryColor,
      ),
    );
  }

  /// بطاقة أذكار
  factory AppCard.athkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    bool isFavorite = false,
    Color? primaryColor,
    VoidCallback? onTap,
    VoidCallback? onFavoriteToggle,
    List<CardAction>? actions,
  }) {
    return AppCard(
      properties: CardFactory.athkar(
        content: content,
        source: source,
        fadl: fadl,
        currentCount: currentCount,
        totalCount: totalCount,
        isFavorite: isFavorite,
        primaryColor: primaryColor,
        onTap: onTap,
        onFavoriteToggle: onFavoriteToggle,
        actions: actions,
      ),
    );
  }

  /// بطاقة اقتباس
  factory AppCard.quote({
    required String quote,
    String? author,
    String? category,
    Color? primaryColor,
    List<Color>? gradientColors,
  }) {
    return AppCard(
      properties: CardFactory.quote(
        quote: quote,
        author: author,
        category: category,
        primaryColor: primaryColor,
        gradientColors: gradientColors,
      ),
    );
  }

  /// بطاقة معلومات
  factory AppCard.info({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return AppCard(
      properties: CardFactory.info(
        title: title,
        subtitle: subtitle,
        icon: icon,
        onTap: onTap,
        iconColor: iconColor,
        trailing: trailing,
      ),
    );
  }

  /// بطاقة فئة زجاجية
  factory AppCard.glassCategory({
    required String title,
    required IconData icon,
    required Color primaryColor,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      properties: CardFactory.glassCategory(
        title: title,
        icon: icon,
        primaryColor: primaryColor,
        onTap: onTap,
        margin: margin,
        padding: padding,
      ),
    );
  }

  /// ذكر الصباح
  factory AppCard.morningAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return AppCard(
      properties: CardFactory.athkar(
        content: content,
        source: source,
        fadl: fadl,
        currentCount: currentCount,
        totalCount: totalCount,
        onTap: onTap,
        actions: actions,
        primaryColor: ThemeConstants.primary,
      ),
    );
  }

  /// ذكر المساء
  factory AppCard.eveningAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return AppCard(
      properties: CardFactory.athkar(
        content: content,
        source: source,
        fadl: fadl,
        currentCount: currentCount,
        totalCount: totalCount,
        onTap: onTap,
        actions: actions,
        primaryColor: ThemeConstants.accent,
      ),
    );
  }

  /// ذكر النوم
  factory AppCard.sleepAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return AppCard(
      properties: CardFactory.athkar(
        content: content,
        source: source,
        fadl: fadl,
        currentCount: currentCount,
        totalCount: totalCount,
        onTap: onTap,
        actions: actions,
        primaryColor: ThemeConstants.tertiary,
      ),
    );
  }

  /// آية قرآنية
  factory AppCard.verse({
    required String verse,
    String? surah,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: CardFactory.quote(
        quote: verse,
        author: surah,
        category: 'آية قرآنية',
        primaryColor: primaryColor ?? ThemeConstants.primary,
        gradientColors: [
          primaryColor ?? ThemeConstants.primary,
          (primaryColor ?? ThemeConstants.primary).darken(0.2),
        ],
      ),
    );
  }

  /// حديث نبوي
  factory AppCard.hadith({
    required String hadith,
    String? narrator,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: CardFactory.quote(
        quote: hadith,
        author: narrator,
        category: 'حديث شريف',
        primaryColor: primaryColor ?? ThemeConstants.accent,
        gradientColors: [
          primaryColor ?? ThemeConstants.accent,
          (primaryColor ?? ThemeConstants.accent).darken(0.2),
        ],
      ),
    );
  }

  /// دعاء مأثور
  factory AppCard.dua({
    required String dua,
    String? source,
    Color? primaryColor,
  }) {
    return AppCard(
      properties: CardFactory.quote(
        quote: dua,
        author: source,
        category: 'دعاء مأثور',
        primaryColor: primaryColor ?? ThemeConstants.tertiary,
        gradientColors: [
          primaryColor ?? ThemeConstants.tertiary,
          (primaryColor ?? ThemeConstants.tertiary).darken(0.2),
        ],
      ),
    );
  }
}

// ===== Extensions مفيدة =====

/// Extensions للألوان
extension ColorExtensions on Color {
  Color withOpacitySafe(double opacity) {
    final safeOpacity = opacity.clamp(0.0, 1.0);
    return withValues(alpha: safeOpacity);
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Color get contrastingTextColor {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }
}

/// Extensions للنصوص
extension AppColorSystemExtension on String {
  Color get primaryColor => AppColorSystem.getPrimaryColor(this);
  Color get lightColor => AppColorSystem.getLightColor(this);
  Color get darkColor => AppColorSystem.getDarkColor(this);
  LinearGradient get gradient => AppColorSystem.getGradient(this);
  Color shadowColor([double opacity = 0.3]) => AppColorSystem.getShadowColor(this, opacity: opacity);
}

/// Extensions للأحجام
extension ComponentSizeExtension on ComponentSize {
  double get height => AppSizeSystem.getHeight(this);
  double get iconSize => AppSizeSystem.getIconSize(this);
  EdgeInsets get padding => AppSizeSystem.getPadding(this);
}

/// Extensions للـ Context
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  
  // الألوان الأساسية
  Color get primaryColor => ThemeConstants.primary;
  Color get primaryLightColor => ThemeConstants.primaryLight;
  Color get primaryDarkColor => ThemeConstants.primaryDark;
  Color get accentColor => ThemeConstants.accent;
  Color get accentLightColor => ThemeConstants.accentLight;
  Color get accentDarkColor => ThemeConstants.accentDark;
  Color get tertiaryColor => ThemeConstants.tertiary;
  Color get tertiaryLightColor => ThemeConstants.tertiaryLight;
  Color get tertiaryDarkColor => ThemeConstants.tertiaryDark;
  
  // الألوان الدلالية
  Color get successColor => ThemeConstants.success;
  Color get errorColor => ThemeConstants.error;
  Color get warningColor => ThemeConstants.warning;
  Color get infoColor => ThemeConstants.info;
  
  // ألوان النصوص
  Color get textPrimaryColor => ThemeConstants.textPrimary(this);
  Color get textSecondaryColor => ThemeConstants.textSecondary(this);
  
  // حالة الثيم
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => !isDarkMode;
  
  // معلومات الشاشة
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
  
  // نوع الجهاز
  bool get isMobile => screenWidth < ThemeConstants.breakpointMobile;
  bool get isTablet => screenWidth >= ThemeConstants.breakpointMobile && screenWidth < ThemeConstants.breakpointTablet;
  bool get isDesktop => screenWidth >= ThemeConstants.breakpointTablet;
  
  // الحجم المتجاوب
  ComponentSize get responsiveSize => AppSizeSystem.getResponsiveSize(this);
}

/// Extensions للـ Widget
extension WidgetExtensions on Widget {
  // الحاويات
  Widget container({
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    double? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return AppContainerBuilder.basic(
      child: this,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      shadows: shadows,
    );
  }

  Widget gradientContainer({
    required List<Color> colors,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    return AppContainerBuilder.gradient(
      child: this,
      colors: colors,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
    );
  }

  Widget glassContainer({
    double blur = 10,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    return AppContainerBuilder.glass(
      child: this,
      blur: blur,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
    );
  }

  Widget cardContainer({
    ComponentSize size = ComponentSize.md,
    String? colorKey,
    bool withGlass = false,
    EdgeInsets? margin,
  }) {
    return AppContainerBuilder.card(
      child: this,
      size: size,
      colorKey: colorKey,
      withGlass: withGlass,
      margin: margin,
    );
  }

  // التأثيرات
  Widget glass({
    double blur = 10,
    GlassIntensity intensity = GlassIntensity.medium,
    EdgeInsets? padding,
  }) {
    return GlassEffect.wrap(this, blur: blur, intensity: intensity, padding: padding);
  }

  Widget shadow({
    ShadowIntensity intensity = ShadowIntensity.medium,
    Color? color,
    double? borderRadius,
  }) {
    final shadows = color != null 
        ? AppShadowSystem.colored(color: color, intensity: intensity)
        : intensity == ShadowIntensity.light ? AppShadowSystem.light :
          intensity == ShadowIntensity.medium ? AppShadowSystem.medium :
          intensity == ShadowIntensity.strong ? AppShadowSystem.strong : AppShadowSystem.intense;
        
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius) : null,
        boxShadow: shadows,
      ),
      child: this,
    );
  }

  // التخطيط
  Widget padded(EdgeInsetsGeometry padding) => Padding(padding: padding, child: this);
  Widget get centered => Center(child: this);
  Widget get expanded => Expanded(child: this);
}

/// Extensions للأرقام
extension NumberExtensions on num {
  SizedBox get w => SizedBox(width: toDouble());
  SizedBox get h => SizedBox(height: toDouble());
  EdgeInsets get all => EdgeInsets.all(toDouble());
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
  BorderRadius get circular => BorderRadius.circular(toDouble());
}

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
    final Color onPrimaryColor = primaryColor.contrastingTextColor;
    final Color onSecondaryColor = ThemeConstants.accent.contrastingTextColor;

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
        onTertiary: ThemeConstants.accentLight.contrastingTextColor,
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
}