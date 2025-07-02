// lib/features/qibla/widgets/qibla_widgets.dart - مكونات متخصصة بالنظام الموحد
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../domain/models/qibla_model.dart';
import '../services/qibla_service.dart';

/// مجموعة مكونات القبلة المتخصصة باستخدام النظام الموحد
class QiblaWidgets {
  QiblaWidgets._();

  /// بطاقة معلومات القبلة الشاملة
  static Widget buildQiblaInfoCard(QiblaModel qiblaData, double currentDirection, [BuildContext? context]) {
    final angleDifference = ((qiblaData.qiblaDirection - currentDirection + 360) % 360);
    final normalizedAngle = angleDifference > 180 ? 360 - angleDifference : angleDifference;
    
    return AppCard.custom(
      type: CardType.info,
      style: CardStyle.glassmorphism,
      title: 'معلومات اتجاه القبلة',
      subtitle: 'من موقعك الحالي إلى الكعبة المشرفة',
      icon: AppIconsSystem.qibla,
      primaryColor: AppColorSystem.getCategoryColor('qibla'),
      gradientColors: [
        AppColorSystem.getCategoryColor('qibla'),
        AppColorSystem.getCategoryColor('qibla').darken(0.2),
      ],
      child: Column(
        children: [
          const SizedBox(height: ThemeConstants.space4),
          
          // معلومات الاتجاه
          _buildInfoRow(
            'الاتجاه من الشمال',
            '${qiblaData.qiblaDirection.toStringAsFixed(1)}°',
            Icons.navigation,
            AppColorSystem.getCategoryColor('qibla'),
            context,
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // المسافة
          _buildInfoRow(
            'المسافة إلى مكة',
            qiblaData.distanceDescription,
            Icons.straighten,
            AppColorSystem.info,
            context,
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // الاتجاه النسبي
          _buildInfoRow(
            'الاتجاه النسبي',
            '${normalizedAngle.toStringAsFixed(1)}° ${_getDirectionSide(angleDifference)}',
            Icons.compass_calibration,
            normalizedAngle < 15 ? AppColorSystem.success : AppColorSystem.warning,
            context,
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // الوصف
          _buildInfoRow(
            'الاتجاه العام',
            qiblaData.directionDescription,
            Icons.explore,
            AppColorSystem.tertiary,
            context,
          ),
        ],
      ),
    );
  }

  /// بطاقة حالة البوصلة
  static Widget buildCompassStatusCard(QiblaService service) {
    return AppCard.custom(
      type: CardType.info,
      style: CardStyle.normal,
      title: service.isCalibrated ? 'البوصلة معايرة' : 'البوصلة تحتاج معايرة',
      subtitle: 'دقة البوصلة: ${service.accuracyText}',
      icon: service.isCalibrated ? AppIconsSystem.success : AppIconsSystem.warning,
      primaryColor: service.accuracyColor,
      child: Column(
        children: [
          const SizedBox(height: ThemeConstants.space3),
          
          // مؤشر الدقة البصري
          _buildAccuracyIndicator(service.compassAccuracy),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // معلومات إضافية
          Row(
            children: [
              Icon(
                service.accuracyIcon,
                color: service.accuracyColor,
                size: ThemeConstants.iconSm,
              ),
              const SizedBox(width: ThemeConstants.space2),
              Expanded(
                child: Text(
                  _getAccuracyDescription(service.compassAccuracy),
                  style: AppTextStyles.caption.copyWith(
                    color: service.accuracyColor,
                  ),
                ),
              ),
            ],
          ),
          
          // زر المعايرة
          if (!service.isCalibrated) ...[
            const SizedBox(height: ThemeConstants.space4),
            AppButton.outline(
              text: 'معايرة البوصلة',
              onPressed: service.startCalibration,
              color: AppColorSystem.warning,
            ),
          ],
        ],
      ),
    );
  }

  /// بطاقة معلومات الموقع
  static Widget buildLocationCard(QiblaModel qiblaData, [BuildContext? context]) {
    return AppCard.custom(
      type: CardType.info,
      style: CardStyle.normal,
      title: qiblaData.cityName ?? 'موقعك الحالي',
      subtitle: qiblaData.countryName ?? 'الموقع محدد بنجاح',
      icon: AppIconsSystem.location,
      primaryColor: AppColorSystem.getCategoryColor('qibla'),
      child: Column(
        children: [
          const SizedBox(height: ThemeConstants.space3),
          
          // الإحداثيات
          _buildCoordinateRow(
            'خط العرض',
            qiblaData.latitude.toStringAsFixed(6),
            Icons.horizontal_rule,
            context,
          ),
          
          const SizedBox(height: ThemeConstants.space2),
          
          _buildCoordinateRow(
            'خط الطول',
            qiblaData.longitude.toStringAsFixed(6),
            Icons.more_vert,
            context,
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // دقة الموقع
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              color: _getLocationAccuracyColor(qiblaData.accuracy).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              border: Border.all(
                color: _getLocationAccuracyColor(qiblaData.accuracy).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getLocationAccuracyIcon(qiblaData.accuracy),
                  color: _getLocationAccuracyColor(qiblaData.accuracy),
                  size: ThemeConstants.iconSm,
                ),
                const SizedBox(width: ThemeConstants.space2),
                Text(
                  'دقة الموقع: ±${qiblaData.accuracy.toStringAsFixed(0)} متر',
                  style: AppTextStyles.caption.copyWith(
                    color: _getLocationAccuracyColor(qiblaData.accuracy),
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// بطاقة حالة القبلة
  static Widget buildQiblaStatusCard(QiblaService service) {
    final status = service.qiblaStatus;
    
    return AppCard.custom(
      type: CardType.info,
      style: CardStyle.glassmorphism,
      title: 'حالة التوجه للقبلة',
      subtitle: _getStatusMessage(status),
      icon: status.icon,
      primaryColor: status.color,
      gradientColors: [
        status.color,
        status.color.darken(0.1),
      ],
      child: Column(
        children: [
          const SizedBox(height: ThemeConstants.space4),
          
          // مؤشر الحالة الكبير
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: status.color,
                width: 3,
              ),
            ),
            child: Icon(
              status.icon,
              color: status.color,
              size: 40,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // نص الحالة
          Text(
            status.text,
            style: AppTextStyles.h5.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space2),
          
          // وصف الحالة
          Text(
            _getStatusDescription(status),
            style: AppTextStyles.body2.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// بطاقة معلومات مكة المكرمة
  static Widget buildMeccaInfoCard() {
    return AppCard.custom(
      type: CardType.quote,
      style: CardStyle.gradient,
      primaryColor: AppColorSystem.getCategoryColor('qibla'),
      gradientColors: [
        AppColorSystem.getCategoryColor('qibla'),
        AppColorSystem.tertiary,
      ],
      child: Column(
        children: [
          // الأيقونة
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: Icon(
              AppIconsSystem.qibla,
              color: Colors.white,
              size: 30,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // العنوان
          Text(
            'مكة المكرمة',
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space2),
          
          // الوصف
          Text(
            'قبلة المسلمين في جميع أنحاء العالم',
            style: AppTextStyles.body2.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // معلومات الكعبة
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'إحداثيات الكعبة المشرفة',
                  style: AppTextStyles.label1.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
                const SizedBox(height: ThemeConstants.space2),
                Text(
                  '${QiblaModel.kaabaLatitude.toStringAsFixed(6)}°, ${QiblaModel.kaabaLongitude.toStringAsFixed(6)}°',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// نصائح الاستخدام
  static Widget buildUsageTipsCard([BuildContext? context]) {
    return AppCard.custom(
      type: CardType.info,
      style: CardStyle.normal,
      title: 'نصائح للحصول على أفضل النتائج',
      subtitle: 'اتبع هذه الإرشادات لضمان الدقة',
      icon: AppIconsSystem.info,
      primaryColor: AppColorSystem.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: ThemeConstants.space4),
          
          _buildTipItem(
            '📱',
            'امسك الهاتف بشكل مسطح',
            'تأكد من أن الهاتف في وضع أفقي',
          ),
          
          _buildTipItem(
            '🧭',
            'ابتعد عن المجالات المغناطيسية',
            'تجنب الأجهزة الإلكترونية والمعادن',
          ),
          
          _buildTipItem(
            '🎯',
            'قم بمعايرة البوصلة',
            'حرك الهاتف على شكل الرقم 8 في الهواء',
          ),
          
          _buildTipItem(
            '📍',
            'تأكد من دقة الموقع',
            'فعل خدمة الموقع واستخدم GPS',
          ),
        ],
      ),
    );
  }

  // ===== دوال مساعدة =====

  static Widget _buildInfoRow(String label, String value, IconData icon, Color color, [BuildContext? context]) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: ThemeConstants.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColorSystem.getTextSecondary(null!),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildCoordinateRow(String label, String value, IconData icon, [BuildContext? context]) {
    return Row(
      children: [
        Icon(icon, color: AppColorSystem.getCategoryColor('qibla'), size: 16),
        const SizedBox(width: ThemeConstants.space2),
        Text(
          '$label: ',
          style: AppTextStyles.caption.copyWith(
            color: context != null ? AppColorSystem.getTextSecondary(context) : Colors.grey,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            fontWeight: ThemeConstants.semiBold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  static Widget _buildAccuracyIndicator(double accuracy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'دقة البوصلة',
              style: AppTextStyles.caption,
            ),
            Text(
              '${(accuracy * 100).toStringAsFixed(0)}%',
              style: AppTextStyles.caption.copyWith(
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ],
        ),
        const SizedBox(height: ThemeConstants.space2),
        LinearProgressIndicator(
          value: accuracy,
          backgroundColor: AppColorSystem.error.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            accuracy >= 0.8 ? AppColorSystem.success :
            accuracy >= 0.5 ? AppColorSystem.warning : AppColorSystem.error,
          ),
          minHeight: 6,
        ),
      ],
    );
  }

  static Widget _buildTipItem(String emoji, String title, String description, [BuildContext? context]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: ThemeConstants.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
                const SizedBox(height: ThemeConstants.space1),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: context != null ? AppColorSystem.getTextSecondary(context) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== دوال المساعدة للحصول على القيم =====

  static String _getDirectionSide(double angle) {
    if (angle <= 180) return 'يميناً';
    return 'يساراً';
  }

  static String _getAccuracyDescription(double accuracy) {
    if (accuracy >= 0.8) return 'دقة ممتازة - النتائج موثوقة';
    if (accuracy >= 0.5) return 'دقة مقبولة - نتائج جيدة';
    return 'دقة منخفضة - قم بالمعايرة';
  }

  static Color _getLocationAccuracyColor(double accuracy) {
    if (accuracy <= 10) return AppColorSystem.success;
    if (accuracy <= 30) return AppColorSystem.warning;
    return AppColorSystem.error;
  }

  static IconData _getLocationAccuracyIcon(double accuracy) {
    if (accuracy <= 10) return Icons.gps_fixed;
    if (accuracy <= 30) return Icons.gps_not_fixed;
    return Icons.gps_off;
  }

  static String _getStatusMessage(QiblaStatus status) {
    switch (status) {
      case QiblaStatus.perfect:
        return 'أنت متوجه نحو القبلة بدقة ممتازة!';
      case QiblaStatus.good:
        return 'قريب جداً من الاتجاه الصحيح';
      case QiblaStatus.fair:
        return 'في الاتجاه الصحيح، اضبط قليلاً';
      case QiblaStatus.poor:
        return 'ابحث عن الاتجاه الصحيح';
      case QiblaStatus.unknown:
        return 'جاري تحديد الاتجاه...';
    }
  }

  static String _getStatusDescription(QiblaStatus status) {
    switch (status) {
      case QiblaStatus.perfect:
        return 'الانحراف أقل من 5 درجات - ممتاز!';
      case QiblaStatus.good:
        return 'الانحراف أقل من 15 درجة - جيد جداً';
      case QiblaStatus.fair:
        return 'الانحراف أقل من 45 درجة - مقبول';
      case QiblaStatus.poor:
        return 'الانحراف أكبر من 45 درجة';
      case QiblaStatus.unknown:
        return 'يرجى الانتظار حتى يتم تحديد الموقع';
    }
  }
}