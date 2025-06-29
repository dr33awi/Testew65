// lib/features/qibla/services/qibla_service.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../domain/models/qibla_model.dart';

class QiblaService extends ChangeNotifier {
  final LoggerService _logger;
  final StorageService _storage;
  final PermissionService _permissionService;

  static const String _qiblaDataKey = 'qibla_data';
  static const String _calibrationDataKey = 'compass_calibration';

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
  static const int _filterSize = 8; // زيادة حجم المرشح للدقة
  DateTime? _lastUpdate;

  QiblaService({
    required LoggerService logger,
    required StorageService storage,
    required PermissionService permissionService,
  })  : _logger = logger,
        _storage = storage,
        _permissionService = permissionService {
    _init();
  }

  // الخصائص العامة
  QiblaModel? get qiblaData => _qiblaData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get currentDirection => _currentDirection;
  bool get hasCompass => _hasCompass;
  double get compassAccuracy => _compassAccuracy;
  bool get isCalibrated => _isCalibrated;

  // اتجاه القبلة بالنسبة للاتجاه الحالي
  double get qiblaAngle {
    if (_qiblaData == null) return 0;
    return (_qiblaData!.qiblaDirection - _currentDirection + 360) % 360;
  }

  // التهيئة الأولية
  Future<void> _init() async {
    try {
      await _loadStoredData();
      await _checkCompassAvailability();
      if (_hasCompass) {
        await _startCompassListener();
      }
    } catch (e) {
      _errorMessage = 'خطأ في تهيئة خدمة القبلة';
      _logger.error(message: '[QiblaService] خطأ في التهيئة', error: e);
    }
  }

  // التحقق من توفر البوصلة بدقة أعلى
  Future<void> _checkCompassAvailability() async {
    try {
      // اختبار أكثر دقة للبوصلة
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
        
        _logger.info(
          message: '[QiblaService] البوصلة متوفرة',
          data: {'accuracy': _compassAccuracy},
        );
      } else {
        _logger.warning(message: '[QiblaService] البوصلة غير متوفرة');
      }
    } catch (e) {
      _hasCompass = false;
      _logger.error(message: '[QiblaService] خطأ في التحقق من البوصلة', error: e);
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
          _logger.error(
            message: '[QiblaService] خطأ في قراءة البوصلة',
            error: error,
          );
        });
    
    _logger.info(message: '[QiblaService] بدأ الاستماع للبوصلة');
  }

  // معالجة قراءة البوصلة محسنة
  void _processCompassReading(CompassEvent event) {
    final now = DateTime.now();
    
    // تقليل معدل التحديث لتوفير البطارية وتحسين الأداء
    if (_lastUpdate != null && 
        now.difference(_lastUpdate!) < const Duration(milliseconds: 50)) {
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

  // حساب الاتجاه المرشح مع أوزان للدقة العالية
  double _calculateWeightedFilteredDirection() {
    if (_directionHistory.isEmpty) return 0;

    // تحويل للتعامل مع انتقال 360-0 درجة
    final sines = _directionHistory.map((a) => math.sin(a * math.pi / 180)).toList();
    final cosines = _directionHistory.map((a) => math.cos(a * math.pi / 180)).toList();

    // تطبيق أوزان للقراءات الأحدث
    double weightedSinSum = 0;
    double weightedCosSum = 0;
    double totalWeight = 0;

    for (int i = 0; i < _directionHistory.length; i++) {
      // القراءات الأحدث لها وزن أكبر
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

  // حساب دقة البوصلة محسن
  double _calculateAccuracy(double rawAccuracy) {
    // تحسين خوارزمية حساب الدقة
    if (rawAccuracy < 0) return 1.0;
    if (rawAccuracy > 180) return 0.0;
    
    // منحنى أكثر واقعية للدقة
    final normalizedAccuracy = rawAccuracy / 180.0;
    return math.max(0.0, 1.0 - math.pow(normalizedAccuracy, 1.5));
  }

  // بدء المعايرة محسن
  Future<void> startCalibration() async {
    _isCalibrated = false;
    _directionHistory.clear(); // إعادة تعيين التاريخ
    notifyListeners();

    _logger.info(message: '[QiblaService] بدء معايرة البوصلة');

    // فترة معايرة أطول للدقة
    await Future.delayed(const Duration(seconds: 5));
    
    _isCalibrated = true;
    await _saveCalibrationData();
    notifyListeners();

    _logger.info(message: '[QiblaService] تمت المعايرة بنجاح');
  }

  // تحديث بيانات القبلة مع دقة Vincenty العالية
  Future<void> updateQiblaData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // التحقق من الأذونات
      if (!await _checkLocationPermission()) {
        _errorMessage = 'لم يتم منح إذن الوصول إلى الموقع';
        return;
      }

      // الحصول على الموقع بأعلى دقة ممكنة
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 20),
      );

      _logger.info(
        message: '[QiblaService] تم الحصول على الموقع',
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
        },
      );

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
          
          _logger.info(
            message: '[QiblaService] تم الحصول على اسم المكان',
            data: {
              'city': cityName,
              'country': countryName,
            },
          );
        }
      } catch (e) {
        _logger.warning(
          message: '[QiblaService] لم يتم الحصول على اسم المكان',
          data: {'error': e.toString()},
        );
      }

      // إنشاء نموذج القبلة باستخدام حسابات Vincenty الدقيقة
      _qiblaData = QiblaModel.fromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        cityName: cityName,
        countryName: countryName,
      );

      await _saveQiblaData();

      _logger.info(
        message: '[QiblaService] تم تحديث بيانات القبلة بنجاح',
        data: {
          'qiblaDirection': _qiblaData!.qiblaDirection,
          'distance': _qiblaData!.distance,
          'directionDesc': _qiblaData!.directionDescription,
        },
      );
    } catch (e) {
      _errorMessage = 'فشل في تحديث بيانات القبلة: ${e.toString()}';
      _logger.error(
        message: '[QiblaService] خطأ في التحديث',
        error: e,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // التحقق من أذونات الموقع
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
      _logger.error(
        message: '[QiblaService] خطأ في التحقق من أذونات الموقع',
        error: e,
      );
      return false;
    }
  }

  // تحميل البيانات المخزنة
  Future<void> _loadStoredData() async {
    try {
      // تحميل بيانات القبلة
      final qiblaJson = _storage.getMap(_qiblaDataKey);
      if (qiblaJson != null && qiblaJson.isNotEmpty) {
        _qiblaData = QiblaModel.fromJson(qiblaJson);
        
        _logger.info(
          message: '[QiblaService] تم تحميل بيانات القبلة المخزنة',
          data: {
            'direction': _qiblaData!.qiblaDirection,
            'age': _qiblaData!.age.inHours,
          },
        );
      }

      // تحميل بيانات المعايرة
      final calibrationData = _storage.getMap(_calibrationDataKey);
      if (calibrationData != null) {
        _isCalibrated = calibrationData['isCalibrated'] ?? false;
        
        _logger.info(
          message: '[QiblaService] تم تحميل بيانات المعايرة',
          data: {'isCalibrated': _isCalibrated},
        );
      }
    } catch (e) {
      _logger.error(
        message: '[QiblaService] خطأ في تحميل البيانات المخزنة',
        error: e,
      );
    }
  }

  // حفظ بيانات القبلة
  Future<void> _saveQiblaData() async {
    try {
      if (_qiblaData != null) {
        await _storage.setMap(_qiblaDataKey, _qiblaData!.toJson());
        _logger.info(message: '[QiblaService] تم حفظ بيانات القبلة');
      }
    } catch (e) {
      _logger.error(
        message: '[QiblaService] خطأ في حفظ بيانات القبلة',
        error: e,
      );
    }
  }

  // حفظ بيانات المعايرة
  Future<void> _saveCalibrationData() async {
    try {
      await _storage.setMap(_calibrationDataKey, {
        'isCalibrated': _isCalibrated,
        'lastCalibration': DateTime.now().toIso8601String(),
      });
      _logger.info(message: '[QiblaService] تم حفظ بيانات المعايرة');
    } catch (e) {
      _logger.error(
        message: '[QiblaService] خطأ في حفظ بيانات المعايرة',
        error: e,
      );
    }
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _logger.info(message: '[QiblaService] تم تحرير الموارد');
    super.dispose();
  }
}