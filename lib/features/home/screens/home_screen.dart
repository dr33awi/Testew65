// lib/features/home/screens/home_screen.dart - محدث بالنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد
import '../../../app/themes/app_theme.dart';

import '../widgets/welcome_message.dart';
import '../widgets/category_grid.dart';
import '../../daily_quote/widgets/daily_quotes_card.dart';
import '../../prayer_times/widgets/home_prayer_times_card.dart';

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
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // رسالة الترحيب
              const WelcomeMessage(),
              
              AppTheme.space4.h,
              
              // مواقيت الصلاة
              const PrayerTimesCard(),
              
              AppTheme.space4.h,
              
              // الاقتباسات اليومية
              const DailyQuotesCard(),
              
              AppTheme.space6.h,
              
              // شبكة الفئات مع العنوان المدمج
              const SimpleCategoryGrid(),
              
              // مساحة إضافية للأسفل
              AppTheme.space8.h,
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.primaryColor.withValues(alpha: 0.1),
              context.primaryColor.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          // أيقونة التطبيق
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primaryColor,
                  context.primaryColor.darken(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.mosque_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          AppTheme.space3.w,
          
          // اسم التطبيق والترحيب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'مُسلم',
                  style: context.headlineSmall.copyWith(
                    fontWeight: AppTheme.bold,
                    color: context.textPrimaryColor,
                    fontSize: 20,
                    height: 1.1,
                  ),
                ),
                Text(
                  'السلام عليكم ورحمة الله',
                  style: context.bodySmall.copyWith(
                    color: context.textSecondaryColor,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // أيقونة الإعدادات
        Container(
          margin: const EdgeInsets.only(left: AppTheme.space4),
          decoration: BoxDecoration(
            color: context.cardColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
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
            icon: Icon(
              Icons.settings_outlined,
              color: context.primaryColor,
              size: 22,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/settings').catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('هذه الميزة قيد التطوير'),
                    backgroundColor: AppTheme.info,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.radiusMd.radius,
                    ),
                  ),
                );
                return null;
              });
            },
            tooltip: 'الإعدادات',
          ),
        ),
      ],
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    // محاكاة تحديث البيانات
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تحديث البيانات بنجاح'),
          backgroundColor: AppTheme.success,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.radiusMd.radius,
          ),
        ),
      );
    }
  }
}