// lib/features/home/screens/home_screen.dart - محسن باستخدام النظام الموحد
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
      backgroundColor: context.backgroundColor,
      // ✅ استخدام CustomAppBar الموحد المحسن
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(context),
        color: context.primaryColor,
        backgroundColor: context.cardColor,
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

  // ✅ AppBar محسن باستخدام CustomAppBar الموحد
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      titleWidget: _buildAppTitle(context),
      actions: [
        _buildSettingsButton(context),
      ],
      backgroundColor: Colors.transparent,
      foregroundColor: context.textPrimaryColor,
      elevation: 0,
      toolbarHeight: 70,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: context.isDarkMode 
            ? Brightness.light 
            : Brightness.dark,
      ),
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
    );
  }

  // ✅ Widget منفصل لعنوان التطبيق
  Widget _buildAppTitle(BuildContext context) {
    return Row(
      children: [
        // أيقونة التطبيق محسنة
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
            // ✅ استخدام الظل الموحد من ThemeConstants
            boxShadow: ThemeConstants.shadowMd,
          ),
          child: const Icon(
            Icons.mosque_outlined,
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
                style: context.headlineSmall?.copyWith(
                  fontWeight: ThemeConstants.bold,
                  fontSize: 20,
                  height: 1.1,
                ),
              ),
              Text(
                'السلام عليكم ورحمة الله',
                style: context.bodySmall?.copyWith(
                  color: context.textSecondaryColor,
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ زر الإعدادات محسن
  Widget _buildSettingsButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
        // ✅ استخدام الظل الموحد
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
        onPressed: () => _navigateToSettings(context),
        tooltip: 'الإعدادات',
      ),
    );
  }

  // ✅ دالة منفصلة للتنقل إلى الإعدادات
  void _navigateToSettings(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/settings').catchError((error) {
      // ✅ استخدام النظام الموحد بدلاً من Extension
      AppSnackBar.showInfo(
        context: context,
        message: 'هذه الميزة قيد التطوير',
      );
      return null;
    });
  }

  // ✅ دالة التحديث محسنة
  Future<void> _handleRefresh(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    // محاكاة تحديث البيانات
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (context.mounted) {
      // ✅ استخدام النظام الموحد بدلاً من Extension
      AppSnackBar.showSuccess(
        context: context,
        message: 'تم تحديث البيانات بنجاح',
      );
    }
  }
}