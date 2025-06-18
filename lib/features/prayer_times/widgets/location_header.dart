// lib/features/prayer_times/widgets/location_header.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
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

class _LocationHeaderState extends State<LocationHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          colors: [
            ThemeConstants.primary.withValues(alpha: 0.9),
            ThemeConstants.primary.darken(0.1).withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap();
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                ),
                child: _buildContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        // أيقونة الموقع المتحركة
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // الدوائر المتحركة
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              // الأيقونة
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ),
        
        ThemeConstants.space4.w,
        
        // معلومات الموقع
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              
              // اسم المدينة والدولة
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.location.cityName ?? 'غير محدد',
                      style: context.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ),
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
            icon: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 0.5,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              },
            ),
            tooltip: 'تحديث الموقع',
          ),
        ),
      ],
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