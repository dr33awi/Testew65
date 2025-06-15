// lib/features/athkar/screens/athkar_details_screen.dart
import 'package:athkar_app/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/widgets/animations/animated_press.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/utils/extensions/string_extensions.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../widgets/athkar_item_card.dart';
import '../widgets/athkar_progress_bar.dart';
import '../widgets/athkar_completion_dialog.dart';

class AthkarDetailsScreen extends StatefulWidget {
  String categoryId;
  
  AthkarDetailsScreen({
    super.key,
    String? categoryId,
  }) : categoryId = categoryId ?? '';

  @override
  State<AthkarDetailsScreen> createState() => _AthkarDetailsScreenState();
}

class _AthkarDetailsScreenState extends State<AthkarDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final AthkarService _service;
  late final StorageService _storage;
  late final AnimationController _animationController;
  
  AthkarCategory? _category;
  final Map<int, int> _counts = {};
  final Set<int> _completedItems = {};
  List<AthkarItem> _visibleItems = [];
  int _totalProgress = 0;
  bool _loading = true;
  bool _allCompleted = false;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _storage = getIt<StorageService>();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationNormal,
    );
    _load();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final cat = await _service.getCategoryById(widget.categoryId);
      if (!mounted) return;
      
      // تحميل التقدم المحفوظ
      final savedProgress = _loadSavedProgress();
      
      setState(() {
        _category = cat;
        if (cat != null) {
          // تهيئة العدادات
          for (var i = 0; i < cat.athkar.length; i++) {
            final item = cat.athkar[i];
            _counts[item.id] = savedProgress[item.id] ?? 0;
            if (_counts[item.id]! >= item.count) {
              _completedItems.add(item.id);
            }
          }
          _updateVisibleItems();
          _calculateProgress();
        }
        _loading = false;
      });
      
      // بدء الأنيميشن
      _animationController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      context.showErrorSnackBar('حدث خطأ في تحميل الأذكار');
    }
  }

  void _updateVisibleItems() {
    if (_category == null) return;
    
    // عرض فقط الأذكار غير المكتملة
    _visibleItems = _category!.athkar
        .where((item) => !_completedItems.contains(item.id))
        .toList();
  }

  Map<int, int> _loadSavedProgress() {
    final key = 'athkar_progress_${widget.categoryId}';
    final data = _storage.getMap(key);
    if (data == null) return {};
    
    return data.map((k, v) => MapEntry(int.parse(k), v as int));
  }

  Future<void> _saveProgress() async {
    final key = 'athkar_progress_${widget.categoryId}';
    final data = _counts.map((k, v) => MapEntry(k.toString(), v));
    await _storage.setMap(key, data);
  }

  void _calculateProgress() {
    if (_category == null) return;
    
    int completed = 0;
    int total = 0;
    
    for (final item in _category!.athkar) {
      final count = _counts[item.id] ?? 0;
      completed += count.clamp(0, item.count);
      total += item.count;
    }
    
    setState(() {
      _totalProgress = total > 0 ? ((completed / total) * 100).round() : 0;
      _allCompleted = completed >= total && total > 0;
    });
  }

  void _onItemTap(AthkarItem item) {
    HapticFeedback.lightImpact();
    
    setState(() {
      final currentCount = _counts[item.id] ?? 0;
      if (currentCount < item.count) {
        _counts[item.id] = currentCount + 1;
        
        // إضافة للمكتملة إذا وصلت للعدد المطلوب
        if (_counts[item.id]! >= item.count) {
          _completedItems.add(item.id);
          HapticFeedback.mediumImpact();
          _updateVisibleItems(); // إخفاء الذكر المكتمل
        }
      }
      _calculateProgress();
    });
    
    _saveProgress();
    
    // عرض رسالة الإكمال
    if (_allCompleted && !_loading) {
      _showCompletionDialog();
    }
  }

  void _onItemLongPress(AthkarItem item) {
    HapticFeedback.mediumImpact();
    
    // إعادة تعيين العداد
    setState(() {
      _counts[item.id] = 0;
      _completedItems.remove(item.id);
      _updateVisibleItems();
      _calculateProgress();
    });
    
    _saveProgress();
    context.showInfoSnackBar('تم إعادة تعيين العداد');
  }

  Future<void> _showCompletionDialog() async {
    final result = await AthkarCompletionDialog.show(
      context: context,
      categoryName: _category!.title,
      onShare: _shareProgress,
      onReset: _resetAll,
    );
    
    if (result == true) {
      // تم إعادة التعيين
      _resetAll();
    }
  }

  Future<void> _shareProgress() async {
    // مشاركة التقدم
    final text = '''
✨ أكملت ${_category!.title} ✨
${_category!.athkar.map((item) => '✓ ${item.text.truncate(50)}').join('\n')}

تطبيق الأذكار
    ''';
    
    await Share.share(text);
  }

  void _resetAll() {
    setState(() {
      _counts.clear();
      _completedItems.clear();
      _allCompleted = false;
      _totalProgress = 0;
      _updateVisibleItems();
    });
    _saveProgress();
  }

  Future<void> _shareItem(AthkarItem item) async {
    final text = '''
${item.text}

${item.fadl != null ? 'الفضل: ${item.fadl}\n' : ''}
${item.source != null ? 'المصدر: ${item.source}' : ''}

تطبيق الأذكار
''';
    
    await Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(
          child: AppLoading.page(
            message: 'جاري تحميل الأذكار...',
          ),
        ),
      );
    }

    if (_category == null) {
      return Scaffold(
        appBar: CustomAppBar.simple(title: 'الأذكار'),
        body: AppEmptyState.error(
          message: 'تعذر تحميل الأذكار المطلوبة',
          onRetry: _load,
        ),
      );
    }

    final category = _category!;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar مخصص
          _buildSliverAppBar(context, category),
          
          // شريط التقدم
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animationController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _animationController,
                      curve: ThemeConstants.curveDefault,
                    )),
                    child: AthkarProgressBar(
                      progress: _totalProgress,
                      color: category.color,
                      completedCount: _completedItems.length,
                      totalCount: category.athkar.length,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // قائمة الأذكار
          if (_visibleItems.isEmpty && _completedItems.isNotEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 80,
                      color: ThemeConstants.success,
                    ),
                    ThemeConstants.space4.h,
                    Text(
                      'أحسنت! أكملت جميع الأذكار',
                      style: context.headlineSmall?.copyWith(
                        color: ThemeConstants.success,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    ThemeConstants.space2.h,
                    Text(
                      'جعله الله في ميزان حسناتك',
                      style: context.bodyLarge?.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                    ThemeConstants.space6.h,
                    AppButton.primary(
                      text: 'البدء من جديد',
                      icon: Icons.refresh,
                      onPressed: _resetAll,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              sliver: AnimationLimiter(
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = _visibleItems[index];
                      final currentCount = _counts[item.id] ?? 0;
                      final isCompleted = _completedItems.contains(item.id);
                      
                      // إيجاد الفهرس الأصلي
                      final originalIndex = category.athkar.indexOf(item);
                      final number = originalIndex + 1;
                      
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: ThemeConstants.durationNormal,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: index < _visibleItems.length - 1
                                    ? ThemeConstants.space3
                                    : 0,
                              ),
                              child: AthkarItemCard(
                                item: item,
                                currentCount: currentCount,
                                isCompleted: isCompleted,
                                number: number,
                                color: category.color,
                                onTap: () => _onItemTap(item),
                                onLongPress: () => _onItemLongPress(item),
                                onFavoriteToggle: () => _toggleFavorite(item),
                                onShare: () => _shareItem(item),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _visibleItems.length,
                  ),
                ),
              ),
            ),
          
          // مساحة إضافية في الأسفل
          const SliverPadding(
            padding: EdgeInsets.only(bottom: ThemeConstants.space8),
          ),
        ],
      ),
      
      // زر عائم للإجراءات
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, AthkarCategory category) {
    // استخدام ألوان من الثيم بناءً على نوع الفئة
    final categoryColor = _getCategoryThemeColor(category.id);
    
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: categoryColor,
      leading: AppBackButton(
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        // زر المفضلة
        AppBarAction(
          icon: Icons.favorite_outline,
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.favorites);
          },
          tooltip: 'المفضلة',
        ),
        
        // زر الإعدادات
        AppBarAction(
          icon: Icons.settings,
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.appSettings);
          },
          tooltip: 'الإعدادات',
        ),
        
        // زر المزيد
        AppBarAction(
          icon: Icons.more_vert,
          color: Colors.white,
          onPressed: () => _showMoreOptions(context),
          tooltip: 'المزيد',
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          category.title,
          style: AppTextStyles.h5.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.bold,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                categoryColor.darken(0.2),
                categoryColor,
                categoryColor.lighten(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // نمط في الخلفية
              Positioned.fill(
                child: CustomPaint(
                  painter: _BackgroundPatternPainter(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              
              // أيقونة الفئة
              Center(
                child: Icon(
                  _getCategoryIcon(category.id),
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الحصول على أيقونة مناسبة لكل فئة
  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'morning':
        return Icons.wb_sunny;
      case 'evening':
        return Icons.wb_twilight;
      case 'sleep':
        return Icons.nights_stay;
      case 'wakeup':
        return Icons.alarm;
      default:
        return Icons.auto_awesome;
    }
  }

  // الحصول على لون من الثيم بناءً على نوع الفئة
  Color _getCategoryThemeColor(String categoryId) {
    switch (categoryId) {
      case 'morning':
        return ThemeConstants.primary; // أخضر زيتي
      case 'evening':
        return ThemeConstants.primaryDark; // أخضر زيتي داكن
      case 'sleep':
        return ThemeConstants.tertiary; // بني دافئ
      case 'wakeup':
        return ThemeConstants.accent; // ذهبي دافئ
      default:
        return ThemeConstants.primary;
    }
  }

  Widget _buildFAB(BuildContext context) {
    if (_allCompleted) {
      return FloatingActionButton.extended(
        onPressed: _showCompletionDialog,
        backgroundColor: ThemeConstants.success,
        icon: const Icon(Icons.check_circle),
        label: const Text('مكتمل'),
      );
    }
    
    return AnimatedPress(
      onTap: _showQuickActions,
      child: FloatingActionButton(
        onPressed: _showQuickActions,
        backgroundColor: _category!.color,
        child: const Icon(Icons.dashboard_rounded),
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusXl),
        ),
      ),
      builder: (context) => _QuickActionsSheet(
        category: _category!,
        onReset: () {
          Navigator.pop(context);
          _resetAll();
        },
        onShare: () {
          Navigator.pop(context);
          _shareProgress();
        },
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusXl),
        ),
      ),
      builder: (context) => _MoreOptionsSheet(
        onNotificationSettings: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, AppRouter.appSettings);
        },
        onTextSize: () {
          Navigator.pop(context);
          // TODO: تغيير حجم الخط
        },
      ),
    );
  }

  void _toggleFavorite(AthkarItem item) {
    // TODO: تنفيذ المفضلة
    context.showInfoSnackBar('سيتم إضافة ميزة المفضلة قريباً');
  }
}

// Widget للإجراءات السريعة
class _QuickActionsSheet extends StatelessWidget {
  final AthkarCategory category;
  final VoidCallback onReset;
  final VoidCallback onShare;

  const _QuickActionsSheet({
    required this.category,
    required this.onReset,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // المقبض
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: ThemeConstants.space4),
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // العنوان
          Text(
            'إجراءات سريعة',
            style: context.titleLarge,
          ),
          
          ThemeConstants.space4.h,
          
          // الإجراءات
          ListTile(
            leading: Icon(Icons.refresh, color: context.primaryColor),
            title: const Text('إعادة تعيين الكل'),
            subtitle: const Text('البدء من جديد'),
            onTap: onReset,
          ),
          
          ListTile(
            leading: Icon(Icons.share, color: context.primaryColor),
            title: const Text('مشاركة التقدم'),
            subtitle: const Text('شارك إنجازك مع الآخرين'),
            onTap: onShare,
          ),
          
          ListTile(
            leading: Icon(Icons.text_increase, color: context.primaryColor),
            title: const Text('حجم النص'),
            subtitle: const Text('تكبير أو تصغير النص'),
            onTap: () {
              Navigator.pop(context);
              // TODO: تنفيذ تغيير حجم النص
            },
          ),
        ],
      ),
    );
  }
}

// Widget للخيارات الإضافية
class _MoreOptionsSheet extends StatelessWidget {
  final VoidCallback onNotificationSettings;
  final VoidCallback onTextSize;

  const _MoreOptionsSheet({
    required this.onNotificationSettings,
    required this.onTextSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: ThemeConstants.space4),
            decoration: BoxDecoration(
              color: context.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('إعدادات التنبيهات'),
            onTap: onNotificationSettings,
          ),
          
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('حجم النص'),
            onTap: onTextSize,
          ),
        ],
      ),
    );
  }
}

// رسام النمط في الخلفية
class _BackgroundPatternPainter extends CustomPainter {
  final Color color;

  _BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 30.0;
    
    // رسم خطوط مائلة
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}