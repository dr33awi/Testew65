// lib/features/home/screens/home_screen.dart - محدث بالنظام الموحد الإسلامي
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - إجباري
import 'package:athkar_app/app/themes/app_theme.dart';

import '../widgets/welcome_message.dart';
import '../widgets/category_grid.dart';
import '../../daily_quote/widgets/daily_quotes_card.dart';
import '../../prayer_times/widgets/home_prayer_times_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(context),
        color: AppTheme.primary,
        backgroundColor: AppTheme.card,
        child: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // رسالة الترحيب
              WelcomeMessage(),
              
              SizedBox(height: AppTheme.space4),
              
              // مواقيت الصلاة
              PrayerTimesCard(),
              
              SizedBox(height: AppTheme.space4),
              
              // الاقتباسات اليومية
              DailyQuotesCard(),
              
              SizedBox(height: AppTheme.space6),
              
              // شبكة الفئات مع العنوان المدمج
              SimpleCategoryGrid(),
              
              // مساحة إضافية للأسفل
              SizedBox(height: AppTheme.space8),
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
              AppTheme.primary.withValues(alpha: 0.1),
              AppTheme.primary.withValues(alpha: 0.05),
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
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.3),
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
                  style: AppTheme.headlineMedium.copyWith(
                    fontWeight: AppTheme.bold,
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    height: 1.1,
                  ),
                ),
                Text(
                  'السلام عليكم ورحمة الله',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
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
            color: AppTheme.card.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.divider.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppTheme.primary,
              size: 22,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/settings').catchError((error) {
                _showInfoSnackBar(context, 'هذه الميزة قيد التطوير');
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
    await Future.delayed(AppTheme.durationSlow);
    
    if (context.mounted) {
      _showSuccessSnackBar(context, 'تم تحديث البيانات بنجاح');
    }
  }

  // ✅ دوال مساعدة لإظهار الرسائل
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }

  void _showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.info,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }
}