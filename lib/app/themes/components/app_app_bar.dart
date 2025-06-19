// lib/app/themes/components/app_app_bar.dart
import 'package:flutter/material.dart';
import '../colors.dart';
import '../typography.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      title: Text(
        title,
        style: AppTypography.title.copyWith(
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
      ),
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? 
          (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      foregroundColor: isDark ? AppColors.darkText : AppColors.lightText,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}