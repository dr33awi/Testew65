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
      colors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
    ),
    TasbihItem(
      text: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'الحمد لله',
      meaning: 'الثناء والشكر لله',
      colors: [const Color(0xFF10B981), const Color(0xFF059669)],
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      colors: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      colors: [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      colors: [const Color(0xFFEF4444), const Color(0xFFDC2626)],
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _service.reset();
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تصفير العداد'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
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
                          child: SizedBox(height: 16),
                        ),
                        
                        // نص التسبيح المختار
                        SliverToBoxAdapter(
                          child: _buildSelectedTasbih(context),
                        ),
                        
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 24),
                        ),
                        
                        // العداد الرئيسي
                        SliverToBoxAdapter(
                          child: _buildMainCounter(context, service),
                        ),
                        
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 24),
                        ),
                        
                        // زر التسبيح
                        SliverToBoxAdapter(
                          child: _buildTasbihButton(context),
                        ),
                        
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 24),
                        ),
                        
                        // الإحصائيات
                        SliverToBoxAdapter(
                          child: _buildStatistics(context, service),
                        ),
                        
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 32),
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // أيقونة التطبيق
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المسبحة الرقمية',
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: IconButton(
                  onPressed: _onReset,
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: context.textSecondaryColor,
                  ),
                  tooltip: 'تصفير العداد',
                ),
              ),
              
              const SizedBox(width: 8),
              
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: IconButton(
                  onPressed: () => _showTasbihInfo(),
                  icon: Icon(
                    Icons.info_outline,
                    color: context.textSecondaryColor,
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tasbihItems.length,
        itemBuilder: (context, index) {
          final item = _tasbihItems[index];
          final isSelected = index == _selectedTasbihIndex;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTasbihIndex = index;
                });
                HapticFeedback.selectionClick();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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
                  borderRadius: BorderRadius.circular(16),
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
                            ? FontWeight.bold 
                            : FontWeight.w500,
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: selectedItem.colors.map((c) => c.withValues(alpha: 0.9)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
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
                
                const SizedBox(height: 12),
                
                // النص العربي
                Text(
                  selectedItem.text,
                  style: context.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Amiri',
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'العدد',
            style: context.titleMedium?.copyWith(
              color: context.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '${service.count}',
            style: context.displayLarge?.copyWith(
              color: selectedItem.colors[0],
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
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
                  const SizedBox(height: 8),
                  Text(
                    'سَبِّح',
                    style: context.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان الإحصائيات
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selectedItem.colors[0].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: selectedItem.colors[0],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإحصائيات',
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
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
          
          const SizedBox(height: 16),
          
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
              
              const SizedBox(width: 12),
              
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'الأطقم',
                  value: '${(service.count / 33).floor()}',
                  icon: Icons.repeat_rounded,
                  color: const Color(0xFF10B981),
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'الباقي',
                  value: '${33 - (service.count % 33 == 0 ? 33 : service.count % 33)}',
                  icon: Icons.more_horiz_rounded,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
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
        title: const Text('عن التسبيح'),
        content: const Text(
          'التسبيح هو ذكر الله وتنزيهه عن كل نقص. قال رسول الله ﷺ: "كلمتان خفيفتان على اللسان، ثقيلتان في الميزان، حبيبتان إلى الرحمن: سبحان الله وبحمده، سبحان الله العظيم"',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('فهمت'),
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