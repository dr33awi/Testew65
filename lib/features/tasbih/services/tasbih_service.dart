import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';

/// خدمة إدارة المسبحة الرقمية
class TasbihService extends ChangeNotifier {
  final StorageService _storage;
  final LoggerService _logger;

  int _count = 0;
  int _dailyCount = 0;
  int _totalCount = 0;
  DateTime _lastUpdateDate = DateTime.now();
  Map<String, int> _statistics = {};

  TasbihService({
    required StorageService storage, 
    required LoggerService logger,
  }) : _storage = storage,
        _logger = logger {
    _loadData();
  }

  // Getters
  int get count => _count;
  int get dailyCount => _dailyCount;
  int get totalCount => _totalCount;
  int get currentSetProgress => _count % 33;
  int get completedSets => (_count / 33).floor();
  int get remainingInSet => 33 - (_count % 33 == 0 ? 0 : _count % 33);
  Map<String, int> get statistics => Map.unmodifiable(_statistics);

  /// تحميل البيانات المحفوظة
  Future<void> _loadData() async {
    try {
      _count = _storage.getInt(AppConstants.tasbihCounterKey) ?? 0;
      _totalCount = _storage.getInt('${AppConstants.tasbihCounterKey}_total') ?? 0;
      _dailyCount = _storage.getInt('${AppConstants.tasbihCounterKey}_daily') ?? 0;
      
      // تحميل تاريخ آخر تحديث
      final lastUpdateString = _storage.getString('${AppConstants.tasbihCounterKey}_last_update');
      if (lastUpdateString != null) {
        _lastUpdateDate = DateTime.parse(lastUpdateString);
      }
      
      // تحميل الإحصائيات
      final statisticsJson = _storage.getString('${AppConstants.tasbihCounterKey}_statistics');
      if (statisticsJson != null) {
        // يمكن إضافة منطق تحويل JSON هنا
      }
      
      // التحقق من تغيير اليوم
      _checkDayChange();
      
      _logger.debug(
        message: '[TasbihService] Data loaded',
        data: {
          'count': _count,
          'dailyCount': _dailyCount,
          'totalCount': _totalCount,
        },
      );
      
      notifyListeners();
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error loading data',
        error: e,
      );
    }
  }

  /// التحقق من تغيير اليوم وإعادة تعيين العداد اليومي
  void _checkDayChange() {
    final now = DateTime.now();
    final lastUpdate = _lastUpdateDate;
    
    // إذا كان اليوم مختلف، قم بإعادة تعيين العداد اليومي
    if (now.day != lastUpdate.day || 
        now.month != lastUpdate.month || 
        now.year != lastUpdate.year) {
      
      // حفظ إحصائيات اليوم السابق
      _saveYesterdayStatistics();
      
      // إعادة تعيين العداد اليومي
      _dailyCount = 0;
      _lastUpdateDate = now;
      
      _logger.info(
        message: '[TasbihService] Day changed, daily count reset',
        data: {'newDate': now.toIso8601String()},
      );
    }
  }

  /// حفظ إحصائيات اليوم السابق
  void _saveYesterdayStatistics() {
    if (_dailyCount > 0) {
      final yesterday = _lastUpdateDate;
      final key = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
      _statistics[key] = _dailyCount;
      
      _logger.debug(
        message: '[TasbihService] Yesterday statistics saved',
        data: {'date': key, 'count': _dailyCount},
      );
    }
  }

  /// زيادة العداد
  Future<void> increment() async {
    try {
      _checkDayChange();
      
      _count++;
      _dailyCount++;
      _totalCount++;
      
      notifyListeners();
      
      // حفظ البيانات
      await _saveData();
      
      _logger.debug(
        message: '[TasbihService] Count incremented',
        data: {
          'count': _count,
          'dailyCount': _dailyCount,
          'totalCount': _totalCount,
        },
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error incrementing count',
        error: e,
      );
    }
  }

  /// إعادة تعيين العداد الحالي
  Future<void> reset() async {
    try {
      _count = 0;
      notifyListeners();
      
      await _saveData();
      
      _logger.info(
        message: '[TasbihService] Count reset',
        data: {'dailyCount': _dailyCount, 'totalCount': _totalCount},
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error resetting count',
        error: e,
      );
    }
  }

  /// إعادة تعيين العداد اليومي
  Future<void> resetDaily() async {
    try {
      _dailyCount = 0;
      notifyListeners();
      
      await _saveData();
      
      _logger.info(
        message: '[TasbihService] Daily count reset',
        data: {'count': _count, 'totalCount': _totalCount},
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error resetting daily count',
        error: e,
      );
    }
  }

  /// إعادة تعيين جميع البيانات
  Future<void> resetAll() async {
    try {
      _count = 0;
      _dailyCount = 0;
      _totalCount = 0;
      _statistics.clear();
      _lastUpdateDate = DateTime.now();
      
      notifyListeners();
      
      await _saveData();
      await _storage.remove('${AppConstants.tasbihCounterKey}_statistics');
      
      _logger.info(message: '[TasbihService] All data reset');
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error resetting all data',
        error: e,
      );
    }
  }

  /// حفظ البيانات
  Future<void> _saveData() async {
    try {
      await Future.wait([
        _storage.setInt(AppConstants.tasbihCounterKey, _count),
        _storage.setInt('${AppConstants.tasbihCounterKey}_total', _totalCount),
        _storage.setInt('${AppConstants.tasbihCounterKey}_daily', _dailyCount),
        _storage.setString(
          '${AppConstants.tasbihCounterKey}_last_update',
          _lastUpdateDate.toIso8601String(),
        ),
      ]);
      
      // حفظ الإحصائيات إذا كانت متوفرة
      if (_statistics.isNotEmpty) {
        // يمكن إضافة منطق حفظ JSON هنا
      }
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error saving data',
        error: e,
      );
    }
  }

  /// الحصول على إحصائيات اليوم
  Map<String, dynamic> getTodayStatistics() {
    return {
      'current': _count,
      'daily': _dailyCount,
      'sets_completed': completedSets,
      'current_set_progress': currentSetProgress,
      'remaining_in_set': remainingInSet,
    };
  }

  /// الحصول على إحصائيات الأسبوع
  Map<String, int> getWeeklyStatistics() {
    final now = DateTime.now();
    final weekStats = <String, int>{};
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      if (i == 0) {
        // اليوم الحالي
        weekStats[key] = _dailyCount;
      } else {
        // الأيام السابقة من الإحصائيات المحفوظة
        weekStats[key] = _statistics[key] ?? 0;
      }
    }
    
    return weekStats;
  }

  /// الحصول على متوسط التسبيح اليومي
  double getDailyAverage() {
    final weekStats = getWeeklyStatistics();
    final totalDays = weekStats.values.where((count) => count > 0).length;
    
    if (totalDays == 0) return 0.0;
    
    final totalCount = weekStats.values.reduce((a, b) => a + b);
    return totalCount / totalDays;
  }

  /// الحصول على أفضل يوم في الأسبوع
  MapEntry<String, int>? getBestDayThisWeek() {
    final weekStats = getWeeklyStatistics();
    
    if (weekStats.isEmpty) return null;
    
    return weekStats.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
  }

  /// تعيين هدف يومي
  Future<void> setDailyGoal(int goal) async {
    try {
      await _storage.setInt('${AppConstants.tasbihCounterKey}_daily_goal', goal);
      
      _logger.info(
        message: '[TasbihService] Daily goal set',
        data: {'goal': goal},
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error setting daily goal',
        error: e,
      );
    }
  }

  /// الحصول على الهدف اليومي
  int getDailyGoal() {
    return _storage.getInt('${AppConstants.tasbihCounterKey}_daily_goal') ?? 100;
  }

  /// التحقق من تحقيق الهدف اليومي
  bool isDailyGoalAchieved() {
    return _dailyCount >= getDailyGoal();
  }

  /// نسبة التقدم نحو الهدف اليومي
  double getDailyGoalProgress() {
    final goal = getDailyGoal();
    if (goal == 0) return 0.0;
    return (_dailyCount / goal).clamp(0.0, 1.0);
  }
}