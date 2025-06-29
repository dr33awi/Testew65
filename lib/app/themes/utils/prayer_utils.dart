// lib/features/prayer_times/utils/prayer_utils.dart - محدث ومتوافق مع النظام الموحد
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/widgets.dart';

/// دوال مساعدة للصلوات - متوافقة مع النظام الموحد
class PrayerUtils {
  PrayerUtils._();
  
  /// تنسيق وقت الصلاة
  static String formatPrayerTime(DateTime time, {bool showPeriod = true, bool use24Hour = false}) {
    if (use24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'م' : 'ص';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      
      return showPeriod ? '$displayHour:$minute $period' : '$displayHour:$minute';
    }
  }
  
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
  
  /// التحقق من اقتراب وقت الصلاة
  static bool isPrayerApproaching(DateTime prayerTime, {int minutesBefore = 15}) {
    final now = DateTime.now();
    final timeDiff = prayerTime.difference(now);
    return timeDiff.inMinutes > 0 && timeDiff.inMinutes <= minutesBefore;
  }
  
  /// تحديد أولوية الصلاة (للترتيب)
  static int getPrayerPriority(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        return 1;
      case 'الشروق':
      case 'sunrise':
        return 2;
      case 'الظهر':
      case 'dhuhr':
        return 3;
      case 'العصر':
      case 'asr':
        return 4;
      case 'المغرب':
      case 'maghrib':
        return 5;
      case 'العشاء':
      case 'isha':
        return 6;
      case 'منتصف الليل':
      case 'midnight':
        return 7;
      case 'الثلث الأخير':
      case 'lastThird':
        return 8;
      default:
        return 99;
    }
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

  /// ترتيب الصلوات حسب الأولوية
  static List<T> sortPrayersByPriority<T>(
    List<T> prayers,
    String Function(T) getNameFunction,
  ) {
    final sortedList = List<T>.from(prayers);
    sortedList.sort((a, b) {
      final priorityA = getPrayerPriority(getNameFunction(a));
      final priorityB = getPrayerPriority(getNameFunction(b));
      return priorityA.compareTo(priorityB);
    });
    return sortedList;
  }

  /// فلترة الصلوات الرئيسية (الخمس صلوات)
  static List<String> getMainPrayers() {
    return ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
  }

  /// فلترة الصلوات الإضافية
  static List<String> getAdditionalPrayers() {
    return ['الشروق', 'منتصف الليل', 'الثلث الأخير'];
  }

  /// التحقق من كون الصلاة من الصلوات الرئيسية
  static bool isMainPrayer(String prayerName) {
    return getMainPrayers().contains(prayerName);
  }

  /// بناء كرت صلاة موحد
  static Widget buildPrayerCard({
    required String prayerName,
    required String time,
    bool isCurrent = false,
    bool isNext = false,
    VoidCallback? onTap,
  }) {
    final prayerColor = AppTheme.getPrayerColor(prayerName);
    
    return AppCard(
      useGradient: isCurrent,
      color: isCurrent ? prayerColor : null,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CardHelper.getPrayerIcon(prayerName),
            size: AppTheme.iconLg,
            color: isCurrent ? Colors.white : prayerColor,
          ),
          AppTheme.space2.h,
          Text(
            prayerName,
            style: AppTheme.titleMedium.copyWith(
              color: isCurrent ? Colors.white : null,
              fontWeight: AppTheme.semiBold,
            ),
          ),
          AppTheme.space1.h,
          Text(
            time,
            style: AppTheme.bodyLarge.copyWith(
              fontFamily: AppTheme.numbersFont,
              fontWeight: AppTheme.bold,
              color: isCurrent ? Colors.white : prayerColor,
            ),
          ),
          if (isNext) ...[
            AppTheme.space1.h,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.space2,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: (isCurrent ? Colors.white : prayerColor).withValues(alpha: 0.2),
                borderRadius: AppTheme.radiusFull.radius,
              ),
              child: Text(
                'التالية',
                style: AppTheme.caption.copyWith(
                  color: isCurrent ? Colors.white : prayerColor,
                  fontWeight: AppTheme.medium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// بناء قائمة صلوات مدمجة
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

  /// بناء كرت الصلاة التالية
  static Widget buildNextPrayerCard({
    required String prayerName,
    required String time,
    Duration? remainingTime,
    VoidCallback? onTap,
  }) {
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
                CardHelper.getPrayerIcon(prayerName),
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
                'بعد ${CardHelper.formatDuration(remainingTime)}',
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

  /// بناء إحصائيات الصلوات
  static Widget buildPrayerStatsCard({
    required int completedToday,
    required int totalDaily,
    required int streak,
  }) {
    final completionRate = totalDaily > 0 ? completedToday / totalDaily : 0.0;
    
    return AppCard(
      useGradient: true,
      color: AppTheme.primary,
      child: Column(
        children: [
          Text(
            'إحصائيات الصلوات',
            style: AppTheme.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.semiBold,
            ),
          ),
          AppTheme.space3.h,
          
          // شريط التقدم
          LinearProgressIndicator(
            value: completionRate,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
          AppTheme.space3.h,
          
          // الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPrayerStat('اليوم', '$completedToday/$totalDaily'),
              _buildPrayerStat('النسبة', '${(completionRate * 100).toInt()}%'),
              _buildPrayerStat('المواظبة', '$streak يوم'),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildPrayerStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
            fontFamily: AppTheme.numbersFont,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
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

  /// الحصول على وقت صلاة منسق
  static String formatPrayerTimeFromString(String timeString, {bool use24Hour = false}) {
    try {
      // محاولة تحليل النص كوقت
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final time = DateTime(2000, 1, 1, hour, minute);
        return formatPrayerTime(time, use24Hour: use24Hour);
      }
    } catch (e) {
      // في حالة فشل التحليل، إرجاع النص كما هو
    }
    return timeString;
  }

  /// التحقق من صحة وقت الصلاة
  static bool isValidPrayerTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length < 2) return false;
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      return hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;
    } catch (e) {
      return false;
    }
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
    
    final sortedPrayers = sortPrayersByPriority(
      prayerTimes.keys.toList(),
      (prayer) => prayer,
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
}