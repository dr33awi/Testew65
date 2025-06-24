// lib/features/home/widgets/category_grid.dart - مُصحح
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart'; // ✅ الاستيراد الموحد الوحيد

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
      icon: Icons.mosque,
      routeName: '/prayer-times',
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار اليومية',
      icon: Icons.auto_awesome,
      routeName: '/athkar',
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      icon: Icons.menu_book_rounded,
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      icon: Icons.explore,
      routeName: '/qibla',
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      icon: Icons.radio_button_checked,
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية المأثورة',
      icon: Icons.pan_tool_rounded,
      routeName: '/dua',
    ),
  ];

  void _onCategoryTap(CategoryItem category) {
    HapticFeedback.lightImpact();
    
    if (category.routeName != null) {
      Navigator.pushNamed(context, category.routeName!).catchError((error) {
        if (mounted) {
          // ✅ استخدام AppSnackBar من app_theme
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
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            return _CategoryCard(
              category: _categories[index],
              onTap: () => _onCategoryTap(_categories[index]),
            );
          },
          childCount: _categories.length,
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ استخدام CategoryHelper من app_theme
    final gradient = CategoryHelper.getCategoryGradientWithOpacity(
      context, 
      category.id,
      opacity: 0.9,
    );
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConstants.space4),
                  child: _buildContent(context, categoryIcon),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, IconData categoryIcon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الأيقونة مع دائرة
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Icon(
              categoryIcon,
              color: Colors.white,
              size: 42,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // النص الرئيسي
          Text(
            category.title,
            style: context.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
              fontSize: 16,
              shadows: [
                const Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// نموذج بيانات الفئة
class CategoryItem {
  final String id;
  final String title;
  final IconData icon;
  final String? routeName;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.icon,
    this.routeName,
  });
}