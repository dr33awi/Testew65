// lib/features/tasbih/screens/tasbih_screen.dart
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
  
  final List<TasbihItem> _tasbihItems = [
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ',
      transliteration: 'سبحان الله',
      meaning: 'تنزيه الله عن كل نقص',
      colors: [ThemeConstants.primary, ThemeConstants.primaryLight],
    ),
    TasbihItem(
      text: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'الحمد لله',
      meaning: 'الثناء والشكر لله',
      colors: [ThemeConstants.accent, ThemeConstants.accentLight],
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      colors: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      colors: [ThemeConstants.success, ThemeConstants.successLight],
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      colors: [ThemeConstants.warning, ThemeConstants.warningLight],
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      colors: [ThemeConstants.info, ThemeConstants.infoLight],
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
    AppInfoDialog.showConfirmation(
      context: context,
      title: 'تصفير العداد',
      content: 'هل أنت متأكد من تصفير عداد التسبيح؟',
      confirmText: 'تصفير',
      cancelText: 'إلغاء',
      icon: Icons.refresh_rounded,
      destructive: true,
    ).then((result) {
      if (result == true) {
        _service.reset();
        HapticFeedback.lightImpact();
        context.showSuccessSnackBar('تم تصفير العداد');
      }
    });
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
                        
                        ThemeConstants.space4.sliverBox,
                        
                        // نص التسبيح المختار
                        SliverToBoxAdapter(
                          child: _buildSelectedTasbih(context),
                        ),
                        
                        ThemeConstants.space6.sliverBox,
                        
                        // العداد الرئيسي
                        SliverToBoxAdapter(
                          child: _buildMainCounter(context, service),
                        ),
                        
                        ThemeConstants.space6.sliverBox,
                        
                        // زر التسبيح
                        SliverToBoxAdapter(
                          child: _buildTasbihButton(context),
                        ),
                        
                        ThemeConstants.space6.sliverBox,
                        
                        // الإحصائيات
                        SliverToBoxAdapter(
                          child: _buildStatistics(context, service),
                        ),
                        
                        ThemeConstants.space8.sliverBox,
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
    return CustomAppBar(
      title: 'المسبحة الرقمية',
      actions: [
        AppBarAction(
          icon: Icons.refresh_rounded,
          onPressed: _onReset,
          tooltip: 'تصفير العداد',
        ),
        AppBarAction(
          icon: Icons.info_outline,
          onPressed: () => _showTasbihInfo(),
          tooltip: 'معلومات التسبيح',
        ),
      ],
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
            child: AnimatedPress(
              onTap: () {
                setState(() {
                  _selectedTasbihIndex = index;
                });
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: ThemeConstants.durationNormal,
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space4,
                  vertical: ThemeConstants.space3,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected 
                      ? LinearGradient(
                          colors: item.colors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: !isSelected ? context.cardColor : null,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                  border: Border.all(
                    color: isSelected 
                        ? item.colors[0].withValues(alpha: 0.3)
                        : context.dividerColor.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: item.colors[0].withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ] : null,
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
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          colors: selectedItem.colors.map((c) => c.withValues(alpha: 0.9)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            ),
            child: Column(
              children: [
                // أيقونة التسبيح
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                
                ThemeConstants.space3.h,
                
                // النص العربي
                Text(
                  selectedItem.text,
                  style: context.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    fontFamily: ThemeConstants.fontFamilyArabic,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                ThemeConstants.space2.h,
                
                // المعنى
                Text(
                  selectedItem.meaning,
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
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
      child: AppCard(
        backgroundColor: context.cardColor,
        elevation: ThemeConstants.elevation2,
        child: Column(
          children: [
            Text(
              'العدد',
              style: context.titleMedium?.copyWith(
                color: context.textSecondaryColor,
                fontWeight: ThemeConstants.medium,
              ),
            ),
            
            ThemeConstants.space2.h,
            
            Text(
              '${service.count}',
              style: context.displayLarge?.copyWith(
                color: selectedItem.colors[0],
                fontWeight: ThemeConstants.bold,
              ),
            ),
            
            ThemeConstants.space1.h,
            
            Text(
              service.count == 1 ? 'تسبيحة' : 'تسبيحة',
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasbihButton(BuildContext context) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return AnimatedPress(
      onTap: _onTasbihTap,
      scaleFactor: 0.95,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: selectedItem.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: selectedItem.colors[0].withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
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
                const Icon(
                  Icons.touch_app_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                ThemeConstants.space2.h,
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
    );
  }

  Widget _buildStatistics(BuildContext context, TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: AppCard(
        backgroundColor: context.cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الإحصائيات
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: selectedItem.colors[0].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: selectedItem.colors[0],
                    size: ThemeConstants.iconMd,
                  ),
                ),
                ThemeConstants.space3.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الإحصائيات',
                        style: context.titleMedium?.semiBold,
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
            
            ThemeConstants.space4.h,
            
            // الإحصائيات
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'العدد الكلي',
                    value: '${service.count}',
                    icon: Icons.format_list_numbered_rounded,
                    color: selectedItem.colors[0],
                  ),
                ),
                
                ThemeConstants.space3.w,
                
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'الأطقم',
                    value: '${(service.count / 33).floor()}',
                    icon: Icons.repeat_rounded,
                    color: ThemeConstants.success,
                  ),
                ),
                
                ThemeConstants.space3.w,
                
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'الباقي',
                    value: '${33 - (service.count % 33 == 0 ? 33 : service.count % 33)}',
                    icon: Icons.more_horiz_rounded,
                    color: ThemeConstants.warning,
                  ),
                ),
              ],
            ),
            
            ThemeConstants.space4.h,
            
            // شريط التقدم للطقم الحالي
            _buildProgressBar(context, service),
          ],
        ),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ThemeConstants.iconMd,
          ),
          ThemeConstants.space1.h,
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
                color: selectedItem.colors[0],
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ],
        ),
        
        ThemeConstants.space2.h,
        
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(selectedItem.colors[0]),
            ),
          ),
        ),
      ],
    );
  }

  void _showTasbihInfo() {
    AppInfoDialog.show(
      context: context,
      title: 'عن التسبيح',
      content: 'التسبيح هو ذكر الله وتنزيهه عن كل نقص. قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"',
      icon: Icons.auto_awesome,
      accentColor: _tasbihItems[_selectedTasbihIndex].colors[0],
    );
  }
}

/// نموذج بيانات التسبيح
class TasbihItem {
  final String text;
  final String transliteration;
  final String meaning;
  final List<Color> colors;

  const TasbihItem({
    required this.text,
    required this.transliteration,
    required this.meaning,
    required this.colors,
  });
}