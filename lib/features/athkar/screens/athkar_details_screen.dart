// lib/features/athkar/screens/athkar_details_screen.dart
import 'package:athkar_app/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/utils/extensions/string_extensions.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../widgets/athkar_item_card.dart';
import '../widgets/athkar_progress_bar.dart';
import '../widgets/athkar_completion_dialog.dart';
import '../utils/category_utils.dart';
import 'notification_settings_screen.dart';

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
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar(
        title: category.title,
        leading: AppBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // زر المفضلة
          AppBarAction(
            icon: Icons.favorite_outline,
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.favorites);
            },
            tooltip: 'المفضلة',
          ),
          
          // زر إعدادات الإشعارات
          AppBarAction(
            icon: Icons.notifications_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AthkarNotificationSettingsScreen(),
                ),
              );
            },
            tooltip: 'إعدادات الإشعارات',
          ),
          
          // زر المشاركة
          AppBarAction(
            icon: Icons.share_outlined,
            onPressed: _shareProgress,
            tooltip: 'مشاركة',
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط التقدم
          AnimatedBuilder(
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
                    color: CategoryUtils.getCategoryThemeColor(category.id),
                    completedCount: _completedItems.length,
                    totalCount: category.athkar.length,
                  ),
                ),
              );
            },
          ),
          
          // قائمة الأذكار
          Expanded(
            child: _buildContent(category),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AthkarCategory category) {
    if (_visibleItems.isEmpty && _completedItems.isNotEmpty) {
      // عرض رسالة الإكمال
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: ThemeConstants.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ThemeConstants.success.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 60,
                  color: ThemeConstants.success,
                ),
              ),
              
              ThemeConstants.space6.h,
              
              Text(
                'أحسنت! أكملت جميع الأذكار',
                style: context.headlineSmall?.copyWith(
                  color: ThemeConstants.success,
                  fontWeight: ThemeConstants.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              ThemeConstants.space3.h,
              
              Text(
                'جعله الله في ميزان حسناتك',
                style: context.bodyLarge?.copyWith(
                  color: context.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              
              ThemeConstants.space8.h,
              
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'مشاركة الإنجاز',
                      icon: Icons.share_rounded,
                      onPressed: _shareProgress,
                      color: ThemeConstants.success,
                    ),
                  ),
                  
                  ThemeConstants.space4.w,
                  
                  Expanded(
                    child: AppButton.primary(
                      text: 'البدء من جديد',
                      icon: Icons.refresh_rounded,
                      onPressed: _resetAll,
                      backgroundColor: ThemeConstants.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    
    // عرض الأذكار
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        itemCount: _visibleItems.length,
        itemBuilder: (context, index) {
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
                    color: CategoryUtils.getCategoryThemeColor(category.id),
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
      ),
    );
  }

  void _toggleFavorite(AthkarItem item) {
    // TODO: تنفيذ المفضلة
    context.showInfoSnackBar('سيتم إضافة ميزة المفضلة قريباً');
  }
}