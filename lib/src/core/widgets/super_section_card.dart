import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_card_theme.dart';
import '../theme/super_color_utils.dart';
import '../theme/super_section_theme.dart';
import '../theme/super_theme.dart';
import '../theme/super_tokens.dart';
import 'hairline.dart';
import 'super_section_footer.dart';
import 'super_section_header.dart';

/// Consolidated section/card surface for Super UI.
///
/// This replaces the older `SectionCard`, `SuperSection`, and `SuperCard`
/// implementations. It can render a plain card, a headed section, a section
/// with footer links, a selectable/tappable card, a collapsible section body,
/// or a card with an expandable detail area.
class SuperSectionCard extends StatefulWidget {
  const SuperSectionCard({
    super.key,
    this.child,
    this.children,
    this.header,
    this.title,
    this.titleArabic,
    this.subtitle,
    this.eyebrow,
    this.marker = SuperMarker.identity,
    this.markerColor,
    this.accentColor,
    this.icon,
    this.leading,
    this.headerTrailing,
    this.headerStyle = SuperSectionHeaderStyle.style1,
    this.footer,
    this.footerBrand,
    this.footerActions = const [],
    this.collapsible = false,
    this.initiallyExpanded,
    this.isExpanded,
    this.onExpansionChanged,
    this.expandedChild,
    this.expandDirection,
    this.toggleOnTap,
    this.showExpandIcon,
    this.onTap,
    this.selected = false,
    this.dividerAfterHeader,
    this.card,
    this.background,
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.clipBehavior,
    this.semanticContainer = true,
    this.gap,
    this.padding,
    this.margin,
  }) : assert(
         child == null || children == null,
         'Provide either child or children, not both.',
       ),
       assert(
         header == null || title == null,
         'Provide either a prebuilt header or the convenience title fields.',
       );

  /// Single body widget. Mutually exclusive with [children].
  final Widget? child;

  /// Body widgets with automatic vertical spacing. Mutually exclusive with
  /// [child].
  final List<Widget>? children;

  /// Prebuilt header. When null and [title] is set, [SuperSectionHeader] is
  /// created from the convenience fields.
  final Widget? header;

  /// Header title.
  final String? title;

  /// Optional inline Arabic title rendered by [SuperSectionHeader.style1].
  final String? titleArabic;

  /// Header subtitle.
  final String? subtitle;

  /// Optional breadcrumb/eyebrow rendered above the title in style1.
  final String? eyebrow;

  /// Header marker intent.
  final SuperMarker marker;

  /// Explicit marker/accent color. Takes precedence over [marker].
  final Color? markerColor;

  /// Compatibility alias for the old `SectionCard.accentColor`.
  final Color? accentColor;

  /// Compatibility icon from the old `SectionCard` API.
  ///
  /// With the default header style, this renders as the legacy tinted chip
  /// before the marker bar.
  final IconData? icon;

  /// Optional header leading widget.
  ///
  /// With the default header style, this is placed in the same leading zone as
  /// the legacy title icon, before the marker bar.
  final Widget? leading;

  /// Optional header trailing widget.
  ///
  /// With the default header style, this is placed at the far end of the title
  /// row before any collapse/expand chevron.
  final Widget? headerTrailing;

  /// Header visual style.
  final SuperSectionHeaderStyle headerStyle;

  /// Prebuilt footer. When null and [footerBrand] is set,
  /// [SuperSectionFooter] is created.
  final Widget? footer;

  /// Brand text used to build a default [SuperSectionFooter].
  final String? footerBrand;

  /// Footer action links used with [footerBrand].
  final List<Widget> footerActions;

  /// Whether the body collapses when the header is tapped.
  final bool collapsible;

  /// Initial expansion state.
  ///
  /// When null, collapsible sections start expanded and cards with only
  /// [expandedChild] start collapsed.
  final bool? initiallyExpanded;

  /// Controlled expansion state for collapsible or expandable cards.
  final bool? isExpanded;

  /// Called whenever the user requests a new expansion state.
  final ValueChanged<bool>? onExpansionChanged;

  /// Additional content revealed by expansion.
  final Widget? expandedChild;

  /// Axis used by [expandedChild]. Defaults to [SuperCardTheme.expandDirection].
  final Axis? expandDirection;

  /// Whether tapping the card body toggles [expandedChild].
  final bool? toggleOnTap;

  /// Whether an animated chevron is shown when the card can expand/collapse.
  final bool? showExpandIcon;

  /// Makes the card interactive and calls this when tapped.
  final VoidCallback? onTap;

  /// Draws the selected accent border and subtle tint.
  final bool selected;

  /// Draws a hairline between the header and body.
  final bool? dividerAfterHeader;

  /// Whether to render the card surface. `false` returns a plain padded layout.
  final bool? card;

  /// Section-style background override.
  final Color? background;

  /// Material Card-compatible fill color override.
  final Color? color;

  /// Shadow color used to build an elevation shadow.
  final Color? shadowColor;

  /// Optional Material elevation tint blended over the fill.
  final Color? surfaceTintColor;

  /// Card elevation. `0` suppresses shadow.
  final double? elevation;

  /// Optional card shape.
  final ShapeBorder? shape;

  /// Accepted for Material Card API parity.
  final bool borderOnForeground;

  /// Clip behavior applied to the card boundary.
  final Clip? clipBehavior;

  /// Whether the card is wrapped in a semantic container.
  final bool semanticContainer;

  /// Gap between [children].
  final double? gap;

  /// Interior padding.
  final EdgeInsetsGeometry? padding;

  /// Exterior margin around the card.
  final EdgeInsetsGeometry? margin;

  bool get _hasExpandableDetail => expandedChild != null;

  bool get _canToggle => collapsible || _hasExpandableDetail;

  @override
  State<SuperSectionCard> createState() => _SuperSectionCardState();
}

class _SuperSectionCardState extends State<SuperSectionCard> {
  bool _hover = false;
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded =
        widget.isExpanded ??
        widget.initiallyExpanded ??
        (widget.collapsible ? true : false);
  }

  @override
  void didUpdateWidget(SuperSectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != null && widget.isExpanded != _expanded) {
      _expanded = widget.isExpanded!;
    }
  }

  void _toggle() {
    final next = !_expanded;
    widget.onExpansionChanged?.call(next);
    if (widget.isExpanded == null) {
      setState(() => _expanded = next);
    }
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
        widget.markerColor ??
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
    final cardGap = cardTheme.gap ?? spacing.md;
    final bodyGap = widget.gap ?? sectionTheme.gap ?? spacing.space4;
    final headerGap = sectionTheme.headerGap ?? spacing.xl;
    final footerGap = sectionTheme.footerGap ?? spacing.lg;
    final dividerAfterHeader =
        widget.dividerAfterHeader ?? sectionTheme.dividerAfterHeader ?? false;
    final direction =
        widget.expandDirection ?? cardTheme.expandDirection ?? Axis.vertical;
    final showExpandIcon =
        widget.showExpandIcon ?? cardTheme.showExpandIcon ?? true;
    final toggleOnTap = widget.toggleOnTap ?? cardTheme.toggleOnTap ?? true;

    final resolvedHeader = _buildHeader(
      context,
      expandDuration: expandDuration,
      expandCurve: expandCurve,
      showExpandIcon: showExpandIcon,
      cardGap: cardGap,
      direction: direction,
    );
    final resolvedFooter =
        widget.footer ??
        (widget.footerBrand == null
            ? null
            : SuperSectionFooter(
                brand: widget.footerBrand!,
                actions: widget.footerActions,
              ));
    final body = _buildBody(bodyGap);
    final content = _buildContent(
      context,
      header: resolvedHeader,
      body: body,
      footer: resolvedFooter,
      headerGap: headerGap,
      footerGap: footerGap,
      dividerAfterHeader: dividerAfterHeader,
      expandDuration: expandDuration,
      expandCurve: expandCurve,
      direction: direction,
      cardGap: cardGap,
    );

    final useCard = widget.card ?? sectionTheme.card ?? true;
    final card = useCard
        ? _buildCard(
            context,
            content: content,
            sectionTheme: sectionTheme,
            cardTheme: cardTheme,
            accent: accent,
          )
        : Padding(padding: widget.padding ?? EdgeInsets.zero, child: content);

    final toggleFromWholeCard = widget._hasExpandableDetail && toggleOnTap;
    final interactive =
        (widget.onTap != null && !widget.collapsible) || toggleFromWholeCard;
    if (!interactive) return card;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (toggleFromWholeCard) _toggle();
          if (!widget.collapsible) widget.onTap?.call();
        },
        child: card,
      ),
    );
  }

  Widget? _buildHeader(
    BuildContext context, {
    required Duration expandDuration,
    required Curve expandCurve,
    required bool showExpandIcon,
    required double cardGap,
    required Axis direction,
  }) {
    Widget? resolvedHeader = widget.header;
    if (resolvedHeader == null && widget.title != null) {
      resolvedHeader = widget.headerStyle == SuperSectionHeaderStyle.style2
          ? SuperSectionHeader(
              title: widget.title!,
              titleArabic: widget.titleArabic,
              subtitle: widget.subtitle,
              eyebrow: widget.eyebrow,
              marker: widget.marker,
              markerColor: widget.markerColor,
              accentColor: widget.accentColor,
              icon: widget.icon,
              leading: widget.leading,
              trailing: widget.headerTrailing,
              style: widget.headerStyle,
            )
          : _SuperSectionCardTitle(
              title: widget.title!,
              titleArabic: widget.titleArabic,
              subtitle: widget.subtitle,
              eyebrow: widget.eyebrow,
              marker: widget.marker,
              markerColor: widget.markerColor,
              accentColor: widget.accentColor,
              icon: widget.icon,
              leading: widget.leading,
              trailing: widget.headerTrailing,
            );
    }

    if (!widget._canToggle || !showExpandIcon) {
      return _wrapHeaderToggle(resolvedHeader);
    }

    final t = context.superTheme;
    final chevron = AnimatedRotation(
      turns: _expanded ? (direction == Axis.vertical ? 0.5 : 0.25) : 0.0,
      duration: expandDuration,
      curve: expandCurve,
      child: Icon(
        direction == Axis.vertical
            ? Icons.keyboard_arrow_down_rounded
            : Icons.chevron_right,
        size: direction == Axis.vertical ? 22 : 20,
        color: t.fg3,
      ),
    );

    if (resolvedHeader == null) {
      return _wrapHeaderToggle(
        Align(alignment: AlignmentDirectional.centerEnd, child: chevron),
      );
    }

    return _wrapHeaderToggle(
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: resolvedHeader),
          SizedBox(width: cardGap),
          chevron,
        ],
      ),
    );
  }

  Widget? _wrapHeaderToggle(Widget? header) {
    if (header == null || !widget.collapsible) return header;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggle,
      child: header,
    );
  }

  Widget? _buildBody(double gap) {
    if (widget.children != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.children!.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            widget.children![i],
          ],
        ],
      );
    }
    return widget.child;
  }

  Widget _buildContent(
    BuildContext context, {
    required Widget? header,
    required Widget? body,
    required Widget? footer,
    required double headerGap,
    required double footerGap,
    required bool dividerAfterHeader,
    required Duration expandDuration,
    required Curve expandCurve,
    required Axis direction,
    required double cardGap,
  }) {
    final t = context.superTheme;
    final bodyContent = _buildBodyContent(
      body: body,
      footer: footer,
      footerGap: footerGap,
      expandDuration: expandDuration,
      expandCurve: expandCurve,
      direction: direction,
      cardGap: cardGap,
    );
    final visibleBody = widget.collapsible
        ? AnimatedCrossFade(
            firstCurve: expandCurve,
            secondCurve: expandCurve,
            sizeCurve: expandCurve,
            duration: expandDuration,
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: bodyContent ?? const SizedBox(width: double.infinity),
            secondChild: const SizedBox(width: double.infinity),
          )
        : bodyContent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null) header,
        if (visibleBody != null) ...[
          if (header != null) ...[
            if (dividerAfterHeader) ...[
              SizedBox(height: t.spacing.space4),
              const Hairline(),
              SizedBox(height: t.spacing.space4),
            ] else
              SizedBox(height: headerGap),
          ],
          visibleBody,
        ],
      ],
    );
  }

  Widget? _buildBodyContent({
    required Widget? body,
    required Widget? footer,
    required double footerGap,
    required Duration expandDuration,
    required Curve expandCurve,
    required Axis direction,
    required double cardGap,
  }) {
    Widget? content = body;

    if (widget.expandedChild != null) {
      final vertical = direction == Axis.vertical;
      final revealed = ClipRect(
        child: AnimatedAlign(
          duration: expandDuration,
          curve: expandCurve,
          alignment: vertical ? Alignment.topLeft : Alignment.centerLeft,
          heightFactor: vertical ? (_expanded ? 1.0 : 0.0) : null,
          widthFactor: vertical ? null : (_expanded ? 1.0 : 0.0),
          child: Padding(
            padding: vertical
                ? EdgeInsets.only(top: cardGap)
                : EdgeInsetsDirectional.only(start: cardGap),
            child: widget.expandedChild,
          ),
        ),
      );

      content = vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [if (content != null) content, revealed],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (content != null) Flexible(child: content),
                revealed,
              ],
            );
    }

    if (footer != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (content != null) content,
          if (content != null) SizedBox(height: footerGap),
          footer,
        ],
      );
    }

    return content;
  }

  Widget _buildCard(
    BuildContext context, {
    required Widget content,
    required SuperSectionThemeData sectionTheme,
    required SuperCardTheme cardTheme,
    required Color accent,
  }) {
    final t = context.superTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final shape = widget.shape ?? cardTheme.shape;
    final radius =
        shape is RoundedRectangleBorder && shape.borderRadius is BorderRadius
        ? shape.borderRadius as BorderRadius
        : BorderRadius.circular(sectionTheme.radius ?? t.spacing.radiusCard);
    final baseFill =
        widget.color ??
        widget.background ??
        sectionTheme.background ??
        cardTheme.color ??
        colorScheme.surfaceContainerLow;
    final tintedFill =
        widget.surfaceTintColor != null &&
            widget.surfaceTintColor != Colors.transparent
        ? Color.alphaBlend(
            widget.surfaceTintColor!.withValues(alpha: 0.08),
            baseFill,
          )
        : baseFill;
    final fill = widget.selected
        ? accent.tintOver(tintedFill, sectionTheme.selectedTintOpacity ?? 0.08)
        : tintedFill;
    final shapeSide = shape is RoundedRectangleBorder
        ? shape.side
        : BorderSide.none;
    final hasShapeSide = shapeSide != BorderSide.none;
    final hoverBorder = _hover && (widget.onTap != null || widget._canToggle);
    final borderColor = widget.selected
        ? accent
        : hasShapeSide
        ? shapeSide.color
        : hoverBorder
        ? (cardTheme.borderColor ?? t.border)
        : (sectionTheme.borderColor ?? Colors.transparent);
    final borderWidth = widget.selected
        ? 1.5
        : hasShapeSide
        ? shapeSide.width
        : 1.0;
    final effectiveElevation = widget.elevation ?? cardTheme.elevation;
    final boxShadow = _boxShadow(t, effectiveElevation);
    final padding =
        widget.padding ??
        sectionTheme.padding ??
        cardTheme.padding ??
        t.spacing.cardPadding;

    Widget card = AnimatedContainer(
      duration: t.tokens.durBase,
      curve: t.tokens.curveStandard,
      margin: widget.margin ?? cardTheme.margin,
      padding: padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: boxShadow,
      ),
      child: content,
    );

    final clip = widget.clipBehavior ?? cardTheme.clipBehavior;
    if (clip != null && clip != Clip.none) {
      card = ClipRRect(borderRadius: radius, clipBehavior: clip, child: card);
    }

    return widget.semanticContainer
        ? Semantics(container: true, child: card)
        : card;
  }

  List<BoxShadow> _boxShadow(SuperThemeData t, double? elevation) {
    if (elevation != null && elevation <= 0) return const [];
    final shadowColor = widget.shadowColor;
    if (shadowColor == null) return t.cardShadow;

    final level = elevation ?? 1.0;
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: (level * 0.06).clamp(0.0, 1.0)),
        blurRadius: level * 8,
        offset: Offset(0, level * 2),
      ),
    ];
  }
}

class _SuperSectionCardTitle extends StatelessWidget {
  const _SuperSectionCardTitle({
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
  });

  final String title;
  final String? titleArabic;
  final String? subtitle;
  final String? eyebrow;
  final SuperMarker marker;
  final Color? markerColor;
  final Color? accentColor;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final tokens = t.tokens;
    final s = t.spacing;
    final th = SuperSectionHeaderThemeData.of(context);
    final effectiveMarker = th.defaultMarker ?? marker;
    final accent =
        markerColor ?? accentColor ?? tokens.markerColor(effectiveMarker);
    final hasEyebrow = eyebrow != null && eyebrow!.isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    final hasArabic = titleArabic != null && titleArabic!.isNotEmpty;
    final titleRailHeight = hasEyebrow || hasSubtitle ? 40.0 : 24.0;
    final markerWidth = th.markerWidth ?? 4;
    final markerRadius = th.markerRadius ?? 2;
    final gap = th.gap ?? s.space3;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null)
          _SuperSectionCardTitleSlot(
            height: titleRailHeight,
            accent: accent,
            child: Icon(icon, size: th.iconSize ?? 14, color: accent),
          ),
        if (leading != null)
          _SuperSectionCardTitleSlot(
            height: titleRailHeight,
            accent: accent,
            decorated: false,
            child: leading!,
          ),
        Container(
          width: markerWidth,
          height: titleRailHeight,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(markerRadius),
          ),
        ),
        SizedBox(width: gap),
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
                      t.textTheme.labelSm.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: s.space1),
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
                          t.textTheme.titleMd.copyWith(color: t.fg1),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasArabic) ...[
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
                Tooltip(
                  message: subtitle!,
                  child: Text(
                    subtitle!.toUpperCase(),
                    style:
                        th.subtitleStyle ??
                        t.textTheme.labelSm.copyWith(
                          color: t.fg3,
                          letterSpacing: 0,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[SizedBox(width: gap), trailing!],
      ],
    );
  }
}

class _SuperSectionCardTitleSlot extends StatelessWidget {
  const _SuperSectionCardTitleSlot({
    required this.height,
    required this.accent,
    required this.child,
    this.decorated = true,
  });

  final double height;
  final Color accent;
  final Widget child;
  final bool decorated;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;

    return Container(
      width: 24,
      height: height,
      alignment: Alignment.center,
      decoration: decorated
          ? BoxDecoration(
              color: t.tint(accent, 0.12),
              borderRadius: const BorderRadiusDirectional.horizontal(
                start: Radius.circular(2),
              ),
            )
          : null,
      child: IconTheme.merge(
        data: IconThemeData(color: accent, size: 14),
        child: child,
      ),
    );
  }
}
