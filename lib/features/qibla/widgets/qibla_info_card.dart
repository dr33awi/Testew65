// lib/features/qibla/widgets/qibla_info_card.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../domain/models/qibla_model.dart';

class QiblaInfoCard extends StatelessWidget {
  final QiblaModel qiblaData;

  const QiblaInfoCard({
    super.key,
    required this.qiblaData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          colors: [
            ThemeConstants.primary.withValues(alpha: 0.05),
            ThemeConstants.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // رأس البطاقة
          _buildLocationHeader(context),
          
          // معلومات القبلة
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Column(
              children: [
                _buildPrimaryInfo(context),
                SizedBox(height: ThemeConstants.space4),
                _buildDetailedInfo(context),
                if (qiblaData.isStale) _buildStaleDataWarning(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeConstants.primary.withValues(alpha: 0.1),
            ThemeConstants.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radius2xl),
        ),
      ),
      child: Row(
        children: [
          // أيقونة الموقع
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ThemeConstants.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: ThemeConstants.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.location_on,
              color: ThemeConstants.primary,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          SizedBox(width: ThemeConstants.space3),
          
          // معلومات الموقع
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'موقعك الحالي',
                  style: context.labelLarge?.copyWith(
                    color: context.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ThemeConstants.space1),
                Text(
                  _getLocationName(),
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ThemeConstants.space1),
                // دقة الموقع
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getAccuracyColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.my_location,
                        size: 12,
                        color: _getAccuracyColor(),
                      ),
                      SizedBox(width: 4),
                      Text(
                        _getAccuracyText(),
                        style: context.labelSmall?.copyWith(
                          color: _getAccuracyColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryInfo(BuildContext context) {
    return Row(
      children: [
        // اتجاه القبلة
        Expanded(
          child: _buildInfoTile(
            context: context,
            icon: Icons.navigation_outlined,
            title: 'اتجاه القبلة',
            value: '${qiblaData.qiblaDirection.toStringAsFixed(1)}°',
            subtitle: qiblaData.directionDescription,
            color: ThemeConstants.primary,
          ),
        ),
        
        // فاصل
        Container(
          width: 1,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space3),
          color: context.dividerColor.withValues(alpha: 0.3),
        ),
        
        // المسافة للكعبة
        Expanded(
          child: _buildInfoTile(
            context: context,
            icon: Icons.straighten,
            title: 'المسافة للكعبة',
            value: qiblaData.distanceDescription,
            subtitle: 'خط مستقيم',
            color: ThemeConstants.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // الأيقونة
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          
          SizedBox(height: ThemeConstants.space2),
          
          // العنوان
          Text(
            title,
            style: context.labelMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: ThemeConstants.space1),
          
          // القيمة
          Text(
            value,
            style: context.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          // الوصف
          Text(
            subtitle,
            style: context.labelSmall?.copyWith(
              color: context.textSecondaryColor.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان التفاصيل
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: ThemeConstants.info.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: ThemeConstants.info,
                  size: 16,
                ),
              ),
              SizedBox(width: ThemeConstants.space2),
              Text(
                'تفاصيل الموقع',
                style: context.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          SizedBox(height: ThemeConstants.space3),
          
          // الإحداثيات والتفاصيل
          _buildDetailRow(
            context: context,
            label: 'خط العرض',
            value: '${qiblaData.latitude.toStringAsFixed(6)}°',
            icon: Icons.horizontal_rule,
          ),
          
          SizedBox(height: ThemeConstants.space2),
          
          _buildDetailRow(
            context: context,
            label: 'خط الطول',
            value: '${qiblaData.longitude.toStringAsFixed(6)}°',
            icon: Icons.more_vert,
          ),
          
          SizedBox(height: ThemeConstants.space2),
          
          _buildDetailRow(
            context: context,
            label: 'دقة الموقع',
            value: _getAccuracyText(),
            valueColor: _getAccuracyColor(),
            icon: Icons.gps_fixed,
          ),
          
          if (!qiblaData.isStale) ...[
            SizedBox(height: ThemeConstants.space2),
            _buildDetailRow(
              context: context,
              label: 'آخر تحديث',
              value: _getLastUpdateText(),
              icon: Icons.access_time,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required String label,
    required String value,
    Color? valueColor,
    IconData? icon,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 14,
            color: context.textSecondaryColor,
          ),
          SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            label,
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ),
        Text(
          value,
          style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? context.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStaleDataWarning(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: ThemeConstants.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: ThemeConstants.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: ThemeConstants.warning,
            size: 20,
          ),
          
          SizedBox(width: ThemeConstants.space2),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بيانات قديمة',
                  style: context.titleSmall?.copyWith(
                    color: ThemeConstants.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'يُنصح بتحديث الموقع لضمان دقة اتجاه القبلة',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دوال مساعدة
  String _getLocationName() {
    if (qiblaData.cityName != null && qiblaData.countryName != null) {
      return '${qiblaData.cityName}، ${qiblaData.countryName}';
    } else if (qiblaData.cityName != null) {
      return qiblaData.cityName!;
    } else if (qiblaData.countryName != null) {
      return qiblaData.countryName!;
    } else {
      return 'موقع غير محدد';
    }
  }

  String _getAccuracyText() {
    if (qiblaData.hasHighAccuracy) {
      return 'عالية (± ${qiblaData.accuracy.toStringAsFixed(0)}م)';
    } else if (qiblaData.hasMediumAccuracy) {
      return 'متوسطة (± ${qiblaData.accuracy.toStringAsFixed(0)}م)';
    } else {
      return 'منخفضة (± ${qiblaData.accuracy.toStringAsFixed(0)}م)';
    }
  }

  Color _getAccuracyColor() {
    if (qiblaData.hasHighAccuracy) return ThemeConstants.success;
    if (qiblaData.hasMediumAccuracy) return ThemeConstants.warning;
    return ThemeConstants.error;
  }

  String _getLastUpdateText() {
    final age = qiblaData.age;

    if (age.inMinutes < 1) {
      return 'الآن';
    } else if (age.inMinutes < 60) {
      return 'منذ ${age.inMinutes} دقيقة';
    } else if (age.inHours < 24) {
      return 'منذ ${age.inHours} ساعة';
    } else {
      return 'منذ ${age.inDays} يوم';
    }
  }
}