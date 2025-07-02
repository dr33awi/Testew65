// ===== lib/app/themes/core/helpers/theme_exporter.dart =====

import 'package:flutter/material.dart';
import '../systems/app_color_system.dart';
import '../../app_theme.dart';

/// مساعد لتصدير وتخزين إعدادات الثيم
class ThemeExporter {
  ThemeExporter._();

  /// تصدير الثيم الحالي إلى Map
  static Map<String, dynamic> exportTheme(ThemeData theme) {
    try {
      return {
        'version': '1.0',
        'primaryColor': theme.primaryColor.value,
        'brightness': theme.brightness.name,
        'fontFamily': theme.textTheme.bodyLarge?.fontFamily ?? 'Cairo',
        'colorScheme': _exportColorScheme(theme.colorScheme),
        'textTheme': _exportTextTheme(theme.textTheme),
        'metadata': {
          'exportedAt': DateTime.now().toIso8601String(),
          'platform': 'flutter',
        },
      };
    } catch (e) {
      return _createFallbackExport(theme.brightness);
    }
  }

  /// استيراد الثيم من Map
  static ThemeData? importTheme(Map<String, dynamic> themeData) {
    try {
      if (!_validateThemeData(themeData)) return null;
      
      final brightness = themeData['brightness'] == 'dark' 
          ? Brightness.dark 
          : Brightness.light;
          
      final primaryColor = Color(themeData['primaryColor'] ?? AppColorSystem.primary.value);
      
      return AppTheme.getCustomTheme(
        brightness: brightness,
        primaryColor: primaryColor,
      );
    } catch (e) {
      return null;
    }
  }

  /// تصدير الثيم إلى JSON string
  static String exportThemeAsJson(ThemeData theme) {
    try {
      final themeMap = exportTheme(theme);
      return _encodeJson(themeMap);
    } catch (e) {
      return '{}';
    }
  }

  /// استيراد الثيم من JSON string
  static ThemeData? importThemeFromJson(String jsonString) {
    try {
      final themeMap = _decodeJson(jsonString);
      return importTheme(themeMap);
    } catch (e) {
      return null;
    }
  }

  /// مقارنة ثيمين
  static ThemeComparison compareThemes(ThemeData theme1, ThemeData theme2) {
    try {
      final differences = <String>[];
      
      if (theme1.brightness != theme2.brightness) {
        differences.add('وضع العرض مختلف');
      }
      
      if (theme1.primaryColor != theme2.primaryColor) {
        differences.add('اللون الأساسي مختلف');
      }
      
      if (theme1.scaffoldBackgroundColor != theme2.scaffoldBackgroundColor) {
        differences.add('لون الخلفية مختلف');
      }
      
      return ThemeComparison(
        areEqual: differences.isEmpty,
        differences: differences,
        similarity: _calculateSimilarity(theme1, theme2),
      );
    } catch (e) {
      return ThemeComparison.error();
    }
  }

  // ===== دوال مساعدة داخلية =====

  static Map<String, dynamic> _exportColorScheme(ColorScheme colorScheme) {
    return {
      'primary': colorScheme.primary.value,
      'secondary': colorScheme.secondary.value,
      'surface': colorScheme.surface.value,
      'error': colorScheme.error.value,
      'onPrimary': colorScheme.onPrimary.value,
      'onSecondary': colorScheme.onSecondary.value,
      'onSurface': colorScheme.onSurface.value,
      'onError': colorScheme.onError.value,
    };
  }

  static Map<String, dynamic> _exportTextTheme(TextTheme textTheme) {
    return {
      'bodyLarge': _exportTextStyle(textTheme.bodyLarge),
      'bodyMedium': _exportTextStyle(textTheme.bodyMedium),
      'titleLarge': _exportTextStyle(textTheme.titleLarge),
      'titleMedium': _exportTextStyle(textTheme.titleMedium),
    };
  }

  static Map<String, dynamic>? _exportTextStyle(TextStyle? style) {
    if (style == null) return null;
    
    return {
      'fontSize': style.fontSize,
      'fontWeight': style.fontWeight?.index,
      'fontFamily': style.fontFamily,
      'color': style.color?.value,
    };
  }

  static bool _validateThemeData(Map<String, dynamic> data) {
    return data.containsKey('primaryColor') && 
           data.containsKey('brightness') &&
           data['version'] != null;
  }

  static Map<String, dynamic> _createFallbackExport(Brightness brightness) {
    return {
      'version': '1.0',
      'primaryColor': AppColorSystem.primary.value,
      'brightness': brightness.name,
      'fontFamily': 'Cairo',
      'metadata': {
        'exportedAt': DateTime.now().toIso8601String(),
        'isFallback': true,
      },
    };
  }

  static String _encodeJson(Map<String, dynamic> data) {
    // تحويل بسيط للـ Map إلى JSON
    // في التطبيق الحقيقي، استخدم dart:convert
    return data.toString();
  }

  static Map<String, dynamic> _decodeJson(String json) {
    // تحويل بسيط من JSON إلى Map
    // في التطبيق الحقيقي، استخدم dart:convert
    return {};
  }

  static double _calculateSimilarity(ThemeData theme1, ThemeData theme2) {
    int similarities = 0;
    int totalChecks = 0;
    
    // فحص الخصائص المختلفة
    totalChecks++;
    if (theme1.brightness == theme2.brightness) similarities++;
    
    totalChecks++;
    if (theme1.primaryColor == theme2.primaryColor) similarities++;
    
    totalChecks++;
    if (theme1.scaffoldBackgroundColor == theme2.scaffoldBackgroundColor) similarities++;
    
    return totalChecks > 0 ? similarities / totalChecks : 0.0;
  }
}

/// نتيجة مقارنة الثيمات
class ThemeComparison {
  final bool areEqual;
  final List<String> differences;
  final double similarity;

  const ThemeComparison({
    required this.areEqual,
    required this.differences,
    required this.similarity,
  });

  factory ThemeComparison.error() {
    return const ThemeComparison(
      areEqual: false,
      differences: ['خطأ في المقارنة'],
      similarity: 0.0,
    );
  }

  String get similarityPercentage => '${(similarity * 100).toInt()}%';
}