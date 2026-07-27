// ============================================================
// core/widgets/super_tile_common.dart
// ------------------------------------------------------------
// Shared internals for the GeniusLink tile family (SuperListTile / SuperGridTile).
// Keeps density presets, interaction-state resolution, and the hover/focus/press
// surface in ONE place so both tiles behave identically (DRY + SOLID: a single
// responsibility owns "how a GeniusLink tile reacts to the pointer/keyboard").
// ============================================================

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_spacing.dart';
import '../theme/super_theme.dart';
import '../theme/super_tokens.dart';

/// Density presets shared by the tile family. Drives interior padding, the
/// minimum row height and the leading/gap rhythm so dense ERP data-entry
/// screens and roomy dashboards read from the same scale.
enum SuperTileDensity {
  /// Tightest — audit tables, pickers, dense lists.
  compact,

  /// Default — most list / grid screens.
  comfortable,

  /// Roomy — hero rows, settings, detail summaries.
  expanded,
}

/// Resolved density metrics for a tile.
@immutable
class SuperTileMetrics {
  const SuperTileMetrics({
    required this.minHeight,
    required this.paddingV,
    required this.paddingH,
    required this.gap,
  });

  /// Minimum content height (list tile) — grid tiles ignore this.
  final double minHeight;

  /// Vertical interior padding.
  final double paddingV;

  /// Horizontal interior padding.
  final double paddingH;

  /// Gap between leading / body / trailing clusters.
  final double gap;

  /// Resolves the metrics for [density] against the ambient [spacing].
  factory SuperTileMetrics.of(SuperTileDensity density, SuperSpacing s) {
    return switch (density) {
      SuperTileDensity.compact => SuperTileMetrics(
        minHeight: 36,
        paddingV: s.space1,
        paddingH: s.space3,
        gap: s.space2,
      ),
      SuperTileDensity.comfortable => SuperTileMetrics(
        minHeight: 48,
        paddingV: s.space2,
        paddingH: s.space3,
        gap: s.space3,
      ),
      SuperTileDensity.expanded => SuperTileMetrics(
        minHeight: 60,
        paddingV: s.space3,
        paddingH: s.space4,
        gap: s.space3,
      ),
    };
  }
}

/// The pointer/keyboard state of a tile, used to resolve its surface treatment.
@immutable
class SuperTileVisualState {
  const SuperTileVisualState({
    this.hovered = false,
    this.focused = false,
    this.pressed = false,
    this.selected = false,
    this.disabled = false,
  });

  final bool hovered;
  final bool focused;
  final bool pressed;
  final bool selected;
  final bool disabled;

  /// Whether any interactive treatment should show.
  bool get isInteractive => hovered || focused || pressed || selected;
}

/// Resolves the GeniusLink surface fill for a tile in [state] over [base].
///
/// Follows the design system's interaction rules: selection uses an accent
/// tint, hover shifts to `--gl-hover`, pressed deepens slightly. Selection wins
/// over hover so a selected row stays clearly marked while pointed at.
Color superTileFill(
  SuperThemeData t,
  SuperTileVisualState state, {
  Color? base,
}) {
  final surface = base ?? t.surface;
  if (state.disabled) return surface;
  if (state.selected) {
    return t.selectionFill(state.pressed ? 0.16 : 0.12);
  }
  if (state.pressed) return t.hover;
  if (state.hovered || state.focused) return t.hover;
  return surface;
}

/// The border a tile shows in [state] — accent when selected/focused, else the
/// hairline (or none).
Border? superTileBorder(
  SuperThemeData t,
  SuperTileVisualState state, {
  bool bordered = true,
}) {
  if (state.selected) {
    return Border.all(color: t.tokens.accent, width: 1.5);
  }
  if (state.focused) {
    return Border.all(color: t.tokens.accent, width: 1.5);
  }
  if (!bordered) return null;
  return Border.all(color: t.border);
}

/// A section-marker pill (the GeniusLink signature 4px bar), sized to [height].
class SuperTileMarker extends StatelessWidget {
  const SuperTileMarker({super.key, required this.marker, this.height = 28});

  final SuperMarker marker;
  final double height;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    return Container(
      width: k.markerWidth,
      height: height,
      decoration: BoxDecoration(
        color: k.markerColor(marker),
        borderRadius: BorderRadius.circular(t.spacing.radiusPill),
      ),
    );
  }
}

/// A subtle indeterminate shimmer used by the tile loading states.
class SuperTileShimmer extends StatefulWidget {
  const SuperTileShimmer({
    super.key,
    this.width,
    this.height = 12,
    this.radius = 4,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<SuperTileShimmer> createState() => _SuperTileShimmerState();
}

class _SuperTileShimmerState extends State<SuperTileShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final v = _c.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 - v * 2, 0),
              end: Alignment(1 - v * 2, 0),
              colors: [t.hover, t.inputBg, t.hover],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}
