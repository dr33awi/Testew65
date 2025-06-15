// lib/features/home/widgets/category_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> with TickerProviderStateMixin {
  late final LoggerService _logger;
  final List<AnimationController> _animationControllers = [];
  final List<Animation<double>> _scaleAnimations = [];
  int _selectedIndex = -1;

  final List<CategoryItem> _categories = [
    CategoryItem(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      subtitle: 'أوقات الصلوات الخمس',
      icon: Icons.mosque,
      gradient: [ThemeConstants.primary, ThemeConstants.primaryLight],
      routeName: AppRouter.prayerTimes,
      pattern: PatternType.geometric,
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار',
      subtitle: 'أذكار الصباح والمساء',
      icon: Icons.auto_awesome,
      gradient: [ThemeConstants.accent, ThemeConstants.accentLight],
      routeName: AppRouter.athkar,
      pattern: PatternType.floral,
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وحفظ وتدبر',
      icon: Icons.book,
      gradient: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
      routeName: '/quran',
      pattern: PatternType.calligraphy,
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الذكية',
      icon: Icons.navigation,
      gradient: [ThemeConstants.primaryDark, ThemeConstants.primary],
      routeName: AppRouter.qibla,
      pattern: PatternType.compass,
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      subtitle: 'عداد التسبيح الذكي',
      icon: Icons.radio_button_checked,
      gradient: [ThemeConstants.accentDark, ThemeConstants.accent],
      routeName: '/tasbih',
      pattern: PatternType.circular,
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية',
      subtitle: 'أدعية من القرآن والسنة',
      icon: Icons.pan_tool,
      gradient: [ThemeConstants.tertiaryDark, ThemeConstants.tertiary],
      routeName: '/dua',
      pattern: PatternType.arabesque,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _logger = context.getService<LoggerService>();
    
    // إنشاء متحكمات الحركة لكل بطاقة
    for (int i = 0; i < _categories.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 600 + (i * 100)),
        vsync: this,
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: ThemeConstants.curveOvershoot,
      ));
      
      _animationControllers.add(controller);
      _scaleAnimations.add(animation);
      
      // بدء الحركة بتأخير تدريجي
      Future.delayed(Duration(milliseconds: 100 * i), () {
        if (mounted) {
          controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onCategoryTap(CategoryItem category, int index) {
    HapticFeedback.lightImpact();
    
    setState(() {
      _selectedIndex = index;
    });
    
    // حركة النقر
    _animationControllers[index].reverse().then((_) {
      _animationControllers[index].forward();
    });
    
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _selectedIndex = -1;
        });
      }
    });
    
    _logger.logEvent('category_tapped', parameters: {
      'category_id': category.id,
      'category_title': category.title,
    });
    
    if (category.routeName != null) {
      Navigator.pushNamed(context, category.routeName!).catchError((error) {
        if (mounted) {
          context.showWarningSnackBar('هذه الميزة قيد التطوير');
        }
        return null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ThemeConstants.space3,
          crossAxisSpacing: ThemeConstants.space3,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            return AnimatedBuilder(
              animation: _scaleAnimations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimations[index].value,
                  child: _buildCategoryItem(
                    context,
                    _categories[index],
                    index,
                  ),
                );
              },
            );
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryItem category, int index) {
    final isSelected = _selectedIndex == index;
    
    return AnimatedContainer(
      duration: ThemeConstants.durationNormal,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(isSelected ? 0.05 : 0.0)
        ..rotateY(isSelected ? -0.05 : 0.0)
        ..scale(isSelected ? 0.95 : 1.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          boxShadow: [
            BoxShadow(
              color: category.gradient[0].withOpacity(0.3),
              blurRadius: isSelected ? 15 : 20,
              offset: Offset(0, isSelected ? 5 : 10),
              spreadRadius: isSelected ? -5 : -5,
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
                onTap: () => _onCategoryTap(category, index),
                borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        category.gradient[0].withOpacity(0.9),
                        category.gradient[1].withOpacity(0.8),
                      ],
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
                      Positioned.fill(
                        child: CustomPaint(
                          painter: CategoryPatternPainter(
                            color: Colors.white.withOpacity(0.1),
                            pattern: category.pattern,
                          ),
                        ),
                      ),
                      
                      // تأثير الإضاءة
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // المحتوى
                      Padding(
                        padding: const EdgeInsets.all(ThemeConstants.space4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // الأيقونة
                            _buildCategoryIcon(category, index),
                            
                            ThemeConstants.space3.h,
                            
                            // العنوان
                            Text(
                              category.title,
                              style: context.titleLarge?.copyWith(
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
                              textAlign: TextAlign.center,
                            ),
                            
                            ThemeConstants.space1.h,
                            
                            // الوصف
                            Text(
                              category.subtitle,
                              style: context.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            ThemeConstants.space3.h,
                            
                            // مؤشر التقدم أو الحالة
                            _buildCategoryIndicator(category),
                          ],
                        ),
                      ),
                      
                      // أيقونة السهم
                      Positioned(
                        bottom: ThemeConstants.space3,
                        left: ThemeConstants.space3,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(CategoryItem category, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // حلقة دائرية متحركة
              CustomPaint(
                size: const Size(70, 70),
                painter: CircularProgressPainter(
                  progress: value,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              
              // الأيقونة
              Icon(
                category.icon,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryIndicator(CategoryItem category) {
    // يمكن استخدام هذا لعرض معلومات إضافية مثل عدد الأذكار المقروءة
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7, // نسبة الإنجاز المؤقتة
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(),
          ),
        ],
      ),
    );
  }
}

// نموذج بيانات الفئة
class CategoryItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String? routeName;
  final PatternType pattern;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.routeName,
    required this.pattern,
  });
}

// أنواع الأنماط الزخرفية
enum PatternType {
  geometric,
  floral,
  calligraphy,
  compass,
  circular,
  arabesque,
}

// رسام الأنماط الزخرفية
class CategoryPatternPainter extends CustomPainter {
  final Color color;
  final PatternType pattern;

  CategoryPatternPainter({
    required this.color,
    required this.pattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    switch (pattern) {
      case PatternType.geometric:
        _drawGeometricPattern(canvas, size, paint);
        break;
      case PatternType.floral:
        _drawFloralPattern(canvas, size, paint);
        break;
      case PatternType.calligraphy:
        _drawCalligraphyPattern(canvas, size, paint);
        break;
      case PatternType.compass:
        _drawCompassPattern(canvas, size, paint);
        break;
      case PatternType.circular:
        _drawCircularPattern(canvas, size, paint);
        break;
      case PatternType.arabesque:
        _drawArabesquePattern(canvas, size, paint);
        break;
    }
  }

  void _drawGeometricPattern(Canvas canvas, Size size, Paint paint) {
    final spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: 20, height: 20),
          paint,
        );
      }
    }
  }

  void _drawFloralPattern(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width * 0.8, size.height * 0.2);
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final petalCenter = Offset(
        center.dx + 20 * math.cos(angle),
        center.dy + 20 * math.sin(angle),
      );
      canvas.drawCircle(petalCenter, 10, paint);
    }
  }

  void _drawCalligraphyPattern(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    path.moveTo(size.width * 0.7, size.height * 0.1);
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.2,
      size.width * 0.9, size.height * 0.1,
    );
    canvas.drawPath(path, paint);
  }

  void _drawCompassPattern(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width * 0.8, size.height * 0.3);
    canvas.drawCircle(center, 25, paint);
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);
      final start = Offset(
        center.dx + 15 * math.cos(angle),
        center.dy + 15 * math.sin(angle),
      );
      final end = Offset(
        center.dx + 25 * math.cos(angle),
        center.dy + 25 * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  void _drawCircularPattern(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width * 0.2, size.height * 0.8);
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, i * 10.0, paint);
    }
  }

  void _drawArabesquePattern(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final centerX = size.width * 0.2;
    final centerY = size.height * 0.2;
    
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3);
      path.moveTo(centerX, centerY);
      path.arcTo(
        Rect.fromCircle(
          center: Offset(
            centerX + 20 * math.cos(angle),
            centerY + 20 * math.sin(angle),
          ),
          radius: 15,
        ),
        0,
        math.pi,
        false,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// رسام مؤشر التقدم الدائري
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}