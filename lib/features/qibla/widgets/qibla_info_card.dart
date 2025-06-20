// lib/features/qibla/widgets/qibla_info_card.dart
import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../domain/models/qibla_model.dart';

class QiblaInfoCard extends StatefulWidget {
  final QiblaModel qiblaData;

  const QiblaInfoCard({
    super.key,
    required this.qiblaData,
  });

  @override
  State<QiblaInfoCard> createState() => _QiblaInfoCardState();
}

class _QiblaInfoCardState extends State<QiblaInfoCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceMd),
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // رأس البطاقة مع الموقع
        _buildLocationHeader(context),
        
        // معلومات القبلة التفصيلية
        Padding(
          padding: const EdgeInsets.all(ThemeConstants.spaceMd),
          child: Column(
            children: [
              // المعلومات الأساسية (الاتجاه والمسافة)
              _buildPrimaryInfo(context),
              
              Spaces.large,
              
              // التفاصيل الإضافية
              _buildDetailedInfo(context),
              
              // تحذير البيانات القديمة
              if (widget.qiblaData.isStale)
                _buildStaleDataWarning(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor.withValues(alpha: 0.1),
            context.primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusLg),
        ),
      ),
      child: Row(
        children: [
          // أيقونة الموقع
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.primaryColor.withValues(alpha: 0.2),
                  context.primaryColor.withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.location_on,
              color: context.primaryColor,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          Spaces.mediumH,
          
          // معلومات الموقع
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'موقعك الحالي',
                  style: context.bodyStyle.copyWith(
                    color: context.secondaryTextColor,
                    fontWeight: ThemeConstants.fontMedium,
                  ),
                ),
                
                Spaces.small,
                
                Text(
                  _getLocationName(),
                  style: context.titleStyle.copyWith(
                    fontWeight: ThemeConstants.fontBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                
                Spaces.small,
                
                // دقة الموقع
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.spaceSm,
                    vertical: ThemeConstants.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: _getAccuracyColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.my_location,
                        size: ThemeConstants.iconSm,
                        color: _getAccuracyColor(),
                      ),
                      Spaces.xsH,
                      Text(
                        _getAccuracyText(),
                        style: context.captionStyle.copyWith(
                          color: _getAccuracyColor(),
                          fontWeight: ThemeConstants.fontSemiBold,
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
            value: '${widget.qiblaData.qiblaDirection.toStringAsFixed(1)}°',
            subtitle: widget.qiblaData.directionDescription,
            color: context.primaryColor,
          ),
        ),
        
        // فاصل رأسي
        Container(
          width: 1,
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceSm),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.borderColor.withValues(alpha: 0.0),
                context.borderColor.withValues(alpha: 0.5),
                context.borderColor.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        
        // المسافة للكعبة
        Expanded(
          child: _buildInfoTile(
            context: context,
            icon: Icons.straighten,
            title: 'المسافة للكعبة',
            value: widget.qiblaData.distanceDescription,
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
      padding: const EdgeInsets.all(ThemeConstants.spaceSm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      child: Column(
        children: [
          // الأيقونة
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spaceSm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          Spaces.medium,
          
          // العنوان
          Text(
            title,
            style: context.bodyStyle.copyWith(
              color: context.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          Spaces.small,
          
          // القيمة
          Text(
            value,
            style: context.titleStyle.copyWith(
              color: color,
              fontWeight: ThemeConstants.fontBold,
            ),
            textAlign: TextAlign.center,
          ),
          
          // الوصف
          Text(
            subtitle,
            style: context.captionStyle.copyWith(
              color: context.secondaryTextColor.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان التفاصيل
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceSm),
                decoration: BoxDecoration(
                  color: ThemeConstants.info.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: ThemeConstants.info,
                  size: ThemeConstants.iconMd,
                ),
              ),
              Spaces.mediumH,
              const Text(
                'تفاصيل الموقع',
                style: AppTypography.title,
              ),
            ],
          ),
          
          Spaces.large,
          
          // الإحداثيات
          _buildDetailRow(
            context: context,
            label: 'خط العرض',
            value: '${widget.qiblaData.latitude.toStringAsFixed(6)}°',
            icon: Icons.horizontal_rule,
          ),
          
          Spaces.medium,
          
          _buildDetailRow(
            context: context,
            label: 'خط الطول',
            value: '${widget.qiblaData.longitude.toStringAsFixed(6)}°',
            icon: Icons.more_vert,
          ),
          
          Spaces.medium,
          
          _buildDetailRow(
            context: context,
            label: 'دقة الموقع',
            value: _getAccuracyText(),
            valueColor: _getAccuracyColor(),
            icon: Icons.gps_fixed,
          ),
          
          if (!widget.qiblaData.isStale) ...[
            Spaces.medium,
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
            size: ThemeConstants.iconSm,
            color: context.secondaryTextColor,
          ),
          Spaces.mediumH,
        ],
        Expanded(
          child: Text(
            label,
            style: context.bodyStyle.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ),
        Text(
          value,
          style: context.bodyStyle.copyWith(
            fontWeight: ThemeConstants.fontSemiBold,
            color: valueColor ?? context.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStaleDataWarning(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: ThemeConstants.spaceMd),
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: ThemeConstants.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: ThemeConstants.warning,
            size: ThemeConstants.iconLg,
          ),
          
          Spaces.mediumH,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بيانات قديمة',
                  style: context.bodyStyle.copyWith(
                    color: ThemeConstants.warning,
                    fontWeight: ThemeConstants.fontSemiBold,
                  ),
                ),
                Spaces.small,
                Text(
                  'يُنصح بتحديث الموقع لضمان دقة اتجاه القبلة',
                  style: context.captionStyle,
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
    if (widget.qiblaData.cityName != null && widget.qiblaData.countryName != null) {
      return '${widget.qiblaData.cityName}، ${widget.qiblaData.countryName}';
    } else if (widget.qiblaData.cityName != null) {
      return widget.qiblaData.cityName!;
    } else if (widget.qiblaData.countryName != null) {
      return widget.qiblaData.countryName!;
    } else {
      return 'موقع غير محدد';
    }
  }

  String _getAccuracyText() {
    if (widget.qiblaData.hasHighAccuracy) {
      return 'عالية (± ${widget.qiblaData.accuracy.toStringAsFixed(0)}م)';
    } else if (widget.qiblaData.hasMediumAccuracy) {
      return 'متوسطة (± ${widget.qiblaData.accuracy.toStringAsFixed(0)}م)';
    } else {
      return 'منخفضة (± ${widget.qiblaData.accuracy.toStringAsFixed(0)}م)';
    }
  }

  Color _getAccuracyColor() {
    if (widget.qiblaData.hasHighAccuracy) return ThemeConstants.success;
    if (widget.qiblaData.hasMediumAccuracy) return ThemeConstants.warning;
    return ThemeConstants.error;
  }

  String _getLastUpdateText() {
    final age = widget.qiblaData.age;

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