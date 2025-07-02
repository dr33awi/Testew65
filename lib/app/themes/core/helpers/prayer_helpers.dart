// lib/features/prayer_times/utils/prayer_helpers.dart - مُصحح نهائياً
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../../../features/prayer_times/models/prayer_time_model.dart';

/// مساعدات خاصة بمواقيت الصلاة
class PrayerHelpers {
  PrayerHelpers._();

  /// تنسيق الوقت بصيغة 12 ساعة
  static String formatTime12Hour(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  /// الحصول على لون الصلاة - استخدام النظام الموحد
  static Color getPrayerColor(String prayerName) {
    return AppColorSystem.getPrayerColor(prayerName); // ✅ صحيح
  }

  /// الحصول على أيقونة الصلاة - استخدام النظام الموحد
  static IconData getPrayerIcon(String prayerName) {
    return AppIconsSystem.getPrayerIcon(prayerName); // ✅ صحيح
  }

  /// الحصول على تدرج لون الصلاة - استخدام النظام الموحد
  static LinearGradient getPrayerGradient(String prayerName) {
    return AppColorSystem.getPrayerGradient(prayerName); // ✅ صحيح
  }

  /// حساب المدة المتبقية حتى الصلاة
  static Duration getTimeUntilPrayer(DateTime prayerTime) {
    final now = DateTime.now();
    if (prayerTime.isBefore(now)) {
      final nextDay = prayerTime.add(const Duration(days: 1));
      return nextDay.difference(now);
    }
    return prayerTime.difference(now);
  }

  /// تحقق من كون الصلاة قد مضت
  static bool isPrayerPassed(DateTime prayerTime) {
    return DateTime.now().isAfter(prayerTime);
  }

  /// الحصول على الصلاة التالية من قائمة الصلوات
  static PrayerTime? getNextPrayer(List<PrayerTime> prayers) {
    final now = DateTime.now();
    
    final futurePrayers = prayers
        .where((prayer) => prayer.time.isAfter(now))
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));
    
    return futurePrayers.isNotEmpty ? futurePrayers.first : null;
  }

  /// تنسيق المدة الزمنية (ساعات ودقائق)
  static String formatDuration(Duration duration) {
    if (duration.isNegative) return '00:00';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}س ${minutes}د';
    } else {
      return '${minutes}د';
    }
  }
}

