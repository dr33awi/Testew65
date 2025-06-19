// lib/app/themes/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../app_theme.dart';
import '../theme_constants.dart';

/// شريط تطبيق مخصص موحد
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AppBarAction>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation = 0,
  });

  factory CustomAppBar.simple({
    required String title,
    List<AppBarAction>? actions,
    Widget? leading,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.backgroundColor,
            context.backgroundColor.withValues(alpha: 0.95),
            context.backgroundColor.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            title: Text(
              title,
              style: context.titleLarge?.copyWith(
                fontWeight: ThemeConstants.bold,
              ),
            ),
            centerTitle: centerTitle,
            backgroundColor: backgroundColor ?? Colors.transparent,
            elevation: elevation,
            surfaceTintColor: Colors.transparent,
            leading: leading,
            actions: actions?.map((action) => action._build(context)).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// إجراء في شريط التطبيق
class AppBarAction {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;

  const AppBarAction({
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
  });

  Widget _build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: ThemeConstants.space2),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color ?? context.primaryColor,
        ),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}