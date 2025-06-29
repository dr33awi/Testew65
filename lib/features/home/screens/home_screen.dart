// lib/features/home/screens/home_screen.dart - محدث بالنظام الموحد الإسلامي
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import '../../../app/themes/index.dart';

import '../widgets/welcome_message.dart';
import '../widgets/category_grid.dart';
import '../../daily_quote/widgets/daily_quotes_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppAppBar.home(
        title: 'مُسلم',
        actions: [
          AppBarSettingsButton(
            onPressed: () => _onSettingsTap(context),
          ),
          AppTheme.space2.w,
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(context),
        color: context.primaryColor,
        backgroundColor: context.cardColor,
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
              
              // شبكة الفئات
              const SimpleCategoryGrid(),
              
              AppTheme.space8.h,
            ],
          ),
        ),
      ),
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

    return AppCard.prayerTimes(
      prayerTimes: prayerTimes,
      currentPrayer: currentPrayer,
      nextPrayer: nextPrayer,
      timeToNext: timeToNext,
      onTap: () => _onPrayerTimesTap(context),
    );
  }

  void _onSettingsTap(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/settings').catchError((error) {
      _showInfoSnackBar(context, 'هذه الميزة قيد التطوير');
      return null;
    });
  }

  void _onPrayerTimesTap(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/prayer-times').catchError((error) {
      _showInfoSnackBar(context, 'هذه الميزة قيد التطوير');
      return null;
    });
  }

  Future<void> _handleRefresh(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    // محاكاة تحديث البيانات
    await Future.delayed(AppTheme.durationSlow);
    
    if (context.mounted) {
      _showSuccessSnackBar(context, 'تم تحديث البيانات بنجاح');
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: context.bodyMedium.copyWith(color: Colors.white),
        ),
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
        content: Text(
          message,
          style: context.bodyMedium.copyWith(color: Colors.white),
        ),
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