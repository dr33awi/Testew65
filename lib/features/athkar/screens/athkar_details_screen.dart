import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/utils/extensions/string_extensions.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AthkarService _service;
  late final StorageService _storage;
  late final AnimationController _animationController;
  
  AthkarCategory? _category;
  final Map<int, int> _counts = {};
  final Set<int> _completedItems = {};
  List<AthkarItem> _visibleItems = [];
  bool _loading = true;
  bool _allCompleted = false;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _storage = getIt<StorageService>();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationNormal,
    );
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_isFirstLoad) {
      _resetAndReload();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final cat = await _service.getCategoryById(widget.categoryId);
      if (!mounted) return;
      
      final savedProgress = _isFirstLoad ? _loadSavedProgress() : <int, int>{};
      
      setState(() {
        _category = cat;
        if (cat != null) {
          _counts.clear();
          _completedItems.clear();
          
          for (var i = 0; i < cat.athkar.length; i++) {
            final item = cat.athkar[i];
            _counts[item.id] = savedProgress[item.id] ?? 0;
            if (_counts[item.id]! >= item.count) {
              _completedItems.add(item.id);
            }
          }
          _updateVisibleItems();
          _calculateCompletion();
        }
        _loading = false;
      });
      
      _animationController.forward();
      _isFirstLoad = false;
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _resetAndReload() async {
    if (!mounted || _loading) return;
    
    setState(() {
      _counts.clear();
      _completedItems.clear();
      _allCompleted = false;
    });
    
    await _saveProgress();
    
    if (_category != null) {
      setState(() {
        _updateVisibleItems();
        _calculateCompletion();
      });
    }
  }

  void _updateVisibleItems() {
    if (_category == null) return;
    
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

  void _calculateCompletion() {
    if (_category == null) return;
    
    int completed = 0;
    int total = 0;
    
    for (final item in _category!.athkar) {
      final count = _counts[item.id] ?? 0;
      completed += count.clamp(0, item.count);
      total += item.count;
    }
    
    setState(() {
      _allCompleted = completed >= total && total > 0;
    });
  }

  void _onItemTap(AthkarItem item) {
    HapticFeedback.lightImpact();
    
    setState(() {
      final currentCount = _counts[item.id] ?? 0;
      if (currentCount < item.count) {
        _counts[item.id] = currentCount + 1;
        
        if (_counts[item.id]! >= item.count) {
          _completedItems.add(item.id);
          HapticFeedback.mediumImpact();
          _updateVisibleItems();
        }
      }
      _calculateCompletion();
    });
    
    _saveProgress();
  }

  void _onItemLongPress(AthkarItem item) {
    HapticFeedback.mediumImpact();
    
    setState(() {
      final wasCompleted = _completedItems.contains(item.id);
      
      _counts[item.id] = 0;
      _completedItems.remove(item.id);
      
      if (wasCompleted) {
        _updateVisibleItems();
      }
      
      _calculateCompletion();
    });
    
    _saveProgress();
  }

  void _rereadAthkar() {
    setState(() {
      _counts.clear();
      _completedItems.clear();
      _allCompleted = false;
      _updateVisibleItems();
    });
    _saveProgress();
  }

  Future<void> _shareProgress() async {
    final text = '''
✨ أكملت ${_category!.title} ✨
${_category!.athkar.map((item) => '✓ ${item.text.truncate(50)}').join('\n')}

تطبيق الأذكار
    ''';
    
    await Share.share(text);
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

  void _toggleFavorite(AthkarItem item) {
    HapticFeedback.lightImpact();
    
    // يمكن إضافة منطق حفظ/إزالة من المفضلة هنا
    // مثلاً: حفظ معرف الذكر في قائمة المفضلة في التخزين المحلي
    
    // إظهار رسالة للمستخدم باستخدام النظام الموحد
    AppSnackBar.showSuccess(
      context: context,
      message: 'تمت إضافة الذكر للمفضلة',
    );
  }

  // ✅ Widget منفصل لشريط التقدم المحسن
  Widget _buildProgressHeader(AthkarCategory category) {
    final totalAthkar = category.athkar.length;
    final completedAthkar = _completedItems.length;
    final remainingAthkar = totalAthkar - completedAthkar;
    
    return AppCard(
      type: CardType.info,
      style: CardStyle.gradient,
      primaryColor: ThemeConstants.success,
      margin: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$remainingAthkar متبقي',
                style: context.bodyMedium?.copyWith(
                  color: remainingAthkar > 0 
                      ? Colors.white.withValues(alpha: 0.9)
                      : Colors.white,
                  fontWeight: remainingAthkar == 0 
                      ? ThemeConstants.bold 
                      : ThemeConstants.regular,
                ),
              ),
              if (completedAthkar > 0) ...[
                Text(
                  ' • ',
                  style: context.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.white,
                ),
                ThemeConstants.space1.w,
                Text(
                  '$completedAthkar مكتمل',
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
              ],
            ],
          ),
          
          ThemeConstants.space3.h,
          
          // شريط التقدم
          if (totalAthkar > 0)
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completedAthkar / totalAthkar,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        body: AppLoading.page(
          message: 'جاري تحميل الأذكار...',
        ),
      );
    }

    if (_category == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: CustomAppBar.simple(title: 'الأذكار'),
        body: AppEmptyState.error(
          message: 'تعذر تحميل الأذكار المطلوبة',
          onRetry: _load,
        ),
      );
    }

    final category = _category!;
    
    return WillPopScope(
      onWillPop: () async {
        await _resetAndReload();
        return true;
      },
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        // ✅ استخدام CustomAppBar المبسط
        appBar: CustomAppBar.simple(
          title: category.title,
          actions: [
            AppBarAction(
              icon: Icons.notifications_outlined,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AthkarNotificationSettingsScreen(),
                ),
              ),
              tooltip: 'إعدادات الإشعارات',
            ),
          ],
        ),
        body: _buildContent(category),
      ),
    );
  }

  Widget _buildContent(AthkarCategory category) {
    return RefreshIndicator(
      onRefresh: () async {
        await _resetAndReload();
      },
      child: Column(
        children: [
          // ✅ شريط التقدم كـ Widget منفصل
          _buildProgressHeader(category),
          
          // المحتوى الرئيسي
          Expanded(
            child: _visibleItems.isEmpty 
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(ThemeConstants.space4),
                    itemCount: _visibleItems.length,
                    itemBuilder: (context, index) {
                      final item = _visibleItems[index];
                      final currentCount = _counts[item.id] ?? 0;
                      final isCompleted = _completedItems.contains(item.id);
                      
                      final originalIndex = category.athkar.indexOf(item);
                      final number = originalIndex + 1;
                        
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < _visibleItems.length - 1
                                ? ThemeConstants.space4
                                : 0,
                          ),
                          // ✅ استخدام AppCard.athkar الموحد
                          child: AppCard.athkar(
                            content: item.text,
                            source: item.source,
                            fadl: item.fadl,
                            currentCount: currentCount,
                            totalCount: item.count,
                            primaryColor: ThemeConstants.success,
                            onTap: () => _onItemTap(item),
                            actions: [
                              CardAction(
                                icon: Icons.favorite_outline,
                                label: 'مفضلة',
                                onPressed: () => _toggleFavorite(item),
                              ),
                              CardAction(
                                icon: Icons.share_rounded,
                                label: 'مشاركة',
                                onPressed: () => _shareItem(item),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    // ✅ استخدام AppCard للحالة المكتملة
    return Center(
      child: AppCard.completion(
        title: 'أكملت جميع الأذكار! 🎉',
        message: 'بارك الله فيك',
        subMessage: 'جعلها الله في ميزان حسناتك',
        icon: Icons.check_circle_rounded,
        primaryColor: ThemeConstants.success,
        actions: [
          CardAction(
            icon: Icons.refresh_rounded,
            label: 'إعادة القراءة',
            onPressed: _rereadAthkar,
            isPrimary: false,
          ),
        ],
      ),
    );
  }
}