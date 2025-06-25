// lib/features/home/widgets/category_grid.dart - محسن ومضغوط
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  static const List<CategoryItem> _categories = [
    CategoryItem(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      routeName: '/prayer-times',
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار',
      routeName: '/athkar',
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      routeName: '/qibla',
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة',
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية',
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
          mainAxisSpacing: ThemeConstants.space3,
          crossAxisSpacing: ThemeConstants.space3,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            final category = _categories[index];
            
            return _buildCategoryCard(context, category);
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryItem category) {
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    
    return AppCard(
      type: CardType.normal,
      style: CardStyle.gradient,
      primaryColor: categoryColor,
      onTap: () => _onCategoryTap(category),
      margin: EdgeInsets.zero,
      borderRadius: ThemeConstants.radiusLg,
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الأيقونة
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              categoryIcon,
              color: Colors.white,
              size: 32,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // النص
          Text(
            category.title,
            style: context.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
              fontSize: 16,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animatedPress(
      onTap: () => _onCategoryTap(category),
      scaleFactor: 0.96,
    );
  }
}

class CategoryItem {
  final String id;
  final String title;
  final String? routeName;

  const CategoryItem({
    required this.id,
    required this.title,
    this.routeName,
  });
}