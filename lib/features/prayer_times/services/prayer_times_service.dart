// lib/features/prayer_times/services/prayer_times_service.dart

import 'dart:async';


import 'package:geolocator/geolocator.dart';
import 'package:adhan/adhan.dart' as adhan;
import 'package:timezone/timezone.dart' as tz;

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
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updatePrayerStates();
    });
    
    // مؤقت العد التنازلي كل ثانية
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
      throw LocationException('لا توجد صلاحية للوصول للموقع');
    }
    
    try {
      // الحصول على الموقع
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );
      
      // الحصول على معلومات المنطقة الزمنية
      final timezone = await _getTimezone(position.latitude, position.longitude);
      
      // الحصول على اسم المدينة والدولة (يمكن استخدام Geocoding API)
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
    // يمكن استخدام timezone API أو حسابها محلياً
    // هنا نستخدم قيمة افتراضية
    return 'Asia/Riyadh';
  }

  /// الحصول على معلومات المدينة
  Future<Map<String, String>> _getCityInfo(double latitude, double longitude) async {
    // يمكن استخدام Geocoding API
    // هنا نستخدم قيم افتراضية
    return {
      'city': 'الرياض',
      'country': 'المملكة العربية السعودية',
    };
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
    
    if (_currentLocation == null) {
      throw DataNotFoundException('لم يتم تحديد الموقع');
    }
    
    _logger.info(
      message: '[PrayerTimesService] حساب مواقيت الصلاة',
      data: {'date': targetDate.toIso8601String()},
    );
    
    try {
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
    
    // تحويل إلى نموذج التطبيق
    return [
      PrayerTime(
        id: 'fajr',
        nameAr: 'الفجر',
        nameEn: 'Fajr',
        time: prayerTimes.fajr,
        type: PrayerType.fajr,
      ),
      PrayerTime(
        id: 'sunrise',
        nameAr: 'الشروق',
        nameEn: 'Sunrise',
        time: prayerTimes.sunrise,
        type: PrayerType.sunrise,
      ),
      PrayerTime(
        id: 'dhuhr',
        nameAr: 'الظهر',
        nameEn: 'Dhuhr',
        time: prayerTimes.dhuhr,
        type: PrayerType.dhuhr,
      ),
      PrayerTime(
        id: 'asr',
        nameAr: 'العصر',
        nameEn: 'Asr',
        time: prayerTimes.asr,
        type: PrayerType.asr,
      ),
      PrayerTime(
        id: 'maghrib',
        nameAr: 'المغرب',
        nameEn: 'Maghrib',
        time: prayerTimes.maghrib,
        type: PrayerType.maghrib,
      ),
      PrayerTime(
        id: 'isha',
        nameAr: 'العشاء',
        nameEn: 'Isha',
        time: prayerTimes.isha,
        type: PrayerType.isha,
      ),
    ];
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
    
    // تطبيق التعديلات اليدوية
    params.adjustments.fajr = _settings.manualAdjustments['fajr'] ?? 0;
    params.adjustments.sunrise = _settings.manualAdjustments['sunrise'] ?? 0;
    params.adjustments.dhuhr = _settings.manualAdjustments['dhuhr'] ?? 0;
    params.adjustments.asr = _settings.manualAdjustments['asr'] ?? 0;
    params.adjustments.maghrib = _settings.manualAdjustments['maghrib'] ?? 0;
    params.adjustments.isha = _settings.manualAdjustments['isha'] ?? 0;
    
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
        // التحقق من تفعيل التنبيه لهذه الصلاة
        if (_notificationSettings.enabledPrayers[prayer.type] != true) {
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
    
    // إعادة حساب المواقيت
    if (_currentLocation != null) {
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
      return hasListener && !isClosed && isPaused == false
          ? stream.first as T?
          : null;
    } catch (_) {
      return null;
    }
  }
}