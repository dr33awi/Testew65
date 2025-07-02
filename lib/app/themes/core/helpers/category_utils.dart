// lib/features/athkar/utils/category_utils.dart - محدث ومدموج مع النظام الموحد
import 'package:athkar_app/app/themes/core/helpers/category_helper.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';

/// أدوات مساعدة لفئات الأذكار - موحدة مع CategoryHelper
/// 
/// ملاحظة: هذا الملف يعمل كـ wrapper للنظام الموحد
/// لضمان التوافق مع الكود الموجود، مع إعادة توجيه جميع الاستدعاءات
/// إلى CategoryHelper الموحد في نظام التصميم
class CategoryUtils {
  CategoryUtils._();

  /// الحصول على أيقونة مناسبة لكل فئة
  /// ✅ إعادة توجيه إلى CategoryHelper الموحد
  static IconData getCategoryIcon(String categoryId) {
    return CategoryHelper.getCategoryIcon(categoryId);
  }

  /// الحصول على لون من الثيم بناءً على نوع الفئة
  /// ✅ إعادة توجيه إلى CategoryHelper الموحد
  static Color getCategoryThemeColor(String categoryId) {
    // ملاحظة: نحتاج BuildContext للألوان الموحدة
    // هذه الدالة للتوافق مع الكود القديم فقط
    // يُفضل استخدام CategoryHelper.getCategoryColor(context, categoryId)
    return _getStaticCategoryColor(categoryId);
  }

  /// الحصول على تدرج لوني مناسب لكل فئة
  /// ✅ محدث لاستخدام CategoryHelper
  static LinearGradient getCategoryGradient(String categoryId) {
    final baseColor = _getStaticCategoryColor(categoryId);
    return LinearGradient(
      colors: [
        baseColor.withOpacity(0.8),
        baseColor,
        _darkenColor(baseColor, 0.1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// الحصول على وصف مناسب لكل فئة
  /// ✅ إعادة توجيه إلى CategoryHelper الموحد
  static String getCategoryDescription(String categoryId) {
    return CategoryHelper.getCategoryDescription(categoryId);
  }

  /// التحقق من أن الفئة من الفئات الأساسية
  /// ✅ إعادة توجيه إلى CategoryHelper الموحد
  static bool isEssentialCategory(String categoryId) {
    return CategoryHelper.shouldAutoEnable(categoryId);
  }

  /// تحديد ما إذا كان يجب عرض الوقت للفئة
  /// ✅ وظيفة محلية مفيدة
  static bool shouldShowTime(String categoryId) {
    // إخفاء الوقت لفئات الصباح والمساء والنوم
    const hiddenTimeCategories = {
      'morning',
      'الصباح',
      'evening', 
      'المساء',
      'sleep',
      'النوم',
    };
    return !hiddenTimeCategories.contains(categoryId.toLowerCase());
  }

  /// الحصول على أولوية العرض للفئة (أقل رقم = أولوية أعلى)
  /// ✅ وظيفة محلية مفيدة للترتيب
  static int getCategoryPriority(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return 1;
      case 'evening':
      case 'المساء':
        return 2;
      case 'prayer':
      case 'الصلاة':
        return 3;
      case 'sleep':
      case 'النوم':
        return 4;
      case 'wakeup':
      case 'الاستيقاظ':
        return 5;
      case 'eating':
      case 'الطعام':
        return 6;
      case 'quran':
      case 'القرآن':
        return 7;
      case 'tasbih':
      case 'التسبيح':
        return 8;
      case 'dua':
      case 'الدعاء':
        return 9;
      case 'istighfar':
      case 'الاستغفار':
        return 10;
      case 'friday':
      case 'الجمعة':
        return 11;
      case 'travel':
      case 'السفر':
        return 12;
      case 'ramadan':
      case 'رمضان':
        return 13;
      case 'hajj':
      case 'الحج':
        return 14;
      case 'eid':
      case 'العيد':
        return 15;
      case 'illness':
      case 'المرض':
        return 16;
      case 'rain':
      case 'المطر':
        return 17;
      case 'wind':
      case 'الرياح':
        return 18;
      case 'general':
      case 'عامة':
        return 19;
      default:
        return 99;
    }
  }

  // ✅ دوال مساعدة إضافية للتوافق مع الكود الموجود

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
      return isEssentialCategory(getIdFunction(category));
    }).toList();
  }

  /// تجميع الفئات حسب النوع
  static Map<String, List<T>> groupCategoriesByType<T>(
    List<T> categories,
    String Function(T) getIdFunction,
  ) {
    final Map<String, List<T>> grouped = {
      'daily': [], // أذكار يومية
      'prayer': [], // أذكار الصلاة
      'special': [], // مناسبات خاصة
      'general': [], // عامة
    };

    for (final category in categories) {
      final id = getIdFunction(category).toLowerCase();
      
      if (['morning', 'الصباح', 'evening', 'المساء', 'sleep', 'النوم'].contains(id)) {
        grouped['daily']!.add(category);
      } else if (['prayer', 'الصلاة', 'wakeup', 'الاستيقاظ'].contains(id)) {
        grouped['prayer']!.add(category);
      } else if (['friday', 'الجمعة', 'ramadan', 'رمضان', 'hajj', 'الحج', 'eid', 'العيد'].contains(id)) {
        grouped['special']!.add(category);
      } else {
        grouped['general']!.add(category);
      }
    }

    return grouped;
  }

  // ===== دوال داخلية للتوافق =====

  /// الحصول على لون ثابت بدون BuildContext (للتوافق فقط)
  /// ⚠️ يُفضل استخدام CategoryHelper.getCategoryColor(context, categoryId)
  static Color _getStaticCategoryColor(String categoryId) {
    switch (categoryId.toLowerCase()) {
      // أذكار الأوقات
      case 'morning':
      case 'الصباح':
      case 'صباح':
        return const Color(0xFFDAA520); // ذهبي فاتح كالشروق
      case 'evening':
      case 'المساء':
      case 'مساء':
        return const Color(0xFF8B6F47); // بني دافئ كالغروب
      case 'sleep':
      case 'النوم':
      case 'نوم':
        return const Color(0xFF2D352D); // داكن أنيق للليل
      case 'wakeup':
      case 'wake_up':
      case 'الاستيقاظ':
      case 'استيقاظ':
      case 'wake':
        return const Color(0xFF7A8B6F); // أخضر زيتي فاتح للنهار
      
      // أذكار العبادة
      case 'prayer':
      case 'الصلاة':
      case 'صلاة':
      case 'prayers':
        return const Color(0xFF445A3B); // أخضر زيتي داكن مقدس
      case 'eating':
      case 'food':
      case 'الطعام':
      case 'طعام':
      case 'الأكل':
      case 'أكل':
        return const Color(0xFF6B8E5A); // أخضر طبيعي للطعام
      case 'home':
      case 'house':
      case 'المنزل':
      case 'منزل':
      case 'البيت':
      case 'بيت':
        return const Color(0xFF8B7355); // بني دافئ للمنزل
      case 'travel':
      case 'السفر':
      case 'سفر':
        return const Color(0xFF5F7C8A); // أزرق رمادي للسفر
      
      // باقي الفئات
      case 'general':
      case 'عامة':
      case 'عام':
        return const Color(0xFF8B7355); // بني متوسط متوازن
      case 'quran':
      case 'القرآن':
      case 'قرآن':
        return const Color(0xFF704214); // بني داكن كالمصحف
      case 'tasbih':
      case 'التسبيح':
      case 'تسبيح':
        return const Color(0xFF4A6741); // أخضر داكن روحاني
      case 'dua':
      case 'الدعاء':
      case 'دعاء':
        return const Color(0xFF6B4C7C); // بنفسجي داكن للدعاء
      default:
        return const Color(0xFF5D7052); // اللون الأساسي الافتراضي
    }
  }

  // ===== دالة داخلية لتغميق اللون =====
  
  /// تغميق اللون - دالة داخلية لتجنب التضارب مع Extensions
  static Color _darkenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
    }
  }