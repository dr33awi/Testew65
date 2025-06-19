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

class _CategoryGridState extends State<CategoryGrid> {
  final List<CategoryItem> _categories = [
    CategoryItem(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      subtitle: 'أوقات الصلوات الخمس',
      icon: Icons.mosque,
      gradient: ColorHelper.getCategoryGradient('prayer_times').colors,
      routeName: '/prayer-times',
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار اليومية',
      subtitle: 'أذكار الصباح والمساء',
      icon: Icons.auto_awesome,
      gradient: ColorHelper.getCategoryGradient('athkar').colors,
      routeName: '/athkar',
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وتدبر',
      icon: Icons.menu_book_rounded,
      gradient: ColorHelper.getCategoryGradient('quran').colors,
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الذكية',
      icon: Icons.explore,
      gradient: ColorHelper.getCategoryGradient('qibla').colors,
      routeName: '/qibla',
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      subtitle: 'عداد التسبيح',
      icon: Icons.radio_button_checked,
      gradient: ColorHelper.getCategoryGradient('tasbih').colors,
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية المأثورة',
      subtitle: 'أدعية من الكتاب والسنة',
      icon: Icons.pan_tool_rounded,
      gradient: ColorHelper.getCategoryGradient('dua').colors,
      routeName: '/dua',
    ),
  ];

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
            
            return _buildSimpleCategoryItem(context, _categories[index]);
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildSimpleCategoryItem(BuildContext context, CategoryItem category) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            category.gradient[0].withValues(alpha: 0.9),
            category.gradient[1].withValues(alpha: 0.8),
          ],
        ),
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
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConstants.space4),
                  child: _buildCategoryContent(context, category),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent(BuildContext context, CategoryItem category) {
    return Stack(
      children: [
        // خلفية الهلال والنجوم
        _buildIslamicStarsBackground(),
        
        // المحتوى
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الأيقونة
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: Icon(
                category.icon,
                color: Colors.white,
                size: 32,
              ),
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
            
            // شريط التقدم المضيء
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _getCategoryProgress(category.id),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIslamicStarsBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: IslamicStarsBackgroundPainter(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
    );
  }

  double _getCategoryProgress(String categoryId) {
    // قيم وهمية للتقدم - يجب استبدالها ببيانات حقيقية
    switch (categoryId) {
      case 'prayer_times':
        return 0.9;
      case 'athkar':
        return 0.7;
      case 'quran':
        return 0.5;
      case 'qibla':
        return 1.0;
      case 'tasbih':
        return 0.8;
      case 'dua':
        return 0.4;
      default:
        return 0.6;
    }
  }
}

/// نموذج بيانات الفئة البسيط
class CategoryItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String? routeName;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.routeName,
  });
}

/// رسام خلفية النجوم
class IslamicStarsBackgroundPainter extends CustomPainter {
  final Color color;

  IslamicStarsBackgroundPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // رسم النجوم المتناثرة بكثرة
    _drawRandomStars(canvas, size, paint);
  }

  void _drawRandomStars(Canvas canvas, Size size, Paint paint) {
    // مواقع النجوم العشوائية الكثيرة (30 نجمة)
    final starPositions = [
      // الصف الأول
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.25, size.height * 0.08),
      Offset(size.width * 0.4, size.height * 0.12),
      Offset(size.width * 0.6, size.height * 0.18),
      Offset(size.width * 0.75, size.height * 0.05),
      Offset(size.width * 0.9, size.height * 0.22),
      
      // الصف الثاني
      Offset(size.width * 0.05, size.height * 0.35),
      Offset(size.width * 0.2, size.height * 0.28),
      Offset(size.width * 0.35, size.height * 0.32),
      Offset(size.width * 0.55, size.height * 0.38),
      Offset(size.width * 0.7, size.height * 0.25),
      Offset(size.width * 0.85, size.height * 0.42),
      Offset(size.width * 0.95, size.height * 0.48),
      
      // الصف الثالث
      Offset(size.width * 0.08, size.height * 0.55),
      Offset(size.width * 0.3, size.height * 0.52),
      Offset(size.width * 0.45, size.height * 0.58),
      Offset(size.width * 0.65, size.height * 0.62),
      Offset(size.width * 0.8, size.height * 0.55),
      Offset(size.width * 0.92, size.height * 0.68),
      
      // الصف الرابع
      Offset(size.width * 0.12, size.height * 0.75),
      Offset(size.width * 0.28, size.height * 0.82),
      Offset(size.width * 0.42, size.height * 0.78),
      Offset(size.width * 0.58, size.height * 0.85),
      Offset(size.width * 0.73, size.height * 0.88),
      Offset(size.width * 0.88, size.height * 0.92),
      
      // نجوم إضافية متناثرة
      Offset(size.width * 0.15, size.height * 0.45),
      Offset(size.width * 0.52, size.height * 0.15),
      Offset(size.width * 0.38, size.height * 0.68),
      Offset(size.width * 0.78, size.height * 0.35),
      Offset(size.width * 0.18, size.height * 0.92),
    ];
    
    // رسم النجوم الخماسية بأحجام مختلفة
    for (int i = 0; i < starPositions.length; i++) {
      // تنويع أحجام النجوم (3-7 بكسل)
      final starSize = 3.0 + (i % 5);
      
      // رسم نجمة خماسية كلاسيكية
      _drawFivePointStar(canvas, starPositions[i], starSize, paint);
    }
  }

  void _drawFivePointStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;
    
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