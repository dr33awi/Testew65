// lib/features/home/screens/home_screen.dart - محدث بالنظام الموحد الإسلامي
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - إجباري
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';
import 'package:athkar_app/app/themes/widgets/extended_cards.dart';

import '../widgets/welcome_message.dart';
import '../widgets/category_grid.dart';
import '../../daily_quote/widgets/daily_quotes_card.dart';

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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: AppTheme.space4.paddingH + AppTheme.space2.paddingV,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // رسالة الترحيب
              const WelcomeMessage(),
              
              AppTheme.space4.h,
              
              // مواقيت الصلاة
              _buildPrayerTimesCard(context),
              
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
            padding: AppTheme.space2.padding,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: AppTheme.radiusMd.radius,
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
            borderRadius: AppTheme.radiusMd.radius,
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

  Widget _buildPrayerTimesCard(BuildContext context) {
    // محاكاة بيانات أوقات الصلاة
    final prayerTimes = {
      'الفجر': '05:30',
      'الشروق': '06:45',
      'الظهر': '12:15',
      'العصر': '15:30',
      'المغرب': '18:00',
      'العشاء': '19:30',
    };

    const currentPrayer = 'الظهر';
    const nextPrayer = 'العصر';
    const timeToNext = Duration(hours: 3, minutes: 15);

    return PrayerTimesCard(
      prayerTimes: prayerTimes,
      currentPrayer: currentPrayer,
      nextPrayer: nextPrayer,
      timeToNext: timeToNext,
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, '/prayer-times').catchError((error) {
          _showInfoSnackBar(context, 'هذه الميزة قيد التطوير');
          return null;
        });
      },
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