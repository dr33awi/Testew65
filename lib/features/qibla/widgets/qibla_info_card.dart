// lib/features/qibla/widgets/qibla_info_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
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
      margin: const EdgeInsets.all(ThemeConstants.space4),
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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            ),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // رأس البطاقة مع الموقع
        _buildLocationHeader(context),
        
        // معلومات القبلة التفصيلية
        Padding(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          child: Column(
            children: [
              // المعلومات الأساسية (الاتجاه والمسافة)
              _buildPrimaryInfo(context),
              
              ThemeConstants.space4.h,
              
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
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeConstants.primary.withValues(alpha: 0.1),
            ThemeConstants.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radius2xl),
        ),
      ),
      child: Row(
        children: [
          // أيقونة الموقع الثابتة
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConstants.primary.withValues(alpha: 0.2),
                  ThemeConstants.primary.withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: ThemeConstants.primary.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeConstants.primary.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.location_on,
              color: ThemeConstants.primary,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          ThemeConstants.space4.w,
          
          // معلومات الموقع
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'موقعك الحالي',
                  style: context.labelLarge?.copyWith(
                    color: context.textSecondaryColor,
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
                
                ThemeConstants.space1.h,
                
                Text(
                  _getLocationName(),
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                
                ThemeConstants.space1.h,
                
                // دقة الموقع
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space2,
                    vertical: ThemeConstants.space1,
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
                        size: ThemeConstants.iconXs,
                        color: _getAccuracyColor(),
                      ),
                      ThemeConstants.space1.w,
                      Text(
                        _getAccuracyText(),
                        style: context.labelSmall?.copyWith(
                          color: _getAccuracyColor(),
                          fontWeight: ThemeConstants.semiBold,
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
            color: ThemeConstants.primary,
          ),
        ),
        
        // فاصل رأسي
        Container(
          width: 1,
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.dividerColor.withValues(alpha: 0.0),
                context.dividerColor.withValues(alpha: 0.5),
                context.dividerColor.withValues(alpha: 0.0),
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
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // الأيقونة
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
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
          
          ThemeConstants.space2.h,
          
          // العنوان
          Text(
            title,
            style: context.labelMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          ThemeConstants.space1.h,
          
          // القيمة
          Text(
            value,
            style: context.titleLarge?.copyWith(
              color: color,
              fontWeight: ThemeConstants.bold,
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
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: ThemeConstants.info.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  color: ThemeConstants.info,
                  size: ThemeConstants.iconMd,
                ),
              ),
              ThemeConstants.space3.w,
              Text(
                'تفاصيل الموقع',
                style: context.titleMedium?.copyWith(
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
            ],
          ),
          
          ThemeConstants.space4.h,
          
          // الإحداثيات
          _buildDetailRow(
            context: context,
            label: 'خط العرض',
            value: '${widget.qiblaData.latitude.toStringAsFixed(6)}°',
            icon: Icons.horizontal_rule,
          ),
          
          ThemeConstants.space2.h,
          
          _buildDetailRow(
            context: context,
            label: 'خط الطول',
            value: '${widget.qiblaData.longitude.toStringAsFixed(6)}°',
            icon: Icons.more_vert,
          ),
          
          ThemeConstants.space2.h,
          
          _buildDetailRow(
            context: context,
            label: 'دقة الموقع',
            value: _getAccuracyText(),
            valueColor: _getAccuracyColor(),
            icon: Icons.gps_fixed,
          ),
          
          if (!widget.qiblaData.isStale) ...[
            ThemeConstants.space2.h,
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
            color: context.textSecondaryColor,
          ),
          ThemeConstants.space2.w,
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
            fontWeight: ThemeConstants.semiBold,
            color: valueColor ?? context.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStaleDataWarning(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeConstants.warning.withValues(alpha: 0.1),
            ThemeConstants.warning.withValues(alpha: 0.05),
          ],
        ),
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
            size: ThemeConstants.iconLg,
          ),
          
          ThemeConstants.space3.w,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بيانات قديمة',
                  style: context.titleSmall?.copyWith(
                    color: ThemeConstants.warning,
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
                ThemeConstants.space1.h,
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