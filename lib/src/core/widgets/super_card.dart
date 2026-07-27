// ============================================================
// core/widgets/super_card.dart
// ------------------------------------------------------------
// The general-purpose GeniusLink card — a surface panel with the theme's card
// shadow and no hairline border at rest. Distinct from [SectionCard] (the
// opinionated form-section unit): SuperCard is a lean, composable container
// that can be made interactive (hover border + tap), can carry the selected
// treatment for the active card/row in a list, and can EXPAND to reveal
// [expandedChild] along either the vertical or the horizontal axis.
//
// All standard Material [Card] widget properties are supported alongside the
// Super-specific expand / collapse behavior.
//
//   SuperCard(
//     header: const SectionHeader(title: 'Downtown Central Store'),
//     child: const StoreSummary(),
//     expandedChild: const StoreDetailTable(),
//   );
//
// Defaults come from the ambient [SuperCardTheme], which
// `SuperMaterialThemeData` installs into `ThemeData.cardTheme`.
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_card_theme.dart';

/// A surface card — the general container primitive of the design system.
///
/// Supports all standard [Card] properties plus Super-specific expand/collapse
/// and the selected-item treatment.
class SuperCard extends StatefulWidget {
  const SuperCard({
    super.key,
    required this.child,
    this.header,
    this.expandedChild,
    this.expandDirection,
    this.initiallyExpanded = false,
    this.isExpanded,
    this.onExpansionChanged,
    this.toggleOnTap,
    this.showExpandIcon,
    // Material Card properties
    this.color,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.clipBehavior,
    this.semanticContainer = true,
    // Additional Super properties
    this.padding,
    this.margin,
    this.onTap,
    this.selected = false,
  });

  /// The card body.
  final Widget child;

  /// Optional header rendered above [child] (typically a [SectionHeader]).
  final Widget? header;

  /// Content revealed when the card is expanded. When null the card is not
  /// expandable and behaves as a plain (optionally tappable) surface.
  final Widget? expandedChild;

  /// The axis the reveal grows along. Defaults to the [SuperCardTheme] value
  /// ([Axis.vertical]).
  final Axis? expandDirection;

  /// Initial expansion state for the uncontrolled case. Ignored when
  /// [isExpanded] is non-null (controlled).
  final bool initiallyExpanded;

  /// Controlled expansion state. When non-null the card reflects this value
  /// and reports toggles through [onExpansionChanged].
  final bool? isExpanded;

  /// Called with the requested new expansion state when the user toggles.
  final ValueChanged<bool>? onExpansionChanged;

  /// Whether tapping the card body toggles expansion. Defaults to the
  /// [SuperCardTheme] value (`true`).
  final bool? toggleOnTap;

  /// Whether to show the animated chevron affordance on an expandable card.
  /// Defaults to the [SuperCardTheme] value (`true`).
  final bool? showExpandIcon;

  // ── Material Card properties ──────────────────────────────────────────────

  /// Card fill color. Defaults to [SuperCardTheme.color] then
  /// `colorScheme.surfaceContainerLow`. The selected tint wins when
  /// [selected] is true.
  final Color? color;

  /// Shadow color. When set, a simple elevation-proportional shadow is built
  /// from this color instead of the theme's [SuperThemeData.cardShadow].
  final Color? shadowColor;

  /// Surface tint color blended over [color] at low opacity (Material 3
  /// elevation tinting). Defaults to [Colors.transparent] — tinting is off by
  /// default in the GeniusLink flat-surface spec.
  final Color? surfaceTintColor;

  /// Card elevation. `0` suppresses the shadow entirely; `null` defers to
  /// [SuperCardTheme.elevation] (with the theme shadow when > 0, no shadow
  /// when 0). Values > 0 with no explicit [shadowColor] use the theme shadow.
  final double? elevation;

  /// Overrides the card shape (border radius + optional border). Defaults to
  /// [SuperCardTheme.shape] (8px rounded rectangle, no border at rest).
  final ShapeBorder? shape;

  /// Whether the border is drawn in front of [child]. Accepted for API
  /// compatibility; the current implementation always draws the border as
  /// part of the container background.
  final bool borderOnForeground;

  /// How to clip the card's content. Defaults to [SuperCardTheme.clipBehavior].
  final Clip? clipBehavior;

  /// Whether the card is a semantic container. When true the subtree is
  /// wrapped in a [Semantics] node with `container: true`.
  final bool semanticContainer;

  // ── Super-only properties ─────────────────────────────────────────────────

  /// Interior padding. Defaults to [SuperCardTheme.padding].
  final EdgeInsetsGeometry? padding;

  /// Optional exterior margin around the card.
  final EdgeInsetsGeometry? margin;

  /// When non-null on a non-expandable card, makes the card interactive
  /// (pointer cursor + hover border) and calls this on tap. On an expandable
  /// card it is invoked on tap in addition to toggling when [toggleOnTap] is on.
  final VoidCallback? onTap;

  /// Draws the selected treatment — a primary-colored border over a faint
  /// primary tint. Use for the active card/row in a list.
  final bool selected;

  bool get isExpandable => expandedChild != null;

  @override
  State<SuperCard> createState() => _SuperCardState();
}

class _SuperCardState extends State<SuperCard> {
  bool _hover = false;
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.isExpanded ?? widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(SuperCard oldWidget) {
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
    final k = t.tokens;
    final cs = Theme.of(context).colorScheme;
    final cardTheme = SuperCardTheme.of(context);

    final expandable = widget.isExpandable;
    final direction =
        widget.expandDirection ?? cardTheme.expandDirection ?? Axis.vertical;
    final duration = cardTheme.expandDuration ?? k.durExpand;
    final curve = cardTheme.expandCurve ?? k.curveOut;
    final toggleOnTap = widget.toggleOnTap ?? cardTheme.toggleOnTap ?? true;
    final showExpandIcon =
        widget.showExpandIcon ?? cardTheme.showExpandIcon ?? true;
    final gap = cardTheme.gap ?? t.spacing.md;

    final interactive = expandable || widget.onTap != null;

    // Border: transparent at rest; subtle on hover; primary on selection.
    final borderColor = widget.selected
        ? (cardTheme.selectedBorderColor ?? cs.primary)
        : (_hover && interactive)
            ? (cardTheme.borderColor ?? t.border)
            : Colors.transparent;

    // Fill color.
    final baseFill =
        widget.color ?? cardTheme.color ?? cs.surfaceContainerLow;
    final tintedFill = (widget.surfaceTintColor != null &&
            widget.surfaceTintColor != Colors.transparent)
        ? Color.alphaBlend(
            widget.surfaceTintColor!.withValues(alpha: 0.08), baseFill)
        : baseFill;
    final fill = widget.selected ? t.selectionFill(0.08) : tintedFill;

    // Shape / radius.
    final resolvedShape = widget.shape ?? cardTheme.shape;
    final radius =
        (resolvedShape is RoundedRectangleBorder &&
            resolvedShape.borderRadius is BorderRadius)
        ? resolvedShape.borderRadius as BorderRadius
        : BorderRadius.circular(k.radiusCard);

    // Shadow.
    final eff = widget.elevation ?? cardTheme.elevation;
    final List<BoxShadow> boxShadow;
    if (eff != null && eff <= 0) {
      boxShadow = const [];
    } else if (widget.shadowColor != null) {
      final level = eff ?? 1.0;
      boxShadow = [
        BoxShadow(
          color: widget.shadowColor!.withValues(
            alpha: (level * 0.06).clamp(0.0, 1.0),
          ),
          blurRadius: level * 8,
          offset: Offset(0, level * 2),
        ),
      ];
    } else {
      boxShadow = t.cardShadow;
    }

    final padding = widget.padding ?? cardTheme.padding ?? t.padding.card;

    // Header row — includes animated chevron when expandable.
    Widget? headerWidget;
    if (widget.header != null || (expandable && showExpandIcon)) {
      Widget? chevron;
      if (expandable && showExpandIcon) {
        chevron = AnimatedRotation(
          duration: duration,
          curve: curve,
          turns: _expanded ? 0.5 : 0.0,
          child: Icon(
            direction == Axis.vertical
                ? Icons.expand_more
                : Icons.chevron_right,
            size: 20.0,
            color: t.fg3,
          ),
        );
      }

      if (widget.header != null && chevron != null) {
        headerWidget = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: widget.header!),
            SizedBox(width: gap),
            chevron,
          ],
        );
      } else if (widget.header != null) {
        headerWidget = widget.header;
      } else {
        headerWidget = Align(
          alignment: AlignmentDirectional.centerEnd,
          child: chevron,
        );
      }
    }

    // Main body column.
    final bodyColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (headerWidget != null) ...[headerWidget, SizedBox(height: gap)],
        widget.child,
      ],
    );

    // Reveal (expandedChild) along the chosen axis.
    Widget content = bodyColumn;
    if (expandable) {
      final vertical = direction == Axis.vertical;
      final revealed = ClipRect(
        child: AnimatedAlign(
          duration: duration,
          curve: curve,
          alignment:
              vertical ? Alignment.topLeft : Alignment.centerLeft,
          heightFactor: vertical ? (_expanded ? 1.0 : 0.0) : null,
          widthFactor: vertical ? null : (_expanded ? 1.0 : 0.0),
          child: Padding(
            padding: vertical
                ? EdgeInsets.only(top: gap)
                : EdgeInsets.only(left: gap),
            child: widget.expandedChild,
          ),
        ),
      );
      content = vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [bodyColumn, revealed],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [Flexible(child: bodyColumn), revealed],
            );
    }

    Widget card = AnimatedContainer(
      duration: k.durBase,
      curve: k.curveStandard,
      margin: widget.margin ?? cardTheme.margin,
      padding: padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        border: Border.all(
          color: borderColor,
          width: widget.selected ? 1.5 : 1,
        ),
        boxShadow: boxShadow,
      ),
      child: content,
    );

    // Clip content to card boundary when requested.
    final clip = widget.clipBehavior ?? cardTheme.clipBehavior;
    if (clip != null && clip != Clip.none) {
      card = ClipRRect(
        borderRadius: radius,
        clipBehavior: clip,
        child: card,
      );
    }

    // Semantic container wrapping.
    if (widget.semanticContainer) {
      card = Semantics(container: true, child: card);
    }

    if (!interactive) return card;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (expandable && toggleOnTap) _toggle();
          widget.onTap?.call();
        },
        child: card,
      ),
    );
  }
}
