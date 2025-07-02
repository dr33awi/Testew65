// lib/features/home/screens/home_screen.dart - محدث للنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: AppColorSystem.getBackground(context),
      appBar: _buildCustomAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(context),
        color: AppColorSystem.primary,
        backgroundColor: AppColorSystem.getCard(context),
        child: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
            vertical: ThemeConstants.space2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // رسالة الترحيب
              WelcomeMessage(),
              
              SizedBox(height: ThemeConstants.space4),
              
              // مواقيت الصلاة
              PrayerTimesCard(),
              
              SizedBox(height: ThemeConstants.space4),
              
              // الاقتباسات اليومية
              DailyQuotesCard(),
              
              SizedBox(height: ThemeConstants.space6),
              
              // شبكة الفئات مع العنوان المدمج
              SimpleCategoryGrid(),
              
              // مساحة إضافية للأسفل
              SizedBox(height: ThemeConstants.space8),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light 
            : Brightness.dark,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColorSystem.primary.withValues(alpha: 0.1),
              AppColorSystem.primary.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
      titleWidget: Row(
        children: [
          // أيقونة التطبيق - محسنة بالنظام الموحد
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColorSystem.primary,
                  AppColorSystem.primary.darken(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColorSystem.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              AppIconsSystem.home,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          // اسم التطبيق والترحيب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'مُسلم',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: AppColorSystem.getTextPrimary(context),
                    fontSize: 20,
                    height: 1.1,
                  ),
                ),
                Text(
                  'السلام عليكم ورحمة الله',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColorSystem.getTextSecondary(context),
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
        // أيقونة الإعدادات - محسنة بالنظام الموحد
        Container(
          margin: const EdgeInsets.only(left: ThemeConstants.space4),
          decoration: BoxDecoration(
            color: AppColorSystem.getCard(context).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColorSystem.getDivider(context).withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColorSystem.primary.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              AppIconsSystem.settings,
              color: AppColorSystem.primary,
              size: 22,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/settings').catchError((error) {
                AppSnackBar.showInfo(
                  context: context,
                  message: 'هذه الميزة قيد التطوير',
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
    await Future.delayed(ThemeConstants.durationNormal);
    
    if (context.mounted) {
      AppSnackBar.showSuccess(
        context: context, 
        message: 'تم تحديث البيانات بنجاح',
      );
    }
  }
}