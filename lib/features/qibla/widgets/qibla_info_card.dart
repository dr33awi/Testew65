// lib/features/qibla/widgets/qibla_info_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return AppCard(
      padding: EdgeInsets.zero,
      borderRadius: ThemeConstants.radius2xl,
      child: Column(
        children: [
          // Header with location name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4, vertical: ThemeConstants.space3), // Reduced vertical padding
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primaryColor.withOpacity(0.1),
                  context.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(ThemeConstants.radius2xl),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2), // Reduced padding
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: context.primaryColor,
                    size: ThemeConstants.iconMd,
                  ),
                ),
                ThemeConstants.space2.w, // Reduced spacing
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'موقعك الحالي',
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                      ThemeConstants.space1.h,
                      Text(
                        _getLocationName(),
                        style: context.bodyLarge?.bold,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Reduced max lines for compactness
                      ),
                    ],
                  ),
                ),
                // Removed Copy coordinates button
              ],
            ),
          ),

          // Qibla Info Details
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4), // Kept consistent padding
            child: Column(
              children: [
                // Primary Info (Direction and Distance)
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        context: context,
                        icon: Icons.navigation_outlined,
                        title: 'اتجاه القبلة',
                        value: '${qiblaData.qiblaDirection.toStringAsFixed(1)}°',
                        subtitle: qiblaData.directionDescription,
                        color: context.primaryColor,
                      ),
                    ),
                    Container(
                      width: ThemeConstants.borderLight,
                      height: ThemeConstants.heightXl,
                      color: context.dividerColor.withOpacity(0.5),
                      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space2),
                    ),
                    Expanded(
                      child: _buildInfoTile(
                        context: context,
                        icon: Icons.straighten,
                        title: 'المسافة للكعبة',
                        value: qiblaData.distanceDescription,
                        subtitle: 'خط مستقيم',
                        color: ThemeConstants.warning, // Use warning color for distance
                      ),
                    ),
                  ],
                ),

                ThemeConstants.space4.h,

                // Additional Details
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space3),
                  decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius: ThemeConstants.radiusMd.circular,
                    border: Border.all(
                      color: context.dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context: context,
                        label: 'خط العرض',
                        value: '${qiblaData.latitude.toStringAsFixed(6)}°',
                      ),
                      ThemeConstants.space2.h,
                      _buildDetailRow(
                        context: context,
                        label: 'خط الطول',
                        value: '${qiblaData.longitude.toStringAsFixed(6)}°',
                      ),
                      ThemeConstants.space2.h,
                      _buildDetailRow(
                        context: context,
                        label: 'دقة الموقع',
                        value: _getAccuracyText(),
                        valueColor: _getAccuracyColor(),
                      ),
                      if (!qiblaData.isStale) ...[
                        ThemeConstants.space2.h,
                        _buildDetailRow(
                          context: context,
                          label: 'آخر تحديث',
                          value: _getLastUpdateText(),
                        ),
                      ],
                    ],
                  ),
                ),

                // Stale data warning
                if (qiblaData.isStale)
                  Container(
                    margin: const EdgeInsets.only(top: ThemeConstants.space3),
                    padding: const EdgeInsets.all(ThemeConstants.space3),
                    decoration: BoxDecoration(
                      color: ThemeConstants.warning.withOpacity(0.1),
                      borderRadius: ThemeConstants.radiusMd.circular,
                      border: Border.all(
                        color: ThemeConstants.warning.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: ThemeConstants.warning.darken(0.1),
                          size: ThemeConstants.iconMd,
                        ),
                        ThemeConstants.space2.w,
                        Expanded(
                          child: Text(
                            'بيانات الموقع قديمة، يُنصح بالتحديث لضمان الدقة.',
                            style: context.bodySmall?.copyWith(
                              color: ThemeConstants.warning.darken(0.1),
                            ),
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

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space1), // Smaller vertical padding
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ThemeConstants.iconLg,
          ),
          ThemeConstants.space1.h, // Reduced spacing
          Text(
            title,
            style: context.bodySmall?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          // No additional vertical space here, value directly below title
          Text(
            value,
            style: context.titleMedium?.bold.textColor(color),
          ),
          ThemeConstants.space1.h,
          Text(
            subtitle,
            style: context.bodySmall?.copyWith( // Used bodySmall for subtitle for compactness
              color: context.textSecondaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.bodySmall?.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
        Text(
          value,
          style: context.bodySmall?.copyWith(
            fontWeight: ThemeConstants.semiBold,
            color: valueColor ?? context.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  String _getAccuracyText() {
    if (qiblaData.hasHighAccuracy) {
      return '± ${qiblaData.accuracy.toStringAsFixed(0)} متر (عالية)';
    } else if (qiblaData.hasMediumAccuracy) {
      return '± ${qiblaData.accuracy.toStringAsFixed(0)} متر (متوسطة)';
    } else {
      return '± ${qiblaData.accuracy.toStringAsFixed(0)} متر (منخفضة)';
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

  // Removed _copyCoordinates method entirely
  // void _copyCoordinates(BuildContext context) {
  //   final coordinates = '${qiblaData.latitude.toStringAsFixed(6)}, ${qiblaData.longitude.toStringAsFixed(6)}';
  //   Clipboard.setData(ClipboardData(text: coordinates));
  //   HapticFeedback.lightImpact();

  //   AppSnackBar.showInfo(
  //     context: context,
  //     message: 'تم نسخ الإحداثيات: $coordinates',
  //   );
  // }
}