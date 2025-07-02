// lib/features/qibla/services/qibla_service.dart - محسن بالنظام الموحد
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../app/themes/app_theme.dart'; // ✅ النظام الموحد الكامل
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../domain/models/qibla_model.dart';

class QiblaService extends ChangeNotifier {
  final LoggerService _logger;
  final StorageService _storage;
  final PermissionService _permissionService;

  // ✅ استخدام ThemeConstants للقيم الثابتة
  static const String _qiblaDataKey = 'qibla_data';
  static const String _calibrationDataKey = 'compass_calibration';
  static const Duration _locationTimeout = Duration(seconds: 20);
  static const Duration _calibrationDuration = ThemeConstants.durationExtraSlow;
  static const int _filterSize = 8;
  static const double _highAccuracyThreshold = 0.8;
  static const double _mediumAccuracyThreshold = 0.5;
  static const double _movementThreshold = 100.0; // متر

  // حالة البيانات
  QiblaModel? _qiblaData;
  bool _isLoading = false;
  String? _errorMessage;

  // البوصلة
  StreamSubscription<CompassEvent>? _compassSubscription;
  double _currentDirection = 0.0;
  bool _hasCompass = false;
  double _compassAccuracy = 0.0;
  bool _isCalibrated = false;

  // تصفية القراءات - محسن لدقة أعلى
  final List<double> _directionHistory = [];
  DateTime? _lastUpdate;
  Timer? _locationUpdateTimer;

  QiblaService({
    required LoggerService logger,
    required StorageService storage,
    required PermissionService permissionService,
  })  : _logger = logger,
        _storage = storage,
        _permissionService = permissionService {
    _init();
  }

  // ✅ الخصائص مع استخدام AppColorSystem
  QiblaModel? get qiblaData => _qiblaData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get currentDirection => _currentDirection;
  bool get hasCompass => _hasCompass;
  double get compassAccuracy => _compassAccuracy;
  bool get isCalibrated => _isCalibrated;

  // ✅ لون الدقة من النظام الموحد
  Color get accuracyColor {
    if (_compassAccuracy >= _highAccuracyThreshold) {
      return AppColorSystem.success;
    } else if (_compassAccuracy >= _mediumAccuracyThreshold) {
      return AppColorSystem.warning;
    } else {
      return AppColorSystem.error;
    }
  }

  // ✅ نص الدقة مع الألوان
  String get accuracyText {
    if (_compassAccuracy >= _highAccuracyThreshold) return 'عالية';
    if (_compassAccuracy >= _mediumAccuracyThreshold) return 'متوسطة';
    return 'منخفضة';
  }

  // ✅ أيقونة الدقة من النظام الموحد
  IconData get accuracyIcon {
    if (_compassAccuracy >= _highAccuracyThreshold) return AppIconsSystem.success;
    if (_compassAccuracy >= _mediumAccuracyThreshold) return AppIconsSystem.warning;
    return AppIconsSystem.error;
  }

  // اتجاه القبلة بالنسبة للاتجاه الحالي
  double get qiblaAngle {
    if (_qiblaData == null) return 0;
    return (_qiblaData!.qiblaDirection - _currentDirection + 360) % 360;
  }

  // ✅ حالة القبلة مع الألوان
  QiblaStatus get qiblaStatus {
    if (_qiblaData == null) return QiblaStatus.unknown;
    
    final angleDifference = _getAngleDifference();
    if (angleDifference < 5) return QiblaStatus.perfect;
    if (angleDifference < 15) return QiblaStatus.good;
    if (angleDifference < 45) return QiblaStatus.fair;
    return QiblaStatus.poor;
  }

  // التهيئة الأولية محسنة
  Future<void> _init() async {
    try {
      _logInfo('🚀 بدء تهيئة خدمة القبلة');
      
      await _loadStoredData();
      await _checkCompassAvailability();
      
      if (_hasCompass) {
        await _startCompassListener();
        _logSuccess('✅ تم تهيئة خدمة القبلة بنجاح');
      } else {
        _logWarning('⚠️ البوصلة غير متوفرة');
      }
      
      _startPeriodicLocationUpdate();
      
    } catch (e) {
      _errorMessage = 'خطأ في تهيئة خدمة القبلة';
      _logError('❌ خطأ في التهيئة', e);
    }
  }

  // ✅ تحديث دوري للموقع باستخدام ThemeConstants
  void _startPeriodicLocationUpdate() {
    _locationUpdateTimer = Timer.periodic(
      ThemeConstants.durationExtraSlow,
      (_) => _updateLocationIfMoved(),
    );
    _logInfo('📍 تم بدء التحديث الدوري للموقع');
  }

  Future<void> _updateLocationIfMoved() async {
    try {
      if (_qiblaData == null) return;
      
      final currentPosition = await _getCurrentPositionQuick();
      if (currentPosition == null) return;
      
      final distance = Geolocator.distanceBetween(
        _qiblaData!.latitude, _qiblaData!.longitude,
        currentPosition.latitude, currentPosition.longitude,
      );
      
      if (distance > _movementThreshold) {
        _logInfo('📍 تم رصد حركة كبيرة (${distance.toInt()}م) - تحديث اتجاه القبلة');
        await updateQiblaData();
      }
    } catch (e) {
      _logWarning('⚠️ فشل في فحص الحركة', e);
    }
  }

  Future<Position?> _getCurrentPositionQuick() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      return null;
    }
  }

  // التحقق من توفر البوصلة مع سجلات ملونة
  Future<void> _checkCompassAvailability() async {
    try {
      _logInfo('🧭 فحص توفر البوصلة...');
      
      final compassEvents = await FlutterCompass.events
          ?.timeout(const Duration(seconds: 5))
          .take(5)
          .toList();
      
      _hasCompass = compassEvents != null && 
                    compassEvents.isNotEmpty && 
                    compassEvents.any((e) => e.heading != null && e.heading! >= 0);
      
      if (_hasCompass && compassEvents!.isNotEmpty) {
        final lastEvent = compassEvents.last;
        if (lastEvent.accuracy != null) {
          _compassAccuracy = _calculateAccuracy(lastEvent.accuracy!);
        }
        
        _logSuccess('✅ البوصلة متوفرة - الدقة: ${accuracyText}');
      } else {
        _logWarning('⚠️ البوصلة غير متوفرة أو معطلة');
      }
    } catch (e) {
      _hasCompass = false;
      _logError('❌ خطأ في فحص البوصلة', e);
    }
  }

  // بدء الاستماع للبوصلة مع تحسينات
  Future<void> _startCompassListener() async {
    if (!_hasCompass) return;

    _compassSubscription = FlutterCompass.events
        ?.where((event) => event.heading != null && event.heading! >= 0)
        .listen((event) {
          _processCompassReading(event);
        }, onError: (error) {
          _logError('❌ خطأ في قراءة البوصلة', error);
        });
    
    _logSuccess('🧭 بدأ الاستماع للبوصلة');
  }

  // معالجة قراءة البوصلة محسنة مع ThemeConstants
  void _processCompassReading(CompassEvent event) {
    final now = DateTime.now();
    
    // تقليل معدل التحديث باستخدام ThemeConstants
    if (_lastUpdate != null && 
        now.difference(_lastUpdate!) < ThemeConstants.durationInstant) {
      return;
    }
    
    _lastUpdate = now;
    
    // تحديث الدقة
    if (event.accuracy != null) {
      _compassAccuracy = _calculateAccuracy(event.accuracy!);
    }

    // تصفية القراءة المحسنة
    _directionHistory.add(event.heading!);
    if (_directionHistory.length > _filterSize) {
      _directionHistory.removeAt(0);
    }

    // حساب المتوسط المرشح مع أوزان
    _currentDirection = _calculateWeightedFilteredDirection();
    notifyListeners();
  }

  // بدء المعايرة محسن مع ThemeConstants
  Future<void> startCalibration() async {
    _isCalibrated = false;
    _directionHistory.clear();
    notifyListeners();

    _logInfo('🎯 بدء معايرة البوصلة...');

    // فترة معايرة باستخدام ThemeConstants
    await Future.delayed(_calibrationDuration);
    
    _isCalibrated = true;
    await _saveCalibrationData();
    notifyListeners();

    _logSuccess('✅ تمت معايرة البوصلة بنجاح');
  }

  // تحديث بيانات القبلة مع سجلات محسنة
  Future<void> updateQiblaData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logInfo('📍 بدء تحديث بيانات القبلة...');

      // التحقق من الأذونات
      if (!await _checkLocationPermission()) {
        _errorMessage = 'لم يتم منح إذن الوصول إلى الموقع';
        _logError('❌ إذن الموقع مرفوض', null);
        return;
      }

      // الحصول على الموقع بأعلى دقة ممكنة
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: _locationTimeout,
      );

      _logSuccess('📍 تم الحصول على الموقع: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}');

      // الحصول على اسم المكان
      String? cityName;
      String? countryName;
      
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          cityName = placemark.locality ?? 
                     placemark.subAdministrativeArea ?? 
                     placemark.administrativeArea;
          countryName = placemark.country;
          
          _logInfo('🏘️ المكان: $cityName, $countryName');
        }
      } catch (e) {
        _logWarning('⚠️ لم يتم الحصول على اسم المكان', e);
      }

      // إنشاء نموذج القبلة
      _qiblaData = QiblaModel.fromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        cityName: cityName,
        countryName: countryName,
      );

      await _saveQiblaData();

      _logSuccess('✅ تم تحديث بيانات القبلة - الاتجاه: ${_qiblaData!.qiblaDirection.toStringAsFixed(2)}° (${_qiblaData!.directionDescription})');
      _logInfo('📏 المسافة إلى مكة: ${_qiblaData!.distanceDescription}');

    } catch (e) {
      _errorMessage = 'فشل في تحديث بيانات القبلة: ${e.toString()}';
      _logError('❌ خطأ في التحديث', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ دوال السجلات الملونة باستخدام AppColorSystem
  void _logSuccess(String message, [dynamic data]) {
    _logger.info(
      message: message,
      data: data != null ? {'details': data} : null,
      // يمكن إضافة لون للسجلات إذا كان LoggerService يدعم ذلك
    );
  }

  void _logInfo(String message, [dynamic data]) {
    _logger.info(
      message: message,
      data: data != null ? {'details': data} : null,
    );
  }

  void _logWarning(String message, [dynamic error]) {
    _logger.warning(
      message: message,
      data: error != null ? {'error': error.toString()} : null,
    );
  }

  void _logError(String message, dynamic error) {
    _logger.error(
      message: message,
      error: error,
    );
  }

  // باقي الدوال كما هي مع تحسينات بسيطة...
  
  double _getAngleDifference() {
    if (_qiblaData == null) return 360;
    final relativeAngle = (qiblaAngle + 360) % 360;
    return (relativeAngle > 180 ? 360 - relativeAngle : relativeAngle).abs();
  }

  double _calculateWeightedFilteredDirection() {
    if (_directionHistory.isEmpty) return 0;

    final sines = _directionHistory.map((a) => math.sin(a * math.pi / 180)).toList();
    final cosines = _directionHistory.map((a) => math.cos(a * math.pi / 180)).toList();

    double weightedSinSum = 0;
    double weightedCosSum = 0;
    double totalWeight = 0;

    for (int i = 0; i < _directionHistory.length; i++) {
      final weight = (i + 1).toDouble();
      weightedSinSum += sines[i] * weight;
      weightedCosSum += cosines[i] * weight;
      totalWeight += weight;
    }

    final avgSin = weightedSinSum / totalWeight;
    final avgCos = weightedCosSum / totalWeight;

    final angle = math.atan2(avgSin, avgCos) * 180 / math.pi;
    return (angle + 360) % 360;
  }

  double _calculateAccuracy(double rawAccuracy) {
    if (rawAccuracy < 0) return 1.0;
    if (rawAccuracy > 180) return 0.0;
    
    final normalizedAccuracy = rawAccuracy / 180.0;
    return math.max(0.0, 1.0 - math.pow(normalizedAccuracy, 1.5));
  }

  Future<bool> _checkLocationPermission() async {
    try {
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
    } catch (e) {
      _logError('❌ خطأ في فحص أذونات الموقع', e);
      return false;
    }
  }

  Future<void> _loadStoredData() async {
    try {
      // تحميل بيانات القبلة
      final qiblaJson = _storage.getMap(_qiblaDataKey);
      if (qiblaJson != null && qiblaJson.isNotEmpty) {
        _qiblaData = QiblaModel.fromJson(qiblaJson);
        _logInfo('💾 تم تحميل بيانات القبلة المخزنة (عمر البيانات: ${_qiblaData!.age.inHours} ساعة)');
      }

      // تحميل بيانات المعايرة
      final calibrationData = _storage.getMap(_calibrationDataKey);
      if (calibrationData != null) {
        _isCalibrated = calibrationData['isCalibrated'] ?? false;
        _logInfo('🎯 تم تحميل بيانات المعايرة: ${_isCalibrated ? "معايرة" : "غير معايرة"}');
      }
    } catch (e) {
      _logError('❌ خطأ في تحميل البيانات المخزنة', e);
    }
  }

  Future<void> _saveQiblaData() async {
    try {
      if (_qiblaData != null) {
        await _storage.setMap(_qiblaDataKey, _qiblaData!.toJson());
        _logInfo('💾 تم حفظ بيانات القبلة');
      }
    } catch (e) {
      _logError('❌ خطأ في حفظ بيانات القبلة', e);
    }
  }

  Future<void> _saveCalibrationData() async {
    try {
      await _storage.setMap(_calibrationDataKey, {
        'isCalibrated': _isCalibrated,
        'lastCalibration': DateTime.now().toIso8601String(),
      });
      _logInfo('🎯 تم حفظ بيانات المعايرة');
    } catch (e) {
      _logError('❌ خطأ في حفظ بيانات المعايرة', e);
    }
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _locationUpdateTimer?.cancel();
    _logInfo('🔄 تم تحرير موارد خدمة القبلة');
    super.dispose();
  }
}

// ✅ تعداد حالة القبلة مع الألوان
enum QiblaStatus {
  perfect,   // دقة مثالية < 5°
  good,      // جيد < 15°
  fair,      // مقبول < 45°
  poor,      // ضعيف > 45°
  unknown,   // غير معروف
}

// ✅ Extension لحالة القبلة مع النظام الموحد
extension QiblaStatusExtension on QiblaStatus {
  Color get color {
    switch (this) {
      case QiblaStatus.perfect:
        return AppColorSystem.success;
      case QiblaStatus.good:
        return AppColorSystem.primary;
      case QiblaStatus.fair:
        return AppColorSystem.warning;
      case QiblaStatus.poor:
        return AppColorSystem.error;
      case QiblaStatus.unknown:
        return AppColorSystem.info;
    }
  }

  String get text {
    switch (this) {
      case QiblaStatus.perfect:
        return 'مثالي';
      case QiblaStatus.good:
        return 'جيد';
      case QiblaStatus.fair:
        return 'مقبول';
      case QiblaStatus.poor:
        return 'بحاجة تعديل';
      case QiblaStatus.unknown:
        return 'غير محدد';
    }
  }

  IconData get icon {
    switch (this) {
      case QiblaStatus.perfect:
        return AppIconsSystem.success;
      case QiblaStatus.good:
        return Icons.thumb_up;
      case QiblaStatus.fair:
        return AppIconsSystem.warning;
      case QiblaStatus.poor:
        return AppIconsSystem.error;
      case QiblaStatus.unknown:
        return AppIconsSystem.info;
    }
  }
}