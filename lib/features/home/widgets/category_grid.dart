// lib/features/home/widgets/category_grid.dart - محدث بالنظام الموحد
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
      description: 'أوقات الصلاة والأذان',
      routeName: '/prayer-times',
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار اليومية',
      description: 'أذكار الصباح والمساء',
      routeName: '/athkar',
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      description: 'تلاوة وتدبر القرآن',
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      description: 'تحديد اتجاه الكعبة',
      routeName: '/qibla',
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      description: 'عداد التسبيح والذكر',
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية المأثورة',
      description: 'أدعية من الكتاب والسنة',
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
          childAspectRatio: 0.9, // تحسين النسبة للمحتوى الجديد
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            final category = _categories[index];
            
            // ✅ استخدام AppCard.info الموحد بدلاً من المحتوى المخصص
            return _buildCategoryCard(context, category);
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryItem category) {
    // ✅ استخدام CategoryHelper للألوان والأيقونات الموحدة
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    
    // ✅ استخدام AppCard.info بدلاً من التصميم المعقد
    return AppCard.info(
      title: category.title,
      subtitle: category.description,
      icon: categoryIcon,
      iconColor: categoryColor,
      onTap: () => _onCategoryTap(category),
      trailing: Container(
        padding: const EdgeInsets.all(ThemeConstants.space1),
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: ThemeConstants.iconSm,
          color: categoryColor,
        ),
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
      description: 'أوقات الصلاة والأذان',
      routeName: '/prayer-times',
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار اليومية',
      description: 'أذكار الصباح والمساء',
      routeName: '/athkar',
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      description: 'تلاوة وتدبر القرآن',
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      description: 'تحديد اتجاه الكعبة',
      routeName: '/qibla',
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      description: 'عداد التسبيح والذكر',
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية المأثورة',
      description: 'أدعية من الكتاب والسنة',
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
        
        // ✅ استخدام AppCard مع تصميم مضغوط جميل
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
          // الأيقونة الجميلة
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
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
              fontSize: 16,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          ThemeConstants.space1.h,
          
          // الوصف
          Text(
            category.description,
            style: context.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
              height: 1.3,
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
                  
                  // النص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category.title,
                          style: context.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (category.description.isNotEmpty) ...[
                          ThemeConstants.space1.h,
                          Text(
                            category.description,
                            style: context.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
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

/// نموذج بيانات الفئة - محدث بالوصف
class CategoryItem {
  final String id;
  final String title;
  final String description;
  final String? routeName;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.description,
    this.routeName,
  });
}