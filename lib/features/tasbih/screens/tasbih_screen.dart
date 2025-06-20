// lib/features/tasbih/screens/tasbih_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// ✅ استيراد النظام المبسط الجديد
import '../../../app/themes/index.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/tasbih_service.dart';

/// شاشة المسبحة الرقمية المحدثة
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
      colors: [ThemeConstants.secondary, ThemeConstants.secondaryLight],
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      colors: [ThemeConstants.accent, const Color(0xFFA67C5A)],
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      colors: [ThemeConstants.success, const Color(0xFF58D68D)],
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      colors: [ThemeConstants.warning, const Color(0xFFF7C52D)],
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      colors: [ThemeConstants.info, const Color(0xFF5DADE2)],
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _service.reset();
              HapticFeedback.lightImpact();
              context.showSuccessMessage('تم تصفير العداد');
            },
            style: ElevatedButton.styleFrom(backgroundColor: ThemeConstants.error),
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
        appBar: IslamicAppBar(
          title: 'المسبحة الرقمية',
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _onReset,
              tooltip: 'تصفير العداد',
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _showTasbihInfo,
              tooltip: 'معلومات التسبيح',
            ),
          ],
        ),
        body: SafeArea(
          child: Consumer<TasbihService>(
            builder: (context, service, _) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(ThemeConstants.spaceMd),
                child: Column(
                  children: [
                    // اختيار نوع التسبيح
                    _buildTasbihSelector(context),
                    
                    Spaces.large,
                    
                    // نص التسبيح المختار
                    _buildSelectedTasbih(context),
                    
                    Spaces.extraLarge,
                    
                    // العداد الرئيسي
                    _buildMainCounter(context, service),
                    
                    Spaces.extraLarge,
                    
                    // زر التسبيح
                    _buildTasbihButton(context),
                    
                    Spaces.extraLarge,
                    
                    // الإحصائيات
                    _buildStatistics(context, service),
                    
                    Spaces.extraLarge,
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTasbihSelector(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tasbihItems.length,
        itemBuilder: (context, index) {
          final item = _tasbihItems[index];
          final isSelected = index == _selectedTasbihIndex;
          
          return Container(
            margin: EdgeInsets.only(
              right: index == _tasbihItems.length - 1 ? 0 : ThemeConstants.spaceSm,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTasbihIndex = index;
                });
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: ThemeConstants.durationNormal,
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spaceMd,
                  vertical: ThemeConstants.spaceSm,
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
                        : context.borderColor.withValues(alpha: 0.3),
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
                child: Center(
                  child: Text(
                    item.transliteration,
                    style: AppTypography.body.copyWith(
                      color: isSelected 
                          ? Colors.white 
                          : context.textColor,
                      fontWeight: isSelected 
                          ? ThemeConstants.fontBold 
                          : ThemeConstants.fontMedium,
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

  Widget _buildSelectedTasbih(BuildContext context) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: selectedItem.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowMd,
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
          
          Spaces.medium,
          
          // النص العربي
          Text(
            selectedItem.text,
            style: AppTypography.dua.copyWith(
              color: Colors.white,
              fontSize: ThemeConstants.fontSize2xl,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          
          Spaces.small,
          
          // المعنى
          Text(
            selectedItem.meaning,
            style: AppTypography.body.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMainCounter(BuildContext context, TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceLg),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowMd,
      ),
      child: Column(
        children: [
          Text(
            'العدد',
            style: AppTypography.subtitle.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          
          Spaces.small,
          
          Text(
            '${service.count}',
            style: AppTypography.heading.copyWith(
              color: selectedItem.colors[0],
              fontSize: ThemeConstants.fontSize4xl,
            ),
          ),
          
          Spaces.xs,
          
          Text(
            service.count == 1 ? 'تسبيحة' : 'تسبيحة',
            style: AppTypography.body.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihButton(BuildContext context) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return GestureDetector(
      onTap: _onTasbihTap,
      child: AnimatedContainer(
        duration: ThemeConstants.durationNormal,
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.0),
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
                  Spaces.small,
                  Text(
                    'سَبِّح',
                    style: AppTypography.title.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.fontBold,
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
      padding: const EdgeInsets.all(ThemeConstants.spaceLg),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان الإحصائيات
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceSm),
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
              Spaces.mediumH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإحصائيات',
                      style: AppTypography.subtitle.semiBold,
                    ),
                    Text(
                      'تتبع تقدمك في التسبيح',
                      style: AppTypography.caption.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Spaces.large,
          
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
              
              Spaces.mediumH,
              
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'الأطقم',
                  value: '${(service.count / 33).floor()}',
                  icon: Icons.repeat_rounded,
                  color: ThemeConstants.success,
                ),
              ),
              
              Spaces.mediumH,
              
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
          
          Spaces.large,
          
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
      padding: const EdgeInsets.all(ThemeConstants.spaceSm),
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
          Spaces.xs,
          Text(
            value,
            style: AppTypography.title.copyWith(
              color: color,
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: context.secondaryTextColor,
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
              style: AppTypography.caption.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
            Text(
              '$currentSetProgress / 33',
              style: AppTypography.caption.copyWith(
                color: selectedItem.colors[0],
                fontWeight: ThemeConstants.fontSemiBold,
              ),
            ),
          ],
        ),
        
        Spaces.small,
        
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: _tasbihItems[_selectedTasbihIndex].colors[0],
            ),
            Spaces.smallH,
            const Text('عن التسبيح'),
          ],
        ),
        content: const Text(
          'التسبيح هو ذكر الله وتنزيهه عن كل نقص. قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
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
  final List<Color> colors;

  const TasbihItem({
    required this.text,
    required this.transliteration,
    required this.meaning,
    required this.colors,
  });
}