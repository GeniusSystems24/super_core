// ============================================================
// core/widgets/super_card.dart
// ------------------------------------------------------------
// The general-purpose GeniusLink card: an 8px-radius surface panel with a
// hairline border and the theme's card shadow. Distinct from [SectionCard]
// (the form-section unit with its tall bottom padding): SuperCard is a lean,
// composable container that can be made interactive (hover + tap) and can carry
// the selected treatment for the active card/row in a list.
//
//   SuperCard(
//     header: const SectionHeader(title: 'Downtown Central Store'),
//     onTap: () => open(store),
//     selected: store == active,
//     child: const StoreSummary(),
//   );
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_tokens.dart';

/// A surface card — the general container primitive of the design system.
///
/// Supply a [child] body and, optionally, a [header] rendered above it. Pass an
/// [onTap] to make the card interactive (pointer cursor + hover border), and
/// [selected] to draw the active-item treatment.
class SuperCard extends StatefulWidget {
  const SuperCard({
    super.key,
    required this.child,
    this.header,
    this.padding = const EdgeInsets.all(SuperTokens.space6),
    this.margin,
    this.onTap,
    this.selected = false,
  });

  /// The card body.
  final Widget child;

  /// Optional header rendered above [child] (typically a [SectionHeader]),
  /// separated from the body by a 16px gap. Null hides the header row.
  final Widget? header;

  /// Interior padding. Defaults to 24px on every side — the GeniusLink card
  /// interior.
  final EdgeInsetsGeometry padding;

  /// Optional exterior margin around the card.
  final EdgeInsetsGeometry? margin;

  /// When non-null the card becomes interactive: it shows a pointer cursor,
  /// deepens its border to [SuperThemeData.borderStrong] on hover, and calls
  /// this callback on tap.
  final VoidCallback? onTap;

  /// Draws the selected treatment — a primary-colored border over a faint
  /// primary tint. Use for the active card/row in a list.
  final bool selected;

  @override
  State<SuperCard> createState() => _SuperCardState();
}

class _SuperCardState extends State<SuperCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final cs = Theme.of(context).colorScheme;
    final interactive = widget.onTap != null;

    final borderColor = widget.selected
        ? cs.primary
        : (_hover && interactive)
            ? t.borderStrong
            : t.border;
    final fill = widget.selected ? t.selectionFill(0.08) : t.surface;

    final card = AnimatedContainer(
      duration: SuperTokens.durBase,
      curve: SuperTokens.curveStandard,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(SuperTokens.radiusCard),
        border: Border.all(
          color: borderColor,
          width: widget.selected ? 1.5 : 1,
        ),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.header != null) ...[
            widget.header!,
            const SizedBox(height: SuperTokens.space4),
          ],
          widget.child,
        ],
      ),
    );

    if (!interactive) return card;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: card,
      ),
    );
  }
}
