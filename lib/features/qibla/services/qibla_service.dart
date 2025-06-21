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

  // تصفية القراءات
  final List<double> _directionHistory = [];
  static const int _filterSize = 5;
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

  // التحقق من توفر البوصلة
  Future<void> _checkCompassAvailability() async {
    try {
      final compassEvents = await FlutterCompass.events?.take(3).toList();
      _hasCompass = compassEvents != null && 
                    compassEvents.isNotEmpty && 
                    compassEvents.any((e) => e.heading != null);
      
      if (_hasCompass && compassEvents!.last.accuracy != null) {
        _compassAccuracy = _calculateAccuracy(compassEvents.last.accuracy!);
      }
    } catch (e) {
      _hasCompass = false;
      _logger.error(message: '[QiblaService] خطأ في التحقق من البوصلة', error: e);
    }
  }

  // بدء الاستماع للبوصلة
  Future<void> _startCompassListener() async {
    if (!_hasCompass) return;

    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        _processCompassReading(event);
      }
    });
  }

  // معالجة قراءة البوصلة
  void _processCompassReading(CompassEvent event) {
    final now = DateTime.now();
    
    // تقليل معدل التحديث
    if (_lastUpdate != null && 
        now.difference(_lastUpdate!) < const Duration(milliseconds: 100)) {
      return;
    }
    
    _lastUpdate = now;
    
    // تحديث الدقة
    if (event.accuracy != null) {
      _compassAccuracy = _calculateAccuracy(event.accuracy!);
    }

    // تصفية القراءة
    _directionHistory.add(event.heading!);
    if (_directionHistory.length > _filterSize) {
      _directionHistory.removeAt(0);
    }

    // حساب المتوسط المرشح
    _currentDirection = _calculateFilteredDirection();
    notifyListeners();
  }

  // حساب الاتجاه المرشح
  double _calculateFilteredDirection() {
    if (_directionHistory.isEmpty) return 0;

    // تحويل للتعامل مع انتقال 360-0
    final sines = _directionHistory.map((a) => math.sin(a * math.pi / 180));
    final cosines = _directionHistory.map((a) => math.cos(a * math.pi / 180));

    final avgSin = sines.reduce((a, b) => a + b) / _directionHistory.length;
    final avgCos = cosines.reduce((a, b) => a + b) / _directionHistory.length;

    final angle = math.atan2(avgSin, avgCos) * 180 / math.pi;
    return (angle + 360) % 360;
  }

  // حساب دقة البوصلة
  double _calculateAccuracy(double rawAccuracy) {
    if (rawAccuracy < 0) return 1.0;
    if (rawAccuracy > 180) return 0.0;
    return 1.0 - (rawAccuracy / 180.0);
  }

  // بدء المعايرة
  Future<void> startCalibration() async {
    _isCalibrated = false;
    notifyListeners();

    // محاكاة عملية المعايرة
    await Future.delayed(const Duration(seconds: 3));
    
    _isCalibrated = true;
    await _saveCalibrationData();
    notifyListeners();
  }

  // تحديث بيانات القبلة
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

      // الحصول على الموقع
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
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
          cityName = placemark.locality ?? placemark.administrativeArea;
          countryName = placemark.country;
        }
      } catch (e) {
        _logger.warning(message: '[QiblaService] لم يتم الحصول على اسم المكان');
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

      _logger.info(
        message: '[QiblaService] تم تحديث بيانات القبلة',
        data: {
          'direction': _qiblaData!.qiblaDirection,
          'distance': _qiblaData!.distance,
        },
      );
    } catch (e) {
      _errorMessage = 'فشل في تحديث بيانات القبلة';
      _logger.error(message: '[QiblaService] خطأ في التحديث', error: e);
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

  // تحميل البيانات المخزنة
  Future<void> _loadStoredData() async {
    try {
      // تحميل بيانات القبلة
      final qiblaJson = _storage.getMap(_qiblaDataKey);
      if (qiblaJson != null) {
        _qiblaData = QiblaModel.fromJson(qiblaJson);
      }

      // تحميل بيانات المعايرة
      final calibrationData = _storage.getMap(_calibrationDataKey);
      if (calibrationData != null) {
        _isCalibrated = calibrationData['isCalibrated'] ?? false;
      }
    } catch (e) {
      _logger.error(message: '[QiblaService] خطأ في تحميل البيانات', error: e);
    }
  }

  // حفظ بيانات القبلة
  Future<void> _saveQiblaData() async {
    if (_qiblaData != null) {
      await _storage.setMap(_qiblaDataKey, _qiblaData!.toJson());
    }
  }

  // حفظ بيانات المعايرة
  Future<void> _saveCalibrationData() async {
    await _storage.setMap(_calibrationDataKey, {
      'isCalibrated': _isCalibrated,
      'lastCalibration': DateTime.now().toIso8601String(),
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }
}