// lib/features/athkar/widgets/athkar_progress_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

class AthkarProgressBar extends StatefulWidget {
  final int progress;
  final Color color;
  final int completedCount;
  final int totalCount;

  const AthkarProgressBar({
    super.key,
    required this.progress,
    required this.color,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  State<AthkarProgressBar> createState() => _AthkarProgressBarState();
}

class _AthkarProgressBarState extends State<AthkarProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: ThemeConstants.durationExtraSlow,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress / 100,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: ThemeConstants.curveSmooth,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
  }

  @override
  void didUpdateWidget(AthkarProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress / 100,
        end: widget.progress / 100,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: ThemeConstants.curveSmooth,
      ));
      _progressController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          colors: [
            widget.color.withValues(alpha: 0.05),
            widget.color.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            ),
            child: Stack(
              children: [
                // خلفية متحركة
                _buildAnimatedBackground(),
                
                // المحتوى الرئيسي
                Padding(
                  padding: const EdgeInsets.all(ThemeConstants.space5),
                  child: Column(
                    children: [
                      // الرأس
                      _buildHeader(context),
                      
                      ThemeConstants.space4.h,
                      
                      // شريط التقدم المحسن
                      _buildProgressBar(context),
                      
                      ThemeConstants.space4.h,
                      
                      // الإحصائيات
                      _buildStatistics(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: ProgressBackgroundPainter(
              animation: _pulseAnimation.value,
              color: widget.color.withValues(alpha: 0.1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // أيقونة التقدم
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_pulseAnimation.value * 0.1),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.2),
                      widget.color.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: widget.color,
                  size: ThemeConstants.iconLg,
                ),
              ),
            );
          },
        ),
        
        ThemeConstants.space4.w,
        
        // معلومات التقدم
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'التقدم الإجمالي',
                style: context.titleLarge?.copyWith(
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              ThemeConstants.space1.h,
              Text(
                'استمر في التقدم والأجر',
                style: context.bodyMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        
        // النسبة المئوية
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            final currentProgress = (_progressAnimation.value * 100).round();
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space4,
                vertical: ThemeConstants.space3,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.color.withValues(alpha: 0.9),
                    widget.color.darken(0.1).withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '$currentProgress%',
                    style: context.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                  Text(
                    'مكتمل',
                    style: context.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: ThemeConstants.medium,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      children: [
        // معلومات التقدم
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم الحالي',
              style: context.labelMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                final currentProgress = (_progressAnimation.value * 100).round();
                return Text(
                  '$currentProgress% مكتمل',
                  style: context.labelMedium?.copyWith(
                    color: widget.color,
                    fontWeight: ThemeConstants.semiBold,
                  ),
                );
              },
            ),
          ],
        ),
        
        ThemeConstants.space3.h,
        
        // شريط التقدم المتقدم
        Container(
          height: 16,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: Stack(
            children: [
              // الخلفية مع تدرج خفيف
              Container(
                height: 16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.isDarkMode 
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                ),
              ),
              
              // شريط التقدم المتحرك
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                      minHeight: 16,
                    ),
                  );
                },
              ),
              
              // تأثير لمعان متحرك
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: -50 + (_pulseAnimation.value * (MediaQuery.of(context).size.width + 100)),
                    child: Container(
                      width: 50,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.4),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_rounded,
            label: 'مكتمل',
            value: '${widget.completedCount}',
            color: ThemeConstants.success,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Expanded(
          child: _StatCard(
            icon: Icons.pending_rounded,
            label: 'متبقي',
            value: '${widget.totalCount - widget.completedCount}',
            color: ThemeConstants.warning,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Expanded(
          child: _StatCard(
            icon: Icons.list_rounded,
            label: 'الكل',
            value: '${widget.totalCount}',
            color: widget.color,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: ThemeConstants.iconMd,
            ),
          ),
          
          ThemeConstants.space2.h,
          
          Text(
            value,
            style: context.titleLarge?.copyWith(
              color: color,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          ThemeConstants.space1.h,
          
          Text(
            label,
            style: context.labelMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// رسام الخلفية للتقدم
class ProgressBackgroundPainter extends CustomPainter {
  final double animation;
  final Color color;

  ProgressBackgroundPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // رسم دوائر متحركة تمثل التقدم
    for (int i = 0; i < 4; i++) {
      final radius = 40.0 + (i * 25) + (animation * 15);
      final alpha = (1 - (i * 0.2)) * (0.6 - animation * 0.2);
      
      paint.color = color.withValues(alpha: alpha.clamp(0.0, 1.0));
      
      // دوائر في مواقع مختلفة
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

    // رسم أشكال هندسية للتقدم
    _drawProgressShapes(canvas, size, paint);
  }

  void _drawProgressShapes(Canvas canvas, Size size, Paint paint) {
    // رسم خطوط متدرجة تمثل التقدم
    final path = Path();
    
    // خط متموج يمثل التقدم
    path.moveTo(size.width * 0.1, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.4 + (animation * 20),
      size.width * 0.5, size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.7, size.height * 0.8 - (animation * 20),
      size.width * 0.9, size.height * 0.6,
    );
    
    paint.color = color.withValues(alpha: 0.4);
    canvas.drawPath(path, paint);
    
    // نقاط تقدم متحركة
    final positions = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.7),
    ];

    for (int i = 0; i < positions.length; i++) {
      final offset = math.sin(animation * 2 * math.pi + i * math.pi) * 5;
      canvas.drawCircle(
        positions[i] + Offset(offset, offset),
        3 + (animation * 2),
        paint..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}