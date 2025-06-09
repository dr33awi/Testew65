// lib/features/home/widgets/category_grid.dart
// تصميم مبتكر - نمط Timeline مع تدرجات ديناميكية متناسقة

import 'package:athkar_app/app/themes/core/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/themes/app_theme.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../app/di/service_locator.dart';
import '../../../../core/infrastructure/services/logging/logger_service.dart';

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
      icon: Icons.mosque,
      gradient: [Color(0xFF1A237E), Color(0xFF303F9F)], // تدرج ازرق داكن متناسق مع الفجر
      routeName: AppRouter.prayerTimes,
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار',
      subtitle: 'أذكار الصباح والمساء',
      icon: Icons.auto_awesome,
      gradient: [Color(0xFF00897B), Color(0xFF26A69A)], // تدرج اخضر متناسق مع العصر
      routeName: AppRouter.athkar,
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وحفظ وتدبر',
      icon: Icons.book,
      gradient: [Color(0xFF4A148C), Color(0xFF7B1FA2)], // تدرج بنفسجي متناسق مع العشاء
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الذكية',
      icon: Icons.navigation,
      gradient: [Color(0xFFE65100), Color(0xFFF57C00)], // تدرج برتقالي متناسق مع المغرب
      routeName: AppRouter.qibla,
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      subtitle: 'عداد التسبيح الذكي',
      icon: Icons.radio_button_checked,
      gradient: [Color(0xFFFF6F00), Color(0xFFFF9800)], // تدرج برتقالي متناسق مع الظهر
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية',
      subtitle: 'أدعية من القرآن والسنة',
      icon: Icons.pan_tool,
      gradient: [Color(0xFF0277BD), Color(0xFF039BE5)], // تدرج ازرق متناسق مع مواقيت الصلاة
      routeName: '/dua',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _logger = context.getService<LoggerService>();
  }

  void _onCategoryTap(CategoryItem category, int index) {
    HapticFeedback.lightImpact();
    
    setState(() {
      _selectedIndex = index;
    });
    
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _selectedIndex = -1;
      });
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
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            return Padding(
              padding: EdgeInsets.only(bottom: ThemeConstants.space3),
              child: _buildCategoryItem(
                context,
                _categories[index],
                index,
              ),
            );
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryItem category, int index) {
    final isDark = context.isDarkMode;
    final isSelected = _selectedIndex == index;
    
    return AnimatedScale(
      scale: isSelected ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: category.gradient,
          ),
          boxShadow: [
            BoxShadow(
              color: category.gradient[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: () => _onCategoryTap(category, index),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.all(ThemeConstants.space3),
              child: Row(
                children: [
                  // الأيقونة الرئيسية - تصميم محسن
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      category.icon,
                      color: Colors.white,
                      size: 28,
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
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        
                        ThemeConstants.space2.h,
                        
                        // تحسين شريط التقدم ليتناسق مع التصميم العام
                        Container(
                          height: 4,
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
                      ],
                    ),
                  ),
                  
                  // رمز السهم - محسن للتناسق
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
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