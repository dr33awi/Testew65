// lib/app/themes/utils/category_utils.dart - مبسّطة ومنظّفة
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/widgets.dart';

/// أدوات مساعدة للفئات - مبسّطة تماماً
class CategoryUtils {
  CategoryUtils._();

  // ========== دوال الفئات الأساسية فقط ==========

  /// وصف مفصل للفئات
  static String getDescription(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return 'أذكار الصباح والاستيقاظ - تُقرأ بعد صلاة الفجر وحتى طلوع الشمس';
      case 'evening':
      case 'المساء':
        return 'أذكار المساء والمغرب - تُقرأ بعد صلاة العصر وحتى المغرب';
      case 'sleep':
      case 'النوم':
        return 'أذكار النوم والاضطجاع - تُقرأ عند النوم وعند الاستيقاظ ليلاً';
      case 'prayer':
      case 'الصلاة':
        return 'أذكار الصلاة والوضوء - تُقرأ عند الوضوء وبعد الصلوات';
      case 'eating':
      case 'الطعام':
        return 'أذكار الطعام والشراب - تُقرأ قبل وبعد الأكل والشرب';
      case 'travel':
      case 'السفر':
        return 'أذكار السفر والطريق - تُقرأ عند السفر والركوب';
      case 'quran':
      case 'القرآن':
        return 'آيات وسور قرآنية مختارة للحفظ والتلاوة';
      case 'tasbih':
      case 'التسبيح':
        return 'التسبيح والتحميد والتكبير والتهليل';
      case 'dua':
      case 'الدعاء':
        return 'أدعية منوعة من القرآن والسنة';
      case 'general':
      case 'عامة':
        return 'أذكار وأدعية عامة لجميع الأوقات';
      default:
        return 'أذكار وأدعية متنوعة';
    }
  }

  /// تحديد ما إذا كان يجب عرض الوقت للفئة
  static bool shouldShowTime(String categoryId) {
    const timeBasedCategories = {
      'morning', 'الصباح',
      'evening', 'المساء',
      'sleep', 'النوم',
      'wakeup', 'الاستيقاظ',
    };
    return timeBasedCategories.contains(categoryId.toLowerCase());
  }

  /// التحقق من مناسبة الفئة للوقت الحالي
  static bool isAppropriateForTime(String categoryId, [DateTime? time]) {
    final hour = (time ?? DateTime.now()).hour;
    
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return hour >= 5 && hour < 12;
      case 'evening':
      case 'المساء':
        return hour >= 15 && hour < 20;
      case 'sleep':
      case 'النوم':
        return hour >= 21 || hour < 5;
      default:
        return true; // الفئات الأخرى مناسبة في أي وقت
    }
  }

  /// بناء قائمة الفئات باستخدام النظام الموحد
  static Widget buildCategoriesList({
    required List<String> categories,
    required Map<String, int> categoryCounts,
    required Map<String, String> categoryTitles,
    required Function(String) onCategoryTap,
    bool isCompact = false,
  }) {
    // استخدام النظام المركزي للترتيب
    final sortedCategories = AppTheme.sortByPriority(
      categories, 
      (category) => AppTheme.getCategoryPriority(category),
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedCategories.length,
      itemBuilder: (context, index) {
        final categoryId = sortedCategories[index];
        final title = categoryTitles[categoryId] ?? categoryId;
        final count = categoryCounts[categoryId] ?? 0;

        return AppCard.category(
          categoryId: categoryId,
          title: title,
          count: count,
          onTap: () => onCategoryTap(categoryId),
          showDescription: !isCompact,
          isCompact: isCompact,
          customDescription: getDescription(categoryId),
        );
      },
    );
  }

  /// بناء شبكة الفئات باستخدام النظام الموحد
  static Widget buildCategoriesGrid({
    required List<String> categories,
    required Map<String, int> categoryCounts,
    required Map<String, String> categoryTitles,
    required Function(String) onCategoryTap,
    int crossAxisCount = 2,
  }) {
    // استخدام النظام المركزي للترتيب
    final sortedCategories = AppTheme.sortByPriority(
      categories, 
      (category) => AppTheme.getCategoryPriority(category),
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppTheme.space3,
        mainAxisSpacing: AppTheme.space3,
      ),
      itemCount: sortedCategories.length,
      itemBuilder: (context, index) {
        final categoryId = sortedCategories[index];
        final title = categoryTitles[categoryId] ?? categoryId;
        final count = categoryCounts[categoryId] ?? 0;

        return AppCard.category(
          categoryId: categoryId,
          title: title,
          count: count,
          onTap: () => onCategoryTap(categoryId),
          isCompact: true,
        );
      },
    );
  }

  /// فلترة الفئات حسب النص - استخدام النظام المركزي
  static List<String> filterByText(
    List<String> categories,
    String searchText,
    Map<String, String> categoryTitles,
  ) {
    return AppTheme.filterByText(
      categories,
      searchText,
      (category) => [
        category,
        categoryTitles[category] ?? category,
        getDescription(category),
      ],
    );
  }

  /// فلترة الفئات المناسبة للوقت الحالي
  static List<String> filterForCurrentTime(List<String> categories) {
    return categories.where((category) {
      return isAppropriateForTime(category);
    }).toList();
  }

  /// الحصول على الفئات الأساسية فقط
  static List<String> getEssentialCategories(List<String> categories) {
    return categories.where(AppTheme.isEssentialCategory).toList();
  }
}

