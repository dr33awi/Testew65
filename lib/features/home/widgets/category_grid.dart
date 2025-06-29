// lib/features/home/widgets/category_grid.dart - محدث بالنظام الموحد الإسلامي
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import '../../../app/themes/index.dart';

class SimpleCategoryGrid extends StatelessWidget {
  const SimpleCategoryGrid({super.key});

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
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppTheme.space3,
            crossAxisSpacing: AppTheme.space3,
            childAspectRatio: 0.95,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return _buildCategoryCard(context, category);
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

  Widget _buildCategoryCard(BuildContext context, CategoryItem category) {
    final categoryColor = AppTheme.getCategoryColor(category.id);
    final categoryIcon = _getCategoryIcon(category.id);
    
    return AppCard(
      useGradient: true,
      color: categoryColor,
      onTap: () => _onCategoryTap(context, category),
      useAnimation: true,
      margin: EdgeInsets.zero,
      padding: AppTheme.space4.padding,
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
              boxShadow: AppTheme.shadowSm,
            ),
            child: Icon(
              categoryIcon,
              color: Colors.white,
              size: AppTheme.iconLg,
            ),
          ),
          
          const Spacer(),
          
          // النصوص
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.title,
                style: AppTheme.titleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.bold,
                  fontSize: context.isMobile ? 18 : 20,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              AppTheme.space1.h,
              
              if (category.subtitle != null)
                Text(
                  category.subtitle!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: context.isMobile ? 14 : 15,
                    fontWeight: AppTheme.medium,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          
          AppTheme.space2.h,
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    return AppTheme.getCategoryIcon(categoryId);
  }

  void _onCategoryTap(BuildContext context, CategoryItem category) {
    HapticFeedback.lightImpact();
    
    if (category.routeName != null) {
      Navigator.pushNamed(context, category.routeName!).catchError((error) {
        if (context.mounted) {
          _showWarningSnackBar(context, 'هذه الميزة قيد التطوير');
        }
        return null;
      });
    }
  }

  void _showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: context.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.warning,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
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