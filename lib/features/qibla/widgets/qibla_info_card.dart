// 3. تحسين واجهة بطاقة معلومات القبلة - lib/features/qibla/widgets/qibla_info_card.dart
import 'package:flutter/material.dart';
import '../../../../app/themes/app_theme.dart';
import 'package:athkar_app/features/qibla/domain/models/qibla_model.dart';

class QiblaInfoCard extends StatelessWidget {
  final QiblaModel qiblaData;

  const QiblaInfoCard({
    super.key,
    required this.qiblaData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: context.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'موقعك الحالي',
                        style: context.titleSmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // إظهار اسم المدينة بدلاً من الإحداثيات
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getLocationName(),
                              style: context.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    Icons.navigation_outlined,
                    'اتجاه القبلة',
                    '${qiblaData.qiblaDirection.toStringAsFixed(1)}°',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    context,
                    Icons.place_outlined,
                    'المسافة',
                    '${qiblaData.distance.toStringAsFixed(0)} كم',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLocationName() {
    if (qiblaData.cityName != null && qiblaData.countryName != null) {
      return '${qiblaData.cityName!}، ${qiblaData.countryName!}';
    } else if (qiblaData.cityName != null) {
      return qiblaData.cityName!;
    } else if (qiblaData.countryName != null) {
      return qiblaData.countryName!;
    } else {
      return '${qiblaData.latitude.toStringAsFixed(6)}°، ${qiblaData.longitude.toStringAsFixed(6)}°';
    }
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: context.textSecondaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: context.bodySmall?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}