// lib/features/athkar/utils/category_utils.dart
import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../models/athkar_model.dart';

/// مساعدات لإدارة فئات الأذكار
class CategoryUtils {
  CategoryUtils._();

  /// الحصول على أيقونة الفئة
  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'morning':
      case 'أذكار_الصباح':
        return Icons.wb_sunny;
      case 'evening':
      case 'أذكار_المساء':
        return Icons.nights_stay;
      case 'after_prayer':
      case 'أذكار_بعد_الصلاة':
        return Icons.mosque;
      case 'sleep':
      case 'أذكار_النوم':
        return Icons.bedtime;
      case 'wake_up':
      case 'أذكار_الاستيقاظ':
        return Icons.wb_twilight;
      case 'eating':
      case 'أذكار_الطعام':
        return Icons.restaurant;
      case 'travel':
      case 'أذكار_السفر':
        return Icons.flight;
      case 'istighfar':
      case 'الاستغفار':
        return Icons.favorite;
      case 'tasbih':
      case 'التسبيح':
        return Icons.touch_app;
      case 'dua':
      case 'الأدعية':
        return Icons.pan_tool;
      case 'quran':
      case 'القرآن':
        return Icons.book;
      case 'hadith':
      case 'الحديث':
        return Icons.format_quote;
      case 'friday':
      case 'أذكار_الجمعة':
        return Icons.calendar_month;
      case 'ramadan':
      case 'أذكار_رمضان':
        return Icons.star_half;
      case 'hajj':
      case 'أذكار_الحج':
        return Icons.home;
      case 'protection':
      case 'أذكار_الحماية':
        return Icons.security;
      case 'forgiveness':
      case 'أذكار_المغفرة':
        return Icons.healing;
      case 'gratitude':
      case 'أذكار_الشكر':
        return Icons.volunteer_activism;
      case 'guidance':
      case 'أذكار_الهداية':
        return Icons.explore;
      case 'health':
      case 'أذكار_الصحة':
        return Icons.health_and_safety;
      case 'knowledge':
      case 'أذكار_العلم':
        return Icons.school;
      case 'work':
      case 'أذكار_العمل':
        return Icons.work;
      case 'family':
      case 'أذكار_الأسرة':
        return Icons.family_restroom;
      case 'weather':
      case 'أذكار_الطقس':
        return Icons.cloud;
      case 'difficulties':
      case 'أذكار_الصعوبات':
        return Icons.support;
      default:
        return Icons.menu_book;
    }
  }

  /// الحصول على لون الفئة
  static Color getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'morning':
      case 'أذكار_الصباح':
        return const Color(0xFFFFB74D); // أصفر برتقالي للصباح
      case 'evening':
      case 'أذكار_المساء':
        return const Color(0xFF7986CB); // بنفسجي للمساء
      case 'after_prayer':
      case 'أذكار_بعد_الصلاة':
        return ThemeConstants.primary; // أخضر للصلاة
      case 'sleep':
      case 'أذكار_النوم':
        return const Color(0xFF64B5F6); // أزرق هادئ للنوم
      case 'wake_up':
      case 'أذكار_الاستيقاظ':
        return const Color(0xFFFFCC02); // أصفر للاستيقاظ
      case 'eating':
      case 'أذكار_الطعام':
        return const Color(0xFF81C784); // أخضر فاتح للطعام
      case 'travel':
      case 'أذكار_السفر':
        return const Color(0xFF4FC3F7); // أزرق سماوي للسفر
      case 'istighfar':
      case 'الاستغفار':
        return const Color(0xFFE57373); // وردي للاستغفار
      case 'tasbih':
      case 'التسبيح':
        return const Color(0xFFBA68C8); // بنفسجي للتسبيح
      case 'dua':
      case 'الأدعية':
        return const Color(0xFF9CCC65); // أخضر للأدعية
      case 'quran':
      case 'القرآن':
        return const Color(0xFF4DB6AC); // تركوازي للقرآن
      case 'hadith':
      case 'الحديث':
        return const Color(0xFFFFB74D); // برتقالي للحديث
      case 'friday':
      case 'أذكار_الجمعة':
        return const Color(0xFF7986CB); // بنفسجي للجمعة
      case 'ramadan':
      case 'أذكار_رمضان':
        return const Color(0xFFFFD54F); // ذهبي لرمضان
      case 'hajj':
      case 'أذكار_الحج':
        return const Color(0xFF8D6E63); // بني للحج
      case 'protection':
      case 'أذكار_الحماية':
        return const Color(0xFF66BB6A); // أخضر للحماية
      case 'forgiveness':
      case 'أذكار_المغفرة':
        return const Color(0xFFAB47BC); // بنفسجي للمغفرة
      case 'gratitude':
      case 'أذكار_الشكر':
        return const Color(0xFFEF5350); // أحمر وردي للشكر
      case 'guidance':
      case 'أذكار_الهداية':
        return const Color(0xFF42A5F5); // أزرق للهداية
      case 'health':
      case 'أذكار_الصحة':
        return const Color(0xFF66BB6A); // أخضر للصحة
      case 'knowledge':
      case 'أذكار_العلم':
        return const Color(0xFF5C6BC0); // أزرق للعلم
      case 'work':
      case 'أذكار_العمل':
        return const Color(0xFF8BC34A); // أخضر للعمل
      case 'family':
      case 'أذكار_الأسرة':
        return const Color(0xFFFF8A65); // برتقالي للأسرة
      case 'weather':
      case 'أذكار_الطقس':
        return const Color(0xFF78909C); // رمادي للطقس
      case 'difficulties':
      case 'أذكار_الصعوبات':
        return const Color(0xFFA1887F); // بني فاتح للصعوبات
      default:
        return ThemeConstants.primary;
    }
  }

  /// الحصول على الوصف الافتراضي للفئة
  static String getCategoryDescription(String categoryId) {
    switch (categoryId) {
      case 'morning':
      case 'أذكار_الصباح':
        return 'أذكار تقال في الصباح لبركة اليوم وحفظ الله';
      case 'evening':
      case 'أذكار_المساء':
        return 'أذكار تقال في المساء للحماية والطمأنينة';
      case 'after_prayer':
      case 'أذكار_بعد_الصلاة':
        return 'أذكار تقال بعد الانتهاء من الصلاة';
      case 'sleep':
      case 'أذكار_النوم':
        return 'أذكار تقال قبل النوم للحماية والراحة';
      case 'wake_up':
      case 'أذكار_الاستيقاظ':
        return 'أذكار تقال عند الاستيقاظ من النوم';
      case 'eating':
      case 'أذكار_الطعام':
        return 'أذكار الطعام والشراب والدعاء قبل وبعد الأكل';
      case 'travel':
      case 'أذكار_السفر':
        return 'أذكار وأدعية السفر والرحلات';
      case 'istighfar':
      case 'الاستغفار':
        return 'أذكار الاستغفار وطلب المغفرة من الله';
      case 'tasbih':
      case 'التسبيح':
        return 'تسبيح الله وتنزيهه عن كل نقص';
      case 'dua':
      case 'الأدعية':
        return 'أدعية مختارة من القرآن والسنة';
      case 'quran':
      case 'القرآن':
        return 'آيات قرآنية للتلاوة والتدبر';
      case 'hadith':
      case 'الحديث':
        return 'أحاديث نبوية شريفة';
      case 'friday':
      case 'أذكار_الجمعة':
        return 'أذكار وأدعية خاصة بيوم الجمعة';
      case 'ramadan':
      case 'أذكار_رمضان':
        return 'أذكار وأدعية شهر رمضان المبارك';
      case 'hajj':
      case 'أذكار_الحج':
        return 'أذكار وأدعية الحج والعمرة';
      case 'protection':
      case 'أذكار_الحماية':
        return 'أذكار الحماية من الشر والمكروه';
      case 'forgiveness':
      case 'أذكار_المغفرة':
        return 'أذكار طلب المغفرة والتوبة';
      case 'gratitude':
      case 'أذكار_الشكر':
        return 'أذكار الشكر والحمد لله';
      case 'guidance':
      case 'أذكار_الهداية':
        return 'أذكار طلب الهداية والرشاد';
      case 'health':
      case 'أذكار_الصحة':
        return 'أذكار الصحة والعافية';
      case 'knowledge':
      case 'أذكار_العلم':
        return 'أذكار طلب العلم والحكمة';
      case 'work':
      case 'أذكار_العمل':
        return 'أذكار العمل والرزق';
      case 'family':
      case 'أذكار_الأسرة':
        return 'أذكار وأدعية للأسرة والأهل';
      case 'weather':
      case 'أذكار_الطقس':
        return 'أذكار المطر والرياح والطقس';
      case 'difficulties':
      case 'أذكار_الصعوبات':
        return 'أذكار وأدعية في أوقات الصعوبات والضيق';
      default:
        return 'مجموعة مختارة من الأذكار والأدعية';
    }
  }

  /// الحصول على الوقت الافتراضي للتذكير
  static TimeOfDay? getDefaultNotifyTime(String categoryId) {
    switch (categoryId) {
      case 'morning':
      case 'أذكار_الصباح':
        return const TimeOfDay(hour: 7, minute: 0);
      case 'evening':
      case 'أذكار_المساء':
        return const TimeOfDay(hour: 18, minute: 0);
      case 'after_prayer':
      case 'أذكار_بعد_الصلاة':
        return null; // يعتمد على أوقات الصلاة
      case 'sleep':
      case 'أذكار_النوم':
        return const TimeOfDay(hour: 22, minute: 0);
      case 'wake_up':
      case 'أذكار_الاستيقاظ':
        return const TimeOfDay(hour: 6, minute: 0);
      case 'eating':
      case 'أذكار_الطعام':
        return const TimeOfDay(hour: 12, minute: 0);
      case 'friday':
      case 'أذكار_الجمعة':
        return const TimeOfDay(hour: 10, minute: 0);
      case 'istighfar':
      case 'الاستغفار':
        return const TimeOfDay(hour: 15, minute: 0);
      case 'tasbih':
      case 'التسبيح':
        return const TimeOfDay(hour: 20, minute: 0);
      default:
        return null;
    }
  }

  /// تصنيف الفئات حسب النوع
  static List<String> getCategoriesByType(CategoryType type) {
    switch (type) {
      case CategoryType.daily:
        return [
          'morning',
          'evening',
          'sleep',
          'wake_up',
          'eating',
          'after_prayer',
        ];
      case CategoryType.special:
        return [
          'friday',
          'ramadan',
          'hajj',
          'travel',
        ];
      case CategoryType.spiritual:
        return [
          'istighfar',
          'tasbih',
          'dua',
          'quran',
          'hadith',
        ];
      case CategoryType.protection:
        return [
          'protection',
          'difficulties',
          'health',
        ];
      case CategoryType.gratitude:
        return [
          'gratitude',
          'forgiveness',
          'guidance',
        ];
      case CategoryType.life:
        return [
          'work',
          'family',
          'knowledge',
          'weather',
        ];
    }
  }

  /// الحصول على نوع الفئة
  static CategoryType getCategoryType(String categoryId) {
    for (final type in CategoryType.values) {
      if (getCategoriesByType(type).contains(categoryId)) {
        return type;
      }
    }
    return CategoryType.daily;
  }

  /// الحصول على اسم نوع الفئة
  static String getCategoryTypeName(CategoryType type) {
    switch (type) {
      case CategoryType.daily:
        return 'الأذكار اليومية';
      case CategoryType.special:
        return 'المناسبات الخاصة';
      case CategoryType.spiritual:
        return 'الأذكار الروحانية';
      case CategoryType.protection:
        return 'الحماية والعافية';
      case CategoryType.gratitude:
        return 'الشكر والتوبة';
      case CategoryType.life:
        return 'أذكار الحياة';
    }
  }

  /// ترتيب الفئات حسب الأولوية
  static List<AthkarCategory> sortCategoriesByPriority(List<AthkarCategory> categories) {
    final priorityOrder = <String>[
      'morning',
      'أذكار_الصباح',
      'evening', 
      'أذكار_المساء',
      'after_prayer',
      'أذكار_بعد_الصلاة',
      'sleep',
      'أذكار_النوم',
      'wake_up',
      'أذكار_الاستيقاظ',
      'friday',
      'أذكار_الجمعة',
      'istighfar',
      'الاستغفار',
      'tasbih',
      'التسبيح',
      'protection',
      'أذكار_الحماية',
    ];

    categories.sort((a, b) {
      final aIndex = priorityOrder.indexOf(a.id);
      final bIndex = priorityOrder.indexOf(b.id);
      
      // إذا كانت الفئة في قائمة الأولوية
      if (aIndex != -1 && bIndex != -1) {
        return aIndex.compareTo(bIndex);
      } else if (aIndex != -1) {
        return -1; // a أولى
      } else if (bIndex != -1) {
        return 1; // b أولى
      } else {
        // ترتيب أبجدي للفئات الأخرى
        return a.title.compareTo(b.title);
      }
    });

    return categories;
  }

  /// فلترة الفئات حسب النوع
  static List<AthkarCategory> filterCategoriesByType(
    List<AthkarCategory> categories,
    CategoryType type,
  ) {
    final typeCategories = getCategoriesByType(type);
    return categories.where((cat) => typeCategories.contains(cat.id)).toList();
  }

  /// البحث في الفئات
  static List<AthkarCategory> searchCategories(
    List<AthkarCategory> categories,
    String query,
  ) {
    if (query.isEmpty) return categories;

    final normalizedQuery = query.toLowerCase().trim();
    
    return categories.where((category) {
      return category.title.toLowerCase().contains(normalizedQuery) ||
             (category.description?.toLowerCase().contains(normalizedQuery) ?? false) ||
             getCategoryDescription(category.id).toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  /// إحصائيات الفئة
  static CategoryStats calculateCategoryStats(
    AthkarCategory category,
    Map<int, int> progress,
  ) {
    int totalCount = 0;
    int completedCount = 0;
    int itemsCompleted = 0;

    for (final item in category.athkar) {
      totalCount += item.count;
      final itemProgress = progress[item.id] ?? 0;
      completedCount += itemProgress.clamp(0, item.count);
      
      if (itemProgress >= item.count) {
        itemsCompleted++;
      }
    }

    final percentage = totalCount > 0 ? (completedCount / totalCount * 100).round() : 0;
    final isCompleted = completedCount >= totalCount;

    return CategoryStats(
      totalItems: category.athkar.length,
      completedItems: itemsCompleted,
      totalCount: totalCount,
      completedCount: completedCount,
      percentage: percentage,
      isCompleted: isCompleted,
    );
  }
}

/// أنواع فئات الأذكار
enum CategoryType {
  daily,      // يومية
  special,    // مناسبات خاصة
  spiritual,  // روحانية
  protection, // حماية
  gratitude,  // شكر وتوبة
  life,       // حياة
}

/// إحصائيات الفئة
class CategoryStats {
  final int totalItems;
  final int completedItems;
  final int totalCount;
  final int completedCount;
  final int percentage;
  final bool isCompleted;

  const CategoryStats({
    required this.totalItems,
    required this.completedItems,
    required this.totalCount,
    required this.completedCount,
    required this.percentage,
    required this.isCompleted,
  });
}