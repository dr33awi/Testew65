// lib/app/themes/utils/prayer_utils.dart - مبسّطة ومنظّفة
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/widgets.dart';

/// دوال مساعدة للصلوات - مبسّطة تماماً
class PrayerUtils {
  PrayerUtils._();
  
  // ========== دوال الصلوات الأساسية فقط ==========
  
  /// أسماء الصلوات بالعربية
  static const Map<String, String> prayerNamesAr = {
    'fajr': 'الفجر',
    'sunrise': 'الشروق',
    'dhuhr': 'الظهر',
    'asr': 'العصر',
    'maghrib': 'المغرب',
    'isha': 'العشاء',
  };
  
  /// الحصول على اسم الصلاة بالعربية
  static String getPrayerNameAr(String englishName) {
    return prayerNamesAr[englishName.toLowerCase()] ?? englishName;
  }

  /// الحصول على الصلوات الرئيسية فقط
  static List<String> getMainPrayers() {
    return ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
  }

  /// الحصول على الصلاة القادمة من قائمة
  static String? getNextPrayer(Map<String, String> prayerTimes, [DateTime? now]) {
    now ??= DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    
    // استخدام النظام المركزي للترتيب
    final sortedPrayers = AppTheme.sortByPriority(
      prayerTimes.keys.toList(),
      (prayer) => AppTheme.getPrayerPriority(prayer),
    );
    
    for (final prayerName in sortedPrayers) {
      final timeString = prayerTimes[prayerName];
      if (timeString != null && AppTheme.isValidPrayerTime(timeString)) {
        final parts = timeString.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final prayerMinutes = hour * 60 + minute;
        
        if (prayerMinutes > currentMinutes) {
          return prayerName;
        }
      }
    }
    
    // إذا لم نجد صلاة قادمة اليوم، فالصلاة القادمة هي فجر الغد
    return 'الفجر';
  }

  /// التحقق من اقتراب وقت الصلاة
  static bool isPrayerApproaching(DateTime prayerTime, {int minutesBefore = 15}) {
    final now = DateTime.now();
    final timeDiff = prayerTime.difference(now);
    return timeDiff.inMinutes > 0 && timeDiff.inMinutes <= minutesBefore;
  }

  /// الحصول على رسالة التنبيه للصلاة
  static String getNotificationMessage(String prayerName, int minutesBefore) {
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

  /// بناء قائمة صلوات باستخدام النظام الموحد
  static Widget buildPrayersList({
    required Map<String, String> prayerTimes,
    String? currentPrayer,
    String? nextPrayer,
    required Function(String) onPrayerTap,
    bool showMainOnly = false,
  }) {
    final prayers = showMainOnly ? getMainPrayers() : prayerTimes.keys.toList();
    // استخدام النظام المركزي للترتيب
    final sortedPrayers = AppTheme.sortByPriority(
      prayers, 
      (prayer) => AppTheme.getPrayerPriority(prayer),
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedPrayers.length,
      itemBuilder: (context, index) {
        final prayerName = sortedPrayers[index];
        final time = prayerTimes[prayerName] ?? '--:--';
        final isCurrent = prayerName == currentPrayer;
        final isNext = prayerName == nextPrayer;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.space1),
          child: AppCard.prayer(
            prayerName: prayerName,
            time: time,
            isCurrent: isCurrent,
            isNext: isNext,
            onTap: () => onPrayerTap(prayerName),
          ),
        );
      },
    );
  }

  /// بناء شبكة الصلوات باستخدام النظام الموحد
  static Widget buildPrayersGrid({
    required Map<String, String> prayerTimes,
    String? currentPrayer,
    String? nextPrayer,
    required Function(String) onPrayerTap,
    int crossAxisCount = 2,
    bool showMainOnly = false,
  }) {
    final prayers = showMainOnly ? getMainPrayers() : prayerTimes.keys.toList();
    // استخدام النظام المركزي للترتيب
    final sortedPrayers = AppTheme.sortByPriority(
      prayers, 
      (prayer) => AppTheme.getPrayerPriority(prayer),
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.1,
        crossAxisSpacing: AppTheme.space3,
        mainAxisSpacing: AppTheme.space3,
      ),
      itemCount: sortedPrayers.length,
      itemBuilder: (context, index) {
        final prayerName = sortedPrayers[index];
        final time = prayerTimes[prayerName] ?? '--:--';
        final isCurrent = prayerName == currentPrayer;
        final isNext = prayerName == nextPrayer;

        return AppCard.prayer(
          prayerName: prayerName,
          time: time,
          isCurrent: isCurrent,
          isNext: isNext,
          isCompact: true,
          onTap: () => onPrayerTap(prayerName),
        );
      },
    );
  }

  /// حساب الوقت المتبقي للصلاة التالية
  static Duration? calculateTimeToNextPrayer(
    Map<String, String> prayerTimes,
    [DateTime? currentTime]
  ) {
    final nextPrayer = getNextPrayer(prayerTimes, currentTime);
    if (nextPrayer == null) return null;
    
    final timeString = prayerTimes[nextPrayer];
    if (timeString == null || !AppTheme.isValidPrayerTime(timeString)) return null;
    
    final now = currentTime ?? DateTime.now();
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    
    var prayerTime = DateTime(now.year, now.month, now.day, hour, minute);
    
    // إذا كانت الصلاة قد فاتت اليوم، فهي غداً
    if (prayerTime.isBefore(now)) {
      prayerTime = prayerTime.add(const Duration(days: 1));
    }
    
    return prayerTime.difference(now);
  }

  /// الحصول على الصلاة المناسبة للوقت الحالي
  static String getCurrentPrayerForTime([DateTime? time]) {
    final currentTime = time ?? DateTime.now();
    final hour = currentTime.hour;
    
    if (hour >= 4 && hour < 6) return 'الفجر';
    if (hour >= 6 && hour < 12) return 'الشروق';
    if (hour >= 12 && hour < 15) return 'الظهر';
    if (hour >= 15 && hour < 18) return 'العصر';
    if (hour >= 18 && hour < 20) return 'المغرب';
    return 'العشاء';
  }

  /// فلترة الصلوات حسب النوع
  static Map<String, String> filterByType({
    required Map<String, String> prayerTimes,
    required String type,
  }) {
    final Map<String, String> filtered = {};
    
    switch (type.toLowerCase()) {
      case 'main':
      case 'رئيسية':
        for (final prayer in getMainPrayers()) {
          if (prayerTimes.containsKey(prayer)) {
            filtered[prayer] = prayerTimes[prayer]!;
          }
        }
        break;
      default:
        return prayerTimes;
    }
    
    return filtered;
  }
}