// lib/features/prayer_times/widgets/prayer_time_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

/// بطاقة وقت الصلاة المحسنة
class PrayerTimeCard extends StatefulWidget {
  final PrayerTime prayer;
  final Function(bool) onNotificationToggle;
  final bool forceColored;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    required this.onNotificationToggle,
    this.forceColored = false,
  });

  @override
  State<PrayerTimeCard> createState() => _PrayerTimeCardState();
}

class _PrayerTimeCardState extends State<PrayerTimeCard>
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
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveSmooth,
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
    final isNext = widget.prayer.isNext;
    final isPassed = widget.prayer.isPassed;
    final gradient = _getGradient(widget.prayer.type);
    final useGradient = widget.forceColored || isNext;
    
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildCard(context, useGradient, gradient, isPassed),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool useGradient, List<Color> gradient, bool isPassed) {
    return Container(
      margin: const EdgeInsets.only(bottom: ThemeConstants.space3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        boxShadow: _buildCardShadow(useGradient, gradient),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleCardTap,
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            child: Stack(
              children: [
                // الخلفية المتدرجة أو العادية
                _buildCardBackground(useGradient, gradient, isPassed),
                
                // المحتوى الرئيسي
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: useGradient 
                          ? Colors.white.withValues(alpha: 0.2)
                          : context.dividerColor.withValues(alpha: 0.1),
                      width: useGradient ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  ),
                  child: _buildCardContent(context, useGradient, gradient, isPassed),
                ),
                
                // تأثير الضوء في الأعلى
                if (useGradient) _buildLightEffect(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _buildCardShadow(bool useGradient, List<Color> gradient) {
    return [
      BoxShadow(
        color: useGradient 
            ? gradient[0].withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.08),
        blurRadius: useGradient ? 25 : 15,
        offset: Offset(0, useGradient ? 12 : 8),
        spreadRadius: useGradient ? 2 : 0,
      ),
      if (useGradient) ...[
        BoxShadow(
          color: gradient[0].withValues(alpha: 0.1),
          blurRadius: 40,
          offset: const Offset(0, 20),
          spreadRadius: 5,
        ),
      ],
    ];
  }

  Widget _buildCardBackground(bool useGradient, List<Color> gradient, bool isPassed) {
    if (useGradient) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradient[0].withValues(alpha: 0.95),
              gradient[1].withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.cardColor,
              context.cardColor.darken(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        ),
      );
    }
  }

  Widget _buildLightEffect() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(ThemeConstants.radius2xl),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(
    BuildContext context, 
    bool useGradient, 
    List<Color> gradient, 
    bool isPassed
  ) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space5),
      child: Row(
        children: [
          // أيقونة الحالة المحسنة
          _buildEnhancedStatusIcon(context, useGradient, gradient, isPassed),
          
          ThemeConstants.space4.w,
          
          // معلومات الصلاة
          Expanded(
            child: _buildPrayerInfo(context, useGradient, isPassed),
          ),
          
          ThemeConstants.space4.w,
          
          // الوقت المحسن
          _buildEnhancedTimeSection(context, useGradient, gradient),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatusIcon(
    BuildContext context, 
    bool useGradient, 
    List<Color> gradient, 
    bool isPassed
  ) {
    final iconData = _getStatusIcon(isPassed);
    final colors = _getIconColors(useGradient, gradient, isPassed);
    
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: colors['background'],
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: colors['border']!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colors['icon']!.withValues(alpha: useGradient ? 0.3 : 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          iconData,
          color: colors['icon'],
          size: ThemeConstants.iconLg,
        ),
      ),
    );
  }

  IconData _getStatusIcon(bool isPassed) {
    if (widget.prayer.isNext) {
      return Icons.schedule_rounded;
    } else if (isPassed) {
      return Icons.check_circle_rounded;
    } else {
      return _getPrayerIcon(widget.prayer.type);
    }
  }

  Map<String, Color> _getIconColors(bool useGradient, List<Color> gradient, bool isPassed) {
    if (widget.prayer.isNext) {
      return {
        'icon': Colors.white,
        'background': Colors.white.withValues(alpha: 0.25),
        'border': Colors.white.withValues(alpha: 0.4),
      };
    } else if (isPassed) {
      return {
        'icon': useGradient ? Colors.white : ThemeConstants.success,
        'background': useGradient 
            ? Colors.white.withValues(alpha: 0.25)
            : ThemeConstants.success.withValues(alpha: 0.15),
        'border': useGradient 
            ? Colors.white.withValues(alpha: 0.4)
            : ThemeConstants.success.withValues(alpha: 0.3),
      };
    } else {
      return {
        'icon': useGradient ? Colors.white : gradient[0],
        'background': useGradient 
            ? Colors.white.withValues(alpha: 0.25)
            : gradient[0].withValues(alpha: 0.15),
        'border': useGradient 
            ? Colors.white.withValues(alpha: 0.4)
            : gradient[0].withValues(alpha: 0.3),
      };
    }
  }

  Widget _buildPrayerInfo(BuildContext context, bool useGradient, bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // اسم الصلاة
        Text(
          widget.prayer.nameAr,
          style: context.headlineSmall?.copyWith(
            color: _getTextColor(context, useGradient, isPassed),
            fontWeight: widget.prayer.isNext 
                ? ThemeConstants.bold 
                : ThemeConstants.semiBold,
            shadows: useGradient ? [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ] : null,
          ),
        ),
        
        ThemeConstants.space2.h,
        
        // الاسم بالإنجليزية
        Text(
          widget.prayer.nameEn,
          style: context.bodySmall?.copyWith(
            color: _getTextColor(context, useGradient, isPassed).withValues(alpha: 0.8),
            fontWeight: ThemeConstants.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedTimeSection(BuildContext context, bool useGradient, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: useGradient 
              ? [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.white.withValues(alpha: 0.15),
                ]
              : [
                  gradient[0].withValues(alpha: 0.15),
                  gradient[0].withValues(alpha: 0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.3)
              : gradient[0].withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (useGradient ? Colors.white : gradient[0]).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // الوقت الرئيسي
          Text(
            _formatTime(widget.prayer.time),
            style: context.headlineMedium?.copyWith(
              color: useGradient ? Colors.white : gradient[0],
              fontWeight: ThemeConstants.bold,
              shadows: useGradient ? [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ] : null,
            ),
          ),
          
          // وقت الإقامة (إذا توفر)
          if (widget.prayer.iqamaTime != null) ...[
            ThemeConstants.space1.h,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space2,
                vertical: ThemeConstants.space1,
              ),
              decoration: BoxDecoration(
                color: useGradient 
                    ? Colors.black.withValues(alpha: 0.2)
                    : context.surfaceColor,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
              ),
              child: Text(
                'الإقامة ${_formatTime(widget.prayer.iqamaTime!)}',
                style: context.labelSmall?.copyWith(
                  color: useGradient 
                      ? Colors.white.withValues(alpha: 0.9)
                      : context.textSecondaryColor,
                  fontWeight: ThemeConstants.medium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleCardTap() {
    HapticFeedback.lightImpact();
    // يمكن إضافة وظائف إضافية هنا مثل إظهار تفاصيل الصلاة
  }

  Color _getTextColor(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) return Colors.white;
    if (isPassed) return context.textSecondaryColor;
    return context.textPrimaryColor;
  }

  List<Color> _getGradient(PrayerType type) {
    final baseColor = _getPrayerTypeColor(type);
    return [baseColor, baseColor.darken(0.2)];
  }
  
  Color _getPrayerTypeColor(PrayerType type) {
    return ThemeConstants.getPrayerColor(type.name);
  }

  IconData _getPrayerIcon(PrayerType type) {
    return ThemeConstants.getPrayerIcon(type.name);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}