import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

/// أدوات مساعدة لفئات الأذكار
class CategoryUtils {
  /// الحصول على أيقونة مناسبة لكل فئة
  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'morning':
        return Icons.wb_sunny;
      case 'evening':
        return Icons.wb_twilight;
      case 'sleep':
        return Icons.nights_stay;
      case 'wakeup':
        return Icons.alarm;
      default:
        return Icons.auto_awesome;
    }
  }

  /// الحصول على لون من الثيم بناءً على نوع الفئة
  static Color getCategoryThemeColor(String categoryId) {
    switch (categoryId) {
      case 'morning':
        return ThemeConstants.primary;
      case 'evening':
        return ThemeConstants.primaryDark;
      case 'sleep':
        return ThemeConstants.tertiary;
      case 'wakeup':
        return ThemeConstants.accent;
      default:
        return ThemeConstants.primary;
    }
  }
}
