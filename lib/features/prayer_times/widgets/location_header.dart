// lib/features/prayer_times/widgets/location_header.dart (محدث ومبسط)
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
    // استخدام AppCard من النظام الموحد مع تصميم مبسط
    return AppCard(
      type: CardType.info,
      style: CardStyle.gradient,
      primaryColor: context.primaryColor,
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      padding: const EdgeInsets.all(ThemeConstants.space4), // تقليل الحشو
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        // أيقونة الموقع مصغرة
        Container(
          width: 50, // مصغرة من 70
          height: 50, // مصغرة من 70
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
            size: 24, // مصغرة من 32
          ),
        ),
        
        ThemeConstants.space3.w,
        
        // معلومات الموقع مبسطة
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // تقليل الارتفاع
            children: [
              // العنوان
              Text(
                'موقعك الحالي',
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: ThemeConstants.medium,
                ),
              ),
              
              ThemeConstants.space1.h,
              
              // اسم المدينة والدولة في سطر واحد
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.location.cityName ?? 'غير محدد',
                      style: context.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.location.countryName != null) ...[
                    ThemeConstants.space2.w,
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
            ],
          ),
        ),
        
        ThemeConstants.space3.w,
        
        // زر التحديث مصغر
        AnimatedPress(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          child: Container(
            width: 40, // مصغر من أكبر
            height: 40, // مصغر من أكبر
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
              size: 20, // مصغر من 24
            ),
          ),
        ),
      ],
    );
  }
}