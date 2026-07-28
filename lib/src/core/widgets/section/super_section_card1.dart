import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/super_card_theme.dart';
import '../../theme/super_color_utils.dart';
import '../../theme/super_section_theme.dart';
import '../hairline.dart';
import 'super_section_footer.dart';

/// Compact section card with a left accent bar title treatment.
///
/// Defaults for surface color, radius, border, margin, clipping, padding and
/// expand motion come from [SuperSectionThemeData] and [SuperCardTheme].
class SuperSectionCard1 extends StatefulWidget {
  const SuperSectionCard1({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.padding,
    this.accentColor,
    this.isSelected = false,
    this.collapsible = false,
    this.initiallyExpanded,
    this.onExpansionChanged,
    this.icon,
    this.trailing,
    this.footer,
    this.footerBrand,
    this.footerActions = const [],
    this.dividerAfterHeader,
    this.background,
    this.color,
    this.clipBehavior,
    this.margin,
    this.animationDuration,
    this.animationCurve,
  });

  final String? title;
  final String? subtitle;

  /// Body content rendered below the optional title row.
  final Widget child;

  final EdgeInsetsGeometry? padding;
  final Color? accentColor;

  /// Applies the selected accent border and subtle selected fill.
  final bool isSelected;

  /// Whether the card can be collapsed or expanded from the header.
  final bool collapsible;

  /// Default expansion state when [collapsible] is true.
  ///
  /// Non-collapsible cards always render their body and ignore this value.
  final bool? initiallyExpanded;

  /// Called whenever the user requests a new expansion state.
  final ValueChanged<bool>? onExpansionChanged;
  final IconData? icon;
  final Widget? trailing;
  final Widget? footer;
  final String? footerBrand;
  final List<Widget> footerActions;
  final bool? dividerAfterHeader;
  final Color? background;
  final Color? color;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? margin;
  final Duration? animationDuration;
  final Curve? animationCurve;

  @override
  State<SuperSectionCard1> createState() => _SuperSectionCard1State();
}

class _SuperSectionCard1State extends State<SuperSectionCard1>
    with AutomaticKeepAliveClientMixin<SuperSectionCard1> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = _initialExpanded;
  }

  bool get _initialExpanded =>
      widget.collapsible ? (widget.initiallyExpanded ?? true) : true;

  @override
  void didUpdateWidget(covariant SuperSectionCard1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.collapsible) {
      _expanded = true;
    } else if (!oldWidget.collapsible) {
      _expanded = _initialExpanded;
    }
  }

  void _toggle() {
    if (!widget.collapsible) return;

    final next = !_expanded;
    widget.onExpansionChanged?.call(next);
    setState(() => _expanded = next);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        widget.animationDuration ??
        sectionTheme.expandDuration ??
        cardTheme.expandDuration ??
        tokens.durExpand;
    final expandCurve =
        widget.animationCurve ??
        sectionTheme.expandCurve ??
        cardTheme.expandCurve ??
        tokens.curveOut;
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
        colorScheme.surfaceContainerLow;
    final selectedFill = widget.isSelected
        ? accent.tintOver(fill, sectionTheme.selectedTintOpacity ?? 0.08)
        : fill;
    final borderColor = widget.isSelected
        ? accent
        : sectionTheme.borderColor ??
              cardTheme.borderColor ??
              Colors.transparent;
    final borderWidth = widget.isSelected ? 1.5 : 1.0;
    final cardPadding =
        widget.padding ??
        sectionTheme.padding ??
        cardTheme.padding ??
        spacing.cardPadding;
    final footerGap = sectionTheme.footerGap ?? spacing.lg;
    final clip = widget.clipBehavior ?? cardTheme.clipBehavior;
    final visible = !widget.collapsible || _expanded;
    final resolvedFooter =
        widget.footer ??
        (widget.footerBrand == null
            ? null
            : SuperSectionFooter(
                brand: widget.footerBrand!,
                actions: widget.footerActions,
              ));

    final effectiveElevation = cardTheme.elevation;
    final boxShadow = effectiveElevation != null && effectiveElevation <= 0
        ? const <BoxShadow>[]
        : [
            BoxShadow(
              color: (cardTheme.shadowColor ?? colorScheme.shadow).withValues(
                alpha: 0.04,
              ),
              blurRadius: 32,
              offset: const Offset(0, 4),
            ),
          ];

    Widget card = AnimatedContainer(
      duration: tokens.durBase,
      curve: tokens.curveStandard,
      margin: widget.margin ?? cardTheme.margin,
      padding: cardPadding,
      decoration: BoxDecoration(
        color: selectedFill,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: boxShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            GestureDetector(
              onTap: widget.collapsible ? _toggle : null,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Expanded(
                    child: SuperSectionTitle1(
                      title: widget.title!,
                      subtitle: widget.subtitle,
                      accentColor: accent,
                      icon: widget.icon,
                      trailing: widget.trailing,
                    ),
                  ),
                  SizedBox(width: cardTheme.gap ?? spacing.md),
                  if (widget.collapsible)
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: expandDuration,
                      curve: expandCurve,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: t.fg3,
                        size: 22,
                      ),
                    ),
                ],
              ),
            ),
          ],
          AnimatedCrossFade(
            firstCurve: expandCurve,
            secondCurve: expandCurve,
            sizeCurve: expandCurve,
            duration: expandDuration,
            crossFadeState: visible
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.title != null) ...[
                  if (dividerAfterHeader) ...[
                    SizedBox(height: spacing.space4),
                    const Hairline(),
                    SizedBox(height: spacing.space4),
                  ] else
                    SizedBox(height: sectionTheme.headerGap ?? spacing.xl),
                ],
                widget.child,
                if (resolvedFooter != null) ...[
                  SizedBox(height: footerGap),
                  resolvedFooter,
                ],
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

    return Semantics(container: true, child: card);
  }
}

class SuperSectionTitle1 extends StatelessWidget {
  const SuperSectionTitle1({
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null)
          Container(
            width: 24,
            height: subtitle != null ? 40 : 24,
            decoration: BoxDecoration(
              color: accentColor?.withValues(alpha: 0.12),
              borderRadius: const BorderRadiusDirectional.horizontal(
                start: Radius.circular(2),
              ),
            ),
            child: Icon(icon, size: 14, color: accentColor),
          ),
        Container(
          width: 4,
          height: subtitle != null ? 40 : 24,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: t.spacing.space3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: t.textTheme.titleMd.copyWith(color: t.fg1)),
              if (subtitle != null) ...[
                SizedBox(height: t.spacing.space1),
                Tooltip(
                  message: subtitle!,
                  child: Text(
                    subtitle!.toUpperCase(),
                    style: t.textTheme.labelSm.copyWith(
                      color: t.fg3,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),

        if (trailing != null) ...[SizedBox(width: t.spacing.space3), trailing!],
      ],
    );
  }
}
