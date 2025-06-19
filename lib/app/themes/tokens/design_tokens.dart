// lib/app/themes/tokens/design_tokens.dart
// نظام Design Tokens - قرارات التصميم المركزية

import 'package:flutter/material.dart';

/// نظام الـ Design Tokens - يحتوي على جميع قرارات التصميم
/// هذا النظام يمكّنك من تغيير التصميم بالكامل من مكان واحد
class DesignTokens {
  DesignTokens._();
  
  // ==================== Color Tokens ====================
  
  /// الألوان الأولية (Raw Colors)
  static const Map<String, Color> _colorPalette = {
    // Primary Family
    'green-50': Color(0xFFF0F9F0),
    'green-100': Color(0xFFDCF2DC),
    'green-200': Color(0xFFB8E5B8),
    'green-300': Color(0xFF8FA584),
    'green-400': Color(0xFF7A8B6F),
    'green-500': Color(0xFF5D7052), // Primary
    'green-600': Color(0xFF445A3B),
    'green-700': Color(0xFF2D3D28),
    'green-800': Color(0xFF1E2A1B),
    'green-900': Color(0xFF141A12),
    
    // Secondary Family (Gold)
    'gold-50': Color(0xFFFFFBF0),
    'gold-100': Color(0xFFFEF3C7),
    'gold-200': Color(0xFFFDE68A),
    'gold-300': Color(0xFFDAA520),
    'gold-400': Color(0xFFB8860B),
    'gold-500': Color(0xFF996515), // Secondary
    'gold-600': Color(0xFF7C5311),
    'gold-700': Color(0xFF5F400D),
    'gold-800': Color(0xFF422D09),
    'gold-900': Color(0xFF2A1C06),
    
    // Tertiary Family (Brown)
    'brown-50': Color(0xFFFAF8F5),
    'brown-100': Color(0xFFF0EBE1),
    'brown-200': Color(0xFFE1D5C3),
    'brown-300': Color(0xFFA68B5B),
    'brown-400': Color(0xFF8B6F47),
    'brown-500': Color(0xFF6B5637), // Tertiary
    'brown-600': Color(0xFF5A462C),
    'brown-700': Color(0xFF493621),
    'brown-800': Color(0xFF382616),
    'brown-900': Color(0xFF27180E),
    
    // Semantic Colors
    'success-light': Color(0xFF10B981),
    'success-dark': Color(0xFF059669),
    'error-light': Color(0xFFEF4444),
    'error-dark': Color(0xFFDC2626),
    'warning-light': Color(0xFFF59E0B),
    'warning-dark': Color(0xFFD97706),
    'info-light': Color(0xFF3B82F6),
    'info-dark': Color(0xFF2563EB),
    
    // Neutral Colors
    'neutral-50': Color(0xFFFAFAF8),
    'neutral-100': Color(0xFFF5F5F0),
    'neutral-200': Color(0xFFE0DDD4),
    'neutral-300': Color(0xFFBBB8B0),
    'neutral-400': Color(0xFF8F8B85),
    'neutral-500': Color(0xFF5F5F5F),
    'neutral-600': Color(0xFF4A4A4A),
    'neutral-700': Color(0xFF2D2D2D),
    'neutral-800': Color(0xFF1A1A1A),
    'neutral-900': Color(0xFF0D0D0D),
  };
  
  // ==================== Semantic Color Tokens ====================
  
  /// ألوان الأساس
  static Color get primaryBase => _colorPalette['green-500']!;
  static Color get primaryLight => _colorPalette['green-400']!;
  static Color get primaryDark => _colorPalette['green-600']!;
  static Color get primarySoft => _colorPalette['green-300']!;
  
  static Color get secondaryBase => _colorPalette['gold-400']!;
  static Color get secondaryLight => _colorPalette['gold-300']!;
  static Color get secondaryDark => _colorPalette['gold-500']!;
  
  static Color get tertiaryBase => _colorPalette['brown-400']!;
  static Color get tertiaryLight => _colorPalette['brown-300']!;
  static Color get tertiaryDark => _colorPalette['brown-500']!;
  
  /// ألوان الحالة
  static Color get successBase => _colorPalette['success-light']!;
  static Color get errorBase => _colorPalette['error-light']!;
  static Color get warningBase => _colorPalette['warning-light']!;
  static Color get infoBase => _colorPalette['info-light']!;
  
  /// ألوان الخلفيات
  static Color get backgroundPrimary => _colorPalette['neutral-50']!;
  static Color get backgroundSecondary => _colorPalette['neutral-100']!;
  static Color get backgroundTertiary => _colorPalette['neutral-200']!;
  
  static Color get surfacePrimary => Colors.white;
  static Color get surfaceSecondary => _colorPalette['neutral-50']!;
  static Color get surfaceTertiary => _colorPalette['neutral-100']!;
  
  /// ألوان النصوص
  static Color get textPrimary => _colorPalette['neutral-700']!;
  static Color get textSecondary => _colorPalette['neutral-500']!;
  static Color get textTertiary => _colorPalette['neutral-400']!;
  static Color get textHint => _colorPalette['neutral-300']!;
  
  // ==================== Dark Mode Colors ====================
  
  static Color get darkBackgroundPrimary => _colorPalette['neutral-900']!;
  static Color get darkBackgroundSecondary => _colorPalette['neutral-800']!;
  static Color get darkSurfacePrimary => _colorPalette['neutral-800']!;
  static Color get darkSurfaceSecondary => _colorPalette['neutral-700']!;
  
  static Color get darkTextPrimary => _colorPalette['neutral-50']!;
  static Color get darkTextSecondary => _colorPalette['neutral-300']!;
  
  // ==================== Spacing Tokens ====================
  
  /// نظام المساحات 8px
  static const double _baseUnit = 8.0;
  
  static const Map<String, double> spacingTokens = {
    'space-0': 0,
    'space-1': _baseUnit * 0.5,  // 4px
    'space-2': _baseUnit,        // 8px
    'space-3': _baseUnit * 1.5,  // 12px
    'space-4': _baseUnit * 2,    // 16px
    'space-5': _baseUnit * 2.5,  // 20px
    'space-6': _baseUnit * 3,    // 24px
    'space-8': _baseUnit * 4,    // 32px
    'space-10': _baseUnit * 5,   // 40px
    'space-12': _baseUnit * 6,   // 48px
    'space-16': _baseUnit * 8,   // 64px
    'space-20': _baseUnit * 10,  // 80px
    'space-24': _baseUnit * 12,  // 96px
  };
  
  // ==================== Typography Tokens ====================
  
  static const Map<String, double> fontSizeTokens = {
    'text-xs': 10,    // Extra small
    'text-sm': 12,    // Small
    'text-base': 14,  // Base size
    'text-lg': 16,    // Large
    'text-xl': 18,    // Extra large
    'text-2xl': 20,   // 2x large
    'text-3xl': 24,   // 3x large
    'text-4xl': 32,   // 4x large
    'text-5xl': 48,   // 5x large
    'text-6xl': 64,   // 6x large
  };
  
  static const Map<String, FontWeight> fontWeightTokens = {
    'font-light': FontWeight.w300,
    'font-normal': FontWeight.w400,
    'font-medium': FontWeight.w500,
    'font-semibold': FontWeight.w600,
    'font-bold': FontWeight.w700,
    'font-extrabold': FontWeight.w800,
  };
  
  static const Map<String, double> lineHeightTokens = {
    'leading-tight': 1.1,
    'leading-snug': 1.3,
    'leading-normal': 1.5,
    'leading-relaxed': 1.7,
    'leading-loose': 2.0,
  };
  
  // ==================== Border Radius Tokens ====================
  
  static const Map<String, double> radiusTokens = {
    'radius-none': 0,
    'radius-xs': 2,
    'radius-sm': 4,
    'radius-base': 6,
    'radius-md': 8,
    'radius-lg': 12,
    'radius-xl': 16,
    'radius-2xl': 20,
    'radius-3xl': 24,
    'radius-4xl': 32,
    'radius-full': 9999,
  };
  
  // ==================== Shadow Tokens ====================
  
  static const Map<String, List<BoxShadow>> shadowTokens = {
    'shadow-none': [],
    'shadow-sm': [
      BoxShadow(
        color: Color(0x0D000000),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
    ],
    'shadow-base': [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
    'shadow-md': [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
    'shadow-lg': [
      BoxShadow(
        color: Color(0x26000000),
        blurRadius: 16,
        offset: Offset(0, 8),
      ),
    ],
    'shadow-xl': [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
  };
  
  // ==================== Animation Tokens ====================
  
  static const Map<String, Duration> durationTokens = {
    'duration-instant': Duration(milliseconds: 0),
    'duration-fast': Duration(milliseconds: 150),
    'duration-normal': Duration(milliseconds: 300),
    'duration-slow': Duration(milliseconds: 500),
    'duration-slower': Duration(milliseconds: 750),
    'duration-slowest': Duration(milliseconds: 1000),
  };
  
  static const Map<String, Curve> easingTokens = {
    'ease-linear': Curves.linear,
    'ease-in': Curves.easeIn,
    'ease-out': Curves.easeOut,
    'ease-in-out': Curves.easeInOut,
    'ease-in-back': Curves.easeInBack,
    'ease-out-back': Curves.easeOutBack,
    'ease-in-out-back': Curves.easeInOutBack,
    'ease-elastic': Curves.elasticOut,
    'ease-bounce': Curves.bounceOut,
  };
  
  // ==================== Component Size Tokens ====================
  
  static const Map<String, double> componentSizeTokens = {
    // Button heights
    'button-sm': 32,
    'button-base': 40,
    'button-lg': 48,
    'button-xl': 56,
    
    // Icon sizes
    'icon-xs': 12,
    'icon-sm': 16,
    'icon-base': 20,
    'icon-md': 24,
    'icon-lg': 32,
    'icon-xl': 40,
    'icon-2xl': 48,
    
    // Input heights
    'input-sm': 32,
    'input-base': 40,
    'input-lg': 48,
    
    // App structure
    'app-bar-height': 56,
    'bottom-nav-height': 64,
    'tab-height': 48,
  };
  
  // ==================== Breakpoint Tokens ====================
  
  static const Map<String, double> breakpointTokens = {
    'screen-xs': 0,
    'screen-sm': 576,
    'screen-md': 768,
    'screen-lg': 992,
    'screen-xl': 1200,
    'screen-2xl': 1400,
  };
  
  // ==================== Helper Methods ====================
  
  /// الحصول على قيمة من الـ tokens
  static T getToken<T>(Map<String, T> tokens, String key, T fallback) {
    return tokens[key] ?? fallback;
  }
  
  /// الحصول على مساحة
  static double spacing(String key) => 
      getToken(spacingTokens, key, spacingTokens['space-4']!);
  
  /// الحصول على حجم خط
  static double fontSize(String key) => 
      getToken(fontSizeTokens, key, fontSizeTokens['text-base']!);
  
  /// الحصول على وزن خط
  static FontWeight fontWeight(String key) => 
      getToken(fontWeightTokens, key, fontWeightTokens['font-normal']!);
  
  /// الحصول على زاوية
  static double radius(String key) => 
      getToken(radiusTokens, key, radiusTokens['radius-base']!);
  
  /// الحصول على ظل
  static List<BoxShadow> shadow(String key) => 
      getToken(shadowTokens, key, shadowTokens['shadow-base']!);
  
  /// الحصول على مدة زمنية
  static Duration duration(String key) => 
      getToken(durationTokens, key, durationTokens['duration-normal']!);
  
  /// الحصول على منحنى
  static Curve easing(String key) => 
      getToken(easingTokens, key, easingTokens['ease-in-out']!);
  
  /// الحصول على حجم مكون
  static double componentSize(String key) => 
      getToken(componentSizeTokens, key, componentSizeTokens['button-base']!);
  
  // ==================== Context-Aware Tokens ====================
  
  /// إنشاء ColorScheme من الـ tokens
  static ColorScheme createColorScheme({bool isDark = false}) {
    if (isDark) {
      return ColorScheme.dark(
        primary: primaryBase,
        secondary: secondaryBase,
        tertiary: tertiaryBase,
        surface: darkSurfacePrimary,
        error: errorBase,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        onError: Colors.white,
      );
    } else {
      return ColorScheme.light(
        primary: primaryBase,
        secondary: secondaryBase,
        tertiary: tertiaryBase,
        surface: surfacePrimary,
        error: errorBase,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      );
    }
  }
  
  /// إنشاء TextTheme من الـ tokens
  static TextTheme createTextTheme({bool isDark = false}) {
    final textColor = isDark ? darkTextPrimary : textPrimary;
    final secondaryTextColor = isDark ? darkTextSecondary : textSecondary;
    
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: fontSize('text-6xl'),
        fontWeight: fontWeight('font-bold'),
        height: lineHeightTokens['leading-tight'],
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: fontSize('text-5xl'),
        fontWeight: fontWeight('font-bold'),
        height: lineHeightTokens['leading-tight'],
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: fontSize('text-4xl'),
        fontWeight: fontWeight('font-bold'),
        height: lineHeightTokens['leading-snug'],
        color: textColor,
      ),
      headlineLarge: TextStyle(
        fontSize: fontSize('text-3xl'),
        fontWeight: fontWeight('font-bold'),
        height: lineHeightTokens['leading-snug'],
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: fontSize('text-2xl'),
        fontWeight: fontWeight('font-semibold'),
        height: lineHeightTokens['leading-snug'],
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: fontSize('text-xl'),
        fontWeight: fontWeight('font-semibold'),
        height: lineHeightTokens['leading-snug'],
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: fontSize('text-lg'),
        fontWeight: fontWeight('font-semibold'),
        height: lineHeightTokens['leading-snug'],
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: fontSize('text-base'),
        fontWeight: fontWeight('font-medium'),
        height: lineHeightTokens['leading-normal'],
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: fontSize('text-sm'),
        fontWeight: fontWeight('font-medium'),
        height: lineHeightTokens['leading-normal'],
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: fontSize('text-lg'),
        fontWeight: fontWeight('font-normal'),
        height: lineHeightTokens['leading-relaxed'],
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: fontSize('text-base'),
        fontWeight: fontWeight('font-normal'),
        height: lineHeightTokens['leading-relaxed'],
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontSize: fontSize('text-sm'),
        fontWeight: fontWeight('font-normal'),
        height: lineHeightTokens['leading-normal'],
        color: secondaryTextColor,
      ),
      labelLarge: TextStyle(
        fontSize: fontSize('text-base'),
        fontWeight: fontWeight('font-medium'),
        height: lineHeightTokens['leading-snug'],
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontSize: fontSize('text-sm'),
        fontWeight: fontWeight('font-medium'),
        height: lineHeightTokens['leading-snug'],
        color: secondaryTextColor,
      ),
      labelSmall: TextStyle(
        fontSize: fontSize('text-xs'),
        fontWeight: fontWeight('font-medium'),
        height: lineHeightTokens['leading-snug'],
        color: secondaryTextColor,
      ),
    );
  }
}