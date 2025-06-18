// lib/features/athkar/widgets/athkar_category_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/animations/animated_press.dart';
import '../models/athkar_model.dart';
import '../utils/category_utils.dart';

class AthkarCategoryCard extends StatefulWidget {
  final AthkarCategory category;
  final int progress;
  final VoidCallback onTap;

  const AthkarCategoryCard({
    super.key,
    required this.category,
    required this.progress,
    required this.onTap,
  });

  @override
  State<AthkarCategoryCard> createState() => _AthkarCategoryCardState();
}

class _AthkarCategoryCardState extends State<AthkarCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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
    final isCompleted = widget.progress >= 100;
    final categoryColor = CategoryUtils.getCategoryThemeColor(widget.category.id);
    final categoryIcon = CategoryUtils.getCategoryIcon(widget.category.id);
    final description = CategoryUtils.getCategoryDescription(widget.category.id);
    
    return AnimatedPress(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      scaleFactor: 0.95,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor.withValues(alpha: 0.9),
              categoryColor.darken(0.1).withValues(alpha: 0.9),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Stack(
              children: [
                // الخلفية المتحركة
                _buildAnimatedBackground(categoryColor),
                
                // الحد اللامع للبطاقات المكتملة
                if (isCompleted) _buildGlowBorder(),
                
                // المحتوى الرئيسي
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(ThemeConstants.space4),
                    child: _buildCardContent(
                      context,
                      categoryIcon,
                      description,
                      isCompleted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(Color categoryColor) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: CategoryBackgroundPainter(
              animation: _glowAnimation.value,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlowBorder() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.5 + (_glowAnimation.value * 0.3),
              ),
              width: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(
    BuildContext context,
    IconData categoryIcon,
    String description,
    bool isCompleted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الأيقونة
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            categoryIcon,
            color: Colors.white,
            size: ThemeConstants.iconLg,
          ),
        ),
        
        const Spacer(),
        
        // النصوص والتقدم
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الفئة
            Text(
              widget.category.title,
              style: context.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
                fontSize: 18,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            ThemeConstants.space1.h,
            
            // الوصف
            Text(
              description,
              style: context.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            ThemeConstants.space3.h,
            
            // شريط التقدم والمعلومات
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // شريط التقدم
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: widget.progress / 100,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                      
                      ThemeConstants.space2.h,
                      
                      // معلومات التقدم
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                                  Icons.format_list_numbered_rounded,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  size: ThemeConstants.iconXs,
                                ),
                                ThemeConstants.space1.w,
                                Text(
                                  '${widget.category.athkar.length} ذكر',
                                  style: context.labelSmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 11,
                                    fontWeight: ThemeConstants.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // دائرة التقدم
                          _buildProgressCircle(context, isCompleted),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCircle(BuildContext context, bool isCompleted) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الخلفية
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ),
          
          // دائرة التقدم
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              value: widget.progress / 100,
              strokeWidth: 3,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          
          // النسبة المئوية أو أيقونة الإكمال
          if (isCompleted)
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_glowAnimation.value * 0.1),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                );
              },
            )
          else
            Text(
              '${widget.progress}%',
              style: context.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}

/// رسام الخلفية للفئة
class CategoryBackgroundPainter extends CustomPainter {
  final double animation;
  final Color color;

  CategoryBackgroundPainter({
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
    final double angle = 2 * math.pi / points;

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