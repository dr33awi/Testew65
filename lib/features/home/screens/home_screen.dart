// lib/features/home/screens/home_screen.dart - النسخة المُصححة نهائياً
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../widgets/welcome_message.dart';
import '../widgets/category_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(context),
        color: context.primaryColor,
        backgroundColor: context.cardColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: context.appResponsivePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // رسالة الترحيب
              const WelcomeMessage(),
              
              const SizedBox(height: ThemeConstants.space4),
              
              // مواقيت الصلاة - بطاقة موحدة
              AppCard.info(
                title: 'مواقيت الصلاة',
                subtitle: 'الصلاة التالية: العصر في 3:45 م',
                icon: 'prayer_times'.themeCategoryIcon,
                iconColor: 'prayer_times'.themeColor,
                onTap: () => _navigateToRoute(context, '/prayer-times'),
                trailing: Icon(
                  Icons.chevron_right,
                  color: context.textSecondaryColor,
                  size: ThemeConstants.iconSm,
                ),
              ),
              
              const SizedBox(height: ThemeConstants.space4),
              
              // الاقتباس اليومي - بطاقة موحدة
              AppCard.quote(
                quote: 'وَمَن يَتَّقِ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
                author: 'سورة الطلاق',
                category: 'آية اليوم',
                primaryColor: 'verse'.themeColor,
              ),
              
              const SizedBox(height: ThemeConstants.space6),
              
              // عنوان الفئات
              _buildSectionTitle(context, 'الفئات الرئيسية'),
              
              const SizedBox(height: ThemeConstants.space4),
              
              // شبكة الفئات - محسنة بالنظام الموحد
              const SimpleCategoryGrid(),
              
              const SizedBox(height: ThemeConstants.space8), // مساحة إضافية
            ],
          ),
        ),
      ),
    );
  }

  /// شريط التطبيق محسن بالنظام الموحد
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar.transparent(
      titleWidget: Row(
        children: [
          // أيقونة التطبيق - بالنظام الموحد
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primaryColor,
                  context.primaryColor.darken(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              AppIconsSystem.home,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'مُسلم',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  'السلام عليكم ورحمة الله',
                  style: AppTextStyles.caption.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // زر الإعدادات - بالنظام الموحد
        Container(
          margin: const EdgeInsets.all(ThemeConstants.space2),
          decoration: BoxDecoration(
            color: context.cardColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: context.primaryColor.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon( // ✅ إضافة const
              AppIconsSystem.settings,
              color: null, // سيتم استخدام iconTheme
              size: ThemeConstants.iconSm,
            ),
            color: context.primaryColor, // نقل اللون هنا
            onPressed: () => _navigateToRoute(context, '/settings'),
            tooltip: 'الإعدادات',
          ),
        ),
      ],
    );
  }

  /// عنوان القسم بالنظام الموحد
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space2),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          Text(
            title,
            style: AppTextStyles.h5.copyWith(
              fontWeight: ThemeConstants.semiBold,
              color: context.textPrimaryColor,
            ),
          ),
          
          const Spacer(),
          
          AppButton.text(
            text: 'عرض الكل',
            onPressed: () => _navigateToRoute(context, '/categories'),
            icon: const IconData(0xe5c8), // ✅ إضافة const مع Icons.arrow_forward_ios
          ),
        ],
      ),
    );
  }

  /// التنقل الموحد مع معالجة الأخطاء
  void _navigateToRoute(BuildContext context, String route) {
    HapticFeedback.lightImpact();
    
    Navigator.pushNamed(context, route).catchError((error) {
      // ✅ لا نستخدم context هنا لتجنب مشكلة async
      return null;
    });
  }

  /// تحديث البيانات مع النظام الموحد
  Future<void> _handleRefresh(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    // محاكاة تحديث البيانات
    await Future.delayed(ThemeConstants.durationNormal);
    
    // ✅ حفظ context قبل await لاستخدامه بأمان
    if (context.mounted) {
      context.showSuccessSnackBar('تم تحديث البيانات بنجاح');
    }
  }
}