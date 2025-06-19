// lib/app/themes/core/gradients.dart
import 'package:flutter/material.dart';
import 'colors.dart';

/// نظام التدرجات اللونية والتأثيرات البصرية
/// جميع التدرجات محسوبة مسبقاً وcached لتحسين الأداء
class AppGradients {
  AppGradients._();

  // ==================== التدرجات الأساسية ====================
  
  /// تدرج اللون الأساسي
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// تدرج اللون الثانوي
  static const LinearGradient secondary = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// تدرج اللون الثالث
  static const LinearGradient tertiary = LinearGradient(
    colors: [AppColors.tertiary, AppColors.tertiaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== تدرجات الحالة ====================
  
  static const LinearGradient success = LinearGradient(
    colors: [AppColors.success, AppColors.successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient error = LinearGradient(
    colors: [AppColors.error, AppColors.errorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warning = LinearGradient(
    colors: [AppColors.warning, AppColors.warningLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient info = LinearGradient(
    colors: [AppColors.info, AppColors.infoLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== تدرجات خاصة بالميزات ====================
  
  /// تدرج الأذكار
  static const LinearGradient athkar = LinearGradient(
    colors: [AppColors.primarySoft, AppColors.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// تدرج القبلة
  static const LinearGradient qibla = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// تدرج التسبيح
  static const LinearGradient tasbih = LinearGradient(
    colors: [AppColors.tertiary, AppColors.tertiaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== تدرجات الخلفيات ====================
  
  /// تدرج الخلفية الدافئة
  static const LinearGradient warmBackground = LinearGradient(
    colors: [AppColors.lightBackground, AppColors.lightSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// تدرج البطاقات الدافئة
  static const LinearGradient warmCard = LinearGradient(
    colors: [AppColors.lightCard, AppColors.athkarBackground],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// تدرج الخلفية الداكنة
  static const LinearGradient darkBackground = LinearGradient(
    colors: [AppColors.darkBackground, AppColors.darkSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ==================== تدرجات الصلوات ====================
  
  /// خريطة تدرجات الصلوات - cached
  static final Map<String, LinearGradient> _prayerGradients = {
    'fajr': const LinearGradient(
      colors: [Color(0xFF6B8E9F), Color(0xFF8FA9B8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'dhuhr': const LinearGradient(
      colors: [Color(0xFFB8860B), Color(0xFFDAA520)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'asr': const LinearGradient(
      colors: [Color(0xFFD4A574), Color(0xFFE8C899)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'maghrib': const LinearGradient(
      colors: [Color(0xFF8B6F47), Color(0xFFA68B5B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'isha': const LinearGradient(
      colors: [Color(0xFF5D7052), Color(0xFF7A8B6F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };

  /// الحصول على تدرج الصلاة
  static LinearGradient getPrayerGradient(String prayerName) {
    final normalizedName = prayerName.toLowerCase();
    
    // التحقق من الأسماء العربية
    switch (normalizedName) {
      case 'الفجر':
        return _prayerGradients['fajr']!;
      case 'الظهر':
        return _prayerGradients['dhuhr']!;
      case 'العصر':
        return _prayerGradients['asr']!;
      case 'المغرب':
        return _prayerGradients['maghrib']!;
      case 'العشاء':
        return _prayerGradients['isha']!;
      default:
        return _prayerGradients[normalizedName] ?? primary;
    }
  }

  // ==================== تدرجات حسب الوقت ====================
  
  /// تدرج حسب الوقت الحالي - cached
  static final Map<int, LinearGradient> _timeGradients = {
    0: darkBackground,  // منتصف الليل
    1: darkBackground,
    2: darkBackground,
    3: darkBackground,
    4: darkBackground,
    5: const LinearGradient( // الفجر
      colors: [Color(0xFF445A3B), Color(0xFF5D7052)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    6: const LinearGradient(
      colors: [Color(0xFF5D7052), Color(0xFF7A8B6F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    7: const LinearGradient(
      colors: [Color(0xFF7A8B6F), Color(0xFF8FA584)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    8: secondary,       // الصباح
    9: secondary,
    10: secondary,
    11: secondary,
    12: primary,        // الظهر
    13: primary,
    14: primary,
    15: const LinearGradient( // العصر
      colors: [Color(0xFF8FA584), Color(0xFF7A8B6F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    16: const LinearGradient(
      colors: [Color(0xFF7A8B6F), Color(0xFF5D7052)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    17: tertiary,       // المغرب
    18: tertiary,
    19: tertiary,
    20: const LinearGradient( // المساء
      colors: [Color(0xFF445A3B), Color(0xFF5D7052)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    21: const LinearGradient(
      colors: [Color(0xFF445A3B), Color(0xFF5D7052)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    22: darkBackground,
    23: darkBackground,
  };

  /// الحصول على تدرج حسب الوقت
  static LinearGradient getTimeBasedGradient({DateTime? dateTime}) {
    final time = dateTime ?? DateTime.now();
    return _timeGradients[time.hour] ?? primary;
  }

  // ==================== تدرجات حسب التقدم ====================
  
  /// تدرج حسب نسبة التقدم
  static LinearGradient getProgressGradient(double progress) {
    progress = progress.clamp(0.0, 1.0);
    
    if (progress < 0.3) {
      return error;
    } else if (progress < 0.7) {
      return warning;
    } else {
      return success;
    }
  }

  // ==================== تدرجات شفافة ====================
  
  /// تدرج شفاف من لون إلى شفاف
  static LinearGradient transparent(
    Color color, {
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
    List<double>? stops,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        color.withValues(alpha: 0.0),
        color.withValues(alpha: 0.3),
        color.withValues(alpha: 0.7),
        color,
      ],
      stops: stops ?? const [0.0, 0.3, 0.7, 1.0],
    );
  }

  /// تدرج overlay للخلفيات
  static LinearGradient overlay({
    Color color = Colors.black,
    double startOpacity = 0.0,
    double endOpacity = 0.6,
  }) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withValues(alpha: startOpacity),
        color.withValues(alpha: endOpacity),
      ],
    );
  }

  // ==================== تدرجات مخصصة ====================
  
  /// إنشاء تدرج مخصص من لونين
  static LinearGradient custom({
    required Color startColor,
    required Color endColor,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [startColor, endColor],
      stops: stops,
    );
  }

  /// إنشاء تدرج من عدة ألوان
  static LinearGradient multiColor({
    required List<Color> colors,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
      stops: stops,
    );
  }

  // ==================== تدرجات دائرية ====================
  
  /// تدرج دائري أساسي
  static RadialGradient radialPrimary({
    Alignment center = Alignment.center,
    double radius = 0.8,
  }) {
    return RadialGradient(
      center: center,
      radius: radius,
      colors: [AppColors.primaryLight, AppColors.primary],
    );
  }

  /// تدرج دائري مخصص
  static RadialGradient radialCustom({
    required List<Color> colors,
    Alignment center = Alignment.center,
    double radius = 0.8,
    List<double>? stops,
  }) {
    return RadialGradient(
      center: center,
      radius: radius,
      colors: colors,
      stops: stops,
    );
  }

  // ==================== تدرجات متقدمة ====================
  
  /// تدرج مع تأثير الشروق
  static const LinearGradient sunrise = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0xFFDAA520), // ذهبي
      Color(0xFFE8C899), // ذهبي فاتح
      Color(0xFF8FA584), // أخضر ناعم
      Color(0xFF6B8E9F), // أزرق رمادي
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  /// تدرج مع تأثير الغروب
  static const LinearGradient sunset = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF6B8E9F), // أزرق رمادي
      Color(0xFF8B6F47), // بني دافئ
      Color(0xFFD4A574), // برتقالي دافئ
      Color(0xFFB8860B), // ذهبي
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  // ==================== Cache Management ====================
  
  /// مسح cache التدرجات (للذاكرة)
  static void clearCache() {
    // يمكن إضافة منطق مسح cache إذا لزم الأمر
  }
}

/// Extension لإنشاء تدرجات سريعة
extension GradientExtensions on Color {
  /// إنشاء تدرج من اللون الحالي إلى لون آخر
  LinearGradient gradientTo(
    Color endColor, {
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [this, endColor],
    );
  }

  /// إنشاء تدرج شفاف
  LinearGradient get transparentGradient => AppGradients.transparent(this);

  /// إنشاء overlay
  LinearGradient overlayGradient({
    double startOpacity = 0.0,
    double endOpacity = 0.6,
  }) {
    return AppGradients.overlay(
      color: this,
      startOpacity: startOpacity,
      endOpacity: endOpacity,
    );
  }
}