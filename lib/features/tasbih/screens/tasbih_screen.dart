// lib/features/tasbih/screens/tasbih_screen.dart - محدث بالنظام الموحد الإسلامي
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

// ✅ استيراد النظام الموحد الإسلامي
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
import '../../../app/themes/widgets/extended_cards.dart';

import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/tasbih_service.dart';

/// شاشة المسبحة الرقمية مع الثيم الإسلامي الموحد
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> 
    with SingleTickerProviderStateMixin {
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
      primaryColor: AppTheme.primary,
    ),
    TasbihItem(
      text: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'الحمد لله',
      meaning: 'الثناء والشكر لله',
      primaryColor: AppTheme.accent,
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      primaryColor: AppTheme.secondary,
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      primaryColor: AppTheme.tertiary,
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      primaryColor: AppTheme.info,
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      primaryColor: AppTheme.success,
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
    
    // إعداد الرسوم المتحركة
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
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
    
    // تشغيل الرسوم المتحركة
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
        title: Row(
          children: [
            const Icon(
              Icons.refresh,
              color: AppTheme.warning,
              size: 24,
            ),
            AppTheme.space2.w,
            const Text('تصفير العداد'),
          ],
        ),
        content: const Text('هل أنت متأكد من تصفير عداد التسبيح؟'),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        actions: [
          AppButton.text(
            text: 'إلغاء',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton.primary(
            text: 'تصفير',
            backgroundColor: AppTheme.error,
            icon: Icons.refresh,
            onPressed: () {
              Navigator.of(context).pop();
              _service.reset();
              HapticFeedback.lightImpact();
              _showSuccessSnackBar('تم تصفير العداد');
            },
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
        backgroundColor: AppTheme.background,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Consumer<TasbihService>(
            builder: (context, service, _) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // بطاقة الترحيب والإحصائيات
                  SliverToBoxAdapter(
                    child: _buildWelcomeCard(context, service),
                  ),
                  
                  SliverToBoxAdapter(child: AppTheme.space4.h),
                  
                  // اختيار نوع التسبيح
                  SliverToBoxAdapter(
                    child: _buildTasbihSelector(context),
                  ),
                  
                  SliverToBoxAdapter(child: AppTheme.space4.h),
                  
                  // نص التسبيح المختار
                  SliverToBoxAdapter(
                    child: _buildSelectedTasbih(context),
                  ),
                  
                  SliverToBoxAdapter(child: AppTheme.space6.h),
                  
                  // العداد الرئيسي
                  SliverToBoxAdapter(
                    child: _buildMainCounter(context, service),
                  ),
                  
                  SliverToBoxAdapter(child: AppTheme.space6.h),
                  
                  // زر التسبيح
                  SliverToBoxAdapter(
                    child: _buildTasbihButton(context),
                  ),
                  
                  SliverToBoxAdapter(child: AppTheme.space8.h),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return SimpleAppBar(
      title: 'المسبحة الرقمية',
      actions: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            _onReset();
          },
          icon: const Icon(
            Icons.refresh_rounded,
            color: AppTheme.primary,
          ),
          tooltip: 'تصفير العداد',
        ),
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            _showTasbihInfo();
          },
          icon: const Icon(
            Icons.info_outline,
            color: AppTheme.primary,
          ),
          tooltip: 'معلومات التسبيح',
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context, TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: AppTheme.space4.padding,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: AppTheme.radiusLg.radius,
      ),
      child: ClipRRect(
        borderRadius: AppTheme.radiusLg.radius,
        child: Stack(
          children: [
            // الخلفية المتدرجة
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    selectedItem.primaryColor,
                    selectedItem.primaryColor.darken(0.2),
                  ].map((c) => c.withValues(alpha: 0.9)).toList(),
                ),
              ),
            ),
            
            // الطبقة الزجاجية
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
            
            // المحتوى
            Padding(
              padding: AppTheme.space5.padding,
              child: Row(
                children: [
                  // الأيقونة
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  
                  AppTheme.space4.w,
                  
                  // النصوص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'المسبحة الرقمية',
                          style: AppTheme.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.bold,
                            fontSize: 18,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        
                        AppTheme.space1.h,
                        
                        Text(
                          'سَبِّحِ اسْمَ رَبِّكَ الْأَعْلَى',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // العداد السريع
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space3,
                      vertical: AppTheme.space2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppTheme.radiusFull.radius,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${service.count}',
                          style: AppTheme.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.bold,
                            fontFamily: AppTheme.numbersFont,
                          ),
                        ),
                        Text(
                          'تسبيحة',
                          style: AppTheme.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // العناصر الزخرفية
            _buildDecorativeElements(),
          ],
        ),
      ),
    );
  }

  Widget _buildTasbihSelector(BuildContext context) {
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
            margin: const EdgeInsets.only(left: AppTheme.space3),
            child: AnimatedPress(
              onTap: () {
                setState(() {
                  _selectedTasbihIndex = index;
                });
                HapticFeedback.selectionClick();
              },
              child: Container(
                width: 120,
                padding: AppTheme.space4.paddingH + AppTheme.space3.paddingV,
                decoration: CardHelper.getCardDecoration(
                  color: isSelected ? item.primaryColor : null,
                  useGradient: isSelected,
                  gradientColors: isSelected ? [
                    item.primaryColor,
                    item.primaryColor.darken(0.2),
                  ] : null,
                  borderRadius: AppTheme.radiusLg,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.transliteration,
                      style: AppTheme.labelMedium.copyWith(
                        color: isSelected 
                            ? Colors.white 
                            : AppTheme.textPrimary,
                        fontWeight: isSelected 
                            ? AppTheme.bold 
                            : AppTheme.medium,
                        shadows: isSelected ? [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ] : null,
                      ),
                      textAlign: TextAlign.center,
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
    
    return AppCard(
      margin: AppTheme.space4.padding,
      useGradient: true,
      color: selectedItem.primaryColor,
      child: Column(
        children: [
          Text(
            selectedItem.text,
            style: CardHelper.getTextStyle('quran').copyWith(
              color: Colors.white,
              fontSize: 24,
              fontWeight: AppTheme.bold,
              height: 1.8,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          
          AppTheme.space3.h,
          
          Container(
            padding: AppTheme.space3.paddingH + AppTheme.space1.paddingV,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppTheme.radiusFull.radius,
            ),
            child: Text(
              selectedItem.meaning,
              style: AppTheme.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: AppTheme.medium,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCounter(BuildContext context, TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return TasbihStatCard(
      totalCount: service.totalCount,
      todayCount: service.count,
      streakDays: service.streakDays,
      onTap: () {
        // يمكن إضافة تفاصيل الإحصائيات هنا
      },
    );
  }

  Widget _buildTasbihButton(BuildContext context) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: AnimatedPress(
              onTap: _onTasbihTap,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Stack(
                    children: [
                      // الخلفية المتدرجة
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              selectedItem.primaryColor,
                              selectedItem.primaryColor.darken(0.2),
                            ].map((c) => c.withValues(alpha: 0.9)).toList(),
                          ),
                        ),
                      ),
                      
                      // الطبقة الزجاجية
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      
                      // المحتوى في المنتصف
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.touch_app_rounded,
                              color: Colors.white,
                              size: 48,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            AppTheme.space2.h,
                            Text(
                              'سَبِّح',
                              style: AppTheme.titleLarge.copyWith(
                                color: Colors.white,
                                fontWeight: AppTheme.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // العناصر الزخرفية
                      _buildDecorativeElements(),
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

  Widget _buildDecorativeElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          // دائرة زخرفية صغيرة
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          
          // دائرة إضافية
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTasbihInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: AppTheme.getCategoryColor('تسبيح'),
              size: 24,
            ),
            AppTheme.space2.w,
            const Text('عن التسبيح'),
          ],
        ),
        content: const Text(
          'التسبيح هو ذكر الله وتنزيهه عن كل نقص. قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        actions: [
          AppButton.text(
            text: 'فهمت',
            onPressed: () => Navigator.of(context).pop(),
            textColor: AppTheme.getCategoryColor('تسبيح'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
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
}

/// نموذج بيانات التسبيح
class TasbihItem {
  final String text;
  final String transliteration;
  final String meaning;
  final Color primaryColor;

  const TasbihItem({
    required this.text,
    required this.transliteration,
    required this.meaning,
    required this.primaryColor,
  });
}