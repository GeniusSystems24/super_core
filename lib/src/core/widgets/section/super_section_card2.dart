import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/super_card_theme.dart';
import '../../theme/super_color_utils.dart';
import '../../theme/super_section_theme.dart';
import '../hairline.dart';
import 'super_section_footer.dart';

/// Style-2 section card: left accent rail · icon chip · title · optional chevron.
///
/// Pairs the compact rail-and-chip header design with full [SuperCardTheme] and
/// [SuperSectionThemeData] integration, optional animated expand/collapse,
/// footer, divider, configurable fill, clip, padding and margin.
class SuperSectionCard2 extends StatefulWidget {
  const SuperSectionCard2({
    super.key,
    required this.child,
    required this.title,
    String? subtitle,
    this.icon,
    this.isSelected = false,
    this.collapsible = true,
    this.initiallyExpanded,
    this.onExpansionChanged,
    Widget? trailing,
    Color? accentColor,
    this.footer,
    this.footerBrand,
    this.footerActions = const [],
    this.dividerAfterHeader,
    this.background,
    this.color,
    this.clipBehavior,
    this.padding,
    this.margin,
    @Deprecated('use accentColor instead') Color? marker,
    @Deprecated('use subtitle instead') String? sub,
    @Deprecated('use trailing instead') Widget? right,
  }) : accentColor = marker ?? accentColor,
       subtitle = sub ?? subtitle,
       trailing = right ?? trailing;

  final String title;
  final String? subtitle;
  final IconData? icon;

  /// Applies the selected accent border and subtle selected fill.
  final bool isSelected;

  /// Whether the header tap collapses the body. Defaults to `true`.
  final bool collapsible;

  /// Initial expansion state. When null, collapsible cards start expanded.
  final bool? initiallyExpanded;

  /// Called whenever the user requests a new expansion state.
  final ValueChanged<bool>? onExpansionChanged;

  final Widget child;
  final Widget? trailing;
  final Color? accentColor;

  /// Prebuilt footer widget.
  final Widget? footer;

  /// Brand text — auto-builds a [SuperSectionFooter] when set.
  final String? footerBrand;

  /// Action links used with [footerBrand].
  final List<Widget> footerActions;

  /// Draws a [Hairline] between the header and the body.
  final bool? dividerAfterHeader;

  /// Section-style fill color override.
  final Color? background;

  /// Material Card-compatible fill color override (alias of [background]).
  final Color? color;

  /// Clip behavior applied to the card boundary.
  final Clip? clipBehavior;

  /// Interior padding around the body and footer.
  final EdgeInsetsGeometry? padding;

  /// Exterior margin around the card.
  final EdgeInsetsGeometry? margin;

  @override
  State<SuperSectionCard2> createState() => _SuperSectionCard2State();
}

class _SuperSectionCard2State extends State<SuperSectionCard2> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded ?? (widget.collapsible ? true : false);
  }

  void _toggle() {
    final next = !_expanded;
    widget.onExpansionChanged?.call(next);
    setState(() => _expanded = next);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final tokens = t.tokens;
    final spacing = t.spacing;
    final colorScheme = Theme.of(context).colorScheme;
    final sectionTheme = SuperSectionThemeData.of(context);
    final cardTheme = SuperCardTheme.of(context);

    final accent =
        widget.accentColor ??
        sectionTheme.selectedBorderColor ??
        cardTheme.selectedBorderColor ??
        colorScheme.primary;

    final expandDuration =
        sectionTheme.expandDuration ??
        cardTheme.expandDuration ??
        tokens.durExpand;

    final expandCurve =
        sectionTheme.expandCurve ?? cardTheme.expandCurve ?? tokens.curveOut;

    final footerGap = sectionTheme.footerGap ?? spacing.lg;

    final dividerAfterHeader =
        widget.dividerAfterHeader ?? sectionTheme.dividerAfterHeader ?? false;

    final shape = cardTheme.shape;
    final radius =
        shape is RoundedRectangleBorder && shape.borderRadius is BorderRadius
        ? shape.borderRadius as BorderRadius
        : BorderRadius.circular(sectionTheme.radius ?? spacing.radiusCard);

    final fill =
        widget.color ??
        widget.background ??
        sectionTheme.background ??
        cardTheme.color ??
        t.surface;
    final selectedFill = widget.isSelected
        ? accent.tintOver(fill, sectionTheme.selectedTintOpacity ?? 0.08)
        : fill;

    final borderColor = widget.isSelected
        ? accent
        : sectionTheme.borderColor ?? cardTheme.borderColor ?? t.border;
    final borderWidth = widget.isSelected ? 1.5 : 1.0;

    final bodyPadding =
        widget.padding ??
        sectionTheme.padding ??
        cardTheme.padding ??
        EdgeInsets.fromLTRB(16, 4, 16, spacing.lg);

    final clip = widget.clipBehavior ?? cardTheme.clipBehavior;

    final resolvedFooter =
        widget.footer ??
        (widget.footerBrand == null
            ? null
            : SuperSectionFooter(
                brand: widget.footerBrand!,
                actions: widget.footerActions,
              ));

    Widget card = AnimatedContainer(
      duration: tokens.durBase,
      curve: tokens.curveStandard,
      margin: widget.margin ?? cardTheme.margin,
      decoration: BoxDecoration(
        color: selectedFill,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: radius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          _buildHeader(
            accent: accent,
            expandDuration: expandDuration,
            expandCurve: expandCurve,
            fg3: t.fg3,
          ),
          // ── Body + footer (animated) ─────────────────────────────────────
          AnimatedCrossFade(
            firstCurve: expandCurve,
            secondCurve: expandCurve,
            sizeCurve: expandCurve,
            duration: expandDuration,
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (dividerAfterHeader) const Hairline(),
                Padding(
                  padding: bodyPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.child,
                      if (resolvedFooter != null) ...[
                        SizedBox(height: footerGap),
                        resolvedFooter,
                      ],
                    ],
                  ),
                ),
              ],
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );

    if (clip != null && clip != Clip.none) {
      card = ClipRRect(borderRadius: radius, clipBehavior: clip, child: card);
    }

    return card;
  }

  Widget _buildHeader({
    required Color accent,
    required Duration expandDuration,
    required Curve expandCurve,
    required Color fg3,
  }) {
    final header = Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: SuperSectionTitle2(
              title: widget.title,
              subtitle: widget.subtitle,
              accentColor: accent,
              icon: widget.icon,
              trailing: widget.trailing,
            ),
          ),
          // chevron — only when collapsible
          if (widget.collapsible)
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0.0,
              duration: expandDuration,
              curve: expandCurve,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: fg3,
              ),
            ),
        ],
      ),
    );

    if (!widget.collapsible) return header;
    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.opaque,
      child: header,
    );
  }
}

/// Style-2 section title row used by [SuperSectionCard2].
class SuperSectionTitle2 extends StatelessWidget {
  const SuperSectionTitle2({
    super.key,
    required this.title,
    this.subtitle,
    this.accentColor,
    this.icon,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Color? accentColor;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final accent = accentColor ?? Theme.of(context).colorScheme.primary;
    final titleStyle = t.textTheme.labelMd.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 12.5,
      letterSpacing: 0.7,
      color: t.fg1,
    );
    final subtitleStyle = t.textTheme.labelMd.copyWith(
      fontSize: 11.5,
      fontWeight: FontWeight.w400,
      color: t.fg3,
    );

    return Row(
      children: [
        Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(12),
            ),
          ),
        ),
        SizedBox(width: t.spacing.space3),
        if (icon != null) ...[
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: t.tint(accent, 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: accent),
          ),
          SizedBox(width: t.spacing.space3),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.toUpperCase(), style: titleStyle),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(subtitle!, style: subtitleStyle),
                ),
            ],
          ),
        ),
        if (trailing != null) ...[SizedBox(width: t.spacing.space3), trailing!],
      ],
    );
  }
}
