// lib/features/home/widgets/category_grid.dart
import 'package:athkar_app/features/home/widgets/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
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
      subtitle: 'أوقات الصلوات الخمس',
      icon: Icons.mosque,
      routeName: '/prayer-times',
    ),
    CategoryItem(
      id: 'athkar',
      title: 'الأذكار اليومية',
      subtitle: 'أذكار الصباح والمساء',
      icon: Icons.auto_awesome,
      routeName: '/athkar',
    ),
    CategoryItem(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وتدبر',
      icon: Icons.menu_book_rounded,
      routeName: '/quran',
    ),
    CategoryItem(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الذكية',
      icon: Icons.explore,
      routeName: '/qibla',
    ),
    CategoryItem(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      subtitle: 'عداد التسبيح',
      icon: Icons.radio_button_checked,
      routeName: '/tasbih',
    ),
    CategoryItem(
      id: 'dua',
      title: 'الأدعية المأثورة',
      subtitle: 'أدعية من الكتاب والسنة',
      icon: Icons.pan_tool_rounded,
      routeName: '/dua',
    ),
  ];

  // بيانات التقدم المخزنة
  static const Map<String, double> _progressData = {
    'prayer_times': 0.9,
    'athkar': 0.7,
    'quran': 0.5,
    'qibla': 1.0,
    'tasbih': 0.8,
    'dua': 0.4,
  };

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
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            
            return _CategoryCard(
              category: _categories[index],
              progress: _progressData[_categories[index].id] ?? 0.6,
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
  final double progress;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = ColorHelper.getCategoryGradient(category.id);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradient.colors[0].withValues(alpha: 0.9),
            gradient.colors[1].withValues(alpha: 0.8),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConstants.space4),
                  child: _buildContent(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الأيقونة
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          child: Icon(
            category.icon,
            color: Colors.white,
            size: 32,
          ),
        ),
        
        const Spacer(),
        
        // النصوص
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.title,
              style: context.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: ThemeConstants.space1),
            
            Text(
              category.subtitle,
              style: context.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        
        const SizedBox(height: ThemeConstants.space3),
        
        // شريط التقدم
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// نموذج بيانات الفئة
class CategoryItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String? routeName;

  const CategoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.routeName,
  });
}