// lib/features/home/widgets/category_grid.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static const List<_CategoryData> _categories = [
    _CategoryData(
      id: 'prayer_times',
      title: 'مواقيت الصلاة',
      subtitle: 'أوقات الصلوات الخمس',
      icon: Icons.mosque,
      routeName: '/prayer-times',
      progress: 0.9,
    ),
    _CategoryData(
      id: 'athkar',
      title: 'الأذكار اليومية',
      subtitle: 'أذكار الصباح والمساء',
      icon: Icons.auto_awesome,
      routeName: '/athkar',
      progress: 0.7,
    ),
    _CategoryData(
      id: 'quran',
      title: 'القرآن الكريم',
      subtitle: 'تلاوة وتدبر',
      icon: Icons.menu_book_rounded,
      routeName: '/quran',
      progress: 0.5,
    ),
    _CategoryData(
      id: 'qibla',
      title: 'اتجاه القبلة',
      subtitle: 'البوصلة الذكية',
      icon: Icons.explore,
      routeName: '/qibla',
      progress: 1.0,
    ),
    _CategoryData(
      id: 'tasbih',
      title: 'المسبحة الرقمية',
      subtitle: 'عداد التسبيح',
      icon: Icons.radio_button_checked,
      routeName: '/tasbih',
      progress: 0.8,
    ),
    _CategoryData(
      id: 'dua',
      title: 'الأدعية المأثورة',
      subtitle: 'أدعية من الكتاب والسنة',
      icon: Icons.pan_tool_rounded,
      routeName: '/dua',
      progress: 0.4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ThemeConstants.space4,
          crossAxisSpacing: ThemeConstants.space4,
          childAspectRatio: 1.1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _categories.length) return null;
            return _UnifiedCategoryCard(category: _categories[index]);
          },
          childCount: _categories.length,
        ),
      ),
    );
  }
}

/// بطاقة الفئة باستخدام الثيم الموحد
class _UnifiedCategoryCard extends StatelessWidget {
  final _CategoryData category;

  const _UnifiedCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: () => _onCategoryTap(context),
      child: AppCard(
        type: CardType.stat,
        style: CardStyle.gradient,
        title: category.title,
        value: '${(category.progress * 100).toInt()}%',
        unit: 'مكتمل',
        icon: category.icon,
        progress: category.progress,
        primaryColor: ThemeConstants.getPrayerColor(category.id),
        gradientColors: ThemeConstants.prayerGradient(category.id).colors,
        onTap: () => _onCategoryTap(context),
        showShadow: true,
        padding: const EdgeInsets.all(ThemeConstants.space4),
      ),
    );
  }

  void _onCategoryTap(BuildContext context) {
    HapticFeedback.lightImpact();
    
    if (category.routeName != null) {
      Navigator.pushNamed(context, category.routeName!).catchError((error) {
        if (context.mounted) {
          // استخدام امتداد الـ SnackBar الموحد الجديد
          context.showAppWarningSnackBar('هذه الميزة قيد التطوير');
        }
        return null;
      });
    }
  }
}

class _CategoryData {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String? routeName;
  final double progress;

  const _CategoryData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.routeName,
    required this.progress,
  });
}