// lib/app/themes/widgets/extended_cards.dart - كروت إضافية للثيم الموحد
// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// بطاقة متقدمة للأذكار مع كامل الميزات
class AdvancedAthkarCard extends StatelessWidget {
  final String content;
  final String? source;
  final String? fadl;
  final int currentCount;
  final int totalCount;
  final Color primaryColor;
  final bool isCompleted;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;
  final VoidCallback? onCopy;
  final VoidCallback? onReset;
  final bool showProgress;

  const AdvancedAthkarCard({
    super.key,
    required this.content,
    this.source,
    this.fadl,
    required this.currentCount,
    required this.totalCount,
    required this.primaryColor,
    this.isCompleted = false,
    this.isFavorite = false,
    required this.onTap,
    this.onFavorite,
    this.onShare,
    this.onCopy,
    this.onReset,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.athkar(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      primaryColor: primaryColor,
      isCompleted: isCompleted,
      onTap: onTap,
      showProgress: showProgress,
      actions: _buildActions(),
    );
  }

  List<CardAction> _buildActions() {
    final actions = <CardAction>[];

    // زر المفضلة
    if (onFavorite != null) {
      actions.add(
        CardAction(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
          label: '',
          onPressed: onFavorite!,
          color: isFavorite ? AppTheme.error : AppTheme.textSecondary,
        ),
      );
    }

    // زر المشاركة
    if (onShare != null) {
      actions.add(
        CardAction(
          icon: Icons.share,
          label: '',
          onPressed: onShare!,
          color: AppTheme.info,
        ),
      );
    }

    // زر النسخ
    if (onCopy != null) {
      actions.add(
        CardAction(
          icon: Icons.copy,
          label: '',
          onPressed: onCopy!,
          color: AppTheme.warning,
        ),
      );
    }

    // زر إعادة التعيين
    if (onReset != null && currentCount > 0) {
      actions.add(
        CardAction(
          icon: Icons.refresh,
          label: '',
          onPressed: onReset!,
          color: AppTheme.textTertiary,
        ),
      );
    }

    return actions;
  }
}

/// شريط علوي بسيط للصفحات
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onBackPressed;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppAppBar.basic(
      title: title,
      actions: actions,
      onBackPressed: onBackPressed,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// مكون الضغط مع التأثيرات البصرية
class AnimatedPress extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;

  const AnimatedPress({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<AnimatedPress> createState() => _AnimatedPressState();
}

class _AnimatedPressState extends State<AnimatedPress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    _controller.forward();
  }

  void _handleTapUp() {
    _controller.reverse();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      HapticFeedback.lightImpact();
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _handleTapDown(),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: _handleTapUp,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// بطاقة إحصائية متقدمة
class AdvancedStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final double? percentage;
  final VoidCallback? onTap;

  const AdvancedStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
    this.percentage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      useGradient: true,
      color: color,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الأيقونة والقيمة
          Row(
            children: [
              Container(
                padding: AppTheme.space2.padding,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: AppTheme.radiusMd.radius,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: AppTheme.iconMd,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: AppTheme.headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.bold,
                  fontFamily: AppTheme.numbersFont,
                ),
              ),
            ],
          ),

          AppTheme.space3.h,

          // العنوان
          Text(
            title,
            style: AppTheme.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTheme.semiBold,
            ),
          ),

          // العنوان الفرعي
          if (subtitle != null) ...[
            AppTheme.space1.h,
            Text(
              subtitle!,
              style: AppTheme.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],

          // شريط التقدم
          if (percentage != null) ...[
            AppTheme.space3.h,
            Container(
              height: AppTheme.radiusXs,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: AppTheme.radiusFull.radius,
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (percentage! / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// بطاقة معلومة سريعة
class QuickInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const QuickInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppTheme.primary;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: AppTheme.iconXl + AppTheme.space2,
            height: AppTheme.iconXl + AppTheme.space2,
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusMd.radius,
            ),
            child: Icon(
              icon,
              color: cardColor,
              size: AppTheme.iconMd,
            ),
          ),

          AppTheme.space3.w,

          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTheme.titleLarge.copyWith(
                    fontWeight: AppTheme.bold,
                    fontFamily: AppTheme.numbersFont,
                    color: cardColor,
                  ),
                ),
                AppTheme.space1.h,
                Text(
                  title,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // سهم الانتقال (إذا كان هناك إجراء)
          if (onTap != null) ...[
            AppTheme.space2.w,
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textTertiary,
              size: AppTheme.iconMd,
            ),
          ],
        ],
      ),
    );
  }
}

/// بطاقة تنبيه أو رسالة
class MessageCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final String? actionText;
  final VoidCallback? onAction;
  final bool isDismissible;
  final VoidCallback? onDismiss;

  const MessageCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.actionText,
    this.onAction,
    this.isDismissible = false,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: color.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: AppTheme.iconMd,
              ),
              AppTheme.space2.w,
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.titleMedium.copyWith(
                    color: color,
                    fontWeight: AppTheme.bold,
                  ),
                ),
              ),
              if (isDismissible) ...[
                AppTheme.space2.w,
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppTheme.textTertiary,
                    size: AppTheme.iconSm,
                  ),
                  onPressed: onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),

          AppTheme.space2.h,

          Text(
            message,
            style: AppTheme.bodyMedium.copyWith(
              height: 1.5,
            ),
          ),

          if (actionText != null && onAction != null) ...[
            AppTheme.space4.h,
            AppButton.outline(
              text: actionText!,
              onPressed: onAction!,
              borderColor: color,
            ),
          ],
        ],
      ),
    );
  }
}

/// مصنع البطاقات للرسائل الشائعة
class MessageCards {
  MessageCards._();

  static Widget success({
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
    bool isDismissible = false,
    VoidCallback? onDismiss,
  }) {
    return MessageCard(
      title: title,
      message: message,
      icon: Icons.check_circle,
      color: AppTheme.success,
      actionText: actionText,
      onAction: onAction,
      isDismissible: isDismissible,
      onDismiss: onDismiss,
    );
  }

  static Widget warning({
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
    bool isDismissible = false,
    VoidCallback? onDismiss,
  }) {
    return MessageCard(
      title: title,
      message: message,
      icon: Icons.warning,
      color: AppTheme.warning,
      actionText: actionText,
      onAction: onAction,
      isDismissible: isDismissible,
      onDismiss: onDismiss,
    );
  }

  static Widget error({
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
    bool isDismissible = false,
    VoidCallback? onDismiss,
  }) {
    return MessageCard(
      title: title,
      message: message,
      icon: Icons.error,
      color: AppTheme.error,
      actionText: actionText,
      onAction: onAction,
      isDismissible: isDismissible,
      onDismiss: onDismiss,
    );
  }

  static Widget info({
    required String title,
    required String message,
    String? actionText,
    VoidCallback? onAction,
    bool isDismissible = false,
    VoidCallback? onDismiss,
  }) {
    return MessageCard(
      title: title,
      message: message,
      icon: Icons.info,
      color: AppTheme.info,
      actionText: actionText,
      onAction: onAction,
      isDismissible: isDismissible,
      onDismiss: onDismiss,
    );
  }
}

/// نمط التحقق من تحديث AppButton
extension AppButtonExtended on AppButton {
  /// زر ثانوي
  static AppButton secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: AppTheme.secondary,
      foregroundColor: Colors.black,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// زر الخطر
  static AppButton danger({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: AppTheme.error,
      foregroundColor: Colors.white,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// زر النجاح
  static AppButton success({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      backgroundColor: AppTheme.success,
      foregroundColor: Colors.white,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }
}

/// نمط التحقق من تحديث SettingCard
extension SettingCardExtended on SettingCard {
  /// بطاقة إعداد للانتقال
  static SettingCard navigation({
    Key? key,
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? color,
  }) {
    return SettingCard(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      color: color,
      showArrow: true,
    );
  }

  /// بطاقة إعداد مع مفتاح تشغيل
  static SettingCard toggle({
    Key? key,
    required String title,
    String? subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool>? onChanged,
    Color? color,
  }) {
    return SettingCard(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: color,
      showArrow: false,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: color ?? AppTheme.primary,
      ),
      onTap: onChanged != null ? () => onChanged(!value) : null,
    );
  }
}