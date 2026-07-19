// ============================================================
// core/widgets/super_list_tile.dart
// ------------------------------------------------------------
// SuperListTile — the GeniusLink list row. A refactor of Flutter's ListTile
// baseline (leading · title/subtitle · trailing) rebuilt on GeniusLink tokens
// and enhanced for ERP desktop / tablet / mobile: density presets, selection,
// hover/focus/press/disabled states, status badge, multiple leading/trailing
// widgets, supporting-info section, configurable separators, loading skeletons,
// section marker, RTL, keyboard activation and context-menu support.
//
// API compatibility: the common ListTile surface (leading, title, subtitle,
// trailing, onTap, onLongPress, selected, enabled, dense, contentPadding) is
// preserved so existing call sites port with minimal change.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_text_styles.dart';
import '../theme/super_tokens.dart';
import 'super_tile_common.dart';

/// How the title / subtitle stack aligns against tall leading/trailing content.
enum SuperListTileAlignment {
  /// Center the body vertically (default for single-line rows).
  center,

  /// Pin the body to the top (multi-line supporting text).
  top,
}

/// A GeniusLink list row. Provide any subset of [leading], [title], [subtitle],
/// [supporting], [trailing]; the tile lays them out with the design system's
/// density, spacing, type and interaction states.
///
/// ```dart
/// SuperListTile(
///   marker: SuperMarker.ledger,
///   leadingIcon: Icons.storefront_outlined,
///   title: const Text('Downtown Central Store'),
///   subtitle: const Text('STR-0042 • Riyadh'),
///   badge: const StatusPill('ACTIVE', tone: PillTone.success),
///   trailingActions: [SuperIconButton(icon: Icons.edit_outlined, onPressed: edit)],
///   selected: isSelected,
///   onTap: open,
/// );
/// ```
class SuperListTile extends StatefulWidget {
  const SuperListTile({
    super.key,
    // Content
    this.leading,
    this.leadingIcon,
    this.leadingWidgets,
    this.title,
    this.titleText,
    this.subtitle,
    this.supporting,
    this.trailing,
    this.trailingActions,
    this.badge,
    this.marker,
    // Interaction
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.contextMenuBuilder,
    this.selected = false,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    // Presentation
    this.density = SuperTileDensity.comfortable,
    this.dense = false,
    this.alignment = SuperListTileAlignment.center,
    this.showSeparator = false,
    this.loading = false,
    this.bordered = false,
    this.background,
    this.contentPadding,
    this.borderRadius,
    this.semanticLabel,
  }) : assert(title == null || titleText == null,
            'Provide either title or titleText, not both.');

  // ── Content ────────────────────────────────────────────────────────────────

  /// Custom leading widget (avatar / icon / image / thumbnail).
  final Widget? leading;

  /// Convenience: renders a GeniusLink-tinted icon as the leading widget.
  final IconData? leadingIcon;

  /// Multiple stacked leading widgets (e.g. a checkbox + avatar).
  final List<Widget>? leadingWidgets;

  /// Primary line. Prefer [titleText] for plain strings.
  final Widget? title;

  /// Convenience plain-text title (rendered in the GeniusLink body style).
  final String? titleText;

  /// Secondary line beneath the title (subtitle / hint / serial).
  final Widget? subtitle;

  /// Extra supporting block below the subtitle (multi-line notes, meta rows).
  final Widget? supporting;

  /// Custom trailing widget (value, chevron, switch).
  final Widget? trailing;

  /// A row of trailing action affordances (icon buttons, menus).
  final List<Widget>? trailingActions;

  /// A status badge / pill shown at the trailing end of the title line.
  final Widget? badge;

  /// Optional section marker bar at the leading edge (identity/ledger/notes).
  final SuperMarker? marker;

  // ── Interaction ──────────────────────────────────────────────────────────

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Secondary (right-click) tap — ignored when [contextMenuBuilder] is set.
  final VoidCallback? onSecondaryTap;

  /// Builds a context menu shown on right-click / long-press. Receives the
  /// global tap position.
  final List<PopupMenuEntry<Object?>> Function(BuildContext context)?
      contextMenuBuilder;

  /// Selected state — accent tint + border.
  final bool selected;

  /// When false the tile is dimmed and non-interactive.
  final bool enabled;

  final FocusNode? focusNode;
  final bool autofocus;

  // ── Presentation ───────────────────────────────────────────────────────────

  /// Density preset. [dense] is a back-compat alias that maps to
  /// [SuperTileDensity.compact].
  final SuperTileDensity density;

  /// Back-compat alias for [SuperTileDensity.compact].
  final bool dense;

  /// Vertical alignment of the body against tall leading/trailing content.
  final SuperListTileAlignment alignment;

  /// Draws a hairline separator beneath the row (for borderless lists).
  final bool showSeparator;

  /// Shows a shimmer skeleton instead of the content.
  final bool loading;

  /// Wraps the row in a card-style hairline border.
  final bool bordered;

  /// Overrides the row background.
  final Color? background;

  /// Overrides the interior padding (else derived from density).
  final EdgeInsetsGeometry? contentPadding;

  /// Overrides the corner radius (defaults to the control radius).
  final BorderRadius? borderRadius;

  /// Accessibility label (falls back to [titleText]).
  final String? semanticLabel;

  bool get _interactive =>
      enabled && !loading && (onTap != null || onLongPress != null);

  @override
  State<SuperListTile> createState() => _SuperListTileState();
}

class _SuperListTileState extends State<SuperListTile> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;
  Offset _tapDown = Offset.zero;

  SuperTileDensity get _density =>
      widget.dense ? SuperTileDensity.compact : widget.density;

  Future<void> _openContextMenu(BuildContext context, Offset globalPos) async {
    final entries = widget.contextMenuBuilder?.call(context);
    if (entries == null || entries.isEmpty) return;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) return;
    await showMenu<Object?>(
      context: context,
      position: RelativeRect.fromRect(
        globalPos & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: entries,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final m = SuperTileMetrics.of(_density, k);
    final disabled = !widget.enabled;
    final vs = SuperTileVisualState(
      hovered: _hovered,
      focused: _focused,
      pressed: _pressed,
      selected: widget.selected,
      disabled: disabled,
    );
    final radius = widget.borderRadius ??
        BorderRadius.circular(widget.bordered ? k.radiusCard : k.radiusControl);
    final fill = superTileFill(t, vs, base: widget.background);
    final border = superTileBorder(t, vs, bordered: widget.bordered);

    Widget content = widget.loading
        ? _buildSkeleton(context, m)
        : _buildContent(context, m);

    content = AnimatedContainer(
      duration: k.durBase,
      curve: k.curveStandard,
      constraints: BoxConstraints(minHeight: m.minHeight),
      padding: widget.contentPadding ??
          EdgeInsets.symmetric(horizontal: m.paddingH, vertical: m.paddingV),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        border: border,
      ),
      child: content,
    );

    // Focus + keyboard activation.
    Widget tile = FocusableActionDetector(
      enabled: widget._interactive,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      mouseCursor: widget._interactive
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget._interactive ? widget.onTap : null,
        onLongPress: !widget.enabled || widget.loading
            ? null
            : (widget.contextMenuBuilder != null
                ? () => _openContextMenu(context, _tapDown)
                : widget.onLongPress),
        onTapDown: (d) {
          _tapDown = d.globalPosition;
          if (widget._interactive) setState(() => _pressed = true);
        },
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onSecondaryTapDown: (d) => _tapDown = d.globalPosition,
        onSecondaryTap: !widget.enabled || widget.loading
            ? null
            : (widget.contextMenuBuilder != null
                ? () => _openContextMenu(context, _tapDown)
                : widget.onSecondaryTap),
        child: content,
      ),
    );

    if (widget.showSeparator) {
      tile = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          tile,
          Container(height: 1, color: t.border),
        ],
      );
    }

    return Semantics(
      container: true,
      enabled: widget.enabled,
      selected: widget.selected,
      button: widget._interactive,
      label: widget.semanticLabel ?? widget.titleText,
      child: AnimatedOpacity(
        duration: k.durBase,
        opacity: disabled ? 0.4 : 1,
        child: tile,
      ),
    );
  }

  // ── Content assembly ───────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, SuperTileMetrics m) {
    final t = context.superTheme;
    final k = t.tokens;
    final crossAxis = widget.alignment == SuperListTileAlignment.top
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;

    final leading = _buildLeading(context, m);
    final body = _buildBody(context);
    final trailing = _buildTrailing(context, m);

    return Row(
      crossAxisAlignment: crossAxis,
      children: [
        if (widget.marker != null) ...[
          SuperTileMarker(
            marker: widget.marker!,
            height: m.minHeight - m.paddingV * 2,
          ),
          SizedBox(width: k.space3),
        ],
        if (leading != null) ...[leading, SizedBox(width: m.gap)],
        Expanded(child: body),
        if (trailing != null) ...[SizedBox(width: m.gap), trailing],
      ],
    );
  }

  Widget? _buildLeading(BuildContext context, SuperTileMetrics m) {
    final t = context.superTheme;
    final k = t.tokens;
    if (widget.leadingWidgets != null && widget.leadingWidgets!.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.leadingWidgets!.length; i++) ...[
            if (i > 0) SizedBox(width: k.space2),
            widget.leadingWidgets![i],
          ],
        ],
      );
    }
    if (widget.leading != null) return widget.leading;
    if (widget.leadingIcon != null) {
      final accent =
          widget.marker != null ? k.markerColor(widget.marker!) : k.accent;
      final size = _density == SuperTileDensity.compact ? 32.0 : 38.0;
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: t.tint(accent, 0.12),
          borderRadius: BorderRadius.circular(k.radiusControl + 2),
        ),
        child: Icon(widget.leadingIcon, size: size * 0.5, color: accent),
      );
    }
    return null;
  }

  Widget _buildBody(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final titleWidget = widget.title ??
        (widget.titleText != null
            ? Text(
                widget.titleText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: SuperText.body.copyWith(
                    color: t.fg1, fontWeight: FontWeight.w600),
              )
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (titleWidget != null)
          Row(
            children: [
              Flexible(
                child: DefaultTextStyle.merge(
                  style: SuperText.body.copyWith(color: t.fg1),
                  child: titleWidget,
                ),
              ),
              if (widget.badge != null) ...[
                SizedBox(width: k.space2),
                widget.badge!,
              ],
            ],
          ),
        if (widget.subtitle != null) ...[
          SizedBox(height: k.space1),
          DefaultTextStyle.merge(
            style: SuperText.caption.copyWith(color: t.fg3),
            child: widget.subtitle!,
          ),
        ],
        if (widget.supporting != null) ...[
          SizedBox(height: k.space2),
          DefaultTextStyle.merge(
            style: SuperText.caption.copyWith(color: t.fg3),
            child: widget.supporting!,
          ),
        ],
      ],
    );
  }

  Widget? _buildTrailing(BuildContext context, SuperTileMetrics m) {
    final k = context.superTheme.tokens;
    if (widget.trailingActions != null &&
        widget.trailingActions!.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.trailingActions!.length; i++) ...[
            if (i > 0) SizedBox(width: k.space1),
            widget.trailingActions![i],
          ],
        ],
      );
    }
    if (widget.trailing != null) {
      final t = context.superTheme;
      return DefaultTextStyle.merge(
        style: SuperText.mono.copyWith(color: t.fg2),
        child: IconTheme.merge(
          data: IconThemeData(color: t.fg3, size: 20),
          child: widget.trailing!,
        ),
      );
    }
    return null;
  }

  Widget _buildSkeleton(BuildContext context, SuperTileMetrics m) {
    final k = context.superTheme.tokens;
    final size = _density == SuperTileDensity.compact ? 32.0 : 38.0;
    return Row(
      children: [
        SuperTileShimmer(width: size, height: size, radius: k.radiusControl + 2),
        SizedBox(width: m.gap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SuperTileShimmer(width: 180, height: 12),
              SizedBox(height: k.space2),
              const SuperTileShimmer(width: 110, height: 10),
            ],
          ),
        ),
        SizedBox(width: m.gap),
        const SuperTileShimmer(width: 48, height: 12),
      ],
    );
  }
}
