// lib/features/athkar/services/athkar_service.dart (محدث مع الدوال المطلوبة)
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';
import '../../../core/infrastructure/services/notifications/models/notification_models.dart';
import '../models/athkar_model.dart';
import '../models/athkar_progress.dart';

/// خدمة شاملة لإدارة الأذكار
class AthkarService {
  final LoggerService _logger;
  final StorageService _storage;

  // مفاتيح التخزين
  static const String _categoriesKey = 'athkar_categories';
  static const String _progressKey = AppConstants.athkarProgressKey;
  static const String _reminderKey = AppConstants.athkarReminderKey;
  static const String _favoritesKey = '${AppConstants.favoritesKey}_athkar';

  // كاش البيانات
  List<AthkarCategory>? _categories;
  final Map<String, AthkarProgress> _progressCache = {};

  AthkarService({
    required LoggerService logger,
    required StorageService storage,
  })  : _logger = logger,
        _storage = storage;

  // ==================== تحميل البيانات ====================

  /// تحميل فئات الأذكار
  Future<List<AthkarCategory>> loadCategories() async {
    try {
      // التحقق من الكاش
      if (_categories != null) {
        _logger.debug(message: '[AthkarService] تحميل الفئات من الكاش');
        return _categories!;
      }

      // محاولة تحميل من التخزين المحلي أولاً
      final cachedData = _storage.getMap(_categoriesKey);
      if (cachedData != null) {
        _logger.debug(message: '[AthkarService] تحميل الفئات من التخزين المحلي');
        final List<dynamic> list = cachedData['categories'] ?? [];
        _categories = list
            .map((e) => AthkarCategory.fromJson(e as Map<String, dynamic>))
            .toList();
        return _categories!;
      }

      // تحميل من الأصول
      _logger.info(message: '[AthkarService] تحميل الفئات من الأصول');
      final jsonStr = await rootBundle.loadString(AppConstants.athkarDataFile);
      final Map<String, dynamic> data = json.decode(jsonStr);
      
      // حفظ في التخزين المحلي
      await _storage.setMap(_categoriesKey, data);
      
      final List<dynamic> list = data['categories'] ?? [];
      _categories = list
          .map((e) => AthkarCategory.fromJson(e as Map<String, dynamic>))
          .toList();
      
      _logger.info(
        message: '[AthkarService] تم تحميل الفئات',
        data: {'count': _categories!.length},
      );
      
      return _categories!;
    } catch (e, stackTrace) {
      _logger.error(
        message: '[AthkarService] فشل تحميل الفئات',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('فشل تحميل بيانات الأذكار');
    }
  }

  /// الحصول على فئة حسب المعرف
  Future<AthkarCategory?> getCategoryById(String id) async {
    try {
      final categories = await loadCategories();
      return categories.firstWhere(
        (c) => c.id == id,
        orElse: () => throw Exception('الفئة غير موجودة'),
      );
    } catch (e) {
      _logger.warning(
        message: '[AthkarService] فئة غير موجودة',
        data: {'categoryId': id},
      );
      return null;
    }
  }

  // ==================== إدارة التقدم ====================

  /// الحصول على تقدم فئة معينة
  Future<AthkarProgress> getCategoryProgress(String categoryId) async {
    // التحقق من الكاش
    if (_progressCache.containsKey(categoryId)) {
      return _progressCache[categoryId]!;
    }

    // تحميل من التخزين
    final key = '${_progressKey}_$categoryId';
    final data = _storage.getMap(key);
    
    if (data != null) {
      final progress = AthkarProgress.fromJson(data);
      _progressCache[categoryId] = progress;
      return progress;
    }

    // إنشاء تقدم جديد
    final category = await getCategoryById(categoryId);
    if (category == null) {
      throw Exception('الفئة غير موجودة');
    }

    final progress = AthkarProgress(
      categoryId: categoryId,
      itemProgress: {},
      lastUpdated: DateTime.now(),
    );
    
    _progressCache[categoryId] = progress;
    return progress;
  }

  /// تحديث تقدم ذكر معين
  Future<void> updateItemProgress({
    required String categoryId,
    required int itemId,
    required int count,
  }) async {
    try {
      final progress = await getCategoryProgress(categoryId);
      progress.itemProgress[itemId] = count;
      progress.lastUpdated = DateTime.now();

      // حفظ في التخزين
      final key = '${_progressKey}_$categoryId';
      await _storage.setMap(key, progress.toJson());
      
      // تحديث الكاش
      _progressCache[categoryId] = progress;

      _logger.debug(
        message: '[AthkarService] تم تحديث التقدم',
        data: {
          'categoryId': categoryId,
          'itemId': itemId,
          'count': count,
        },
      );
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل تحديث التقدم',
        error: e,
      );
      rethrow;
    }
  }

  /// إعادة تعيين تقدم فئة
  Future<void> resetCategoryProgress(String categoryId) async {
    try {
      final key = '${_progressKey}_$categoryId';
      await _storage.remove(key);
      _progressCache.remove(categoryId);

      _logger.info(
        message: '[AthkarService] تم إعادة تعيين التقدم',
        data: {'categoryId': categoryId},
      );
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل إعادة تعيين التقدم',
        error: e,
      );
      rethrow;
    }
  }

  /// الحصول على نسبة إكمال فئة
  Future<int> getCategoryCompletionPercentage(String categoryId) async {
    try {
      final category = await getCategoryById(categoryId);
      if (category == null) return 0;

      final progress = await getCategoryProgress(categoryId);
      
      int totalRequired = 0;
      int totalCompleted = 0;

      for (final item in category.athkar) {
        totalRequired += item.count;
        final completed = progress.itemProgress[item.id] ?? 0;
        totalCompleted += completed.clamp(0, item.count);
      }

      if (totalRequired == 0) return 0;
      return ((totalCompleted / totalRequired) * 100).round();
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل حساب نسبة الإكمال',
        error: e,
      );
      return 0;
    }
  }

  // ==================== إدارة التذكيرات ====================

  /// جدولة تذكيرات الفئات
  Future<void> scheduleCategoryReminders() async {
    try {
      final categories = await loadCategories();
      final enabledIds = getEnabledReminderCategories();

      for (final category in categories) {
        if (category.notifyTime != null && enabledIds.contains(category.id)) {
          await NotificationManager.instance.scheduleAthkarReminder(
            categoryId: category.id,
            categoryName: category.title,
            time: category.notifyTime!,
            repeat: NotificationRepeat.daily,
          );
          
          _logger.info(
            message: '[AthkarService] تم جدولة تذكير',
            data: {
              'categoryId': category.id,
              'time': '${category.notifyTime!.hour}:${category.notifyTime!.minute.toString().padLeft(2, '0')}',
            },
          );
        }
      }
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل جدولة التذكيرات',
        error: e,
      );
      rethrow;
    }
  }

  /// الحصول على الفئات المفعلة للتذكير
  List<String> getEnabledReminderCategories() {
    return _storage.getStringList(_reminderKey) ?? [];
  }

  /// تحديث الفئات المفعلة للتذكيرات (الدالة المطلوبة)
  Future<void> setEnabledReminderCategories(List<String> enabledIds) async {
    try {
      await _storage.setStringList(_reminderKey, enabledIds);
      
      _logger.info(
        message: '[AthkarService] تم تحديث الفئات المفعلة للتذكيرات',
        data: {'enabledIds': enabledIds},
      );
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل تحديث الفئات المفعلة للتذكيرات',
        error: e,
      );
      rethrow;
    }
  }

  /// تحديث إعدادات التذكيرات
  Future<void> updateReminderSettings(Map<String, bool> enabledMap) async {
    try {
      final enabledIds = enabledMap.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
      
      await setEnabledReminderCategories(enabledIds);

      // تحديث الجدولة
      final categories = await loadCategories();
      for (final category in categories) {
        if (category.notifyTime == null) continue;

        if (enabledIds.contains(category.id)) {
          await NotificationManager.instance.scheduleAthkarReminder(
            categoryId: category.id,
            categoryName: category.title,
            time: category.notifyTime!,
          );
        } else {
          await NotificationManager.instance.cancelAthkarReminder(category.id);
        }
      }

      _logger.info(
        message: '[AthkarService] تم تحديث إعدادات التذكيرات',
        data: {'enabledCount': enabledIds.length},
      );
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل تحديث إعدادات التذكيرات',
        error: e,
      );
      rethrow;
    }
  }

  // ==================== إدارة المفضلة ====================

  /// إضافة ذكر للمفضلة
  Future<void> addToFavorites({
    required String categoryId,
    required int itemId,
  }) async {
    try {
      final favorites = getFavoriteItems();
      final key = '$categoryId:$itemId';
      
      if (!favorites.contains(key)) {
        favorites.add(key);
        await _storage.setStringList(_favoritesKey, favorites);
        
        _logger.info(
          message: '[AthkarService] تم إضافة للمفضلة',
          data: {'categoryId': categoryId, 'itemId': itemId},
        );
      }
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل إضافة للمفضلة',
        error: e,
      );
      rethrow;
    }
  }

  /// إزالة ذكر من المفضلة
  Future<void> removeFromFavorites({
    required String categoryId,
    required int itemId,
  }) async {
    try {
      final favorites = getFavoriteItems();
      final key = '$categoryId:$itemId';
      
      if (favorites.remove(key)) {
        await _storage.setStringList(_favoritesKey, favorites);
        
        _logger.info(
          message: '[AthkarService] تم إزالة من المفضلة',
          data: {'categoryId': categoryId, 'itemId': itemId},
        );
      }
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل إزالة من المفضلة',
        error: e,
      );
      rethrow;
    }
  }

  /// الحصول على المفضلة
  List<String> getFavoriteItems() {
    return _storage.getStringList(_favoritesKey) ?? [];
  }

  /// التحقق من كون الذكر في المفضلة
  bool isFavorite(String categoryId, int itemId) {
    final key = '$categoryId:$itemId';
    return getFavoriteItems().contains(key);
  }

  // ==================== البحث ====================

  /// البحث في الأذكار
  Future<List<SearchResult>> searchAthkar(String query) async {
    try {
      if (query.isEmpty) return [];

      final categories = await loadCategories();
      final results = <SearchResult>[];
      final normalizedQuery = query.toLowerCase().trim();

      for (final category in categories) {
        for (final item in category.athkar) {
          // البحث في النص
          if (item.text.toLowerCase().contains(normalizedQuery)) {
            results.add(SearchResult(
              category: category,
              item: item,
              matchType: MatchType.text,
            ));
          }
          // البحث في الفضل
          else if (item.fadl?.toLowerCase().contains(normalizedQuery) ?? false) {
            results.add(SearchResult(
              category: category,
              item: item,
              matchType: MatchType.fadl,
            ));
          }
          // البحث في المصدر
          else if (item.source?.toLowerCase().contains(normalizedQuery) ?? false) {
            results.add(SearchResult(
              category: category,
              item: item,
              matchType: MatchType.source,
            ));
          }
        }
      }

      _logger.info(
        message: '[AthkarService] نتائج البحث',
        data: {
          'query': query,
          'results': results.length,
        },
      );

      return results;
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل البحث',
        error: e,
      );
      return [];
    }
  }

  // ==================== تنظيف البيانات ====================

  /// مسح جميع البيانات المحفوظة
  Future<void> clearAllData() async {
    try {
      // مسح التقدم
      final categories = await loadCategories();
      for (final category in categories) {
        await resetCategoryProgress(category.id);
      }

      // مسح المفضلة
      await _storage.remove(_favoritesKey);

      // مسح الكاش
      _progressCache.clear();

      _logger.info(message: '[AthkarService] تم مسح جميع البيانات');
    } catch (e) {
      _logger.error(
        message: '[AthkarService] فشل مسح البيانات',
        error: e,
      );
      rethrow;
    }
  }

  /// التنظيف عند إغلاق التطبيق
  void dispose() {
    _progressCache.clear();
    _categories = null;
    _logger.debug(message: '[AthkarService] تم التنظيف');
  }
}

// ==================== نماذج البحث ====================

enum MatchType { text, fadl, source }

class SearchResult {
  final AthkarCategory category;
  final AthkarItem item;
  final MatchType matchType;

  SearchResult({
    required this.category,
    required this.item,
    required this.matchType,
  });
}