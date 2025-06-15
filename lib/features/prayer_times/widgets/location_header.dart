// lib/features/prayer_times/widgets/location_header.dart

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

class LocationHeader extends StatelessWidget {
  final PrayerLocation location;
  final VoidCallback onTap;

  const LocationHeader({
    super.key,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      child: AppCard(
        style: CardStyle.normal,
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on,
                color: context.primaryColor,
                size: 24,
              ),
            ),
            
            ThemeConstants.space3.w,
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        location.cityName ?? 'موقع غير محدد',
                        style: context.titleMedium?.semiBold,
                      ),
                      if (location.countryName != null) ...[
                        Text(
                          ' • ',
                          style: context.bodyMedium?.copyWith(
                            color: context.textSecondaryColor,
                          ),
                        ),
                        Text(
                          location.countryName!,
                          style: context.bodyMedium?.copyWith(
                            color: context.textSecondaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  ThemeConstants.space1.h,
                  
                  Text(
                    'خط العرض: ${location.latitude.toStringAsFixed(4)}° • '
                    'خط الطول: ${location.longitude.toStringAsFixed(4)}°',
                    style: context.bodySmall?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.refresh,
              color: context.textSecondaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}