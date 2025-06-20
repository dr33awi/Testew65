// lib/features/qibla/widgets/qibla_info_card.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../models/qibla_model.dart';

/// بطاقة معلومات القبلة
class QiblaInfoCard extends StatelessWidget {
  final QiblaModel qiblaModel;
  final double compassAccuracy;
  final bool hasCompass;

  const QiblaInfoCard({
    super.key,
    required this.qiblaModel,
    required this.compassAccuracy,
    required this.hasCompass,
  });

  @override
  Widget build(BuildContext context) {
    return IslamicCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          context.primaryColor.withValues(alpha: 0.1),
          context.primaryColor.withValues(alpha: 0.05),
        ],
      ),
      child: Column(
        children: [
          // العنوان
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.primaryColor,
                      context.primaryColor.darken(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.place,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Spaces.smallH,
              Text(
                'معلومات القبلة',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _buildStatusIndicator(context),
            ],
          ),
          
          Spaces.medium,
          
          // المعلومات الأساسية
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        'المسافة',
                        qiblaModel.distanceDescription,
                        Icons.straighten,
                        context.infoColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            context.borderColor.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        'الاتجاه',
                        qiblaModel.directionDescription,
                        Icons.navigation,
                        context.secondaryColor,
                      ),
                    ),
                  ],
                ),
                
                if (qiblaModel.cityName != null || qiblaModel.countryName != null) ...[
                  Spaces.medium,
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          context.borderColor.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Spaces.medium,
                  _buildLocationInfo(context),
                ],
              ],
            ),
          ),
          
          // معلومات الدقة والحالة
          Spaces.medium,
          Row(
            children: [
              // دقة الموقع
              Expanded(
                child: _buildAccuracyCard(
                  context,
                  'دقة الموقع',
                  '${qiblaModel.accuracy.toStringAsFixed(1)} م',
                  Icons.gps_fixed,
                  qiblaModel.hasHighAccuracy 
                      ? context.successColor
                      : qiblaModel.hasMediumAccuracy 
                          ? context.warningColor 
                          : context.errorColor,
                  _getLocationAccuracyDescription(qiblaModel.accuracy),
                ),
              ),
              
              if (hasCompass) ...[
                Spaces.mediumH,
                // دقة البوصلة
                Expanded(
                  child: _buildAccuracyCard(
                    context,
                    'دقة البوصلة',
                    '${compassAccuracy.toStringAsFixed(0)}%',
                    Icons.explore,
                    compassAccuracy > 70 
                        ? context.successColor
                        : compassAccuracy > 40
                            ? context.warningColor
                            : context.errorColor,
                    _getCompassAccuracyDescription(compassAccuracy),
                  ),
                ),
              ],
            ],
          ),
          
          // معلومات إضافية
          if (!hasCompass || qiblaModel.isStale) ...[
            Spaces.medium,
            _buildWarningInfo(context),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    final isRecent = !qiblaModel.isStale;
    final hasGoodAccuracy = qiblaModel.hasHighAccuracy;
    final hasGoodCompass = hasCompass && compassAccuracy > 60;
    
    final isGoodOverall = isRecent && hasGoodAccuracy && (hasGoodCompass || !hasCompass);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isGoodOverall 
              ? [
                  context.successColor.withValues(alpha: 0.2),
                  context.successColor.withValues(alpha: 0.1),
                ]
              : [
                  context.warningColor.withValues(alpha: 0.2),
                  context.warningColor.withValues(alpha: 0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGoodOverall 
              ? context.successColor.withValues(alpha: 0.3)
              : context.warningColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGoodOverall ? Icons.check_circle : Icons.warning,
            size: 16,
            color: isGoodOverall 
                ? context.successColor 
                : context.warningColor,
          ),
          const SizedBox(width: 6),
          Text(
            isGoodOverall ? 'دقيق' : 'تقريبي',
            style: context.captionStyle.copyWith(
              color: isGoodOverall 
                  ? context.successColor 
                  : context.warningColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.1),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        Spaces.small,
        Text(
          label,
          style: context.captionStyle.copyWith(
            color: context.secondaryTextColor,
          ),
        ),
        Spaces.xs,
        Text(
          value,
          style: context.bodyStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.location_on,
              color: context.primaryColor,
              size: 18,
            ),
          ),
          Spaces.mediumH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (qiblaModel.cityName != null)
                  Text(
                    qiblaModel.cityName!,
                    style: context.bodyStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (qiblaModel.countryName != null)
                  Text(
                    qiblaModel.countryName!,
                    style: context.captionStyle.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
              ],
            ),
          ),
          // إحداثيات مبسطة
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${qiblaModel.latitude.toStringAsFixed(2)}°',
                style: context.captionStyle.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${qiblaModel.longitude.toStringAsFixed(2)}°',
                style: context.captionStyle.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              Spaces.smallH,
              Expanded(
                child: Text(
                  title,
                  style: context.captionStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Spaces.small,
          Text(
            value,
            style: context.titleStyle.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            description,
            style: context.captionStyle.copyWith(
              color: color,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningInfo(BuildContext context) {
    final warnings = <String>[];
    
    if (!hasCompass) {
      warnings.add('البوصلة غير متوفرة على هذا الجهاز');
    }
    
    if (qiblaModel.isStale) {
      warnings.add('البيانات قديمة، يُنصح بالتحديث');
    }
    
    if (warnings.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.warningColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: context.warningColor,
                size: 18,
              ),
              Spaces.smallH,
              Text(
                'ملاحظات مهمة',
                style: context.captionStyle.copyWith(
                  color: context.warningColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spaces.small,
          ...warnings.map((warning) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: context.captionStyle.copyWith(
                    color: context.warningColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    warning,
                    style: context.captionStyle.copyWith(
                      color: context.warningColor,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  String _getLocationAccuracyDescription(double accuracy) {
    if (accuracy <= 5) return 'ممتازة';
    if (accuracy <= 20) return 'جيدة جداً';
    if (accuracy <= 50) return 'جيدة';
    if (accuracy <= 100) return 'متوسطة';
    return 'ضعيفة';
  }

  String _getCompassAccuracyDescription(double accuracy) {
    if (accuracy > 80) return 'ممتازة';
    if (accuracy > 60) return 'جيدة';
    if (accuracy > 40) return 'متوسطة';
    return 'ضعيفة';
  }
}