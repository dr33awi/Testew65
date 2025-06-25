// lib/features/home/widgets/simple_category_grid.dart - شبكة فئات بسيطة بدون Slivers
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class SimpleCategoryGrid extends StatefulWidget {
  const SimpleCategoryGrid({super.key});

  @override
  State<SimpleCategoryGrid> createState() => _SimpleCategoryGridState();
}

class _SimpleCategoryGridState extends State<SimpleCategoryGrid> 
    with TickerProviderStateMixin {
  
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;
  
  static const List<CategoryItem> _categories = [
    CategoryItem(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      subtitle: 'أوقات الصلوات الخمس',
      routeName: '/prayer-times',
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار',
      subtitle: 'أذكار الصباح والمساء',
      routeName: '/athkar',
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وحفظ',
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الإسلامية',
      routeName: '/qibla',
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة',
      subtitle: 'تسبيح رقمي',
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية',
      subtitle: 'أدعية مأثورة',
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

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();

    // بدء الانيميشن تدريجياً
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
    for (var controller in _controllers) {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        final childAspectRatio = _getChildAspectRatio(constraints.maxWidth);
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: ThemeConstants.space3,
            crossAxisSpacing: ThemeConstants.space3,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            
            return AnimatedBuilder(
              animation: Listenable.merge([
                _scaleAnimations[index],
                _fadeAnimations[index],
              ]),
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimations[index],
                  child: ScaleTransition(
                    scale: _scaleAnimations[index],
                    child: _buildCategoryCard(context, category, index),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 2;
  }

  double _getChildAspectRatio(double width) {
    if (width > 900) return 1.1;
    if (width > 600) return 1.0;
    return 0.95;
  }

  Widget _buildCategoryCard(BuildContext context, CategoryItem category, int index) {
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final gradientColors = [
      categoryColor,
      categoryColor.darken(0.2),
    ];
    
    return GestureDetector(
      onTap: () => _onCategoryTap(category),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: -3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          child: Stack(
            children: [
              // الخلفية المتدرجة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors.map((c) => 
                      c.withValues(alpha: 0.9)
                    ).toList(),
                  ),
                ),
              ),
              
              // الطبقة الزجاجية
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),
              
              // المحتوى
              Padding(
                padding: const EdgeInsets.all(ThemeConstants.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الأيقونة
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.25),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        categoryIcon,
                        color: Colors.white,
                        size: 28,
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
                            fontSize: 18,
                            height: 1.2,
                            letterSpacing: 0.3,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 6),
                        
                        if (category.subtitle != null)
                          Text(
                            category.subtitle!,
                            style: context.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                              fontWeight: ThemeConstants.medium,
                              height: 1.4,
                              letterSpacing: 0.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: ThemeConstants.space3),
                    
                    // مؤشر الانتقال
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 24,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                        
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // تأثير الهوفر للتفاعل
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onCategoryTap(category),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  highlightColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              
              // عناصر زخرفية
              _buildDecorativeElements(categoryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeElements(Color categoryColor) {
    return Positioned.fill(
      child: Stack(
        children: [
          // دائرة زخرفية صغيرة
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          
          // خط زخرفي
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              width: 30,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? routeName;

  const CategoryItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.routeName,
  });
}