// lib/features/prayer_times/widgets/prayer_time_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
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
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: isNext ? _pulseAnimation.value : 1.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              boxShadow: [
                BoxShadow(
                  color: useGradient 
                      ? gradient[0].withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: useGradient ? 20 : 10,
                  offset: const Offset(0, 8),
                  spreadRadius: useGradient ? 2 : 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showPrayerDetails(context),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  child: Stack(
                    children: [
                      // الخلفية المتدرجة أو العادية
                      _buildCardBackground(useGradient, gradient, isPassed),
                      
                      // الخلفية المتحركة للصلاة القادمة
                      if (isNext) _buildAnimatedBackground(),
                      
                      // الحد اللامع للصلاة القادمة
                      if (isNext) _buildGlowBorder(gradient[0]),
                      
                      // المحتوى الرئيسي
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: useGradient 
                                ? Colors.white.withValues(alpha: 0.2)
                                : context.dividerColor.withValues(alpha: 0.2),
                            width: useGradient ? 1 : 1,
                          ),
                          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                        ),
                        child: _buildCardContent(context, useGradient, gradient, isPassed),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardBackground(bool useGradient, List<Color> gradient, bool isPassed) {
    if (useGradient) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient.map((c) => c.withValues(alpha: 0.9)).toList(),
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
          color: isPassed 
              ? context.cardColor.darken(0.02) 
              : context.cardColor,
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        ),
      );
    }
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: PrayerBackgroundPainter(
          animation: _glowAnimation.value,
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildGlowBorder(Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.4 + (_glowAnimation.value * 0.3),
          ),
          width: 2,
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
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
        children: [
          // أيقونة الحالة
          _buildStatusIcon(context, useGradient, gradient, isPassed),
          
          ThemeConstants.space4.w,
          
          // معلومات الصلاة
          Expanded(
            child: _buildPrayerInfo(context, useGradient, isPassed),
          ),
          
          ThemeConstants.space4.w,
          
          // الوقت
          _buildTimeSection(context, useGradient, gradient),
          
          ThemeConstants.space3.w,
          
          // زر التنبيه
          _buildNotificationToggle(context, useGradient),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(
    BuildContext context, 
    bool useGradient, 
    List<Color> gradient, 
    bool isPassed
  ) {
    IconData icon;
    Color iconColor;
    Color backgroundColor;
    
    if (widget.prayer.isNext) {
      icon = Icons.access_time_filled;
      iconColor = Colors.white;
      backgroundColor = Colors.white.withValues(alpha: 0.2);
    } else if (isPassed) {
      icon = Icons.check_circle_rounded;
      iconColor = useGradient ? Colors.white : ThemeConstants.success;
      backgroundColor = useGradient 
          ? Colors.white.withValues(alpha: 0.2)
          : ThemeConstants.success.withValues(alpha: 0.1);
    } else {
      icon = _getPrayerIcon(widget.prayer.type);
      iconColor = useGradient ? Colors.white : gradient[0];
      backgroundColor = useGradient 
          ? Colors.white.withValues(alpha: 0.2)
          : gradient[0].withValues(alpha: 0.1);
    }
    
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.3)
              : gradient[0].withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: useGradient ? [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ] : [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: ThemeConstants.iconLg,
      ),
    );
  }

  Widget _buildPrayerInfo(BuildContext context, bool useGradient, bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // اسم الصلاة
        Text(
          widget.prayer.nameAr,
          style: context.titleLarge?.copyWith(
            color: _getTextColor(context, useGradient, isPassed),
            fontWeight: widget.prayer.isNext 
                ? ThemeConstants.bold 
                : ThemeConstants.semiBold,
          ),
        ),
        
        ThemeConstants.space1.h,
        
        // معلومات إضافية
        if (widget.prayer.isNext)
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space2,
                  vertical: ThemeConstants.space1,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: ThemeConstants.iconXs,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    ThemeConstants.space1.w,
                    Text(
                      widget.prayer.remainingTimeText,
                      style: context.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: ThemeConstants.medium,
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        else if (isPassed)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space2,
              vertical: ThemeConstants.space1,
            ),
            decoration: BoxDecoration(
              color: useGradient 
                  ? Colors.white.withValues(alpha: 0.2)
                  : ThemeConstants.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: ThemeConstants.iconXs,
                  color: useGradient 
                      ? Colors.white.withValues(alpha: 0.9)
                      : ThemeConstants.success,
                ),
                ThemeConstants.space1.w,
                Text(
                  'انتهى الوقت',
                  style: context.labelSmall?.copyWith(
                    color: useGradient 
                        ? Colors.white.withValues(alpha: 0.9)
                        : ThemeConstants.success,
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            "متبقي " + _formatTime(widget.prayer.time),
            style: context.bodySmall?.copyWith(
              color: _getTextColor(context, useGradient, isPassed).withValues(alpha: 0.8),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeSection(BuildContext context, bool useGradient, List<Color> gradient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // الوقت الرئيسي
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            color: useGradient 
                ? Colors.white.withValues(alpha: 0.2)
                : gradient[0].withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: useGradient 
                  ? Colors.white.withValues(alpha: 0.3)
                  : gradient[0].withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            _formatTime(widget.prayer.time),
            style: context.headlineSmall?.copyWith(
              color: useGradient ? Colors.white : gradient[0],
              fontWeight: ThemeConstants.bold,
            ),
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
                    ? Colors.white.withValues(alpha: 0.8)
                    : context.textSecondaryColor,
                fontWeight: ThemeConstants.medium,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationToggle(BuildContext context, bool useGradient) {
    return Container(
      decoration: BoxDecoration(
        color: useGradient 
            ? Colors.white.withValues(alpha: 0.15)
            : context.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.3)
              : context.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onNotificationToggle(true);
        },
        icon: Icon(
          Icons.notifications_outlined,
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.8)
              : context.textSecondaryColor,
        ),
        tooltip: 'تنبيه الصلاة',
      ),
    );
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

  void _showPrayerDetails(BuildContext context) {
    HapticFeedback.lightImpact();
    
    AppInfoDialog.show(
      context: context,
      title: widget.prayer.nameAr,
      content: 'وقت ${widget.prayer.nameAr}: ${_formatTime(widget.prayer.time)}',
      subtitle: widget.prayer.isPassed 
          ? 'انتهى وقت الصلاة' 
          : widget.prayer.remainingTimeText,
      icon: _getPrayerIcon(widget.prayer.type),
      accentColor: _getGradient(widget.prayer.type)[0],
      actions: [
        DialogAction(
          label: 'إعدادات الصلاة',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/prayer-settings');
          },
          isPrimary: true,
        ),
      ],
    );
  }
  
  void onNotificationToggle(bool bool) {}
}

/// رسام الخلفية للصلاة
class PrayerBackgroundPainter extends CustomPainter {
  final double animation;
  final Color color;

  PrayerBackgroundPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // رسم دوائر متحركة تمثل أمواج الصلاة
    for (int i = 0; i < 4; i++) {
      final radius = 25.0 + (i * 15) + (animation * 8);
      final alpha = (1 - (i * 0.2)) * (0.8 - animation * 0.4);
      
      paint.color = color.withValues(alpha: alpha.clamp(0.0, 1.0));
      
      // دوائر في الزوايا
      canvas.drawCircle(
        Offset(size.width * 0.15, size.height * 0.2),
        radius * 0.6,
        paint,
      );
      
      canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.8),
        radius * 0.4,
        paint,
      );
    }

    // رسم أشكال إسلامية بسيطة
    _drawIslamicElements(canvas, size, paint);
  }

  void _drawIslamicElements(Canvas canvas, Size size, Paint paint) {
    // رسم نجوم إسلامية صغيرة
    final positions = [
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.2, size.height * 0.7),
    ];

    for (int i = 0; i < positions.length; i++) {
      final offset = math.sin(animation * 2 * math.pi + i * math.pi) * 2;
      _drawSimpleStar(
        canvas,
        positions[i] + Offset(offset, offset),
        6,
        paint..color = color.withValues(alpha: 0.5),
      );
    }
  }

  void _drawSimpleStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 6;
    final double angle = 2 * math.pi / points;

    for (int i = 0; i < points; i++) {
      final outerAngle = i * angle - math.pi / 2;
      final innerAngle = (i + 0.5) * angle - math.pi / 2;

      final outerX = center.dx + radius * math.cos(outerAngle);
      final outerY = center.dy + radius * math.sin(outerAngle);

      final innerX = center.dx + (radius * 0.6) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.6) * math.sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }

      path.lineTo(innerX, innerY);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}