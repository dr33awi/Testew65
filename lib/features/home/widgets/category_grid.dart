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

class _CategoryGridState extends State<CategoryGrid> {
  late final LoggerService _logger;

  final List<CategoryItem> _categories = [
    CategoryItem(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      icon: Icons.mosque,
      gradient: [ThemeConstants.primary, ThemeConstants.primaryLight],
      routeName: AppRouter.prayerTimes,
      pattern: PatternType.geometric,
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار',
      icon: Icons.auto_awesome,
      gradient: [ThemeConstants.accent, ThemeConstants.accentLight],
      routeName: AppRouter.athkar,
      pattern: PatternType.floral,
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      icon: Icons.book,
      gradient: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
      routeName: '/quran',
      pattern: PatternType.calligraphy,
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      icon: Icons.navigation,
      gradient: [ThemeConstants.primaryDark, ThemeConstants.primary],
      routeName: AppRouter.qibla,
      pattern: PatternType.compass,
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      icon: Icons.radio_button_checked,
      gradient: [ThemeConstants.accentDark, ThemeConstants.accent],
      routeName: '/tasbih',
      pattern: PatternType.circular,
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية',
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
  }

  void _onCategoryTap(CategoryItem category) {
    HapticFeedback.lightImpact();
    
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
          childAspectRatio: 1.3,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            return _buildCategoryItem(
              context,
              _categories[index],
            );
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryItem category) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: category.gradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onCategoryTap(category),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
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
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
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
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // المحتوى
                    Padding(
                      padding: const EdgeInsets.all(ThemeConstants.space3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // الأيقونة بدون أنيميشن
                          Container(
                            width: 50,
                            height: 50,
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
                            child: Icon(
                              category.icon,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          
                          ThemeConstants.space2.h,
                          
                          // العنوان
                          Text(
                            category.title,
                            style: context.titleMedium?.copyWith(
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          ThemeConstants.space2.h,
                          
                          // مؤشر التقدم المكتمل
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: const Offset(0, 0),
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
}

// نموذج بيانات الفئة
class CategoryItem {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final String? routeName;
  final PatternType pattern;

  const CategoryItem({
    required this.id,
    required this.title,
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
    canvas.drawCircle(center, 20, paint);
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2);
      final start = Offset(
        center.dx + 10 * math.cos(angle),
        center.dy + 10 * math.sin(angle),
      );
      final end = Offset(
        center.dx + 20 * math.cos(angle),
        center.dy + 20 * math.sin(angle),
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