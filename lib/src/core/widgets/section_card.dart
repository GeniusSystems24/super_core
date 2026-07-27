// ============================================================
// core/widgets/section_card.dart
// ------------------------------------------------------------
// The fundamental form-section layout unit: a card with the theme's
// `surfaceContainerLow` fill, no hairline border, and a single diffuse shadow.
// Optionally collapsible with an animated chevron. The header is a
// [SectionHeader] built from [title] / [subtitle] / [marker] / [accentColor] /
// [icon], or a fully custom [header] widget.
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_tokens.dart';
import 'section_header.dart';

/// A section card. Supply [child] and optionally a header via [title] +
/// [subtitle] + [marker] / [accentColor] / [icon], or a pre-built [header].
///
/// Set [collapsible] to allow the body to be toggled; [initiallyExpanded]
/// controls the starting state.
class SectionCard extends StatefulWidget {
  const SectionCard({
    super.key,
    this.header,
    this.title,
    this.subtitle,
    this.marker = SuperMarker.identity,
    this.accentColor,
    this.icon,
    this.headerTrailing,
    required this.child,
    this.padding,
    this.collapsible = false,
    this.initiallyExpanded = true,
  });

  /// A pre-built header. When null and [title] is set, a [SectionHeader] is
  /// constructed from [title] / [subtitle] / [marker] / [accentColor] / [icon].
  final Widget? header;
  final String? title;
  final String? subtitle;
  final SuperMarker marker;

  /// Explicit accent color for the marker bar and icon container. Takes
  /// precedence over [marker] when both are supplied.
  final Color? accentColor;

  /// Optional icon displayed in the marker area of the generated header.
  final IconData? icon;

  /// Trailing widget shown at the end of the generated header row.
  final Widget? headerTrailing;

  final Widget child;

  /// Interior padding. Defaults to the theme's responsive compact card inset
  /// (`SuperThemeData.padding.card`) when null.
  final EdgeInsetsGeometry? padding;

  /// Whether tapping the header row collapses / expands the body. When false
  /// the card is always expanded and no chevron is shown.
  final bool collapsible;

  /// Initial expansion state used when [collapsible] is true.
  final bool initiallyExpanded;

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final cs = Theme.of(context).colorScheme;

    final resolvedHeader = widget.header ??
        (widget.title != null
            ? SectionHeader(
                title: widget.title!,
                subtitle: widget.subtitle,
                marker: widget.marker,
                accentColor: widget.accentColor,
                icon: widget.icon,
                trailing: widget.headerTrailing,
              )
            : null);

    // Body content — animated when collapsible.
    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (resolvedHeader != null) SizedBox(height: t.spacing.xl),
        widget.child,
      ],
    );

    if (widget.collapsible) {
      body = ClipRect(
        child: AnimatedAlign(
          alignment: Alignment.topLeft,
          heightFactor: _expanded ? 1.0 : 0.0,
          duration: k.durExpand,
          curve: k.curveOut,
          child: body,
        ),
      );
    }

    Widget? headerSection;
    if (resolvedHeader != null) {
      if (widget.collapsible) {
        headerSection = GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Expanded(child: resolvedHeader),
              SizedBox(width: k.space2),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0.0,
                duration: k.durExpand,
                curve: k.curveOut,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: t.fg3,
                ),
              ),
            ],
          ),
        );
      } else {
        headerSection = resolvedHeader;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(k.radiusCard),
        boxShadow: t.cardShadow,
      ),
      padding: widget.padding ?? t.padding.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (headerSection != null) headerSection,
          body,
        ],
      ),
    );
  }
}
