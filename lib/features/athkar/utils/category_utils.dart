import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';

/// أدوات مساعدة لفئات الأذكار
class CategoryUtils {
  /// الحصول على أيقونة مناسبة لكل فئة
  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      // أذكار الأوقات
      case 'morning':
      case 'الصباح':
      case 'صباح':
        return Icons.wb_sunny_rounded; // شمس للصباح
      case 'evening':
      case 'المساء':
      case 'مساء':
        return Icons.wb_twilight_rounded; // غروب للمساء
      case 'sleep':
      case 'النوم':
      case 'نوم':
        return Icons.bedtime_rounded; // سرير للنوم
      case 'wakeup':
      case 'wake_up':
      case 'الاستيقاظ':
      case 'استيقاظ':
      case 'wake':
        return Icons.alarm_rounded; // منبه للاستيقاظ
      
      // أذكار العبادة والأماكن
      case 'prayer':
      case 'الصلاة':
      case 'صلاة':
      case 'prayers':
        return Icons.mosque; // مسجد للصلاة
      case 'eating':
      case 'food':
      case 'الطعام':
      case 'طعام':
      case 'الأكل':
      case 'أكل':
        return Icons.restaurant_rounded; // مطعم للطعام
      case 'home':
      case 'house':
      case 'المنزل':
      case 'منزل':
      case 'البيت':
      case 'بيت':
        return Icons.home_rounded; // منزل للبيت
      case 'travel':
      case 'السفر':
      case 'سفر':
        return Icons.flight_rounded; // طائرة للسفر
      
      // باقي الفئات
      case 'general':
      case 'عامة':
      case 'عام':
        return Icons.auto_awesome_rounded; // نجمة للعام
      case 'quran':
      case 'القرآن':
      case 'قرآن':
        return Icons.menu_book_rounded; // كتاب للقرآن
      case 'tasbih':
      case 'التسبيح':
      case 'تسبيح':
        return Icons.radio_button_checked; // دائرة للتسبيح
      case 'dua':
      case 'الدعاء':
      case 'دعاء':
        return Icons.pan_tool_rounded; // يد للدعاء
      case 'istighfar':
      case 'الاستغفار':
      case 'استغفار':
        return Icons.favorite_rounded; // قلب للاستغفار
      case 'friday':
      case 'الجمعة':
      case 'جمعة':
        return Icons.event_rounded; // تقويم للجمعة
      case 'hajj':
      case 'الحج':
      case 'حج':
        return Icons.location_on_rounded; // موقع للحج
      case 'ramadan':
      case 'رمضان':
        return Icons.nights_stay_rounded; // هلال لرمضان
      case 'eid':
      case 'العيد':
      case 'عيد':
        return Icons.celebration_rounded; // احتفال للعيد
      case 'illness':
      case 'المرض':
      case 'مرض':
        return Icons.healing_rounded; // شفاء للمرض
      case 'rain':
      case 'المطر':
      case 'مطر':
        return Icons.water_drop_rounded; // قطرة للمطر
      case 'wind':
      case 'الرياح':
      case 'رياح':
        return Icons.air_rounded; // هواء للرياح
      case 'work':
      case 'العمل':
      case 'عمل':
        return Icons.work_rounded; // عمل للمهنة
      case 'study':
      case 'الدراسة':
      case 'دراسة':
        return Icons.school_rounded; // مدرسة للدراسة
      case 'anxiety':
      case 'القلق':
      case 'قلق':
        return Icons.psychology_rounded; // عقل للقلق
      case 'gratitude':
      case 'الشكر':
      case 'شكر':
        return Icons.thumb_up_rounded; // إعجاب للشكر
      case 'protection':
      case 'الحماية':
      case 'حماية':
        return Icons.shield_rounded; // درع للحماية
      case 'guidance':
      case 'الهداية':
      case 'هداية':
        return Icons.lightbulb_rounded; // مصباح للهداية
      case 'forgiveness':
      case 'المغفرة':
      case 'مغفرة':
        return Icons.clean_hands_rounded; // أيدي نظيفة للمغفرة
      case 'success':
      case 'النجاح':
      case 'نجاح':
        return Icons.emoji_events_rounded; // كأس للنجاح
      case 'patience':
      case 'الصبر':
      case 'صبر':
        return Icons.hourglass_bottom_rounded; // ساعة رملية للصبر
      case 'knowledge':
      case 'العلم':
      case 'علم':
        return Icons.psychology_alt_rounded; // عقل للعلم
      default:
        return Icons.auto_awesome_rounded; // افتراضي
    }
  }

  /// الحصول على لون من الثيم بناءً على نوع الفئة
  static Color getCategoryThemeColor(String categoryId) {
    switch (categoryId.toLowerCase()) {
      // أذكار الأوقات
      case 'morning':
      case 'الصباح':
      case 'صباح':
        return const Color(0xFFDAA520); // ذهبي فاتح كالشروق
      case 'evening':
      case 'المساء':
      case 'مساء':
        return const Color(0xFF8B6F47); // بني دافئ كالغروب
      case 'sleep':
      case 'النوم':
      case 'نوم':
        return const Color(0xFF2D352D); // داكن أنيق للليل
      case 'wakeup':
      case 'wake_up':
      case 'الاستيقاظ':
      case 'استيقاظ':
      case 'wake':
        return const Color(0xFF7A8B6F); // أخضر زيتي فاتح للنهار
      
      // أذكار العبادة
      case 'prayer':
      case 'الصلاة':
      case 'صلاة':
      case 'prayers':
        return const Color(0xFF445A3B); // أخضر زيتي داكن مقدس
      case 'eating':
      case 'food':
      case 'الطعام':
      case 'طعام':
      case 'الأكل':
      case 'أكل':
        return const Color(0xFF6B8E5A); // أخضر طبيعي للطعام
      case 'home':
      case 'house':
      case 'المنزل':
      case 'منزل':
      case 'البيت':
      case 'بيت':
        return const Color(0xFF8B7355); // بني دافئ للمنزل
      case 'travel':
      case 'السفر':
      case 'سفر':
        return const Color(0xFF5F7C8A); // أزرق رمادي للسفر
      
      // باقي الفئات
      case 'general':
      case 'عامة':
      case 'عام':
        return const Color(0xFF8B7355); // بني متوسط متوازن
      case 'quran':
      case 'القرآن':
      case 'قرآن':
        return const Color(0xFF704214); // بني داكن كالمصحف
      case 'tasbih':
      case 'التسبيح':
      case 'تسبيح':
        return const Color(0xFF4A6741); // أخضر داكن روحاني
      case 'dua':
      case 'الدعاء':
      case 'دعاء':
        return const Color(0xFF6B4C7C); // بنفسجي داكن للدعاء
      case 'istighfar':
      case 'الاستغفار':
      case 'استغفار':
        return const Color(0xFF8B4A6B); // وردي داكن للتوبة
      case 'friday':
      case 'الجمعة':
      case 'جمعة':
        return const Color(0xFF4F6B43); // أخضر مبارك للجمعة
      case 'hajj':
      case 'الحج':
      case 'حج':
        return const Color(0xFF5A5A5A); // رمادي داكن للكعبة
      case 'ramadan':
      case 'رمضان':
        return const Color(0xFF4A3C6B); // بنفسجي داكن لرمضان
      case 'eid':
      case 'العيد':
      case 'عيد':
        return const Color(0xFFB8860B); // ذهبي احتفالي للعيد
      case 'illness':
      case 'المرض':
      case 'مرض':
        return const Color(0xFF5D7A52); // أخضر هادئ للشفاء
      case 'rain':
      case 'المطر':
      case 'مطر':
        return const Color(0xFF4A6B7C); // أزرق رمادي للمطر
      case 'wind':
      case 'الرياح':
      case 'رياح':
        return const Color(0xFF6B7A7A); // رمادي فضي للرياح
      case 'work':
      case 'العمل':
      case 'عمل':
        return const Color(0xFF7A6B3F); // بني ذهبي للعمل
      case 'study':
      case 'الدراسة':
      case 'دراسة':
        return const Color(0xFF3F4A7A); // أزرق داكن للدراسة
      case 'anxiety':
      case 'القلق':
      case 'قلق':
        return const Color(0xFF4A7A6B); // تركوازي داكن مهدئ
      case 'gratitude':
      case 'الشكر':
      case 'شكر':
        return const Color(0xFF8B7A2D); // أصفر داكن للشكر
      case 'protection':
      case 'الحماية':
      case 'حماية':
        return const Color(0xFF5A6B4A); // أخضر داكن للحماية
      case 'guidance':
      case 'الهداية':
      case 'هداية':
        return const Color(0xFF5A4A6B); // بنفسجي داكن للهداية
      case 'forgiveness':
      case 'المغفرة':
      case 'مغفرة':
        return const Color(0xFF7A4A5A); // وردي داكن للمغفرة
      case 'success':
      case 'النجاح':
      case 'نجاح':
        return const Color(0xFF4A6B47); // أخضر داكن للنجاح
      case 'patience':
      case 'الصبر':
      case 'صبر':
        return const Color(0xFF5A6B6B); // رمادي أزرق للصبر
      case 'knowledge':
      case 'العلم':
      case 'علم':
        return const Color(0xFF3F5A7A); // أزرق داكن للعلم
      default:
        return const Color(0xFF5D7052); // اللون الأساسي الافتراضي
    }
  }

  /// الحصول على تدرج لوني مناسب لكل فئة
  static LinearGradient getCategoryGradient(String categoryId) {
    final baseColor = getCategoryThemeColor(categoryId);
    return LinearGradient(
      colors: [
        baseColor.withValues(alpha: 0.8),
        baseColor,
        baseColor.darken(0.1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// الحصول على وصف مناسب لكل فئة
  static String getCategoryDescription(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return 'ابدأ يومك بالأذكار المباركة';
      case 'evening':
      case 'المساء':
        return 'اختتم نهارك بالذكر والدعاء';
      case 'sleep':
      case 'النوم':
        return 'نم آمناً في حفظ الله';
      case 'wakeup':
      case 'الاستيقاظ':
        return 'احمد الله على نعمة الحياة';
      case 'prayer':
      case 'الصلاة':
        return 'أذكار قبل وبعد الصلاة';
      case 'eating':
      case 'الطعام':
        return 'بارك في طعامك وشرابك';
      case 'travel':
      case 'السفر':
        return 'استعن بالله في سفرك';
      case 'general':
      case 'عامة':
        return 'أذكار متنوعة لكل وقت';
      case 'quran':
      case 'القرآن':
        return 'آيات كريمة للحفظ والأمان';
      case 'tasbih':
      case 'التسبيح':
        return 'سبح الله في كل وقت';
      case 'dua':
      case 'الدعاء':
        return 'ادع الله بخير الدعاء';
      case 'istighfar':
      case 'الاستغفار':
        return 'استغفر الله من كل ذنب';
      case 'friday':
      case 'الجمعة':
        return 'بركات يوم الجمعة المبارك';
      case 'hajj':
      case 'الحج':
        return 'أذكار الحج والعمرة';
      case 'ramadan':
      case 'رمضان':
        return 'أذكار الشهر الكريم';
      case 'eid':
      case 'العيد':
        return 'فرحة العيد بالذكر';
      case 'illness':
      case 'المرض':
        return 'الدعاء للشفاء والعافية';
      case 'rain':
      case 'المطر':
        return 'استبشر بالمطر والرحمة';
      case 'wind':
      case 'الرياح':
        return 'استعذ من شر الرياح';
      case 'work':
      case 'العمل':
        return 'بارك الله في عملك';
      case 'study':
      case 'الدراسة':
        return 'ادع الله بالتوفيق في العلم';
      case 'anxiety':
      case 'القلق':
        return 'اطمئن بذكر الله';
      case 'gratitude':
      case 'الشكر':
        return 'احمد الله على نعمه';
      case 'protection':
      case 'الحماية':
        return 'احتم بحفظ الله ورعايته';
      case 'guidance':
      case 'الهداية':
        return 'اطلب الهداية من الله';
      case 'forgiveness':
      case 'المغفرة':
        return 'اطلب المغفرة والرحمة';
      case 'success':
      case 'النجاح':
        return 'ادع الله بالتوفيق والنجاح';
      case 'patience':
      case 'الصبر':
        return 'اصبر واحتسب الأجر';
      case 'knowledge':
      case 'العلم':
        return 'اطلب من الله العلم النافع';
      default:
        return 'أذكار وأدعية من السنة النبوية';
    }
  }

  /// التحقق من أن الفئة من الفئات الأساسية
  static bool isEssentialCategory(String categoryId) {
    const essentialCategories = {
      'morning',
      'الصباح',
      'evening', 
      'المساء',
      'sleep',
      'النوم',
      'prayer',
      'الصلاة',
    };
    return essentialCategories.contains(categoryId.toLowerCase());
  }

  /// تحديد ما إذا كان يجب عرض الوقت للفئة
  static bool shouldShowTime(String categoryId) {
    // إخفاء الوقت لفئات الصباح والمساء والنوم
    const hiddenTimeCategories = {
      'morning',
      'الصباح',
      'evening', 
      'المساء',
      'sleep',
      'النوم',
    };
    return !hiddenTimeCategories.contains(categoryId.toLowerCase());
  }

  /// الحصول على أولوية العرض للفئة (أقل رقم = أولوية أعلى)
  static int getCategoryPriority(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return 1;
      case 'evening':
      case 'المساء':
        return 2;
      case 'prayer':
      case 'الصلاة':
        return 3;
      case 'sleep':
      case 'النوم':
        return 4;
      case 'wakeup':
      case 'الاستيقاظ':
        return 5;
      case 'eating':
      case 'الطعام':
        return 6;
      case 'quran':
      case 'القرآن':
        return 7;
      case 'tasbih':
      case 'التسبيح':
        return 8;
      case 'dua':
      case 'الدعاء':
        return 9;
      case 'istighfar':
      case 'الاستغفار':
        return 10;
      case 'friday':
      case 'الجمعة':
        return 11;
      case 'travel':
      case 'السفر':
        return 12;
      case 'ramadan':
      case 'رمضان':
        return 13;
      case 'hajj':
      case 'الحج':
        return 14;
      case 'eid':
      case 'العيد':
        return 15;
      case 'illness':
      case 'المرض':
        return 16;
      case 'rain':
      case 'المطر':
        return 17;
      case 'wind':
      case 'الرياح':
        return 18;
      case 'general':
      case 'عامة':
        return 19;
      default:
        return 99;
    }
  }
}