// ============================================================
// core/widgets/super_grid_tile.dart
// ------------------------------------------------------------
// SuperGridTile — the GeniusLink grid / dashboard card. A refactor of Flutter's
// GridTile baseline (header · child · footer) rebuilt on GeniusLink tokens and
// enhanced for ERP dashboards and catalog layouts: selection, hover/press/focus
// states, status badges + overlays, configurable media/content layouts,
// action overlays, loading/placeholder states, responsive sizing, RTL and
// keyboard activation.
//
// API compatibility: GridTile's core slots (header / child / footer) map to
// [header], [child], [footer]. The tile owns the card surface, so drop it
// straight into a GridView / Wrap.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_text_styles.dart';
import '../theme/super_tokens.dart';
import 'super_tile_common.dart';

/// A GeniusLink grid / dashboard card.
///
/// ```dart
/// SuperGridTile(
///   marker: SuperMarker.ledger,
///   header: const Text('TOTAL BALANCE'),
///   badge: const StatusPill('LIVE', tone: PillTone.success),
///   footer: const Text('Updated 2m ago'),
///   selected: isSelected,
///   onTap: open,
///   child: const Text('\$248,200.00'),
/// );
/// ```
class SuperGridTile extends StatefulWidget {
  const SuperGridTile({
    super.key,
    // Content
    this.child,
    this.header,
    this.footer,
    this.media,
    this.badge,
    this.marker,
    this.overlay,
    this.actions,
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
    this.loading = false,
    this.aspectRatio,
    this.mediaHeight,
    this.background,
    this.borderRadius,
    this.padding,
    this.revealActionsOnHover = true,
    this.semanticLabel,
  });

  // ── Content ──────────────────────────────────────────────────────────────

  /// The main body of the card (value, chart, description).
  final Widget? child;

  /// A header row above the body (label / title). ALL-CAPS label styling is
  /// applied to bare text.
  final Widget? header;

  /// A footer row below the body (meta, timestamp, delta).
  final Widget? footer;

  /// Media banner shown at the top of the card (image / thumbnail / chart),
  /// sized by [mediaHeight]. Clipped to the card radius.
  final Widget? media;

  /// A status badge / pill pinned to the top trailing corner.
  final Widget? badge;

  /// Optional section marker bar at the leading edge of the header.
  final SuperMarker? marker;

  /// A full-card overlay (e.g. a scrim or "SELECTED" veil) above the content.
  final Widget? overlay;

  /// Action affordances shown over the [media] / card (revealed on hover when
  /// [revealActionsOnHover]).
  final List<Widget>? actions;

  // ── Interaction ────────────────────────────────────────────────────────────

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;

  /// Builds a context menu shown on right-click / long-press.
  final List<PopupMenuEntry<Object?>> Function(BuildContext context)?
      contextMenuBuilder;

  final bool selected;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;

  // ── Presentation ───────────────────────────────────────────────────────────

  final SuperTileDensity density;

  /// Shows a shimmer skeleton instead of the content.
  final bool loading;

  /// Constrains the card to an aspect ratio (useful in a `Wrap`; a GridView
  /// already imposes one via `childAspectRatio`).
  final double? aspectRatio;

  /// Height of the [media] banner.
  final double? mediaHeight;

  /// Overrides the card background.
  final Color? background;

  /// Overrides the corner radius (defaults to the card radius).
  final BorderRadius? borderRadius;

  /// Overrides the interior padding (else derived from density).
  final EdgeInsetsGeometry? padding;

  /// Fade the [actions] in on hover instead of always showing them.
  final bool revealActionsOnHover;

  /// Accessibility label.
  final String? semanticLabel;

  bool get _interactive =>
      enabled && !loading && (onTap != null || onLongPress != null);

  @override
  State<SuperGridTile> createState() => _SuperGridTileState();
}

class _SuperGridTileState extends State<SuperGridTile> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;
  Offset _tapDown = Offset.zero;

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
    final m = SuperTileMetrics.of(widget.density, k);
    final disabled = !widget.enabled;
    final vs = SuperTileVisualState(
      hovered: _hovered,
      focused: _focused,
      pressed: _pressed,
      selected: widget.selected,
      disabled: disabled,
    );
    final radius = widget.borderRadius ?? BorderRadius.circular(k.radiusCard);
    final fill = widget.selected
        ? superTileFill(t, vs, base: widget.background)
        : (widget.background ?? t.surface);
    final border = superTileBorder(t, vs, bordered: true)!;
    final lifted = (_hovered || _pressed) && widget._interactive;

    final Widget content = widget.loading
        ? _buildSkeleton(context, m)
        : _buildContent(context, m, radius);

    Widget card = AnimatedContainer(
      duration: k.durBase,
      curve: k.curveStandard,
      transform: lifted
          ? (Matrix4.identity()..translate(0.0, -2.0))
          : Matrix4.identity(),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        border: border,
        boxShadow: lifted ? t.cardShadow : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    if (widget.aspectRatio != null) {
      card = AspectRatio(aspectRatio: widget.aspectRatio!, child: card);
    }

    final Widget tile = FocusableActionDetector(
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
        child: card,
      ),
    );

    return Semantics(
      container: true,
      enabled: widget.enabled,
      selected: widget.selected,
      button: widget._interactive,
      label: widget.semanticLabel,
      child: AnimatedOpacity(
        duration: k.durBase,
        opacity: disabled ? 0.4 : 1,
        child: tile,
      ),
    );
  }

  // ── Content assembly ───────────────────────────────────────────────────────

  Widget _buildContent(
      BuildContext context, SuperTileMetrics m, BorderRadius radius) {
    final k = context.superTheme.tokens;
    final pad = widget.padding ?? EdgeInsets.all(m.paddingH);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.header != null || widget.marker != null) ...[
          _buildHeader(context),
          SizedBox(height: k.space3),
        ],
        if (widget.child != null) Flexible(child: widget.child!),
        if (widget.footer != null) ...[
          SizedBox(height: k.space3),
          _buildFooter(context),
        ],
      ],
    );

    final stack = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.media != null)
          _buildMedia(context)
        else
          const SizedBox.shrink(),
        Padding(padding: pad, child: body),
      ],
    );

    // Overlays: badge (top-trailing), action overlay, custom overlay.
    return Stack(
      children: [
        Positioned.fill(child: stack),
        if (widget.badge != null)
          PositionedDirectional(
            top: k.space3,
            end: k.space3,
            child: widget.badge!,
          ),
        if (widget.actions != null && widget.actions!.isNotEmpty)
          Positioned.fill(child: _buildActions(context)),
        if (widget.overlay != null) Positioned.fill(child: widget.overlay!),
      ],
    );
  }

  Widget _buildMedia(BuildContext context) {
    return SizedBox(
      height: widget.mediaHeight ?? 120,
      width: double.infinity,
      child: widget.media,
    );
  }

  Widget _buildHeader(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    final header = widget.header == null
        ? null
        : DefaultTextStyle.merge(
            style: SuperText.label.copyWith(color: t.fg3),
            child: widget.header!,
          );
    if (widget.marker == null) return header ?? const SizedBox.shrink();
    return Row(
      children: [
        SuperTileMarker(marker: widget.marker!, height: 16),
        SizedBox(width: k.space3),
        if (header != null) Expanded(child: header),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final t = context.superTheme;
    return DefaultTextStyle.merge(
      style: SuperText.caption.copyWith(color: t.fg3),
      child: widget.footer!,
    );
  }

  Widget _buildActions(BuildContext context) {
    final k = context.superTheme.tokens;
    final show = !widget.revealActionsOnHover || _hovered || _focused;
    return IgnorePointer(
      ignoring: !show,
      child: AnimatedOpacity(
        duration: k.durBase,
        opacity: show ? 1 : 0,
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
            padding: EdgeInsets.all(k.space3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < widget.actions!.length; i++) ...[
                  if (i > 0) SizedBox(width: k.space2),
                  widget.actions![i],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context, SuperTileMetrics m) {
    final k = context.superTheme.tokens;
    final pad = widget.padding ?? EdgeInsets.all(m.paddingH);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.mediaHeight != null || widget.media != null)
          SuperTileShimmer(height: widget.mediaHeight ?? 120, radius: 0),
        Padding(
          padding: pad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SuperTileShimmer(width: 90, height: 10),
              SizedBox(height: k.space3),
              const SuperTileShimmer(width: 140, height: 20),
              SizedBox(height: k.space3),
              const SuperTileShimmer(width: 70, height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
