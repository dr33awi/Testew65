// lib/features/prayer_times/utils/prayer_extensions.dart

import 'package:flutter/material.dart';
import '../models/prayer_time_model.dart';
import 'prayer_helpers.dart';

/// Extensions لنموذج وقت الصلاة
extension PrayerTimeExtensions on PrayerTime {
  /// الوقت المنسق بصيغة 12 ساعة
  String get formattedTime => PrayerHelpers.formatPrayerTime(time);
  
  /// الوقت المنسق بصيغة 24 ساعة
  String get formattedTime24 => PrayerHelpers.formatPrayerTime(time, use24Hour: true);
  
  /// وقت الإقامة المنسق
  String? get formattedIqamaTime => 
      iqamaTime != null ? PrayerHelpers.formatPrayerTime(iqamaTime!) : null;
  
  /// وقت الأذان المنسق
  String? get formattedAdhanTime => 
      adhanTime != null ? PrayerHelpers.formatPrayerTime(adhanTime!) : null;
  
  /// اللون المناسب للصلاة
  Color get color => PrayerHelpers.getPrayerColor(type);
  
  /// الأيقونة المناسبة للصلاة
  IconData get icon => PrayerHelpers.getPrayerIcon(type);
  
  /// التدرج اللوني للصلاة
  List<Color> get gradient => PrayerHelpers.getPrayerGradient(type);
  
  /// التدرج الخطي من ThemeConstants
  LinearGradient get linearGradient => PrayerHelpers.getPrayerLinearGradient(type);
  
  /// نص الحالة (متبقي، انتهى، قادم)
  String get statusText => PrayerHelpers.getPrayerStatusText(this);
  
  /// التحقق من اقتراب الوقت
  bool get isApproachingSoon => PrayerHelpers.isPrayerApproaching(this);
  
  /// التحقق من اقتراب الوقت مع تحديد الدقائق
  bool isApproachingIn(int minutes) => PrayerHelpers.isPrayerApproaching(this, minutesBefore: minutes);
  
  /// الوقت المتبقي كنص منسق
  String get formattedRemainingTime => PrayerHelpers.formatRemainingTime(remainingTime);
  
  /// التحقق من أن الصلاة حالية (بين وقتها ووقت الصلاة التالية)
  bool isCurrent(PrayerTime? nextPrayer) {
    if (!isPassed || nextPrayer == null) return false;
    final now = DateTime.now();
    return now.isAfter(time) && now.isBefore(nextPrayer.time);
  }
  
  /// الحصول على رسالة التنبيه
  String getNotificationMessage(int minutesBefore) {
    return PrayerHelpers.getNotificationMessage(type, minutesBefore);
  }
}

/// Extensions لمواقيت الصلاة اليومية
extension DailyPrayerTimesExtensions on DailyPrayerTimes {
  /// الصلوات الرئيسية فقط (الخمس صلوات)
  List<PrayerTime> get mainPrayers => prayers.where((prayer) =>
    prayer.type != PrayerType.sunrise &&
    prayer.type != PrayerType.midnight &&
    prayer.type != PrayerType.lastThird
  ).toList();
  
  /// الصلوات الإضافية (شروق، منتصف الليل، الثلث الأخير)
  List<PrayerTime> get additionalPrayers => prayers.where((prayer) =>
    prayer.type == PrayerType.sunrise ||
    prayer.type == PrayerType.midnight ||
    prayer.type == PrayerType.lastThird
  ).toList();
  
  /// الصلوات التي انتهت
  List<PrayerTime> get passedPrayers => prayers.where((p) => p.isPassed).toList();
  
  /// الصلوات القادمة
  List<PrayerTime> get upcomingPrayers => prayers.where((p) => !p.isPassed).toList();
  
  /// الصلاة بنوع محدد
  PrayerTime? getPrayerByType(PrayerType type) {
    try {
      return prayers.firstWhere((p) => p.type == type);
    } catch (_) {
      return null;
    }
  }
  
  /// صلاة الفجر
  PrayerTime? get fajr => getPrayerByType(PrayerType.fajr);
  
  /// صلاة الظهر
  PrayerTime? get dhuhr => getPrayerByType(PrayerType.dhuhr);
  
  /// صلاة العصر
  PrayerTime? get asr => getPrayerByType(PrayerType.asr);
  
  /// صلاة المغرب
  PrayerTime? get maghrib => getPrayerByType(PrayerType.maghrib);
  
  /// صلاة العشاء
  PrayerTime? get isha => getPrayerByType(PrayerType.isha);
  
  /// وقت الشروق
  PrayerTime? get sunrise => getPrayerByType(PrayerType.sunrise);
  
  /// نسبة التقدم في اليوم (بناءً على الصلوات)
  double get dayProgress {
    final mainPrayersList = mainPrayers;
    if (mainPrayersList.isEmpty) return 0.0;
    
    final passedCount = mainPrayersList.where((p) => p.isPassed).length;
    return (passedCount / mainPrayersList.length).clamp(0.0, 1.0);
  }
  
  /// نسبة التقدم بين الصلاة الحالية والتالية
  double get currentPrayerProgress {
    if (currentPrayer == null || nextPrayer == null) return 0.0;
    return PrayerHelpers.calculateProgressBetweenPrayers(currentPrayer!, nextPrayer!);
  }
  
  /// التحقق من وجود صلاة قريبة
  bool get hasApproachingPrayer {
    return prayers.any((p) => p.isApproachingSoon);
  }
  
  /// الحصول على الصلوات القريبة
  List<PrayerTime> getApproachingPrayers({int minutesBefore = 15}) {
    return prayers.where((p) => p.isApproachingIn(minutesBefore)).toList();
  }
  
  /// نسخة محدثة من المواقيت
  DailyPrayerTimes get updated => updatePrayerStates();
}

/// Extensions لإعدادات الحساب
extension PrayerCalculationSettingsExtensions on PrayerCalculationSettings {
  /// اسم طريقة الحساب
  String get methodName => PrayerHelpers.getCalculationMethodName(method);
  
  /// وصف طريقة الحساب
  String get methodDescription => PrayerHelpers.getCalculationMethodDescription(method);
  
  /// اسم المذهب
  String get juristicName => PrayerHelpers.getJuristicName(asrJuristic);
  
  /// التحقق من وجود تعديلات يدوية
  bool get hasManualAdjustments => manualAdjustments.values.any((v) => v != 0);
  
  /// عدد التعديلات اليدوية
  int get manualAdjustmentCount => manualAdjustments.values.where((v) => v != 0).length;
}

/// Extensions لإعدادات التنبيهات
extension PrayerNotificationSettingsExtensions on PrayerNotificationSettings {
  /// عدد الصلوات المفعلة للتنبيه
  int get enabledPrayersCount => enabledPrayers.values.where((v) => v).length;
  
  /// التحقق من تفعيل تنبيه صلاة معينة
  bool isPrayerEnabled(PrayerType type) => enabledPrayers[type] ?? false;
  
  /// الحصول على وقت التنبيه قبل الصلاة
  int getMinutesBefore(PrayerType type) => minutesBefore[type] ?? 0;
  
  /// التحقق من وجود أي تنبيه مفعل
  bool get hasAnyEnabled => enabledPrayers.values.any((v) => v);
}

/// Extensions للموقع
extension PrayerLocationExtensions on PrayerLocation {
  /// الموقع كنص
  String get displayName {
    if (cityName != null && countryName != null) {
      return '$cityName، $countryName';
    } else if (cityName != null) {
      return cityName!;
    } else if (countryName != null) {
      return countryName!;
    } else {
      return 'موقع غير محدد';
    }
  }
  
  /// الإحداثيات كنص
  String get coordinatesText {
    return 'خط العرض: ${latitude.toStringAsFixed(4)}° • خط الطول: ${longitude.toStringAsFixed(4)}°';
  }
  
  /// الارتفاع كنص
  String? get altitudeText {
    if (altitude == null) return null;
    return 'الارتفاع: ${altitude!.toStringAsFixed(0)} متر';
  }
}