// lib/core/services/notification/notification_service_impl.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:battery_plus/battery_plus.dart';

import 'notification_service.dart';
import 'models/notification_models.dart';

class NotificationServiceImpl implements NotificationService {
  static const String _settingsKey = 'notification_settings';
  static const String _scheduledKey = 'scheduled_notifications';
  
  final FlutterLocalNotificationsPlugin _plugin;
  final SharedPreferences _prefs;
  final Battery _battery;
  
  final StreamController<NotificationTapEvent> _tapController = 
      StreamController<NotificationTapEvent>.broadcast();
  
  NotificationSettings _currentSettings = const NotificationSettings();
  
  NotificationServiceImpl({
    required SharedPreferences prefs,
    FlutterLocalNotificationsPlugin? plugin,
    Battery? battery,
  }) : _prefs = prefs,
       _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _battery = battery ?? Battery();
  
  @override
  Future<void> initialize() async {
    // تهيئة المنطقة الزمنية
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    
    // تحميل الإعدادات المحفوظة
    await _loadSettings();
    
    // إعدادات Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // إعدادات iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    
    // تهيئة المكون
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );
    
    // إنشاء قنوات Android
    if (Platform.isAndroid) {
      await _createAndroidChannels();
    }
  }
  
  /// إنشاء قنوات Android
  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin == null) return;
    
    // قناة الصلاة (أولوية عالية)
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'prayer_channel',
        'مواقيت الصلاة',
        description: 'تنبيهات أوقات الصلاة',
        importance: Importance.high,
        playSound: false,
        enableVibration: true,
      ),
    );
    
    // قناة الأذكار (أولوية متوسطة)
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'athkar_channel',
        'الأذكار',
        description: 'تذكيرات الأذكار اليومية',
        importance: Importance.defaultImportance,
        playSound: false,
        enableVibration: true,
      ),
    );
    
    // قناة عامة (أولوية منخفضة)
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'general_channel',
        'عام',
        description: 'إشعارات وتذكيرات عامة',
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
      ),
    );
  }
  
  @override
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: false,
      );
      return granted ?? false;
    } else if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestNotificationsPermission();
      return granted ?? true;
    }
    return false;
  }
  
  @override
  Future<bool> hasPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.areNotificationsEnabled() ?? false;
    }
    // iOS يحتاج طريقة مختلفة للتحقق
    return true;
  }
  
  @override
  Future<void> showNotification(NotificationData notification) async {
    // التحقق من الإعدادات
    if (!_currentSettings.enabled) return;
    
    // التحقق من وقت الهدوء
    if (_currentSettings.isInQuietTime()) return;
    
    // التحقق من البطارية
    if (await _shouldCheckBattery() && !await _hasSufficientBattery()) return;
    
    final details = await _buildNotificationDetails(notification);
    
    await _plugin.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode({
        'id': notification.id,
        'category': notification.category.index,
        'payload': notification.payload ?? {},
      }),
    );
  }
  
  @override
  Future<void> scheduleNotification(NotificationData notification) async {
    if (notification.scheduledTime == null) {
      throw ArgumentError('يجب تحديد وقت الجدولة');
    }
    
    // التحقق من الإعدادات
    if (!_currentSettings.enabled) return;
    
    final details = await _buildNotificationDetails(notification);
    final scheduledDate = tz.TZDateTime.from(
      notification.scheduledTime!,
      tz.local,
    );
    
    // التأكد من أن الوقت في المستقبل
    final now = tz.TZDateTime.now(tz.local);
    if (scheduledDate.isBefore(now)) {
      return;
    }
    
    await _plugin.zonedSchedule(
      notification.id.hashCode,
      notification.title,
      notification.body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: _getDateTimeComponents(notification.repeatType),
      payload: jsonEncode({
        'id': notification.id,
        'category': notification.category.index,
        'payload': notification.payload ?? {},
      }),
    );
    
    // حفظ الإشعار المجدول
    await _saveScheduledNotification(notification);
  }
  
  @override
  Future<void> cancelNotification(String notificationId) async {
    await _plugin.cancel(notificationId.hashCode);
    await _removeScheduledNotification(notificationId);
  }
  
  @override
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
    await _prefs.remove(_scheduledKey);
  }
  
  @override
  Future<void> cancelCategoryNotifications(NotificationCategory category) async {
    final scheduled = await getScheduledNotifications();
    
    for (final notification in scheduled) {
      if (notification.category == category) {
        await cancelNotification(notification.id);
      }
    }
  }
  
  @override
  Future<List<NotificationData>> getScheduledNotifications() async {
    final jsonList = _prefs.getStringList(_scheduledKey) ?? [];
    
    return jsonList
        .map((json) => NotificationData.fromJson(jsonDecode(json)))
        .toList();
  }
  
  @override
  Future<void> updateSettings(NotificationSettings settings) async {
    _currentSettings = settings;
    await _saveSettings();
    
    // إذا تم تعطيل الإشعارات، إلغاء جميع المجدولة
    if (!settings.enabled) {
      await cancelAllNotifications();
    }
  }
  
  @override
  Future<NotificationSettings> getSettings() async {
    return _currentSettings;
  }
  
  @override
  Stream<NotificationTapEvent> get onNotificationTap => _tapController.stream;
  
  @override
  Future<void> dispose() async {
    await _tapController.close();
  }
  
  // ============= Helper Methods =============
  
  /// بناء تفاصيل الإشعار
  Future<NotificationDetails> _buildNotificationDetails(
    NotificationData notification,
  ) async {
    final channelId = _getChannelId(notification.category);
    final channelName = _getChannelName(notification.category);
    
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: _getImportance(notification.priority),
      priority: _getPriority(notification.priority),
      playSound: false, // دائماً false
      enableVibration: _currentSettings.vibrationEnabled,
      channelShowBadge: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );
    
    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }
  
  /// معالجة النقر على الإشعار
  void _handleNotificationTap(NotificationResponse response) {
    if (response.payload == null) return;
    
    try {
      final data = jsonDecode(response.payload!);
      
      _tapController.add(NotificationTapEvent(
        notificationId: data['id'],
        category: NotificationCategory.values[data['category']],
        payload: data['payload'] ?? {},
      ));
    } catch (e) {
      // معالجة الخطأ
    }
  }
  
  /// الحصول على معرف القناة
  String _getChannelId(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.prayer:
        return 'prayer_channel';
      case NotificationCategory.athkar:
        return 'athkar_channel';
      default:
        return 'general_channel';
    }
  }
  
  /// الحصول على اسم القناة
  String _getChannelName(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.prayer:
        return 'مواقيت الصلاة';
      case NotificationCategory.athkar:
        return 'الأذكار';
      default:
        return 'عام';
    }
  }
  
  /// تحويل الأولوية
  Importance _getImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.normal:
        return Importance.defaultImportance;
      case NotificationPriority.low:
        return Importance.low;
    }
  }
  
  /// تحويل أولوية Android
  Priority _getPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.normal:
        return Priority.defaultPriority;
      case NotificationPriority.low:
        return Priority.low;
    }
  }
  
  /// الحصول على مكونات التاريخ والوقت للتكرار
  DateTimeComponents? _getDateTimeComponents(NotificationRepeat? repeat) {
    switch (repeat) {
      case NotificationRepeat.daily:
        return DateTimeComponents.time;
      case NotificationRepeat.weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      default:
        return null;
    }
  }
  
  /// التحقق من البطارية
  Future<bool> _shouldCheckBattery() async {
    return _currentSettings.minBatteryLevel != null &&
           _currentSettings.minBatteryLevel! > 0;
  }
  
  /// التحقق من مستوى البطارية
  Future<bool> _hasSufficientBattery() async {
    try {
      final level = await _battery.batteryLevel;
      final minLevel = _currentSettings.minBatteryLevel ?? 15;
      return level >= minLevel;
    } catch (e) {
      // في حالة الخطأ، نسمح بالإشعار
      return true;
    }
  }
  
  /// حفظ الإعدادات
  Future<void> _saveSettings() async {
    await _prefs.setString(
      _settingsKey,
      jsonEncode({
        'enabled': _currentSettings.enabled,
        'soundEnabled': _currentSettings.soundEnabled,
        'vibrationEnabled': _currentSettings.vibrationEnabled,
        'quietTimeStart': _currentSettings.quietTimeStart != null
            ? '${_currentSettings.quietTimeStart!.hour}:${_currentSettings.quietTimeStart!.minute}'
            : null,
        'quietTimeEnd': _currentSettings.quietTimeEnd != null
            ? '${_currentSettings.quietTimeEnd!.hour}:${_currentSettings.quietTimeEnd!.minute}'
            : null,
        'minBatteryLevel': _currentSettings.minBatteryLevel,
      }),
    );
  }
  
  /// تحميل الإعدادات
  Future<void> _loadSettings() async {
    final json = _prefs.getString(_settingsKey);
    if (json == null) return;
    
    try {
      final data = jsonDecode(json);
      
      _currentSettings = NotificationSettings(
        enabled: data['enabled'] ?? true,
        soundEnabled: false, // دائماً false
        vibrationEnabled: data['vibrationEnabled'] ?? true,
        quietTimeStart: _parseTimeOfDay(data['quietTimeStart']),
        quietTimeEnd: _parseTimeOfDay(data['quietTimeEnd']),
        minBatteryLevel: data['minBatteryLevel'],
      );
    } catch (e) {
      // معالجة الخطأ
    }
  }
  
  /// تحويل نص إلى TimeOfDay
  TimeOfDay? _parseTimeOfDay(String? time) {
    if (time == null) return null;
    
    try {
      final parts = time.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (e) {
      return null;
    }
  }
  
  /// حفظ الإشعار المجدول
  Future<void> _saveScheduledNotification(NotificationData notification) async {
    final scheduled = await getScheduledNotifications();
    scheduled.add(notification);
    
    await _prefs.setStringList(
      _scheduledKey,
      scheduled.map((n) => jsonEncode(n.toJson())).toList(),
    );
  }
  
  /// إزالة الإشعار المجدول
  Future<void> _removeScheduledNotification(String notificationId) async {
    final scheduled = await getScheduledNotifications();
    scheduled.removeWhere((n) => n.id == notificationId);
    
    await _prefs.setStringList(
      _scheduledKey,
      scheduled.map((n) => jsonEncode(n.toJson())).toList(),
    );
  }
}