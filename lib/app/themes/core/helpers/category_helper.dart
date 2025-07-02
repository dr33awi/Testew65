// lib/app/themes/core/helpers/category_helper.dart - النسخة الكاملة والنهائية
import 'package:flutter/material.dart';
import '../systems/app_color_system.dart';
import '../systems/app_icons_system.dart';

/// مساعد الفئات الشامل - النسخة الكاملة والمتقدمة
/// 
/// يوفر جميع الدوال المطلوبة للتعامل مع فئات التطبيق
/// بطريقة موحدة ومنظمة
class CategoryHelper {
  CategoryHelper._();

  // ===== إعادة التوجيه للأنظمة الموحدة =====
  
  /// الحصول على لون الفئة الأساسي
  static Color getCategoryColor(String categoryId) => 
      AppColorSystem.getCategoryColor(categoryId);

  /// الحصول على اللون الفاتح للفئة
  static Color getCategoryLightColor(String categoryId) => 
      AppColorSystem.getCategoryLightColor(categoryId);

  /// الحصول على اللون الداكن للفئة
  static Color getCategoryDarkColor(String categoryId) => 
      AppColorSystem.getCategoryDarkColor(categoryId);

  /// الحصول على أيقونة الفئة
  static IconData getCategoryIcon(String categoryId) => 
      AppIconsSystem.getCategoryIcon(categoryId);

  /// الحصول على التدرج اللوني للفئة
  static LinearGradient getCategoryGradient(String categoryId) => 
      AppColorSystem.getCategoryGradient(categoryId);

  // ===== دوال السياق والثيم =====

  /// الحصول على لون الفئة مع تكييف حسب السياق
  static Color getCategoryColorForContext(BuildContext context, String categoryId) {
    final baseColor = AppColorSystem.getCategoryColor(categoryId);
    
    // تعديل اللون حسب الثيم
    if (Theme.of(context).brightness == Brightness.dark) {
      return baseColor.withValues(alpha: 0.9);
    }
    return baseColor;
  }

  /// الحصول على لون النص المناسب للفئة
  static Color getCategoryTextColor(BuildContext context, String categoryId) {
    final backgroundColor = getCategoryColorForContext(context, categoryId);
    final luminance = backgroundColor.computeLuminance();
    
    // اختيار لون النص بناء على سطوع الخلفية
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// الحصول على تدرج لوني محسن للسياق
  static LinearGradient getCategoryGradientForContext(BuildContext context, String categoryId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = getCategoryColor(categoryId);
    
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          baseColor.withValues(alpha: 0.8),
          baseColor.withValues(alpha: 0.6),
        ],
      );
    }
    
    return getCategoryGradient(categoryId);
  }

  // ===== المعلومات الأساسية للفئات =====

  /// الحصول على وصف الفئة المفصل
  static String getCategoryDescription(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return 'أذكار بعد صلاة الفجر وحتى شروق الشمس';
      case 'evening':
      case 'المساء':
        return 'أذكار بعد صلاة المغرب وحتى العشاء';
      case 'sleep':
      case 'النوم':
        return 'أذكار قبل النوم للحماية والسكينة';
      case 'prayer':
      case 'بعد الصلاة':
        return 'أذكار بعد كل صلاة من الصلوات الخمس';
      case 'wakeup':
      case 'الاستيقاظ':
        return 'أذكار الاستيقاظ من النوم';
      case 'general':
      case 'عامة':
        return 'أذكار عامة لمختلف الأوقات والمناسبات';
      case 'prayer_times':
        return 'أوقات الصلوات الخمس والإقامة';
      case 'qibla':
        return 'البوصلة الإسلامية لتحديد اتجاه القبلة';
      case 'tasbih':
        return 'المسبحة الرقمية للتسبيح والذكر';
      case 'quran':
        return 'القرآن الكريم كاملاً مع التفسير';
      case 'hadith':
        return 'الأحاديث النبوية الشريفة';
      case 'dua':
        return 'الأدعية المأثورة من الكتاب والسنة';
      case 'names':
        return 'أسماء الله الحسنى مع شرحها';
      case 'calendar':
        return 'التقويم الهجري والميلادي';
      default:
        return 'فئة من فئات التطبيق الإسلامي';
    }
  }

  /// الحصول على العنوان المُترجم والمُنسق
  static String getLocalizedTitle(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
        return 'أذكار الصباح';
      case 'evening':
        return 'أذكار المساء';
      case 'sleep':
        return 'أذكار النوم';
      case 'prayer':
        return 'أذكار بعد الصلاة';
      case 'wakeup':
        return 'أذكار الاستيقاظ';
      case 'general':
        return 'الأذكار العامة';
      case 'prayer_times':
        return 'مواقيت الصلاة';
      case 'qibla':
        return 'اتجاه القبلة';
      case 'tasbih':
        return 'المسبحة الرقمية';
      case 'quran':
        return 'القرآن الكريم';
      case 'hadith':
        return 'الأحاديث النبوية';
      case 'dua':
        return 'الأدعية المأثورة';
      case 'names':
        return 'أسماء الله الحسنى';
      case 'calendar':
        return 'التقويم الإسلامي';
      default:
        return _capitalizeFirst(categoryId);
    }
  }

  /// الحصول على العنوان الفرعي التوضيحي
  static String getLocalizedSubtitle(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
        return 'ابدأ يومك بالذكر والدعاء';
      case 'evening':
        return 'اختتم يومك بالذكر والاستغفار';
      case 'sleep':
        return 'نم بسكينة وطمأنينة';
      case 'prayer':
        return 'أذكار بعد كل صلاة';
      case 'wakeup':
        return 'احمد الله على نعمة الاستيقاظ';
      case 'general':
        return 'أذكار لمختلف الأوقات';
      case 'prayer_times':
        return 'أوقات الصلوات الخمس';
      case 'qibla':
        return 'البوصلة الإسلامية الدقيقة';
      case 'tasbih':
        return 'تسبيح رقمي مع العداد';
      case 'quran':
        return 'اقرأ وتدبر القرآن الكريم';
      case 'hadith':
        return 'تعلم من سنة النبي ﷺ';
      case 'dua':
        return 'أدعية من الكتاب والسنة';
      case 'names':
        return 'تعرف على أسماء الله الحسنى';
      case 'calendar':
        return 'التواريخ الهجرية والميلادية';
      default:
        return '';
    }
  }

  /// الحصول على كلمات مفتاحية للبحث
  static List<String> getCategoryKeywords(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
        return ['صباح', 'فجر', 'شروق', 'بداية', 'يوم', 'أذكار الصباح'];
      case 'evening':
        return ['مساء', 'مغرب', 'غروب', 'نهاية', 'يوم', 'أذكار المساء'];
      case 'sleep':
        return ['نوم', 'ليل', 'راحة', 'سكينة', 'أذكار النوم'];
      case 'prayer':
        return ['صلاة', 'بعد الصلاة', 'تسبيح', 'تحميد', 'تهليل'];
      case 'qibla':
        return ['قبلة', 'اتجاه', 'بوصلة', 'كعبة', 'مكة'];
      case 'tasbih':
        return ['تسبيح', 'ذكر', 'عداد', 'مسبحة', 'تهليل'];
      case 'quran':
        return ['قرآن', 'كريم', 'تلاوة', 'تفسير', 'آيات'];
      case 'dua':
        return ['دعاء', 'أدعية', 'مأثور', 'استغفار', 'دعوات'];
      default:
        return [categoryId];
    }
  }

  // ===== الإعدادات والتفضيلات =====

  /// التحقق من ضرورة التفعيل التلقائي
  static bool shouldAutoEnable(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
      case 'evening':
      case 'المساء':
      case 'prayer':
      case 'بعد الصلاة':
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
        return const TimeOfDay(hour: 6, minute: 30); // بعد الفجر
      case 'evening':
      case 'المساء':
        return const TimeOfDay(hour: 18, minute: 30); // بعد المغرب
      case 'sleep':
      case 'النوم':
        return const TimeOfDay(hour: 22, minute: 30); // قبل النوم
      case 'wakeup':
      case 'الاستيقاظ':
        return const TimeOfDay(hour: 5, minute: 30); // وقت الاستيقاظ
      case 'prayer':
      case 'بعد الصلاة':
        return const TimeOfDay(hour: 12, minute: 30); // الظهر كمثال
      default:
        return const TimeOfDay(hour: 12, minute: 0);
    }
  }

  /// الحصول على أولوية الفئة للترتيب
  static int getCategoryPriority(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'prayer_times': return 1;  // الأهم
      case 'morning':
      case 'الصباح': return 2;
      case 'evening':
      case 'المساء': return 3;
      case 'prayer':
      case 'بعد الصلاة': return 4;
      case 'sleep':
      case 'النوم': return 5;
      case 'wakeup':
      case 'الاستيقاظ': return 6;
      case 'qibla': return 7;
      case 'tasbih': return 8;
      case 'quran': return 9;
      case 'hadith': return 10;
      case 'dua': return 11;
      case 'names': return 12;
      case 'general': return 13;
      case 'calendar': return 14;
      default: return 99;
    }
  }

  /// الحصول على مستوى أهمية الفئة
  static CategoryImportance getCategoryImportance(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'prayer_times':
      case 'morning':
      case 'evening':
      case 'prayer':
        return CategoryImportance.critical;
      case 'sleep':
      case 'qibla':
      case 'quran':
        return CategoryImportance.high;
      case 'tasbih':
      case 'dua':
      case 'hadith':
        return CategoryImportance.medium;
      default:
        return CategoryImportance.low;
    }
  }

  // ===== التحقق من الحالة والوصول =====

  /// التحقق من إمكانية الوصول للفئة
  static bool isCategoryAccessible(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'evening':
      case 'sleep':
      case 'prayer':
      case 'wakeup':
      case 'general':
      case 'dua':
        return true; // الأذكار والأدعية متاحة
      case 'prayer_times':
      case 'qibla':
      case 'tasbih':
      case 'quran':
      case 'hadith':
        return false; // قيد التطوير
      default:
        return false;
    }
  }

  /// التحقق من كون الفئة مفعلة افتراضياً
  static bool isCategoryEnabledByDefault(String categoryId) {
    return shouldAutoEnable(categoryId) && isCategoryAccessible(categoryId);
  }

  /// التحقق من كون الفئة تحتاج تذكيرات
  static bool categoryNeedsReminders(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'evening':
      case 'sleep':
      case 'prayer':
        return true;
      default:
        return false;
    }
  }

  /// التحقق من كون الفئة متاحة في الوقت الحالي
  static bool isCategoryRelevantNow(String categoryId) {
    final hour = DateTime.now().hour;
    
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return hour >= 5 && hour < 12; // من الفجر للظهر
      case 'evening':
      case 'المساء':
        return hour >= 17 && hour < 21; // من المغرب للعشاء
      case 'sleep':
      case 'النوم':
        return hour >= 21 || hour < 5; // من العشاء للفجر
      case 'wakeup':
      case 'الاستيقاظ':
        return hour >= 4 && hour < 8; // وقت الاستيقاظ المعتاد
      default:
        return true; // الفئات الأخرى متاحة دائماً
    }
  }

  // ===== رسائل التطوير والأخطاء =====

  /// رسالة التطوير للفئات
  static String getDevelopmentMessage(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'prayer_times':
        return 'ميزة مواقيت الصلاة قيد التطوير وستكون متاحة قريباً';
      case 'qibla':
        return 'ميزة البوصلة الإسلامية قيد التطوير';
      case 'tasbih':
        return 'ميزة المسبحة الرقمية قيد التطوير';
      case 'quran':
        return 'ميزة القرآن الكريم قيد التطوير مع التفسير';
      case 'hadith':
        return 'ميزة الأحاديث النبوية قيد التطوير';
      case 'names':
        return 'ميزة أسماء الله الحسنى قيد التطوير';
      case 'calendar':
        return 'ميزة التقويم الإسلامي قيد التطوير';
      case 'morning':
      case 'evening':
      case 'sleep':
        return 'أذكار ${getLocalizedTitle(categoryId)} متاحة الآن';
      default:
        return 'هذه الميزة قيد التطوير وستكون متاحة في التحديثات القادمة';
    }
  }

  /// رسالة عدم الوصول
  static String getAccessDeniedMessage(String categoryId) {
    if (isCategoryAccessible(categoryId)) {
      return 'الفئة متاحة';
    }
    
    return getDevelopmentMessage(categoryId);
  }

  // ===== التحقق من صحة البيانات =====

  /// التحقق من صحة معرف الفئة
  static bool isValidCategoryId(String categoryId) {
    if (categoryId.isEmpty) return false;
    
    final validIds = [
      'morning', 'evening', 'sleep', 'prayer', 'wakeup', 'general',
      'prayer_times', 'qibla', 'tasbih', 'quran', 'hadith', 'dua',
      'names', 'calendar',
      'الصباح', 'المساء', 'النوم', 'بعد الصلاة', 'الاستيقاظ', 'عامة'
    ];
    
    return validIds.contains(categoryId.toLowerCase());
  }

  /// الحصول على جميع معرفات الفئات الصحيحة
  static List<String> getAllValidCategoryIds() {
    return [
      'morning', 'evening', 'sleep', 'prayer', 'wakeup', 'general',
      'prayer_times', 'qibla', 'tasbih', 'quran', 'hadith', 'dua',
      'names', 'calendar'
    ];
  }

  /// الحصول على الفئات المتاحة فقط
  static List<String> getAccessibleCategoryIds() {
    return getAllValidCategoryIds()
        .where((id) => isCategoryAccessible(id))
        .toList();
  }

  /// الحصول على الفئات المفعلة افتراضياً
  static List<String> getDefaultEnabledCategoryIds() {
    return getAllValidCategoryIds()
        .where((id) => isCategoryEnabledByDefault(id))
        .toList();
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

  /// ترتيب الفئات حسب الأهمية
  static List<T> sortCategoriesByImportance<T>(
    List<T> categories,
    String Function(T) getIdFunction,
  ) {
    final sortedList = List<T>.from(categories);
    sortedList.sort((a, b) {
      final importanceA = getCategoryImportance(getIdFunction(a)).index;
      final importanceB = getCategoryImportance(getIdFunction(b)).index;
      return importanceA.compareTo(importanceB);
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

  /// فلترة الفئات المتاحة فقط
  static List<T> filterAccessibleCategories<T>(
    List<T> categories,
    String Function(T) getIdFunction,
  ) {
    return categories.where((category) {
      return isCategoryAccessible(getIdFunction(category));
    }).toList();
  }

  /// فلترة الفئات المناسبة للوقت الحالي
  static List<T> filterRelevantCategories<T>(
    List<T> categories,
    String Function(T) getIdFunction,
  ) {
    return categories.where((category) {
      return isCategoryRelevantNow(getIdFunction(category));
    }).toList();
  }

  /// فلترة الفئات حسب الأهمية
  static List<T> filterCategoriesByImportance<T>(
    List<T> categories,
    String Function(T) getIdFunction,
    CategoryImportance importance,
  ) {
    return categories.where((category) {
      return getCategoryImportance(getIdFunction(category)) == importance;
    }).toList();
  }

  // ===== البحث والاستعلام =====

  /// البحث في الفئات
  static List<T> searchCategories<T>(
    List<T> categories,
    String Function(T) getIdFunction,
    String Function(T) getTitleFunction,
    String searchTerm,
  ) {
    if (searchTerm.isEmpty) return categories;
    
    final lowerSearchTerm = searchTerm.toLowerCase();
    
    return categories.where((category) {
      final id = getIdFunction(category).toLowerCase();
      final title = getTitleFunction(category).toLowerCase();
      final description = getCategoryDescription(id).toLowerCase();
      final localizedTitle = getLocalizedTitle(id).toLowerCase();
      final keywords = getCategoryKeywords(id).join(' ').toLowerCase();
      
      return id.contains(lowerSearchTerm) ||
             title.contains(lowerSearchTerm) ||
             description.contains(lowerSearchTerm) ||
             localizedTitle.contains(lowerSearchTerm) ||
             keywords.contains(lowerSearchTerm);
    }).toList();
  }

  /// البحث المتقدم بمعايير متعددة
  static List<T> advancedSearchCategories<T>(
    List<T> categories,
    String Function(T) getIdFunction,
    String Function(T) getTitleFunction, {
    String? searchTerm,
    bool? onlyAccessible,
    bool? onlyEssential,
    bool? onlyRelevantNow,
    CategoryImportance? importance,
  }) {
    var results = List<T>.from(categories);
    
    // تطبيق البحث النصي
    if (searchTerm != null && searchTerm.isNotEmpty) {
      results = searchCategories(results, getIdFunction, getTitleFunction, searchTerm);
    }
    
    // فلترة حسب إمكانية الوصول
    if (onlyAccessible == true) {
      results = filterAccessibleCategories(results, getIdFunction);
    }
    
    // فلترة الفئات الأساسية
    if (onlyEssential == true) {
      results = filterEssentialCategories(results, getIdFunction);
    }
    
    // فلترة المناسبة للوقت الحالي
    if (onlyRelevantNow == true) {
      results = filterRelevantCategories(results, getIdFunction);
    }
    
    // فلترة حسب الأهمية
    if (importance != null) {
      results = filterCategoriesByImportance(results, getIdFunction, importance);
    }
    
    return results;
  }

  // ===== الإحصائيات والتحليل =====

  /// إحصائيات الفئات
  static CategoryStats getCategoryStats(List<String> categoryIds) {
    var accessible = 0;
    var autoEnabled = 0;
    var needsReminders = 0;
    var relevantNow = 0;
    final importanceCounts = <CategoryImportance, int>{};
    final typeCounts = <String, int>{};

    for (final id in categoryIds) {
      if (isCategoryAccessible(id)) accessible++;
      if (shouldAutoEnable(id)) autoEnabled++;
      if (categoryNeedsReminders(id)) needsReminders++;
      if (isCategoryRelevantNow(id)) relevantNow++;
      
      // إحصائيات الأهمية
      final importance = getCategoryImportance(id);
      importanceCounts[importance] = (importanceCounts[importance] ?? 0) + 1;
      
      // إحصائيات النوع
      final type = _getCategoryType(id);
      typeCounts[type] = (typeCounts[type] ?? 0) + 1;
    }

    return CategoryStats(
      total: categoryIds.length,
      accessible: accessible,
      autoEnabled: autoEnabled,
      needsReminders: needsReminders,
      relevantNow: relevantNow,
      importanceCounts: importanceCounts,
      typeCounts: typeCounts,
    );
  }

  /// تحليل الاستخدام للفئات
  static CategoryUsageAnalysis analyzeUsage(
    List<String> categoryIds,
    Map<String, int> usageCounts,
  ) {
    final totalUsage = usageCounts.values.fold(0, (sum, count) => sum + count);
    final avgUsage = totalUsage / categoryIds.length;
    
    final sortedByUsage = categoryIds.toList()
      ..sort((a, b) => (usageCounts[b] ?? 0).compareTo(usageCounts[a] ?? 0));
    
    final mostUsed = sortedByUsage.take(3).toList();
    final leastUsed = sortedByUsage.reversed.take(3).toList();
    
    return CategoryUsageAnalysis(
      totalUsage: totalUsage,
      averageUsage: avgUsage,
      mostUsedCategories: mostUsed,
      leastUsedCategories: leastUsed,
      usageDistribution: usageCounts,
    );
  }

  // ===== دوال مساعدة داخلية =====

  /// تحديد نوع الفئة
  static String _getCategoryType(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'evening':
      case 'sleep':
      case 'prayer':
      case 'wakeup':
      case 'general':
        return 'athkar';
      case 'prayer_times':
      case 'qibla':
      case 'tasbih':
      case 'calendar':
        return 'tools';
      case 'quran':
      case 'hadith':
      case 'dua':
      case 'names':
        return 'religious_content';
      default:
        return 'other';
    }
  }

  /// تحويل أول حرف إلى كبير
  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // ===== التحقق من التكامل =====

  /// التحقق من تكامل البيانات
  static bool validateCategorySystem() {
    final allIds = getAllValidCategoryIds();
    
    for (final id in allIds) {
      // التحقق من وجود العنوان
      final title = getLocalizedTitle(id);
      if (title.isEmpty) return false;
      
      // التحقق من وجود الوصف
      final description = getCategoryDescription(id);
      if (description.isEmpty) return false;
      
      // التحقق من صحة الأولوية
      final priority = getCategoryPriority(id);
      if (priority < 1) return false;
    }
    
    return true;
  }

  /// الحصول على تقرير صحة النظام
  static String getSystemHealthReport() {
    final isValid = validateCategorySystem();
    final allIds = getAllValidCategoryIds();
    final accessibleIds = getAccessibleCategoryIds();
    final enabledIds = getDefaultEnabledCategoryIds();
    
    final buffer = StringBuffer();
    buffer.writeln('=== تقرير صحة نظام الفئات ===');
    buffer.writeln('حالة النظام: ${isValid ? "صحيح ✅" : "يحتاج إصلاح ❌"}');
    buffer.writeln('إجمالي الفئات: ${allIds.length}');
    buffer.writeln('الفئات المتاحة: ${accessibleIds.length}');
    buffer.writeln('الفئات المفعلة افتراضياً: ${enabledIds.length}');
    buffer.writeln('نسبة الإتاحة: ${((accessibleIds.length / allIds.length) * 100).toStringAsFixed(1)}%');
    
    return buffer.toString();
  }
}

// ===== التعدادات والفئات المساعدة =====

/// مستويات أهمية الفئات
enum CategoryImportance {
  critical,  // حرج (الأذكار الأساسية)
  high,      // عالي (القرآن، القبلة)
  medium,    // متوسط (التسبيح، الأدعية)
  low,       // منخفض (الميزات الإضافية)
}

/// إحصائيات الفئات
class CategoryStats {
  final int total;
  final int accessible;
  final int autoEnabled;
  final int needsReminders;
  final int relevantNow;
  final Map<CategoryImportance, int> importanceCounts;
  final Map<String, int> typeCounts;

  const CategoryStats({
    required this.total,
    required this.accessible,
    required this.autoEnabled,
    required this.needsReminders,
    required this.relevantNow,
    required this.importanceCounts,
    required this.typeCounts,
  });

  /// النسبة المئوية للفئات المتاحة
  double get accessibilityPercentage => (accessible / total) * 100;

  /// النسبة المئوية للفئات المفعلة
  double get enabledPercentage => (autoEnabled / total) * 100;

  /// النسبة المئوية للفئات المناسبة الآن
  double get relevancePercentage => (relevantNow / total) * 100;
}

/// تحليل استخدام الفئات
class CategoryUsageAnalysis {
  final int totalUsage;
  final double averageUsage;
  final List<String> mostUsedCategories;
  final List<String> leastUsedCategories;
  final Map<String, int> usageDistribution;

  const CategoryUsageAnalysis({
    required this.totalUsage,
    required this.averageUsage,
    required this.mostUsedCategories,
    required this.leastUsedCategories,
    required this.usageDistribution,
  });

  /// الحصول على معدل الاستخدام لفئة معينة
  double getUsageRate(String categoryId) {
    final usage = usageDistribution[categoryId] ?? 0;
    return totalUsage > 0 ? (usage / totalUsage) * 100 : 0.0;
  }

  /// التحقق من كون الفئة من الأكثر استخداماً
  bool isMostUsed(String categoryId) {
    return mostUsedCategories.contains(categoryId);
  }

  /// التحقق من كون الفئة من الأقل استخداماً
  bool isLeastUsed(String categoryId) {
    return leastUsedCategories.contains(categoryId);
  }
}