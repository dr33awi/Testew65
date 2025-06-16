// lib/features/settings/widgets/settings_section.dart (محسن ومطور)
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

/// قسم محسن في شاشة الإعدادات مع تأثيرات بصرية متقدمة
class SettingsSection extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;
  final bool showHeader;
  final bool isCollapsible;
  final bool initiallyExpanded;
  final Widget? headerTrailing;
  final VoidCallback? onHeaderTap;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final bool showDividers;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    this.showHeader = true,
    this.isCollapsible = false,
    this.initiallyExpanded = true,
    this.headerTrailing,
    this.onHeaderTap,
    this.elevation,
    this.borderRadius,
    this.gradient,
    this.showDividers = true,
  });

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _initializeAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveDefault,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    widget.onHeaderTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveMargin = widget.margin ?? const EdgeInsets.symmetric(
      horizontal: ThemeConstants.space4,
      vertical: ThemeConstants.space3,
    );

    final effectiveBorderRadius = widget.borderRadius ?? 
        BorderRadius.circular(ThemeConstants.radiusXl);

    return Container(
      margin: effectiveMargin,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: widget.elevation ?? 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? context.cardColor,
            gradient: widget.gradient,
            borderRadius: effectiveBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showHeader) _buildHeader(context),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final effectiveTitleColor = widget.titleColor ?? context.primaryColor;
    final effectiveIconColor = widget.iconColor ?? context.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isCollapsible ? _toggleExpansion : widget.onHeaderTap,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ThemeConstants.radiusXl),
          topRight: Radius.circular(ThemeConstants.radiusXl),
        ),
        child: Container(
          padding: widget.padding ?? const EdgeInsets.all(ThemeConstants.space4),
          child: Row(
            children: [
              // أيقونة القسم
              if (widget.icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    widget.icon,
                    size: ThemeConstants.iconSm,
                    color: effectiveIconColor,
                  ),
                ),
                ThemeConstants.space3.w,
              ],
              
              // محتوى العنوان
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: context.titleMedium?.copyWith(
                        color: effectiveTitleColor,
                        fontWeight: ThemeConstants.bold,
                        height: 1.2,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      ThemeConstants.space1.h,
                      Text(
                        widget.subtitle!,
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // العنصر الإضافي في الهيدر
              if (widget.headerTrailing != null) ...[
                ThemeConstants.space3.w,
                widget.headerTrailing!,
              ],
              
              // سهم الطي (إذا كان قابل للطي)
              if (widget.isCollapsible) ...[
                ThemeConstants.space2.w,
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: effectiveIconColor,
                        size: ThemeConstants.iconMd,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.isCollapsible) {
      return SizeTransition(
        sizeFactor: _expandAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildContentBody(context),
        ),
      );
    }

    return _buildContentBody(context);
  }

  Widget _buildContentBody(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        // خط فاصل بين الهيدر والمحتوى
        if (widget.showHeader && widget.showDividers)
          Divider(
            height: 1,
            thickness: 1,
            color: context.dividerColor.withValues(alpha: 0.3),
            indent: 0,
            endIndent: 0,
          ),
        
        // محتوى القسم
        ...List.generate(
          widget.children.length,
          (index) {
            final child = widget.children[index];
            final isLast = index == widget.children.length - 1;
            
            return Column(
              children: [
                child,
                // خط فاصل بين العناصر
                if (!isLast && widget.showDividers)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: ThemeConstants.space6,
                    endIndent: ThemeConstants.space6,
                    color: context.dividerColor.withValues(alpha: 0.3),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// قسم بسيط بدون تعقيدات
class SimpleSettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;
  final EdgeInsetsGeometry? margin;

  const SimpleSettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.icon,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: title,
      icon: icon,
      children: children,
      margin: margin,
      showDividers: true,
      elevation: 8,
    );
  }
}

/// قسم مع تدرج لوني
class GradientSettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;
  final List<Color> gradientColors;
  final EdgeInsetsGeometry? margin;

  const GradientSettingsSection({
    super.key,
    required this.title,
    required this.children,
    required this.gradientColors,
    this.icon,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: title,
      icon: icon,
      children: children,
      margin: margin,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ),
      titleColor: Colors.white,
      iconColor: Colors.white,
      showDividers: false,
    );
  }
}

/// قسم قابل للطي
class CollapsibleSettingsSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final IconData? icon;
  final bool initiallyExpanded;
  final EdgeInsetsGeometry? margin;

  const CollapsibleSettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
    this.initiallyExpanded = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: title,
      subtitle: subtitle,
      icon: icon,
      children: children,
      margin: margin,
      isCollapsible: true,
      initiallyExpanded: initiallyExpanded,
      showDividers: true,
    );
  }
}

/// قسم بدون هيدر
class HeaderlessSettingsSection extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  const HeaderlessSettingsSection({
    super.key,
    required this.children,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: '',
      children: children,
      margin: margin,
      backgroundColor: backgroundColor,
      showHeader: false,
      showDividers: true,
    );
  }
}

/// ويدجت لعنوان القسم فقط
class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? titleColor;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const SettingsSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.titleColor,
    this.iconColor,
    this.trailing,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitleColor = titleColor ?? context.primaryColor;
    final effectiveIconColor = iconColor ?? context.primaryColor;
    final effectivePadding = padding ?? const EdgeInsets.symmetric(
      horizontal: ThemeConstants.space4,
      vertical: ThemeConstants.space3,
    );

    return Padding(
      padding: effectivePadding,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: ThemeConstants.iconSm,
                  color: effectiveIconColor,
                ),
                ThemeConstants.space2.w,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.labelLarge?.copyWith(
                        color: effectiveTitleColor,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      ThemeConstants.space1.h,
                      Text(
                        subtitle!,
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                ThemeConstants.space2.w,
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}