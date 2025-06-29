// lib/features/prayer_times/widgets/location_header.dart (محدث بالنظام الموحد)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
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

class _LocationHeaderState extends State<LocationHeader>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppTheme.durationNormal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildLocationCard(context),
        );
      },
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return AnimatedPress(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AppCard(
        useGradient: true,
        color: AppTheme.primary,
        padding: AppTheme.space4.padding,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: AppTheme.iconMd,
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
                style: AppTheme.labelMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: AppTheme.medium,
                ),
              ),
              
              AppTheme.space1.h,
              
              // اسم المدينة والدولة
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.location.cityName ?? 'غير محدد',
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.location.countryName != null) ...[
                    AppTheme.space2.w,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.space2,
                        vertical: AppTheme.space1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: AppTheme.radiusFull.radius,
                      ),
                      child: Text(
                        widget.location.countryName!,
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: AppTheme.semiBold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              // الإحداثيات (اختيارية)
              if (widget.location.latitude != 0 && widget.location.longitude != 0) ...[
                AppTheme.space1.h,
                Text(
                  'خط العرض: ${widget.location.latitude.toStringAsFixed(2)}° • خط الطول: ${widget.location.longitude.toStringAsFixed(2)}°',
                  style: AppTheme.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
        
        AppTheme.space3.w,
        
        // زر التحديث
        AnimatedPress(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap();
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
              size: AppTheme.iconSm,
            ),
          ),
        ),
      ],
    );
  }
}