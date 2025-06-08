
// lib/core/services/notification/models/notification_models.dart

import 'package:flutter/material.dart';

/// أولوية الإشعار
enum NotificationPriority {
  high,   // للصلاة والتنبيهات المهمة
  normal, // للأذكار العادية
  low     // للتذكيرات العامة
}

/// تكرار الإشعار
enum NotificationRepeat {
  once,     // مرة واحدة
  daily,    // يومياً
  weekly,   // أسبوعياً
  custom    // مخصص
}

/// فئة الإشعار
enum NotificationCategory {
  prayer,    // إشعارات الصلاة
  athkar,    // إشعارات الأذكار
  quran,     // إشعارات القرآن
  reminder,  // تذكيرات عامة
  system     // إشعارات النظام
}

/// بيانات الإشعار
class NotificationData {
  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
  final NotificationPriority priority;
  final Map<String, dynamic>? payload;
  final DateTime? scheduledTime;
  final NotificationRepeat? repeatType;
  
  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    this.priority = NotificationPriority.normal,
    this.payload,
    this.scheduledTime,
    this.repeatType,
  });
  
  /// تحويل لـ JSON للتخزين
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'category': category.index,
    'priority': priority.index,
    'payload': payload,
    'scheduledTime': scheduledTime?.toIso8601String(),
    'repeatType': repeatType?.index,
  };
  
  /// إنشاء من JSON
  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      category: NotificationCategory.values[json['category']],
      priority: NotificationPriority.values[json['priority'] ?? 1],
      payload: json['payload'],
      scheduledTime: json['scheduledTime'] != null 
          ? DateTime.parse(json['scheduledTime'])
          : null,
      repeatType: json['repeatType'] != null
          ? NotificationRepeat.values[json['repeatType']]
          : null,
    );
  }
}

/// حدث النقر على الإشعار
class NotificationTapEvent {
  final String notificationId;
  final NotificationCategory category;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  
  NotificationTapEvent({
    required this.notificationId,
    required this.category,
    required this.payload,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// إعدادات الإشعارات
class NotificationSettings {
  final bool enabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final TimeOfDay? quietTimeStart;
  final TimeOfDay? quietTimeEnd;
  final int? minBatteryLevel;
  
  const NotificationSettings({
    this.enabled = true,
    this.soundEnabled = false, // دائماً false حسب متطلباتك
    this.vibrationEnabled = true,
    this.quietTimeStart,
    this.quietTimeEnd,
    this.minBatteryLevel = 15,
  });
  
  /// نسخ مع تعديل
  NotificationSettings copyWith({
    bool? enabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    TimeOfDay? quietTimeStart,
    TimeOfDay? quietTimeEnd,
    int? minBatteryLevel,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      quietTimeStart: quietTimeStart ?? this.quietTimeStart,
      quietTimeEnd: quietTimeEnd ?? this.quietTimeEnd,
      minBatteryLevel: minBatteryLevel ?? this.minBatteryLevel,
    );
  }
  
  /// التحقق من وقت الهدوء
  bool isInQuietTime() {
    if (quietTimeStart == null || quietTimeEnd == null) return false;
    
    final now = TimeOfDay.now();
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = quietTimeStart!.hour * 60 + quietTimeStart!.minute;
    final endMinutes = quietTimeEnd!.hour * 60 + quietTimeEnd!.minute;
    
    if (startMinutes <= endMinutes) {
      // نفس اليوم
      return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
    } else {
      // عبر منتصف الليل
      return nowMinutes >= startMinutes || nowMinutes <= endMinutes;
    }
  }
}