// lib/features/athkar/widgets/athkar_category_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/animations/animated_press.dart';
import '../models/athkar_model.dart';
import '../utils/category_utils.dart';

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
    final categoryColor = CategoryUtils.getCategoryThemeColor(widget.category.id);
    final categoryIcon = CategoryUtils.getCategoryIcon(widget.category.id);
    final description = CategoryUtils.getCategoryDescription(widget.category.id);
    
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
                      description,
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
    String description,
    bool isCompleted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الأيقونة
        Container(
          width: 60,
          height: 60,
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
            size: ThemeConstants.iconLg,
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
                fontSize: 18,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            ThemeConstants.space1.h,
            
            // الوصف
            Text(
              description,
              style: context.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            ThemeConstants.space3.h,
            
            // المعلومات السفلية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // عدد الأذكار
                Container(
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
                        size: ThemeConstants.iconXs,
                      ),
                      ThemeConstants.space1.w,
                      Text(
                        '${widget.category.athkar.length} ذكر',
                        style: context.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: ThemeConstants.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // أيقونة الحالة
                if (isCompleted)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                else
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 16,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}