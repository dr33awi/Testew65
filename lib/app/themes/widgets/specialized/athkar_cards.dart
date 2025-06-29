// lib/app/themes/widgets/specialized/athkar_cards.dart
// كروت الأذكار والأدعية - مفصولة ومتخصصة
// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==================== كروت الأذكار المتخصصة ====================

/// بطاقة ذكر أساسية متقدمة
class AthkarCard extends StatefulWidget {
  final String content;
  final String? source;
  final String? fadl;
  final int currentCount;
  final int totalCount;
  final Color primaryColor;
  final bool isCompleted;
  final VoidCallback onTap;
  final List<AthkarAction>? actions;
  final bool showProgress;
  final bool useAdvancedAnimation;
  final bool showSource;
  final bool showFadl;

  const AthkarCard({
    super.key,
    required this.content,
    this.source,
    this.fadl,
    required this.currentCount,
    required this.totalCount,
    required this.primaryColor,
    this.isCompleted = false,
    required this.onTap,
    this.actions,
    this.showProgress = true,
    this.useAdvancedAnimation = false,
    this.showSource = true,
    this.showFadl = true,
  });

  @override
  State<AthkarCard> createState() => _AthkarCardState();
}

class _AthkarCardState extends State<AthkarCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.useAdvancedAnimation) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
    
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.totalCount > 0 ? widget.currentCount / widget.totalCount : 0.0;
    
    return AnimatedBuilder(
      animation: widget.useAdvancedAnimation ? _pulseAnimation : _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.useAdvancedAnimation ? _pulseAnimation.value : _scaleAnimation.value,
          child: Container(
            margin: AppTheme.space3.padding,
            child: Material(
              color: Colors.transparent,
              borderRadius: AppTheme.radiusLg.radius,
              child: InkWell(
                onTap: _handleTap,
                borderRadius: AppTheme.radiusLg.radius,
                child: Container(
                  decoration: _buildCardDecoration(),
                  padding: AppTheme.space4.padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContent(),
                      AppTheme.space3.h,
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: AppTheme.card,
      borderRadius: AppTheme.radiusLg.radius,
      border: Border.all(
        color: widget.isCompleted 
            ? widget.primaryColor.withValues(alpha: 0.4)
            : AppTheme.divider.withValues(alpha: 0.3),
        width: widget.isCompleted ? 2 : 1,
      ),
      boxShadow: AppTheme.shadowSm,
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      padding: AppTheme.space4.padding,
      decoration: BoxDecoration(
        color: widget.isCompleted 
            ? widget.primaryColor.withValues(alpha: 0.2)
            : widget.primaryColor.withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusMd.radius,
        border: Border.all(
          color: widget.isCompleted
              ? widget.primaryColor.withValues(alpha: 0.4)
              : widget.primaryColor.withValues(alpha: 0.2),
          width: widget.isCompleted ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // النص الرئيسي
          Text(
            widget.content,
            style: AppTheme.quranStyle.copyWith(
              height: 1.8,
              color: widget.isCompleted ? widget.primaryColor : AppTheme.textReligious,
            ),
            textAlign: TextAlign.center,
          ),
          
          // إشارة الاكتمال
          if (widget.isCompleted) ...[
            AppTheme.space2.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: widget.primaryColor,
                  size: AppTheme.iconSm,
                ),
                AppTheme.space1.w,
                Text(
                  'مكتمل',
                  style: AppTheme.caption.copyWith(
                    color: widget.primaryColor,
                    fontWeight: AppTheme.medium,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // المعلومات الإضافية
        if (widget.source != null && widget.showSource) ...[
          _buildInfoRow(Icons.library_books, 'المصدر: ${widget.source}', widget.primaryColor),
          AppTheme.space1.h,
        ],
        
        if (widget.fadl != null && widget.showFadl) ...[
          _buildInfoRow(Icons.star, 'الفضل: ${widget.fadl}', AppTheme.warning),
          AppTheme.space2.h,
        ],
        
        // شريط التقدم والعداد
        Row(
          children: [
            // العداد
            _buildCounter(),
            
            // شريط التقدم
            if (widget.showProgress && !widget.isCompleted) ...[
              AppTheme.space3.w,
              Expanded(child: _buildProgressBar()),
            ],
          ],
        ),
        
        // الإجراءات
        if (widget.actions != null && widget.actions!.isNotEmpty) ...[
          AppTheme.space4.h,
          _buildActions(),
        ],
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppTheme.iconSm,
          color: iconColor,
        ),
        AppTheme.space2.w,
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space3,
        vertical: AppTheme.space1,
      ),
      decoration: BoxDecoration(
        color: widget.isCompleted ? AppTheme.success : widget.primaryColor,
        borderRadius: AppTheme.radiusFull.radius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isCompleted)
            const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            )
          else ...[
            Text(
              '${widget.currentCount}',
              style: AppTheme.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTheme.bold,
                fontFamily: AppTheme.numbersFont,
              ),
            ),
            Text(
              ' / ${widget.totalCount}',
              style: AppTheme.labelMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontFamily: AppTheme.numbersFont,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = widget.totalCount > 0 ? widget.currentCount / widget.totalCount : 0.0;
    
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: widget.primaryColor.withValues(alpha: 0.2),
        borderRadius: AppTheme.radiusFull.radius,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: widget.primaryColor,
            borderRadius: AppTheme.radiusFull.radius,
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: widget.actions!.map((action) => 
        Padding(
          padding: const EdgeInsets.only(left: AppTheme.space2),
          child: action,
        ),
      ).toList(),
    );
  }
}

/// بطاقة ذكر مبسطة للقوائم السريعة
class SimpleAthkarCard extends StatelessWidget {
  final String content;
  final int count;
  final Color color;
  final VoidCallback onTap;
  final bool isCompleted;
  final bool showCount;

  const SimpleAthkarCard({
    super.key,
    required this.content,
    required this.count,
    required this.color,
    required this.onTap,
    this.isCompleted = false,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusMd.radius,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: AppTheme.radiusMd.radius,
          child: Container(
            padding: AppTheme.space3.padding,
            decoration: BoxDecoration(
              color: isCompleted 
                  ? AppTheme.success.withValues(alpha: 0.1)
                  : color.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusMd.radius,
              border: Border.all(
                color: isCompleted ? AppTheme.success : color,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // النص
                Expanded(
                  child: Text(
                    content,
                    style: AppTheme.bodyMedium.copyWith(
                      height: 1.5,
                      color: isCompleted ? AppTheme.success : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                AppTheme.space2.w,
                
                // العداد أو الحالة
                if (showCount && !isCompleted) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space2,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: AppTheme.radiusFull.radius,
                    ),
                    child: Text(
                      count.toString(),
                      style: AppTheme.caption.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                        fontFamily: AppTheme.numbersFont,
                      ),
                    ),
                  ),
                ] else if (isCompleted) ...[
                  Icon(
                    Icons.check_circle,
                    color: AppTheme.success,
                    size: AppTheme.iconMd,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة تقدم الأذكار اليومية
class DailyAthkarProgressCard extends StatelessWidget {
  final Map<String, int> categoryProgress;
  final int totalCompleted;
  final int totalAthkar;
  final VoidCallback? onViewDetails;
  final String title;

  const DailyAthkarProgressCard({
    super.key,
    required this.categoryProgress,
    required this.totalCompleted,
    required this.totalAthkar,
    this.onViewDetails,
    this.title = 'تقدم الأذكار اليوم',
  });

  @override
  Widget build(BuildContext context) {
    final overallProgress = totalAthkar > 0 
        ? ((totalCompleted / totalAthkar) * 100).round()
        : 0;
    
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: onViewDetails,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: BoxDecoration(
              gradient: _getGradientForProgress(overallProgress),
              borderRadius: AppTheme.radiusLg.radius,
              boxShadow: AppTheme.shadowMd,
            ),
            padding: AppTheme.space5.padding,
            child: Column(
              children: [
                // العنوان والنسبة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.semiBold,
                      ),
                    ),
                    Text(
                      '$overallProgress%',
                      style: AppTheme.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                        fontFamily: AppTheme.numbersFont,
                      ),
                    ),
                  ],
                ),
                
                AppTheme.space4.h,
                
                // شريط التقدم العام
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (overallProgress / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppTheme.radiusFull.radius,
                      ),
                    ),
                  ),
                ),
                
                AppTheme.space4.h,
                
                // الإحصائيات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('مكتمل', totalCompleted.toString()),
                    _buildStatItem('المجموع', totalAthkar.toString()),
                    _buildStatItem('الفئات', categoryProgress.length.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradientForProgress(int progress) {
    if (progress >= 90) {
      return const LinearGradient(
        colors: [AppTheme.success, Color(0xFF4CAF50)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (progress >= 70) {
      return LinearGradient(
        colors: [AppTheme.primary, AppTheme.primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (progress >= 50) {
      return LinearGradient(
        colors: [AppTheme.warning, AppTheme.secondaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return LinearGradient(
        colors: [AppTheme.info, AppTheme.tertiary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.titleLarge.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
            fontFamily: AppTheme.numbersFont,
          ),
        ),
        AppTheme.space1.h,
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: AppTheme.medium,
          ),
        ),
      ],
    );
  }
}

/// بطاقة الأذكار المفضلة
class FavoriteAthkarCard extends StatelessWidget {
  final List<String> favoriteAthkar;
  final VoidCallback onViewAll;
  final int maxDisplay;

  const FavoriteAthkarCard({
    super.key,
    required this.favoriteAthkar,
    required this.onViewAll,
    this.maxDisplay = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteAthkar.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: onViewAll,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: AppTheme.radiusLg.radius,
              border: Border.all(
                color: AppTheme.divider.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: AppTheme.shadowSm,
            ),
            padding: AppTheme.space4.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: AppTheme.error,
                      size: AppTheme.iconMd,
                    ),
                    AppTheme.space2.w,
                    Text(
                      'الأذكار المفضلة',
                      style: AppTheme.titleMedium.copyWith(
                        fontWeight: AppTheme.semiBold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${favoriteAthkar.length}',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.error,
                        fontWeight: AppTheme.bold,
                        fontFamily: AppTheme.numbersFont,
                      ),
                    ),
                  ],
                ),
                
                AppTheme.space4.h,
                
                // قائمة مختصرة من المفضلة
                ...favoriteAthkar.take(maxDisplay).map((athkar) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.space2),
                    child: Text(
                      athkar,
                      style: AppTheme.bodySmall.copyWith(
                        height: 1.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                // رابط عرض الكل
                if (favoriteAthkar.length > maxDisplay) ...[
                  AppTheme.space2.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'عرض جميع المفضلة (${favoriteAthkar.length - maxDisplay}+)',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primary,
                          fontWeight: AppTheme.medium,
                        ),
                      ),
                      AppTheme.space1.w,
                      Icon(
                        Icons.arrow_forward_ios,
                        size: AppTheme.iconSm,
                        color: AppTheme.primary,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: AppTheme.radiusLg.radius,
            border: Border.all(
              color: AppTheme.divider.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          padding: AppTheme.space5.padding,
          child: Column(
            children: [
              Icon(
                Icons.favorite_border,
                size: AppTheme.iconXl,
                color: AppTheme.textTertiary,
              ),
              AppTheme.space2.h,
              Text(
                'لا توجد أذكار مفضلة',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              AppTheme.space1.h,
              Text(
                'اضغط على ♥ في أي ذكر لإضافته للمفضلة',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== مكونات مساعدة للأذكار ====================

/// إجراء في بطاقة الذكر
class AthkarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;

  const AthkarAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: AppTheme.radiusMd.radius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space3,
            vertical: AppTheme.space2,
          ),
          decoration: isPrimary ? BoxDecoration(
            color: color ?? AppTheme.primary,
            borderRadius: AppTheme.radiusMd.radius,
          ) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppTheme.iconSm,
                color: isPrimary 
                    ? Colors.black
                    : color ?? AppTheme.textSecondary,
              ),
              if (label.isNotEmpty) ...[
                AppTheme.space1.w,
                Text(
                  label,
                  style: AppTheme.labelMedium.copyWith(
                    color: isPrimary 
                        ? Colors.black
                        : color ?? AppTheme.textSecondary,
                    fontWeight: isPrimary 
                        ? AppTheme.semiBold 
                        : AppTheme.medium,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// عداد الذكر مع التأثيرات البصرية
class AthkarCounter extends StatefulWidget {
  final int currentCount;
  final int totalCount;
  final Color color;
  final VoidCallback onIncrement;
  final VoidCallback? onReset;
  final bool showProgress;
  final bool useHapticFeedback;

  const AthkarCounter({
    super.key,
    required this.currentCount,
    required this.totalCount,
    required this.color,
    required this.onIncrement,
    this.onReset,
    this.showProgress = true,
    this.useHapticFeedback = true,
  });

  @override
  State<AthkarCounter> createState() => _AthkarCounterState();
}

class _AthkarCounterState extends State<AthkarCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleIncrement() {
    if (widget.useHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    
    _controller.forward().then((_) {
      _controller.reverse();
    });
    
    widget.onIncrement();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.currentCount >= widget.totalCount;
    final progress = widget.totalCount > 0 ? widget.currentCount / widget.totalCount : 0.0;

    return Column(
      children: [
        // العداد الرئيسي
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: isCompleted ? null : _handleIncrement,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: isCompleted 
                        ? const LinearGradient(
                            colors: [AppTheme.success, Color(0xFF4CAF50)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [widget.color, AppTheme.darken(widget.color, 0.2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.shadowMd,
                  ),
                  child: Center(
                    child: isCompleted 
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          )
                        : Text(
                            '${widget.currentCount}',
                            style: AppTheme.displayMedium.copyWith(
                              color: Colors.white,
                              fontFamily: AppTheme.numbersFont,
                              fontSize: 32,
                            ),
                          ),
                  ),
                ),
              ),
            );
          },
        ),
        
        AppTheme.space3.h,
        
        // المعلومات
        if (!isCompleted) ...[
          Text(
            'من ${widget.totalCount}',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
              fontFamily: AppTheme.numbersFont,
            ),
          ),
          
          if (widget.showProgress) ...[
            AppTheme.space2.h,
            SizedBox(
              width: 120,
              child: AthkarProgressBar(
                currentCount: widget.currentCount,
                totalCount: widget.totalCount,
                color: widget.color,
                showNumbers: false,
              ),
            ),
          ],
        ] else ...[
          Text(
            'مكتمل! 🎉',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.success,
              fontWeight: AppTheme.bold,
            ),
          ),
        ],
        
        // زر الإعادة
        if (widget.onReset != null && widget.currentCount > 0) ...[
          AppTheme.space3.h,
          TextButton.icon(
            onPressed: () {
              if (widget.useHapticFeedback) {
                HapticFeedback.lightImpact();
              }
              widget.onReset!();
            },
            icon: const Icon(Icons.refresh, size: AppTheme.iconSm),
            label: const Text('إعادة تعيين'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textTertiary,
            ),
          ),
        ],
      ],
    );
  }
}

/// شريط تقدم الذكر
class AthkarProgressBar extends StatelessWidget {
  final int currentCount;
  final int totalCount;
  final Color color;
  final bool showNumbers;
  final double height;

  const AthkarProgressBar({
    super.key,
    required this.currentCount,
    required this.totalCount,
    required this.color,
    this.showNumbers = true,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? currentCount / totalCount : 0.0;
    
    return Column(
      children: [
        if (showNumbers) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentCount / $totalCount',
                style: AppTheme.bodySmall.copyWith(
                  fontFamily: AppTheme.numbersFont,
                  fontWeight: AppTheme.medium,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTheme.bodySmall.copyWith(
                  color: color,
                  fontFamily: AppTheme.numbersFont,
                  fontWeight: AppTheme.bold,
                ),
              ),
            ],
          ),
          AppTheme.space2.h,
        ],
        
        Container(
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: AppTheme.radiusFull.radius,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppTheme.radiusFull.radius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== Factory Methods للأذكار ====================

/// مصنع بطاقات الأذكار
class AthkarCards {
  AthkarCards._();

  /// بطاقة ذكر الصباح
  static Widget morning({
    required String content,
    String? source,
    String? fadl,
    required int currentCount,
    required int totalCount,
    required VoidCallback onTap,
    List<AthkarAction>? actions,
    bool isCompleted = false,
  }) {
    return AthkarCard(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      primaryColor: AppTheme.getCategoryColor('الصباح'),
      onTap: onTap,
      actions: actions,
      isCompleted: isCompleted,
    );
  }

  /// بطاقة ذكر المساء
  static Widget evening({
    required String content,
    String? source,
    String? fadl,
    required int currentCount,
    required int totalCount,
    required VoidCallback onTap,
    List<AthkarAction>? actions,
    bool isCompleted = false,
  }) {
    return AthkarCard(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      primaryColor: AppTheme.getCategoryColor('المساء'),
      onTap: onTap,
      actions: actions,
      isCompleted: isCompleted,
    );
  }

  /// بطاقة ذكر النوم
  static Widget sleep({
    required String content,
    String? source,
    String? fadl,
    required int currentCount,
    required int totalCount,
    required VoidCallback onTap,
    List<AthkarAction>? actions,
    bool isCompleted = false,
  }) {
    return AthkarCard(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      primaryColor: AppTheme.getCategoryColor('النوم'),
      onTap: onTap,
      actions: actions,
      isCompleted: isCompleted,
    );
  }

  /// بطاقة آية قرآنية
  static Widget quran({
    required String content,
    String? suraName,
    int? ayahNumber,
    required VoidCallback onTap,
    List<AthkarAction>? actions,
  }) {
    return AthkarCard(
      content: content,
      source: suraName != null && ayahNumber != null 
          ? 'سورة $suraName - الآية $ayahNumber'
          : suraName,
      currentCount: 1,
      totalCount: 1,
      primaryColor: AppTheme.getCategoryColor('القرآن'),
      onTap: onTap,
      actions: actions,
      showProgress: false,
      isCompleted: true,
    );
  }

  /// بطاقة دعاء
  static Widget dua({
    required String content,
    String? source,
    String? fadl,
    required VoidCallback onTap,
    List<AthkarAction>? actions,
  }) {
    return AthkarCard(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: 1,
      totalCount: 1,
      primaryColor: AppTheme.getCategoryColor('الدعاء'),
      onTap: onTap,
      actions: actions,
      showProgress: false,
    );
  }

  /// بطاقة مبسطة
  static Widget simple({
    required String content,
    required int count,
    required Color color,
    required VoidCallback onTap,
    bool isCompleted = false,
  }) {
    return SimpleAthkarCard(
      content: content,
      count: count,
      color: color,
      onTap: onTap,
      isCompleted: isCompleted,
    );
  }
}

// ==================== Extensions للأذكار ====================

extension AthkarCardExtensions on BuildContext {
  /// إظهار بطاقة ذكر في الأسفل
  void showAthkarBottomSheet({
    required String content,
    String? source,
    String? fadl,
    required int currentCount,
    required int totalCount,
    required Color primaryColor,
    required VoidCallback onIncrement,
    List<AthkarAction>? actions,
  }) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: AppTheme.space4.padding,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: AppTheme.radiusXl.radius,
        ),
        child: Padding(
          padding: AppTheme.space5.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // مقبض السحب
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: AppTheme.radiusFull.radius,
                ),
              ),
              
              AppTheme.space4.h,
              
              // بطاقة الذكر
              AthkarCard(
                content: content,
                source: source,
                fadl: fadl,
                currentCount: currentCount,
                totalCount: totalCount,
                primaryColor: primaryColor,
                onTap: onIncrement,
                actions: [
                  AthkarAction(
                    icon: Icons.share,
                    label: 'مشاركة',
                    onPressed: () {
                      // منطق المشاركة
                    },
                    color: AppTheme.info,
                  ),
                  AthkarAction(
                    icon: Icons.copy,
                    label: 'نسخ',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: content));
                      Navigator.pop(context);
                    },
                    color: AppTheme.warning,
                  ),
                  ...?actions,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}