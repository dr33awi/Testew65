// lib/features/home/widgets/category_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import 'color_helper.dart';

/// شبكة الفئات المحسنة والمبسطة
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  // البيانات الثابتة للفئات
  static const List<_CategoryData> _categories = [
    _CategoryData(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      subtitle: 'أوقات الصلوات الخمس',
      icon: Icons.mosque,
      routeName: '/prayer-times',
      progress: 0.9,
    ),
    _CategoryData(
      id: 'athkar',
      title: 'الأذكار اليومية',
      subtitle: 'أذكار الصباح والمساء',
      icon: Icons.auto_awesome,
      routeName: '/athkar',
      progress: 0.7,
    ),
    _CategoryData(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وتدبر',
      icon: Icons.menu_book_rounded,
      routeName: '/quran',
      progress: 0.5,
    ),
    _CategoryData(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الذكية',
      icon: Icons.explore,
      routeName: '/qibla',
      progress: 1.0,
    ),
    _CategoryData(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      subtitle: 'عداد التسبيح',
      icon: Icons.radio_button_checked,
      routeName: '/tasbih',
      progress: 0.8,
    ),
    _CategoryData(
      id: 'dua',
      title: 'الأدعية المأثورة',
      subtitle: 'أدعية من الكتاب والسنة',
      icon: Icons.pan_tool_rounded,
      routeName: '/dua',
      progress: 0.4,
    ),
  ];

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
            return _CategoryCard(category: _categories[index]);
          },
          childCount: _categories.length,
        ),
      ),
    );
  }
}

/// بطاقة الفئة المحسنة
class _CategoryCard extends StatelessWidget {
  final _CategoryData category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final gradient = ColorHelper.getCategoryGradient(category.id);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        boxShadow: [
          BoxShadow(
            color: gradient.colors[0].withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onCategoryTap(context),
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    gradient.colors[0].withValues(alpha: 0.9),
                    gradient.colors[1].withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        // خلفية النجوم
        const Positioned.fill(
          child: _StarsBackground(),
        ),
        
        // المحتوى الرئيسي
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الأيقونة
            _buildIcon(),
            
            const Spacer(),
            
            // النصوص
            _buildTexts(),
            
            ThemeConstants.space3.h,
            
            // شريط التقدم
            _buildProgressBar(),
          ],
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
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
            color: Colors.white.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        category.icon,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Widget _buildTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: ThemeConstants.textSizeLg,
            fontWeight: ThemeConstants.bold,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(0, 2),
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
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: ThemeConstants.textSizeSm,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
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
    );
  }

  void _onCategoryTap(BuildContext context) {
    HapticFeedback.lightImpact();
    
    if (category.routeName != null) {
      Navigator.pushNamed(context, category.routeName!).catchError((error) {
        if (context.mounted) {
          context.showWarningSnackBar('هذه الميزة قيد التطوير');
        }
        return null;
      });
    }
  }
}

/// خلفية النجوم المحسنة
class _StarsBackground extends StatelessWidget {
  const _StarsBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarsBackgroundPainter(
        color: Colors.white.withValues(alpha: 0.15),
      ),
      size: Size.infinite,
    );
  }
}

/// رسام خلفية النجوم المحسن
class _StarsBackgroundPainter extends CustomPainter {
  final Color color;

  _StarsBackgroundPainter({required this.color});

  // مواقع النجوم المحددة مسبقاً للأداء
  static const List<Offset> _starPositions = [
    Offset(0.1, 0.15), Offset(0.25, 0.08), Offset(0.4, 0.12),
    Offset(0.6, 0.18), Offset(0.75, 0.05), Offset(0.9, 0.22),
    Offset(0.05, 0.35), Offset(0.2, 0.28), Offset(0.35, 0.32),
    Offset(0.55, 0.38), Offset(0.7, 0.25), Offset(0.85, 0.42),
    Offset(0.95, 0.48), Offset(0.08, 0.55), Offset(0.3, 0.52),
    Offset(0.45, 0.58), Offset(0.65, 0.62), Offset(0.8, 0.55),
    Offset(0.92, 0.68), Offset(0.12, 0.75), Offset(0.28, 0.82),
    Offset(0.42, 0.78), Offset(0.58, 0.85), Offset(0.73, 0.88),
    Offset(0.88, 0.92), Offset(0.15, 0.45), Offset(0.52, 0.15),
    Offset(0.38, 0.68), Offset(0.78, 0.35), Offset(0.18, 0.92),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // رسم النجوم بأحجام متنوعة
    for (int i = 0; i < _starPositions.length; i++) {
      final position = Offset(
        _starPositions[i].dx * size.width,
        _starPositions[i].dy * size.height,
      );
      
      // تنويع حجم النجوم (3-7 بكسل)
      final starSize = 3.0 + (i % 5);
      
      _drawStar(canvas, position, starSize, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;
    
    // رسم نجمة خماسية محسنة
    const int points = 5;
    final double angleStep = (2 * 3.14159) / points;
    
    for (int i = 0; i < points; i++) {
      final outerAngle = (i * angleStep) - (3.14159 / 2);
      final innerAngle = ((i + 0.5) * angleStep) - (3.14159 / 2);
      
      final outerX = center.dx + outerRadius * (outerAngle).cos();
      final outerY = center.dy + outerRadius * (outerAngle).sin();
      
      final innerX = center.dx + innerRadius * (innerAngle).cos();
      final innerY = center.dy + innerRadius * (innerAngle).sin();
      
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// نموذج بيانات الفئة
class _CategoryData {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String? routeName;
  final double progress;

  const _CategoryData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.routeName,
    required this.progress,
  });
}

/// امتداد لحساب الجيب وجيب التمام
extension on double {
  double cos() => math.cos(this);
  double sin() => math.sin(this);
}

// استيراد math للحسابات الرياضية
import 'dart:math' as math;