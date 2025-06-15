// lib/features/athkar/widgets/athkar_completion_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AthkarCompletionDialog extends StatefulWidget {
  final String categoryName;
  final VoidCallback? onShare;
  final VoidCallback? onReset;

  const AthkarCompletionDialog({
    super.key,
    required this.categoryName,
    this.onShare,
    this.onReset,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String categoryName,
    VoidCallback? onShare,
    VoidCallback? onReset,
  }) async {
    HapticFeedback.mediumImpact();
    
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AthkarCompletionDialog(
        categoryName: categoryName,
        onShare: onShare,
        onReset: onReset,
      ),
    );
  }

  @override
  State<AthkarCompletionDialog> createState() => _AthkarCompletionDialogState();
}

class _AthkarCompletionDialogState extends State<AthkarCompletionDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationSlow,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5),
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                  gradient: LinearGradient(
                    colors: [
                      ThemeConstants.success.lighten(0.1),
                      ThemeConstants.success,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // الرأس
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.space6),
                      child: Column(
                        children: [
                          // الأيقونة المتحركة
                          _AnimatedCheckIcon(
                            animation: _animationController,
                          ),
                          
                          ThemeConstants.space4.h,
                          
                          // العنوان
                          AnimationConfiguration.synchronized(
                            duration: ThemeConstants.durationNormal,
                            child: SlideAnimation(
                              verticalOffset: 20,
                              curve: Curves.easeOutBack,
                              child: FadeInAnimation(
                                child: Text(
                                  'مبارك عليك!',
                                  style: context.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: ThemeConstants.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          ThemeConstants.space2.h,
                          
                          // الرسالة
                          AnimationConfiguration.synchronized(
                            duration: ThemeConstants.durationNormal,
                            child: SlideAnimation(
                              verticalOffset: 20,
                              curve: Curves.easeOutBack,
                              delay: const Duration(milliseconds: 100),
                              child: FadeInAnimation(
                                child: Text(
                                  'أكملت ${widget.categoryName}',
                                  style: context.bodyLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          
                          ThemeConstants.space1.h,
                          
                          // دعاء
                          AnimationConfiguration.synchronized(
                            duration: ThemeConstants.durationNormal,
                            child: SlideAnimation(
                              verticalOffset: 20,
                              curve: Curves.easeOutBack,
                              delay: const Duration(milliseconds: 200),
                              child: FadeInAnimation(
                                child: Text(
                                  'جعله الله في ميزان حسناتك',
                                  style: context.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // الإجراءات
                    Container(
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(ThemeConstants.radiusXl),
                          bottomRight: Radius.circular(ThemeConstants.radiusXl),
                        ),
                      ),
                      padding: const EdgeInsets.all(ThemeConstants.space4),
                      child: Column(
                        children: [
                          // زر المشاركة
                          if (widget.onShare != null)
                            AnimationConfiguration.synchronized(
                              duration: ThemeConstants.durationNormal,
                              child: SlideAnimation(
                                horizontalOffset: 50,
                                curve: Curves.easeOutBack,
                                delay: const Duration(milliseconds: 300),
                                child: FadeInAnimation(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: AppButton.primary(
                                      text: 'مشاركة الإنجاز',
                                      icon: Icons.share_rounded,
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                        widget.onShare?.call();
                                      },
                                      backgroundColor: ThemeConstants.success,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          
                          if (widget.onShare != null) ThemeConstants.space3.h,
                          
                          // الأزرار الثانوية
                          AnimationConfiguration.synchronized(
                            duration: ThemeConstants.durationNormal,
                            child: SlideAnimation(
                              horizontalOffset: -50,
                              curve: Curves.easeOutBack,
                              delay: const Duration(milliseconds: 400),
                              child: FadeInAnimation(
                                child: Row(
                                  children: [
                                    // زر الإغلاق
                                    Expanded(
                                      child: AppButton.text(
                                        text: 'إغلاق',
                                        onPressed: () => Navigator.pop(context, false),
                                      ),
                                    ),
                                    
                                    ThemeConstants.space3.w,
                                    
                                    // زر البدء من جديد
                                    if (widget.onReset != null)
                                      Expanded(
                                        child: AppButton.outline(
                                          text: 'البدء من جديد',
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                            widget.onReset?.call();
                                          },
                                          icon: Icons.refresh,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// أيقونة الإنجاز المتحركة
class _AnimatedCheckIcon extends StatelessWidget {
  final Animation<double> animation;

  const _AnimatedCheckIcon({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // الدوائر المتحركة
              _AnimatedCircle(
                animation: animation,
                delay: 0.0,
                size: 80,
              ),
              _AnimatedCircle(
                animation: animation,
                delay: 0.2,
                size: 60,
              ),
              
              // الأيقونة
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// الدوائر المتحركة
class _AnimatedCircle extends StatelessWidget {
  final Animation<double> animation;
  final double delay;
  final double size;

  const _AnimatedCircle({
    required this.animation,
    required this.delay,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = Curves.easeOut.transform(
          ((animation.value - delay) / (1 - delay)).clamp(0.0, 1.0),
        );
        
        return Transform.scale(
          scale: value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3 * (1 - value)),
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}