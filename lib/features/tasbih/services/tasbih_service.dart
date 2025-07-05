// lib/features/tasbih/services/tasbih_service.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../models/dhikr_model.dart';

/// خدمة إدارة المسبحة الرقمية المحسنة
class TasbihService extends ChangeNotifier {
  final StorageService _storage;
  final LoggerService _logger;

  int _count = 0;
  int _todayCount = 0;
  int _totalCount = 0;
  DateTime _lastUsedDate = DateTime.now();
  
  // إحصائيات متقدمة
  Map<String, int> _dhikrStats = {};
  List<DailyRecord> _history = [];
  List<DhikrItem> _customAdhkar = []; // قائمة الأذكار المخصصة

  TasbihService({
    required StorageService storage, 
    required LoggerService logger,
  }) : _storage = storage,
        _logger = logger {
    _loadData();
  }

  // Getters
  int get count => _count;
  int get todayCount => _todayCount;
  int get totalCount => _totalCount;
  Map<String, int> get dhikrStats => Map.unmodifiable(_dhikrStats);
  List<DailyRecord> get history => List.unmodifiable(_history);
  List<DhikrItem> get customAdhkar => List.unmodifiable(_customAdhkar);

  Future<void> _loadData() async {
    try {
      // تحميل العداد الأساسي
      _count = _storage.getInt(AppConstants.tasbihCounterKey) ?? 0;
      
      // تحميل العداد الإجمالي
      _totalCount = _storage.getInt('${AppConstants.tasbihCounterKey}_total') ?? 0;
      
      // تحميل تاريخ آخر استخدام
      final lastDateString = _storage.getString('${AppConstants.tasbihCounterKey}_last_date');
      if (lastDateString != null) {
        try {
          _lastUsedDate = DateTime.parse(lastDateString);
        } catch (e) {
          _logger.warning(
            message: '[TasbihService] Invalid date format, using current date',
            data: {'dateString': lastDateString},
          );
          _lastUsedDate = DateTime.now();
        }
      }
      
      // تحقق من تغيير اليوم
      final today = DateTime.now();
      if (!_isSameDay(_lastUsedDate, today)) {
        await _resetDailyCount();
        _lastUsedDate = today;
        await _storage.setString(
          '${AppConstants.tasbihCounterKey}_last_date',
          today.toIso8601String(),
        );
      } else {
        // تحميل عداد اليوم
        _todayCount = _storage.getInt('${AppConstants.tasbihCounterKey}_today') ?? 0;
      }
      
      // تحميل إحصائيات الأذكار
      await _loadDhikrStats();
      
      // تحميل التاريخ
      await _loadHistory();
      
      // تحميل الأذكار المخصصة
      await _loadCustomAdhkar();
      
      _logger.debug(
        message: '[TasbihService] Data loaded successfully',
        data: {
          'count': _count,
          'todayCount': _todayCount,
          'totalCount': _totalCount,
          'dhikrStatsCount': _dhikrStats.length,
          'historyCount': _history.length,
          'customAdhkarCount': _customAdhkar.length,
        },
      );
      
      notifyListeners();
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error loading data',
        error: e,
      );
      // في حالة الخطأ، نبدأ بقيم افتراضية
      _count = 0;
      _todayCount = 0;
      _totalCount = 0;
      _dhikrStats = {};
      _history = [];
      _customAdhkar = [];
      notifyListeners();
    }
  }

  Future<void> _loadDhikrStats() async {
    try {
      final statsData = _storage.getMap('${AppConstants.tasbihCounterKey}_stats');
      if (statsData != null) {
        _dhikrStats = {};
        statsData.forEach((key, value) {
          if (key is String && value is int) {
            _dhikrStats[key] = value;
          } else if (key is String && value is num) {
            _dhikrStats[key] = value.toInt();
          }
        });
      }
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error loading dhikr stats',
        error: e,
      );
      _dhikrStats = {};
    }
  }

  Future<void> increment({String dhikrType = 'default'}) async {
    try {
      _count++;
      _todayCount++;
      _totalCount++;
      
      // تحديث إحصائيات نوع الذكر
      _dhikrStats[dhikrType] = (_dhikrStats[dhikrType] ?? 0) + 1;
      
      notifyListeners();
      
      // حفظ البيانات
      await Future.wait([
        _storage.setInt(AppConstants.tasbihCounterKey, _count),
        _storage.setInt('${AppConstants.tasbihCounterKey}_today', _todayCount),
        _storage.setInt('${AppConstants.tasbihCounterKey}_total', _totalCount),
        _storage.setMap('${AppConstants.tasbihCounterKey}_stats', _dhikrStats),
      ]);
      
      _logger.debug(
        message: '[TasbihService] Incremented',
        data: {
          'count': _count,
          'dhikrType': dhikrType,
          'todayCount': _todayCount,
        },
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error incrementing',
        error: e,
      );
    }
  }

  Future<void> reset() async {
    try {
      _count = 0;
      notifyListeners();
      
      await _storage.setInt(AppConstants.tasbihCounterKey, _count);
      
      _logger.info(
        message: '[TasbihService] Counter reset',
        data: {'previousCount': _count},
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error resetting',
        error: e,
      );
    }
  }

  Future<void> resetDaily() async {
    try {
      // حفظ سجل اليوم قبل التصفير
      await _saveDailyRecord();
      
      _todayCount = 0;
      notifyListeners();
      
      await _storage.setInt('${AppConstants.tasbihCounterKey}_today', _todayCount);
      
      _logger.info(
        message: '[TasbihService] Daily count reset',
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error resetting daily count',
        error: e,
      );
    }
  }

  Future<void> resetAll() async {
    try {
      _count = 0;
      _todayCount = 0;
      _totalCount = 0;
      _dhikrStats.clear();
      _history.clear();
      
      notifyListeners();
      
      await Future.wait([
        _storage.remove(AppConstants.tasbihCounterKey),
        _storage.remove('${AppConstants.tasbihCounterKey}_today'),
        _storage.remove('${AppConstants.tasbihCounterKey}_total'),
        _storage.remove('${AppConstants.tasbihCounterKey}_stats'),
        _storage.remove('${AppConstants.tasbihCounterKey}_history'),
      ]);
      
      _logger.info(
        message: '[TasbihService] All data reset',
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error resetting all data',
        error: e,
      );
    }
  }

  Future<void> _resetDailyCount() async {
    if (_todayCount > 0) {
      await _saveDailyRecord();
    }
    _todayCount = 0;
  }

  Future<void> _saveDailyRecord() async {
    try {
      final record = DailyRecord(
        date: _lastUsedDate,
        count: _todayCount,
        dhikrBreakdown: Map<String, int>.from(_dhikrStats),
      );
      
      _history.insert(0, record);
      
      // الاحتفاظ بآخر 30 يوم فقط
      if (_history.length > 30) {
        _history = _history.take(30).toList();
      }
      
      await _saveHistory();
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error saving daily record',
        error: e,
      );
    }
  }

  Future<void> _loadHistory() async {
    try {
      final historyMap = _storage.getMap('${AppConstants.tasbihCounterKey}_history');
      if (historyMap != null) {
        _history = [];
        
        // ترتيب المفاتيح بترتيب عددي
        final sortedKeys = historyMap.keys
            .where((key) => int.tryParse(key) != null)
            .map((key) => int.parse(key))
            .toList()
          ..sort();
        
        // تحويل البيانات إلى قائمة السجلات
        for (final key in sortedKeys) {
          final recordData = historyMap[key.toString()];
          if (recordData is Map<String, dynamic>) {
            try {
              _history.add(DailyRecord.fromMap(recordData));
            } catch (e) {
              _logger.warning(
                message: '[TasbihService] Invalid history record format',
              );
            }
          }
        }
      }
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error loading history',
        error: e,
      );
      _history = [];
    }
  }

  Future<void> _saveHistory() async {
    try {
      final historyData = <String, dynamic>{};
      for (int i = 0; i < _history.length; i++) {
        historyData[i.toString()] = _history[i].toMap();
      }
      await _storage.setMap('${AppConstants.tasbihCounterKey}_history', historyData);
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error saving history',
        error: e,
      );
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // إحصائيات متقدمة
  int getWeeklyCount() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _history
        .where((record) => record.date.isAfter(weekAgo))
        .fold(0, (sum, record) => sum + record.count);
  }

  int getMonthlyCount() {
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    return _history
        .where((record) => record.date.isAfter(monthAgo))
        .fold(0, (sum, record) => sum + record.count);
  }

  double getAverageDaily() {
    if (_history.isEmpty) return 0.0;
    
    final totalDays = _history.length;
    final totalCount = _history.fold(0, (sum, record) => sum + record.count);
    
    return totalCount / totalDays;
  }

  List<DailyRecord> getLastWeekRecords() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _history
        .where((record) => record.date.isAfter(weekAgo))
        .toList();
  }

  String getMostUsedDhikr() {
    if (_dhikrStats.isEmpty) return 'لا يوجد';
    
    String mostUsed = _dhikrStats.keys.first;
    int maxCount = _dhikrStats[mostUsed] ?? 0;
    
    for (final entry in _dhikrStats.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostUsed = entry.key;
      }
    }
    
    return mostUsed;
  }

  // إدارة الأذكار المخصصة - النسخة المحدثة
  Future<void> _loadCustomAdhkar() async {
    try {
      final customData = _storage.getMap('${AppConstants.tasbihCounterKey}_custom_adhkar');
      if (customData != null) {
        _customAdhkar = [];
        
        // ترتيب المفاتيح بترتيب عددي
        final sortedKeys = customData.keys
            .where((key) => int.tryParse(key) != null)
            .map((key) => int.parse(key))
            .toList()
          ..sort();
        
        // تحويل البيانات إلى قائمة الأذكار المخصصة
        for (final key in sortedKeys) {
          final dhikrData = customData[key.toString()];
          if (dhikrData is Map<String, dynamic>) {
            try {
              final dhikr = DhikrItem.fromMap(dhikrData);
              _customAdhkar.add(dhikr);
            } catch (e) {
              _logger.warning(
                message: '[TasbihService] Invalid custom dhikr format',
              );
            }
          }
        }
        
        _logger.debug(
          message: '[TasbihService] Custom adhkar loaded',
        );
      }
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error loading custom adhkar',
        error: e,
      );
      _customAdhkar = [];
    }
  }

  Future<void> _saveCustomAdhkar() async {
    try {
      final customData = <String, dynamic>{};
      for (int i = 0; i < _customAdhkar.length; i++) {
        customData[i.toString()] = _customAdhkar[i].toMap();
      }
      await _storage.setMap('${AppConstants.tasbihCounterKey}_custom_adhkar', customData);
      
      _logger.debug(
        message: '[TasbihService] Custom adhkar saved',
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error saving custom adhkar',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> addCustomDhikr(DhikrItem dhikr) async {
    try {
      // التحقق من عدم وجود ذكر بنفس المعرف
      if (_customAdhkar.any((existing) => existing.id == dhikr.id)) {
        throw Exception('Dhikr with this ID already exists');
      }

      _customAdhkar.add(dhikr);
      await _saveCustomAdhkar();
      
      notifyListeners();
      
      _logger.info(
        message: '[TasbihService] Custom dhikr added successfully',
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error adding custom dhikr',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> removeCustomDhikr(String dhikrId) async {
    try {
      final oldLength = _customAdhkar.length;
      _customAdhkar.removeWhere((dhikr) => dhikr.id == dhikrId);
      
      if (_customAdhkar.length < oldLength) {
        await _saveCustomAdhkar();
        notifyListeners();
        
        _logger.info(
          message: '[TasbihService] Custom dhikr removed successfully',
        );
      } else {
        _logger.warning(
          message: '[TasbihService] Custom dhikr not found for removal',
        );
      }
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error removing custom dhikr',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> updateCustomDhikr(DhikrItem updatedDhikr) async {
    try {
      final index = _customAdhkar.indexWhere((dhikr) => dhikr.id == updatedDhikr.id);
      if (index != -1) {
        _customAdhkar[index] = updatedDhikr;
        await _saveCustomAdhkar();
        notifyListeners();
        
        _logger.info(
          message: '[TasbihService] Custom dhikr updated successfully',
        );
      } else {
        throw Exception('Custom dhikr not found for update');
      }
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error updating custom dhikr',
        error: e,
      );
      rethrow;
    }
  }

  List<DhikrItem> getAllAdhkar() {
    // دمج الأذكار الافتراضية مع المخصصة
    final allAdhkar = List<DhikrItem>.from(DefaultAdhkar.getAll());
    allAdhkar.addAll(_customAdhkar);
    return allAdhkar;
  }

  // دالة للتحقق من صحة البيانات المحفوظة
  Future<bool> validateStoredData() async {
    try {
      // تحقق من وجود البيانات
      final customData = _storage.getMap('${AppConstants.tasbihCounterKey}_custom_adhkar');
      
      _logger.debug(
        message: '[TasbihService] Validating stored data',
      );
      
      return true;
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error validating stored data',
        error: e,
      );
      return false;
    }
  }

  // دالة لإعادة تحميل البيانات يدوياً
  Future<void> reloadData() async {
    await _loadData();
  }
}

/// نموذج سجل يومي
class DailyRecord {
  final DateTime date;
  final int count;
  final Map<String, int> dhikrBreakdown;

  const DailyRecord({
    required this.date,
    required this.count,
    required this.dhikrBreakdown,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'count': count,
      'dhikrBreakdown': dhikrBreakdown,
    };
  }

  factory DailyRecord.fromMap(Map<String, dynamic> map) {
    return DailyRecord(
      date: DateTime.parse(map['date']),
      count: map['count'] ?? 0,
      dhikrBreakdown: Map<String, int>.from(map['dhikrBreakdown'] ?? {}),
    );
  }
}