// lib/features/prayer_times/models/prayer_time_model.dart

/// نموذج وقت الصلاة
class PrayerTime {
  final String id;
  final String nameAr;
  final String nameEn;
  final DateTime time;
  final DateTime? adhanTime;
  final DateTime? iqamaTime;
  final bool isNext;
  final bool isPassed;
  final PrayerType type;

  const PrayerTime({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.time,
    this.adhanTime,
    this.iqamaTime,
    this.isNext = false,
    this.isPassed = false,
    required this.type,
  });

  /// الحصول على الوقت المتبقي
  Duration get remainingTime {
    final now = DateTime.now();
    if (time.isAfter(now)) {
      return time.difference(now);
    }
    return Duration.zero;
  }

  /// التحقق من اقتراب الوقت (قبل 15 دقيقة)
  bool get isApproaching {
    final remaining = remainingTime;
    return remaining.inMinutes <= 15 && remaining.inMinutes > 0;
  }

  /// الحصول على نص الوقت المتبقي
  String get remainingTimeText {
    final duration = remainingTime;
    if (duration.inMinutes == 0) return 'حان الآن';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return 'بعد $hours ساعة و$minutes دقيقة';
    } else {
      return 'بعد $minutes دقيقة';
    }
  }

  /// نسخ مع تعديل
  PrayerTime copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    DateTime? time,
    DateTime? adhanTime,
    DateTime? iqamaTime,
    bool? isNext,
    bool? isPassed,
    PrayerType? type,
  }) {
    return PrayerTime(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      time: time ?? this.time,
      adhanTime: adhanTime ?? this.adhanTime,
      iqamaTime: iqamaTime ?? this.iqamaTime,
      isNext: isNext ?? this.isNext,
      isPassed: isPassed ?? this.isPassed,
      type: type ?? this.type,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'nameAr': nameAr,
    'nameEn': nameEn,
    'time': time.toIso8601String(),
    'adhanTime': adhanTime?.toIso8601String(),
    'iqamaTime': iqamaTime?.toIso8601String(),
    'isNext': isNext,
    'isPassed': isPassed,
    'type': type.index,
  };

  /// إنشاء من JSON
  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      time: DateTime.parse(json['time'] as String),
      adhanTime: json['adhanTime'] != null ? DateTime.parse(json['adhanTime'] as String) : null,
      iqamaTime: json['iqamaTime'] != null ? DateTime.parse(json['iqamaTime'] as String) : null,
      isNext: json['isNext'] as bool? ?? false,
      isPassed: json['isPassed'] as bool? ?? false,
      type: PrayerType.values[json['type'] as int],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTime &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          time == other.time;

  @override
  int get hashCode => id.hashCode ^ time.hashCode;

  @override
  String toString() => 'PrayerTime(id: $id, nameAr: $nameAr, time: $time)';
}

/// أنواع الصلوات
enum PrayerType {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
  midnight,
  lastThird,
}

/// طرق الحساب
enum CalculationMethod {
  muslimWorldLeague,    // رابطة العالم الإسلامي
  egyptian,            // الهيئة المصرية العامة للمساحة
  karachi,            // جامعة العلوم الإسلامية، كراتشي
  ummAlQura,          // أم القرى
  dubai,              // دبي
  qatar,              // قطر
  kuwait,             // الكويت
  singapore,          // سنغافورة
  northAmerica,       // الجمعية الإسلامية لأمريكا الشمالية
  other,              // أخرى
}

/// المذهب الفقهي
enum AsrJuristic {
  standard,  // الجمهور (الشافعي، المالكي، الحنبلي)
  hanafi,    // الحنفي
}

/// إعدادات حساب مواقيت الصلاة
class PrayerCalculationSettings {
  final CalculationMethod method;
  final AsrJuristic asrJuristic;
  final int fajrAngle;
  final int ishaAngle;
  final int maghribAngle;
  final bool summerTimeAdjustment;
  final Map<String, int> manualAdjustments;

  const PrayerCalculationSettings({
    this.method = CalculationMethod.ummAlQura,
    this.asrJuristic = AsrJuristic.standard,
    this.fajrAngle = 18,
    this.ishaAngle = 17,
    this.maghribAngle = 0,
    this.summerTimeAdjustment = false,
    this.manualAdjustments = const {},
  });

  /// نسخ مع تعديل
  PrayerCalculationSettings copyWith({
    CalculationMethod? method,
    AsrJuristic? asrJuristic,
    int? fajrAngle,
    int? ishaAngle,
    int? maghribAngle,
    bool? summerTimeAdjustment,
    Map<String, int>? manualAdjustments,
  }) {
    return PrayerCalculationSettings(
      method: method ?? this.method,
      asrJuristic: asrJuristic ?? this.asrJuristic,
      fajrAngle: fajrAngle ?? this.fajrAngle,
      ishaAngle: ishaAngle ?? this.ishaAngle,
      maghribAngle: maghribAngle ?? this.maghribAngle,
      summerTimeAdjustment: summerTimeAdjustment ?? this.summerTimeAdjustment,
      manualAdjustments: manualAdjustments ?? this.manualAdjustments,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() => {
    'method': method.index,
    'asrJuristic': asrJuristic.index,
    'fajrAngle': fajrAngle,
    'ishaAngle': ishaAngle,
    'maghribAngle': maghribAngle,
    'summerTimeAdjustment': summerTimeAdjustment,
    'manualAdjustments': manualAdjustments,
  };

  /// إنشاء من JSON
  factory PrayerCalculationSettings.fromJson(Map<String, dynamic> json) {
    return PrayerCalculationSettings(
      method: CalculationMethod.values[json['method'] as int? ?? 0],
      asrJuristic: AsrJuristic.values[json['asrJuristic'] as int? ?? 0],
      fajrAngle: json['fajrAngle'] as int? ?? 18,
      ishaAngle: json['ishaAngle'] as int? ?? 17,
      maghribAngle: json['maghribAngle'] as int? ?? 0,
      summerTimeAdjustment: json['summerTimeAdjustment'] as bool? ?? false,
      manualAdjustments: Map<String, int>.from(json['manualAdjustments'] as Map? ?? {}),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerCalculationSettings &&
          runtimeType == other.runtimeType &&
          method == other.method &&
          asrJuristic == other.asrJuristic;

  @override
  int get hashCode => method.hashCode ^ asrJuristic.hashCode;
}

/// بيانات الموقع للصلاة
class PrayerLocation {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? countryName;
  final String timezone;
  final double? altitude;

  const PrayerLocation({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.countryName,
    required this.timezone,
    this.altitude,
  });

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'cityName': cityName,
    'countryName': countryName,
    'timezone': timezone,
    'altitude': altitude,
  };

  /// إنشاء من JSON
  factory PrayerLocation.fromJson(Map<String, dynamic> json) {
    return PrayerLocation(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      cityName: json['cityName'] as String?,
      countryName: json['countryName'] as String?,
      timezone: json['timezone'] as String,
      altitude: json['altitude'] as double?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerLocation &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => 'PrayerLocation(cityName: $cityName, lat: $latitude, lng: $longitude)';
}

/// حالة مواقيت الصلاة اليومية
class DailyPrayerTimes {
  final DateTime date;
  final List<PrayerTime> prayers;
  final PrayerLocation location;
  final PrayerCalculationSettings settings;

  const DailyPrayerTimes({
    required this.date,
    required this.prayers,
    required this.location,
    required this.settings,
  });

  /// الحصول على الصلاة التالية
  PrayerTime? get nextPrayer {
    try {
      return prayers.firstWhere((prayer) => prayer.isNext);
    } catch (_) {
      return null;
    }
  }

  /// الحصول على الصلاة الحالية (آخر صلاة مرت)
  PrayerTime? get currentPrayer {
    final passedPrayers = prayers.where((p) => p.isPassed).toList();
    if (passedPrayers.isEmpty) return null;
    return passedPrayers.last;
  }

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

  /// تحديث حالات الصلوات
  DailyPrayerTimes updatePrayerStates() {
    final now = DateTime.now();
    final updatedPrayers = <PrayerTime>[];
    
    PrayerTime? nextPrayer;
    
    for (int i = 0; i < prayers.length; i++) {
      final prayer = prayers[i];
      final isPassed = prayer.time.isBefore(now);
      final isNext = nextPrayer == null && !isPassed;
      
      if (isNext) nextPrayer = prayer;
      
      updatedPrayers.add(prayer.copyWith(
        isPassed: isPassed,
        isNext: isNext,
      ));
    }
    
    return DailyPrayerTimes(
      date: date,
      prayers: updatedPrayers,
      location: location,
      settings: settings,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'prayers': prayers.map((p) => p.toJson()).toList(),
    'location': location.toJson(),
    'settings': settings.toJson(),
  };

  /// إنشاء من JSON
  factory DailyPrayerTimes.fromJson(Map<String, dynamic> json) {
    return DailyPrayerTimes(
      date: DateTime.parse(json['date'] as String),
      prayers: (json['prayers'] as List)
          .map((p) => PrayerTime.fromJson(p as Map<String, dynamic>))
          .toList(),
      location: PrayerLocation.fromJson(json['location'] as Map<String, dynamic>),
      settings: PrayerCalculationSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPrayerTimes &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          location == other.location;

  @override
  int get hashCode => date.hashCode ^ location.hashCode;
}

/// إعدادات تنبيهات الصلاة
class PrayerNotificationSettings {
  final bool enabled;
  final Map<PrayerType, bool> enabledPrayers;
  final Map<PrayerType, int> minutesBefore;
  final bool playAdhan;
  final String adhanSound;
  final bool vibrate;

  const PrayerNotificationSettings({
    this.enabled = true,
    this.enabledPrayers = const {
      PrayerType.fajr: true,
      PrayerType.dhuhr: true,
      PrayerType.asr: true,
      PrayerType.maghrib: true,
      PrayerType.isha: true,
    },
    this.minutesBefore = const {
      PrayerType.fajr: 15,
      PrayerType.dhuhr: 10,
      PrayerType.asr: 10,
      PrayerType.maghrib: 5,
      PrayerType.isha: 10,
    },
    this.playAdhan = false,
    this.adhanSound = 'default',
    this.vibrate = true,
  });

  /// نسخ مع تعديل
  PrayerNotificationSettings copyWith({
    bool? enabled,
    Map<PrayerType, bool>? enabledPrayers,
    Map<PrayerType, int>? minutesBefore,
    bool? playAdhan,
    String? adhanSound,
    bool? vibrate,
  }) {
    return PrayerNotificationSettings(
      enabled: enabled ?? this.enabled,
      enabledPrayers: enabledPrayers ?? this.enabledPrayers,
      minutesBefore: minutesBefore ?? this.minutesBefore,
      playAdhan: playAdhan ?? this.playAdhan,
      adhanSound: adhanSound ?? this.adhanSound,
      vibrate: vibrate ?? this.vibrate,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'enabledPrayers': enabledPrayers.map((k, v) => MapEntry(k.index.toString(), v)),
    'minutesBefore': minutesBefore.map((k, v) => MapEntry(k.index.toString(), v)),
    'playAdhan': playAdhan,
    'adhanSound': adhanSound,
    'vibrate': vibrate,
  };

  /// إنشاء من JSON
  factory PrayerNotificationSettings.fromJson(Map<String, dynamic> json) {
    return PrayerNotificationSettings(
      enabled: json['enabled'] as bool? ?? true,
      enabledPrayers: (json['enabledPrayers'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(PrayerType.values[int.parse(k)], v as bool),
      ) ?? const {},
      minutesBefore: (json['minutesBefore'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(PrayerType.values[int.parse(k)], v as int),
      ) ?? const {},
      playAdhan: json['playAdhan'] as bool? ?? false,
      adhanSound: json['adhanSound'] as String? ?? 'default',
      vibrate: json['vibrate'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerNotificationSettings &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled;

  @override
  int get hashCode => enabled.hashCode;
}