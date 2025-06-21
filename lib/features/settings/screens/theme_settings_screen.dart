// lib/features/settings/screens/theme_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/index.dart';
import 'package:athkar_app/app/di/service_locator.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _selectedThemeMode = AppTheme.themeModeNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IslamicAppBar(title: 'المظهر والسمة'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معاينة السمة الحالية
            _buildThemePreview(context),
            
            Spaces.large,
            
            // خيارات السمة
            _buildThemeOptions(context),
            
            Spaces.large,
            
            // معلومات مفيدة
            _buildInfoSection(context),
            
            Spaces.large,
            
            // زر حفظ الإعدادات
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreview(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.preview_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'معاينة السمة',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          // عينة من المكونات
          Container(
            padding: EdgeInsets.all(context.mediumPadding),
            decoration: BoxDecoration(
              color: context.backgroundColor,
              borderRadius: BorderRadius.circular(context.mediumRadius),
              border: Border.all(color: context.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // شريط تطبيق مصغر
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.smallPadding),
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(context.smallRadius),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: ThemeConstants.iconSm,
                        color: context.textColor,
                      ),
                      Spaces.smallH,
                      Text(
                        'تطبيق الأذكار',
                        style: context.bodyStyle.copyWith(
                          fontWeight: ThemeConstants.fontSemiBold,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.notifications,
                        size: ThemeConstants.iconSm,
                        color: context.secondaryTextColor,
                      ),
                    ],
                  ),
                ),
                
                Spaces.small,
                
                // نص عادي
                Text(
                  'هذا مثال على النص العادي في التطبيق',
                  style: context.bodyStyle,
                ),
                
                Spaces.xs,
                
                // نص ثانوي
                Text(
                  'هذا مثال على النص الثانوي أو التوضيحي',
                  style: context.captionStyle,
                ),
                
                Spaces.small,
                
                // زر مصغر
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.smallPadding,
                    vertical: context.smallPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor,
                    borderRadius: BorderRadius.circular(context.smallRadius),
                  ),
                  child: Text(
                    'زر المثال',
                    style: context.captionStyle.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.fontSemiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOptions(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.palette_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'خيارات السمة',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Text(
            'اختر السمة المناسبة لك',
            style: context.captionStyle,
          ),
          
          Spaces.medium,
          
          // السمة التلقائية
          _buildThemeOption(
            context: context,
            title: 'تلقائي (حسب النظام)',
            subtitle: 'يتبع إعدادات النظام تلقائياً',
            icon: Icons.auto_mode_outlined,
            themeMode: ThemeMode.system,
          ),
          
          Spaces.small,
          
          // السمة الفاتحة
          _buildThemeOption(
            context: context,
            title: 'الوضع الفاتح',
            subtitle: 'خلفية فاتحة ونصوص داكنة',
            icon: Icons.light_mode_outlined,
            themeMode: ThemeMode.light,
          ),
          
          Spaces.small,
          
          // السمة الداكنة
          _buildThemeOption(
            context: context,
            title: 'الوضع الداكن',
            subtitle: 'خلفية داكنة ونصوص فاتحة',
            icon: Icons.dark_mode_outlined,
            themeMode: ThemeMode.dark,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode themeMode,
  }) {
    final isSelected = _selectedThemeMode == themeMode;
    
    return GestureDetector(
      onTap: () => _selectThemeMode(themeMode),
      child: Container(
        padding: EdgeInsets.all(context.mediumPadding),
        decoration: BoxDecoration(
          color: isSelected 
              ? context.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(context.smallRadius),
          border: Border.all(
            color: isSelected 
                ? context.primaryColor
                : context.borderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? context.primaryColor 
                  : context.secondaryTextColor,
            ),
            Spaces.mediumH,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodyStyle.copyWith(
                      fontWeight: isSelected 
                          ? ThemeConstants.fontSemiBold 
                          : ThemeConstants.fontMedium,
                      color: isSelected ? context.primaryColor : null,
                    ),
                  ),
                  Spaces.xs,
                  Text(
                    subtitle,
                    style: context.captionStyle,
                  ),
                ],
              ),
            ),
            if (isSelected) ...[
              Spaces.smallH,
              Icon(
                Icons.check_circle,
                color: context.primaryColor,
                size: ThemeConstants.iconSm,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
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
                'معلومات مفيدة',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          _buildInfoItem(
            context: context,
            icon: Icons.battery_saver_outlined,
            title: 'توفير البطارية',
            description: 'الوضع الداكن يساعد في توفير طاقة البطارية في الشاشات OLED',
          ),
          
          Spaces.small,
          
          _buildInfoItem(
            context: context,
            icon: Icons.remove_red_eye_outlined,
            title: 'راحة العين',
            description: 'الوضع الداكن أكثر راحة للعينين في الإضاءة المنخفضة',
          ),
          
          Spaces.small,
          
          _buildInfoItem(
            context: context,
            icon: Icons.sync_outlined,
            title: 'التزامن التلقائي',
            description: 'الوضع التلقائي يتغير حسب وقت اليوم أو إعدادات النظام',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: ThemeConstants.iconSm,
          color: context.secondaryTextColor,
        ),
        Spaces.smallH,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.bodyStyle.copyWith(
                  fontWeight: ThemeConstants.fontMedium,
                ),
              ),
              Spaces.xs,
              Text(
                description,
                style: context.captionStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: IslamicButton.primary(
        text: 'حفظ الإعدادات',
        icon: Icons.save_outlined,
        onPressed: _saveSettings,
      ),
    );
  }

  void _selectThemeMode(ThemeMode mode) {
    setState(() {
      _selectedThemeMode = mode;
    });
    
    // تطبيق السمة فوراً للمعاينة
    AppTheme.setThemeMode(mode);
  }

  Future<void> _saveSettings() async {
    try {
      final storage = context.storageService;
      
      // حفظ السمة المختارة
      await storage.setString('theme_mode', _selectedThemeMode.toString());
      
      // تطبيق السمة
      AppTheme.setThemeMode(_selectedThemeMode);
      
      if (mounted) {
        context.showSuccessMessage('تم حفظ إعدادات المظهر');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء حفظ الإعدادات');
      }
    }
  }
}