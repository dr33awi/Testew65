// lib/features/prayer_times/utils/prayer_helpers.dart

import 'package:athkar_app/app/themes/core/theme_extensions.dart';
import 'package:flutter/material.dart';
import '../../../app/themes/theme_constants.dart';
import '../models/prayer_time_model.dart';

/// أدوات مساعدة لمواقيت الصلاة
class PrayerHelpers {
  PrayerHelpers._();
  
  /// تنسيق وقت الصلاة
  static String formatPrayerTime(DateTime time, {bool showPeriod = true, bool use24Hour = false}) {
    if (use24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    if (showPeriod) {
      return '$displayHour:$minute $period';
    } else {
      return '$displayHour:$minute';
    }
  }
  
  /// تنسيق الوقت المتبقي
  static String formatRemainingTime(Duration duration) {
    if (duration.isNegative || duration.inSeconds == 0) {
      return 'حان الآن';
    }
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return 'بعد $hours ساعة و$minutes دقيقة';
    } else if (minutes > 0) {
      return 'بعد $minutes دقيقة';
    } else {
      return 'بعد ${duration.inSeconds} ثانية';
    }
  }
  
  /// الحصول على لون الصلاة من الثوابت
  static Color getPrayerColor(PrayerType type) {
    return ThemeConstants.getPrayerColor(type.name);
  }
  
  /// الحصول على أيقونة الصلاة من الثوابت
  static IconData getPrayerIcon(PrayerType type) {
    return ThemeConstants.getPrayerIcon(type.name);
  }
  
  /// الحصول على تدرج لون الصلاة
  static List<Color> getPrayerGradient(PrayerType type) {
    final baseColor = getPrayerColor(type);
    return [baseColor, baseColor.darken(0.2)];
  }
  
  /// الحصول على تدرج من ThemeConstants
  static LinearGradient getPrayerLinearGradient(PrayerType type) {
    return ThemeConstants.prayerGradient(type.name);
  }
  
  /// تحديد إذا كان الوقت في النهار
  static bool isDayTime(DateTime time) {
    final hour = time.hour;
    return hour >= 6 && hour < 18;
  }
  
  /// الحصول على اسم الصلاة بالعربية
  static String getPrayerNameAr(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return 'الفجر';
      case PrayerType.sunrise:
        return 'الشروق';
      case PrayerType.dhuhr:
        return 'الظهر';
      case PrayerType.asr:
        return 'العصر';
      case PrayerType.maghrib:
        return 'المغرب';
      case PrayerType.isha:
        return 'العشاء';
      case PrayerType.midnight:
        return 'منتصف الليل';
      case PrayerType.lastThird:
        return 'الثلث الأخير';
    }
  }
  
  /// الحصول على اسم الصلاة بالإنجليزية
  static String getPrayerNameEn(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.sunrise:
        return 'Sunrise';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
      case PrayerType.midnight:
        return 'Midnight';
      case PrayerType.lastThird:
        return 'Last Third';
    }
  }
  
  /// التحقق من اقتراب وقت الصلاة
  static bool isPrayerApproaching(PrayerTime prayer, {int minutesBefore = 15}) {
    final now = DateTime.now();
    final timeDiff = prayer.time.difference(now);
    return timeDiff.inMinutes > 0 && timeDiff.inMinutes <= minutesBefore;
  }
  
  /// الحصول على رسالة التنبيه المناسبة
  static String getNotificationMessage(PrayerType type, int minutesBefore) {
    final prayerName = getPrayerNameAr(type);
    
    if (minutesBefore == 0) {
      return 'حان الآن وقت صلاة $prayerName';
    } else if (minutesBefore == 1) {
      return 'بقي دقيقة واحدة على صلاة $prayerName';
    } else if (minutesBefore == 2) {
      return 'بقي دقيقتان على صلاة $prayerName';
    } else if (minutesBefore <= 10) {
      return 'بقي $minutesBefore دقائق على صلاة $prayerName';
    } else {
      return 'اقترب وقت صلاة $prayerName (بعد $minutesBefore دقيقة)';
    }
  }
  
  /// الحصول على نص الحالة للصلاة
  static String getPrayerStatusText(PrayerTime prayer) {
    if (prayer.isNext) {
      return prayer.remainingTimeText;
    } else if (prayer.isPassed) {
      return 'انتهى الوقت';
    } else {
      return 'قادم';
    }
  }
  
  /// حساب نسبة التقدم بين صلاتين
  static double calculateProgressBetweenPrayers(
    PrayerTime currentPrayer,
    PrayerTime nextPrayer,
  ) {
    final now = DateTime.now();
    final totalDuration = nextPrayer.time.difference(currentPrayer.time);
    final elapsed = now.difference(currentPrayer.time);
    
    if (totalDuration.inSeconds == 0) return 0.0;
    
    return (elapsed.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
  }
  
  /// الحصول على أسماء طرق الحساب
  static String getCalculationMethodName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslimWorldLeague:
        return 'رابطة العالم الإسلامي';
      case CalculationMethod.egyptian:
        return 'الهيئة المصرية العامة للمساحة';
      case CalculationMethod.karachi:
        return 'جامعة العلوم الإسلامية، كراتشي';
      case CalculationMethod.ummAlQura:
        return 'أم القرى';
      case CalculationMethod.dubai:
        return 'دبي';
      case CalculationMethod.qatar:
        return 'قطر';
      case CalculationMethod.kuwait:
        return 'الكويت';
      case CalculationMethod.singapore:
        return 'سنغافورة';
      case CalculationMethod.northAmerica:
        return 'الجمعية الإسلامية لأمريكا الشمالية';
      case CalculationMethod.other:
        return 'أخرى';
    }
  }
  
  /// الحصول على وصف طريقة الحساب
  static String getCalculationMethodDescription(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslimWorldLeague:
        return 'الفجر 18°، العشاء 17°';
      case CalculationMethod.egyptian:
        return 'الفجر 19.5°، العشاء 17.5°';
      case CalculationMethod.karachi:
        return 'الفجر 18°، العشاء 18°';
      case CalculationMethod.ummAlQura:
        return 'الفجر 18.5°، العشاء 90 دقيقة بعد المغرب';
      case CalculationMethod.dubai:
        return 'الفجر 18.2°، العشاء 18.2°';
      case CalculationMethod.qatar:
        return 'الفجر 18°، العشاء 90 دقيقة بعد المغرب';
      case CalculationMethod.kuwait:
        return 'الفجر 18°، العشاء 17.5°';
      case CalculationMethod.singapore:
        return 'الفجر 20°، العشاء 18°';
      case CalculationMethod.northAmerica:
        return 'الفجر 15°، العشاء 15°';
      case CalculationMethod.other:
        return 'مخصص';
    }
  }
  
  /// الحصول على اسم المذهب
  static String getJuristicName(AsrJuristic juristic) {
    switch (juristic) {
      case AsrJuristic.standard:
        return 'الجمهور (الشافعي، المالكي، الحنبلي)';
      case AsrJuristic.hanafi:
        return 'الحنفي';
    }
  }
}