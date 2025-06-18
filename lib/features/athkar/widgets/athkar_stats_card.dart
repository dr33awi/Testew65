// lib/features/athkar/widgets/athkar_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

class AthkarStatsCard extends StatefulWidget {
  final int totalCategories;
  final int completedToday;
  final int streak;
  final VoidCallback? onViewDetails;

  const AthkarStatsCard({
    super.key,
    required this.totalCategories,
    required this.completedToday,
    required this.streak,
    this.onViewDetails,
  });

  @override
  State<AthkarStatsCard> createState() => _AthkarStatsCardState();
}

class _AthkarStatsCardState extends State<AthkarStatsCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _backgroundController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _backgroundController.dispose();
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
        boxShadow: [
          BoxShadow(
            color: ThemeConstants.primary.withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              // الخلفية المتحركة
              _buildAnimatedBackground(),
              
              // المحتوى الرئيسي
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                ),
                child: _buildContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: StatsBackgroundPainter(
              animation: _backgroundAnimation.value,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space5),
      child: Column(
        children: [
          // الرأس
          _buildHeader(context),
          
          ThemeConstants.space5.h,
          
          // الإحصائيات
          _buildStatistics(context),
          
          if (widget.onViewDetails != null) ...[
            ThemeConstants.space5.h,
            
            // زر عرض التفاصيل
            _buildDetailsButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // الأيقونة المتحركة
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // دوائر متحركة في الخلفية
                    ...List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _backgroundAnimation,
                        builder: (context, child) {
                          final offset = _backgroundAnimation.value * 2 * math.pi + index;
                          return Transform.scale(
                            scale: 1.0 + (math.sin(offset) * 0.1),
                            child: Container(
                              width: 60 - (index * 15),
                              height: 60 - (index * 15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2 - (index * 0.05)),
                                  width: 1,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    
                    // الأيقونة الرئيسية
                    const Icon(
                      Icons.insights_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        ThemeConstants.space4.w,
        
        // العنوان والوصف
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إحصائياتك اليوم',
                style: context.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              
              ThemeConstants.space1.h,
              
              Text(
                _getMotivationalMessage(),
                style: context.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // الأذكار المكتملة
          Expanded(
            child: _StatItem(
              icon: Icons.check_circle_rounded,
              value: '${widget.completedToday}/${widget.totalCategories}',
              label: 'أكملت اليوم',
              color: Colors.white,
              showProgress: true,
              progress: widget.totalCategories > 0 
                  ? widget.completedToday / widget.totalCategories 
                  : 0.0,
            ),
          ),
          
          // الفاصل
          Container(
            width: 1,
            height: 60,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          
          // سلسلة الأيام
          Expanded(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.streak > 0 ? _pulseAnimation.value : 1.0,
                  child: _StatItem(
                    icon: Icons.local_fire_department_rounded,
                    value: '${widget.streak}',
                    label: widget.streak == 1 ? 'يوم متتالي' : 'أيام متتالية',
                    color: Colors.white,
                    hasStreak: widget.streak > 0,
                    showGlow: widget.streak > 0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedPress(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onViewDetails!();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: ThemeConstants.space4,
            horizontal: ThemeConstants.space5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: ThemeConstants.iconMd,
                color: ThemeConstants.primary,
              ),
              ThemeConstants.space2.w,
              Text(
                'عرض التفاصيل',
                style: context.titleMedium?.copyWith(
                  color: ThemeConstants.primary,
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
              ThemeConstants.space2.w,
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: ThemeConstants.iconSm,
                color: ThemeConstants.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMotivationalMessage() {
    final completionPercentage = widget.totalCategories > 0 
        ? (widget.completedToday / widget.totalCategories) * 100 
        : 0;
    
    if (completionPercentage == 100) {
      return 'ما شاء الله! أكملت جميع الأذكار اليوم 🎉';
    } else if (completionPercentage >= 75) {
      return 'أحسنت! تقدم ممتاز، أكمل البقية 💪';
    } else if (completionPercentage >= 50) {
      return 'بداية موفقة! استمر في هذا التقدم الرائع 📈';
    } else if (completionPercentage > 0) {
      return 'بداية طيبة، لا تتوقف واستمر في الذكر 🌟';
    } else {
      return 'ابدأ يومك بالأذكار واجعله مباركاً ✨';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool hasStreak;
  final bool showProgress;
  final double progress;
  final bool showGlow;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.hasStreak = false,
    this.showProgress = false,
    this.progress = 0.0,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الأيقونة مع التأثيرات
        Stack(
          alignment: Alignment.center,
          children: [
            // توهج للخطوط المتتالية
            if (showGlow)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              ),
            
            // الأيقونة
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: hasStreak ? ThemeConstants.iconLg : ThemeConstants.iconMd,
              ),
            ),
            
            // شريط التقدم الدائري
            if (showProgress)
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
          ],
        ),
        
        ThemeConstants.space3.h,
        
        // القيمة
        Text(
          value,
          style: context.headlineMedium?.copyWith(
            color: color,
            fontWeight: ThemeConstants.bold,
            fontSize: hasStreak ? 28 : 24,
          ),
        ),
        
        ThemeConstants.space1.h,
        
        // التسمية
        Text(
          label,
          style: context.labelMedium?.copyWith(
            color: color.withValues(alpha: 0.9),
            fontWeight: ThemeConstants.medium,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// رسام الخلفية للإحصائيات
class StatsBackgroundPainter extends CustomPainter {
  final double animation;
  final Color color;

  StatsBackgroundPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // رسم خطوط قطرية متحركة
    for (int i = 0; i < 8; i++) {
      final offset = animation * 50 + (i * 30);
      final startX = -50 + offset;
      final endX = startX + size.height;
      
      paint.color = color.withValues(alpha: 0.3 - (i * 0.03));
      canvas.drawLine(
        Offset(startX, 0),
        Offset(endX, size.height),
        paint,
      );
    }

    // رسم دوائر متحركة للإحصائيات
    for (int i = 0; i < 5; i++) {
      final radius = 25.0 + (i * 15) + (animation * 10);
      final alpha = (1 - (i * 0.15)) * (0.5 - animation * 0.2);
      
      paint.color = color.withValues(alpha: alpha.clamp(0.0, 1.0));
      
      // دوائر في مواقع مختلفة
      canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.3),
        radius * 0.5,
        paint,
      );
      
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.7),
        radius * 0.3,
        paint,
      );
    }

    // رسم أشكال إحصائية
    _drawStatShapes(canvas, size, paint);
  }

  void _drawStatShapes(Canvas canvas, Size size, Paint paint) {
    // رسم مخطط بياني مبسط
    final points = [
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.6 + (animation * 30)),
      Offset(size.width * 0.5, size.height * 0.4 - (animation * 20)),
      Offset(size.width * 0.7, size.height * 0.5 + (animation * 25)),
      Offset(size.width * 0.9, size.height * 0.3),
    ];
    
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    paint.color = color.withValues(alpha: 0.4);
    canvas.drawPath(path, paint);
    
    // نقاط البيانات
    for (final point in points) {
      canvas.drawCircle(point, 3, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}