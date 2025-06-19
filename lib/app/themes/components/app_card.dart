
// lib/app/themes/components/app_card.dart - نسخة منظفة ومبسطة

import 'package:athkar_app/app/themes/colors.dart';
import 'package:athkar_app/app/themes/widgets.dart';
import 'package:flutter/material.dart';

/// بطاقة التطبيق الموحدة - نسخة منظفة
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final AppCardType type;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? heroTag;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.type = AppCardType.simple,  // ✅ تبسيط الافتراضي
    this.padding,
    this.margin,
    this.heroTag,
  });

  // ============================================
  // Factory Constructors المبسطة
  // ============================================

  /// بطاقة بسيطة (الأكثر استخداماً)
  factory AppCard.simple({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      type: AppCardType.simple,
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }

  /// بطاقة مع تدرج
  factory AppCard.gradient({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      type: AppCardType.gradient,
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }

  /// بطاقة للأذكار ✅
  factory AppCard.athkar({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      type: AppCardType.athkar,
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }

  /// بطاقة للصلوات
  factory AppCard.prayer({
    required Widget child,
    required String prayerName,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      type: AppCardType.prayer,
      onTap: onTap,
      padding: padding,
      child: _PrayerCardContent(
        prayerName: prayerName,
        child: child,
      ),
    );
  }

  /// بطاقة للإحصائيات
  factory AppCard.stats({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      type: AppCardType.stats,
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }

  /// بطاقة Hero للانتقالات
  factory AppCard.hero({
    required Widget child,
    required String heroTag,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      type: AppCardType.simple,
      heroTag: heroTag,
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget card = _buildCardContent();

    // تطبيق Hero إذا كان مطلوباً
    if (heroTag != null) {
      card = Hero(
        tag: heroTag!,
        child: card,
      );
    }

    return card;
  }

  Widget _buildCardContent() {
    switch (type) {
      case AppCardType.simple:
        return IslamicCard.simple(
          onTap: onTap,
          padding: padding,
          child: child,
        );
        
      case AppCardType.gradient:
        return IslamicCard.gradient(
          gradient: _getPrimaryGradient(),
          onTap: onTap,
          padding: padding,
          child: child,
        );
        
      case AppCardType.prayer:
        return IslamicCard.simple(
          onTap: onTap,
          padding: padding,
          child: child,
        );
        
      case AppCardType.athkar:
        return IslamicCard.gradient(
          gradient: _getAthkarGradient(),
          onTap: onTap,
          padding: padding,
          child: child,
        );
        
      case AppCardType.stats:
        return IslamicCard.gradient(
          gradient: _getStatsGradient(),
          onTap: onTap,
          padding: padding,
          child: child,
        );
    }
  }

  // ============================================
  // التدرجات المساعدة
  // ============================================
  
  LinearGradient _getPrimaryGradient() {
    return const LinearGradient(
      colors: [AppColors.primary, AppColors.primaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient _getAthkarGradient() {
    return const LinearGradient(
      colors: [AppColors.success, AppColors.primaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient _getStatsGradient() {
    return const LinearGradient(
      colors: [AppColors.info, AppColors.primary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

// ============================================
// Enum منظف ومبسط ✅
// ============================================

/// أنواع البطاقات - نسخة محسنة
enum AppCardType {
  simple,     // بطاقة بسيطة (الافتراضي)
  gradient,   // بطاقة مع تدرج
  prayer,     // بطاقة صلاة
  athkar,     // بطاقة أذكار ✅
  stats,      // بطاقة إحصائيات
}

// ============================================
// محتوى بطاقة الصلاة المخصص
// ============================================

class _PrayerCardContent extends StatelessWidget {
  final String prayerName;
  final Widget child;

  const _PrayerCardContent({
    required this.prayerName,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.getPrayerColor(prayerName),
            AppColors.getPrayerColor(prayerName).withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

// ============================================
// بطاقة معلومات سريعة ومبسطة
// ============================================

class AppInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const AppInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.stats(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}