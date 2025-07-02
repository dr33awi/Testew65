// lib/app/themes/core/systems/app_icons_system.dart - محدث مع الأيقونات المفقودة
import 'package:flutter/material.dart';

/// نظام الأيقونات الموحد للتطبيق
class AppIconsSystem {
  AppIconsSystem._();

  // ===== الأيقونات الأساسية =====
  static const IconData home = Icons.home_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData back = Icons.arrow_back_ios_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData info = Icons.info_rounded;
  static const IconData save = Icons.save_rounded;
  static const IconData refresh = Icons.refresh_rounded;

  // ===== أيقونات الحالات =====
  static const IconData success = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData warning = Icons.warning_rounded;
  static const IconData loading = Icons.hourglass_empty_rounded;
  static const IconData empty = Icons.inbox_rounded;
  static const IconData progress = Icons.trending_up_rounded;
  static const IconData notifications = Icons.notifications_rounded;

  // ===== أيقونات الوقت والتاريخ =====
  static const IconData time = Icons.access_time_filled;
  static const IconData schedule = Icons.schedule_rounded;
  static const IconData current = Icons.radio_button_checked;

  // ===== أيقونات الموقع =====
  static const IconData location = Icons.location_on_rounded;
  static const IconData myLocation = Icons.my_location;

  // ===== أيقونات التطبيق =====
  static const IconData calculate = Icons.calculate_rounded;
  static const IconData school = Icons.school_rounded;
  static const IconData tune = Icons.tune_rounded;

  // ===== أيقونات الصلوات =====
  static const IconData prayer = Icons.mosque;
  static const IconData prayerTime = Icons.access_time_rounded;
  static const IconData qibla = Icons.explore_rounded;
  static const IconData fajr = Icons.dark_mode;
  static const IconData dhuhr = Icons.light_mode;
  static const IconData asr = Icons.wb_cloudy_rounded;
  static const IconData maghrib = Icons.wb_twilight_rounded;
  static const IconData isha = Icons.bedtime_rounded;
  static const IconData sunrise = Icons.wb_sunny_rounded;

  // ===== أيقونات الأذكار =====
  static const IconData athkar = Icons.menu_book_rounded;
  static const IconData morningAthkar = Icons.wb_sunny_rounded;
  static const IconData eveningAthkar = Icons.nights_stay_rounded;
  static const IconData sleepAthkar = Icons.bedtime_rounded;
  static const IconData prayerAthkar = Icons.mosque;
  static const IconData generalAthkar = Icons.auto_awesome_rounded;

  // ===== أيقونات القرآن والدعاء =====
  static const IconData quran = Icons.auto_stories_rounded;
  static const IconData verse = Icons.format_quote_rounded;
  static const IconData dua = Icons.volunteer_activism_rounded;

  // ===== أيقونات التفاعل =====
  static const IconData favorite = Icons.favorite_rounded;
  static const IconData favoriteOutlined = Icons.favorite_border_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData copy = Icons.content_copy_rounded;

  // ===== دوال مساعدة =====

  /// الحصول على أيقونة الصلاة حسب الاسم
  static IconData getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return fajr;
      case 'dhuhr':
      case 'الظهر':
        return dhuhr;
      case 'asr':
      case 'العصر':
        return asr;
      case 'maghrib':
      case 'المغرب':
        return maghrib;
      case 'isha':
      case 'العشاء':
        return isha;
      case 'sunrise':
      case 'الشروق':
        return sunrise;
      default:
        return prayer;
    }
  }

  /// الحصول على أيقونة الفئة حسب النوع
  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
        return morningAthkar;
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
        return eveningAthkar;
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
        return sleepAthkar;
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return prayerAthkar;
      case 'general':
      case 'عامة':
      case 'أذكار عامة':
        return generalAthkar;
      case 'quran':
      case 'القرآن':
        return quran;
      case 'dua':
      case 'دعاء':
        return dua;
      default:
        return athkar;
    }
  }

  /// الحصول على أيقونة النوع (آية، حديث، دعاء)
  static IconData getQuoteTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return verse;
      case 'hadith':
      case 'حديث':
        return athkar;
      case 'dua':
      case 'دعاء':
        return dua;
      default:
        return athkar;
    }
  }

  /// الحصول على أيقونة الحالة
  static IconData getStateIcon(String state) {
    switch (state.toLowerCase()) {
      case 'success':
      case 'نجح':
        return success;
      case 'error':
      case 'خطأ':
        return error;
      case 'warning':
      case 'تحذير':
        return warning;
      case 'info':
      case 'معلومات':
        return info;
      case 'loading':
      case 'تحميل':
        return loading;
      case 'empty':
      case 'فارغ':
        return empty;
      default:
        return info;
    }
  }

  /// الحصول على أيقونة افتراضية آمنة
  static IconData getSafeIcon(String? iconName, {IconData fallback = Icons.help_outline}) {
    if (iconName == null || iconName.isEmpty) return fallback;
    
    try {
      return getCategoryIcon(iconName);
    } catch (e) {
      return fallback;
    }
  }
}

/// Extension لتسهيل الاستخدام
extension StringToAppIconsExtension on String {
  /// الحصول على أيقونة الفئة
  IconData get categoryIcon => AppIconsSystem.getCategoryIcon(this);
  
  /// الحصول على أيقونة الصلاة
  IconData get prayerIcon => AppIconsSystem.getPrayerIcon(this);
  
  /// الحصول على أيقونة النوع
  IconData get quoteTypeIcon => AppIconsSystem.getQuoteTypeIcon(this);
  
  /// الحصول على أيقونة الحالة
  IconData get stateIcon => AppIconsSystem.getStateIcon(this);
}