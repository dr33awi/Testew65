// lib/core/services/notification/notification_manager.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'notification_service.dart';
import 'models/notification_models.dart';

/// مدير مركزي للإشعارات
/// يوفر واجهة سهلة لجميع أجزاء التطبيق
class NotificationManager {
  final NotificationService _service;
  
  // Singleton pattern
  static NotificationManager? _instance;
  
  NotificationManager._(this._service);
  
  /// الحصول على instance واحد
  static NotificationManager get instance {
    if (_instance == null) {
      throw StateError('NotificationManager not initialized');
    }
    return _instance!;
  }
  
  /// تهيئة المدير
  static Future<void> initialize(NotificationService service) async {
    _instance = NotificationManager._(service);
    await _instance!._service.initialize();
  }
  
  /// طلب الأذونات
  Future<bool> requestPermission() => _service.requestPermission();
  
  /// التحقق من الأذونات
  Future<bool> hasPermission() => _service.hasPermission();
  
  /// الاستماع للنقرات
  Stream<NotificationTapEvent> get onTap => _service.onNotificationTap;
  
  // ========== إشعارات الصلاة ==========
  
  /// جدولة إشعار الصلاة
  Future<void> schedulePrayerNotification({
    required String prayerName,
    required String arabicName,
    required DateTime time,
    int minutesBefore = 0,
  }) async {
    final scheduledTime = time.subtract(Duration(minutes: minutesBefore));
    final id = 'prayer_${prayerName}_${time.millisecondsSinceEpoch}';
    
    final notification = NotificationData(
      id: id,
      title: minutesBefore > 0 
          ? 'اقترب وقت $arabicName'
          : 'حان وقت $arabicName',
      body: minutesBefore > 0
          ? 'بعد $minutesBefore دقيقة'
          : 'حان الآن وقت صلاة $arabicName',
      category: NotificationCategory.prayer,
      priority: NotificationPriority.high,
      scheduledTime: scheduledTime,
      repeatType: NotificationRepeat.daily,
      payload: {
        'prayer': prayerName,
        'time': time.toIso8601String(),
      },
    );
    
    await _service.scheduleNotification(notification);
  }
  
  /// إلغاء جميع إشعارات الصلاة
  Future<void> cancelAllPrayerNotifications() async {
    await _service.cancelCategoryNotifications(NotificationCategory.prayer);
  }
  
  // ========== إشعارات الأذكار ==========
  
  /// جدولة تذكير الأذكار
  Future<void> scheduleAthkarReminder({
    required String categoryId,
    required String categoryName,
    required TimeOfDay time,
    NotificationRepeat repeat = NotificationRepeat.daily,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    
    // إذا مر الوقت اليوم، جدولة لليوم التالي
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    final notification = NotificationData(
      id: 'athkar_$categoryId',
      title: 'وقت $categoryName',
      body: 'حان وقت قراءة $categoryName',
      category: NotificationCategory.athkar,
      priority: NotificationPriority.normal,
      scheduledTime: scheduledDate,
      repeatType: repeat,
      payload: {
        'categoryId': categoryId,
        'categoryName': categoryName,
      },
    );
    
    await _service.scheduleNotification(notification);
  }
  
  /// إلغاء تذكير أذكار محدد
  Future<void> cancelAthkarReminder(String categoryId) async {
    await _service.cancelNotification('athkar_$categoryId');
  }
  
  /// إلغاء جميع تذكيرات الأذكار
  Future<void> cancelAllAthkarReminders() async {
    await _service.cancelCategoryNotifications(NotificationCategory.athkar);
  }
  
  // ========== إشعارات القرآن ==========
  
  /// تذكير بالورد اليومي
  Future<void> scheduleQuranReminder({
    required TimeOfDay time,
    String message = 'حان وقت قراءة وردك اليومي من القرآن الكريم',
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    final notification = NotificationData(
      id: 'quran_daily_wird',
      title: 'الورد اليومي',
      body: message,
      category: NotificationCategory.quran,
      priority: NotificationPriority.normal,
      scheduledTime: scheduledDate,
      repeatType: NotificationRepeat.daily,
      payload: {
        'type': 'daily_wird',
      },
    );
    
    await _service.scheduleNotification(notification);
  }
  
  // ========== إشعارات عامة ==========
  
  /// عرض إشعار فوري
  Future<void> showInstantNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    final notification = NotificationData(
      id: 'instant_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      category: NotificationCategory.system,
      priority: priority,
      payload: payload,
    );
    
    await _service.showNotification(notification);
  }
  
  /// جدولة تذكير مخصص
  Future<void> scheduleCustomReminder({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    NotificationRepeat? repeat,
    Map<String, dynamic>? payload,
  }) async {
    final notification = NotificationData(
      id: 'custom_$id',
      title: title,
      body: body,
      category: NotificationCategory.reminder,
      priority: NotificationPriority.normal,
      scheduledTime: scheduledTime,
      repeatType: repeat,
      payload: payload,
    );
    
    await _service.scheduleNotification(notification);
  }
  
  // ========== الإعدادات ==========
  
  /// تحديث إعدادات الإشعارات
  Future<void> updateSettings(NotificationSettings settings) async {
    await _service.updateSettings(settings);
  }
  
  /// الحصول على الإعدادات الحالية
  Future<NotificationSettings> getSettings() => _service.getSettings();
  
  /// تفعيل/تعطيل الإشعارات
  Future<void> setEnabled(bool enabled) async {
    final settings = await getSettings();
    await updateSettings(settings.copyWith(enabled: enabled));
  }
  
  /// تعيين وقت الهدوء
  Future<void> setQuietTime({
    TimeOfDay? start,
    TimeOfDay? end,
  }) async {
    final settings = await getSettings();
    await updateSettings(settings.copyWith(
      quietTimeStart: start,
      quietTimeEnd: end,
    ));
  }
  
  /// تعيين الحد الأدنى للبطارية
  Future<void> setMinBatteryLevel(int? level) async {
    final settings = await getSettings();
    await updateSettings(settings.copyWith(
      minBatteryLevel: level,
    ));
  }
  
  // ========== إدارة الإشعارات ==========
  
  /// الحصول على الإشعارات المجدولة
  Future<List<NotificationData>> getScheduledNotifications() {
    return _service.getScheduledNotifications();
  }
  
  /// إلغاء إشعار محدد
  Future<void> cancelNotification(String id) {
    return _service.cancelNotification(id);
  }
  
  /// إلغاء جميع الإشعارات
  Future<void> cancelAllNotifications() {
    return _service.cancelAllNotifications();
  }
  
  /// التنظيف
  Future<void> dispose() {
    return _service.dispose();
  }
}