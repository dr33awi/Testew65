// lib/features/tasbih/screens/tasbih_screen.dart (محول للنظام الموحد)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../app/themes/app_theme.dart'; // ✅ النظام الموحد
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/tasbih_service.dart';

/// شاشة المسبحة الرقمية بالنظام الموحد
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
      primaryColor: context.primaryColor,
    ),
    TasbihItem(
      text: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'الحمد لله',
      meaning: 'الثناء والشكر لله',
      primaryColor: context.accentColor,
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      primaryColor: context.tertiaryColor,
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      primaryColor: context.primaryDarkColor,
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      primaryColor: context.accentDarkColor,
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      primaryColor: context.tertiaryDarkColor,
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
      destructive: true,
    ).then((confirmed) {
      if (confirmed == true) {
        _service.reset();
        HapticFeedback.lightImpact();
        AppSnackBar.showSuccess(
          context: context,
          message: 'تم تصفير العداد',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _service,
      child: Scaffold(
        backgroundColor: context.backgroundColor, // ✅ من النظام الموحد
        // ✅ CustomAppBar من النظام الموحد
        appBar: CustomAppBar(
          title: 'المسبحة الرقمية',
          backgroundColor: context.backgroundColor,
          foregroundColor: context.textPrimaryColor,
          actions: [
            // زر تصفير العداد
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _onReset();
              },
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              tooltip: 'تصفير العداد',
            ),
            // زر المعلومات
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showTasbihInfo();
              },
              icon: const Icon(Icons.info_outline, color: Colors.white),
              tooltip: 'معلومات التسبيح',
            ),
          ],
        ),
        body: SafeArea(
          child: Consumer<TasbihService>(
            builder: (context, service, _) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // مقدمة التطبيق
                  SliverToBoxAdapter(
                    child: _buildIntroCard(),
                  ),
                  
                  // اختيار نوع التسبيح
                  SliverToBoxAdapter(
                    child: _buildTasbihSelector(),
                  ),
                  
                  ThemeConstants.space3.sliverBox, // تقليل المسافة من space4
                  
                  // نص التسبيح المختار مع العداد المدمج
                  SliverToBoxAdapter(
                    child: _buildSelectedTasbihWithCounter(service),
                  ),
                  
                  ThemeConstants.space5.sliverBox,
                  
                  // زر التسبيح
                  SliverToBoxAdapter(
                    child: _buildTasbihButton(),
                  ),
                  
                  ThemeConstants.space8.sliverBox,
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ✅ بطاقة مقدمة باستخدام AppCard
  Widget _buildIntroCard() {
    return AppCard.info(
      title: 'سبح الله واذكره',
      subtitle: 'اختر نوع التسبيح واضغط على الزر لبدء العد',
      icon: Icons.auto_awesome,
      iconColor: context.successColor,
    );
  }

  // ✅ محدد نوع التسبيح باستخدام AppCard محسن
  Widget _buildTasbihSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
          child: Text(
            'اختر نوع التسبيح',
            style: context.titleMedium?.semiBold,
          ),
        ),
        
        ThemeConstants.space3.h,
        
        SizedBox(
          height: 100, // تقليل الارتفاع من 120 إلى 100
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
            itemCount: _tasbihItems.length,
            itemBuilder: (context, index) {
              final item = _tasbihItems[index];
              final isSelected = index == _selectedTasbihIndex;
              
              return AnimatedPress(
                onTap: () {
                  setState(() {
                    _selectedTasbihIndex = index;
                  });
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  width: 110, // تقليل العرض من 140 إلى 110
                  margin: const EdgeInsets.only(right: ThemeConstants.space2), // تقليل المسافة
                  child: AppCard(
                    type: CardType.normal,
                    style: isSelected ? CardStyle.gradient : CardStyle.normal,
                    primaryColor: item.primaryColor,
                    backgroundColor: !isSelected ? context.cardColor : null,
                    showShadow: isSelected,
                    padding: const EdgeInsets.all(ThemeConstants.space2), // تقليل الحشو
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(ThemeConstants.space1), // تقليل الحشو
                          decoration: BoxDecoration(
                            color: (isSelected ? Colors.white : item.primaryColor)
                                .withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: isSelected ? Colors.white : item.primaryColor,
                            size: ThemeConstants.iconSm, // تقليل حجم الأيقونة
                          ),
                        ),
                        
                        ThemeConstants.space1.h, // تقليل المسافة
                        
                        Flexible( // إضافة Flexible لتجنب overflow
                          child: Text(
                            item.transliteration,
                            style: context.labelSmall?.copyWith( // تغيير إلى labelSmall
                              color: isSelected ? Colors.white : context.textPrimaryColor,
                              fontWeight: isSelected ? ThemeConstants.semiBold : ThemeConstants.medium,
                              fontSize: 11, // تصغير الخط
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ التسبيح المختار مع العداد المدمج
  Widget _buildSelectedTasbihWithCounter(TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: AppCard(
        type: CardType.normal,
        style: CardStyle.gradient,
        primaryColor: selectedItem.primaryColor,
        padding: const EdgeInsets.all(ThemeConstants.space4),
        child: Column(
          children: [
            // نص التسبيح
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeConstants.space4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    selectedItem.text,
                    style: context.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                      fontSize: 20,
                      height: 1.4,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  ThemeConstants.space2.h,
                  
                  Text(
                    selectedItem.meaning,
                    style: context.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            ThemeConstants.space4.h,
            
            // العداد المدمج
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeConstants.space4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${service.count}',
                    style: context.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                      fontSize: 48,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  
                  Text(
                    service.count == 1 ? 'تسبيحة' : 'تسبيحة',
                    style: context.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: ThemeConstants.medium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ زر التسبيح الرئيسي
  Widget _buildTasbihButton() {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Center(
      child: AnimatedPress(
        onTap: _onTasbihTap,
        scaleFactor: 0.92,
        enableHaptic: false, // نحن نتحكم في الـ haptic بأنفسنا
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                selectedItem.primaryColor,
                selectedItem.primaryColor.darken(0.2),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: selectedItem.primaryColor.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: _onTasbihTap,
              customBorder: const CircleBorder(),
              splashColor: Colors.white.withValues(alpha: 0.3),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: Colors.white,
                    size: ThemeConstants.icon3xl,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  
                  ThemeConstants.space2.h,
                  
                  Text(
                    'سَبِّح',
                    style: context.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
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

  // ✅ معلومات التسبيح باستخدام AppInfoDialog
  void _showTasbihInfo() {
    AppInfoDialog.show(
      context: context,
      title: 'عن التسبيح',
      content: 'التسبيح هو ذكر الله وتنزيهه عن كل نقص. قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"',
      icon: Icons.auto_awesome,
      accentColor: context.successColor,
      closeButtonText: 'فهمت',
    );
  }
}

/// نموذج بيانات التسبيح المبسط
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