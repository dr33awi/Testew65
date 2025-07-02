// lib/app/themes/core/helpers/category_helper.dart - مساعد الفئات الموحد
import 'package:flutter/material.dart';
import '../systems/app_color_system.dart';
import '../systems/app_icons_system.dart';

/// مساعد موحد للفئات في التطبيق
class CategoryHelper {
  CategoryHelper._();

  /// الحصول على لون الفئة
  static Color getCategoryColor(BuildContext context, String categoryId) {
    return AppColorSystem.getCategoryColor(categoryId);
  }

  /// الحصول على لون الفئة الفاتح
  static Color getCategoryLightColor(String categoryId) {
    return AppColorSystem.getCategoryLightColor(categoryId);
  }

  /// الحصول على لون الفئة الداكن
  static Color getCategoryDarkColor(String categoryId) {
    return AppColorSystem.getCategoryDarkColor(categoryId);
  }

  /// الحصول على أيقونة الفئة
  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'prayer_times':
      case 'مواقيت الصلاة':
        return AppIconsSystem.prayerTime;
      case 'athkar':
      case 'الأذكار':
        return AppIconsSystem.athkar;
      case 'qibla':
      case 'اتجاه القبلة':
        return AppIconsSystem.qibla;
      case 'tasbih':
      case 'المسبحة':
        return Icons.radio_button_checked;
      case 'quran':
      case 'القرآن':
        return AppIconsSystem.quran;
      case 'dua':
      case 'الدعاء':
        return AppIconsSystem.dua;
      case 'morning':
      case 'الصباح':
        return AppIconsSystem.morningAthkar;
      case 'evening':
      case 'المساء':
        return AppIconsSystem.eveningAthkar;
      case 'sleep':
      case 'النوم':
        return AppIconsSystem.sleepAthkar;
      case 'prayer':
      case 'بعد الصلاة':
        return AppIconsSystem.prayerAthkar;
      default:
        return AppIconsSystem.athkar;
    }
  }

  /// الحصول على تدرج لوني للفئة
  static LinearGradient getCategoryGradient(String categoryId) {
    return AppColorSystem.getCategoryGradient(categoryId);
  }

  /// الحصول على وصف الفئة
  static String getCategoryDescription(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'prayer_times':
        return 'أوقات الصلوات الخمس';
      case 'athkar':
        return 'أذكار الصباح والمساء';
      case 'qibla':
        return 'البوصلة الإسلامية';
      case 'tasbih':
        return 'تسبيح رقمي';
      case 'quran':
        return 'القرآن الكريم';
      case 'dua':
        return 'الأدعية المأثورة';
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
      default:
        return '';
    }
  }

  /// التحقق من ضرورة التفعيل التلقائي للفئة
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

  /// الحصول على لون النص المناسب للفئة
  static Color getCategoryTextColor(String categoryId, {bool isDark = false}) {
    return Colors.white;
  }

  /// الحصول على أولوية الفئة للترتيب
  static int getCategoryPriority(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'prayer_times':
        return 1;
      case 'athkar':
        return 2;
      case 'qibla':
        return 3;
      case 'tasbih':
        return 4;
      case 'quran':
        return 5;
      case 'dua':
        return 6;
      default:
        return 99;
    }
  }

  /// تحديد ما إذا كانت الفئة متاحة
  static bool isCategoryAvailable(String categoryId) {
    // يمكن إضافة منطق للتحقق من توفر الفئة
    return true;
  }

  /// الحصول على رسالة التطوير للفئة
  static String getDevelopmentMessage(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'qibla':
        return 'البوصلة الإسلامية قيد التطوير';
      case 'tasbih':
        return 'المسبحة الرقمية قيد التطوير';
      default:
        return 'هذه الميزة قيد التطوير';
    }
  }
}

/// Extension لتسهيل الاستخدام
extension CategoryExtension on String {
  /// الحصول على لون الفئة
  Color getCategoryColor(BuildContext context) => 
      CategoryHelper.getCategoryColor(context, this);
  
  /// الحصول على أيقونة الفئة
  IconData get categoryIcon => CategoryHelper.getCategoryIcon(this);
  
  /// الحصول على وصف الفئة
  String get categoryDescription => CategoryHelper.getCategoryDescription(this);
  
  /// الحصول على تدرج الفئة
  LinearGradient get categoryGradient => CategoryHelper.getCategoryGradient(this);
}