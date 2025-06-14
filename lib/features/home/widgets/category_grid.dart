// lib/features/home/widgets/category_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      gradient: [ThemeConstants.primaryDark, ThemeConstants.primary],
      routeName: AppRouter.prayerTimes,
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار',
      subtitle: 'أذكار الصباح والمساء',
      icon: ThemeConstants.iconAthkar,
      gradient: [ThemeConstants.primary, ThemeConstants.primaryLight],
      routeName: AppRouter.athkar,
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وحفظ وتدبر',
      icon: Icons.book,
      gradient: [ThemeConstants.info, ThemeConstants.info.darken(0.2)],
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الذكية',
      icon: ThemeConstants.iconQibla,
      gradient: [ThemeConstants.warning, ThemeConstants.warning.darken(0.2)],
      routeName: AppRouter.qibla,
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      subtitle: 'عداد التسبيح الذكي',
      icon: Icons.radio_button_checked,
      gradient: [ThemeConstants.success, ThemeConstants.success.darken(0.2)],
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية',
      subtitle: 'أدعية من القرآن والسنة',
      icon: Icons.pan_tool,
      gradient: [ThemeConstants.primaryLight, ThemeConstants.primary],
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
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: ThemeConstants.durationNormal,
              child: SlideAnimation(
                verticalOffset: 30.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: ThemeConstants.space3.bottom,
                    child: _buildCategoryItem(
                      context,
                      _categories[index],
                      index,
                    ),
                  ),
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
    final isSelected = _selectedIndex == index;
    
    return AnimatedScale(
      scale: isSelected ? 0.95 : 1.0,
      duration: ThemeConstants.durationFast,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: category.gradient,
          ),
          boxShadow: [
            BoxShadow(
              color: category.gradient[0].withValues(alpha: ThemeConstants.opacity30),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: InkWell(
            onTap: () => _onCategoryTap(category, index),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            child: Container(
              padding: ThemeConstants.space3.all,
              child: Row(
                children: [
                  // الأيقونة الرئيسية
                  Container(
                    width: 60,
                    height: 60,
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
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      category.icon,
                      color: Colors.white,
                      size: ThemeConstants.iconLg,
                    ),
                  ),
                  
                  ThemeConstants.space4.w,
                  
                  // المعلومات
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: context.titleMedium?.copyWith(
                            fontWeight: ThemeConstants.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        ThemeConstants.space1.h,
                        
                        Text(
                          category.subtitle,
                          style: context.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: ThemeConstants.opacity70),
                          ),
                        ),
                        
                        ThemeConstants.space2.h,
                        
                        // شريط التقدم
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: ThemeConstants.opacity50),
                                blurRadius: 4,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // رمز السهم
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: ThemeConstants.iconSm,
                      color: Colors.white,
                    ),
                  ),
                ],
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