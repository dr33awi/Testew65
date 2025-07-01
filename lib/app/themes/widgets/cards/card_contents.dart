// lib/app/themes/widgets/cards/card_contents.dart - النسخة المبسطة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';
import 'card_types.dart';

/// بناء محتويات البطاقات - مبسط
class CardContentBuilder {
  CardContentBuilder._();

  /// بناء المحتوى حسب النوع
  static Widget buildContent({
    required CardProperties properties,
    required BuildContext context,
  }) {
    // فحص الـ child المخصص أولاً
    if (properties.child != null && _isValidChild(properties.child!)) {
      return properties.child!;
    }
    
    // بناء المحتوى حسب النوع
    switch (properties.type) {
      case CardType.athkar:
        return AthkarContent.build(properties: properties, context: context);
      case CardType.quote:
        return QuoteContent.build(properties: properties, context: context);
      case CardType.info:
        return InfoContent.build(properties: properties, context: context);
      case CardType.normal:
        return NormalContent.build(properties: properties, context: context);
    }
  }

  /// فحص صحة الـ child
  static bool _isValidChild(Widget child) {
    if (child is SizedBox) {
      final sizedBox = child;
      if ((sizedBox.width == null || sizedBox.width == 0.0) && 
          (sizedBox.height == null || sizedBox.height == 0.0) &&
          sizedBox.child == null) {
        return false;
      }
    }
    
    if (child is Container) {
      final container = child;
      if (container.child == null) {
        return false;
      }
    }
    
    return true;
  }

  /// محتوى احتياطي عند عدم وجود بيانات
  static Widget buildFallbackContent(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: _getTextColor(context, CardStyle.normal).withValues(alpha: 0.5),
          ),
          const SizedBox(height: ThemeConstants.space2),
          Text(
            message,
            style: context.bodyMedium?.copyWith(
              color: _getTextColor(context, CardStyle.normal),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// الحصول على لون النص المناسب
  static Color _getTextColor(BuildContext context, CardStyle style, {bool isSecondary = false}) {
    if (style == CardStyle.gradient || style == CardStyle.glassmorphism) {
      return isSecondary 
          ? Colors.white.withValues(alpha: 0.85)
          : Colors.white;
    }
    
    return isSecondary 
        ? context.textSecondaryColor 
        : context.textPrimaryColor;
  }
}

/// محتوى الأذكار
class AthkarContent {
  static Widget build({
    required CardProperties properties,
    required BuildContext context,
  }) {
    if (!properties.hasAthkarData) {
      return CardContentBuilder.buildFallbackContent(context, 'محتوى الذكر غير متوفر');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // الرأس مع العداد والأيقونات
        if (properties.currentCount != null || properties.totalCount != null || properties.actions != null)
          _buildAthkarHeader(properties, context),
        
        if ((properties.currentCount != null || properties.totalCount != null || properties.actions != null) && 
            (properties.content != null || properties.title != null))
          const SizedBox(height: ThemeConstants.space3),
        
        // محتوى الذكر
        if (properties.content != null || properties.title != null)
          _buildAthkarBody(properties, context),
        
        // المصدر
        if (properties.source != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildSource(properties, context),
        ],
        
        // الفضل
        if (properties.fadl != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildFadlSection(properties, context),
        ],
      ],
    );
  }

  static Widget _buildAthkarHeader(CardProperties properties, BuildContext context) {
    return Row(
      children: [
        if (properties.currentCount != null && properties.totalCount != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Text(
              '${properties.currentCount}/${properties.totalCount}',
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        
        const Spacer(),
        
        if (properties.actions != null && properties.actions!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: properties.actions!.map((action) => 
              Container(
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: action.onPressed,
                  icon: Icon(action.icon),
                  iconSize: 20,
                  color: Colors.white,
                  tooltip: action.label,
                ),
              ),
            ).toList(),
          ),
      ],
    );
  }

  static Widget _buildAthkarBody(CardProperties properties, BuildContext context) {
    final text = properties.content ?? properties.title ?? '';
    if (text.isEmpty) {
      return CardContentBuilder.buildFallbackContent(context, 'محتوى الذكر');
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: 20,
          fontWeight: ThemeConstants.semiBold,
          height: 2.0,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.6),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSource(CardProperties properties, BuildContext context) {
    if (properties.source == null) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space2,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Text(
          properties.source!,
          style: context.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.bold,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.5),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildFadlSection(CardProperties properties, BuildContext context) {
    if (properties.fadl == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.star_outline,
            color: Colors.white.withValues(alpha: 0.8),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الفضل',
                  style: context.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  properties.fadl!,
                  style: context.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// محتوى الاقتباسات
class QuoteContent {
  static Widget build({
    required CardProperties properties,
    required BuildContext context,
  }) {
    if (properties.content == null && properties.title == null) {
      return CardContentBuilder.buildFallbackContent(context, 'محتوى الاقتباس');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (properties.subtitle != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space1,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            ),
            child: Text(
              properties.subtitle!,
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
        
        if (properties.subtitle != null) const SizedBox(height: ThemeConstants.space3),
        
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          ),
          child: Text(
            properties.content ?? properties.title ?? '',
            textAlign: TextAlign.center,
            style: context.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: 18,
              height: 1.8,
            ),
          ),
        ),
        
        if (properties.source != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          AthkarContent._buildSource(properties, context),
        ],
      ],
    );
  }
}

/// محتوى المعلومات
class InfoContent {
  static Widget build({
    required CardProperties properties,
    required BuildContext context,
  }) {
    if (properties.title == null && properties.subtitle == null && properties.icon == null) {
      return CardContentBuilder.buildFallbackContent(context, 'معلومات البطاقة');
    }

    return Row(
      children: [
        if (properties.icon != null)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (properties.primaryColor ?? context.primaryColor).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Icon(
              properties.icon,
              color: properties.primaryColor ?? context.primaryColor,
              size: ThemeConstants.iconLg,
            ),
          ),
        
        if (properties.icon != null) const SizedBox(width: ThemeConstants.space4),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (properties.title != null)
                Text(
                  properties.title!,
                  style: context.titleMedium?.copyWith(
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
              if (properties.subtitle != null) ...[
                const SizedBox(height: ThemeConstants.space1),
                Text(
                  properties.subtitle!,
                  style: context.bodyMedium?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        if (properties.trailing != null) properties.trailing!,
      ],
    );
  }
}

/// محتوى عادي
class NormalContent {
  static Widget build({
    required CardProperties properties,
    required BuildContext context,
  }) {
    if (!properties.hasContent) {
      return CardContentBuilder.buildFallbackContent(context, 'محتوى البطاقة');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (properties.icon != null)
          Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(bottom: ThemeConstants.space4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              properties.icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        
        const Spacer(),
        
        if (properties.title != null)
          Text(
            properties.title!,
            style: CardContentBuilder._getTextColor(context, properties.style) == Colors.white
                ? context.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    fontSize: 18,
                    height: 1.2,
                    letterSpacing: 0.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  )
                : context.titleLarge?.copyWith(
                    color: CardContentBuilder._getTextColor(context, properties.style),
                    fontWeight: ThemeConstants.semiBold,
                  ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        
        if (properties.subtitle != null) ...[
          const SizedBox(height: ThemeConstants.space1),
          Text(
            properties.subtitle!,
            style: CardContentBuilder._getTextColor(context, properties.style) == Colors.white
                ? context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  )
                : context.bodyMedium?.copyWith(
                    color: CardContentBuilder._getTextColor(context, properties.style, isSecondary: true),
                  ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        
        if (properties.content != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          Text(
            properties.content!,
            style: context.bodyLarge?.copyWith(
              color: CardContentBuilder._getTextColor(context, properties.style),
            ),
          ),
        ],
        
        if (properties.onTap != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
        ],
        
        if (properties.actions != null && properties.actions!.isNotEmpty) ...[
          const SizedBox(height: ThemeConstants.space4),
          _buildActions(properties, context),
        ],
      ],
    );
  }

  static Widget _buildActions(CardProperties properties, BuildContext context) {
    if (properties.actions == null || properties.actions!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space2,
      children: properties.actions!.map((action) => 
        OutlinedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            action.onPressed();
          },
          icon: Icon(action.icon, size: 18),
          label: Text(action.label),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
          ),
        ),
      ).toList(),
    );
  }
}