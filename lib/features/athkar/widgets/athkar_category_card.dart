// lib/features/athkar/widgets/athkar_category_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيرادات النظام الموحد الموجود فقط
import '../../../app/themes/index.dart';

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
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  categoryColor.withValues(alpha: 0.9),
                  categoryColor.darken(0.1).withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: categoryColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                // حد لامع للبطاقات المكتملة
                if (isCompleted)
                  BoxShadow(
                    color: Colors.white.withValues(
                      alpha: 0.3 + (_glowAnimation.value * 0.2),
                    ),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
              ],
              border: isCompleted ? Border.all(
                color: Colors.white.withValues(
                  alpha: 0.4 + (_glowAnimation.value * 0.2),
                ),
                width: 2,
              ) : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              child: Padding(
                padding: const EdgeInsets.all(ThemeConstants.spaceMd),
                child: Column(
                  children: [
                    // الأيقونة
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Icon(
                        categoryIcon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // النصوص
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عنوان الفئة
                        IslamicText.dua(
                          text: widget.category.title,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        
                        SizedBox(height: context.smallPadding),
                        
                        // الوصف
                        Text(
                          description,
                          style: context.captionStyle.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: context.mediumPadding),
                        
                        // المعلومات السفلية
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // عدد الأذكار
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.format_list_numbered_rounded,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                  SizedBox(width: context.smallPadding / 2),
                                  Text(
                                    '${widget.category.athkar.length} ذكر',
                                    style: context.captionStyle.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // أيقونة الحالة
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCompleted 
                                    ? Icons.check_rounded 
                                    : Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: isCompleted ? 20 : 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}