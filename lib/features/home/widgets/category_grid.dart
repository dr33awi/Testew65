// lib/features/home/widgets/category_grid.dart - محدث لاستخدام AppCard
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/cards/app_card.dart';

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
            
            final category = _categories[index];
            final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
            final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
            
            // إنشاء تدرج مباشر من اللون الأساسي
            final gradientColors = [
              categoryColor,
              categoryColor.darken(0.3),
            ];
            
            return AppCard(
              type: CardType.normal,
              style: CardStyle.gradient,
              title: category.title,
              icon: categoryIcon,
              primaryColor: categoryColor,
              gradientColors: gradientColors,
              onTap: () => _onCategoryTap(category),
              margin: EdgeInsets.zero,
              child: _buildCategoryContent(context, category, categoryIcon),
            );
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryContent(BuildContext context, CategoryItem category, IconData categoryIcon) {
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
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
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
              shadows: const [
                Shadow(
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