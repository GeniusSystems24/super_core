import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_section_theme.dart';
import '../theme/super_tokens.dart';

/// Visual variants for [SuperSectionHeader].
enum SuperSectionHeaderStyle {
  /// Marker-bar + title/subtitle form header.
  style1,

  /// Marker tab + optional icon chip row header.
  style2,
}

/// Consolidated section header for Super section and card surfaces.
///
/// This replaces the older `SectionHeader` and the previous
/// `SuperSectionHeader` implementation. Use [style1] for form/page sections
/// and [style2] for compact rows, expandable cards, and settings groups.
class SuperSectionHeader extends StatelessWidget {
  const SuperSectionHeader({
    super.key,
    required this.title,
    this.titleArabic,
    this.subtitle,
    this.eyebrow,
    this.marker = SuperMarker.identity,
    this.markerColor,
    this.accentColor,
    this.icon,
    this.leading,
    this.trailing,
    this.style = SuperSectionHeaderStyle.style1,
  });

  /// Primary heading text.
  final String title;

  /// Optional inline Arabic translation for [style1].
  final String? titleArabic;

  /// Optional supporting text.
  final String? subtitle;

  /// Optional all-caps breadcrumb shown above [title] in [style1].
  final String? eyebrow;

  /// Marker-bar or icon-chip intent.
  final SuperMarker marker;

  /// Explicit marker/accent color. Takes precedence over [marker].
  final Color? markerColor;

  /// Compatibility alias for the old `SectionHeader.accentColor`.
  ///
  /// [markerColor] wins when both are provided.
  final Color? accentColor;

  /// Compatibility icon from the old `SectionHeader` API.
  ///
  /// In [style1] it is shown as a tinted chip before the marker bar. In
  /// [style2] it is used as the chip content when [leading] is null.
  final IconData? icon;

  /// Optional leading widget.
  final Widget? leading;

  /// Optional trailing widget such as an action, count, status pill, or chevron.
  final Widget? trailing;

  /// Header visual style.
  final SuperSectionHeaderStyle style;

  @override
  Widget build(BuildContext context) {
    return style == SuperSectionHeaderStyle.style2
        ? _buildStyle2(context)
        : _buildStyle1(context);
  }

  Widget _buildStyle1(BuildContext context) {
    final t = context.superTheme;
    final tokens = t.tokens;
    final s = t.spacing;
    final th = SuperSectionHeaderThemeData.of(context);
    final effectiveMarker = th.defaultMarker ?? marker;
    final accent =
        markerColor ?? accentColor ?? tokens.markerColor(effectiveMarker);
    final gap = th.gap ?? s.space3;
    final hasEyebrow = eyebrow != null && eyebrow!.isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    final barHeight = !hasSubtitle && !hasEyebrow
        ? 18.0
        : hasEyebrow
        ? tokens.markerHeight + 14
        : tokens.markerHeight;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Container(
            width: 24,
            height: barHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: t.tint(accent, 0.12),
              borderRadius: const BorderRadiusDirectional.horizontal(
                start: Radius.circular(2),
              ),
            ),
            child: Icon(icon, size: 14, color: accent),
          ),
        Container(
          width: th.markerWidth ?? tokens.markerWidth,
          height: barHeight,
          margin: EdgeInsetsDirectional.only(top: 1, end: s.space3),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(
              th.markerRadius ?? s.radiusPill,
            ),
          ),
        ),
        if (leading != null) ...[leading!, SizedBox(width: gap)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasEyebrow) ...[
                Text(
                  eyebrow!,
                  style:
                      th.eyebrowStyle ??
                      t.textTheme.eyebrow.copyWith(color: accent),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: s.space2),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style:
                          th.titleStyle ??
                          t.textTheme.heading.copyWith(color: t.fg1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (titleArabic != null && titleArabic!.isNotEmpty) ...[
                    SizedBox(width: s.space2),
                    Flexible(
                      child: Text(
                        titleArabic!,
                        style:
                            th.arabicStyle ??
                            t.textTheme.body.copyWith(color: accent),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (hasSubtitle) ...[
                SizedBox(height: s.space1),
                Text(
                  subtitle!,
                  style:
                      th.subtitleStyle ??
                      t.textTheme.caption.copyWith(color: t.fg3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[SizedBox(width: gap), trailing!],
      ],
    );
  }

  Widget _buildStyle2(BuildContext context) {
    final t = context.superTheme;
    final tokens = t.tokens;
    final s = t.spacing;
    final th = SuperSectionHeaderThemeData.of(context);
    final effectiveMarker = th.defaultMarker ?? marker;
    final accent =
        markerColor ?? accentColor ?? tokens.markerColor(effectiveMarker);
    final gap = th.gap ?? s.space3;
    final chip = th.iconChipSize ?? 26;
    final effectiveLeading = leading ?? (icon == null ? null : Icon(icon));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: th.style2BarWidth ?? 4,
          height: th.style2BarHeight ?? 28,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadiusDirectional.horizontal(
              end: Radius.circular(th.style2BarTailRadius ?? 12),
            ),
          ),
        ),
        SizedBox(width: gap),
        if (effectiveLeading != null) ...[
          Container(
            width: chip,
            height: chip,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: t.tint(accent, th.iconChipTintOpacity ?? 0.12),
              borderRadius: BorderRadius.circular(th.iconChipRadius ?? 8),
            ),
            child: IconTheme.merge(
              data: IconThemeData(color: accent, size: th.iconSize ?? 16),
              child: effectiveLeading,
            ),
          ),
          SizedBox(width: gap),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toUpperCase(),
                style:
                    th.style2TitleStyle ??
                    t.textTheme.heading.copyWith(
                      color: t.fg1,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style:
                      th.style2SubtitleStyle ??
                      t.textTheme.caption.copyWith(
                        color: t.fg3,
                        fontSize: 11.5,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: gap),
          IconTheme.merge(
            data: IconThemeData(color: t.fg3, size: th.trailingIconSize ?? 18),
            child: trailing!,
          ),
        ],
      ],
    );
  }
}
