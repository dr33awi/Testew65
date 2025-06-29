// lib/features/tasbih/screens/tasbih_screen.dart - محدث ومصحح
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/tasbih_service.dart';

/// شاشة المسبحة الرقمية مع نمط Glassmorphism
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  late TasbihService _service;
  late LoggerService _logger;

  int _selectedTasbihIndex = 0;
  
  List<TasbihItem> get _tasbihItems => [
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ',
      transliteration: 'سبحان الله',
      meaning: 'تنزيه الله عن كل نقص',
      gradient: AppTheme.primaryGradient,
      primaryColor: AppTheme.primary,
    ),
    TasbihItem(
      text: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'الحمد لله',
      meaning: 'الثناء والشكر لله',
      gradient: AppTheme.secondaryGradient,
      primaryColor: AppTheme.secondary,
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      gradient: LinearGradient(
        colors: [AppTheme.tertiary, AppTheme.tertiary.darken(0.2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      primaryColor: AppTheme.tertiary,
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      gradient: AppTheme.primaryGradient,
      primaryColor: AppTheme.primary,
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      gradient: AppTheme.secondaryGradient,
      primaryColor: AppTheme.secondary,
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      gradient: LinearGradient(
        colors: [AppTheme.tertiary, AppTheme.tertiary.darken(0.2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      primaryColor: AppTheme.tertiary,
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
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        actions: [
          AppButton.text(
            text: 'إلغاء',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton.primary(
            text: 'تصفير',
            backgroundColor: AppTheme.error,
            onPressed: () {
              Navigator.of(context).pop();
              _service.reset();
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم تصفير العداد'),
                  backgroundColor: AppTheme.success,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
              );
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
                        
                        SliverToBoxAdapter(
                          child: AppTheme.space4.h,
                        ),
                        
                        // نص التسبيح المختار
                        SliverToBoxAdapter(
                          child: _buildSelectedTasbih(context),
                        ),
                        
                        SliverToBoxAdapter(
                          child: AppTheme.space6.h,
                        ),
                        
                        // العداد الرئيسي
                        SliverToBoxAdapter(
                          child: _buildMainCounter(context, service),
                        ),
                        
                        SliverToBoxAdapter(
                          child: AppTheme.space6.h,
                        ),
                        
                        // زر التسبيح
                        SliverToBoxAdapter(
                          child: _buildTasbihButton(context),
                        ),
                        
                        SliverToBoxAdapter(
                          child: AppTheme.space8.h,
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
      padding: AppTheme.space4.padding,
      child: Row(
        children: [
          // أيقونة التطبيق
          Container(
            width: 56,
            height: 56,
            padding: AppTheme.space3.padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.success, AppTheme.success.darken(0.2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.success.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: AppTheme.iconMd,
            ),
          ),
          
          AppTheme.space3.w,
          
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المسبحة الرقمية',
                  style: AppTheme.titleLarge.copyWith(
                    fontWeight: AppTheme.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'سبح الله واذكره',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
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
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(
                    color: AppTheme.divider.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _onReset();
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: AppTheme.primary,
                  ),
                  tooltip: 'تصفير العداد',
                ),
              ),
              
              AppTheme.space2.w,
              
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(
                    color: AppTheme.divider.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showTasbihInfo();
                  },
                  icon: Icon(
                    Icons.info_outline,
                    color: AppTheme.primary,
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
      margin: EdgeInsets.symmetric(horizontal: AppTheme.space4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tasbihItems.length,
        itemBuilder: (context, index) {
          final item = _tasbihItems[index];
          final isSelected = index == _selectedTasbihIndex;
          
          return Container(
            margin: EdgeInsets.only(right: AppTheme.space3),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTasbihIndex = index;
                });
                HapticFeedback.selectionClick();
              },
              child: Container(
                width: 120,
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.space4,
                  vertical: AppTheme.space3,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? item.gradient : null,
                  color: !isSelected ? AppTheme.card : null,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(
                    color: isSelected 
                        ? item.primaryColor.withValues(alpha: 0.3)
                        : AppTheme.divider.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: item.primaryColor.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ] : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ] : null,
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
      margin: EdgeInsets.symmetric(horizontal: AppTheme.space4),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
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
              padding: EdgeInsets.all(AppTheme.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // النصوص
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedItem.text,
                        style: AppTheme.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: AppTheme.bold,
                          fontSize: 24,
                          height: 1.2,
                          letterSpacing: 0.3,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      AppTheme.space2.h,
                      
                      Text(
                        selectedItem.meaning,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

  Widget _buildMainCounter(BuildContext context, TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppTheme.space4),
      padding: EdgeInsets.all(AppTheme.space6),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.divider.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'العدد',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: AppTheme.medium,
            ),
          ),
          
          AppTheme.space2.h,
          
          Text(
            '${service.count}',
            style: AppTheme.displayLarge.copyWith(
              color: selectedItem.primaryColor,
              fontWeight: AppTheme.bold,
            ),
          ),
          
          AppTheme.space1.h,
          
          Text(
            service.count == 1 ? 'تسبيحة' : 'تسبيحة',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
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
                        width: 1,
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
                        size: AppTheme.iconXl,
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
                
                // طبقة التفاعل
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _onTasbihTap,
                    borderRadius: BorderRadius.circular(100),
                    splashColor: Colors.white.withValues(alpha: 0.2),
                    highlightColor: Colors.white.withValues(alpha: 0.1),
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
        title: const Text('عن التسبيح'),
        content: const Text(
          'التسبيح هو ذكر الله وتنزيهه عن كل نقص. قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        actions: [
          AppButton.text(
            text: 'فهمت',
            onPressed: () => Navigator.of(context).pop(),
            textColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}

/// نموذج بيانات التسبيح
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