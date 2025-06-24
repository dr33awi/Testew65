// lib/features/athkar/widgets/athkar_category_card.dart - محدث بالنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../models/athkar_model.dart';

class AthkarCategoryCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // ✅ استخدام CategoryHelper للألوان والأيقونات الموحدة
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final categoryDescription = CategoryHelper.getCategoryDescription(category.id);
    
    final isCompleted = progress >= 100;
    final totalAthkar = category.athkar.length;
    
    // تحديد نوع البطاقة حسب الحالة
    if (isCompleted) {
      // ✅ بطاقة إكمال للفئات المنجزة
      return AppCard.completion(
        title: category.title,
        message: 'تم إكمال جميع الأذكار! 🎉',
        subMessage: '$totalAthkar ذكر مكتمل',
        icon: Icons.check_circle_rounded,
        primaryColor: ThemeConstants.success,
        actions: [
          CardAction(
            icon: Icons.refresh_rounded,
            label: 'إعادة القراءة',
            onPressed: () {
              HapticFeedback.mediumImpact();
              onTap();
            },
            isPrimary: true,
          ),
          CardAction(
            icon: Icons.share_rounded,
            label: 'مشاركة الإنجاز',
            onPressed: () {
              HapticFeedback.lightImpact();
              _shareProgress(context);
            },
          ),
        ],
      ).animatedPress(
        onTap: onTap,
        scaleFactor: 0.98,
      );
    }
    
    // ✅ بطاقة إحصائيات للفئات قيد التنفيذ
    return AppCard.stat(
      title: category.title,
      value: '$progress%',
      icon: categoryIcon,
      color: categoryColor,
      progress: progress / 100,
      onTap: onTap,
      // إضافة معلومات إضافية في الـ trailing
    ).animatedPress(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      scaleFactor: 0.95,
    ).container(
      margin: const EdgeInsets.only(bottom: ThemeConstants.space3),
      // إضافة تفاصيل إضافية أسفل البطاقة
    ).padded(
      EdgeInsets.zero,
    );
  }

  void _shareProgress(BuildContext context) {
    // منطق مشاركة التقدم - يمكن تطويره لاحقاً
    context.showSuccessSnackBar('سيتم إضافة المشاركة قريباً');
  }
}

/// بطاقة فئة مبسطة للاستخدام في القوائم
class SimpleCategoryCard extends StatelessWidget {
  final AthkarCategory category;
  final VoidCallback onTap;
  final bool showProgress;
  final int? progress;

  const SimpleCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.showProgress = false,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final categoryDescription = CategoryHelper.getCategoryDescription(category.id);
    
    // ✅ استخدام AppCard.info للبطاقات المبسطة
    return AppCard.info(
      title: category.title,
      subtitle: categoryDescription,
      icon: categoryIcon,
      iconColor: categoryColor,
      onTap: onTap,
      trailing: showProgress && progress != null
          ? _buildProgressIndicator(context, categoryColor)
          : const Icon(Icons.arrow_forward_ios_rounded, size: 16),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space2,
        vertical: ThemeConstants.space1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
      ),
      child: Text(
        '$progress%',
        style: context.labelSmall?.copyWith(
          color: color,
          fontWeight: ThemeConstants.bold,
        ),
      ),
    );
  }
}

/// بطاقة فئة مضغوطة للاستخدام في الشبكات
class CompactCategoryCard extends StatelessWidget {
  final AthkarCategory category;
  final int progress;
  final VoidCallback onTap;

  const CompactCategoryCard({
    super.key,
    required this.category,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final isCompleted = progress >= 100;
    
    // ✅ استخدام AppCard العادي مع محتوى مخصص مبسط
    return AppCard(
      type: CardType.normal,
      style: CardStyle.gradient,
      primaryColor: categoryColor,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الأيقونة
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              categoryIcon,
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
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          ThemeConstants.space2.h,
          
          // شريط التقدم أو حالة الإكمال
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space3,
                vertical: ThemeConstants.space1,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: ThemeConstants.iconSm,
                  ),
                  ThemeConstants.space1.w,
                  Text(
                    'مكتمل',
                    style: context.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
        ],
      ),
    ).animatedPress(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }
}