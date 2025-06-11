// 2. تحسين خدمة القبلة - lib/features/qibla/services/qibla_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import 'package:athkar_app/features/qibla/domain/models/qibla_model.dart';

class QiblaService extends ChangeNotifier {
  final LoggerService _logger;
  final StorageService _storage;
  final PermissionService _permissionService;

  static const String _qiblaDataKey = 'qibla_data';
  static const String _lastUpdateKey = 'qibla_last_update';

  QiblaModel? _qiblaData;
  bool _isLoading = false;
  String? _errorMessage;
  
  StreamSubscription<CompassEvent>? _compassSubscription;
  double _currentDirection = 0.0;
  bool _hasCompass = false;

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
  
  // اتجاه القبلة بالنسبة للاتجاه الحالي (الزاوية المطلوبة للاستدارة)
  double get qiblaAngle {
    if (_qiblaData == null) return 0;
    return (_qiblaData!.qiblaDirection - _currentDirection + 360) % 360;
  }

  // التهيئة الأولية
  Future<void> _init() async {
    try {
      // التحقق من توفر البوصلة
      _hasCompass = await FlutterCompass.events?.first != null;
      
      if (_hasCompass) {
        _startCompassListener();
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

  // البدء في الاستماع لتغيرات البوصلة
  void _startCompassListener() {
    if (!_hasCompass) return;

    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        _currentDirection = event.heading!;
        notifyListeners();
      }
    });

    _logger.info(
      message: '[QiblaService] بدأ الاستماع لتغيرات البوصلة',
    );
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

  // تحديث بيانات القبلة
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

      // الحصول على الموقع الحالي
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

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

      // حساب اتجاه القبلة
      final qiblaModel = QiblaModel.fromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        cityName: cityName,
        countryName: countryName,
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

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }
}
