// lib/app/themes/core/helpers/theme_validator.dart
import 'package:flutter/material.dart';

/// مساعد للتحقق من صحة إعدادات الثيم
class ThemeValidator {
  ThemeValidator._();

  /// التحقق من صحة الثيم
  static bool validateTheme(ThemeData? theme) {
    if (theme == null) return false;
    
    try {
      return theme.primaryColor != null &&
             theme.colorScheme != null &&
             theme.textTheme != null &&
             theme.textTheme.bodyLarge != null;
    } catch (e) {
      return false;
    }
  }

  /// الحصول على قائمة بمشاكل الثيم
  static List<String> getThemeIssues(ThemeData? theme) {
    final issues = <String>[];
    
    if (theme == null) {
      issues.add('الثيم غير موجود');
      return issues;
    }

    try {
      if (theme.primaryColor == null) {
        issues.add('اللون الأساسي مفقود');
      }
      
      if (theme.colorScheme == null) {
        issues.add('نظام الألوان مفقود');
      }
      
      if (theme.textTheme == null) {
        issues.add('أنماط النصوص مفقودة');
      } else if (theme.textTheme.bodyLarge == null) {
        issues.add('نمط النص الأساسي مفقود');
      }
      
      if (theme.scaffoldBackgroundColor == null) {
        issues.add('لون خلفية الصفحة مفقود');
      }
      
      if (theme.appBarTheme == null) {
        issues.add('ثيم شريط التطبيق مفقود');
      }
    } catch (e) {
      issues.add('خطأ في تحليل الثيم: ${e.toString()}');
    }
    
    return issues;
  }

  /// التحقق من تباين الألوان
  static bool hasGoodColorContrast(ThemeData theme) {
    try {
      final primaryColor = theme.primaryColor;
      final backgroundColor = theme.scaffoldBackgroundColor;
      
      if (primaryColor == null || backgroundColor == null) return false;
      
      final primaryLuminance = primaryColor.computeLuminance();
      final backgroundLuminance = backgroundColor.computeLuminance();
      
      final contrast = (primaryLuminance + 0.05) / (backgroundLuminance + 0.05);
      return contrast >= 3.0; // نسبة تباين مقبولة
    } catch (e) {
      return false;
    }
  }

  /// تقرير شامل عن صحة الثيم
  static ThemeHealthReport getThemeHealthReport(ThemeData? theme) {
    final issues = getThemeIssues(theme);
    final isValid = validateTheme(theme);
    final hasGoodContrast = theme != null ? hasGoodColorContrast(theme) : false;
    
    return ThemeHealthReport(
      isValid: isValid,
      hasGoodContrast: hasGoodContrast,
      issues: issues,
      score: _calculateThemeScore(isValid, hasGoodContrast, issues.length),
    );
  }

  static int _calculateThemeScore(bool isValid, bool hasGoodContrast, int issuesCount) {
    int score = 0;
    if (isValid) score += 50;
    if (hasGoodContrast) score += 30;
    score -= issuesCount * 5;
    return score.clamp(0, 100);
  }
}

/// تقرير صحة الثيم
class ThemeHealthReport {
  final bool isValid;
  final bool hasGoodContrast;
  final List<String> issues;
  final int score;

  const ThemeHealthReport({
    required this.isValid,
    required this.hasGoodContrast,
    required this.issues,
    required this.score,
  });

  bool get isHealthy => isValid && hasGoodContrast && issues.isEmpty;
  String get grade {
    if (score >= 90) return 'ممتاز';
    if (score >= 80) return 'جيد جداً';
    if (score >= 70) return 'جيد';
    if (score >= 60) return 'مقبول';
    return 'يحتاج تحسين';
  }
}



