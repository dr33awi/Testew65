// lib/features/prayer_times/widgets/location_header.dart - مُصحح نهائياً
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return AppContainerBuilder.gradient(
      colors: [
        AppColorSystem.primary,
        AppColorSystem.primary.darken(0.2),
      ],
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Row(
          children: [
            // أيقونة الموقع
            Container(
              width: 50,
              height: 50,
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
                size: ThemeConstants.iconMd,
              ),
            ),
            
            const SizedBox(width: ThemeConstants.space3),
            
            // معلومات الموقع
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'موقعك الحالي',
                    style: AppTextStyles.label1.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: ThemeConstants.medium,
                    ),
                  ),
                  
                  const SizedBox(height: ThemeConstants.space1),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          location.cityName ?? 'غير محدد',
                          style: AppTextStyles.h5.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (location.countryName != null) ...[
                        const SizedBox(width: ThemeConstants.space2),
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
                            location.countryName!,
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: ThemeConstants.semiBold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: ThemeConstants.space3),
            
            // زر التحديث
            AnimatedPress(
              onTap: () {
                HapticFeedback.lightImpact();
                onTap();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: ThemeConstants.iconSm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}