// lib/app/themes/utils/category_utils.dart - مبسّط ومنظّف من التكرار
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/widgets.dart';

/// أدوات مساعدة للفئات - منظّفة ومعتمدة على النظام المركزي
class CategoryUtils {
  CategoryUtils._();

  // ========== الدوال الخاصة بالفئات فقط ==========

  /// وصف مفصل للفئات
  static String getCategoryDescription(String categoryId) {
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
      case 'wakeup':
      case 'الاستيقاظ':
        return 'أذكار الاستيقاظ من النوم - تُقرأ فور الاستيقاظ';
      case 'prayer':
      case 'الصلاة':
        return 'أذكار الصلاة والوضوء - تُقرأ عند الوضوء وبعد الصلوات';
      case 'eating':
      case 'الطعام':
        return 'أذكار الطعام والشراب - تُقرأ قبل وبعد الأكل والشرب';
      case 'home':
      case 'المنزل':
      case 'البيت':
        return 'أذكار دخول وخروج المنزل';
      case 'travel':
      case 'السفر':
        return 'أذكار السفر والطريق - تُقرأ عند السفر والركوب';
      case 'friday':
      case 'الجمعة':
        return 'أذكار وأدعية يوم الجمعة المبارك';
      case 'ramadan':
      case 'رمضان':
        return 'أذكار وأدعية شهر رمضان المبارك';
      case 'hajj':
      case 'الحج':
        return 'أذكار وأدعية الحج والعمرة';
      case 'eid':
      case 'العيد':
        return 'أذكار وتكبيرات العيدين';
      case 'illness':
      case 'المرض':
        return 'أذكار وأدعية المرض والشفاء';
      case 'rain':
      case 'المطر':
        return 'أذكار وأدعية نزول المطر';
      case 'wind':
      case 'الرياح':
        return 'أذكار الرياح والعواصف';
      case 'quran':
      case 'القرآن':
        return 'آيات وسور قرآنية مختارة للحفظ والتلاوة';
      case 'tasbih':
      case 'التسبيح':
        return 'التسبيح والتحميد والتكبير والتهليل';
      case 'dua':
      case 'الدعاء':
        return 'أدعية منوعة من القرآن والسنة';
      case 'istighfar':
      case 'الاستغفار':
        return 'أدعية الاستغفار والتوبة';
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
      'friday', 'الجمعة',
    };
    return timeBasedCategories.contains(categoryId.toLowerCase());
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
      
      if (['morning', 'الصباح', 'evening', 'المساء', 'sleep', 'النوم', 'wakeup', 'الاستيقاظ'].contains(id)) {
        grouped['daily']!.add(category);
      } else if (['prayer', 'الصلاة', 'eating', 'الطعام'].contains(id)) {
        grouped['prayer']!.add(category);
      } else if (['friday', 'الجمعة', 'ramadan', 'رمضان', 'hajj', 'الحج', 'eid', 'العيد'].contains(id)) {
        grouped['special']!.add(category);
      } else {
        grouped['general']!.add(category);
      }
    }

    return grouped;
  }

  /// فلترة الفئات الأساسية فقط
  static List<T> filterEssentialCategories<T>(
    List<T> categories,
    String Function(T) getIdFunction,
  ) {
    return categories.where((category) {
      return AppTheme.isEssentialCategory(getIdFunction(category));
    }).toList();
  }

  /// ترتيب الفئات حسب الأولوية - استخدام النظام المركزي
  static List<T> sortCategoriesByPriority<T>(
    List<T> categories,
    String Function(T) getIdFunction,
  ) {
    return AppTheme.sortByPriority(
      categories,
      (category) => AppTheme.getCategoryPriority(getIdFunction(category)),
    );
  }

  /// فلترة الفئات حسب النص - استخدام النظام المركزي
  static List<T> filterCategoriesByText<T>(
    List<T> categories,
    String searchText,
    String Function(T) getIdFunction,
    String Function(T) getTitleFunction,
  ) {
    return AppTheme.filterByText(
      categories,
      searchText,
      (category) => [
        getIdFunction(category),
        getTitleFunction(category),
        getCategoryDescription(getIdFunction(category)),
      ],
    );
  }

  /// الحصول على إحصائيات الفئات
  static Map<String, dynamic> getCategoriesStats(
    List<String> categories,
    Map<String, int> categoryCounts,
  ) {
    final totalCategories = categories.length;
    final totalAthkar = categoryCounts.values.fold(0, (sum, count) => sum + count);
    final essentialCategories = categories.where(AppTheme.isEssentialCategory).length;
    final activeCategories = categoryCounts.entries.where((entry) => entry.value > 0).length;

    return {
      'totalCategories': totalCategories,
      'totalAthkar': totalAthkar,
      'essentialCategories': essentialCategories,
      'activeCategories': activeCategories,
      'averagePerCategory': totalCategories > 0 ? (totalAthkar / totalCategories).round() : 0,
    };
  }

  /// الحصول على أفضل الفئات
  static List<String> getTopCategories({
    required Map<String, int> categoryCounts,
    int limit = 5,
  }) {
    final sortedEntries = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries
        .take(limit)
        .map((entry) => entry.key)
        .toList();
  }

  /// بناء كرت فئة - استخدام النظام الموحد
  static Widget buildCategoryCard({
    required String categoryId,
    required String title,
    required int count,
    VoidCallback? onTap,
    bool showDescription = true,
    bool isCompact = false,
  }) {
    return AppCard.category(
      categoryId: categoryId,
      title: title,
      count: count,
      onTap: onTap,
      showDescription: showDescription,
      isCompact: isCompact,
    );
  }

  /// بناء قائمة الفئات
  static Widget buildCategoriesList({
    required List<String> categories,
    required Map<String, int> categoryCounts,
    required Map<String, String> categoryTitles,
    required Function(String) onCategoryTap,
    bool isCompact = false,
  }) {
    final sortedCategories = sortCategoriesByPriority(
      categories, 
      (category) => category,
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedCategories.length,
      itemBuilder: (context, index) {
        final categoryId = sortedCategories[index];
        final title = categoryTitles[categoryId] ?? categoryId;
        final count = categoryCounts[categoryId] ?? 0;

        return buildCategoryCard(
          categoryId: categoryId,
          title: title,
          count: count,
          onTap: () => onCategoryTap(categoryId),
          showDescription: !isCompact,
          isCompact: isCompact,
        );
      },
    );
  }

  /// بناء شبكة الفئات
  static Widget buildCategoriesGrid({
    required List<String> categories,
    required Map<String, int> categoryCounts,
    required Map<String, String> categoryTitles,
    required Function(String) onCategoryTap,
    int crossAxisCount = 2,
  }) {
    final sortedCategories = sortCategoriesByPriority(
      categories, 
      (category) => category,
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

        return buildCategoryCard(
          categoryId: categoryId,
          title: title,
          count: count,
          onTap: () => onCategoryTap(categoryId),
          isCompact: true,
        );
      },
    );
  }

  /// بناء شريحة إحصائيات الفئات
  static Widget buildCategoriesStatsCard({
    required List<String> categories,
    required Map<String, int> categoryCounts,
  }) {
    final stats = getCategoriesStats(categories, categoryCounts);
    
    return AppCard(
      useGradient: true,
      color: AppTheme.info,
      child: Column(
        children: [
          Text(
            'إحصائيات الفئات',
            style: AppTheme.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.semiBold,
            ),
          ),
          AppTheme.space3.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('الفئات', '${stats['totalCategories']}'),
              _buildStatItem('الأذكار', '${stats['totalAthkar']}'),
              _buildStatItem('النشطة', '${stats['activeCategories']}'),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
            fontFamily: AppTheme.numbersFont,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  /// الحصول على تخطيط مقترح للفئات
  static Map<String, List<String>> getSuggestedLayout(List<String> categories) {
    final grouped = groupCategoriesByType(categories, (category) => category);
    
    final layout = <String, List<String>>{};
    
    // الفئات اليومية أولاً
    if (grouped['daily']?.isNotEmpty == true) {
      layout['أذكار يومية'] = sortCategoriesByPriority(
        grouped['daily']!,
        (category) => category,
      );
    }
    
    // فئات الصلاة
    if (grouped['prayer']?.isNotEmpty == true) {
      layout['أذكار الصلاة'] = sortCategoriesByPriority(
        grouped['prayer']!,
        (category) => category,
      );
    }
    
    // المناسبات الخاصة
    if (grouped['special']?.isNotEmpty == true) {
      layout['مناسبات خاصة'] = sortCategoriesByPriority(
        grouped['special']!,
        (category) => category,
      );
    }
    
    // الفئات العامة
    if (grouped['general']?.isNotEmpty == true) {
      layout['فئات أخرى'] = sortCategoriesByPriority(
        grouped['general']!,
        (category) => category,
      );
    }
    
    return layout;
  }

  /// بناء تخطيط مجمع للفئات
  static Widget buildGroupedCategoriesLayout({
    required List<String> categories,
    required Map<String, int> categoryCounts,
    required Map<String, String> categoryTitles,
    required Function(String) onCategoryTap,
    bool showStats = true,
  }) {
    final layout = getSuggestedLayout(categories);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الإحصائيات
        if (showStats) ...[
          buildCategoriesStatsCard(
            categories: categories,
            categoryCounts: categoryCounts,
          ),
          AppTheme.space4.h,
        ],
        
        // المجموعات
        ...layout.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان المجموعة
              Padding(
                padding: AppTheme.space4.paddingH,
                child: Text(
                  entry.key,
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: AppTheme.semiBold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              AppTheme.space2.h,
              
              // فئات المجموعة
              ...entry.value.map((categoryId) {
                final title = categoryTitles[categoryId] ?? categoryId;
                final count = categoryCounts[categoryId] ?? 0;
                
                return buildCategoryCard(
                  categoryId: categoryId,
                  title: title,
                  count: count,
                  onTap: () => onCategoryTap(categoryId),
                  showDescription: false,
                );
              }),
              
              AppTheme.space4.h,
            ],
          );
        }),
      ],
    );
  }

  /// التحقق من وجود تحديثات للفئة
  static bool hasCategoryUpdates(String categoryId, DateTime lastUpdate) {
    // يمكن إضافة منطق التحقق من التحديثات هنا
    return false;
  }

  /// الحصول على شارة التحديث
  static Widget? getCategoryUpdateBadge(String categoryId, DateTime lastUpdate) {
    if (!hasCategoryUpdates(categoryId, lastUpdate)) return null;
    
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppTheme.error,
        shape: BoxShape.circle,
      ),
    );
  }

  /// الحصول على لون حالة الفئة
  static Color getCategoryStatusColor(String categoryId, int count) {
    if (count == 0) return AppTheme.textTertiary;
    if (AppTheme.isEssentialCategory(categoryId)) return AppTheme.primary;
    return AppTheme.getCategoryColor(categoryId);
  }

  /// بناء مؤشر حالة الفئة
  static Widget buildCategoryStatusIndicator(String categoryId, int count) {
    final color = getCategoryStatusColor(categoryId, count);
    final isEssential = AppTheme.isEssentialCategory(categoryId);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space1,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: AppTheme.radiusSm.radius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isEssential) ...[
            Icon(
              Icons.star,
              size: 10,
              color: color,
            ),
            const SizedBox(width: 2),
          ],
          Text(
            count.toString(),
            style: AppTheme.caption.copyWith(
              color: color,
              fontWeight: AppTheme.medium,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  /// الحصول على نص حالة الفئة
  static String getCategoryStatusText(String categoryId, int count) {
    if (count == 0) {
      return 'فارغة';
    } else if (count == 1) {
      return 'ذكر واحد';
    } else if (count == 2) {
      return 'ذكران';
    } else if (count <= 10) {
      return '$count أذكار';
    } else {
      return '${AppTheme.formatLargeNumber(count)} ذكر';
    }
  }

  /// تحديد الوقت المناسب لعرض الفئة
  static bool isCategoryAppropriateForTime(String categoryId, [DateTime? time]) {
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
      case 'wakeup':
      case 'الاستيقاظ':
        return hour >= 4 && hour < 8;
      default:
        return true; // الفئات الأخرى مناسبة في أي وقت
    }
  }

  /// فلترة الفئات المناسبة للوقت الحالي
  static List<T> filterCategoriesForCurrentTime<T>(
    List<T> categories,
    String Function(T) getIdFunction,
  ) {
    return categories.where((category) {
      return isCategoryAppropriateForTime(getIdFunction(category));
    }).toList();
  }

  /// الحصول على رسالة توضيحية للفئة
  static String getCategoryHelpText(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return 'يُستحب قراءة أذكار الصباح بعد صلاة الفجر وحتى طلوع الشمس';
      case 'evening':
      case 'المساء':
        return 'يُستحب قراءة أذكار المساء بعد صلاة العصر وحتى المغرب';
      case 'sleep':
      case 'النوم':
        return 'تُقرأ هذه الأذكار عند النوم للحماية والأجر';
      case 'prayer':
      case 'الصلاة':
        return 'أذكار مهمة تُقرأ بعد كل صلاة للحصول على الأجر';
      default:
        return 'اضغط للعرض والقراءة';
    }
  }

  /// التحقق من اكتمال فئة معينة
  static bool isCategoryCompleted(
    String categoryId,
    Map<String, int> completedCounts,
    Map<String, int> totalCounts,
  ) {
    final completed = completedCounts[categoryId] ?? 0;
    final total = totalCounts[categoryId] ?? 0;
    return total > 0 && completed >= total;
  }

  /// حساب نسبة الإنجاز للفئة
  static double getCategoryCompletionRate(
    String categoryId,
    Map<String, int> completedCounts,
    Map<String, int> totalCounts,
  ) {
    final completed = completedCounts[categoryId] ?? 0;
    final total = totalCounts[categoryId] ?? 0;
    if (total == 0) return 0.0;
    return (completed / total).clamp(0.0, 1.0);
  }

  /// الحصول على الفئات المكتملة
  static List<String> getCompletedCategories(
    List<String> categories,
    Map<String, int> completedCounts,
    Map<String, int> totalCounts,
  ) {
    return categories.where((categoryId) {
      return isCategoryCompleted(categoryId, completedCounts, totalCounts);
    }).toList();
  }

  /// الحصول على الفئات غير المكتملة
  static List<String> getIncompleteCategories(
    List<String> categories,
    Map<String, int> completedCounts,
    Map<String, int> totalCounts,
  ) {
    return categories.where((categoryId) {
      return !isCategoryCompleted(categoryId, completedCounts, totalCounts);
    }).toList();
  }
}