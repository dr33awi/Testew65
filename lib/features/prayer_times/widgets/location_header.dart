// lib/features/prayer_times/widgets/location_header.dart - النسخة الموحدة

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
    // ✅ استخدام AppCard مع تدرج موحد
    return AppCard.custom(
      style: CardStyle.glassmorphism,
      gradientColors: [
        context.primaryColor,
        context.primaryColor.darken(0.2),
      ],
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          _buildLocationIcon(),
          ThemeConstants.space3.w,
          Expanded(
            child: _buildLocationInfo(context),
          ),
          ThemeConstants.space3.w,
          _buildRefreshButton(context),
        ],
      ),
    ).cardContainer(
      margin: ThemeConstants.space4.horizontal,
    );
  }

  Widget _buildLocationIcon() {
    // ✅ استخدام النظام الموحد للحاويات
    return AppContainerBuilder.glass(
      child: const Icon(
        AppIconsSystem.location,
        color: Colors.white,
        size: ThemeConstants.iconMd,
      ),
      backgroundColor: Colors.white.withOpacitySafe(0.2),
      borderRadius: ThemeConstants.radiusLg,
      padding: const EdgeInsets.all(12),
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'موقعك الحالي',
          style: AppTextStyles.label1.copyWith(
            color: Colors.white.withOpacitySafe(0.8),
            fontWeight: ThemeConstants.medium,
          ),
        ),
        
        ThemeConstants.space1.h,
        
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
              ThemeConstants.space2.w,
              _buildCountryBadge(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCountryBadge() {
    // ✅ استخدام النظام الموحد للشارات
    return AppNoticeCard.info(
      title: location.countryName!,
    ).padded(const EdgeInsets.symmetric(
      horizontal: ThemeConstants.space2,
      vertical: ThemeConstants.space1,
    ));
  }

  Widget _buildRefreshButton(BuildContext context) {
    // ✅ استخدام AnimatedPress الموحد
    return AnimatedPress(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AppContainerBuilder.glass(
        child: const Icon(
          AppIconsSystem.refresh,
          color: Colors.white,
          size: ThemeConstants.iconSm,
        ),
        backgroundColor: Colors.white.withOpacitySafe(0.2),
        borderRadius: ThemeConstants.radiusLg,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}