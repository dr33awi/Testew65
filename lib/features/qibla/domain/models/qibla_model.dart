// lib/features/qibla/domain/models/qibla_model.dart
import 'dart:math' as math;

class QiblaModel {
  final double latitude;
  final double longitude;
  final double qiblaDirection;
  final double accuracy;
  final double distance;
  final String? cityName;
  final String? countryName;
  final DateTime calculatedAt;

  // إحداثيات الكعبة المشرفة بدقة عالية
  static const double kaabaLatitude = 21.4224827;
  static const double kaabaLongitude = 39.8261816;

  const QiblaModel({
    required this.latitude,
    required this.longitude,
    required this.qiblaDirection,
    required this.accuracy,
    required this.distance,
    this.cityName,
    this.countryName,
    required this.calculatedAt,
  });

  factory QiblaModel.fromCoordinates({
    required double latitude,
    required double longitude,
    double accuracy = 0,
    String? cityName,
    String? countryName,
  }) {
    return QiblaModel(
      latitude: latitude,
      longitude: longitude,
      qiblaDirection: _calculateQiblaDirection(latitude, longitude),
      accuracy: accuracy,
      distance: _calculateDistance(latitude, longitude),
      cityName: cityName,
      countryName: countryName,
      calculatedAt: DateTime.now(),
    );
  }

  // حساب اتجاه القبلة باستخدام الصيغة الكروية
  static double _calculateQiblaDirection(double userLat, double userLng) {
    final phi1 = _toRadians(userLat);
    final phi2 = _toRadians(kaabaLatitude);
    final deltaLambda = _toRadians(kaabaLongitude - userLng);

    final y = math.sin(deltaLambda) * math.cos(phi2);
    final x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);

    final theta = math.atan2(y, x);
    return (_toDegrees(theta) + 360) % 360;
  }

  // حساب المسافة باستخدام صيغة هافرسين
  static double _calculateDistance(double userLat, double userLng) {
    const double earthRadiusKm = 6371.0088;

    final dLat = _toRadians(kaabaLatitude - userLat);
    final dLon = _toRadians(kaabaLongitude - userLng);
    final lat1Rad = _toRadians(userLat);
    final lat2Rad = _toRadians(kaabaLatitude);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(lat1Rad) * math.cos(lat2Rad);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _toRadians(double degrees) => degrees * (math.pi / 180);
  static double _toDegrees(double radians) => radians * (180 / math.pi);

  // الحصول على وصف نصي للاتجاه
  String get directionDescription {
    if (qiblaDirection >= 337.5 || qiblaDirection < 22.5) return 'الشمال';
    if (qiblaDirection >= 22.5 && qiblaDirection < 67.5) return 'الشمال الشرقي';
    if (qiblaDirection >= 67.5 && qiblaDirection < 112.5) return 'الشرق';
    if (qiblaDirection >= 112.5 && qiblaDirection < 157.5) return 'الجنوب الشرقي';
    if (qiblaDirection >= 157.5 && qiblaDirection < 202.5) return 'الجنوب';
    if (qiblaDirection >= 202.5 && qiblaDirection < 247.5) return 'الجنوب الغربي';
    if (qiblaDirection >= 247.5 && qiblaDirection < 292.5) return 'الغرب';
    return 'الشمال الغربي';
  }

  // الحصول على وصف المسافة
  String get distanceDescription {
    if (distance < 100) return '${distance.toStringAsFixed(1)} كم';
    if (distance < 1000) return '${distance.toStringAsFixed(0)} كم';
    final thousands = distance / 1000;
    return '${thousands.toStringAsFixed(1)} ألف كم';
  }

  // التحقق من صحة البيانات
  bool get isValid =>
      latitude >= -90 && latitude <= 90 &&
      longitude >= -180 && longitude <= 180 &&
      accuracy >= 0;

  // التحقق من دقة الموقع
  bool get hasHighAccuracy => accuracy <= 20;
  bool get hasMediumAccuracy => accuracy <= 50;
  bool get hasLowAccuracy => accuracy > 50;

  // حساب عمر البيانات
  Duration get age => DateTime.now().difference(calculatedAt);
  bool get isStale => age.inHours > 24;

  // تحويل البيانات إلى JSON
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'qiblaDirection': qiblaDirection,
    'accuracy': accuracy,
    'distance': distance,
    'cityName': cityName,
    'countryName': countryName,
    'calculatedAt': calculatedAt.toIso8601String(),
  };

  // إنشاء نموذج من JSON
  factory QiblaModel.fromJson(Map<String, dynamic> json) {
    return QiblaModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      qiblaDirection: (json['qiblaDirection'] as num?)?.toDouble() ?? 0.0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      cityName: json['cityName'] as String?,
      countryName: json['countryName'] as String?,
      calculatedAt: json['calculatedAt'] != null
          ? DateTime.parse(json['calculatedAt'] as String)
          : DateTime.now(),
    );
  }

  // نسخة محدثة من البيانات
  QiblaModel copyWith({
    double? latitude,
    double? longitude,
    double? qiblaDirection,
    double? accuracy,
    double? distance,
    String? cityName,
    String? countryName,
    DateTime? calculatedAt,
  }) {
    return QiblaModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      qiblaDirection: qiblaDirection ?? this.qiblaDirection,
      accuracy: accuracy ?? this.accuracy,
      distance: distance ?? this.distance,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      calculatedAt: calculatedAt ?? this.calculatedAt,
    );
  }

  @override
  String toString() => 'QiblaModel('
      'lat: $latitude, '
      'lng: $longitude, '
      'direction: ${qiblaDirection.toStringAsFixed(2)}°, '
      'distance: ${distance.toStringAsFixed(2)} km'
      ')';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QiblaModel &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.qiblaDirection == qiblaDirection;

  @override
  int get hashCode => Object.hash(latitude, longitude, qiblaDirection);
}