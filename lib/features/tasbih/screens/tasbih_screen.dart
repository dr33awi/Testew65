import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'dart:math' as math;

import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/tasbih_service.dart';

/// شاشة المسبحة الرقمية
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> 
    with TickerProviderStateMixin {
  late TasbihService _service;
  late LoggerService _logger;
  late AnimationController _countAnimationController;
  late AnimationController _rippleAnimationController;
  late AnimationController _floatingAnimationController;
  late Animation<double> _countAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _floatingAnimation;

  int _selectedTasbihIndex = 0;
  
  final List<TasbihItem> _tasbihItems = [
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ',
      transliteration: 'سبحان الله',
      meaning: 'تنزيه الله عن كل نقص',
      color: const Color(0xFF667eea),
    ),
    TasbihItem(
      text: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'الحمد لله',
      meaning: 'الثناء والشكر لله',
      color: const Color(0xFF4facfe),
    ),
    TasbihItem(
      text: 'اللَّهُ أَكْبَرُ',
      transliteration: 'الله أكبر',
      meaning: 'الله أعظم من كل شيء',
      color: const Color(0xFFfa709a),
    ),
    TasbihItem(
      text: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'لا إله إلا الله',
      meaning: 'لا معبود بحق إلا الله',
      color: const Color(0xFF43e97b),
    ),
    TasbihItem(
      text: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'أستغفر الله',
      meaning: 'طلب المغفرة من الله',
      color: const Color(0xFFfb6340),
    ),
    TasbihItem(
      text: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'سبحان الله وبحمده',
      meaning: 'تنزيه الله مع حمده',
      color: const Color(0xFF667eea),
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
    _setupAnimations();
  }

  void _setupAnimations() {
    // تحريك الأرقام - أقصر وأسرع
    _countAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _countAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _countAnimationController,
      curve: Curves.elasticOut,
    ));

    // تحريك التموجات - أقصر
    _rippleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleAnimationController,
      curve: Curves.easeOut,
    ));

    // تحريك الخلفية - أبطأ وأهدأ
    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _countAnimationController.dispose();
    _rippleAnimationController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
  }

  void _onTasbihTap() {
    _service.increment();
    
    // تحريك العداد فقط
    _countAnimationController.forward().then((_) {
      _countAnimationController.reverse();
    });
    
    // تحريك التموجات
    _rippleAnimationController.forward().then((_) {
      _rippleAnimationController.reset();
    });
    
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
        title: Text(
          'تصفير العداد',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من تصفير عداد التسبيح؟',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _service.reset();
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Theme.of(context).scaffoldBackgroundColor,
                Theme.of(context).primaryColor.withOpacity(0.05),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // شريط التنقل العلوي
                _buildAppBar(context),
                
                // اختيار نوع التسبيح
                _buildTasbihSelector(context),
                
                // المحتوى الرئيسي
                Expanded(
                  child: Consumer<TasbihService>(
                    builder: (context, service, _) {
                      return Stack(
                        children: [
                          // الخلفية المتحركة
                          _buildAnimatedBackground(),
                          
                          // المحتوى
                          _buildMainContent(context, service),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
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
          // زر العودة
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // العنوان
          Expanded(
            child: Text(
              'المسبحة الرقمية',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // زر التصفير
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: _onReset,
              icon: Icon(
                Icons.refresh_rounded,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihSelector(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tasbihItems.length,
        itemBuilder: (context, index) {
          final item = _tasbihItems[index];
          final isSelected = index == _selectedTasbihIndex;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTasbihIndex = index;
              });
              HapticFeedback.selectionClick();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? item.color : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? item.color : Theme.of(context).dividerColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  item.transliteration,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: IslamicPatternPainter(
              animation: _floatingAnimation.value,
              color: _tasbihItems[_selectedTasbihIndex].color.withOpacity(0.1),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, TasbihService service) {
    return Column(
      children: [
        const SizedBox(height: 20),
        
        // نص التسبيح المختار
        _buildSelectedTasbih(context),
        
        const Spacer(),
        
        // العداد الرئيسي
        _buildMainCounter(context, service),
        
        const Spacer(),
        
        // زر التسبيح
        _buildTasbihButton(context),
        
        const SizedBox(height: 32),
        
        // الإحصائيات (ثابتة)
        _buildStatistics(context, service),
        
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSelectedTasbih(BuildContext context) {
    final selectedItem = _tasbihItems[_selectedTasbihIndex];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selectedItem.color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: selectedItem.color.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // النص العربي
          Text(
            selectedItem.text,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: selectedItem.color,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // المعنى
          Text(
            selectedItem.meaning,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMainCounter(BuildContext context, TasbihService service) {
    return Column(
      children: [
        // نص "العدد"
        Text(
          'العدد',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // العداد (مع تحريك بسيط فقط)
        AnimatedBuilder(
          animation: _countAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _countAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _tasbihItems[_selectedTasbihIndex].color.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _tasbihItems[_selectedTasbihIndex].color.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Text(
                  '${service.count}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _tasbihItems[_selectedTasbihIndex].color,
                    fontSize: 72,
                  ),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 8),
        
        // نص "تسبيحة"
        Text(
          service.count == 1 ? 'تسبيحة' : 'تسبيحة',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTasbihButton(BuildContext context) {
    final selectedColor = _tasbihItems[_selectedTasbihIndex].color;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // التموجات
        AnimatedBuilder(
          animation: _rippleAnimation,
          builder: (context, child) {
            return Container(
              width: 200 + (_rippleAnimation.value * 100),
              height: 200 + (_rippleAnimation.value * 100),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selectedColor.withOpacity(
                    0.3 * (1 - _rippleAnimation.value),
                  ),
                  width: 2,
                ),
              ),
            );
          },
        ),
        
        // الزر الرئيسي (ثابت)
        GestureDetector(
          onTap: _onTasbihTap,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  selectedColor,
                  selectedColor.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: selectedColor.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
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
                      const Icon(
                        Icons.touch_app_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'سَبِّح',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext context, TasbihService service) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // عنوان الإحصائيات
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: Theme.of(context).hintColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'الإحصائيات',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // الإحصائيات
          Row(
            children: [
              // العدد الكلي
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'العدد الكلي',
                  value: '${service.count}',
                  icon: Icons.format_list_numbered_rounded,
                  color: _tasbihItems[_selectedTasbihIndex].color,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // عدد الأطقم (33)
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'الأطقم',
                  value: '${(service.count / 33).floor()}',
                  icon: Icons.repeat_rounded,
                  color: Colors.green,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // الباقي في الطقم
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'الباقي',
                  value: '${33 - (service.count % 33 == 0 ? 33 : service.count % 33)}',
                  icon: Icons.more_horiz_rounded,
                  color: Colors.orange,
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, TasbihService service) {
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
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            Text(
              '$currentSetProgress / 33',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _tasbihItems[_selectedTasbihIndex].color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(_tasbihItems[_selectedTasbihIndex].color),
            ),
          ),
        ),
      ],
    );
  }
}

/// نموذج بيانات التسبيح
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

/// رسام الأنماط الإسلامية للخلفية
class IslamicPatternPainter extends CustomPainter {
  final double animation;
  final Color color;

  IslamicPatternPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // رسم دوائر متحركة
    for (int i = 0; i < 5; i++) {
      final radius = 50.0 + (i * 30) + (animation * 20);
      final alpha = (1 - (i * 0.2)) * (1 - animation * 0.5);
      
      paint.color = color.withOpacity(alpha.clamp(0.0, 1.0));
      canvas.drawCircle(
        Offset(centerX, centerY),
        radius,
        paint,
      );
    }

    // رسم نجوم في الزوايا
    final corners = [
      Offset(size.width * 0.1, size.height * 0.1),
      Offset(size.width * 0.9, size.height * 0.1),
      Offset(size.width * 0.1, size.height * 0.9),
      Offset(size.width * 0.9, size.height * 0.9),
    ];

    for (int i = 0; i < corners.length; i++) {
      final offset = math.sin(animation * 2 * math.pi + i) * 10;
      _drawStar(
        canvas,
        corners[i] + Offset(offset, offset),
        15,
        paint..color = color.withOpacity(0.3),
      );
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 8;
    final double angle = 2 * math.pi / points;

    for (int i = 0; i < points; i++) {
      final outerAngle = i * angle - math.pi / 2;
      final innerAngle = (i + 0.5) * angle - math.pi / 2;

      final outerX = center.dx + radius * math.cos(outerAngle);
      final outerY = center.dy + radius * math.sin(outerAngle);

      final innerX = center.dx + (radius * 0.6) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.6) * math.sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }

      path.lineTo(innerX, innerY);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}