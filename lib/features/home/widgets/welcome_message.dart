// lib/features/home/widgets/welcome_message.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

class WelcomeMessage extends StatefulWidget {
  const WelcomeMessage({super.key});

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _iconAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );
    
    _iconAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveOvershoot,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveSmooth,
    ));
    
    _iconRotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.linear,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(hour);
    final message = _getMessage(hour);
    final icon = _getIcon(hour);
    final gradient = _getGradientColors(hour);
    
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  boxShadow: [
                    BoxShadow(
                      color: gradient[0].withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(ThemeConstants.space5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient.map((c) => c.withOpacity(0.8)).toList(),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // نمط زخرفي في الخلفية
                          Positioned(
                            right: -20,
                            top: -20,
                            child: _buildDecorativePattern(),
                          ),
                          
                          // المحتوى
                          Row(
                            children: [
                              // الأيقونة المتحركة
                              _buildAnimatedIcon(icon, gradient),
                              
                              ThemeConstants.space4.w,
                              
                              // النصوص
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      greeting,
                                      style: context.headlineSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: ThemeConstants.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.3),
                                            offset: const Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ThemeConstants.space1.h,
                                    Text(
                                      message,
                                      style: context.bodyLarge?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.4,
                                      ),
                                    ),
                                    ThemeConstants.space2.h,
                                    _buildTimeDisplay(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, List<Color> gradient) {
    return AnimatedBuilder(
      animation: _iconRotationAnimation,
      builder: (context, child) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // خلفية دائرية متحركة
              Transform.rotate(
                angle: _iconRotationAnimation.value,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                ),
              ),
              
              // الأيقونة
              Icon(
                icon,
                color: Colors.white,
                size: ThemeConstants.iconXl,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeDisplay() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
        final dateStr = _getArabicDate(now);
        
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space3,
                vertical: ThemeConstants.space1,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: ThemeConstants.iconSm,
                  ),
                  ThemeConstants.space1.w,
                  Text(
                    timeStr,
                    style: context.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                ],
              ),
            ),
            ThemeConstants.space2.w,
            Text(
              dateStr,
              style: context.labelMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDecorativePattern() {
    return Container(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: IslamicStarPainter(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 5) {
      return 'أهلاً بك في قيام الليل';
    } else if (hour < 12) {
      return 'صباح الخير والبركة';
    } else if (hour < 17) {
      return 'مساء النور';
    } else if (hour < 20) {
      return 'مساء الخير';
    } else {
      return 'أمسية مباركة';
    }
  }

  String _getMessage(int hour) {
    if (hour < 5) {
      return 'وقت مبارك لقيام الليل والدعاء';
    } else if (hour < 10) {
      return 'لا تنس أذكار الصباح وصلاة الضحى';
    } else if (hour < 14) {
      return 'وقت مناسب لقراءة القرآن والذكر';
    } else if (hour < 17) {
      return 'حان وقت أذكار المساء';
    } else if (hour < 20) {
      return 'وقت الدعاء والاستغفار';
    } else {
      return 'لا تنس أذكار النوم والوتر';
    }
  }

  IconData _getIcon(int hour) {
    if (hour < 5) {
      return Icons.nights_stay;
    } else if (hour < 12) {
      return Icons.wb_sunny;
    } else if (hour < 17) {
      return Icons.wb_twilight;
    } else if (hour < 20) {
      return Icons.wb_twilight_sharp;
    } else {
      return Icons.nightlight_round;
    }
  }

  List<Color> _getGradientColors(int hour) {
    if (hour < 5) {
      return [ThemeConstants.primaryDark, ThemeConstants.darkCard]; // ليل
    } else if (hour < 8) {
      return [ThemeConstants.primary, ThemeConstants.primaryLight]; // فجر
    } else if (hour < 12) {
      return [ThemeConstants.accent, ThemeConstants.accentLight]; // صباح
    } else if (hour < 17) {
      return [ThemeConstants.primaryLight, ThemeConstants.primarySoft]; // ظهر
    } else if (hour < 20) {
      return [ThemeConstants.tertiary, ThemeConstants.tertiaryLight]; // مغرب
    } else {
      return [ThemeConstants.primaryDark, ThemeConstants.primary]; // ليل
    }
  }

  String _getArabicDate(DateTime date) {
    const arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    const arabicDays = [
      'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'
    ];
    
    final dayName = arabicDays[date.weekday % 7];
    final day = date.day;
    final month = arabicMonths[date.month - 1];
    
    return '$dayName، $day $month';
  }
}

// رسام النجمة الإسلامية
class IslamicStarPainter extends CustomPainter {
  final Color color;

  IslamicStarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // رسم نجمة ثمانية
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      
      // نقطة داخلية
      final innerAngle = angle + math.pi / 8;
      final innerX = center.dx + (radius * 0.5) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.5) * math.sin(innerAngle);
      path.lineTo(innerX, innerY);
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}