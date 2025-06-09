// lib/features/prayer_times/services/prayer_times_service.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:adhan/adhan.dart' as adhan;
import 'package:rxdart/rxdart.dart';

import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/error/exceptions.dart';
import '../models/prayer_time_model.dart';

/// خدمة مواقيت الصلاة
class PrayerTimesService {
  final LoggerService _logger;
  final StorageService _storage;
  final PermissionService _permissionService;
  
  // مفاتيح التخزين
  static const String _locationKey = 'prayer_location';
  static const String _settingsKey = 'prayer_settings';
  static const String _notificationSettingsKey = 'prayer_notification_settings';
  static const String _cachedTimesKey = 'cached_prayer_times';
  static const String _lastLocationUpdateKey = 'last_location_update';
  
  // متغيرات الحالة
  PrayerLocation? _currentLocation;
  PrayerCalculationSettings _settings = const PrayerCalculationSettings();
  PrayerNotificationSettings _notificationSettings = const PrayerNotificationSettings();
  
  // Stream Controllers
  final _prayerTimesController = StreamController<DailyPrayerTimes>.broadcast();
  final _nextPrayerController = StreamController<PrayerTime?>.broadcast();
  Timer? _updateTimer;
  Timer? _countdownTimer;
  
  // Cache
  final Map<String, DailyPrayerTimes> _timesCache = {};

  PrayerTimesService({
    required LoggerService logger,
    required StorageService storage,
    required PermissionService permissionService,
  }) : _logger = logger,
       _storage = storage,
       _permissionService = permissionService {
    _initialize();
  }

  /// تهيئة الخدمة
  Future<void> _initialize() async {
    _logger.debug(message: '[PrayerTimesService] تهيئة خدمة مواقيت الصلاة');
    
    // تحميل الإعدادات المحفوظة
    await _loadSavedSettings();
    
    // تحميل الموقع المحفوظ
    await _loadSavedLocation();
    
    // بدء المؤقتات
    _startTimers();
    
    // تحديث المواقيت
    if (_currentLocation != null) {
      await updatePrayerTimes();
    }
  }

  /// تحميل الإعدادات المحفوظة
  Future<void> _loadSavedSettings() async {
    try {
      // إعدادات الحساب
      final settingsJson = _storage.getMap(_settingsKey);
      if (settingsJson != null) {
        _settings = PrayerCalculationSettings.fromJson(settingsJson);
      }
      
      // إعدادات التنبيهات
      final notifJson = _storage.getMap(_notificationSettingsKey);
      if (notifJson != null) {
        _notificationSettings = PrayerNotificationSettings.fromJson(notifJson);
      }
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في تحميل الإعدادات',
        error: e,
      );
    }
  }

  /// تحميل الموقع المحفوظ
  Future<void> _loadSavedLocation() async {
    try {
      final locationJson = _storage.getMap(_locationKey);
      if (locationJson != null) {
        _currentLocation = PrayerLocation.fromJson(locationJson);
        _logger.info(
          message: '[PrayerTimesService] تم تحميل الموقع المحفوظ',
          data: {
            'city': _currentLocation?.cityName,
            'country': _currentLocation?.countryName,
            'latitude': _currentLocation?.latitude,
            'longitude': _currentLocation?.longitude,
          },
        );
      }
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في تحميل الموقع',
        error: e,
      );
    }
  }

  /// بدء المؤقتات
  void _startTimers() {
    // مؤقت تحديث المواقيت كل دقيقة
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updatePrayerStates();
    });
    
    // مؤقت العد التنازلي كل ثانية
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final times = _prayerTimesController.valueOrNull;
      if (times != null) {
        _nextPrayerController.add(times.nextPrayer);
      }
    });
  }

  /// الحصول على الموقع الحالي
  Future<PrayerLocation> getCurrentLocation() async {
    _logger.info(message: '[PrayerTimesService] الحصول على الموقع الحالي');
    
    // التحقق من الأذونات
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      throw LocationException('لا توجد صلاحية للوصول للموقع', code: 'PERMISSION_DENIED');
    }
    
    try {
      // التحقق من تفعيل خدمة الموقع
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException('خدمة الموقع غير مفعلة في الجهاز', code: 'SERVICE_DISABLED');
      }
      
      // الحصول على الموقع - محاولة دقيقة أولاً
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
      } catch (timeoutError) {
        // إذا استغرق وقتاً طويلاً، نستخدم دقة أقل
        _logger.warning(message: 'تعذر الحصول على موقع دقيق، محاولة الحصول على موقع تقريبي');
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 10),
        );
      }
      
      // الحصول على معلومات المنطقة الزمنية
      final timezone = await _getTimezone(position.latitude, position.longitude);
      
      // الحصول على اسم المدينة والدولة
      final cityInfo = await _getCityInfo(position.latitude, position.longitude);
      
      final location = PrayerLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: cityInfo['city'],
        countryName: cityInfo['country'],
        timezone: timezone,
        altitude: position.altitude,
      );
      
      // حفظ الموقع
      _currentLocation = location;
      await _saveLocation(location);
      
      _logger.info(
        message: '[PrayerTimesService] تم الحصول على الموقع',
        data: {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'city': location.cityName,
          'country': location.countryName,
        },
      );
      
      return location;
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في الحصول على الموقع',
        error: e,
      );
      
      // إذا فشل الحصول على الموقع وليس لدينا موقع محفوظ، نستخدم موقع افتراضي
      if (_currentLocation == null) {
        // موقع الرياض كموقع افتراضي
        const defaultLocation = PrayerLocation(
          latitude: 24.7136,
          longitude: 46.6753,
          cityName: 'الرياض',
          countryName: 'المملكة العربية السعودية',
          timezone: 'Asia/Riyadh',
        );
        
        _logger.warning(
          message: '[PrayerTimesService] استخدام موقع افتراضي',
          data: {
            'latitude': defaultLocation.latitude,
            'longitude': defaultLocation.longitude,
            'city': defaultLocation.cityName,
          },
        );
        
        _currentLocation = defaultLocation;
        await _saveLocation(defaultLocation);
        return defaultLocation;
      }
      
      throw LocationException('فشل الحصول على الموقع: ${e.toString()}');
    }
  }

  /// التحقق من أذونات الموقع
  Future<bool> _checkLocationPermission() async {
    final status = await _permissionService.checkPermissionStatus(
      AppPermissionType.location,
    );
    
    if (status != AppPermissionStatus.granted) {
      final result = await _permissionService.requestPermission(
        AppPermissionType.location,
      );
      return result == AppPermissionStatus.granted;
    }
    
    return true;
  }

  /// الحصول على المنطقة الزمنية
  Future<String> _getTimezone(double latitude, double longitude) async {
    // في الإصدار الحقيقي يمكن استخدام API خارجية للحصول على المنطقة الزمنية
    // حسب الموقع الجغرافي
    
    // لكن هنا سنستخدم تخمين بسيط للمنطقة الزمنية
    try {
      if (longitude >= 20 && longitude <= 60) {
        return 'Asia/Riyadh'; // غرب آسيا والشرق الأوسط
      } else if (longitude >= 60 && longitude <= 90) {
        return 'Asia/Kolkata'; // جنوب آسيا
      } else if (longitude >= 90 && longitude <= 140) {
        return 'Asia/Shanghai'; // شرق آسيا
      } else if (longitude >= 140 || longitude <= -100) {
        return 'Pacific/Honolulu'; // المحيط الهادئ
      } else if (longitude >= -100 && longitude <= -30) {
        return 'America/New_York'; // أمريكا
      } else {
        return 'Europe/London'; // أوروبا وغرب أفريقيا
      }
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في تحديد المنطقة الزمنية',
        error: e,
      );
      return 'UTC'; // قيمة افتراضية
    }
  }

  /// الحصول على معلومات المدينة
  Future<Map<String, String>> _getCityInfo(double latitude, double longitude) async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
        
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          final city = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea;
          final country = placemark.country;
          
          return {
            'city': city ?? 'غير معروف',
            'country': country ?? 'غير معروف',
          };
        }
      }
      
      // في حالة عدم وجود معلومات
      return {
        'city': 'غير معروف',
        'country': 'غير معروف',
      };
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في الحصول على معلومات المدينة',
        error: e,
      );
      
      return {
        'city': 'غير معروف',
        'country': 'غير معروف',
      };
    }
  }

  /// حفظ الموقع
  Future<void> _saveLocation(PrayerLocation location) async {
    await _storage.setMap(_locationKey, location.toJson());
    await _storage.setString(
      _lastLocationUpdateKey,
      DateTime.now().toIso8601String(),
    );
  }

  /// تحديث مواقيت الصلاة
  Future<DailyPrayerTimes> updatePrayerTimes({DateTime? date}) async {
    final targetDate = date ?? DateTime.now();
    final dateKey = targetDate.toIso8601String().split('T')[0];
    
    if (_currentLocation == null) {
      throw DataNotFoundException('لم يتم تحديد الموقع');
    }
    
    _logger.info(
      message: '[PrayerTimesService] حساب مواقيت الصلاة',
      data: {'date': dateKey},
    );
    
    try {
      // تحقق من وجود المواقيت في الذاكرة المؤقتة
      if (_timesCache.containsKey(dateKey)) {
        final cachedTimes = _timesCache[dateKey]!;
        
        // تحديث حالات الصلوات
        final updatedTimes = cachedTimes.updatePrayerStates();
        
        // إرسال إلى Stream
        _prayerTimesController.add(updatedTimes);
        _nextPrayerController.add(updatedTimes.nextPrayer);
        
        _logger.info(
          message: '[PrayerTimesService] استخدام المواقيت من الذاكرة المؤقتة',
          data: {'date': dateKey},
        );
        
        return updatedTimes;
      }
      
      // حساب المواقيت باستخدام مكتبة adhan
      final prayers = _calculatePrayerTimes(targetDate, _currentLocation!);
      
      // تحديث حالات الصلوات
      final dailyTimes = DailyPrayerTimes(
        date: targetDate,
        prayers: prayers,
        location: _currentLocation!,
        settings: _settings,
      ).updatePrayerStates();
      
      // حفظ في الكاش
      await _cachePrayerTimes(dailyTimes);
      
      // حفظ في الذاكرة المؤقتة
      _timesCache[dateKey] = dailyTimes;
      
      // إرسال إلى Stream
      _prayerTimesController.add(dailyTimes);
      _nextPrayerController.add(dailyTimes.nextPrayer);
      
      // جدولة التنبيهات
      await _scheduleNotifications(dailyTimes);
      
      _logger.info(
        message: '[PrayerTimesService] تم حساب المواقيت',
        data: {
          'nextPrayer': dailyTimes.nextPrayer?.nameAr,
          'remainingTime': dailyTimes.nextPrayer?.remainingTimeText,
        },
      );
      
      return dailyTimes;
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في حساب المواقيت',
        error: e,
      );
      throw DataLoadException('فشل حساب مواقيت الصلاة: ${e.toString()}');
    }
  }

  /// حساب مواقيت الصلاة
  List<PrayerTime> _calculatePrayerTimes(DateTime date, PrayerLocation location) {
    // إعداد الإحداثيات
    final coordinates = adhan.Coordinates(
      location.latitude,
      location.longitude,
    );
    
    // إعداد طريقة الحساب
    final params = _getCalculationParameters();
    
    // إعداد التاريخ
    final components = adhan.DateComponents.from(date);
    
    // حساب المواقيت
    final prayerTimes = adhan.PrayerTimes(coordinates, components, params);
    
    // تطبيق التعديلات اليدوية
    final Map<String, int> adjustments = _settings.manualAdjustments;
    
    // تحويل إلى نموذج التطبيق
    return [
      PrayerTime(
        id: 'fajr',
        nameAr: 'الفجر',
        nameEn: 'Fajr',
        time: _applyAdjustment(prayerTimes.fajr, adjustments['fajr'] ?? 0),
        type: PrayerType.fajr,
      ),
      PrayerTime(
        id: 'sunrise',
        nameAr: 'الشروق',
        nameEn: 'Sunrise',
        time: _applyAdjustment(prayerTimes.sunrise, adjustments['sunrise'] ?? 0),
        type: PrayerType.sunrise,
      ),
      PrayerTime(
        id: 'dhuhr',
        nameAr: 'الظهر',
        nameEn: 'Dhuhr',
        time: _applyAdjustment(prayerTimes.dhuhr, adjustments['dhuhr'] ?? 0),
        type: PrayerType.dhuhr,
      ),
      PrayerTime(
        id: 'asr',
        nameAr: 'العصر',
        nameEn: 'Asr',
        time: _applyAdjustment(prayerTimes.asr, adjustments['asr'] ?? 0),
        type: PrayerType.asr,
      ),
      PrayerTime(
        id: 'maghrib',
        nameAr: 'المغرب',
        nameEn: 'Maghrib',
        time: _applyAdjustment(prayerTimes.maghrib, adjustments['maghrib'] ?? 0),
        type: PrayerType.maghrib,
      ),
      PrayerTime(
        id: 'isha',
        nameAr: 'العشاء',
        nameEn: 'Isha',
        time: _applyAdjustment(prayerTimes.isha, adjustments['isha'] ?? 0),
        type: PrayerType.isha,
      ),
    ];
  }

  /// تطبيق تعديل الوقت
  DateTime _applyAdjustment(DateTime time, int minutes) {
    return time.add(Duration(minutes: minutes));
  }

  /// الحصول على معاملات الحساب
  adhan.CalculationParameters _getCalculationParameters() {
    adhan.CalculationParameters params;
    
    // اختيار طريقة الحساب
    switch (_settings.method) {
      case CalculationMethod.muslimWorldLeague:
        params = adhan.CalculationMethod.muslim_world_league.getParameters();
        break;
      case CalculationMethod.egyptian:
        params = adhan.CalculationMethod.egyptian.getParameters();
        break;
      case CalculationMethod.karachi:
        params = adhan.CalculationMethod.karachi.getParameters();
        break;
      case CalculationMethod.ummAlQura:
        params = adhan.CalculationMethod.umm_al_qura.getParameters();
        break;
      case CalculationMethod.dubai:
        params = adhan.CalculationMethod.dubai.getParameters();
        break;
      case CalculationMethod.qatar:
        params = adhan.CalculationMethod.qatar.getParameters();
        break;
      case CalculationMethod.kuwait:
        params = adhan.CalculationMethod.kuwait.getParameters();
        break;
      case CalculationMethod.singapore:
        params = adhan.CalculationMethod.singapore.getParameters();
        break;
      case CalculationMethod.northAmerica:
        params = adhan.CalculationMethod.north_america.getParameters();
        break;
      default:
        params = adhan.CalculationMethod.other.getParameters();
        params.fajrAngle = _settings.fajrAngle.toDouble();
        params.ishaAngle = _settings.ishaAngle.toDouble();
    }
    
    // إعداد المذهب
    params.madhab = _settings.asrJuristic == AsrJuristic.hanafi
        ? adhan.Madhab.hanafi
        : adhan.Madhab.shafi;
    
    return params;
  }

  /// حفظ المواقيت في الكاش
  Future<void> _cachePrayerTimes(DailyPrayerTimes times) async {
    final key = '${_cachedTimesKey}_${times.date.toIso8601String().split('T')[0]}';
    await _storage.setMap(key, times.toJson());
  }

  /// الحصول على المواقيت المحفوظة
  Future<DailyPrayerTimes?> getCachedPrayerTimes(DateTime date) async {
    final key = '${_cachedTimesKey}_${date.toIso8601String().split('T')[0]}';
    final json = _storage.getMap(key);
    
    if (json != null) {
      try {
        return DailyPrayerTimes.fromJson(json);
      } catch (e) {
        _logger.error(
          message: '[PrayerTimesService] خطأ في قراءة المواقيت المحفوظة',
          error: e,
        );
      }
    }
    
    return null;
  }

  /// جدولة التنبيهات
  Future<void> _scheduleNotifications(DailyPrayerTimes times) async {
    if (!_notificationSettings.enabled) return;
    
    _logger.info(message: '[PrayerTimesService] جدولة تنبيهات الصلاة');
    
    try {
      // إلغاء التنبيهات السابقة
      await NotificationManager.instance.cancelAllPrayerNotifications();
      
      // جدولة تنبيهات جديدة
      for (final prayer in times.prayers) {
        // تخطي الشروق لأنه ليس صلاة
        if (prayer.type == PrayerType.sunrise) {
          continue;
        }
        
        // التحقق من تفعيل التنبيه لهذه الصلاة
        if (_notificationSettings.enabledPrayers[prayer.type] != true) {
          continue;
        }
        
        // التحقق من أن الصلاة لم تمر بعد
        if (prayer.isPassed) {
          continue;
        }
        
        // تنبيه قبل الصلاة
        final minutesBefore = _notificationSettings.minutesBefore[prayer.type] ?? 0;
        if (minutesBefore > 0) {
          await NotificationManager.instance.schedulePrayerNotification(
            prayerName: prayer.id,
            arabicName: prayer.nameAr,
            time: prayer.time,
            minutesBefore: minutesBefore,
          );
        }
        
        // تنبيه وقت الصلاة
        await NotificationManager.instance.schedulePrayerNotification(
          prayerName: prayer.id,
          arabicName: prayer.nameAr,
          time: prayer.time,
          minutesBefore: 0,
        );
      }
      
      _logger.info(
        message: '[PrayerTimesService] تم جدولة التنبيهات',
        data: {'count': times.prayers.length},
      );
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في جدولة التنبيهات',
        error: e,
      );
    }
  }

  /// تحديث حالات الصلوات
  void _updatePrayerStates() {
    final currentTimes = _prayerTimesController.valueOrNull;
    if (currentTimes != null) {
      final updated = currentTimes.updatePrayerStates();
      _prayerTimesController.add(updated);
      _nextPrayerController.add(updated.nextPrayer);
    }
  }

  /// تحديث إعدادات الحساب
  Future<void> updateCalculationSettings(PrayerCalculationSettings settings) async {
    _settings = settings;
    await _storage.setMap(_settingsKey, settings.toJson());
    
    // مسح الكاش لإجبار إعادة حساب المواقيت
    _timesCache.clear();
    
    // إعادة حساب المواقيت
    if (_currentLocation != null) {
      // عرض المواقيت المخزنة سابقاً أثناء إعادة الحساب
      final cachedTimes = await getCachedPrayerTimes(DateTime.now());
      if (cachedTimes != null) {
        _prayerTimesController.add(cachedTimes);
        _nextPrayerController.add(cachedTimes.nextPrayer);
      }
      
      // حساب المواقيت الجديدة
      await updatePrayerTimes();
    }
  }

  /// تحديث إعدادات التنبيهات
  Future<void> updateNotificationSettings(PrayerNotificationSettings settings) async {
    _notificationSettings = settings;
    await _storage.setMap(_notificationSettingsKey, settings.toJson());
    
    // إعادة جدولة التنبيهات
    final currentTimes = _prayerTimesController.valueOrNull;
    if (currentTimes != null) {
      await _scheduleNotifications(currentTimes);
    }
  }

  /// تعيين موقع مخصص
  Future<void> setCustomLocation(PrayerLocation location) async {
    _currentLocation = location;
    await _saveLocation(location);
    
    // مسح الكاش لإجبار إعادة حساب المواقيت
    _timesCache.clear();
    
    await updatePrayerTimes();
  }

  // Getters
  Stream<DailyPrayerTimes> get prayerTimesStream => _prayerTimesController.stream;
  Stream<PrayerTime?> get nextPrayerStream => _nextPrayerController.stream;
  PrayerLocation? get currentLocation => _currentLocation;
  PrayerCalculationSettings get calculationSettings => _settings;
  PrayerNotificationSettings get notificationSettings => _notificationSettings;

  /// تنظيف الموارد
  void dispose() {
    _updateTimer?.cancel();
    _countdownTimer?.cancel();
    _prayerTimesController.close();
    _nextPrayerController.close();
    
    _logger.info(message: '[PrayerTimesService] تم تنظيف الموارد');
  }
}

// Extension for nullable stream value
extension _StreamControllerExtension<T> on StreamController<T> {
  T? get valueOrNull {
    try {
      if (hasListener && !isClosed && isPaused == false) {
        final stream = this.stream;
        if (stream is BehaviorSubject<T>) {
          return stream.value;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}