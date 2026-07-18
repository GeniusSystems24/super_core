// ============================================================
// core/widgets/super_card.dart
// ------------------------------------------------------------
// The general-purpose GeniusLink card: an 8px-radius surface panel with a
// hairline border and the theme's card shadow. Distinct from [SectionCard]
// (the form-section unit with its tall bottom padding): SuperCard is a lean,
// composable container that can be made interactive (hover + tap), can carry
// the selected treatment for the active card/row in a list, can host [leading]
// / [trailing] slots, and can EXPAND to reveal [expandedChild] along either the
// vertical or the horizontal axis.
//
//   SuperCard(
//     leading: const Icon(Icons.storefront_outlined),
//     header: const SectionHeader(title: 'Downtown Central Store'),
//     child: const StoreSummary(),
//     expandedChild: const StoreDetailTable(),   // revealed on tap / chevron
//   );
//
// Defaults (expand direction, animation, tap-to-toggle, chevron affordance,
// interior padding, border colors) come from the ambient [SuperCardTheme],
// which `SuperMaterialThemeData` installs into `ThemeData.cardTheme`.
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_card_theme.dart';

/// A surface card — the general container primitive of the design system.
///
/// Supply a [child] body and, optionally: a [header] above it, [leading] /
/// [trailing] slots beside it, and an [expandedChild] revealed when the card
/// expands. Pass [onTap] to make a non-expandable card interactive, and
/// [selected] to draw the active-item treatment.
class SuperCard extends StatefulWidget {
  const SuperCard({
    super.key,
    required this.child,
    this.header,
    this.leading,
    this.trailing,
    this.expandedChild,
    this.expandDirection,
    this.initiallyExpanded = false,
    this.isExpanded,
    this.onExpansionChanged,
    this.toggleOnTap,
    this.showExpandIcon,
    this.padding,
    this.margin,
    this.onTap,
    this.selected = false,
  });

  /// The card body.
  final Widget child;

  /// Optional header rendered above [child] (typically a [SectionHeader]).
  final Widget? header;

  /// Optional widget at the start of the card row (icon, avatar, marker…).
  final Widget? leading;

  /// Optional widget at the end of the card row. When the card is expandable
  /// and [showExpandIcon] is on, an animated chevron is appended after it.
  final Widget? trailing;

  /// Content revealed when the card is expanded. When null the card is not
  /// expandable and behaves as a plain (optionally tappable) surface.
  final Widget? expandedChild;

  /// The axis the reveal grows along. Defaults to the [SuperCardTheme] value
  /// ([Axis.vertical]).
  final Axis? expandDirection;

  /// Initial expansion state for the uncontrolled case. Ignored when
  /// [isExpanded] is non-null (controlled).
  final bool initiallyExpanded;

  /// Controlled expansion state. When non-null the card reflects this value and
  /// reports toggles through [onExpansionChanged] instead of self-managing.
  final bool? isExpanded;

  /// Called with the requested new expansion state when the user toggles.
  final ValueChanged<bool>? onExpansionChanged;

  /// Whether tapping the card body toggles expansion. Defaults to the
  /// [SuperCardTheme] value (`true`). Independent of the chevron, which always
  /// toggles.
  final bool? toggleOnTap;

  /// Whether to show the animated chevron affordance on an expandable card.
  /// Defaults to the [SuperCardTheme] value (`true`).
  final bool? showExpandIcon;

  /// Interior padding. Defaults to the [SuperCardTheme] padding (24px).
  final EdgeInsetsGeometry? padding;

  /// Optional exterior margin around the card.
  final EdgeInsetsGeometry? margin;

  /// When non-null on a non-expandable card, makes the card interactive
  /// (pointer cursor + hover border) and calls this on tap. On an expandable
  /// card it is still invoked on tap (in addition to toggling when
  /// [toggleOnTap] is on).
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
    // Controlled cards update via didUpdateWidget when the parent rebuilds.
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
    final gap = cardTheme.gap ?? k.space4;

    final interactive = expandable || widget.onTap != null;
    final borderColor = widget.selected
        ? (cardTheme.selectedBorderColor ?? cs.primary)
        : (_hover && interactive)
            ? t.borderStrong
            : (cardTheme.borderColor ?? t.border);
    final fill =
        widget.selected ? t.selectionFill(0.08) : (cardTheme.color ?? t.surface);

    final shape = cardTheme.shape;
    final radius = (shape is RoundedRectangleBorder &&
            shape.borderRadius is BorderRadius)
        ? shape.borderRadius as BorderRadius
        : BorderRadius.circular(k.radiusCard);
    final padding = widget.padding ?? cardTheme.padding ?? EdgeInsets.all(k.space6);

    // ── Header + body column ──
    final bodyColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.header != null) ...[
          widget.header!,
          SizedBox(height: gap),
        ],
        widget.child,
      ],
    );

    // ── Trailing area (trailing widget + optional chevron) ──
    Widget? trailingArea;
    final showChevron = expandable && showExpandIcon;
    if (widget.trailing != null || showChevron) {
      trailingArea = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.trailing != null) widget.trailing!,
          if (showChevron) ...[
            if (widget.trailing != null) SizedBox(width: k.space2),
            AnimatedRotation(
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
            ),
          ],
        ],
      );
    }

    // ── Primary row: leading | body | trailing ──
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.leading != null) ...[
          widget.leading!,
          SizedBox(width: gap),
        ],
        Expanded(child: bodyColumn),
        if (trailingArea != null) ...[
          SizedBox(width: gap),
          trailingArea,
        ],
      ],
    );

    // ── Reveal (expandedChild) along the chosen axis ──
    Widget content = row;
    if (expandable) {
      final vertical = direction == Axis.vertical;
      final revealed = ClipRect(
        child: AnimatedAlign(
          duration: duration,
          curve: curve,
          alignment: vertical ? Alignment.topLeft : Alignment.centerLeft,
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
              children: [row, revealed],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [Flexible(child: row), revealed],
            );
    }

    final card = AnimatedContainer(
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
        boxShadow: t.cardShadow,
      ),
      child: content,
    );

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
