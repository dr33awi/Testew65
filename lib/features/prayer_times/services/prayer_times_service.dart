// lib/features/prayer_times/services/prayer_times_service.dart (محدث)

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:adhan/adhan.dart' as adhan;

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
  DailyPrayerTimes? _currentTimes; // لحفظ المواقيت الحالية

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
    
    try {
      // تحميل الإعدادات المحفوظة
      await _loadSavedSettings();
      
      // تحميل الموقع المحفوظ
      await _loadSavedLocation();
      
      // بدء المؤقتات
      _startTimers();
      
      // تحديث المواقيت إذا كان هناك موقع محفوظ
      if (_currentLocation != null) {
        await updatePrayerTimes();
      }
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في تهيئة الخدمة',
        error: e,
      );
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
      
      _logger.debug(
        message: '[PrayerTimesService] تم تحميل الإعدادات',
        data: {
          'method': _settings.method.toString(),
          'notifications_enabled': _notificationSettings.enabled,
        },
      );
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
      if (_currentTimes != null) {
        _nextPrayerController.add(_currentTimes!.nextPrayer);
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
      
      // الحصول على الموقع
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15),
        );
      } catch (timeoutError) {
        _logger.warning(message: 'تعذر الحصول على موقع دقيق، محاولة الحصول على موقع تقريبي');
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 10),
        );
      }
      
      // الحصول على معلومات المنطقة الزمنية والمدينة
      final timezone = await _getTimezone(position.latitude, position.longitude);
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
        const defaultLocation = PrayerLocation(
          latitude: 24.7136,
          longitude: 46.6753,
          cityName: 'الرياض',
          countryName: 'المملكة العربية السعودية',
          timezone: 'Asia/Riyadh',
        );
        
        _logger.warning(message: '[PrayerTimesService] استخدام موقع افتراضي (الرياض)');
        
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
    try {
      // تخمين بسيط للمنطقة الزمنية حسب خط الطول
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
      return 'UTC';
    }
  }

  /// الحصول على معلومات المدينة
  Future<Map<String, String>> _getCityInfo(double latitude, double longitude) async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
        
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          final city = placemark.locality ?? 
                      placemark.subAdministrativeArea ?? 
                      placemark.administrativeArea ?? 
                      'غير معروف';
          final country = placemark.country ?? 'غير معروف';
          
          return {
            'city': city,
            'country': country,
          };
        }
      }
      
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
        final cachedTimes = _timesCache[dateKey]!.updatePrayerStates();
        _currentTimes = cachedTimes;
        
        // إرسال إلى Stream
        _prayerTimesController.add(cachedTimes);
        _nextPrayerController.add(cachedTimes.nextPrayer);
        
        return cachedTimes;
      }
      
      // حساب المواقيت باستخدام مكتبة adhan
      final prayers = _calculatePrayerTimes(targetDate, _currentLocation!);
      
      // إنشاء نموذج المواقيت اليومية
      final dailyTimes = DailyPrayerTimes(
        date: targetDate,
        prayers: prayers,
        location: _currentLocation!,
        settings: _settings,
      ).updatePrayerStates();
      
      _currentTimes = dailyTimes;
      
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
          'prayerCount': prayers.length,
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
    try {
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
      final adjustments = _settings.manualAdjustments;
      
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
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في حساب المواقيت',
        error: e,
      );
      rethrow;
    }
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
    try {
      final key = '${_cachedTimesKey}_${times.date.toIso8601String().split('T')[0]}';
      await _storage.setMap(key, times.toJson());
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في حفظ الكاش',
        error: e,
      );
    }
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
    
    try {
      // إلغاء التنبيهات السابقة
      await NotificationManager.instance.cancelAllPrayerNotifications();
      
      // جدولة تنبيهات جديدة
      for (final prayer in times.prayers) {
        // تخطي الشروق
        if (prayer.type == PrayerType.sunrise) continue;
        
        // التحقق من تفعيل التنبيه لهذه الصلاة
        if (_notificationSettings.enabledPrayers[prayer.type] != true) continue;
        
        // التحقق من أن الصلاة لم تمر بعد
        if (prayer.isPassed) continue;
        
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
      
      _logger.info(message: '[PrayerTimesService] تم جدولة التنبيهات');
    } catch (e) {
      _logger.error(
        message: '[PrayerTimesService] خطأ في جدولة التنبيهات',
        error: e,
      );
    }
  }

  /// تحديث حالات الصلوات
  void _updatePrayerStates() {
    if (_currentTimes != null) {
      final updated = _currentTimes!.updatePrayerStates();
      _currentTimes = updated;
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
      await updatePrayerTimes();
    }
    
    _logger.info(
      message: '[PrayerTimesService] تم تحديث إعدادات الحساب',
      data: {'method': settings.method.toString()},
    );
  }

  /// تحديث إعدادات التنبيهات
  Future<void> updateNotificationSettings(PrayerNotificationSettings settings) async {
    _notificationSettings = settings;
    await _storage.setMap(_notificationSettingsKey, settings.toJson());
    
    // إعادة جدولة التنبيهات
    if (_currentTimes != null) {
      await _scheduleNotifications(_currentTimes!);
    }
    
    _logger.info(
      message: '[PrayerTimesService] تم تحديث إعدادات التنبيهات',
      data: {'enabled': settings.enabled},
    );
  }

  /// تعيين موقع مخصص
  Future<void> setCustomLocation(PrayerLocation location) async {
    _currentLocation = location;
    await _saveLocation(location);
    
    // مسح الكاش لإجبار إعادة حساب المواقيت
    _timesCache.clear();
    
    await updatePrayerTimes();
    
    _logger.info(
      message: '[PrayerTimesService] تم تعيين موقع مخصص',
      data: {
        'city': location.cityName,
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
    );
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