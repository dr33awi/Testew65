// TODO Implement this library.// lib/app/themes/simple/widgets.dart
import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// Widgets مساعدة للتطبيق الإسلامي
/// بساطة ووضوح في الاستخدام

// ==================== مساحات سريعة ====================

class VSpace extends StatelessWidget {
  final double height;
  const VSpace(this.height, {super.key});
  
  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class HSpace extends StatelessWidget {
  final double width;
  const HSpace(this.width, {super.key});
  
  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}

// المساحات الثابتة
class Spaces {
  static const small = VSpace(8);
  static const medium = VSpace(16);
  static const large = VSpace(24);
  static const extraLarge = VSpace(32);
  
  static const smallH = HSpace(8);
  static const mediumH = HSpace(16);
  static const largeH = HSpace(24);
  static const extraLargeH = HSpace(32);
}

// ==================== بطاقة إسلامية ====================

class IslamicCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final LinearGradient? gradient;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  
  const IslamicCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.gradient,
    this.borderRadius,
    this.boxShadow,
  });
  
  /// بطاقة بسيطة
  factory IslamicCard.simple({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return IslamicCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
  }
  
  /// بطاقة بتدرج
  factory IslamicCard.gradient({
    required Widget child,
    required LinearGradient gradient,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return IslamicCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(16),
      gradient: gradient,
      child: child,
    );
  }
  
  /// بطاقة صلاة
  factory IslamicCard.prayer({
    required Widget child,
    required String prayerName,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    final prayerColor = AppColors.getPrayerColor(prayerName);
    return IslamicCard(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(16),
      gradient: LinearGradient(
        colors: [prayerColor, prayerColor.withOpacity(0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: child,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget card = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradient == null 
            ? (color ?? (isDark ? AppColors.darkCard : AppColors.lightCard))
            : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
    
    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          child: card,
        ),
      );
    }
    
    return card;
  }
}

// ==================== زر إسلامي ====================

class IslamicButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isOutlined;
  final Color? color;
  final double? width;
  final double? height;
  
  const IslamicButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isOutlined = false,
    this.color,
    this.width,
    this.height,
  });
  
  /// زر أساسي
  factory IslamicButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
  }) {
    return IslamicButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      width: width,
    );
  }
  
  /// زر ثانوي
  factory IslamicButton.secondary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    double? width,
  }) {
    return IslamicButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isSecondary: true,
      width: width,
    );
  }
  
  /// زر محدود
  factory IslamicButton.outlined({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    Color? color,
    double? width,
  }) {
    return IslamicButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isOutlined: true,
      color: color,
      width: width,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? 
        (isSecondary ? AppColors.secondary : AppColors.primary);
    
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor, width: 2),
            minimumSize: Size(width ?? 0, height ?? 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            minimumSize: Size(width ?? 0, height ?? 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          );
    
    if (icon != null) {
      return isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon),
              label: Text(text),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon),
              label: Text(text),
            );
    }
    
    return isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: style,
            child: Text(text),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: Text(text),
          );
  }
}

// ==================== نص إسلامي ====================

class IslamicText extends StatelessWidget {
  final String text;
  final IslamicTextType type;
  final TextAlign? textAlign;
  final Color? color;
  final double? fontSize;
  
  const IslamicText({
    super.key,
    required this.text,
    required this.type,
    this.textAlign,
    this.color,
    this.fontSize,
  });
  
  /// آية قرآنية
  factory IslamicText.quran({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.quran,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
    );
  }
  
  /// حديث شريف
  factory IslamicText.hadith({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.hadith,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
    );
  }
  
  /// دعاء
  factory IslamicText.dua({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.dua,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
    );
  }
  
  /// تسبيح
  factory IslamicText.tasbih({
    required String text,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
  }) {
    return IslamicText(
      text: text,
      type: IslamicTextType.tasbih,
      textAlign: textAlign ?? TextAlign.center,
      color: color,
      fontSize: fontSize,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ?? (isDark ? AppColors.darkText : AppColors.lightText);
    
    TextStyle style = switch (type) {
      IslamicTextType.quran => AppTypography.quran,
      IslamicTextType.hadith => AppTypography.hadith,
      IslamicTextType.dua => AppTypography.dua,
      IslamicTextType.tasbih => AppTypography.tasbih,
    };
    
    if (fontSize != null) {
      style = style.copyWith(fontSize: fontSize);
    }
    
    return Text(
      text,
      style: style.copyWith(color: defaultColor),
      textAlign: textAlign,
      textDirection: TextDirection.rtl,
    );
  }
}

enum IslamicTextType { quran, hadith, dua, tasbih }

// ==================== مؤشر التحميل الإسلامي ====================

class IslamicLoading extends StatelessWidget {
  final String? message;
  final Color? color;
  final double? size;
  
  const IslamicLoading({
    super.key,
    this.message,
    this.color,
    this.size,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: color ?? AppColors.primary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            Spaces.medium,
            Text(
              message!,
              style: AppTypography.body.copyWith(
                color: color ?? AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== مفتاح التبديل الإسلامي ====================

class IslamicSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? title;
  final String? subtitle;
  final Color? activeColor;
  
  const IslamicSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.subtitle,
    this.activeColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title != null ? Text(title!) : null,
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor ?? AppColors.primary,
      ),
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}

// ==================== شريط تطبيق إسلامي ====================

class IslamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  
  const IslamicAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? 
          (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      foregroundColor: foregroundColor ?? 
          (isDark ? AppColors.darkText : AppColors.lightText),
      elevation: 0,
      bottom: bottom,
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}