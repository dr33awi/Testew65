// lib/features/tasbih/services/tasbih_service.dart
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';

/// خدمة إدارة المسبحة الرقمية المحسنة
class TasbihService extends ChangeNotifier {
  final StorageService _storage;
  final LoggerService _logger;

  // العدادات الأساسية
  int _count = 0;
  int _dailyCount = 0;
  int _totalCount = 0;
  int _weeklyCount = 0;
  int _monthlyCount = 0;
  
  // التواريخ والإحصائيات
  DateTime _lastUpdateDate = DateTime.now();
  Map<String, int> _dailyStatistics = {};
  Map<String, int> _weeklyStatistics = {};
  Map<String, int> _monthlyStatistics = {};
  
  // الإعدادات
  int _dailyGoal = 100;
  String _selectedTasbihType = 'سبحان الله';
  bool _enableNotifications = true;
  bool _enableVibration = true;
  bool _enableSound = false;

  TasbihService({
    required StorageService storage, 
    required LoggerService logger,
  }) : _storage = storage,
        _logger = logger {
    _loadData();
  }

  // ==================== Getters ====================
  
  /// العداد الحالي للجلسة
  int get count => _count;
  
  /// العداد اليومي
  int get dailyCount => _dailyCount;
  
  /// العداد الكلي
  int get totalCount => _totalCount;
  
  /// العداد الأسبوعي
  int get weeklyCount => _weeklyCount;
  
  /// العداد الشهري
  int get monthlyCount => _monthlyCount;
  
  /// تقدم الطقم الحالي (من 33)
  int get currentSetProgress => _count % 33;
  
  /// عدد الأطقم المكتملة
  int get completedSets => (_count / 33).floor();
  
  /// المتبقي في الطقم الحالي
  int get remainingInSet => 33 - (_count % 33 == 0 ? 0 : _count % 33);
  
  /// نسبة التقدم في الطقم الحالي
  double get setProgress => currentSetProgress / 33.0;
  
  /// الإحصائيات اليومية
  Map<String, int> get dailyStatistics => Map.unmodifiable(_dailyStatistics);
  
  /// الإحصائيات الأسبوعية
  Map<String, int> get weeklyStatistics => Map.unmodifiable(_weeklyStatistics);
  
  /// الإحصائيات الشهرية
  Map<String, int> get monthlyStatistics => Map.unmodifiable(_monthlyStatistics);
  
  /// الهدف اليومي
  int get dailyGoal => _dailyGoal;
  
  /// نوع التسبيح المختار
  String get selectedTasbihType => _selectedTasbihType;
  
  /// حالة الإشعارات
  bool get enableNotifications => _enableNotifications;
  
  /// حالة الاهتزاز
  bool get enableVibration => _enableVibration;
  
  /// حالة الصوت
  bool get enableSound => _enableSound;
  
  /// نسبة التقدم نحو الهدف اليومي
  double get dailyGoalProgress => _dailyGoal > 0 ? (_dailyCount / _dailyGoal).clamp(0.0, 1.0) : 0.0;
  
  /// هل تم تحقيق الهدف اليومي
  bool get isDailyGoalAchieved => _dailyCount >= _dailyGoal;

  // ==================== تحميل وحفظ البيانات ====================
  
  /// تحميل البيانات المحفوظة
  Future<void> _loadData() async {
    try {
      _logger.debug(message: '[TasbihService] Loading data...');
      
      // تحميل العدادات
      _count = _storage.getInt('${AppConstants.tasbihCounterKey}_current') ?? 0;
      _totalCount = _storage.getInt('${AppConstants.tasbihCounterKey}_total') ?? 0;
      _dailyCount = _storage.getInt('${AppConstants.tasbihCounterKey}_daily') ?? 0;
      _weeklyCount = _storage.getInt('${AppConstants.tasbihCounterKey}_weekly') ?? 0;
      _monthlyCount = _storage.getInt('${AppConstants.tasbihCounterKey}_monthly') ?? 0;
      
      // تحميل تاريخ آخر تحديث
      final lastUpdateString = _storage.getString('${AppConstants.tasbihCounterKey}_last_update');
      if (lastUpdateString != null) {
        _lastUpdateDate = DateTime.parse(lastUpdateString);
      }
      
      // تحميل الإعدادات
      _dailyGoal = _storage.getInt('${AppConstants.tasbihCounterKey}_daily_goal') ?? 100;
      _selectedTasbihType = _storage.getString('${AppConstants.tasbihCounterKey}_selected_type') ?? 'سبحان الله';
      _enableNotifications = _storage.getBool('${AppConstants.tasbihCounterKey}_notifications') ?? true;
      _enableVibration = _storage.getBool('${AppConstants.tasbihCounterKey}_vibration') ?? true;
      _enableSound = _storage.getBool('${AppConstants.tasbihCounterKey}_sound') ?? false;
      
      // تحميل الإحصائيات
      await _loadStatistics();
      
      // التحقق من تغيير الفترات الزمنية
      _checkDateChanges();
      
      _logger.debug(
        message: '[TasbihService] Data loaded successfully',
        data: {
          'count': _count,
          'dailyCount': _dailyCount,
          'totalCount': _totalCount,
          'dailyGoal': _dailyGoal,
        },
      );
      
      notifyListeners();
    } catch (e, stackTrace) {
      _logger.error(
        message: '[TasbihService] Error loading data',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
  
  /// تحميل الإحصائيات
  Future<void> _loadStatistics() async {
    try {
      // تحميل الإحصائيات اليومية
      final dailyStatsString = _storage.getString('${AppConstants.tasbihCounterKey}_daily_stats');
      if (dailyStatsString != null) {
        // يمكن تحويل من JSON هنا عند الحاجة
        // _dailyStatistics = jsonDecode(dailyStatsString);
      }
      
      // إضافة بعض البيانات التجريبية للأسبوع الماضي
      final now = DateTime.now();
      for (int i = 7; i >= 1; i--) {
        final date = now.subtract(Duration(days: i));
        final key = _formatDate(date);
        if (!_dailyStatistics.containsKey(key)) {
          _dailyStatistics[key] = (i * 15) % 50; // بيانات تجريبية
        }
      }
      
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error loading statistics',
        error: e,
      );
    }
  }
  
  /// التحقق من تغيير التواريخ
  void _checkDateChanges() {
    final now = DateTime.now();
    final lastUpdate = _lastUpdateDate;
    
    // التحقق من تغيير اليوم
    if (_isDifferentDay(now, lastUpdate)) {
      _handleDayChange();
    }
    
    // التحقق من تغيير الأسبوع
    if (_isDifferentWeek(now, lastUpdate)) {
      _handleWeekChange();
    }
    
    // التحقق من تغيير الشهر
    if (_isDifferentMonth(now, lastUpdate)) {
      _handleMonthChange();
    }
    
    _lastUpdateDate = now;
  }
  
  /// معالجة تغيير اليوم
  void _handleDayChange() {
    _logger.info(message: '[TasbihService] Day changed, resetting daily count');
    
    // حفظ إحصائيات اليوم السابق
    if (_dailyCount > 0) {
      final yesterday = _lastUpdateDate;
      final key = _formatDate(yesterday);
      _dailyStatistics[key] = _dailyCount;
    }
    
    // إعادة تعيين العداد اليومي
    _dailyCount = 0;
  }
  
  /// معالجة تغيير الأسبوع
  void _handleWeekChange() {
    _logger.info(message: '[TasbihService] Week changed, resetting weekly count');
    
    // حفظ إحصائيات الأسبوع السابق
    if (_weeklyCount > 0) {
      final lastWeek = _lastUpdateDate;
      final key = _formatWeek(lastWeek);
      _weeklyStatistics[key] = _weeklyCount;
    }
    
    // إعادة تعيين العداد الأسبوعي
    _weeklyCount = 0;
  }
  
  /// معالجة تغيير الشهر
  void _handleMonthChange() {
    _logger.info(message: '[TasbihService] Month changed, resetting monthly count');
    
    // حفظ إحصائيات الشهر السابق
    if (_monthlyCount > 0) {
      final lastMonth = _lastUpdateDate;
      final key = _formatMonth(lastMonth);
      _monthlyStatistics[key] = _monthlyCount;
    }
    
    // إعادة تعيين العداد الشهري
    _monthlyCount = 0;
  }
  
  /// حفظ البيانات
  Future<void> _saveData() async {
    try {
      await Future.wait([
        // حفظ العدادات
        _storage.setInt('${AppConstants.tasbihCounterKey}_current', _count),
        _storage.setInt('${AppConstants.tasbihCounterKey}_total', _totalCount),
        _storage.setInt('${AppConstants.tasbihCounterKey}_daily', _dailyCount),
        _storage.setInt('${AppConstants.tasbihCounterKey}_weekly', _weeklyCount),
        _storage.setInt('${AppConstants.tasbihCounterKey}_monthly', _monthlyCount),
        
        // حفظ التاريخ
        _storage.setString(
          '${AppConstants.tasbihCounterKey}_last_update',
          _lastUpdateDate.toIso8601String(),
        ),
        
        // حفظ الإعدادات
        _storage.setInt('${AppConstants.tasbihCounterKey}_daily_goal', _dailyGoal),
        _storage.setString('${AppConstants.tasbihCounterKey}_selected_type', _selectedTasbihType),
        _storage.setBool('${AppConstants.tasbihCounterKey}_notifications', _enableNotifications),
        _storage.setBool('${AppConstants.tasbihCounterKey}_vibration', _enableVibration),
        _storage.setBool('${AppConstants.tasbihCounterKey}_sound', _enableSound),
      ]);
      
      // حفظ الإحصائيات
      await _saveStatistics();
      
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error saving data',
        error: e,
      );
    }
  }
  
  /// حفظ الإحصائيات
  Future<void> _saveStatistics() async {
    try {
      // يمكن تحويل إلى JSON وحفظ الإحصائيات هنا
      // final dailyStatsJson = jsonEncode(_dailyStatistics);
      // await _storage.setString('${AppConstants.tasbihCounterKey}_daily_stats', dailyStatsJson);
      
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error saving statistics',
        error: e,
      );
    }
  }

  // ==================== العمليات الأساسية ====================
  
  /// زيادة العداد
  Future<void> increment() async {
    try {
      _checkDateChanges();
      
      _count++;
      _dailyCount++;
      _weeklyCount++;
      _monthlyCount++;
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
          'setProgress': setProgress,
          'completedSets': completedSets,
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
        message: '[TasbihService] Current count reset',
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
      _weeklyCount = 0;
      _monthlyCount = 0;
      _totalCount = 0;
      _dailyStatistics.clear();
      _weeklyStatistics.clear();
      _monthlyStatistics.clear();
      _lastUpdateDate = DateTime.now();
      
      notifyListeners();
      
      // حذف جميع البيانات المحفوظة
      await Future.wait([
        _storage.remove('${AppConstants.tasbihCounterKey}_current'),
        _storage.remove('${AppConstants.tasbihCounterKey}_total'),
        _storage.remove('${AppConstants.tasbihCounterKey}_daily'),
        _storage.remove('${AppConstants.tasbihCounterKey}_weekly'),
        _storage.remove('${AppConstants.tasbihCounterKey}_monthly'),
        _storage.remove('${AppConstants.tasbihCounterKey}_daily_stats'),
        _storage.remove('${AppConstants.tasbihCounterKey}_weekly_stats'),
        _storage.remove('${AppConstants.tasbihCounterKey}_monthly_stats'),
      ]);
      
      _logger.info(message: '[TasbihService] All data reset');
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error resetting all data',
        error: e,
      );
    }
  }

  // ==================== إدارة الإعدادات ====================
  
  /// تعيين الهدف اليومي
  Future<void> setDailyGoal(int goal) async {
    try {
      _dailyGoal = goal.clamp(1, 10000); // حد أدنى 1 وحد أقصى 10000
      notifyListeners();
      
      await _saveData();
      
      _logger.info(
        message: '[TasbihService] Daily goal updated',
        data: {'goal': _dailyGoal},
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error setting daily goal',
        error: e,
      );
    }
  }
  
  /// تعيين نوع التسبيح المختار
  Future<void> setSelectedTasbihType(String type) async {
    try {
      _selectedTasbihType = type;
      notifyListeners();
      
      await _saveData();
      
      _logger.debug(
        message: '[TasbihService] Selected tasbih type updated',
        data: {'type': type},
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error setting tasbih type',
        error: e,
      );
    }
  }
  
  /// تفعيل/إلغاء الإشعارات
  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      _enableNotifications = enabled;
      notifyListeners();
      
      await _saveData();
      
      _logger.debug(
        message: '[TasbihService] Notifications setting updated',
        data: {'enabled': enabled},
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error setting notifications',
        error: e,
      );
    }
  }
  
  /// تفعيل/إلغاء الاهتزاز
  Future<void> setVibrationEnabled(bool enabled) async {
    try {
      _enableVibration = enabled;
      notifyListeners();
      
      await _saveData();
      
      _logger.debug(
        message: '[TasbihService] Vibration setting updated',
        data: {'enabled': enabled},
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error setting vibration',
        error: e,
      );
    }
  }
  
  /// تفعيل/إلغاء الصوت
  Future<void> setSoundEnabled(bool enabled) async {
    try {
      _enableSound = enabled;
      notifyListeners();
      
      await _saveData();
      
      _logger.debug(
        message: '[TasbihService] Sound setting updated',
        data: {'enabled': enabled},
      );
    } catch (e) {
      _logger.error(
        message: '[TasbihService] Error setting sound',
        error: e,
      );
    }
  }

  // ==================== الإحصائيات والتقارير ====================
  
  /// الحصول على إحصائيات اليوم
  Map<String, dynamic> getTodayStatistics() {
    return {
      'current': _count,
      'daily': _dailyCount,
      'sets_completed': completedSets,
      'current_set_progress': currentSetProgress,
      'remaining_in_set': remainingInSet,
      'daily_goal': _dailyGoal,
      'daily_goal_progress': dailyGoalProgress,
      'daily_goal_achieved': isDailyGoalAchieved,
    };
  }
  
  /// الحصول على إحصائيات الأسبوع
  Map<String, int> getWeeklyStatistics() {
    final now = DateTime.now();
    final weekStats = <String, int>{};
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = _formatDate(date);
      
      if (i == 0) {
        // اليوم الحالي
        weekStats[key] = _dailyCount;
      } else {
        // الأيام السابقة من الإحصائيات المحفوظة
        weekStats[key] = _dailyStatistics[key] ?? 0;
      }
    }
    
    return weekStats;
  }
  
  /// الحصول على إحصائيات الشهر
  Map<String, int> getMonthlyStatistics() {
    final now = DateTime.now();
    final monthStats = <String, int>{};
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(now.year, now.month, i);
      final key = _formatDate(date);
      
      if (date.day == now.day) {
        // اليوم الحالي
        monthStats[key] = _dailyCount;
      } else if (date.isBefore(now)) {
        // الأيام السابقة من الإحصائيات المحفوظة
        monthStats[key] = _dailyStatistics[key] ?? 0;
      } else {
        // الأيام المستقبلية
        monthStats[key] = 0;
      }
    }
    
    return monthStats;
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
  
  /// الحصول على أطول سلسلة متتالية
  int getLongestStreak() {
    final weekStats = getWeeklyStatistics();
    int currentStreak = 0;
    int longestStreak = 0;
    
    for (final count in weekStats.values.toList().reversed) {
      if (count > 0) {
        currentStreak++;
        longestStreak = longestStreak > currentStreak ? longestStreak : currentStreak;
      } else {
        currentStreak = 0;
      }
    }
    
    return longestStreak;
  }
  
  /// الحصول على السلسلة الحالية
  int getCurrentStreak() {
    final weekStats = getWeeklyStatistics();
    int currentStreak = 0;
    
    for (final count in weekStats.values.toList().reversed) {
      if (count > 0) {
        currentStreak++;
      } else {
        break;
      }
    }
    
    return currentStreak;
  }

  // ==================== دوال مساعدة ====================
  
  /// فحص إذا كان التاريخان في أيام مختلفة
  bool _isDifferentDay(DateTime date1, DateTime date2) {
    return date1.year != date2.year ||
           date1.month != date2.month ||
           date1.day != date2.day;
  }
  
  /// فحص إذا كان التاريخان في أسابيع مختلفة
  bool _isDifferentWeek(DateTime date1, DateTime date2) {
    final weekday1 = date1.weekday;
    final weekday2 = date2.weekday;
    final daysDiff = date1.difference(date2).inDays;
    
    return daysDiff >= 7 || (daysDiff > 0 && weekday1 < weekday2);
  }
  
  /// فحص إذا كان التاريخان في أشهر مختلفة
  bool _isDifferentMonth(DateTime date1, DateTime date2) {
    return date1.year != date2.year || date1.month != date2.month;
  }
  
  /// تنسيق التاريخ كسلسلة نصية
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  /// تنسيق الأسبوع كسلسلة نصية
  String _formatWeek(DateTime date) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    return 'W${_formatDate(weekStart)}';
  }
  
  /// تنسيق الشهر كسلسلة نصية
  String _formatMonth(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }
  
  /// التنظيف عند إنهاء الخدمة
  @override
  void dispose() {
    _saveData();
    super.dispose();
  }
}