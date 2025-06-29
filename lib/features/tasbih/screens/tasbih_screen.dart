// lib/features/tasbih/screens/tasbih_screen.dart - محدث بالثيم الإسلامي الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import '../../../app/themes/index.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/tasbih_service.dart';

/// شاشة المسبحة الرقمية - محدثة بالنظام الموحد
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> with SingleTickerProviderStateMixin {
  late TasbihService _service;
  late LoggerService _logger;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  int _selectedTasbihIndex = 0;
  
  List<TasbihItem> get _tasbihItems => [
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ',
      transliteration: 'سبحان الله',
      meaning: 'تنزيه الله عن كل نقص',
      color: AppTheme.primary,
    ),
    TasbihItem(
      text: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'الحمد لله',
      meaning: 'الثناء والشكر لله',
      color: AppTheme.secondary,
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      color: AppTheme.tertiary,
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      color: AppTheme.accent,
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      color: AppTheme.info,
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      color: AppTheme.success,
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
    
    _animationController = AnimationController(
      duration: AppTheme.durationFast,
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTasbihTap() {
    _service.increment();
    HapticFeedback.mediumImpact();
    
    // تشغيل الأنيميشن
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    _logger.debug(
      message: '[TasbihScreen] increment',
      data: {'count': _service.count},
    );
  }

  void _onReset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تصفير العداد',
          style: context.titleLarge,
        ),
        content: Text(
          'هل أنت متأكد من تصفير عداد التسبيح؟',
          style: context.bodyMedium,
        ),
        backgroundColor: context.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        actions: [
          AppButton.outline(
            text: 'إلغاء',
            onPressed: () => Navigator.of(context).pop(),
            borderColor: AppTheme.textSecondary,
          ),
          AppTheme.space2.w,
          AppButton(
            text: 'تصفير',
            backgroundColor: AppTheme.error,
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
              _service.reset();
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم تصفير العداد',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.black),
                  ),
                  backgroundColor: AppTheme.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.radiusMd.radius,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTasbihInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'عن التسبيح',
          style: context.titleLarge,
        ),
        content: Text(
          'التسبيح هو ذكر الله وتنزيهه عن كل نقص. قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"',
          style: context.bodyMedium.copyWith(height: 1.6),
        ),
        backgroundColor: context.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        actions: [
          AppButton.primary(
            text: 'فهمت',
            onPressed: () => Navigator.of(context).pop(),
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
        appBar: AppAppBar.basic(
          title: 'المسبحة الرقمية',
          actions: [
            AppBarCounter(count: _service.count),
            AppTheme.space2.w,
            IconButton(
              icon: const Icon(Icons.refresh),
              color: context.primaryColor,
              onPressed: _onReset,
              tooltip: 'تصفير العداد',
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              color: context.primaryColor,
              onPressed: _showTasbihInfo,
              tooltip: 'معلومات التسبيح',
            ),
            AppTheme.space2.w,
          ],
        ),
        body: SafeArea(
          child: Consumer<TasbihService>(
            builder: (context, service, _) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // اختيار نوع التسبيح
                  SliverToBoxAdapter(
                    child: _buildTasbihSelector(),
                  ),
                  
                  SliverToBoxAdapter(
                    child: AppTheme.space4.h,
                  ),
                  
                  // نص التسبيح المختار
                  SliverToBoxAdapter(
                    child: _buildSelectedTasbih(),
                  ),
                  
                  SliverToBoxAdapter(
                    child: AppTheme.space6.h,
                  ),
                  
                  // العداد الرئيسي
                  SliverToBoxAdapter(
                    child: _buildMainCounter(service),
                  ),
                  
                  SliverToBoxAdapter(
                    child: AppTheme.space6.h,
                  ),
                  
                  // زر التسبيح
                  SliverToBoxAdapter(
                    child: _buildTasbihButton(),
                  ),
                  
                  SliverToBoxAdapter(
                    child: AppTheme.space4.h,
                  ),
                  
                  // إحصائيات سريعة
                  SliverToBoxAdapter(
                    child: _buildQuickStats(service),
                  ),
                  
                  SliverToBoxAdapter(
                    child: AppTheme.space8.h,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTasbihSelector() {
    return Container(
      height: 80,
      margin: AppTheme.space4.paddingH,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tasbihItems.length,
        itemBuilder: (context, index) {
          final item = _tasbihItems[index];
          final isSelected = index == _selectedTasbihIndex;
          
          return Container(
            margin: EdgeInsets.only(left: AppTheme.space3),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTasbihIndex = index;
                });
                HapticFeedback.selectionClick();
              },
              child: AppCard(
                useGradient: isSelected,
                color: isSelected ? item.color : null,
                margin: EdgeInsets.zero,
                padding: AppTheme.space3.padding,
                child: SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: isSelected ? Colors.white : item.color,
                        size: AppTheme.iconMd,
                      ),
                      AppTheme.space2.h,
                      Text(
                        item.transliteration,
                        style: AppTheme.labelMedium.copyWith(
                          color: isSelected ? Colors.white : null,
                          fontWeight: isSelected ? AppTheme.bold : AppTheme.medium,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedTasbih() {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: AppTheme.space4.paddingH,
      child: AppCard(
        useGradient: true,
        color: selectedItem.color,
        padding: AppTheme.space5.padding,
        child: Column(
          children: [
            Text(
              selectedItem.text,
              style: AppTheme.quranStyle.copyWith(
                color: Colors.white,
                fontSize: 24,
                fontWeight: AppTheme.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppTheme.space3.h,
            Text(
              selectedItem.meaning,
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCounter(TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: AppTheme.space4.paddingH,
      child: AppCard.stat(
        title: 'العدد الحالي',
        value: AppTheme.formatLargeNumber(service.count),
        icon: Icons.touch_app,
        color: selectedItem.color,
        subtitle: service.count == 1 ? 'تسبيحة' : 'تسبيحة',
      ),
    );
  }

  Widget _buildTasbihButton() {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: GestureDetector(
              onTap: _onTasbihTap,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.oliveGoldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: selectedItem.color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _onTasbihTap,
                    borderRadius: BorderRadius.circular(90),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app,
                            color: Colors.white,
                            size: AppTheme.iconXl,
                          ),
                          AppTheme.space2.h,
                          Text(
                            'سَبِّح',
                            style: AppTheme.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: AppTheme.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStats(TasbihService service) {
    return Container(
      margin: AppTheme.space4.paddingH,
      child: Row(
        children: [
          Expanded(
            child: AppCard.stat(
              title: 'اليوم',
              value: AppTheme.formatLargeNumber(service.dailyCount),
              icon: Icons.today,
              color: AppTheme.info,
            ),
          ),
          AppTheme.space3.w,
          Expanded(
            child: AppCard.stat(
              title: 'المجموع',
              value: AppTheme.formatLargeNumber(service.totalCount),
              icon: Icons.analytics,
              color: AppTheme.success,
            ),
          ),
          AppTheme.space3.w,
          Expanded(
            child: AppCard.stat(
              title: 'دورات',
              value: service.completedSets.toString(),
              icon: Icons.repeat,
              color: AppTheme.warning,
            ),
          ),
        ],
      ),
    );
  }
}

/// نموذج بيانات التسبيح - محدث بالثيم الموحد
class TasbihItem {
  final String text;
  final String transliteration;
  final String meaning;
  final Color color;

  const TasbihItem({
    required this.text,
    required this.transliteration,
    required this.meaning,
    required this.color,
  });
}