// lib/features/settings/screens/about_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:athkar_app/app/themes/index.dart';
import 'package:athkar_app/core/constants/app_constants.dart';

class AboutSettingsScreen extends StatefulWidget {
  const AboutSettingsScreen({super.key});

  @override
  State<AboutSettingsScreen> createState() => _AboutSettingsScreenState();
}

class _AboutSettingsScreenState extends State<AboutSettingsScreen> {
  PackageInfo? _packageInfo;
  Map<String, dynamic> _deviceInfo = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfoPlugin = DeviceInfoPlugin();
      
      if (!mounted) return;
      
      Map<String, dynamic> deviceData = {};
      
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceData = {
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'version': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
        };
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceData = {
          'model': iosInfo.model,
          'name': iosInfo.name,
          'version': iosInfo.systemVersion,
        };
      }

      if (mounted) {
        setState(() {
          _packageInfo = packageInfo;
          _deviceInfo = deviceData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: IslamicAppBar(title: 'حول التطبيق'),
        body: Center(child: IslamicLoading(message: 'جاري التحميل...')),
      );
    }

    return Scaffold(
      appBar: const IslamicAppBar(title: 'حول التطبيق'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شعار التطبيق ومعلومات أساسية
            _buildAppHeader(context),
            
            Spaces.large,
            
            // معلومات التطبيق
            _buildAppInfo(context),
            
            Spaces.large,
            
            // معلومات الجهاز
            _buildDeviceInfo(context),
            
            Spaces.large,
            
            // الدعم والمساعدة
            _buildSupportSection(context),
            
            Spaces.large,
            
            // المطورون والشكر والتقدير
            _buildCreditsSection(context),
            
            Spaces.large,
            
            // الروابط المفيدة
            _buildLinksSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        children: [
          // شعار التطبيق
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(25),
              boxShadow: ThemeConstants.shadowLg,
            ),
            child: const Icon(
              Icons.menu_book,
              size: 50,
              color: Colors.white,
            ),
          ),
          
          Spaces.medium,
          
          // اسم التطبيق
          Text(
            AppConstants.appName,
            style: context.headingStyle.copyWith(
              color: context.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          Spaces.small,
          
          // وصف مختصر
          Text(
            'تطبيق شامل للأذكار والأدعية ومواقيت الصلاة',
            style: context.bodyStyle,
            textAlign: TextAlign.center,
          ),
          
          Spaces.medium,
          
          // نسخة التطبيق
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.mediumPadding,
              vertical: context.smallPadding,
            ),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.largeRadius),
            ),
            child: Text(
              'الإصدار ${_packageInfo?.version ?? AppConstants.appVersion}',
              style: context.bodyStyle.copyWith(
                color: context.primaryColor,
                fontWeight: ThemeConstants.fontSemiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'معلومات التطبيق',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          _buildInfoRow(
            context: context,
            label: 'اسم التطبيق',
            value: _packageInfo?.appName ?? AppConstants.appName,
          ),
          
          _buildInfoRow(
            context: context,
            label: 'الإصدار',
            value: _packageInfo?.version ?? AppConstants.appVersion,
          ),
          
          _buildInfoRow(
            context: context,
            label: 'رقم البناء',
            value: _packageInfo?.buildNumber ?? AppConstants.appBuildNumber,
          ),
          
          _buildInfoRow(
            context: context,
            label: 'معرف الحزمة',
            value: _packageInfo?.packageName ?? 'com.example.athkar_app',
          ),
          
          _buildInfoRow(
            context: context,
            label: 'اللغة',
            value: 'العربية والإنجليزية',
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfo(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.smartphone_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'معلومات الجهاز',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          if (_deviceInfo.isNotEmpty) ...[
            _buildInfoRow(
              context: context,
              label: 'النموذج',
              value: _deviceInfo['model'] ?? 'غير معروف',
            ),
            
            if (_deviceInfo['brand'] != null)
              _buildInfoRow(
                context: context,
                label: 'العلامة التجارية',
                value: _deviceInfo['brand'],
              ),
            
            _buildInfoRow(
              context: context,
              label: 'إصدار النظام',
              value: _deviceInfo['version'] ?? 'غير معروف',
            ),
            
            if (_deviceInfo['sdkInt'] != null)
              _buildInfoRow(
                context: context,
                label: 'API Level',
                value: _deviceInfo['sdkInt'].toString(),
              ),
          ] else ...[
            Text(
              'لم نتمكن من الحصول على معلومات الجهاز',
              style: context.captionStyle,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.support_agent_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'الدعم والمساعدة',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          _buildActionTile(
            context: context,
            icon: Icons.email_outlined,
            title: 'تواصل معنا',
            subtitle: 'أرسل لنا رسالة أو استفسار',
            onTap: () => _contactSupport(context),
          ),
          
          Spaces.small,
          
          _buildActionTile(
            context: context,
            icon: Icons.bug_report_outlined,
            title: 'الإبلاغ عن خطأ',
            subtitle: 'ساعدنا في تحسين التطبيق',
            onTap: () => _reportBug(context),
          ),
          
          Spaces.small,
          
          _buildActionTile(
            context: context,
            icon: Icons.star_outline,
            title: 'تقييم التطبيق',
            subtitle: 'قيم التطبيق في المتجر',
            onTap: () => _rateApp(context),
          ),
          
          Spaces.small,
          
          _buildActionTile(
            context: context,
            icon: Icons.share_outlined,
            title: 'مشاركة التطبيق',
            subtitle: 'شارك التطبيق مع الأصدقاء',
            onTap: () => _shareApp(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditsSection(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people_outline,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'الشكر والتقدير',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          _buildCreditItem(
            context: context,
            title: 'المطورون',
            description: 'فريق تطوير تطبيق الأذكار',
          ),
          
          Spaces.small,
          
          _buildCreditItem(
            context: context,
            title: 'المحتوى الديني',
            description: 'مراجعة وتدقيق المحتوى من قبل متخصصين',
          ),
          
          Spaces.small,
          
          _buildCreditItem(
            context: context,
            title: 'مصادر البيانات',
            description: 'أوقات الصلاة والأذكار من مصادر موثوقة',
          ),
          
          Spaces.small,
          
          _buildCreditItem(
            context: context,
            title: 'المكتبات المستخدمة',
            description: 'Flutter والمكتبات مفتوحة المصدر',
          ),
        ],
      ),
    );
  }

  Widget _buildLinksSection(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.link_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'روابط مفيدة',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          _buildActionTile(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: 'سياسة الخصوصية',
            subtitle: 'اطلع على سياسة حماية البيانات',
            onTap: () => _openPrivacyPolicy(context),
          ),
          
          Spaces.small,
          
          _buildActionTile(
            context: context,
            icon: Icons.gavel_outlined,
            title: 'شروط الاستخدام',
            subtitle: 'شروط وأحكام استخدام التطبيق',
            onTap: () => _openTermsOfService(context),
          ),
          
          Spaces.small,
          
          _buildActionTile(
            context: context,
            icon: Icons.code_outlined,
            title: 'المصدر المفتوح',
            subtitle: 'اطلع على كود التطبيق',
            onTap: () => _openSourceCode(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.smallPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: context.captionStyle.copyWith(
                fontWeight: ThemeConstants.fontMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.bodyStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: context.secondaryTextColor,
      ),
      title: Text(
        title,
        style: context.bodyStyle.copyWith(
          fontWeight: ThemeConstants.fontMedium,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.captionStyle,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: ThemeConstants.iconXs,
        color: context.secondaryTextColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildCreditItem({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.smallPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.bodyStyle.copyWith(
              fontWeight: ThemeConstants.fontSemiBold,
            ),
          ),
          Spaces.xs,
          Text(
            description,
            style: context.captionStyle,
          ),
        ],
      ),
    );
  }

  // Action Methods
  void _contactSupport(BuildContext context) {
    context.showInfoMessage('سيتم فتح تطبيق البريد الإلكتروني');
  }

  void _reportBug(BuildContext context) {
    context.showInfoMessage('سيتم فتح نموذج الإبلاغ عن الأخطاء');
  }

  void _rateApp(BuildContext context) {
    context.showInfoMessage('سيتم فتح متجر التطبيقات');
  }

  void _shareApp(BuildContext context) {
    context.showInfoMessage('سيتم مشاركة رابط التطبيق');
  }

  void _openPrivacyPolicy(BuildContext context) {
    context.showInfoMessage('سيتم فتح سياسة الخصوصية');
  }

  void _openTermsOfService(BuildContext context) {
    context.showInfoMessage('سيتم فتح شروط الاستخدام');
  }

  void _openSourceCode(BuildContext context) {
    context.showInfoMessage('سيتم فتح مستودع الكود');
  }
}