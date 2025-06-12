// lib/features/qibla/services/qibla_service.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../domain/models/qibla_model.dart';

class QiblaService extends ChangeNotifier {
  final LoggerService _logger;
  final StorageService _storage;
  final PermissionService _permissionService;

  static const String _qiblaDataKey = 'qibla_data';
  static const String _lastUpdateKey = 'qibla_last_update';
  static const String _calibrationDataKey = 'compass_calibration';

  QiblaModel? _qiblaData;
  bool _isLoading = false;
  String? _errorMessage;
  
  // البوصلة والحساسات
  StreamSubscription<CompassEvent>? _compassSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  
  double _currentDirection = 0.0;
  double _filteredDirection = 0.0;
  bool _hasCompass = false;
  double _compassAccuracy = 0.0;
  
  // معايرة البوصلة
  double _magneticDeclination = 0.0;
  bool _isCalibrated = false;
  final List<double> _calibrationReadings = [];
  
  // تصفية القراءات
  static const int _filterSize = 10;
  final List<double> _directionHistory = [];
  final List<double> _magnetometerReadings = [];
  
  // معدل التحديث
  DateTime? _lastCompassUpdate;
  static const Duration _updateThreshold = Duration(milliseconds: 100);

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
  double get currentDirection => _filteredDirection;
  bool get hasCompass => _hasCompass;
  double get compassAccuracy => _compassAccuracy;
  bool get isCalibrated => _isCalibrated;
  
  // اتجاه القبلة بالنسبة للاتجاه الحالي (الزاوية المطلوبة للاستدارة)
  double get qiblaAngle {
    if (_qiblaData == null) return 0;
    
    // تطبيق الانحراف المغناطيسي على اتجاه القبلة
    final adjustedQiblaDirection = (_qiblaData!.qiblaDirection + _magneticDeclination + 360) % 360;
    return (adjustedQiblaDirection - _filteredDirection + 360) % 360;
  }
  
  // دقة البوصلة كنسبة مئوية
  double get accuracyPercentage {
    if (!_hasCompass) return 0;
    return math.min(_compassAccuracy * 100, 100);
  }

  // التهيئة الأولية
  Future<void> _init() async {
    try {
      // تحميل بيانات المعايرة المحفوظة
      await _loadCalibrationData();
      
      // التحقق من توفر البوصلة
      await _checkCompassAvailability();
      
      if (_hasCompass) {
        await _startSensorListeners();
      } else {
        _logger.warning(
          message: '[QiblaService] البوصلة غير متوفرة على هذا الجهاز',
        );
      }
      
      // محاولة استرجاع بيانات القبلة المخزنة
      await _loadStoredQiblaData();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تهيئة خدمة القبلة';
      _logger.error(
        message: '[QiblaService] خطأ في التهيئة',
        error: e,
      );
    }
  }

  // التحقق من توفر البوصلة بشكل أكثر دقة
  Future<void> _checkCompassAvailability() async {
    try {
      final compassEvents = await FlutterCompass.events?.take(3).toList();
      
      if (compassEvents != null && compassEvents.isNotEmpty) {
        _hasCompass = compassEvents.any((event) => event.heading != null);
        
        // حساب دقة البوصلة الأولية
        if (_hasCompass && compassEvents.last.accuracy != null) {
          _compassAccuracy = _calculateAccuracy(compassEvents.last.accuracy!);
        }
      }
    } catch (e) {
      _hasCompass = false;
      _logger.error(
        message: '[QiblaService] خطأ في التحقق من البوصلة',
        error: e,
      );
    }
  }

  // بدء الاستماع للحساسات المختلفة
  Future<void> _startSensorListeners() async {
    if (!_hasCompass) return;

    // الاستماع للبوصلة
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        _processCompassReading(event);
      }
    });

    // الاستماع لمقياس التسارع للكشف عن استقرار الجهاز
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      _processAccelerometerReading(event);
    });

    // الاستماع للمغناطيسية لتحسين الدقة
    _magnetometerSubscription = magnetometerEventStream().listen((event) {
      _processMagnetometerReading(event);
    });

    _logger.info(
      message: '[QiblaService] بدأ الاستماع لجميع الحساسات',
    );
  }

  // معالجة قراءة البوصلة مع التصفية المتقدمة
  void _processCompassReading(CompassEvent event) {
    final now = DateTime.now();
    
    // تقليل معدل التحديث لتوفير البطارية
    if (_lastCompassUpdate != null &&
        now.difference(_lastCompassUpdate!) < _updateThreshold) {
      return;
    }
    
    _lastCompassUpdate = now;
    _currentDirection = event.heading!;
    
    // حساب الدقة
    if (event.accuracy != null) {
      _compassAccuracy = _calculateAccuracy(event.accuracy!);
    }
    
    // إضافة القراءة للسجل
    _directionHistory.add(_currentDirection);
    if (_directionHistory.length > _filterSize) {
      _directionHistory.removeAt(0);
    }
    
    // تطبيق مرشح متوسط متحرك مع أوزان
    _filteredDirection = _applyWeightedMovingAverage(_directionHistory);
    
    // تحديث واجهة المستخدم
    notifyListeners();
  }

  // معالجة قراءات مقياس التسارع
  void _processAccelerometerReading(AccelerometerEvent event) {
    // يمكن استخدام هذه البيانات لتحديد ما إذا كان الجهاز مستقرًا
    final magnitude = math.sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z
    );
    
    // إذا كان الجهاز يتحرك بشدة، قلل من الثقة في القراءات
    if ((magnitude - 9.8).abs() > 2.0) {
      _compassAccuracy *= 0.8;
    }
  }

  // معالجة قراءات المغناطيسية
  void _processMagnetometerReading(MagnetometerEvent event) {
    _magnetometerReadings.add(
      math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z)
    );
    
    if (_magnetometerReadings.length > 20) {
      _magnetometerReadings.removeAt(0);
    }
    
    // كشف التشويش المغناطيسي
    if (_magnetometerReadings.length >= 20) {
      final stdDev = _calculateStandardDeviation(_magnetometerReadings);
      if (stdDev > 50) {
        _compassAccuracy *= 0.7; // تقليل الدقة في حالة التشويش
      }
    }
  }

  // تطبيق مرشح متوسط متحرك موزون
  double _applyWeightedMovingAverage(List<double> readings) {
    if (readings.isEmpty) return 0;
    
    // تحويل الزوايا للتعامل مع الانتقال من 359 إلى 0
    final sines = readings.map((angle) => math.sin(angle * math.pi / 180)).toList();
    final cosines = readings.map((angle) => math.cos(angle * math.pi / 180)).toList();
    
    // حساب الأوزان (القراءات الأحدث لها وزن أكبر)
    final weights = List.generate(readings.length, (i) => i + 1.0);
    final totalWeight = weights.reduce((a, b) => a + b);
    
    double weightedSinSum = 0;
    double weightedCosSum = 0;
    
    for (int i = 0; i < readings.length; i++) {
      weightedSinSum += sines[i] * weights[i] / totalWeight;
      weightedCosSum += cosines[i] * weights[i] / totalWeight;
    }
    
    // حساب الزاوية المرشحة
    double filteredAngle = math.atan2(weightedSinSum, weightedCosSum) * 180 / math.pi;
    
    return (filteredAngle + 360) % 360;
  }

  // حساب الانحراف المعياري
  double _calculateStandardDeviation(List<double> values) {
    if (values.isEmpty) return 0;
    
    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDifferences = values.map((v) => math.pow(v - mean, 2));
    final variance = squaredDifferences.reduce((a, b) => a + b) / values.length;
    
    return math.sqrt(variance);
  }

  // حساب دقة البوصلة
  double _calculateAccuracy(double rawAccuracy) {
    // تحويل القيمة الخام إلى نسبة من 0 إلى 1
    // القيم الأقل تعني دقة أفضل
    if (rawAccuracy < 0) return 1.0;
    if (rawAccuracy > 180) return 0.0;
    
    return 1.0 - (rawAccuracy / 180.0);
  }

  // بدء عملية المعايرة
  Future<void> startCalibration() async {
    _isCalibrated = false;
    _calibrationReadings.clear();
    notifyListeners();
    
    // جمع قراءات المعايرة لمدة 10 ثوان
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_calibrationReadings.length >= 50) {
        timer.cancel();
        _completeCalibration();
      } else {
        _calibrationReadings.add(_currentDirection);
      }
    });
  }

  // إكمال المعايرة
  void _completeCalibration() {
    if (_calibrationReadings.isEmpty) return;
    
    // حساب الانحراف المغناطيسي بناءً على القراءات
    // هذا مثال مبسط، في الواقع يجب استخدام بيانات الموقع الجغرافي
    _magneticDeclination = 0; // يمكن تحسين هذا بناءً على الموقع
    
    _isCalibrated = true;
    _saveCalibrationData();
    notifyListeners();
    
    _logger.info(
      message: '[QiblaService] تمت المعايرة بنجاح',
      data: {'readings': _calibrationReadings.length},
    );
  }

  // تحميل بيانات المعايرة
  Future<void> _loadCalibrationData() async {
    try {
      final calibrationData = _storage.getMap(_calibrationDataKey);
      if (calibrationData != null) {
        _magneticDeclination = calibrationData['declination'] ?? 0.0;
        _isCalibrated = calibrationData['isCalibrated'] ?? false;
      }
    } catch (e) {
      _logger.error(
        message: '[QiblaService] خطأ في تحميل بيانات المعايرة',
        error: e,
      );
    }
  }

  // حفظ بيانات المعايرة
  Future<void> _saveCalibrationData() async {
    await _storage.setMap(_calibrationDataKey, {
      'declination': _magneticDeclination,
      'isCalibrated': _isCalibrated,
      'lastCalibration': DateTime.now().toIso8601String(),
    });
  }

  // تحميل بيانات القبلة المخزنة
  Future<void> _loadStoredQiblaData() async {
    try {
      final qiblaJson = _storage.getMap(_qiblaDataKey);
      if (qiblaJson != null && qiblaJson.isNotEmpty) {
        _qiblaData = QiblaModel.fromJson(qiblaJson);
        
        _logger.info(
          message: '[QiblaService] تم تحميل بيانات القبلة المخزنة',
          data: {
            'direction': _qiblaData?.qiblaDirection,
            'distance': _qiblaData?.distance,
            'cityName': _qiblaData?.cityName,
          },
        );
      }
    } catch (e) {
      _logger.error(
        message: '[QiblaService] خطأ في تحميل بيانات القبلة المخزنة',
        error: e,
      );
    }
  }

  // تحديث بيانات القبلة مع تحسينات الدقة
  Future<void> updateQiblaData() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // التحقق من أذونات الموقع
      final hasPermission = await _checkLocationPermission();
      if (!hasPermission) {
        _errorMessage = 'لم يتم منح إذن الوصول إلى الموقع';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // الحصول على الموقع الحالي بدقة عالية
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 15),
      );

      // التحقق من دقة الموقع
      if (position.accuracy > 50) {
        _logger.warning(
          message: '[QiblaService] دقة الموقع منخفضة',
          data: {'accuracy': position.accuracy},
        );
      }

      // الحصول على اسم المدينة والدولة
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
        }
      } catch (e) {
        _logger.warning(
          message: '[QiblaService] لم يتم الحصول على اسم المدينة',
          data: {'error': e.toString()},
        );
      }

      // حساب اتجاه القبلة مع الدقة المحسنة
      final qiblaModel = QiblaModel.fromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        cityName: cityName,
        countryName: countryName,
        magneticDeclination: _magneticDeclination,
      );

      // حفظ البيانات
      _qiblaData = qiblaModel;
      await _saveQiblaData(qiblaModel);

      _logger.info(
        message: '[QiblaService] تم تحديث بيانات القبلة بنجاح',
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'qiblaDirection': qiblaModel.qiblaDirection,
          'distance': qiblaModel.distance,
          'cityName': cityName,
          'countryName': countryName,
          'accuracy': position.accuracy,
        },
      );
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تحديث بيانات القبلة';
      _logger.error(
        message: '[QiblaService] خطأ في تحديث بيانات القبلة',
        error: e,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // التحقق من أذونات الموقع
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

  // حفظ بيانات القبلة
  Future<void> _saveQiblaData(QiblaModel qiblaModel) async {
    await _storage.setMap(_qiblaDataKey, qiblaModel.toJson());
    await _storage.setString(
      _lastUpdateKey,
      DateTime.now().toIso8601String(),
    );
  }

  // إعادة تعيين المعايرة
  void resetCalibration() {
    _isCalibrated = false;
    _magneticDeclination = 0;
    _calibrationReadings.clear();
    _saveCalibrationData();
    notifyListeners();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _magnetometerSubscription?.cancel();
    super.dispose();
  }
}