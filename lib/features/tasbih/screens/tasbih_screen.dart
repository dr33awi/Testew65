// lib/features/tasbih/screens/tasbih_screen.dart - النسخة المُصححة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ إضافة import مفقود
import 'package:provider/provider.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/tasbih_service.dart';

/// شاشة المسبحة الرقمية بالنظام الموحد - مُصححة
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  late TasbihService _service;
  late LoggerService _logger;

  int _selectedTasbihIndex = 0;
  
  List<TasbihItem> get _tasbihItems => const [ // ✅ إضافة const
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ',
      transliteration: 'سبحان الله',
      meaning: 'تنزيه الله عن كل نقص',
      categoryKey: 'tasbih',
    ),
    TasbihItem(
      text: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'الحمد لله',
      meaning: 'الثناء والشكر لله',
      categoryKey: 'prayer',
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      categoryKey: 'morning',
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      categoryKey: 'evening',
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      categoryKey: 'general',
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      categoryKey: 'sleep',
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
      isDestructive: true,
    ).then((confirmed) {
      if (confirmed == true) {
        _service.reset();
        HapticFeedback.lightImpact();
        context.showSuccessSnackBar('تم تصفير العداد'); // ✅ استخدام Extension
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _service,
      child: Scaffold(
        backgroundColor: context.backgroundColor, // ✅ Extension من النظام الموحد
        appBar: CustomAppBar(
          title: 'المسبحة الرقمية',
          backgroundColor: context.backgroundColor,
          foregroundColor: context.textPrimaryColor,
          actions: [
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _onReset();
              },
              icon: Icon(
                Icons.refresh_rounded,
                color: context.textPrimaryColor,
              ),
              tooltip: 'تصفير العداد',
            ),
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showTasbihInfo();
              },
              icon: Icon(
                Icons.info_outline,
                color: context.textPrimaryColor,
              ),
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
                    child: Container(
                      margin: const EdgeInsets.all(ThemeConstants.space4),
                      child: _buildIntroCard(),
                    ),
                  ),
                  
                  // اختيار نوع التسبيح
                  SliverToBoxAdapter(
                    child: _buildTasbihSelector(),
                  ),
                  
                  const SliverToBoxAdapter( // ✅ إضافة const
                    child: SizedBox(height: ThemeConstants.space3),
                  ),
                  
                  // نص التسبيح المختار مع العداد المدمج
                  SliverToBoxAdapter(
                    child: _buildSelectedTasbihWithCounter(service),
                  ),
                  
                  const SliverToBoxAdapter( // ✅ إضافة const
                    child: SizedBox(height: ThemeConstants.space5),
                  ),
                  
                  // زر التسبيح
                  SliverToBoxAdapter(
                    child: _buildTasbihButton(),
                  ),
                  
                  const SliverToBoxAdapter( // ✅ إضافة const
                    child: SizedBox(height: ThemeConstants.space4),
                  ),
                  
                  // الإحصائيات السريعة
                  SliverToBoxAdapter(
                    child: _buildQuickStats(service),
                  ),
                  
                  const SliverToBoxAdapter( // ✅ إضافة const
                    child: SizedBox(height: ThemeConstants.space8),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return AppCard.info(
      title: 'سبح الله واذكره',
      subtitle: 'اختر نوع التسبيح واضغط على الزر لبدء العد',
      icon: Icons.auto_awesome_rounded,
      iconColor: context.successColor, // ✅ Extension من النظام الموحد
    );
  }

  Widget _buildTasbihSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
          child: Text(
            'اختر نوع التسبيح',
            style: AppTextStyles.h5.copyWith(
              color: context.textPrimaryColor, // ✅ Extension
            ),
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space3),
        
        SizedBox(
          height: 100,
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
                  width: 110,
                  margin: const EdgeInsets.only(right: ThemeConstants.space2),
                  child: AppCard.custom(
                    type: CardType.normal,
                    style: isSelected ? CardStyle.gradient : CardStyle.normal,
                    primaryColor: item.primaryColor, // ✅ استخدام getter
                    backgroundColor: !isSelected ? context.cardColor : null,
                    showShadow: isSelected,
                    padding: const EdgeInsets.all(ThemeConstants.space2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(ThemeConstants.space1),
                          decoration: BoxDecoration(
                            color: (isSelected 
                                ? Colors.white 
                                : item.primaryColor)
                                .withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon, // ✅ استخدام getter
                            color: isSelected 
                                ? Colors.white 
                                : item.primaryColor,
                            size: ThemeConstants.iconSm,
                          ),
                        ),
                        
                        const SizedBox(height: ThemeConstants.space1),
                        
                        Flexible(
                          child: Text(
                            item.transliteration,
                            style: AppTextStyles.caption.copyWith(
                              color: isSelected 
                                  ? Colors.white 
                                  : context.textPrimaryColor,
                              fontWeight: isSelected 
                                  ? ThemeConstants.semiBold 
                                  : ThemeConstants.medium,
                              fontSize: 11,
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

  Widget _buildSelectedTasbihWithCounter(TasbihService service) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: AppCard.custom(
        type: CardType.athkar,
        style: CardStyle.gradient,
        primaryColor: selectedItem.primaryColor,
        gradientColors: selectedItem.gradientColors, // ✅ استخدام getter
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
                    style: AppTextStyles.athkar.copyWith(
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
                  
                  const SizedBox(height: ThemeConstants.space2),
                  
                  Text(
                    selectedItem.meaning,
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: ThemeConstants.space4),
            
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
                    style: AppTextStyles.h1.copyWith(
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
                    style: AppTextStyles.h5.copyWith(
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

  Widget _buildTasbihButton() {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    final primaryColor = selectedItem.primaryColor;
    
    return Center(
      child: AnimatedPress(
        onTap: _onTasbihTap,
        scaleFactor: 0.92,
        enableHaptic: false,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: selectedItem.gradientColors, // ✅ استخدام getter
            ),
            shape: BoxShape.circle,
            boxShadow: AppShadowSystem.colored(
              color: primaryColor,
              intensity: ShadowIntensity.strong,
              opacity: 0.4,
            ),
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
                  
                  const SizedBox(height: ThemeConstants.space2),
                  
                  Text(
                    'سَبِّح',
                    style: AppTextStyles.h3.copyWith(
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

  // ✅ إحصائيات مبسطة باستخدام المكونات الموجودة فقط
  Widget _buildQuickStats(TasbihService service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'اليوم',
              value: '${service.dailyCount}',
              icon: Icons.today,
              color: context.successColor,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          Expanded(
            child: _buildStatCard(
              title: 'الإجمالي',
              value: '${service.totalCount}',
              icon: Icons.trending_up,
              color: context.infoColor,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ دالة مساعدة لبناء بطاقة إحصائية باستخدام المكونات الموجودة
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ThemeConstants.iconLg,
          ),
          
          const SizedBox(height: ThemeConstants.space2),
          
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: color,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: context.textSecondaryColor,
              fontWeight: ThemeConstants.medium,
            ),
          ),
        ],
      ),
    );
  }

  void _showTasbihInfo() {
    AppInfoDialog.show(
      context: context,
      title: 'عن التسبيح',
      content: 'التسبيح هو ذكر الله وتنزيهه عن كل نقص. قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"',
      icon: Icons.auto_awesome_rounded,
      accentColor: context.successColor,
      closeButtonText: 'فهمت',
    );
  }
}

/// نموذج بيانات التسبيح المبسط - مُصحح مع getters
class TasbihItem {
  final String text;
  final String transliteration;
  final String meaning;
  final String categoryKey;

  const TasbihItem({
    required this.text,
    required this.transliteration,
    required this.meaning,
    required this.categoryKey,
  });

  /// الحصول على اللون من النظام الموحد
  Color get primaryColor => AppColorSystem.getCategoryColor(categoryKey);

  /// الحصول على اللون الفاتح
  Color get lightColor => AppColorSystem.getCategoryLightColor(categoryKey);

  /// الحصول على اللون الداكن
  Color get darkColor => AppColorSystem.getCategoryDarkColor(categoryKey);

  /// الحصول على التدرج اللوني
  List<Color> get gradientColors => [
    primaryColor,
    darkColor,
  ];

  /// الحصول على الأيقونة المناسبة
  IconData get icon => AppIconsSystem.getCategoryIcon(categoryKey);
}