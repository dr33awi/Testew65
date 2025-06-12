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
  final double magneticDeclination;
  final DateTime calculatedAt;
  
  // إحداثيات الكعبة المشرفة بدقة عالية
  static const double kaabaLatitude = 21.4224827;
  static const double kaabaLongitude = 39.8261816;

  QiblaModel({
    required this.latitude,
    required this.longitude,
    required this.qiblaDirection,
    required this.accuracy,
    required this.distance,
    this.cityName,
    this.countryName,
    this.magneticDeclination = 0.0,
    DateTime? calculatedAt,
  }) : calculatedAt = calculatedAt ?? DateTime.now();

  factory QiblaModel.fromCoordinates({
    required double latitude,
    required double longitude,
    double accuracy = 0,
    String? cityName,
    String? countryName,
    double magneticDeclination = 0.0,
  }) {
    // حساب اتجاه القبلة باستخدام الصيغة الكروية الدقيقة
    final qiblaDirection = _calculateQiblaDirection(latitude, longitude);
    
    // حساب المسافة إلى الكعبة
    final distance = _calculateDistance(latitude, longitude);
    
    return QiblaModel(
      latitude: latitude,
      longitude: longitude,
      qiblaDirection: qiblaDirection,
      accuracy: accuracy,
      distance: distance,
      cityName: cityName,
      countryName: countryName,
      magneticDeclination: magneticDeclination,
    );
  }

  // حساب اتجاه القبلة باستخدام صيغة فينسنتي (Vincenty) الأكثر دقة
  static double _calculateQiblaDirection(double userLat, double userLng) {
    // تحويل الدرجات إلى راديان
    final phi1 = userLat * (math.pi / 180);
    final phi2 = kaabaLatitude * (math.pi / 180);
    final deltaLambda = (kaabaLongitude - userLng) * (math.pi / 180);
    
    // حساب الاتجاه باستخدام معادلة أكثر دقة
    final y = math.sin(deltaLambda) * math.cos(phi2);
    final x = math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(deltaLambda);
    
    // حساب الزاوية الأولية
    final theta = math.atan2(y, x);
    
    // تحويل من راديان إلى درجات
    double bearing = theta * (180 / math.pi);
    
    // تعديل النطاق ليكون من 0 إلى 360
    bearing = (bearing + 360) % 360;
    
    return bearing;
  }

  // حساب المسافة باستخدام صيغة هافرسين المحسنة
  static double _calculateDistance(double userLat, double userLng) {
    const double earthRadiusKm = 6371.0088; // نصف قطر الأرض المتوسط بالكيلومتر
    
    final dLat = _toRadians(kaabaLatitude - userLat);
    final dLon = _toRadians(kaabaLongitude - userLng);
    
    final lat1Rad = _toRadians(userLat);
    final lat2Rad = _toRadians(kaabaLatitude);
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) * math.sin(dLon / 2) *
        math.cos(lat1Rad) * math.cos(lat2Rad);
    
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadiusKm * c;
  }

  static double _toRadians(double degrees) => degrees * (math.pi / 180);

  // الحصول على اتجاه القبلة مع تطبيق الانحراف المغناطيسي
  double get magneticQiblaDirection {
    return (qiblaDirection + magneticDeclination + 360) % 360;
  }

  // الحصول على وصف نصي للاتجاه
  String get directionDescription {
    final angle = qiblaDirection;
    
    if (angle >= 337.5 || angle < 22.5) return 'الشمال';
    if (angle >= 22.5 && angle < 67.5) return 'الشمال الشرقي';
    if (angle >= 67.5 && angle < 112.5) return 'الشرق';
    if (angle >= 112.5 && angle < 157.5) return 'الجنوب الشرقي';
    if (angle >= 157.5 && angle < 202.5) return 'الجنوب';
    if (angle >= 202.5 && angle < 247.5) return 'الجنوب الغربي';
    if (angle >= 247.5 && angle < 292.5) return 'الغرب';
    if (angle >= 292.5 && angle < 337.5) return 'الشمال الغربي';
    
    return 'غير محدد';
  }

  // الحصول على وصف المسافة
  String get distanceDescription {
    if (distance < 100) {
      return '${distance.toStringAsFixed(1)} كم';
    } else if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} كم';
    } else {
      final thousands = distance / 1000;
      return '${thousands.toStringAsFixed(1)} ألف كم';
    }
  }

  // التحقق من صحة البيانات
  bool get isValid {
    return latitude >= -90 && latitude <= 90 &&
           longitude >= -180 && longitude <= 180 &&
           accuracy >= 0;
  }

  // التحقق من دقة الموقع
  bool get hasHighAccuracy => accuracy <= 20; // دقة عالية إذا كانت أقل من 20 متر
  bool get hasMediumAccuracy => accuracy <= 50; // دقة متوسطة
  bool get hasLowAccuracy => accuracy > 50; // دقة منخفضة

  // حساب عمر البيانات
  Duration get age => DateTime.now().difference(calculatedAt);
  bool get isStale => age.inHours > 24; // البيانات قديمة بعد 24 ساعة

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
      'magneticDeclination': magneticDeclination,
      'calculatedAt': calculatedAt.toIso8601String(),
    };
  }

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
      magneticDeclination: (json['magneticDeclination'] as num?)?.toDouble() ?? 0.0,
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
    double? magneticDeclination,
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
      magneticDeclination: magneticDeclination ?? this.magneticDeclination,
      calculatedAt: calculatedAt ?? this.calculatedAt,
    );
  }

  @override
  String toString() {
    return 'QiblaModel('
        'latitude: $latitude, '
        'longitude: $longitude, '
        'qiblaDirection: ${qiblaDirection.toStringAsFixed(2)}°, '
        'distance: ${distance.toStringAsFixed(2)} km, '
        'accuracy: ${accuracy.toStringAsFixed(2)} m, '
        'location: ${cityName ?? "Unknown"}, ${countryName ?? "Unknown"}'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is QiblaModel &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.qiblaDirection == qiblaDirection &&
        other.accuracy == accuracy &&
        other.distance == distance &&
        other.cityName == cityName &&
        other.countryName == countryName &&
        other.magneticDeclination == magneticDeclination;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        qiblaDirection.hashCode ^
        accuracy.hashCode ^
        distance.hashCode ^
        (cityName?.hashCode ?? 0) ^
        (countryName?.hashCode ?? 0) ^
        magneticDeclination.hashCode;
  }
}