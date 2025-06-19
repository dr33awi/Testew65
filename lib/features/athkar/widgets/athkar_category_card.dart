// lib/features/athkar/widgets/athkar_category_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// ✅ استيرادات النظام الموحد الجديد
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets.dart';
import '../../../app/themes/colors.dart';
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
    
    return AppCard.athkar( // ✅ استخدام النظام الموحد للأذكار
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: Stack(
        children: [
          // الحد اللامع للبطاقات المكتملة فقط
          if (isCompleted) _buildGlowBorder(),
          
          // المحتوى الرئيسي
          _buildCardContent(
            context,
            categoryIcon,
            description,
            isCompleted,
            categoryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildGlowBorder() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
    Color categoryColor,
  ) {
    return AppColumn( // ✅ النظام الموحد
      children: [
        // الأيقونة
        IslamicCard.simple( // ✅ النظام الموحد
          padding: const EdgeInsets.all(16),
          child: Icon(
            categoryIcon,
            color: Colors.white,
            size: 32,
          ),
        ),
        
        const Spacer(),
        
        // النصوص
        AppColumn.small( // ✅ النظام الموحد
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الفئة
            IslamicText.dua( // ✅ النظام الموحد للنصوص الإسلامية
              text: widget.category.title,
              color: Colors.white,
              fontSize: 18,
            ),
            
            // الوصف
            AppText.caption( // ✅ النظام الموحد
              description,
              color: Colors.white.withValues(alpha: 0.85),
              maxLines: 2,
            ),
            
            Spaces.medium, // ✅ النظام الموحد
            
            // المعلومات السفلية
            AppRow( // ✅ النظام الموحد
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // عدد الأذكار
                AppCard.simple(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: AppRichText( // ✅ النظام الموحد
                    text: '${widget.category.athkar.length} ذكر',
                    icon: Icons.format_list_numbered_rounded,
                    color: Colors.white.withValues(alpha: 0.9),
                    style: AppTextStyle.caption,
                  ),
                ),
                
                // أيقونة الحالة
                if (isCompleted)
                  AppCard.simple(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                else
                  AppCard.simple(
                    padding: const EdgeInsets.all(8),
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

// ✅ نسخة محسنة من AppRichText للاستخدام المحلي
class AppRichText extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;
  final Color? iconColor;
  final AppTextStyle style;
  final TextAlign? textAlign;

  const AppRichText({
    super.key,
    required this.text,
    this.icon,
    this.color,
    this.iconColor,
    this.style = AppTextStyle.body,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return AppRow.small( // ✅ النظام الموحد
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: _getIconSize(),
            color: iconColor ?? color,
          ),
          Flexible(
            child: AppText( // ✅ النظام الموحد
              text,
              style: style,
              color: color,
              textAlign: textAlign,
            ),
          ),
        ],
      ],
    );
  }

  double _getIconSize() {
    switch (style) {
      case AppTextStyle.heading:
        return 28.0;
      case AppTextStyle.title:
        return 24.0;
      case AppTextStyle.subtitle:
        return 20.0;
      case AppTextStyle.body:
        return 18.0;
      case AppTextStyle.bodyLarge:
        return 20.0;
      case AppTextStyle.caption:
        return 14.0;
      case AppTextStyle.label:
        return 16.0;
    }
  }
}