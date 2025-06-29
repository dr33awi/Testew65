// lib/app/themes/utils/prayer_utils.dart - مبسّط ومنظّف من التكرار
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/widgets.dart';

/// دوال مساعدة للصلوات - منظّفة ومعتمدة على النظام المركزي
class PrayerUtils {
  PrayerUtils._();
  
  // ========== تنسيق الأوقات ==========
  
  /// تنسيق وقت الصلاة - استخدام النظام المركزي
  static String formatPrayerTime(DateTime time, {bool showPeriod = true, bool use24Hour = false}) {
    return AppTheme.formatPrayerTime(time, use24Hour: use24Hour);
  }

  /// تنسيق وقت من نص
  static String formatPrayerTimeFromString(String timeString, {bool use24Hour = false}) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final time = DateTime(2000, 1, 1, hour, minute);
        return AppTheme.formatPrayerTime(time, use24Hour: use24Hour);
      }
    } catch (e) {
      // في حالة فشل التحليل، إرجاع النص كما هو
    }
    return timeString;
  }

  // ========== أسماء الصلوات ==========
  
  /// أسماء الصلوات بالعربية
  static const Map<String, String> prayerNamesAr = {
    'fajr': 'الفجر',
    'sunrise': 'الشروق',
    'dhuhr': 'الظهر',
    'asr': 'العصر',
    'maghrib': 'المغرب',
    'isha': 'العشاء',
    'midnight': 'منتصف الليل',
    'lastThird': 'الثلث الأخير',
  };
  
  /// أسماء الصلوات بالإنجليزية
  static const Map<String, String> prayerNamesEn = {
    'الفجر': 'Fajr',
    'الشروق': 'Sunrise',
    'الظهر': 'Dhuhr',
    'العصر': 'Asr',
    'المغرب': 'Maghrib',
    'العشاء': 'Isha',
    'منتصف الليل': 'Midnight',
    'الثلث الأخير': 'Last Third',
  };
  
  /// الحصول على اسم الصلاة بالعربية
  static String getPrayerNameAr(String englishName) {
    return prayerNamesAr[englishName.toLowerCase()] ?? englishName;
  }
  
  /// الحصول على اسم الصلاة بالإنجليزية
  static String getPrayerNameEn(String arabicName) {
    return prayerNamesEn[arabicName] ?? arabicName;
  }

  // ========== فئات الصلوات ==========

  /// فلترة الصلوات الرئيسية (الخمس صلوات)
  static List<String> getMainPrayers() {
    return ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
  }

  /// فلترة الصلوات الإضافية
  static List<String> getAdditionalPrayers() {
    return ['الشروق', 'منتصف الليل', 'الثلث الأخير'];
  }

  /// التحقق من كون الصلاة من الصلوات الرئيسية - استخدام النظام المركزي
  static bool isMainPrayer(String prayerName) {
    return AppTheme.isMainPrayer(prayerName);
  }

  // ========== التوقيتات والتحقق ==========

  /// التحقق من اقتراب وقت الصلاة
  static bool isPrayerApproaching(DateTime prayerTime, {int minutesBefore = 15}) {
    final now = DateTime.now();
    final timeDiff = prayerTime.difference(now);
    return timeDiff.inMinutes > 0 && timeDiff.inMinutes <= minutesBefore;
  }

  /// التحقق من صحة وقت الصلاة - استخدام النظام المركزي
  static bool isValidPrayerTime(String timeString) {
    return AppTheme.isValidPrayerTime(timeString);
  }

  /// حساب الفرق بين وقتين
  static Duration calculateTimeDifference(String time1, String time2) {
    try {
      final parts1 = time1.split(':');
      final parts2 = time2.split(':');
      
      final hour1 = int.parse(parts1[0]);
      final minute1 = int.parse(parts1[1]);
      final hour2 = int.parse(parts2[0]);
      final minute2 = int.parse(parts2[1]);
      
      final time1Minutes = hour1 * 60 + minute1;
      final time2Minutes = hour2 * 60 + minute2;
      
      return Duration(minutes: (time2Minutes - time1Minutes).abs());
    } catch (e) {
      return Duration.zero;
    }
  }

  /// الحصول على الصلاة القادمة من قائمة
  static String? getNextPrayer(Map<String, String> prayerTimes, [DateTime? now]) {
    now ??= DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    
    final sortedPrayers = AppTheme.sortByPriority(
      prayerTimes.keys.toList(),
      (prayer) => AppTheme.getPrayerPriority(prayer),
    );
    
    for (final prayerName in sortedPrayers) {
      final timeString = prayerTimes[prayerName];
      if (timeString != null && isValidPrayerTime(timeString)) {
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

  // ========== الرسائل والتنبيهات ==========

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

  // ========== الترتيب والفلترة - استخدام النظام المركزي ==========

  /// ترتيب الصلوات حسب الأولوية
  static List<T> sortPrayersByPriority<T>(
    List<T> prayers,
    String Function(T) getNameFunction,
  ) {
    return AppTheme.sortByPriority(
      prayers,
      (prayer) => AppTheme.getPrayerPriority(getNameFunction(prayer)),
    );
  }

  /// فلترة الصلوات حسب النوع
  static Map<String, String> filterPrayersByType({
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
      case 'additional':
      case 'إضافية':
        for (final prayer in getAdditionalPrayers()) {
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

  // ========== بناء الواجهات - استخدام النظام الموحد ==========

  /// بناء كرت صلاة - استخدام النظام الموحد
  static Widget buildPrayerCard({
    required String prayerName,
    required String time,
    bool isCurrent = false,
    bool isNext = false,
    VoidCallback? onTap,
  }) {
    return AppCard.prayer(
      prayerName: prayerName,
      time: time,
      isCurrent: isCurrent,
      isNext: isNext,
      onTap: onTap,
    );
  }

  /// بناء قائمة صلوات
  static Widget buildPrayersList({
    required Map<String, String> prayerTimes,
    String? currentPrayer,
    String? nextPrayer,
    required Function(String) onPrayerTap,
    bool showMainOnly = false,
  }) {
    final prayers = showMainOnly ? getMainPrayers() : prayerTimes.keys.toList();
    final sortedPrayers = sortPrayersByPriority(prayers, (prayer) => prayer);

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
          child: buildPrayerCard(
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

  /// بناء شبكة الصلوات
  static Widget buildPrayersGrid({
    required Map<String, String> prayerTimes,
    String? currentPrayer,
    String? nextPrayer,
    required Function(String) onPrayerTap,
    int crossAxisCount = 2,
    bool showMainOnly = false,
  }) {
    final prayers = showMainOnly ? getMainPrayers() : prayerTimes.keys.toList();
    final sortedPrayers = sortPrayersByPriority(prayers, (prayer) => prayer);

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

        return buildPrayerCard(
          prayerName: prayerName,
          time: time,
          isCurrent: isCurrent,
          isNext: isNext,
          onTap: () => onPrayerTap(prayerName),
        );
      },
    );
  }

  /// بناء مؤشر حالة الصلاة
  static Widget buildPrayerStatusIndicator({
    required String prayerName,
    required bool isCompleted,
    required bool isPassed,
    required bool isCurrent,
  }) {
    late Color color;
    late IconData icon;
    late String status;

    if (isCompleted) {
      color = AppTheme.success;
      icon = Icons.check_circle;
      status = 'مُؤداة';
    } else if (isCurrent) {
      color = AppTheme.warning;
      icon = Icons.access_time;
      status = 'وقتها الآن';
    } else if (isPassed) {
      color = AppTheme.error;
      icon = Icons.cancel;
      status = 'فاتت';
    } else {
      color = AppTheme.textTertiary;
      icon = Icons.schedule;
      status = 'قادمة';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusFull.radius,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          AppTheme.space1.w,
          Text(
            status,
            style: AppTheme.caption.copyWith(
              color: color,
              fontWeight: AppTheme.medium,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء الصلاة التالية - استخدام extended_cards
  static Widget buildNextPrayerCard({
    required String prayerName,
    required String time,
    Duration? remainingTime,
    VoidCallback? onTap,
  }) {
    // يتم استيراد NextPrayerCard من extended_cards.dart
    return AppCard(
      useGradient: true,
      color: AppTheme.getPrayerColor(prayerName),
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppTheme.getPrayerIcon(prayerName),
                color: Colors.white,
                size: AppTheme.iconMd,
              ),
              AppTheme.space2.w,
              Text(
                'الصلاة التالية',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.medium,
                ),
              ),
            ],
          ),
          AppTheme.space3.h,
          Text(
            prayerName,
            style: AppTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.bold,
            ),
          ),
          AppTheme.space1.h,
          Text(
            time,
            style: AppTheme.titleLarge.copyWith(
              color: Colors.white,
              fontFamily: AppTheme.numbersFont,
              fontWeight: AppTheme.semiBold,
            ),
          ),
          if (remainingTime != null) ...[
            AppTheme.space2.h,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space3,
                vertical: AppTheme.space1,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: AppTheme.radiusFull.radius,
              ),
              child: Text(
                'بعد ${AppTheme.formatDuration(remainingTime)}',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.medium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ========== دوال إضافية مفيدة ==========

  /// الحصول على الصلاة السابقة
  static String getPreviousPrayer(String currentPrayer) {
    final mainPrayers = getMainPrayers();
    final currentIndex = mainPrayers.indexOf(currentPrayer);
    
    if (currentIndex <= 0) {
      return mainPrayers.last; // العشاء
    }
    return mainPrayers[currentIndex - 1];
  }

  /// الحصول على الصلاة التالية من اسم الصلاة الحالية
  static String getNextPrayerFromCurrent(String currentPrayer) {
    final mainPrayers = getMainPrayers();
    final currentIndex = mainPrayers.indexOf(currentPrayer);
    
    if (currentIndex == -1 || currentIndex == mainPrayers.length - 1) {
      return mainPrayers.first; // الفجر
    }
    return mainPrayers[currentIndex + 1];
  }

  /// التحقق من كون الوقت في فترة صلاة معينة
  static bool isTimeInPrayerPeriod(String prayerName, DateTime time) {
    final hour = time.hour;
    
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        return hour >= 4 && hour < 6;
      case 'الظهر':
      case 'dhuhr':
        return hour >= 12 && hour < 15;
      case 'العصر':
      case 'asr':
        return hour >= 15 && hour < 18;
      case 'المغرب':
      case 'maghrib':
        return hour >= 18 && hour < 20;
      case 'العشاء':
      case 'isha':
        return hour >= 20 || hour < 4;
      default:
        return false;
    }
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

  /// حساب الوقت المتبقي للصلاة التالية
  static Duration? calculateTimeToNextPrayer(
    Map<String, String> prayerTimes,
    [DateTime? currentTime]
  ) {
    final nextPrayer = getNextPrayer(prayerTimes, currentTime);
    if (nextPrayer == null) return null;
    
    final timeString = prayerTimes[nextPrayer];
    if (timeString == null || !isValidPrayerTime(timeString)) return null;
    
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
}