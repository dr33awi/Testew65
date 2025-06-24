// lib/features/tasbih/screens/tasbih_screen.dart (مُصلح)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/tasbih_service.dart';

/// شاشة المسبحة الرقمية المبسطة
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  late TasbihService _service;
  late LoggerService _logger;

  int _selectedTasbihIndex = 0;
  
  // تحديث قائمة التسبيح لتستخدم gradients موحدة
  List<TasbihItem> get _tasbihItems => [
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ',
      transliteration: 'سبحان الله',
      meaning: 'تنزيه الله عن كل نقص',
      gradient: context.primaryGradient,
      primaryColor: context.primaryColor,
    ),
    TasbihItem(
      text: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'الحمد لله',
      meaning: 'الثناء والشكر لله',
      gradient: context.accentGradient,
      primaryColor: context.accentColor,
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      gradient: context.tertiaryGradient,
      primaryColor: context.tertiaryColor,
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      gradient: context.primaryGradient,
      primaryColor: context.primaryColor,
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      gradient: context.accentGradient,
      primaryColor: context.accentColor,
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      gradient: context.tertiaryGradient,
      primaryColor: context.tertiaryColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _service = TasbihService(
      storage: getIt<StorageService>(),
      logger: getIt<LoggerService>(),
    );
    _logger = getIt<LoggerService>();
  }

  void _onTasbihTap() {
    _service.increment();
    HapticFeedback.mediumImpact();
    
    _logger.debug(
      message: '[TasbihScreen] increment',
      data: {'count': _service.count},
    );
  }

  void _onReset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفير العداد'),
        content: const Text('هل أنت متأكد من تصفير عداد التسبيح؟'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: TextStyle(color: context.textSecondaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _service.reset();
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم تصفير العداد'),
                  backgroundColor: context.successColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
            ),
            child: const Text('تصفير'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _service,
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // شريط التنقل العلوي
              _buildAppBar(context),
              
              // المحتوى
              Expanded(
                child: Consumer<TasbihService>(
                  builder: (context, service, _) {
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // اختيار نوع التسبيح
                        SliverToBoxAdapter(
                          child: _buildTasbihSelector(context),
                        ),
                        
                        const SliverToBoxAdapter(
                          child: SizedBox(height: ThemeConstants.space4),
                        ),
                        
                        // نص التسبيح المختار
                        SliverToBoxAdapter(
                          child: _buildSelectedTasbih(context),
                        ),
                        
                        const SliverToBoxAdapter(
                          child: SizedBox(height: ThemeConstants.space6),
                        ),
                        
                        // العداد الرئيسي
                        SliverToBoxAdapter(
                          child: _buildMainCounter(context, service),
                        ),
                        
                        const SliverToBoxAdapter(
                          child: SizedBox(height: ThemeConstants.space6),
                        ),
                        
                        // زر التسبيح
                        SliverToBoxAdapter(
                          child: _buildTasbihButton(context),
                        ),
                        
                        const SliverToBoxAdapter(
                          child: SizedBox(height: ThemeConstants.space6),
                        ),
                        
                        // الإحصائيات
                        SliverToBoxAdapter(
                          child: _buildStatistics(context, service),
                        ),
                        
                        const SliverToBoxAdapter(
                          child: SizedBox(height: ThemeConstants.space8),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
        children: [
          // أيقونة التطبيق - استخدام ألوان الثيم الموحدة
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              gradient: context.successGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: context.successColor.withValues(alpha: ThemeConstants.opacity30),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المسبحة الرقمية',
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  'سبح الله واذكره',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // الإجراءات
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                  ),
                  boxShadow: ThemeConstants.shadowSm,
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _onReset();
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: context.primaryColor,
                  ),
                  tooltip: 'تصفير العداد',
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space2),
              
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                  ),
                  boxShadow: ThemeConstants.shadowSm,
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showTasbihInfo();
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: context.primaryColor,
                  ),
                  tooltip: 'معلومات التسبيح',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihSelector(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tasbihItems.length,
        itemBuilder: (context, index) {
          final item = _tasbihItems[index];
          final isSelected = index == _selectedTasbihIndex;
          
          return Container(
            margin: const EdgeInsets.only(right: ThemeConstants.space3),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTasbihIndex = index;
                });
                HapticFeedback.selectionClick();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space4,
                  vertical: ThemeConstants.space3,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? item.gradient : null,
                  color: !isSelected ? context.cardColor : null,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  border: Border.all(
                    color: isSelected 
                        ? item.primaryColor.withValues(alpha: ThemeConstants.opacity30)
                        : context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                    width: isSelected ? ThemeConstants.borderMedium : ThemeConstants.borderLight,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: item.primaryColor.withValues(alpha: ThemeConstants.opacity20),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ] : ThemeConstants.shadowSm,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.transliteration,
                      style: context.labelMedium?.copyWith(
                        color: isSelected 
                            ? Colors.white 
                            : context.textPrimaryColor,
                        fontWeight: isSelected 
                            ? ThemeConstants.bold 
                            : ThemeConstants.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedTasbih(BuildContext context) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        gradient: selectedItem.gradient,
        boxShadow: [
          BoxShadow(
            color: selectedItem.primaryColor.withValues(alpha: ThemeConstants.opacity30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                width: ThemeConstants.borderThin,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            ),
            child: Column(
              children: [
                // أيقونة التسبيح
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                      width: ThemeConstants.borderThin,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: ThemeConstants.iconLg,
                  ),
                ),
                
                const SizedBox(height: ThemeConstants.space3),
                
                // النص العربي
                Text(
                  selectedItem.text,
                  style: context.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    fontFamily: ThemeConstants.fontFamilyQuran,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: ThemeConstants.space2),
                
                // المعنى
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space3,
                    vertical: ThemeConstants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                      width: ThemeConstants.borderThin,
                    ),
                  ),
                  child: Text(
                    selectedItem.meaning,
                    style: context.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                      fontWeight: ThemeConstants.medium,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCounter(BuildContext context, TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space6),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowMd,
        border: Border.all(
          color: context.dividerColor.withValues(alpha: ThemeConstants.opacity20),
          width: ThemeConstants.borderThin,
        ),
      ),
      child: Column(
        children: [
          Text(
            'العدد',
            style: context.titleMedium?.copyWith(
              color: context.textSecondaryColor,
              fontWeight: ThemeConstants.medium,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space2),
          
          Text(
            '${service.count}',
            style: context.displayLarge?.copyWith(
              color: selectedItem.primaryColor,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space1),
          
          Text(
            service.count == 1 ? 'تسبيحة' : 'تسبيحة',
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihButton(BuildContext context) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Center(
      child: GestureDetector(
        onTap: _onTasbihTap,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            gradient: selectedItem.gradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: selectedItem.primaryColor.withValues(alpha: ThemeConstants.opacity40),
                blurRadius: 30,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: ThemeConstants.opacity10),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _onTasbihTap,
              borderRadius: BorderRadius.circular(100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: Colors.white,
                    size: ThemeConstants.icon2xl,
                  ),
                  const SizedBox(height: ThemeConstants.space2),
                  Text(
                    'سَبِّح',
                    style: context.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان الإحصائيات
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: selectedItem.primaryColor.withValues(alpha: ThemeConstants.opacity10),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: selectedItem.primaryColor,
                  size: ThemeConstants.iconMd,
                ),
              ),
              const SizedBox(width: ThemeConstants.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإحصائيات',
                      style: context.titleMedium?.copyWith(
                        fontWeight: ThemeConstants.semiBold,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    Text(
                      'تتبع تقدمك في التسبيح',
                      style: context.bodySmall?.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // الإحصائيات
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'العدد الكلي',
                  value: '${service.count}',
                  icon: Icons.format_list_numbered_rounded,
                  color: selectedItem.primaryColor,
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space3),
              
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'الأطقم',
                  value: '${(service.count / 33).floor()}',
                  icon: Icons.repeat_rounded,
                  color: context.successColor,
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space3),
              
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'الباقي',
                  value: '${33 - (service.count % 33 == 0 ? 33 : service.count % 33)}',
                  icon: Icons.more_horiz_rounded,
                  color: context.accentColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // شريط التقدم للطقم الحالي
          _buildProgressBar(context, service),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: ThemeConstants.opacity10),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: ThemeConstants.opacity20),
          width: ThemeConstants.borderThin,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ThemeConstants.iconMd,
          ),
          const SizedBox(height: ThemeConstants.space1),
          Text(
            value,
            style: context.titleLarge?.copyWith(
              color: color,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          Text(
            title,
            style: context.labelSmall?.copyWith(
              color: context.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    final currentSetProgress = service.count % 33;
    final progress = currentSetProgress / 33;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تقدم الطقم الحالي',
              style: context.labelMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
            Text(
              '$currentSetProgress / 33',
              style: context.labelMedium?.copyWith(
                color: selectedItem.primaryColor,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: ThemeConstants.space2),
        
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(selectedItem.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  void _showTasbihInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('عن التسبيح'),
        content: const Text(
          'التسبيح هو ذكر الله وتنزيهه عن كل نقص. قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'فهمت',
              style: TextStyle(color: context.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// نموذج بيانات التسبيح المُحدث
class TasbihItem {
  final String text;
  final String transliteration;
  final String meaning;
  final LinearGradient gradient;
  final Color primaryColor;

  const TasbihItem({
    required this.text,
    required this.transliteration,
    required this.meaning,
    required this.gradient,
    required this.primaryColor,
  });
}