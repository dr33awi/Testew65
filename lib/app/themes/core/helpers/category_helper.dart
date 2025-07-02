// lib/app/themes/core/helpers/category_helper.dart - بدون Extensions مكررة
import 'package:flutter/material.dart';
import '../systems/app_color_system.dart';
import '../systems/app_icons_system.dart';

/// مساعد الفئات - مبسط ويعيد التوجيه فقط (بدون تكرار)
class CategoryHelper {
  CategoryHelper._();

  // ===== إعادة التوجيه للأنظمة الموحدة - بدون تكرار =====
  
  static Color getCategoryColor(String categoryId) => 
      AppColorSystem.getCategoryColor(categoryId);

  static Color getCategoryLightColor(String categoryId) => 
      AppColorSystem.getCategoryLightColor(categoryId);

  static Color getCategoryDarkColor(String categoryId) => 
      AppColorSystem.getCategoryDarkColor(categoryId);

  static IconData getCategoryIcon(String categoryId) => 
      AppIconsSystem.getCategoryIcon(categoryId);

  static LinearGradient getCategoryGradient(String categoryId) => 
      AppColorSystem.getCategoryGradient(categoryId);

  // ===== البيانات الفريدة لـ CategoryHelper فقط =====

  /// الحصول على وصف الفئة - المنطق الوحيد المتبقي هنا
  static String getCategoryDescription(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return 'أذكار بعد صلاة الفجر';
      case 'evening':
      case 'المساء':
        return 'أذكار بعد صلاة المغرب';
      case 'sleep':
      case 'النوم':
        return 'أذكار قبل النوم';
      case 'prayer':
      case 'بعد الصلاة':
        return 'أذكار بعد كل صلاة';
      case 'prayer_times':
        return 'أوقات الصلوات الخمس';
      case 'qibla':
        return 'البوصلة الإسلامية';
      case 'tasbih':
        return 'تسبيح رقمي';
      case 'quran':
        return 'القرآن الكريم';
      case 'dua':
        return 'الأدعية المأثورة';
      default:
        return '';
    }
  }

  /// التحقق من ضرورة التفعيل التلقائي
  static bool shouldAutoEnable(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
      case 'evening':
      case 'المساء':
        return true;
      default:
        return false;
    }
  }

  /// الحصول على الوقت الافتراضي للتذكير
  static TimeOfDay getDefaultReminderTime(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return const TimeOfDay(hour: 7, minute: 0);
      case 'evening':
      case 'المساء':
        return const TimeOfDay(hour: 18, minute: 0);
      case 'sleep':
      case 'النوم':
        return const TimeOfDay(hour: 22, minute: 0);
      case 'prayer':
      case 'بعد الصلاة':
        return const TimeOfDay(hour: 12, minute: 0);
      default:
        return const TimeOfDay(hour: 12, minute: 0);
    }
  }

  /// الحصول على أولوية الفئة للترتيب
  static int getCategoryPriority(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'prayer_times': return 1;
      case 'morning':
      case 'الصباح': return 2;
      case 'evening':
      case 'المساء': return 3;
      case 'prayer':
      case 'بعد الصلاة': return 4;
      case 'sleep':
      case 'النوم': return 5;
      case 'qibla': return 6;
      case 'tasbih': return 7;
      case 'quran': return 8;
      case 'dua': return 9;
      default: return 99;
    }
  }

  // ===== دوال التصنيف والفلترة =====

  /// ترتيب الفئات حسب الأولوية
  static List<T> sortCategoriesByPriority<T>(
    List<T> categories,
    String Function(T) getIdFunction,
  ) {
    final sortedList = List<T>.from(categories);
    sortedList.sort((a, b) {
      final priorityA = getCategoryPriority(getIdFunction(a));
      final priorityB = getCategoryPriority(getIdFunction(b));
      return priorityA.compareTo(priorityB);
    });
    return sortedList;
  }

  /// فلترة الفئات الأساسية فقط
  static List<T> filterEssentialCategories<T>(
    List<T> categories,
    String Function(T) getIdFunction,
  ) {
    return categories.where((category) {
      return shouldAutoEnable(getIdFunction(category));
    }).toList();
  }
}

