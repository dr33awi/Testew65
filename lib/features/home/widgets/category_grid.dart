// lib/features/home/widgets/category_grid.dart - محدث بالنظام الموحد (بدون description)
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
      title: 'الأذكار اليومية',
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
      title: 'المسبحة الرقمية',
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية المأثورة',
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
          childAspectRatio: 0.9,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            final category = _categories[index];
            
            return _buildCompactCategoryCard(context, category);
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildCompactCategoryCard(BuildContext context, CategoryItem category) {
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    
    return AppCard(
      type: CardType.normal,
      style: CardStyle.gradient,
      primaryColor: categoryColor,
      onTap: () => _onCategoryTap(category),
      margin: EdgeInsets.zero,
      borderRadius: ThemeConstants.radius2xl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الأيقونة الكبيرة - نفس حجم athkar_categories_screen
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              categoryIcon,
              color: Colors.white,
              size: 48,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // النص الكبير - نفس حجم athkar_categories_screen
          Text(
            category.title,
            style: context.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
              fontSize: 20,
              height: 1.3,
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
    ).animatedPress(
      onTap: () => _onCategoryTap(category),
      scaleFactor: 0.97,
    );
  }
}

/// تصميم بديل للشبكة - بطاقات مضغوطة أكثر جاذبية
class CompactCategoryGrid extends StatelessWidget {
  const CompactCategoryGrid({super.key});

  static const List<CategoryItem> _categories = [
    CategoryItem(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      routeName: '/prayer-times',
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار اليومية',
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
      title: 'المسبحة الرقمية',
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية المأثورة',
      routeName: '/dua',
    ),
  ];

  void _onCategoryTap(BuildContext context, CategoryItem category) {
    HapticFeedback.lightImpact();
    
    if (category.routeName != null) {
      Navigator.pushNamed(context, category.routeName!).catchError((error) {
        context.showWarningSnackBar('هذه الميزة قيد التطوير');
        return null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: ThemeConstants.space4,
        crossAxisSpacing: ThemeConstants.space4,
        childAspectRatio: 1.1,
      ),
      itemCount: _categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = _categories[index];
        final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
        final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
        
        return AppCard(
          type: CardType.normal,
          style: CardStyle.gradient,
          primaryColor: categoryColor,
          onTap: () => _onCategoryTap(context, category),
          margin: EdgeInsets.zero,
          borderRadius: ThemeConstants.radius2xl,
          child: _buildCompactContent(context, category, categoryIcon),
        ).animatedPress(
          onTap: () => _onCategoryTap(context, category),
          scaleFactor: 0.95,
        );
      },
    );
  }

  Widget _buildCompactContent(BuildContext context, CategoryItem category, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الأيقونة الكبيرة - محدثة لتطابق athkar_categories_screen
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 48,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // العنوان الكبير - محدث لتطابق athkar_categories_screen
          Text(
            category.title,
            style: context.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
              fontSize: 20,
              height: 1.3,
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

/// شبكة أفقية للفئات (للاستخدام في الصفحة الرئيسية)
class HorizontalCategoryList extends StatelessWidget {
  final List<CategoryItem> categories;
  final Function(CategoryItem) onCategoryTap;

  const HorizontalCategoryList({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
          final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
          
          return Container(
            width: 160,
            margin: EdgeInsets.only(
              left: index < categories.length - 1 ? ThemeConstants.space3 : 0,
            ),
            child: AppCard(
              type: CardType.normal,
              style: CardStyle.gradient,
              primaryColor: categoryColor,
              onTap: () => onCategoryTap(category),
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  // الأيقونة
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      categoryIcon,
                      color: Colors.white,
                      size: ThemeConstants.iconMd,
                    ),
                  ),
                  
                  ThemeConstants.space3.w,
                  
                  // النص فقط
                  Expanded(
                    child: Text(
                      category.title,
                      style: context.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ).animatedPress(
              onTap: () => onCategoryTap(category),
            ),
          );
        },
      ),
    );
  }
}

/// نموذج بيانات الفئة - مبسط بدون description
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