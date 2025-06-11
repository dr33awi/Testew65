// 1. تحسين نموذج القبلة - lib/features/qibla/models/qibla_model.dart
import 'dart:math' as math;

class QiblaModel {
  final double latitude;
  final double longitude;
  final double qiblaDirection;
  final double accuracy;
  final double distance;
  final String? cityName;
  final String? countryName;

  QiblaModel({
    required this.latitude,
    required this.longitude,
    required this.qiblaDirection,
    required this.accuracy,
    required this.distance,
    this.cityName,
    this.countryName,
  });

  factory QiblaModel.fromCoordinates({
    required double latitude,
    required double longitude,
    double accuracy = 0,
    String? cityName,
    String? countryName,
  }) {
    // موقع الكعبة المشرفة - استخدام إحداثيات دقيقة
    const kaabaLatitude = 21.422487;
    const kaabaLongitude = 39.826206;

    // تحويل للراديان
    final userLat = latitude * (math.pi / 180);
    final userLng = longitude * (math.pi / 180);
    final kaabaLat = kaabaLatitude * (math.pi / 180);
    final kaabaLng = kaabaLongitude * (math.pi / 180);

    // حساب اتجاه القبلة باستخدام معادلة عالية الدقة
    final y = math.sin(kaabaLng - userLng);
    final x = math.cos(userLat) * math.tan(kaabaLat) -
        math.sin(userLat) * math.cos(kaabaLng - userLng);

    double qiblaDirection = math.atan2(y, x) * (180 / math.pi);
    qiblaDirection = (qiblaDirection + 360) % 360;

    // حساب المسافة باستخدام صيغة هافرسين
    final dLat = kaabaLat - userLat;
    final dLon = kaabaLng - userLng;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(userLat) * math.cos(kaabaLat) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distance = 6371 * c; // نصف قطر الأرض بالكيلومتر

    return QiblaModel(
      latitude: latitude,
      longitude: longitude,
      qiblaDirection: qiblaDirection,
      accuracy: accuracy,
      distance: distance,
      cityName: cityName,
      countryName: countryName,
    );
  }

  // تحويل البيانات إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'qiblaDirection': qiblaDirection,
      'accuracy': accuracy,
      'distance': distance,
      'cityName': cityName,
      'countryName': countryName,
    };
  }

  // إنشاء نموذج من JSON
  factory QiblaModel.fromJson(Map<String, dynamic> json) {
    return QiblaModel(
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      qiblaDirection: json['qiblaDirection'] ?? 0.0,
      accuracy: json['accuracy'] ?? 0.0,
      distance: json['distance'] ?? 0.0,
      cityName: json['cityName'],
      countryName: json['countryName'],
    );
  }
}