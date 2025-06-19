// lib/features/prayer_times/widgets/location_header.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

class LocationHeader extends StatefulWidget {
  final PrayerLocation location;
  final VoidCallback onTap;

  const LocationHeader({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  State<LocationHeader> createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader> {

  @override
  Widget build(BuildContext context) {
    return AppCard(
      type: CardType.info,
      style: CardStyle.gradient,
      gradientColors: ThemeConstants.primaryGradient.colors,
      showShadow: true,
      enableBlur: true,
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      padding: const EdgeInsets.all(ThemeConstants.space5),
      child: Row(
        children: [
          // أيقونة الموقع
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.white,
              size: 32,
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
                  style: context.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
                
                ThemeConstants.space1.h,
                
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.location.cityName ?? 'غير محدد',
                        style: context.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ).withShadow(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.location.countryName != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space2,
                          vertical: ThemeConstants.space1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                        ),
                        child: Text(
                          widget.location.countryName!,
                          style: context.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: ThemeConstants.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                
                ThemeConstants.space2.h,
                
                // الإحداثيات
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      // خط العرض
                      Expanded(
                        child: _buildCoordinateItem(
                          'خط العرض',
                          '${widget.location.latitude.toStringAsFixed(4)}°',
                          Icons.horizontal_rule,
                        ),
                      ),
                      
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.white.withValues(alpha: 0.3),
                        margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space2),
                      ),
                      
                      // خط الطول
                      Expanded(
                        child: _buildCoordinateItem(
                          'خط الطول',
                          '${widget.location.longitude.toStringAsFixed(4)}°',
                          Icons.more_vert,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          ThemeConstants.space3.w,
          
          // زر التحديث
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                widget.onTap();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 24,
              ),
              tooltip: 'تحديث الموقع',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinateItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.7),
          size: ThemeConstants.iconSm,
        ),
        ThemeConstants.space1.h,
        Text(
          label,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: context.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
      ],
    );
  }
}