// lib/features/tasbih/screens/tasbih_screen.dart (مُحدث بنمط Glassmorphism)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../../app/themes/app_theme.dart';
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
          // أيقونة التطبيق
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              gradient: context.successGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: context.successColor.withValues(alpha: 0.3),
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
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.3),
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
                    color: context.primaryColor,
                  ),
                  tooltip: 'تصفير العداد',
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space2),
              
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.3),
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
                width: 120,
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
                        ? item.primaryColor.withValues(alpha: 0.3)
                        : context.dividerColor.withValues(alpha: 0.3),
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
                      style: context.labelMedium?.copyWith(
                        color: isSelected 
                            ? Colors.white 
                            : context.textPrimaryColor,
                        fontWeight: isSelected 
                            ? ThemeConstants.bold 
                            : ThemeConstants.medium,
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
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
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
              padding: const EdgeInsets.all(ThemeConstants.space5),
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
                        style: context.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                          fontSize: 24, // زيادة حجم النص
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
                      
                      const SizedBox(height: ThemeConstants.space2),
                      
                      Text(
                        selectedItem.meaning,
                        style: context.bodyMedium?.copyWith(
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
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space6),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.2),
          width: 1,
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
                        size: ThemeConstants.icon2xl,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      const SizedBox(height: ThemeConstants.space2),
                      Text(
                        'سَبِّح',
                        style: context.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
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