// lib/core/services/notification/notification_service.dart

import 'dart:async';
import 'models/notification_models.dart';

/// واجهة خدمة الإشعارات الموحدة
abstract class NotificationService {
  /// تهيئة الخدمة
  Future<void> initialize();
  
  /// طلب إذن الإشعارات
  Future<bool> requestPermission();
  
  /// التحقق من حالة الإذن
  Future<bool> hasPermission();
  
  /// عرض إشعار فوري
  Future<void> showNotification(NotificationData notification);
  
  /// جدولة إشعار
  Future<void> scheduleNotification(NotificationData notification);
  
  /// إلغاء إشعار
  Future<void> cancelNotification(String notificationId);
  
  /// إلغاء جميع الإشعارات
  Future<void> cancelAllNotifications();
  
  /// إلغاء إشعارات فئة معينة
  Future<void> cancelCategoryNotifications(NotificationCategory category);
  
  /// الحصول على الإشعارات المجدولة
  Future<List<NotificationData>> getScheduledNotifications();
  
  /// تحديث إعدادات الإشعارات
  Future<void> updateSettings(NotificationSettings settings);
  
  /// الحصول على الإعدادات الحالية
  Future<NotificationSettings> getSettings();
  
  /// الاستماع لأحداث النقر على الإشعارات
  Stream<NotificationTapEvent> get onNotificationTap;
  
  /// التنظيف عند إغلاق التطبيق
  Future<void> dispose();
}