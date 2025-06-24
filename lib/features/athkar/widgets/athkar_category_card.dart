// lib/features/athkar/widgets/athkar_category_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/animations/animated_press.dart';
import '../models/athkar_model.dart';

class AthkarCategoryCard extends StatefulWidget {
  final AthkarCategory category;
  final int progress;
  final VoidCallback onTap;

  const AthkarCategoryCard({
    super.key,
    required this.category,
    required this.progress,
    required this.onTap,
  });

  @override
  State<AthkarCategoryCard> createState() => _AthkarCategoryCardState();
}

class _AthkarCategoryCardState extends State<AthkarCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.progress >= 100;
    // ✅ استخدام دالة محلية بدلاً من CategoryUtils
    final categoryColor = _getCategoryThemeColor(widget.category.id);
    final categoryIcon = _getCategoryIcon(widget.category.id);
    
    return AnimatedPress(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      scaleFactor: 0.95,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor.withValues(alpha: 0.9),
              categoryColor.darken(0.1).withValues(alpha: 0.9),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Stack(
              children: [
                // الحد اللامع للبطاقات المكتملة فقط
                if (isCompleted) _buildGlowBorder(),
                
                // المحتوى الرئيسي
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(ThemeConstants.space4),
                    child: _buildCardContent(
                      context,
                      categoryIcon,
                      isCompleted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlowBorder() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.5 + (_glowAnimation.value * 0.3),
              ),
              width: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(
    BuildContext context,
    IconData categoryIcon,
    bool isCompleted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الأيقونة
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            categoryIcon,
            color: Colors.white,
            size: ThemeConstants.icon2xl,
          ),
        ),
        
        const Spacer(),
        
        // النصوص
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الفئة
            Text(
              widget.category.title,
              style: context.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
                fontSize: 20,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            ThemeConstants.space4.h,
            
            // المعلومات السفلية (بدون أيقونة السهم)
            Row(
              children: [
                // عدد الأذكار
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.space3,
                      vertical: ThemeConstants.space2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.format_list_numbered_rounded,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: ThemeConstants.iconSm,
                        ),
                        ThemeConstants.space1.w,
                        Text(
                          '${widget.category.athkar.length} ذكر',
                          style: context.labelMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: ThemeConstants.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                ThemeConstants.space3.w,
                
                // حالة الإكمال فقط
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.space3,
                      vertical: ThemeConstants.space2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: ThemeConstants.iconSm,
                        ),
                        ThemeConstants.space1.w,
                        Text(
                          'مكتمل',
                          style: context.labelMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ===== دوال محلية بدلاً من CategoryUtils =====

  /// ✅ دالة محلية بدلاً من CategoryUtils.getCategoryThemeColor
  Color _getCategoryThemeColor(String categoryId) {
    // نفس النتيجة البصرية بالضبط
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
        return context.primaryColor; // ThemeConstants.primary
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
        return context.accentColor; // ThemeConstants.accent
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
        return context.tertiaryColor; // ThemeConstants.tertiary
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return context.primaryLightColor; // ThemeConstants.primaryLight
      case 'travel':
      case 'السفر':
      case 'أذكار السفر':
        return context.accentDarkColor; // ThemeConstants.accentDark
      case 'general':
      case 'عامة':
      case 'أذكار عامة':
        return context.tertiaryDarkColor; // ThemeConstants.tertiaryDark
      default:
        return context.primaryColor;
    }
  }

  /// ✅ دالة محلية بدلاً من CategoryUtils.getCategoryIcon
  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
        return Icons.wb_sunny_rounded;
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
        return Icons.nights_stay_rounded;
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
        return Icons.bedtime_rounded;
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return Icons.mosque_rounded;
      case 'travel':
      case 'السفر':
      case 'أذكار السفر':
        return Icons.luggage_rounded;
      case 'general':
      case 'عامة':
      case 'أذكار عامة':
        return Icons.auto_awesome_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }