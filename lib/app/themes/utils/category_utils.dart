// lib/app/themes/utils/category_utils.dart - محدث بالثيم الإسلامي الموحد
// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/index.dart';
import 'package:flutter/material.dart';

/// أدوات مساعدة للفئات - محدثة بالثيم الموحد
class CategoryUtils {
  CategoryUtils._();

  // ========== دوال الفئات الأساسية ==========

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

  /// الحصول على لون الثيم للفئة
  static Color getCategoryThemeColor(String categoryId) {
    return AppTheme.getCategoryColor(categoryId);
  }

  /// الحصول على أيقونة الفئة
  static IconData getCategoryIcon(String categoryId) {
    return AppTheme.getCategoryIcon(categoryId);
  }

  /// الحصول على أولوية الفئة
  static int getCategoryPriority(String categoryId) {
    return AppTheme.getCategoryPriority(categoryId);
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

  /// بناء بطاقة فئة باستخدام النظام الموحد
  static Widget buildCategoryCard({
    required String categoryId,
    required String title,
    required int count,
    required VoidCallback onTap,
    bool isCompact = false,
    String? customDescription,
    int? progress,
  }) {
    return AppCard.category(
      categoryId: categoryId,
      title: title,
      count: count,
      onTap: onTap,
      isCompact: isCompact,
      customDescription: customDescription ?? getDescription(categoryId),
    );
  }

  /// بناء إحصائيات الفئات
  static Widget buildCategoryStats({
    required Map<String, int> categoryCounts,
    required Map<String, int> categoryProgress,
    VoidCallback? onViewAll,
  }) {
    final totalCategories = categoryCounts.length;
    final totalAthkar = categoryCounts.values.fold(0, (sum, count) => sum + count);
    final avgProgress = categoryProgress.values.isNotEmpty 
        ? (categoryProgress.values.fold(0, (sum, progress) => sum + progress) / categoryProgress.length).round()
        : 0;

    return Row(
      children: [
        Expanded(
          child: AppCard.stat(
            title: 'فئات',
            value: AppTheme.formatLargeNumber(totalCategories),
            icon: Icons.category,
            color: AppTheme.primary,
          ),
        ),
        AppTheme.space3.w,
        Expanded(
          child: AppCard.stat(
            title: 'أذكار',
            value: AppTheme.formatLargeNumber(totalAthkar),
            icon: Icons.book,
            color: AppTheme.secondary,
          ),
        ),
        AppTheme.space3.w,
        Expanded(
          child: AppCard.stat(
            title: 'إنجاز',
            value: '$avgProgress%',
            icon: Icons.trending_up,
            color: AppTheme.success,
          ),
        ),
      ],
    );
  }

  /// بناء قائمة الفئات مع التقدم
  static Widget buildCategoriesWithProgress({
    required List<String> categories,
    required Map<String, String> categoryTitles,
    required Map<String, int> categoryCounts,
    required Map<String, int> categoryProgress,
    required Function(String) onCategoryTap,
    bool showOnlyIncomplete = false,
  }) {
    // ترتيب الفئات
    final sortedCategories = AppTheme.sortByPriority(
      categories,
      (category) => AppTheme.getCategoryPriority(category),
    );

    // فلترة حسب الحالة إذا لزم الأمر
    final filteredCategories = showOnlyIncomplete 
        ? sortedCategories.where((category) => (categoryProgress[category] ?? 0) < 100).toList()
        : sortedCategories;

    if (filteredCategories.isEmpty) {
      return AppEmptyState.noData(
        message: showOnlyIncomplete 
            ? 'تم إكمال جميع الفئات! 🎉'
            : 'لا توجد فئات متاحة',
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredCategories.length,
      separatorBuilder: (context, index) => AppTheme.space3.h,
      itemBuilder: (context, index) {
        final categoryId = filteredCategories[index];
        final title = categoryTitles[categoryId] ?? categoryId;
        final count = categoryCounts[categoryId] ?? 0;
        final progress = categoryProgress[categoryId] ?? 0;

        return _buildCategoryWithProgress(
          categoryId: categoryId,
          title: title,
          count: count,
          progress: progress,
          onTap: () => onCategoryTap(categoryId),
        );
      },
    );
  }

  /// بناء بطاقة فئة مع شريط التقدم
  static Widget _buildCategoryWithProgress({
    required String categoryId,
    required String title,
    required int count,
    required int progress,
    required VoidCallback onTap,
  }) {
    final categoryColor = AppTheme.getCategoryColor(categoryId);
    final categoryIcon = AppTheme.getCategoryIcon(categoryId);
    final isCompleted = progress >= 100;

    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          // الصف الرئيسي
          Row(
            children: [
              // الأيقونة
              Container(
                width: AppTheme.iconXl + AppTheme.space2,
                height: AppTheme.iconXl + AppTheme.space2,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.1),
                  borderRadius: AppTheme.radiusMd.radius,
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: AppTheme.iconMd,
                ),
              ),

              AppTheme.space3.w,

              // النص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.titleMedium.copyWith(
                        fontWeight: AppTheme.semiBold,
                        color: isCompleted ? AppTheme.success : null,
                      ),
                    ),
                    AppTheme.space1.h,
                    Text(
                      '$count ذكر',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // النسبة المئوية
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.space2,
                  vertical: AppTheme.space1,
                ),
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? AppTheme.success 
                      : categoryColor.withValues(alpha: 0.1),
                  borderRadius: AppTheme.radiusFull.radius,
                ),
                child: Text(
                  '$progress%',
                  style: AppTheme.labelMedium.copyWith(
                    color: isCompleted 
                        ? Colors.white 
                        : categoryColor,
                    fontWeight: AppTheme.bold,
                    fontFamily: AppTheme.numbersFont,
                  ),
                ),
              ),

              // أيقونة الإكمال
              if (isCompleted) ...[
                AppTheme.space2.w,
                Icon(
                  Icons.check_circle,
                  color: AppTheme.success,
                  size: AppTheme.iconMd,
                ),
              ],
            ],
          ),

          // شريط التقدم
          if (progress > 0) ...[
            AppTheme.space3.h,
            Container(
              height: AppTheme.radiusXs,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: AppTheme.radiusFull.radius,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (progress / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isCompleted ? AppTheme.success : categoryColor,
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// الحصول على رسالة التحفيز حسب التقدم
  static String getMotivationalMessage(int progress) {
    if (progress == 0) {
      return 'ابدأ رحلتك مع الأذكار 🌱';
    } else if (progress < 25) {
      return 'بداية موفقة! استمر 💪';
    } else if (progress < 50) {
      return 'تقدم ممتاز! في المنتصف 🔥';
    } else if (progress < 75) {
      return 'أكثر من النصف! تقترب من الهدف 🎯';
    } else if (progress < 100) {
      return 'أوشكت على الانتهاء! 🏃‍♂️';
    } else {
      return 'مبارك! أكملت جميع الأذكار! 🎉';
    }
  }

  /// بناء رسالة تحفيزية
  static Widget buildMotivationalCard(int overallProgress) {
    final message = getMotivationalMessage(overallProgress);
    Color cardColor;
    IconData cardIcon;

    if (overallProgress == 0) {
      cardColor = AppTheme.info;
      cardIcon = Icons.play_arrow;
    } else if (overallProgress < 50) {
      cardColor = AppTheme.warning;
      cardIcon = Icons.trending_up;
    } else if (overallProgress < 100) {
      cardColor = AppTheme.primary;
      cardIcon = Icons.near_me;
    } else {
      cardColor = AppTheme.success;
      cardIcon = Icons.celebration;
    }

    return AppCard(
      useGradient: true,
      color: cardColor,
      child: Row(
        children: [
          Icon(
            cardIcon,
            color: Colors.white,
            size: AppTheme.iconLg,
          ),
          AppTheme.space3.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.bold,
                  ),
                ),
                AppTheme.space1.h,
                Text(
                  'إجمالي التقدم: $overallProgress%',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontFamily: AppTheme.numbersFont,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}