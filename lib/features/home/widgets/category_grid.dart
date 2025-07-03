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
      child: Container(),
    );
  }

  Widget _buildCategoryContent(BuildContext context, CategoryItem category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        
        // شريط التقدم السفلي مكتمل
        Container(
          height: 4,
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

  const CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.routeName,
  });
}