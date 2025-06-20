// lib/features/athkar/widgets/athkar_item_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// ✅ استيرادات النظام الموحد الموجود فقط
import '../../../app/themes/index.dart';

import '../models/athkar_model.dart';

class AthkarItemCard extends StatefulWidget {
  final AthkarItem item;
  final int currentCount;
  final bool isCompleted;
  final int number;
  final Color? color;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onShare;

  const AthkarItemCard({
    super.key,
    required this.item,
    required this.currentCount,
    required this.isCompleted,
    required this.number,
    this.color,
    required this.onTap,
    required this.onLongPress,
    this.onFavoriteToggle,
    this.onShare,
  });

  @override
  State<AthkarItemCard> createState() => _AthkarItemCardState();
}

class _AthkarItemCardState extends State<AthkarItemCard>
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
      end: 1.02,
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
    final effectiveColor = widget.color ?? ThemeConstants.primary;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isCompleted ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            onLongPress: () {
              HapticFeedback.mediumImpact();
              widget.onLongPress();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                gradient: widget.isCompleted 
                    ? LinearGradient(
                        colors: [
                          effectiveColor.withValues(alpha: 0.9),
                          effectiveColor.darken(0.1).withValues(alpha: 0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: !widget.isCompleted ? context.cardColor : null,
                boxShadow: widget.isCompleted ? [
                  BoxShadow(
                    color: effectiveColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: 2,
                  ),
                ] : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                child: Stack(
                  children: [
                    // الخلفية المتحركة للبطاقات المكتملة
                    if (widget.isCompleted) _buildAnimatedBackground(),
                    
                    // الحد اللامع للبطاقات المكتملة
                    if (widget.isCompleted) _buildGlowBorder(effectiveColor),
                    
                    // المحتوى الرئيسي
                    _buildCardContent(context, effectiveColor),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: AthkarBackgroundPainter(
          animation: _glowAnimation.value,
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildGlowBorder(Color effectiveColor) {
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

  Widget _buildCardContent(BuildContext context, Color effectiveColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isCompleted 
              ? Colors.white.withValues(alpha: 0.2)
              : context.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الرأس
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رقم الذكر
                _buildNumberBadge(context, effectiveColor),
                
                SizedBox(width: context.mediumPadding),
                
                // محتوى الذكر
                Expanded(
                  child: _buildMainContent(context, effectiveColor),
                ),
              ],
            ),
            
            SizedBox(height: context.mediumPadding),
            
            // الفوتر
            _buildFooter(context, effectiveColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberBadge(BuildContext context, Color effectiveColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: widget.isCompleted
            ? LinearGradient(
                colors: [effectiveColor.lighten(0.1), effectiveColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: !widget.isCompleted ? effectiveColor.withValues(alpha: 0.1) : null,
        shape: BoxShape.circle,
        border: Border.all(
          color: effectiveColor.withValues(alpha: widget.isCompleted ? 0.6 : 0.3),
          width: widget.isCompleted ? 2 : 1.5,
        ),
        boxShadow: widget.isCompleted ? [
          BoxShadow(
            color: effectiveColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Center(
        child: widget.isCompleted
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: ThemeConstants.iconMd,
              )
            : Text(
                '${widget.number}',
                style: context.titleStyle.copyWith(
                  color: effectiveColor,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, Color effectiveColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // النص الرئيسي
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ThemeConstants.spaceMd),
          decoration: BoxDecoration(
            gradient: widget.isCompleted 
                ? LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  )
                : null,
            color: !widget.isCompleted 
                ? context.isDarkMode 
                    ? effectiveColor.withValues(alpha: 0.08)
                    : effectiveColor.withValues(alpha: 0.05)
                : null,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            border: Border.all(
              color: widget.isCompleted
                  ? Colors.white.withValues(alpha: 0.2)
                  : effectiveColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            widget.item.text,
            style: context.bodyStyle.copyWith(
              fontSize: 18,
              height: 2.0,
              fontFamily: ThemeConstants.fontArabic,
              color: widget.isCompleted 
                  ? Colors.white
                  : context.textColor,
              fontWeight: widget.isCompleted 
                  ? ThemeConstants.fontMedium 
                  : ThemeConstants.fontRegular,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // الفضل
        if (widget.item.fadl != null) ...[
          SizedBox(height: context.mediumPadding),
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spaceMd),
            decoration: BoxDecoration(
              gradient: widget.isCompleted
                  ? LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    )
                  : null,
              color: !widget.isCompleted
                  ? ThemeConstants.accent.withValues(alpha: 0.08)
                  : null,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              border: Border.all(
                color: widget.isCompleted
                    ? Colors.white.withValues(alpha: 0.2)
                    : ThemeConstants.accent.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.spaceXs),
                  decoration: BoxDecoration(
                    color: widget.isCompleted
                        ? Colors.white.withValues(alpha: 0.2)
                        : ThemeConstants.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    size: ThemeConstants.iconSm,
                    color: widget.isCompleted
                        ? Colors.white
                        : ThemeConstants.accent,
                  ),
                ),
                SizedBox(width: context.smallPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الفضل',
                        style: context.captionStyle.copyWith(
                          color: widget.isCompleted
                              ? Colors.white.withValues(alpha: 0.9)
                              : ThemeConstants.accent,
                          fontWeight: ThemeConstants.fontSemiBold,
                        ),
                      ),
                      SizedBox(height: context.smallPadding / 2),
                      Text(
                        widget.item.fadl!,
                        style: context.captionStyle.copyWith(
                          color: widget.isCompleted
                              ? Colors.white.withValues(alpha: 0.8)
                              : context.secondaryTextColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter(BuildContext context, Color effectiveColor) {
    return Row(
      children: [
        // المصدر
        if (widget.item.source != null) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.spaceMd,
                vertical: ThemeConstants.spaceSm,
              ),
              decoration: BoxDecoration(
                color: widget.isCompleted
                    ? Colors.white.withValues(alpha: 0.15)
                    : context.secondaryTextColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                border: Border.all(
                  color: widget.isCompleted
                      ? Colors.white.withValues(alpha: 0.2)
                      : context.secondaryTextColor.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.source_rounded,
                    size: ThemeConstants.iconXs,
                    color: widget.isCompleted
                        ? Colors.white.withValues(alpha: 0.8)
                        : context.secondaryTextColor,
                  ),
                  SizedBox(width: context.smallPadding / 2),
                  Flexible(
                    child: Text(
                      widget.item.source!,
                      style: context.captionStyle.copyWith(
                        color: widget.isCompleted
                            ? Colors.white.withValues(alpha: 0.8)
                            : context.secondaryTextColor,
                        fontWeight: ThemeConstants.fontMedium,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: context.mediumPadding),
        ] else
          const Spacer(),
        
        // العداد
        _buildCounter(context, effectiveColor),
        
        // الإجراءات
        if (widget.onShare != null || widget.onFavoriteToggle != null) ...[
          SizedBox(width: context.mediumPadding),
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildCounter(BuildContext context, Color effectiveColor) {
    final progress = widget.currentCount / widget.item.count;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spaceMd,
        vertical: ThemeConstants.spaceSm,
      ),
      decoration: BoxDecoration(
        gradient: widget.isCompleted
            ? LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.15),
                ],
              )
            : null,
        color: !widget.isCompleted ? context.surfaceColor : null,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        border: Border.all(
          color: widget.isCompleted
              ? Colors.white.withValues(alpha: 0.3)
              : context.borderColor,
        ),
        boxShadow: widget.isCompleted ? [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // أيقونة التقدم
          SizedBox(
            width: 24,
            height: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // دائرة الخلفية
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isCompleted
                          ? Colors.white.withValues(alpha: 0.3)
                          : context.borderColor.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                ),
                
                // دائرة التقدم
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isCompleted ? Colors.white : effectiveColor,
                    ),
                  ),
                ),
                
                // أيقونة الحالة
                if (widget.isCompleted)
                  const Icon(
                    Icons.check_rounded,
                    size: 12,
                    color: Colors.white,
                  )
                else if (widget.currentCount > 0)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: effectiveColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(width: context.smallPadding),
          
          // النص
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.currentCount} / ${widget.item.count}',
                style: context.captionStyle.copyWith(
                  color: widget.isCompleted 
                      ? Colors.white 
                      : context.textColor,
                  fontWeight: widget.isCompleted 
                      ? ThemeConstants.fontBold 
                      : ThemeConstants.fontMedium,
                ),
              ),
              if (!widget.isCompleted && widget.currentCount > 0)
                Text(
                  'اضغط للمتابعة',
                  style: context.captionStyle.copyWith(
                    color: widget.isCompleted
                        ? Colors.white.withValues(alpha: 0.7)
                        : context.secondaryTextColor,
                    fontSize: 9,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.onFavoriteToggle != null) ...[
          _ActionButton(
            icon: Icons.favorite_outline_rounded,
            onTap: widget.onFavoriteToggle!,
            tooltip: 'إضافة للمفضلة',
            color: widget.isCompleted
                ? Colors.white.withValues(alpha: 0.8)
                : context.secondaryTextColor,
          ),
        ],
        
        if (widget.onShare != null) ...[
          if (widget.onFavoriteToggle != null) SizedBox(width: context.smallPadding),
          _ActionButton(
            icon: Icons.share_rounded,
            onTap: widget.onShare!,
            tooltip: 'مشاركة',
            color: widget.isCompleted
                ? Colors.white.withValues(alpha: 0.8)
                : context.secondaryTextColor,
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        child: Container(
          padding: const EdgeInsets.all(ThemeConstants.spaceSm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: ThemeConstants.iconSm,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// رسام الخلفية للأذكار
class AthkarBackgroundPainter extends CustomPainter {
  final double animation;
  final Color color;

  AthkarBackgroundPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // رسم دوائر متحركة
    for (int i = 0; i < 3; i++) {
      final radius = 30.0 + (i * 20) + (animation * 10);
      final alpha = (1 - (i * 0.3)) * (0.8 - animation * 0.3);
      
      paint.color = color.withValues(alpha: alpha.clamp(0.0, 1.0));
      
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.2),
        radius,
        paint,
      );
    }

    // رسم أشكال زخرفية
    _drawDecorativeShapes(canvas, size, paint);
  }

  void _drawDecorativeShapes(Canvas canvas, Size size, Paint paint) {
    // رسم نجوم صغيرة متحركة
    final positions = [
      Offset(size.width * 0.15, size.height * 0.25),
      Offset(size.width * 0.85, size.height * 0.75),
      Offset(size.width * 0.25, size.height * 0.85),
    ];

    for (int i = 0; i < positions.length; i++) {
      final offset = math.sin(animation * 2 * math.pi + i) * 3;
      _drawStar(
        canvas,
        positions[i] + Offset(offset, offset),
        4,
        paint..color = color.withValues(alpha: 0.6),
      );
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 5;
    const double angle = 2 * math.pi / points;

    for (int i = 0; i < points; i++) {
      final outerAngle = i * angle - math.pi / 2;
      final innerAngle = (i + 0.5) * angle - math.pi / 2;

      final outerX = center.dx + radius * math.cos(outerAngle);
      final outerY = center.dy + radius * math.sin(outerAngle);

      final innerX = center.dx + (radius * 0.5) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.5) * math.sin(innerAngle);

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