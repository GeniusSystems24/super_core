// ============================================================
// core/widgets/super_section_header.dart
// ------------------------------------------------------------
// SuperSectionHeader — the page/section header pattern of the GeniusLink design
// system. Two styles:
//
//   • style1 — the signature 4x40 marker bar + title (16/700), with an optional
//     ALL-CAPS breadcrumb eyebrow above and an inline Arabic translation beside
//     the title. The classic form-page section header.
//   • style2 — a compact list/row header: a tinted rounded icon chip ([leading])
//     + ALL-CAPS title + subtitle + a [trailing] slot (e.g. a chevron). Used for
//     expandable rows, settings groups and linked-account cards.
//
// Both styles take [leading] and [trailing]. Everything resolves from the
// ambient [SuperThemeData].
// ============================================================

import 'package:flutter/widgets.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_section_theme.dart';
import '../theme/super_text_styles.dart';
import '../theme/super_tokens.dart';

/// The visual style of a [SuperSectionHeader].
enum SuperSectionHeaderStyle {
  /// Marker-bar + title/subtitle form-page header.
  style1,

  /// Icon-chip + ALL-CAPS title/subtitle row header.
  style2,
}

/// A section / page header — see [SuperSectionHeaderStyle] for the two forms.
class SuperSectionHeader extends StatelessWidget {
  const SuperSectionHeader({
    super.key,
    required this.title,
    this.titleArabic,
    this.subtitle,
    this.eyebrow,
    this.marker = SuperMarker.identity,
    this.leading,
    this.trailing,
    this.style = SuperSectionHeaderStyle.style1,
  });

  /// Primary heading text (Title Case for style1, upper-cased for style2).
  final String title;

  /// Optional inline Arabic translation rendered in tertiary blue beside [title]
  /// (style1 only — e.g. `Opening Journal Entry قيد افتتاحي`).
  final String? titleArabic;

  /// One-line plain-English explainer beneath the title.
  final String? subtitle;

  /// Optional ALL-CAPS breadcrumb / eyebrow above the title (style1 only).
  final String? eyebrow;

  /// The marker-bar / icon-chip intent (identity / ledger / notes).
  final SuperMarker marker;

  /// Leading widget. In style1 it sits between the marker bar and the text; in
  /// style2 it is wrapped in a tinted rounded icon chip.
  final Widget? leading;

  /// Trailing widget (an action button, a count, a chevron, a toggle).
  final Widget? trailing;

  /// Which visual style to render.
  final SuperSectionHeaderStyle style;

  @override
  Widget build(BuildContext context) {
    return style == SuperSectionHeaderStyle.style2
        ? _buildStyle2(context)
        : _buildStyle1(context);
  }

  // ── style1 — marker bar + title/subtitle ─────────────────────────────────
  Widget _buildStyle1(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final th = SuperSectionHeaderThemeData.of(context);
    final gap = th.gap ?? k.space3;
    final hasEyebrow = eyebrow != null && eyebrow!.isNotEmpty;
    final double barHeight = (subtitle == null && !hasEyebrow)
        ? 20
        : (hasEyebrow ? k.markerHeight + 16 : k.markerHeight);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: th.markerWidth ?? k.markerWidth,
          height: barHeight,
          margin: EdgeInsetsDirectional.only(top: 1, end: k.space4),
          decoration: BoxDecoration(
            color: k.markerColor(marker),
            borderRadius:
                BorderRadius.circular(th.markerRadius ?? k.radiusPill),
          ),
        ),
        if (leading != null) ...[
          leading!,
          SizedBox(width: gap),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasEyebrow) ...[
                Text(eyebrow!,
                    style: th.eyebrowStyle ??
                        SuperText.eyebrow.copyWith(color: k.accent)),
                SizedBox(height: k.space2),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Flexible(
                    child: Text(title,
                        style: th.titleStyle ??
                            SuperText.heading.copyWith(color: t.fg1)),
                  ),
                  if (titleArabic != null && titleArabic!.isNotEmpty) ...[
                    SizedBox(width: k.space2),
                    Text(titleArabic!,
                        style: th.arabicStyle ??
                            SuperText.body.copyWith(color: k.accent)),
                  ],
                ],
              ),
              if (subtitle != null) ...[
                SizedBox(height: k.space1),
                Text(subtitle!,
                    style: th.subtitleStyle ??
                        SuperText.caption.copyWith(color: t.fg3)),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: gap),
          trailing!,
        ],
      ],
    );
  }

  // ── style2 — flush left marker tab + icon chip + ALL-CAPS title/subtitle ──
  Widget _buildStyle2(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final th = SuperSectionHeaderThemeData.of(context);
    final accent = k.markerColor(marker);
    final gap = th.gap ?? k.space3;
    final chip = th.iconChipSize ?? 30;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Marker bar flush to the leading edge, rounded on the trailing side.
        Container(
          width: th.style2BarWidth ?? 4,
          height: th.style2BarHeight ?? 36,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadiusDirectional.horizontal(
              end: Radius.circular(th.style2BarTailRadius ?? 12),
            ),
          ),
        ),
        SizedBox(width: gap),
        if (leading != null) ...[
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
              child: leading!,
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
                style: th.style2TitleStyle ??
                    SuperText.heading.copyWith(
                      color: t.fg1,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(subtitle!,
                    style: th.style2SubtitleStyle ??
                        SuperText.caption
                            .copyWith(color: t.fg3, fontSize: 11.5)),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: gap),
          IconTheme.merge(
            data: IconThemeData(
                color: t.fg3, size: th.trailingIconSize ?? 18),
            child: trailing!,
          ),
        ],
      ],
    );
  }
}
