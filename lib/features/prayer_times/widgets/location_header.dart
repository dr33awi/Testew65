// lib/features/prayer_times/widgets/location_header.dart - مُحدث بالنظام الموحد

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';

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
    // استخدام AppCard من النظام الموحد مع تصميم مبسط
    return AnimatedPress(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        margin: EdgeInsets.all(AppTheme.space4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.space4),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(
      children: [
        // أيقونة الموقع
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 24,
          ),
        ),
        
        AppTheme.space3.w,
        
        // معلومات الموقع
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // العنوان
              Text(
                'موقعك الحالي',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              AppTheme.space1.h,
              
              // اسم المدينة والدولة
              Row(
                children: [
                  Expanded(
                    child: Text(
                      location.cityName ?? 'غير محدد',
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (location.countryName != null) ...[
                    AppTheme.space2.w,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.space2,
                        vertical: AppTheme.space1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                      ),
                      child: Text(
                        location.countryName!,
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        
        AppTheme.space3.w,
        
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
              size: 20,
            ),
          ),
        ),
      ],
    );
  }