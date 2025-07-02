// lib/features/home/widgets/floating_action_menu.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class FloatingActionMenu extends StatefulWidget {
  final bool visible;
  final VoidCallback? onScrollToTop;

  const FloatingActionMenu({
    super.key,
    required this.visible,
    this.onScrollToTop,
  });

  @override
  State<FloatingActionMenu> createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with TickerProviderStateMixin {
  late AnimationController _visibilityController;
  late AnimationController _expandController;
  late Animation<double> _visibilityAnimation;
  late Animation<double> _expandAnimation;
  
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _visibilityController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _expandController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _visibilityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _visibilityController,
      curve: ThemeConstants.curveSmooth,
    ));

    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: ThemeConstants.curveSmooth,
    ));
  }

  @override
  void didUpdateWidget(FloatingActionMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _visibilityController.forward();
      } else {
        _visibilityController.reverse();
        if (_isExpanded) {
          _toggleExpansion();
        }
      }
    }
  }

  @override
  void dispose() {
    _visibilityController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _visibilityAnimation,
      builder: (context, child) {
        if (_visibilityAnimation.value == 0) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: ThemeConstants.space4,
          bottom: ThemeConstants.space6,
          child: Transform.scale(
            scale: _visibilityAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الأزرار الفرعية
                AnimatedBuilder(
                  animation: _expandAnimation,
                  builder: (context, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSubButton(
                          icon: Icons.favorite_rounded,
                          color: ThemeConstants.accent,
                          tooltip: 'المفضلة',
                          onPressed: () => _navigateToFavorites(context),
                          delay: 0,
                        ),
                        
                        _buildSubButton(
                          icon: Icons.bar_chart_rounded,
                          color: ThemeConstants.tertiary,
                          tooltip: 'الإحصائيات',
                          onPressed: () => _navigateToStats(context),
                          delay: 1,
                        ),
                        
                        _buildSubButton(
                          icon: Icons.share_rounded,
                          color: ThemeConstants.primaryLight,
                          tooltip: 'مشاركة التطبيق',
                          onPressed: () => _shareApp(context),
                          delay: 2,
                        ),
                        
                        _buildSubButton(
                          icon: Icons.keyboard_arrow_up_rounded,
                          color: context.primaryColor,
                          tooltip: 'الأعلى',
                          onPressed: widget.onScrollToTop,
                          delay: 3,
                        ),
                      ],
                    );
                  },
                ),
                
                ThemeConstants.space3.h,
                
                // الزر الرئيسي
                _buildMainButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback? onPressed,
    required int delay,
  }) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        final delayedAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: _expandAnimation,
          curve: Interval(
            delay * 0.1,
            0.7 + (delay * 0.1),
            curve: ThemeConstants.curveSmooth,
          ),
        ));

        return Transform.scale(
          scale: delayedAnimation.value,
          child: Transform.translate(
            offset: Offset(
              0,
              (1 - delayedAnimation.value) * 20,
            ),
            child: Opacity(
              opacity: delayedAnimation.value,
              child: Container(
                margin: const EdgeInsets.only(bottom: ThemeConstants.space3),
                child: _buildFloatingButton(
                  icon: icon,
                  color: color,
                  size: 48,
                  onPressed: onPressed,
                  tooltip: tooltip,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainButton(BuildContext context) {
    return _buildFloatingButton(
      icon: _isExpanded ? Icons.close_rounded : Icons.menu_rounded,
      color: context.primaryColor,
      size: 56,
      onPressed: _toggleExpansion,
      tooltip: _isExpanded ? 'إغلاق' : 'القائمة',
      isMain: true,
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback? onPressed,
    required String tooltip,
    bool isMain = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.lighten(0.1),
              color,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: isMain ? 12 : 8,
              offset: Offset(0, isMain ? 6 : 4),
              spreadRadius: isMain ? 2 : 0,
            ),
            if (isMain)
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 4,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                customBorder: const CircleBorder(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: ThemeConstants.durationFast,
                      child: Icon(
                        icon,
                        key: ValueKey(icon),
                        color: Colors.white,
                        size: isMain ? 28 : 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToFavorites(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/favorites').catchError((error) {
      if (context.mounted) {
        context.showInfoSnackBar('هذه الميزة قيد التطوير');
      }
      return null;
    });
  }

  void _navigateToStats(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/statistics').catchError((error) {
      if (context.mounted) {
        context.showInfoSnackBar('هذه الميزة قيد التطوير');
      }
      return null;
    });
  }

  void _shareApp(BuildContext context) {
    HapticFeedback.lightImpact();
    // يمكن استخدام share_plus package هنا
    context.showInfoSnackBar('سيتم إضافة ميزة المشاركة قريباً');
  }
}