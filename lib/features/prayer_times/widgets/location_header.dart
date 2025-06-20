// lib/features/prayer_times/widgets/location_header.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/index.dart';
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
    return IslamicCard.gradient(
      gradient: LinearGradient(
        colors: [
          context.primaryColor.withAlpha(229),
          context.primaryColor.darken(0.1).withAlpha(229),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      margin: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap();
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withAlpha(77),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 32,
          ),
        ),
        
        const HSpace(ThemeConstants.spaceMd),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'موقعك الحالي',
                style: context.captionStyle.copyWith(
                  color: Colors.white.withAlpha(204),
                  fontWeight: ThemeConstants.fontMedium,
                ),
              ),
              const VSpace(ThemeConstants.spaceXs),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.location.cityName ?? 'غير محدد',
                      style: context.titleStyle.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.fontBold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.location.countryName != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spaceSm,
                        vertical: ThemeConstants.spaceXs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                      ),
                      child: Text(
                        widget.location.countryName!,
                        style: context.captionStyle.copyWith(
                          color: Colors.white.withAlpha(229),
                          fontWeight: ThemeConstants.fontSemiBold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const VSpace(ThemeConstants.spaceSm),
              IslamicCard.simple(
                color: Colors.white.withAlpha(38),
                child: Row(
                  children: [
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
                      color: Colors.white.withAlpha(77),
                      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceSm),
                    ),
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
        
        const HSpace(ThemeConstants.spaceMd),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
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
    );
  }

  Widget _buildCoordinateItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withAlpha(179),
          size: ThemeConstants.iconSm,
        ),
        const VSpace(ThemeConstants.spaceXs),
        Text(
          label,
          style: context.captionStyle.copyWith(
            color: Colors.white.withAlpha(179),
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: context.captionStyle.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.fontSemiBold,
          ),
        ),
      ],
    );
  }
}