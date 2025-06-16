// lib/features/settings/widgets/settings_tile.dart (محسن ومطور)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';

/// عنصر محسن في قسم الإعدادات مع تفاعل متقدم
class SettingsTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool enabled;
  final bool showRipple;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool showDivider;
  final Widget? badge;
  final double? iconSize;
  final CrossAxisAlignment crossAxisAlignment;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.iconColor,
    this.backgroundColor,
    this.enabled = true,
    this.showRipple = true,
    this.padding,
    this.borderRadius,
    this.showDivider = false,
    this.badge,
    this.iconSize,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    if (!mounted) return;
    
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTap() {
    if (!widget.enabled || widget.onTap == null) return;
    
    HapticFeedback.mediumImpact();
    widget.onTap!();
  }

  void _handleLongPress() {
    if (!widget.enabled || widget.onLongPress == null) return;
    
    HapticFeedback.heavyImpact();
    widget.onLongPress!();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = widget.iconColor ?? context.primaryColor;
    final effectiveBackgroundColor = widget.backgroundColor ?? Colors.transparent;
    final effectivePadding = widget.padding ?? const EdgeInsets.symmetric(
      horizontal: ThemeConstants.space4,
      vertical: ThemeConstants.space4,
    );
    final effectiveBorderRadius = widget.borderRadius ?? 
        BorderRadius.circular(ThemeConstants.radiusXl);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: widget.enabled ? _opacityAnimation.value : 0.6,
            child: Container(
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                borderRadius: effectiveBorderRadius,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleTap,
                  onLongPress: _handleLongPress,
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  borderRadius: effectiveBorderRadius,
                  splashColor: widget.showRipple 
                      ? effectiveIconColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  highlightColor: widget.showRipple
                      ? effectiveIconColor.withValues(alpha: 0.05)
                      : Colors.transparent,
                  child: Padding(
                    padding: effectivePadding,
                    child: Row(
                      crossAxisAlignment: widget.crossAxisAlignment,
                      children: [
                        _buildIcon(context, effectiveIconColor),
                        ThemeConstants.space4.w,
                        Expanded(child: _buildContent(context)),
                        if (widget.trailing != null) ...[
                          ThemeConstants.space3.w,
                          _buildTrailing(context),
                        ] else if (widget.onTap != null && widget.enabled) ...[
                          ThemeConstants.space3.w,
                          _buildDefaultTrailing(context),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context, Color iconColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // خلفية الأيقونة مع تأثير
        AnimatedContainer(
          duration: ThemeConstants.durationFast,
          width: widget.iconSize != null ? widget.iconSize! + 16 : 48,
          height: widget.iconSize != null ? widget.iconSize! + 16 : 48,
          decoration: BoxDecoration(
            color: widget.enabled 
                ? iconColor.withValues(alpha: _isPressed ? 0.2 : 0.1)
                : context.textSecondaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            boxShadow: _isPressed && widget.enabled ? [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Icon(
            widget.icon,
            color: widget.enabled 
                ? iconColor
                : context.textSecondaryColor.withValues(alpha: 0.5),
            size: widget.iconSize ?? ThemeConstants.iconMd,
          ),
        ),
        
        // Badge إذا كان موجود
        if (widget.badge != null)
          Positioned(
            top: 0,
            right: 0,
            child: widget.badge!,
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // العنوان
        AnimatedDefaultTextStyle(
          duration: ThemeConstants.durationFast,
          style: context.titleMedium?.copyWith(
            color: widget.enabled 
                ? context.textPrimaryColor
                : context.textSecondaryColor.withValues(alpha: 0.7),
            fontWeight: ThemeConstants.medium,
            height: 1.2,
          ) ?? const TextStyle(),
          child: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // العنوان الفرعي
        if (widget.subtitle != null) ...[
          ThemeConstants.space1.h,
          AnimatedDefaultTextStyle(
            duration: ThemeConstants.durationFast,
            style: context.bodySmall?.copyWith(
              color: widget.enabled 
                  ? context.textSecondaryColor
                  : context.textSecondaryColor.withValues(alpha: 0.5),
              height: 1.3,
            ) ?? const TextStyle(),
            child: Text(
              widget.subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return AnimatedOpacity(
      duration: ThemeConstants.durationFast,
      opacity: widget.enabled ? 1.0 : 0.5,
      child: widget.trailing!,
    );
  }

  Widget _buildDefaultTrailing(BuildContext context) {
    return AnimatedRotation(
      duration: ThemeConstants.durationFast,
      turns: _isPressed ? 0.05 : 0.0,
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: ThemeConstants.iconSm,
        color: context.textSecondaryColor.withValues(
          alpha: widget.enabled ? 0.6 : 0.3,
        ),
      ),
    );
  }
}

/// Badge للإشعارات أو التنبيهات
class SettingsBadge extends StatelessWidget {
  final String? text;
  final Color? color;
  final bool isNew;
  final bool isWarning;
  final bool isError;
  final double? size;

  const SettingsBadge({
    super.key,
    this.text,
    this.color,
    this.isNew = false,
    this.isWarning = false,
    this.isError = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    if (color != null) {
      badgeColor = color!;
    } else if (isError) {
      badgeColor = ThemeConstants.error;
    } else if (isWarning) {
      badgeColor = ThemeConstants.warning;
    } else if (isNew) {
      badgeColor = ThemeConstants.success;
    } else {
      badgeColor = context.primaryColor;
    }

    final effectiveSize = size ?? 16.0;

    return Container(
      constraints: BoxConstraints(
        minWidth: effectiveSize,
        minHeight: effectiveSize,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: text != null ? 6 : 0,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(effectiveSize / 2),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: text != null
          ? Text(
              text!,
              style: TextStyle(
                color: Colors.white,
                fontSize: effectiveSize * 0.6,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
              textAlign: TextAlign.center,
            )
          : null,
    );
  }

  /// Badge جديد
  factory SettingsBadge.isNew([String? text]) => SettingsBadge(
        text: text ?? 'جديد',
        isNew: true,
      );

  /// Badge تحذير
  factory SettingsBadge.warning([String? text]) => SettingsBadge(
        text: text ?? '!',
        isWarning: true,
      );

  /// Badge خطأ
  factory SettingsBadge.error([String? text]) => SettingsBadge(
        text: text ?? '!',
        isError: true,
      );

  /// Badge عداد
  factory SettingsBadge.count(int count, {Color? color}) => SettingsBadge(
        text: count > 99 ? '99+' : count.toString(),
        color: color,
      );

  /// Badge نقطة فقط
  factory SettingsBadge.dot({Color? color}) => SettingsBadge(
        color: color,
        size: 8,
      );
}

/// Switch مخصص للإعدادات
class SettingsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enabled;

  const SettingsSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: activeColor ?? context.primaryColor,
      inactiveThumbColor: inactiveColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// قائمة منسدلة للإعدادات
class SettingsDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;

  const SettingsDropdown({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      hint: hint != null ? Text(hint!) : null,
      underline: const SizedBox(),
      isDense: true,
      icon: Icon(
        Icons.arrow_drop_down,
        color: context.textSecondaryColor,
      ),
    );
  }
}

/// زر إجراء في الإعدادات
class SettingsActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool outlined;
  final bool enabled;

  const SettingsActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.outlined = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.primaryColor;

    if (outlined) {
      return OutlinedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: icon != null ? Icon(icon, size: 16) : const SizedBox(),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveColor,
          side: BorderSide(color: effectiveColor),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: icon != null ? Icon(icon, size: 16) : const SizedBox(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
      ),
    );
  }
}