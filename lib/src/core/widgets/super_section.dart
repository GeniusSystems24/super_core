// ============================================================
// core/widgets/super_section.dart
// ------------------------------------------------------------
// SuperSection — a section-card shell that OPTIONALLY composes a
// [SuperSectionHeader] at the top and a [SuperSectionFooter] at the bottom,
// with the body in between. Pass a single [child] or a spaced [children] list;
// pass a prebuilt [header]/[footer] or the convenience fields and the section
// builds them for you.
//
// v2.1.0 enhancements:
//   • [collapsible] — the header toggles the body open/closed with the brand's
//     200ms ease-out animation; a chevron is appended to the header trailing.
//   • [children] + [gap] — vertical child list with automatic spacing.
//   • [onTap] / [selected] — make the whole card an interactive, selectable
//     surface (accent border + tint when selected).
//   • [dividerAfterHeader] — a hairline between header and body.
//   • [markerColor] — override the section-marker accent for a custom intent.
//   • [card] = false for a borderless variant; [background] to override surface.
//
// Everything resolves from the ambient [SuperThemeData].
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_color_utils.dart';
import '../theme/super_section_theme.dart';
import '../theme/super_tokens.dart';
import 'hairline.dart';
import 'super_section_footer.dart';
import 'super_section_header.dart';

/// A section card with an optional header, optional footer, optional collapse.
class SuperSection extends StatefulWidget {
  const SuperSection({
    super.key,
    this.child,
    this.children,
    // Header — pass [header] OR the convenience fields.
    this.header,
    this.title,
    this.titleArabic,
    this.subtitle,
    this.eyebrow,
    this.marker = SuperMarker.identity,
    this.markerColor,
    this.leading,
    this.headerTrailing,
    this.headerStyle = SuperSectionHeaderStyle.style1,
    // Footer — pass [footer] OR [footerBrand] (+ [footerActions]).
    this.footer,
    this.footerBrand,
    this.footerActions = const [],
    // Behaviour.
    this.collapsible = false,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
    this.onTap,
    this.selected = false,
    this.dividerAfterHeader,
    // Shell.
    this.card,
    this.background,
    this.gap,
    this.padding,
  })  : assert(child == null || children == null,
            'Provide either child or children, not both.'),
        assert(header == null || title == null,
            'Provide either a prebuilt header or the convenience fields.');

  /// The section body (single). Mutually exclusive with [children].
  final Widget? child;

  /// The section body as a spaced list. Mutually exclusive with [child].
  final List<Widget>? children;

  /// A prebuilt header. If null and [title] is set, one is built for you.
  final Widget? header;
  final String? title;
  final String? titleArabic;
  final String? subtitle;
  final String? eyebrow;
  final SuperMarker marker;

  /// Overrides the marker/accent color derived from [marker].
  final Color? markerColor;
  final Widget? leading;
  final Widget? headerTrailing;
  final SuperSectionHeaderStyle headerStyle;

  /// A prebuilt footer. If null and [footerBrand] is set, one is built for you.
  final Widget? footer;
  final String? footerBrand;
  final List<Widget> footerActions;

  /// When true the header toggles the body open/closed.
  final bool collapsible;

  /// Initial open state when [collapsible].
  final bool initiallyExpanded;

  /// Called with the new open state whenever the section toggles.
  final ValueChanged<bool>? onExpansionChanged;

  /// Makes the whole card tappable (independent of [collapsible]).
  final VoidCallback? onTap;

  /// Selected state — accent border + subtle tint.
  final bool selected;

  /// Draws a hairline between the header and the body. Falls back to the theme
  /// (default false).
  final bool? dividerAfterHeader;

  /// Whether to wrap in the card surface (border + shadow). Falls back to the
  /// theme (default true). False = plain.
  final bool? card;

  /// Overrides the card background (defaults to the theme surface).
  final Color? background;

  /// Spacing between [children]. Defaults to `space4`.
  final double? gap;

  /// Interior padding. Defaults to the responsive card padding.
  final EdgeInsetsGeometry? padding;

  @override
  State<SuperSection> createState() => _SuperSectionState();
}

class _SuperSectionState extends State<SuperSection>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() {
    setState(() => _expanded = !_expanded);
    widget.onExpansionChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final th = SuperSectionThemeData.of(context);
    final accent = widget.markerColor ?? k.markerColor(widget.marker);
    final showBody = !widget.collapsible || _expanded;
    final useCard = widget.card ?? th.card ?? true;
    final dividerAfterHeader =
        widget.dividerAfterHeader ?? th.dividerAfterHeader ?? false;
    final expandDuration = th.expandDuration ?? k.durExpand;
    final expandCurve = th.expandCurve ?? k.curveOut;
    final headerGap = th.headerGap ?? k.space8;
    final footerGap = th.footerGap ?? k.space6;

    // ── Header ──────────────────────────────────────────────────────────────
    Widget? resolvedHeader = widget.header;
    if (resolvedHeader == null && widget.title != null) {
      // When collapsible, append an animated chevron to the header trailing.
      Widget? trailing = widget.headerTrailing;
      if (widget.collapsible) {
        final chevron = AnimatedRotation(
          turns: _expanded ? 0 : -0.25,
          duration: expandDuration,
          curve: expandCurve,
          child: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: t.fg3),
        );
        trailing = trailing == null
            ? chevron
            : Row(mainAxisSize: MainAxisSize.min, children: [
                trailing,
                SizedBox(width: k.space2),
                chevron,
              ]);
      }
      resolvedHeader = SuperSectionHeader(
        title: widget.title!,
        titleArabic: widget.titleArabic,
        subtitle: widget.subtitle,
        eyebrow: widget.eyebrow,
        marker: widget.marker,
        leading: widget.leading,
        trailing: trailing,
        style: widget.headerStyle,
      );
    }
    if (resolvedHeader != null && (widget.collapsible || widget.onTap != null)) {
      resolvedHeader = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.collapsible ? _toggle : widget.onTap,
        child: resolvedHeader,
      );
    }

    // ── Footer ──────────────────────────────────────────────────────────────
    final resolvedFooter = widget.footer ??
        (widget.footerBrand != null
            ? SuperSectionFooter(
                brand: widget.footerBrand!, actions: widget.footerActions)
            : null);

    // ── Body ────────────────────────────────────────────────────────────────
    final gap = widget.gap ?? th.gap ?? k.space4;
    Widget? body;
    if (widget.children != null) {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.children!.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            widget.children![i],
          ],
        ],
      );
    } else {
      body = widget.child;
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (resolvedHeader != null) resolvedHeader,
        AnimatedCrossFade(
          firstCurve: expandCurve,
          secondCurve: expandCurve,
          sizeCurve: expandCurve,
          duration: expandDuration,
          crossFadeState:
              showBody ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (resolvedHeader != null) ...[
                if (dividerAfterHeader) ...[
                  SizedBox(height: k.space4),
                  const Hairline(),
                  SizedBox(height: k.space4),
                ] else
                  SizedBox(height: headerGap),
              ],
              if (body != null) body,
              if (resolvedFooter != null) ...[
                SizedBox(height: footerGap),
                resolvedFooter,
              ],
            ],
          ),
          secondChild: const SizedBox(width: double.infinity),
        ),
      ],
    );

    if (!useCard) {
      return Padding(padding: widget.padding ?? EdgeInsets.zero, child: content);
    }

    final surface = widget.background ?? th.background ?? t.surface;
    final selBorder = widget.markerColor ??
        th.selectedBorderColor ??
        accent;
    final bg = widget.selected
        ? selBorder.tintOver(surface, th.selectedTintOpacity ?? 0.08)
        : surface;
    final borderColor =
        widget.selected ? selBorder : (th.borderColor ?? t.border);
    final radius = th.radius ?? k.radiusCard;

    final container = AnimatedContainer(
      duration: k.durBase,
      curve: k.curveStandard,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
            color: borderColor, width: widget.selected ? 1.5 : 1),
        boxShadow: t.cardShadow,
      ),
      padding: widget.padding ??
          th.padding ??
          EdgeInsets.fromLTRB(k.space6, k.space6, k.space6,
              resolvedFooter != null || (widget.collapsible && !showBody)
                  ? k.space6
                  : k.space10),
      child: content,
    );

    if (widget.onTap != null && !widget.collapsible) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: container,
      );
    }
    return container;
  }
}
