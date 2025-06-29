// lib/features/athkar/utils/category_utils.dart - محدث ومتوافق مع النظام الموحد
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/widgets.dart';

/// أدوات مساعدة لفئات الأذكار - متوافق مع CardHelper والنظام الموحد
class CategoryUtils {
  CategoryUtils._();

  /// الحصول على أيقونة مناسبة لكل فئة
  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      // أذكار الأوقات
      case 'morning':
      case 'الصباح':
      case 'صباح':
        return Icons.wb_sunny;
      case 'evening':
      case 'المساء':
      case 'مساء':
        return Icons.wb_incandescent;
      case 'sleep':
      case 'النوم':
      case 'نوم':
        return Icons.nightlight_round;
      case 'wakeup':
      case 'wake_up':
      case 'الاستيقاظ':
      case 'استيقاظ':
      case 'wake':
        return Icons.wb_twilight;
      
      // أذكار العبادة
      case 'prayer':
      case 'الصلاة':
      case 'صلاة':
      case 'prayers':
        return Icons.mosque;
      case 'eating':
      case 'food':
      case 'الطعام':
      case 'طعام':
      case 'الأكل':
      case 'أكل':
        return Icons.restaurant;
      case 'home':
      case 'house':
      case 'المنزل':
      case 'منزل':
      case 'البيت':
      case 'بيت':
        return Icons.home;
      case 'travel':
      case 'السفر':
      case 'سفر':
        return Icons.flight;
      
      // فئات خاصة
      case 'friday':
      case 'الجمعة':
        return Icons.calendar_today;
      case 'ramadan':
      case 'رمضان':
        return Icons.nights_stay;
      case 'hajj':
      case 'الحج':
        return Icons.landscape;
      case 'eid':
      case 'العيد':
        return Icons.celebration;
      case 'illness':
      case 'المرض':
        return Icons.healing;
      case 'rain':
      case 'المطر':
        return Icons.water_drop;
      case 'wind':
      case 'الرياح':
        return Icons.air;
      
      // باقي الفئات
      case 'general':
      case 'عامة':
      case 'عام':
        return Icons.book;
      case 'quran':
      case 'القرآن':
      case 'قرآن':
        return Icons.menu_book;
      case 'tasbih':
      case 'التسبيح':
      case 'تسبيح':
        return Icons.fingerprint;
      case 'dua':
      case 'الدعاء':
      case 'دعاء':
        return Icons.volunteer_activism;
      case 'istighfar':
      case 'الاستغفار':
        return Icons.favorite;
      
      default:
        return Icons.book;
    }
  }

  /// الحصول على لون من النظام الموحد
  static Color getCategoryThemeColor(String categoryId) {
    return AppTheme.getCategoryColor(categoryId);
  }

  /// الحصول على تدرج لوني مناسب لكل فئة
  static LinearGradient getCategoryGradient(String categoryId) {
    final baseColor = AppTheme.getCategoryColor(categoryId);
    return LinearGradient(
      colors: [
        baseColor.withValues(alpha: 0.8),
        baseColor,
        baseColor.darken(0.1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// الحصول على وصف مناسب لكل فئة
  static String getCategoryDescription(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return 'أذكار الصباح والاستيقاظ';
      case 'evening':
      case 'المساء':
        return 'أذكار المساء والمغرب';
      case 'sleep':
      case 'النوم':
        return 'أذكار النوم والاضطجاع';
      case 'prayer':
      case 'الصلاة':
        return 'أذكار الصلاة والوضوء';
      case 'eating':
      case 'الطعام':
        return 'أذكار الطعام والشراب';
      case 'travel':
      case 'السفر':
        return 'أذكار السفر والطريق';
      case 'friday':
      case 'الجمعة':
        return 'أذكار يوم الجمعة';
      case 'ramadan':
      case 'رمضان':
        return 'أذكار شهر رمضان';
      case 'hajj':
      case 'الحج':
        return 'أذكار الحج والعمرة';
      case 'quran':
      case 'القرآن':
        return 'آيات وسور قرآنية';
      case 'tasbih':
      case 'التسبيح':
        return 'التسبيح والتحميد والتكبير';
      case 'dua':
      case 'الدعاء':
        return 'أدعية منوعة';
      default:
        return 'أذكار متنوعة';
    }
  }

  /// التحقق من أن الفئة من الفئات الأساسية
  static bool isEssentialCategory(String categoryId) {
    const essentialCategories = {
      'morning', 'الصباح',
      'evening', 'المساء', 
      'sleep', 'النوم',
      'prayer', 'الصلاة',
      'eating', 'الطعام',
    };
    return essentialCategories.contains(categoryId.toLowerCase());
  }

  /// تحديد ما إذا كان يجب عرض الوقت للفئة
  static bool shouldShowTime(String categoryId) {
    const hiddenTimeCategories = {
      'morning', 'الصباح',
      'evening', 'المساء',
      'sleep', 'النوم',
    };
    return !hiddenTimeCategories.contains(categoryId.toLowerCase());
  }

  /// الحصول على أولوية العرض للفئة (أقل رقم = أولوية أعلى)
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

  /// الحصول على كرت فئة موحد
  static Widget buildCategoryCard({
    required String categoryId,
    required String title,
    required int count,
    VoidCallback? onTap,
    bool showDescription = true,
  }) {
    return AppCard(
      icon: getCategoryIcon(categoryId),
      title: title,
      subtitle: showDescription ? getCategoryDescription(categoryId) : null,
      color: getCategoryThemeColor(categoryId),
      onTap: onTap,
      actions: count > 0 ? [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space2,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: getCategoryThemeColor(categoryId),
            borderRadius: AppTheme.radiusFull.radius,
          ),
          child: Text(
            count.toString(),
            style: AppTheme.caption.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.bold,
            ),
          ),
        ),
      ] : null,
    );
  }

  /// الحصول على كرت فئة مدمج
  static Widget buildCompactCategoryCard({
    required String categoryId,
    required String title,
    required int count,
    VoidCallback? onTap,
  }) {
    return AppCard(
      useGradient: true,
      color: getCategoryThemeColor(categoryId),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            getCategoryIcon(categoryId),
            color: Colors.white,
            size: AppTheme.iconLg,
          ),
          AppTheme.space2.h,
          Text(
            title,
            style: AppTheme.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.semiBold,
            ),
            textAlign: TextAlign.center,
          ),
          AppTheme.space1.h,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space3,
              vertical: AppTheme.space1,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppTheme.radiusFull.radius,
            ),
            child: Text(
              '$count ذكر',
              style: AppTheme.caption.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.medium,
              ),
            ),
          ),
        ],
      ),
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

        if (isCompact) {
          return buildCompactCategoryCard(
            categoryId: categoryId,
            title: title,
            count: count,
            onTap: () => onCategoryTap(categoryId),
          );
        } else {
          return buildCategoryCard(
            categoryId: categoryId,
            title: title,
            count: count,
            onTap: () => onCategoryTap(categoryId),
          );
        }
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

        return buildCompactCategoryCard(
          categoryId: categoryId,
          title: title,
          count: count,
          onTap: () => onCategoryTap(categoryId),
        );
      },
    );
  }

  /// فلترة الفئات حسب النص
  static List<String> filterCategoriesByText({
    required List<String> categories,
    required Map<String, String> categoryTitles,
    required String searchText,
  }) {
    if (searchText.isEmpty) return categories;

    final lowerSearchText = searchText.toLowerCase().trim();
    
    return categories.where((categoryId) {
      final title = categoryTitles[categoryId]?.toLowerCase() ?? '';
      final description = getCategoryDescription(categoryId).toLowerCase();
      final id = categoryId.toLowerCase();
      
      return title.contains(lowerSearchText) ||
             description.contains(lowerSearchText) ||
             id.contains(lowerSearchText);
    }).toList();
  }

  /// الحصول على إحصائيات الفئات
  static Map<String, dynamic> getCategoriesStats(
    List<String> categories,
    Map<String, int> categoryCounts,
  ) {
    final totalCategories = categories.length;
    final totalAthkar = categoryCounts.values.fold(0, (sum, count) => sum + count);
    final essentialCategories = categories.where(isEssentialCategory).length;
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
    
    // إعادة ترتيب حسب الأولوية
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
    // هنا يمكن إضافة منطق التحقق من التحديثات
    // مثل مقارنة التاريخ مع آخر تحديث للمحتوى
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
    if (isEssentialCategory(categoryId)) return AppTheme.primary;
    return getCategoryThemeColor(categoryId);
  }

  /// بناء مؤشر حالة الفئة
  static Widget buildCategoryStatusIndicator(String categoryId, int count) {
    final color = getCategoryStatusColor(categoryId, count);
    final isEssential = isEssentialCategory(categoryId);
    
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
}