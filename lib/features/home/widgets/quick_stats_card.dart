// lib/features/home/widgets/quick_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class QuickStatsCard extends StatefulWidget {
  final int dailyProgress;
  final String? lastReadTime;
  final Function(String) onStatTap;

  const QuickStatsCard({
    super.key,
    required this.dailyProgress,
    required this.lastReadTime,
    required this.onStatTap,
  });

  @override
  State<QuickStatsCard> createState() => _QuickStatsCardState();
}

class _QuickStatsCardState extends State<QuickStatsCard> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.dailyProgress / 100,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutBack,
    ));
    
    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _progressController.forward();
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
      margin: ThemeConstants.space4.horizontal,
      child: Row(
        children: [
          // بطاقة التقدم اليومي
          Expanded(
            flex: 3,
            child: _buildProgressCard(context),
          ),
          
          ThemeConstants.space3.w,
          
          // بطاقات الإحصائيات
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // المفضلة
                _buildStatCard(
                  context: context,
                  icon: ThemeConstants.iconFavorite,
                  label: 'المفضلة',
                  value: '٢٤',
                  gradient: [ThemeConstants.tertiary, ThemeConstants.tertiaryDark],
                  onTap: () => widget.onStatTap('favorites'),
                ),
                
                ThemeConstants.space3.h,
                
                // أيام متتالية
                _buildStatCard(
                  context: context,
                  icon: Icons.local_fire_department,
                  label: 'متتالية',
                  value: '١٥',
                  gradient: [ThemeConstants.warning, ThemeConstants.warningDark],
                  onTap: () => widget.onStatTap('streak'),
                  showPulse: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: ThemeConstants.opacity20),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
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
                widget.onStatTap('daily_progress');
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.primaryColor.withValues(alpha: context.isDarkMode ? ThemeConstants.opacity80 : ThemeConstants.opacity90),
                      context.primaryColor.darken(0.1).withValues(alpha: context.isDarkMode ? ThemeConstants.opacity70 : ThemeConstants.opacity80),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                    width: ThemeConstants.borderLight,
                  ),
                ),
                child: Stack(
                  children: [
                    // نمط زخرفي
                    Positioned(
                      right: -40,
                      top: -40,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: ThemeConstants.opacity5),
                        ),
                      ),
                    ),
                    
                    // المحتوى
                    Padding(
                      padding: const EdgeInsets.all(ThemeConstants.space4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // مؤشر دائري متطور
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // خلفية المؤشر
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Container(
                                    width: 90 + (_pulseAnimation.value * 10),
                                    height: 90 + (_pulseAnimation.value * 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: ThemeConstants.opacity10 - (_pulseAnimation.value * ThemeConstants.opacity5)),
                                    ),
                                  );
                                },
                              ),
                              
                              // المؤشر الدائري
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      painter: CircularProgressPainter(
                                        progress: _progressAnimation.value,
                                        backgroundColor: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                                        progressColor: Colors.white,
                                        strokeWidth: 8,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${(_progressAnimation.value * 100).toInt()}%',
                                              style: context.headlineMedium?.copyWith(
                                                color: Colors.white,
                                                fontWeight: ThemeConstants.bold,
                                              ),
                                            ),
                                            Text(
                                              'إنجاز اليوم',
                                              style: context.bodySmall?.copyWith(
                                                color: Colors.white.withValues(alpha: ThemeConstants.opacity80),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          
                          ThemeConstants.space4.h,
                          
                          // معلومات إضافية
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ThemeConstants.space3,
                              vertical: ThemeConstants.space1_5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: ThemeConstants.iconSm,
                                  color: Colors.white,
                                ),
                                ThemeConstants.space1.w,
                                Text(
                                  'آخر قراءة: ${widget.lastReadTime ?? "غير محدد"}',
                                  style: context.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: ThemeConstants.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradient,
    required VoidCallback onTap,
    bool showPulse = false,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: ThemeConstants.opacity15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                onTap();
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      gradient[0].withValues(alpha: context.isDarkMode ? ThemeConstants.opacity80 : ThemeConstants.opacity90),
                      gradient[1].withValues(alpha: context.isDarkMode ? ThemeConstants.opacity70 : ThemeConstants.opacity80),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                ),
                child: Stack(
                  children: [
                    // نمط زخرفي
                    if (showPulse)
                      Positioned(
                        right: -10,
                        top: -10,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 40 + (_pulseAnimation.value * 10),
                              height: 40 + (_pulseAnimation.value * 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: ThemeConstants.opacity10 - (_pulseAnimation.value * ThemeConstants.opacity5)),
                              ),
                            );
                          },
                        ),
                      ),
                    
                    // المحتوى
                    Padding(
                      padding: const EdgeInsets.all(ThemeConstants.space3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: Colors.white,
                            size: ThemeConstants.iconLg,
                          ),
                          ThemeConstants.space2.h,
                          Text(
                            value,
                            style: context.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                            ),
                          ),
                          Text(
                            label,
                            style: context.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: ThemeConstants.opacity80),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// رسام المؤشر الدائري
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // رسم الخلفية
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // رسم التقدم
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}