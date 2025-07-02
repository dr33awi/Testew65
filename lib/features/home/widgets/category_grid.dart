// lib/features/home/widgets/category_grid.dart - محدث بالكامل للنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';

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
      id: 'morning',
      title: 'أذكار الصباح',
      subtitle: 'ابدأ يومك بالذكر',
      routeName: '/athkar/morning',
    ),
    CategoryItem(
      id: 'evening',
      title: 'أذكار المساء',
      subtitle: 'اختتم يومك بالذكر',
      routeName: '/athkar/evening',
    ),
    CategoryItem(
      id: 'sleep',
      title: 'أذكار النوم',
      subtitle: 'نم بسلام وطمأنينة',
      routeName: '/athkar/sleep',
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

  void _onCategoryTap(BuildContext context, CategoryItem category) {
    HapticFeedback.lightImpact();
    
    if (category.routeName != null) {
      Navigator.pushNamed(context, category.routeName!).catchError((error) {
        if (context.mounted) {
          context.showInfoSnackBar( // ✅ استخدام Extension
            category.isDevelopment 
                ? 'هذه الميزة قيد التطوير' 
                : 'خطأ في فتح ${category.title}',
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
        final crossAxisCount = context.responsiveColumns( // ✅ استخدام Extension
          mobile: 2, 
          tablet: 3, 
          desktop: 4,
        );
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: ThemeConstants.space3,
            crossAxisSpacing: ThemeConstants.space3,
            childAspectRatio: _getChildAspectRatio(context),
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

  double _getChildAspectRatio(BuildContext context) {
    if (context.isDesktop) return 1.1; // ✅ استخدام Extension
    if (context.isTablet) return 1.0;   // ✅ استخدام Extension
    return 0.95;
  }

  Widget _buildCategoryCard(BuildContext context, CategoryItem category) {
    // استخدام النظام الموحد الكامل
    return AppCard.glassCategory( // ✅ استخدام AppCard الموحد
      title: category.title,
      icon: category.id.themeCategoryIcon, // ✅ استخدام Extension
      primaryColor: category.id.themeColor, // ✅ استخدام Extension
      onTap: () => _onCategoryTap(context, category),
      padding: _getCardPadding(context),
    ).animatedPress( // ✅ استخدام Extension
      onTap: () => _onCategoryTap(context, category),
      scaleFactor: 0.95,
    );
  }

  EdgeInsets _getCardPadding(BuildContext context) {
    if (context.isDesktop) return ThemeConstants.space5.all; // ✅ استخدام Extension
    if (context.isTablet) return ThemeConstants.space4.all;   // ✅ استخدام Extension
    return ThemeConstants.space3.all;
  }
}

class CategoryItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? routeName;
  final bool isDevelopment;

  const CategoryItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.routeName,
    this.isDevelopment = true, // معظم الميزات قيد التطوير
  });
}