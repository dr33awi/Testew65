// lib/features/home/widgets/category_grid.dart - محدث بالنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// ✅ استيراد النظام الموحد
import '../../../app/themes/app_theme.dart';

class SimpleCategoryGrid extends StatelessWidget {
  const SimpleCategoryGrid({super.key});

  static const List<CategoryItem> _categories = [
    CategoryItem(
      id: 'اوقات_الصلاة',
      title: 'مواقيت الصلاة',
      subtitle: 'أوقات الصلوات الخمس',
      routeName: '/prayer-times',
    ),
    CategoryItem(
      id: 'الاذكار',
      title: 'الأذكار',
      subtitle: 'أذكار الصباح والمساء',
      routeName: '/athkar',
    ),
    CategoryItem(
      id: 'القبلة',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الإسلامية',
      routeName: '/qibla',
    ),
    CategoryItem(
      id: 'التسبيح',
      title: 'المسبحة',
      subtitle: 'تسبيح رقمي',
      routeName: '/tasbih',
    ),
  ];

  void _onCategoryTap(BuildContext context, CategoryItem category) {
    HapticFeedback.lightImpact();
    
    if (category.routeName != null) {
      Navigator.pushNamed(context, category.routeName!).catchError((error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('هذه الميزة قيد التطوير'),
              backgroundColor: AppTheme.warning,
              shape: RoundedRectangleBorder(
                borderRadius: AppTheme.radiusMd.radius,
              ),
            ),
          );
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
            mainAxisSpacing: AppTheme.space3,
            crossAxisSpacing: AppTheme.space3,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return _buildCategoryCard(context, category, constraints.maxWidth);
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

  // تحديد أحجام النصوص حسب عرض الشاشة
  double _getTitleFontSize(double screenWidth) {
    if (screenWidth > 900) return 24;
    if (screenWidth > 600) return 22;
    if (screenWidth > 400) return 20;
    return 18;
  }

  double _getSubtitleFontSize(double screenWidth) {
    if (screenWidth > 900) return 18;
    if (screenWidth > 600) return 16;
    if (screenWidth > 400) return 15;
    return 14;
  }

  double _getIconSize(double screenWidth) {
    if (screenWidth > 900) return 36;
    if (screenWidth > 600) return 32;
    if (screenWidth > 400) return 30;
    return 28;
  }

  double _getIconContainerSize(double screenWidth) {
    if (screenWidth > 900) return 72;
    if (screenWidth > 600) return 64;
    if (screenWidth > 400) return 60;
    return 56;
  }

  EdgeInsets _getCardPadding(double screenWidth) {
    if (screenWidth > 900) return AppTheme.space6.padding;
    if (screenWidth > 600) return AppTheme.space5.padding;
    if (screenWidth > 400) return AppTheme.space4.padding;
    return AppTheme.space3.padding;
  }

  Widget _buildCategoryCard(BuildContext context, CategoryItem category, double screenWidth) {
    final categoryColor = context.getCategoryColor(category.id);
    final categoryIcon = _getCategoryIcon(category.id);
    
    return GestureDetector(
      onTap: () => _onCategoryTap(context, category),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppTheme.radiusLg.radius,
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
          borderRadius: AppTheme.radiusLg.radius,
          child: Stack(
            children: [
              // الخلفية المتدرجة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      categoryColor,
                      categoryColor.darken(0.2),
                    ].map((c) => c.withValues(alpha: 0.9)).toList(),
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
                padding: _getCardPadding(screenWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الأيقونة
                    Container(
                      width: _getIconContainerSize(screenWidth),
                      height: _getIconContainerSize(screenWidth),
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
                        size: _getIconSize(screenWidth),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // النصوص
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: context.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.bold,
                            fontSize: _getTitleFontSize(screenWidth),
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
                        
                        SizedBox(height: screenWidth > 400 ? 6 : 4),
                        
                        if (category.subtitle != null)
                          Text(
                            category.subtitle!,
                            style: context.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: _getSubtitleFontSize(screenWidth),
                              fontWeight: AppTheme.medium,
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

                    SizedBox(height: screenWidth > 400 ? AppTheme.space2 : AppTheme.space1),
                  ],
                ),
              ),
              
              // تأثير الهوفر للتفاعل
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onCategoryTap(context, category),
                  borderRadius: AppTheme.radiusLg.radius,
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  highlightColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'اوقات_الصلاة':
        return Icons.access_time;
      case 'الاذكار':
        return Icons.auto_stories;
      case 'القبلة':
        return Icons.explore;
      case 'التسبيح':
        return Icons.auto_awesome;
      default:
        return Icons.apps;
    }
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