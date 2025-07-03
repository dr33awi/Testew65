// lib/features/home/widgets/category_grid.dart
import 'package:athkar_app/features/home/widgets/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Animation<Offset>> _slideAnimations;

  final List<CategoryItem> _categories = [
    CategoryItem(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      subtitle: 'أوقات الصلوات الخمس',
      icon: Icons.mosque,
      gradient: ColorHelper.getCategoryGradient('prayer_times').colors,
      routeName: '/prayer-times',
      pattern: PatternType.mosque,
      progress: 0.8,
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار اليومية',
      subtitle: 'أذكار الصباح والمساء',
      icon: Icons.auto_awesome,
      gradient: ColorHelper.getCategoryGradient('athkar').colors,
      routeName: '/athkar',
      pattern: PatternType.stars,
      progress: 0.6,
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وتدبر',
      icon: Icons.menu_book_rounded,
      gradient: ColorHelper.getCategoryGradient('quran').colors,
      routeName: '/quran',
      pattern: PatternType.quran,
      progress: 0.4,
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الذكية',
      icon: Icons.explore,
      gradient: ColorHelper.getCategoryGradient('qibla').colors,
      routeName: '/qibla',
      pattern: PatternType.compass,
      progress: 1.0,
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      subtitle: 'عداد التسبيح',
      icon: Icons.radio_button_checked,
      gradient: ColorHelper.getCategoryGradient('tasbih').colors,
      routeName: '/tasbih',
      pattern: PatternType.beads,
      progress: 0.9,
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية المأثورة',
      subtitle: 'أدعية من الكتاب والسنة',
      icon: Icons.pan_tool_rounded,
      gradient: ColorHelper.getCategoryGradient('dua').colors,
      routeName: '/dua',
      pattern: PatternType.hands,
      progress: 0.3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controllers = List.generate(_categories.length, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: ThemeConstants.curveSmooth,
      ));
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: ThemeConstants.curveSmooth,
      ));
    }).toList();

    // بدء الحركات بتأخير متدرج
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onCategoryTap(CategoryItem category) {
    HapticFeedback.lightImpact();
    
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
          mainAxisSpacing: ThemeConstants.space4,
          crossAxisSpacing: ThemeConstants.space4,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: ThemeConstants.durationSlow,
              columnCount: 2,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _buildCategoryItem(context, _categories[index], index),
                ),
              ),
            );
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryItem category, int index) {
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _animations[index].value,
          child: SlideTransition(
            position: _slideAnimations[index],
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                boxShadow: [
                  BoxShadow(
                    color: category.gradient[0].withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: category.gradient[1].withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 3,
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
                      onTap: () => _onCategoryTap(category),
                      borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              category.gradient[0].withValues(alpha: 0.9),
                              category.gradient[1].withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // خلفية زخرفية
                            _buildCategoryBackground(category),
                            
                            // المحتوى
                            Padding(
                              padding: const EdgeInsets.all(ThemeConstants.space4),
                              child: _buildCategoryContent(context, category),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryBackground(CategoryItem category) {
    return Positioned.fill(
      child: Stack(
        children: [
          // نمط زخرفي
          Positioned.fill(
            child: CustomPaint(
              painter: CategoryPatternPainter(
                color: Colors.white.withValues(alpha: 0.15),
                pattern: category.pattern,
              ),
            ),
          ),
          
          // تأثير الضوء
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // دوائر صغيرة متحركة
          ...List.generate(3, (index) {
            return Positioned(
              bottom: 20 + (index * 15),
              left: 20 + (index * 20),
              child: Container(
                width: 6 + (index * 2),
                height: 6 + (index * 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.3 - (index * 0.1)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryContent(BuildContext context, CategoryItem category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الأيقونة والتقدم
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // الأيقونة
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                category.icon,
                color: Colors.white,
                size: 32,
              ),
            ),
            
            // مؤشر التقدم الدائري
            SizedBox(
              width: 45,
              height: 45,
              child: Stack(
                children: [
                  // الدائرة الخلفية
                  CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  // دائرة التقدم
                  CircularProgressIndicator(
                    value: category.progress,
                    strokeWidth: 3,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  // النسبة في المنتصف
                  Center(
                    child: Text(
                      '${(category.progress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const Spacer(),
        
        // النصوص
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.title,
              style: context.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            ThemeConstants.space1.h,
            
            Text(
              category.subtitle,
              style: context.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        
        ThemeConstants.space3.h,
        
        // شريط التقدم السفلي
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: category.progress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// نموذج بيانات الفئة المطور
class CategoryItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String? routeName;
  final PatternType pattern;
  final double progress;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.routeName,
    required this.pattern,
    required this.progress,
  });
}

/// أنواع الأنماط الزخرفية المطورة
enum PatternType {
  mosque,
  stars,
  quran,
  compass,
  beads,
  hands,
}

/// رسام الأنماط الزخرفية المطور
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
      ..strokeWidth = 1.5;

    switch (pattern) {
      case PatternType.mosque:
        _drawMosquePattern(canvas, size, paint);
        break;
      case PatternType.stars:
        _drawStarsPattern(canvas, size, paint);
        break;
      case PatternType.quran:
        _drawQuranPattern(canvas, size, paint);
        break;
      case PatternType.compass:
        _drawCompassPattern(canvas, size, paint);
        break;
      case PatternType.beads:
        _drawBeadsPattern(canvas, size, paint);
        break;
      case PatternType.hands:
        _drawHandsPattern(canvas, size, paint);
        break;
    }
  }

  void _drawMosquePattern(Canvas canvas, Size size, Paint paint) {
    // رسم نمط المسجد
    final centerX = size.width * 0.8;
    final centerY = size.height * 0.2;
    
    // رسم قبة
    final path = Path();
    path.addArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: 15),
      math.pi,
      math.pi,
    );
    canvas.drawPath(path, paint);
    
    // رسم مئذنة
    canvas.drawLine(
      Offset(centerX + 20, centerY - 10),
      Offset(centerX + 20, centerY + 20),
      paint,
    );
    
    // رسم هلال
    final crescent = Path();
    crescent.addArc(
      Rect.fromCircle(center: Offset(centerX, centerY - 15), radius: 5),
      0,
      math.pi,
    );
    canvas.drawPath(crescent, paint);
  }

  void _drawStarsPattern(Canvas canvas, Size size, Paint paint) {
    // رسم نجوم متناثرة
    final stars = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.7, size.height * 0.1),
      Offset(size.width * 0.9, size.height * 0.4),
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.9),
    ];
    
    for (final star in stars) {
      _drawStar(canvas, star, 8, paint);
    }
  }

  void _drawQuranPattern(Canvas canvas, Size size, Paint paint) {
    // رسم نمط القرآن (خطوط عربية مزخرفة)
    final path = Path();
    
    // خط منحني يشبه الخط العربي
    path.moveTo(size.width * 0.1, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.1,
      size.width * 0.9, size.height * 0.3,
    );
    
    path.moveTo(size.width * 0.1, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.5,
      size.width * 0.9, size.height * 0.8,
    );
    
    canvas.drawPath(path, paint);
    
    // نقاط زخرفية
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.2 + i * 0.15), size.height * 0.9),
        2,
        paint..style = PaintingStyle.fill,
      );
    }
  }

  void _drawCompassPattern(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width * 0.8, size.height * 0.2);
    
    // رسم البوصلة
    canvas.drawCircle(center, 20, paint);
    
    // رسم الاتجاهات
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final start = Offset(
        center.dx + 12 * math.cos(angle),
        center.dy + 12 * math.sin(angle),
      );
      final end = Offset(
        center.dx + 18 * math.cos(angle),
        center.dy + 18 * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
    
    // إبرة البوصلة
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - 15),
      paint..strokeWidth = 2,
    );
  }

  void _drawBeadsPattern(Canvas canvas, Size size, Paint paint) {
    // رسم نمط حبات المسبحة
    final beadPositions = <Offset>[];
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.6;
    final radius = 25.0;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi / 8);
      beadPositions.add(Offset(
        centerX + radius * math.cos(angle),
        centerY + radius * math.sin(angle),
      ));
    }
    
    // رسم الخيط
    for (int i = 0; i < beadPositions.length; i++) {
      final next = (i + 1) % beadPositions.length;
      canvas.drawLine(beadPositions[i], beadPositions[next], paint);
    }
    
    // رسم الحبات
    for (final pos in beadPositions) {
      canvas.drawCircle(pos, 3, paint..style = PaintingStyle.fill);
    }
  }

  void _drawHandsPattern(Canvas canvas, Size size, Paint paint) {
    // رسم نمط اليدين في الدعاء
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.7;
    
    // يد يسرى
    final leftHand = Path();
    leftHand.moveTo(centerX - 20, centerY);
    leftHand.quadraticBezierTo(centerX - 15, centerY - 20, centerX - 5, centerY - 15);
    leftHand.quadraticBezierTo(centerX - 10, centerY - 5, centerX - 20, centerY);
    
    // يد يمنى  
    final rightHand = Path();
    rightHand.moveTo(centerX + 20, centerY);
    rightHand.quadraticBezierTo(centerX + 15, centerY - 20, centerX + 5, centerY - 15);
    rightHand.quadraticBezierTo(centerX + 10, centerY - 5, centerX + 20, centerY);
    
    canvas.drawPath(leftHand, paint);
    canvas.drawPath(rightHand, paint);
    
    // خطوط الدعاء صاعدة
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(centerX - 5 + i * 5, centerY - 15),
        Offset(centerX - 3 + i * 3, centerY - 25),
        paint..strokeWidth = 1,
      );
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.5;
    
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * math.pi / 5) - math.pi / 2;
      final innerAngle = ((i + 0.5) * 2 * math.pi / 5) - math.pi / 2;
      
      final outerPoint = Offset(
        center.dx + outerRadius * math.cos(outerAngle),
        center.dy + outerRadius * math.sin(outerAngle),
      );
      
      final innerPoint = Offset(
        center.dx + innerRadius * math.cos(innerAngle),
        center.dy + innerRadius * math.sin(innerAngle),
      );
      
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}