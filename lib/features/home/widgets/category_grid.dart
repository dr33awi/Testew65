// lib/features/home/widgets/category_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
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
  int _selectedIndex = -1;

  final List<CategoryItem> _categories = [
    CategoryItem(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      subtitle: 'أوقات الصلوات الخمس',
      icon: ThemeConstants.iconPrayer,
      gradient: [ThemeConstants.primary, ThemeConstants.primaryDark],
      routeName: AppRouter.prayerTimes,
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار',
      subtitle: 'أذكار الصباح والمساء',
      icon: ThemeConstants.iconAthkar,
      gradient: [ThemeConstants.secondary, ThemeConstants.secondaryDark],
      routeName: AppRouter.athkar,
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وحفظ وتدبر',
      icon: Icons.book,
      gradient: [ThemeConstants.success, ThemeConstants.successDark],
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الذكية',
      icon: ThemeConstants.iconQibla,
      gradient: [ThemeConstants.tertiary, ThemeConstants.tertiaryDark],
      routeName: AppRouter.qibla,
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      subtitle: 'عداد التسبيح الذكي',
      icon: Icons.radio_button_checked,
      gradient: [ThemeConstants.info, ThemeConstants.infoDark],
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية',
      subtitle: 'أدعية من القرآن والسنة',
      icon: Icons.pan_tool,
      gradient: [ThemeConstants.warning, ThemeConstants.warningDark],
      routeName: '/dua',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _logger = getIt<LoggerService>();
  }

  void _onCategoryTap(CategoryItem category, int index) {
    HapticFeedback.lightImpact();
    
    setState(() {
      _selectedIndex = index;
    });
    
    Future.delayed(ThemeConstants.durationFast, () {
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
      padding: ThemeConstants.space4.horizontal,
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: ThemeConstants.durationNormal,
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.95,
                child: FadeInAnimation(
                  child: _buildCategoryItem(
                    context,
                    _categories[index],
                    index,
                  ),
                ),
              ),
            );
          },
          childCount: _categories.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ThemeConstants.space3,
          crossAxisSpacing: ThemeConstants.space3,
          childAspectRatio: 1.1,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryItem category, int index) {
    final isSelected = _selectedIndex == index;
    
    return AnimatedScale(
      scale: isSelected ? 0.95 : 1.0,
      duration: ThemeConstants.durationFast,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          boxShadow: [
            BoxShadow(
              color: category.gradient[0].withValues(alpha: ThemeConstants.opacity20),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                        category.gradient[0].withValues(alpha: context.isDarkMode ? ThemeConstants.opacity80 : ThemeConstants.opacity90),
                        category.gradient[1].withValues(alpha: context.isDarkMode ? ThemeConstants.opacity70 : ThemeConstants.opacity80),
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
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: ThemeConstants.opacity10),
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
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                                  width: ThemeConstants.borderMedium,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: ThemeConstants.opacity10),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                category.icon,
                                color: Colors.white,
                                size: ThemeConstants.iconLg,
                              ),
                            ),
                            
                            ThemeConstants.space3.h,
                            
                            // العنوان
                            Text(
                              category.title,
                              style: context.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: ThemeConstants.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: ThemeConstants.opacity20),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
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
                                color: Colors.white.withValues(alpha: ThemeConstants.opacity80),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      // مؤشر الحالة
                      if (isSelected)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                              border: Border.all(
                                color: Colors.white,
                                width: ThemeConstants.borderThick,
                              ),
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
}

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