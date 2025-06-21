// lib/features/home/widgets/category_grid.dart
import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../../../app/routes/app_router.dart';

/// ويدجت شبكة الميزات السريعة في الصفحة الرئيسية
class CategoryGrid extends StatefulWidget {
  /// عدد الأعمدة في الشبكة
  final int crossAxisCount;
  
  /// نسبة العرض إلى الارتفاع للبطاقات
  final double childAspectRatio;
  
  /// إظهار العنوان الرئيسي
  final bool showTitle;

  const CategoryGrid({
    super.key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.2,
    this.showTitle = true,
  });

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );

    // إنشاء أنيميشن منفصل لكل عنصر
    _itemAnimations = List.generate(_getFeatures().length, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.elasticOut,
        ),
      ));
    });
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[
          Text(
            'الميزات السريعة',
            style: context.titleStyle.copyWith(
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
          Spaces.medium,
        ],
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: ThemeConstants.spaceMd,
            mainAxisSpacing: ThemeConstants.spaceMd,
            childAspectRatio: widget.childAspectRatio,
          ),
          itemCount: _getFeatures().length,
          itemBuilder: (context, index) {
            final feature = _getFeatures()[index];
            return AnimatedBuilder(
              animation: _itemAnimations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _itemAnimations[index].value,
                  child: Opacity(
                    opacity: _itemAnimations[index].value,
                    child: _buildFeatureCard(
                      title: feature['title'] as String,
                      subtitle: feature['subtitle'] as String,
                      icon: feature['icon'] as IconData,
                      color: feature['color'] as Color,
                      onTap: () => AppRouter.push(feature['route'] as String),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFeatures() {
    return [
      {
        'title': 'الأذكار',
        'subtitle': 'أذكار الصباح والمساء',
        'icon': Icons.menu_book,
        'color': const Color(0xFF4CAF50),
        'route': AppRouter.athkar,
      },
      {
        'title': 'القبلة',
        'subtitle': 'اتجاه القبلة الشريفة',
        'icon': Icons.explore,
        'color': const Color(0xFF2196F3),
        'route': AppRouter.qibla,
      },
      {
        'title': 'التسبيح',
        'subtitle': 'عداد التسبيح الرقمي',
        'icon': Icons.touch_app,
        'color': const Color(0xFF9C27B0),
        'route': AppRouter.tasbih,
      },
      {
        'title': 'مواقيت الصلاة',
        'subtitle': 'أوقات الصلوات الخمس',
        'icon': Icons.mosque,
        'color': const Color(0xFFFF9800),
        'route': AppRouter.prayerTimes,
      },
    ];
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return IslamicCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة الميزة
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Icon(
              icon,
              color: color,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          Spaces.medium,
          
          // عنوان الميزة
          Text(
            title,
            style: context.titleStyle.copyWith(
              fontSize: ThemeConstants.fontSizeLg,
              fontWeight: ThemeConstants.fontSemiBold,
            ),
            textAlign: TextAlign.center,
          ),
          
          Spaces.xs,
          
          // وصف الميزة
          Text(
            subtitle,
            style: context.captionStyle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}