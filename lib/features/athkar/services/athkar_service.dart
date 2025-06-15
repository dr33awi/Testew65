// lib/features/athkar/services/athkar_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';
import '../models/athkar_model.dart';

/// خدمة تحميل الأذكار وإدارة تذكيراتها
class AthkarService {
  final LoggerService _logger;
  final StorageService _storage;

  static const String _completedKey = AppConstants.athkarProgressKey;
  static const String _reminderKey = AppConstants.athkarReminderKey;

  List<AthkarCategory>? _categories;

  AthkarService({
    required LoggerService logger,
    required StorageService storage,
  })  : _logger = logger,
        _storage = storage;

  /// تحميل فئات الأذكار من ملف JSON الموجود في الأصول
  Future<List<AthkarCategory>> loadCategories() async {
    if (_categories != null) return _categories!;
    try {
      final jsonStr = await rootBundle.loadString(AppConstants.athkarDataFile);
      final Map<String, dynamic> data = json.decode(jsonStr);
      final List<dynamic> list = data['categories'] ?? [];
      _categories = list
          .map((e) => AthkarCategory.fromJson(e as Map<String, dynamic>))
          .toList();
      _logger.info(
        message: '[AthkarService] loaded categories',
        data: {'count': _categories!.length},
      );
      return _categories!;
    } catch (e) {
      _logger.error(
        message: '[AthkarService] failed to load categories',
        error: e,
      );
      rethrow;
    }
  }

  /// الحصول على فئة حسب المعرف
  Future<AthkarCategory?> getCategoryById(String id) async {
    final cats = await loadCategories();
    try {
      return cats.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// جدولة التذكيرات لكل فئة تحوي وقت تنبيه
  Future<void> scheduleCategoryReminders() async {
    final cats = await loadCategories();
    final enabled = getEnabledReminderCategories();
    for (final cat in cats) {
      if (cat.notifyTime != null && enabled.contains(cat.id)) {
        await NotificationManager.instance.scheduleAthkarReminder(
          categoryId: cat.id,
          categoryName: cat.title,
          time: cat.notifyTime!,
        );
      }
    }
  }

  /// تعليم فئة كمكتملة في التخزين
  Future<void> markCategoryCompleted(String id) async {
    final completed = _storage.getStringList(_completedKey) ?? [];
    if (!completed.contains(id)) {
      completed.add(id);
      await _storage.setStringList(_completedKey, completed);
    }
  }

  /// الفئات المكتملة
  List<String> getCompletedCategories() {
    return _storage.getStringList(_completedKey) ?? [];
  }

  /// الفئات التي تم تمكين تذكيرها
  List<String> getEnabledReminderCategories() {
    return _storage.getStringList(_reminderKey) ?? [];
  }

  /// تحديث تذكيرات الفئات وجدولتها
  Future<void> updateReminderSettings(Map<String, bool> enabledMap) async {
    final enabledIds = enabledMap.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    await _storage.setStringList(_reminderKey, enabledIds);

    final cats = await loadCategories();
    for (final cat in cats) {
      if (cat.notifyTime == null) continue;
      if (enabledIds.contains(cat.id)) {
        await NotificationManager.instance.scheduleAthkarReminder(
          categoryId: cat.id,
          categoryName: cat.title,
          time: cat.notifyTime!,
        );
      } else {
        await NotificationManager.instance.cancelAthkarReminder(cat.id);
      }
    }
  }
}
