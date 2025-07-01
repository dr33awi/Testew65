// lib/app/themes/core/systems/app_shadow_system.dart - النسخة النظيفة المنفصلة
import 'package:flutter/material.dart';
import '../../theme_constants.dart';

/// نظام الظلال الموحد - منفصل بالكامل
class AppShadowSystem {
  AppShadowSystem._();

  // ===== الظلال الأساسية - بدون ألوان =====
  
  /// ظل خفيف جداً
  static List<BoxShadow> get none => [];
  
  /// ظل خفيف للعناصر البسيطة
  static List<BoxShadow> get light => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  /// ظل متوسط للبطاقات
  static List<BoxShadow> get medium => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  /// ظل قوي للعناصر المرتفعة
  static List<BoxShadow> get strong => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  /// ظل شديد للحوارات والعناصر العائمة
  static List<BoxShadow> get intense => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  // ===== ظلال ملونة =====
  
  /// ظل ملون مخصص
  static List<BoxShadow> colored({
    required Color color,
    ShadowIntensity intensity = ShadowIntensity.medium,
    double opacity = 0.3,
  }) {
    final config = _getShadowConfig(intensity);
    
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: config.blurRadius,
        offset: config.offset,
        spreadRadius: config.spreadRadius,
      ),
    ];
  }
  
  /// ظل ملون متدرج
  static List<BoxShadow> coloredGradient({
    required Color color,
    ShadowIntensity intensity = ShadowIntensity.medium,
    double opacity = 0.4,
  }) {
    final config = _getShadowConfig(intensity);
    
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: config.blurRadius,
        offset: config.offset,
        spreadRadius: config.spreadRadius,
      ),
      BoxShadow(
        color: color.withValues(alpha: opacity * 0.5),
        blurRadius: config.blurRadius * 0.5,
        offset: Offset(config.offset.dx * 0.5, config.offset.dy * 0.5),
        spreadRadius: 0,
      ),
    ];
  }

  // ===== ظلال متخصصة =====
  
  /// ظل للبطاقات الزجاجية
  static List<BoxShadow> glass({
    Color color = Colors.black,
    double opacity = 0.1,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: -4,
      ),
    ];
  }
  
  /// ظل للأزرار العائمة
  static List<BoxShadow> floating({
    Color color = Colors.black,
    double opacity = 0.12,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: 12,
        offset: const Offset(0, 6),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: color.withValues(alpha: opacity * 0.5),
        blurRadius: 4,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ];
  }
  
  /// ظل داخلي (inset)
  static List<BoxShadow> inset({
    Color color = Colors.black,
    double opacity = 0.1,
    double blurRadius = 4,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blurRadius,
        offset: const Offset(0, 2),
        spreadRadius: -2,
      ),
    ];
  }
  
  /// ظل للنصوص
  static List<Shadow> textShadow({
    Color color = Colors.black,
    double opacity = 0.3,
    double blurRadius = 2,
    Offset offset = const Offset(0, 1),
  }) {
    return [
      Shadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }

  // ===== ظلال حسب الارتفاع (Material Design) =====
  
  /// الحصول على ظل حسب الارتفاع
  static List<BoxShadow> elevation(double elevation) {
    if (elevation <= 0) return none;
    if (elevation <= 2) return light;
    if (elevation <= 4) return medium;
    if (elevation <= 8) return strong;
    return intense;
  }

  // ===== ظلال متجاوبة =====
  
  /// ظل متجاوب حسب حجم الشاشة
  static List<BoxShadow> responsive(BuildContext context, {
    ShadowIntensity mobileIntensity = ShadowIntensity.light,
    ShadowIntensity tabletIntensity = ShadowIntensity.medium,
    ShadowIntensity desktopIntensity = ShadowIntensity.strong,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    
    if (width < ThemeConstants.breakpointMobile) {
      return _getBasicShadow(mobileIntensity);
    } else if (width < ThemeConstants.breakpointTablet) {
      return _getBasicShadow(tabletIntensity);
    } else {
      return _getBasicShadow(desktopIntensity);
    }
  }

  // ===== ظلال مُسبقة الإعداد للمكونات =====
  
  /// ظل للبطاقات
  static List<BoxShadow> get card => medium;
  
  /// ظل للأزرار
  static List<BoxShadow> get button => light;
  
  /// ظل للحوارات
  static List<BoxShadow> get dialog => intense;
  
  /// ظل للقوائم المنسدلة
  static List<BoxShadow> get dropdown => strong;
  
  /// ظل لشريط التطبيق
  static List<BoxShadow> get appBar => light;
  
  /// ظل للعناصر المحددة
  static List<BoxShadow> selected({required Color color}) => colored(
    color: color,
    intensity: ShadowIntensity.medium,
    opacity: 0.25,
  );
  
  /// ظل للعناصر المعطلة
  static List<BoxShadow> get disabled => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  // ===== دوال مساعدة =====
  
  /// إعداد الظل حسب الشدة
  static _ShadowConfig _getShadowConfig(ShadowIntensity intensity) {
    switch (intensity) {
      case ShadowIntensity.none:
        return const _ShadowConfig(
          blurRadius: 0,
          offset: Offset.zero,
          spreadRadius: 0,
        );
      case ShadowIntensity.light:
        return const _ShadowConfig(
          blurRadius: 4,
          offset: Offset(0, 2),
          spreadRadius: 0,
        );
      case ShadowIntensity.medium:
        return const _ShadowConfig(
          blurRadius: 8,
          offset: Offset(0, 4),
          spreadRadius: 0,
        );
      case ShadowIntensity.strong:
        return const _ShadowConfig(
          blurRadius: 16,
          offset: Offset(0, 8),
          spreadRadius: 0,
        );
      case ShadowIntensity.intense:
        return const _ShadowConfig(
          blurRadius: 24,
          offset: Offset(0, 12),
          spreadRadius: 0,
        );
    }
  }
  
  /// الحصول على الظل الأساسي حسب الشدة
  static List<BoxShadow> _getBasicShadow(ShadowIntensity intensity) {
    switch (intensity) {
      case ShadowIntensity.none:
        return none;
      case ShadowIntensity.light:
        return light;
      case ShadowIntensity.medium:
        return medium;
      case ShadowIntensity.strong:
        return strong;
      case ShadowIntensity.intense:
        return intense;
    }
  }
}

/// شدة الظل
enum ShadowIntensity {
  none,     // بدون ظل
  light,    // ظل خفيف
  medium,   // ظل متوسط
  strong,   // ظل قوي
  intense,  // ظل شديد
}

/// إعداد الظل
class _ShadowConfig {
  final double blurRadius;
  final Offset offset;
  final double spreadRadius;

  const _ShadowConfig({
    required this.blurRadius,
    required this.offset,
    required this.spreadRadius,
  });
}

/// Extension لتسهيل الاستخدام
extension ShadowExtension on Widget {
  /// إضافة ظل للـ Widget
  Widget shadow({
    ShadowIntensity intensity = ShadowIntensity.medium,
    Color? color,
    double? borderRadius,
  }) {
    final shadows = color != null 
        ? AppShadowSystem.colored(color: color, intensity: intensity)
        : AppShadowSystem._getBasicShadow(intensity);
        
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius != null 
            ? BorderRadius.circular(borderRadius) 
            : null,
        boxShadow: shadows,
      ),
      child: this,
    );
  }
  
  /// إضافة ظل ملون
  Widget coloredShadow({
    required Color color,
    ShadowIntensity intensity = ShadowIntensity.medium,
    double opacity = 0.3,
    double? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius != null 
            ? BorderRadius.circular(borderRadius) 
            : null,
        boxShadow: AppShadowSystem.colored(
          color: color,
          intensity: intensity,
          opacity: opacity,
        ),
      ),
      child: this,
    );
  }
  
  /// إضافة ظل زجاجي
  Widget glassShadow({
    Color color = Colors.black,
    double opacity = 0.1,
    double? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius != null 
            ? BorderRadius.circular(borderRadius) 
            : null,
        boxShadow: AppShadowSystem.glass(color: color, opacity: opacity),
      ),
      child: this,
    );
  }
}