// ============================================================
// core/theme/super_metrics.dart
// ------------------------------------------------------------
// SuperMetrics — the responsive design-token bundle. One immutable snapshot of
// the spacing + sizing scales for a single SuperDeviceMode.
//
// The spacing / radii / control-height / container-inset scale lives in
// [SuperSpacing] (see super_spacing.dart). SuperMetrics pairs the active
// [SuperSpacing] with the [SuperSizing] scale (icon + control sizing that the
// spacing bundle does not cover) so a theme can resolve both from a single
// [SuperDeviceMode]:
//
//   final m = SuperMetrics.of(SuperDeviceMode.tablet);
//   SizedBox(height: m.spacing.space4);
//   Icon(Icons.close, size: m.sizing.icon);
//
// Everything else calls `SuperMetrics.of(mode)` and reads the active values.
// All three device configurations remain reachable through the static
// `*Responsive` containers (and through `SuperSpacing.responsive`).
// ============================================================

import 'package:flutter/widgets.dart';

import 'super_device_mode.dart';
import 'super_spacing.dart';

/// Responsive sizing scale (control-adjacent heights, icon + touch-target
/// sizes) that the [SuperSpacing] bundle does not cover.
///
/// Note the inverse relationship with the spacing scale: controls are *taller*
/// on mobile (≥44px touch targets) and *shorter* on desktop (dense pointer UI).
@immutable
class SuperSizing {
  const SuperSizing({
    required this.iconButton,
    required this.icon,
    required this.fieldComfortable,
    required this.fieldCompact,
    required this.contentColumn,
  });

  /// Square icon-button hit area.
  final double iconButton;

  /// Glyph size.
  final double icon;

  /// Comfortable-density field height.
  final double fieldComfortable;

  /// Compact-density field height.
  final double fieldCompact;

  /// Centered page content column width.
  final double contentColumn;

  SuperSizing copyWith({
    double? iconButton,
    double? icon,
    double? fieldComfortable,
    double? fieldCompact,
    double? contentColumn,
  }) => SuperSizing(
    iconButton: iconButton ?? this.iconButton,
    icon: icon ?? this.icon,
    fieldComfortable: fieldComfortable ?? this.fieldComfortable,
    fieldCompact: fieldCompact ?? this.fieldCompact,
    contentColumn: contentColumn ?? this.contentColumn,
  );

  static SuperSizing lerp(SuperSizing a, SuperSizing b, double t) =>
      SuperSizing(
        iconButton: _lerpDouble(a.iconButton, b.iconButton, t),
        icon: _lerpDouble(a.icon, b.icon, t),
        fieldComfortable: _lerpDouble(
          a.fieldComfortable,
          b.fieldComfortable,
          t,
        ),
        fieldCompact: _lerpDouble(a.fieldCompact, b.fieldCompact, t),
        contentColumn: _lerpDouble(a.contentColumn, b.contentColumn, t),
      );

  @override
  bool operator ==(Object other) =>
      other is SuperSizing &&
      other.iconButton == iconButton &&
      other.icon == icon &&
      other.fieldComfortable == fieldComfortable &&
      other.fieldCompact == fieldCompact &&
      other.contentColumn == contentColumn;

  @override
  int get hashCode => Object.hash(
    iconButton,
    icon,
    fieldComfortable,
    fieldCompact,
    contentColumn,
  );
}

/// An immutable snapshot of the responsive token scales for one
/// [SuperDeviceMode]. Obtain via [SuperMetrics.of].
///
/// ```dart
/// final m = SuperMetrics.of(SuperDeviceMode.tablet);
/// Padding(padding: m.spacing.cardPadding, child: ...);
/// SizedBox(height: m.spacing.section);
/// Icon(Icons.close, size: m.sizing.icon);
/// ```
///
/// All three device configurations remain reachable through
/// `SuperSpacing.responsive` and [sizingResponsive].
@immutable
class SuperMetrics {
  const SuperMetrics({
    required this.mode,
    required this.spacing,
    required this.sizing,
  });

  /// The device mode these active values were resolved for.
  final SuperDeviceMode mode;

  /// The active spacing / radii / control-height / inset bundle.
  final SuperSpacing spacing;

  /// The active icon + control sizing scale.
  final SuperSizing sizing;

  /// Resolves the active [SuperMetrics] for [mode] from the centralized
  /// responsive definitions.
  factory SuperMetrics.of(SuperDeviceMode mode) => SuperMetrics(
    mode: mode,
    spacing: SuperSpacing.of(mode),
    sizing: sizingResponsive.resolve(mode),
  );

  // ── CENTRALIZED responsive definitions (single source of truth) ───────────
  //
  // The spacing scale is defined in SuperSpacing; the sizing scale is defined
  // here. Each per-mode bundle is written exactly once as a private const, then
  // wired into BOTH the responsive container (for runtime resolution) and the
  // const SuperMetrics presets.

  // Sizing — controls shrink as the pointer gets more precise.
  static const SuperSizing _sizingMobile = SuperSizing(
    iconButton: 44,
    icon: 22,
    fieldComfortable: 44,
    fieldCompact: 38,
    contentColumn: 480,
  );
  static const SuperSizing _sizingTablet = SuperSizing(
    iconButton: 40,
    icon: 21,
    fieldComfortable: 42,
    fieldCompact: 38,
    contentColumn: 600,
  );
  static const SuperSizing _sizingDesktop = SuperSizing(
    iconButton: 32,
    icon: 20,
    fieldComfortable: 40,
    fieldCompact: 36,
    contentColumn: 680,
  );

  /// Responsive sizing scale.
  static const SuperResponsive<SuperSizing> sizingResponsive =
      SuperResponsive<SuperSizing>(
        mobile: _sizingMobile,
        tablet: _sizingTablet,
        desktop: _sizingDesktop,
      );

  // ── Const presets (usable as const default values) ────────────────────────

  /// The mobile metrics snapshot as a compile-time constant.
  static const SuperMetrics mobile = SuperMetrics(
    mode: SuperDeviceMode.mobile,
    spacing: SuperSpacing.mobile,
    sizing: _sizingMobile,
  );

  /// The tablet metrics snapshot as a compile-time constant.
  static const SuperMetrics tablet = SuperMetrics(
    mode: SuperDeviceMode.tablet,
    spacing: SuperSpacing.tablet,
    sizing: _sizingTablet,
  );

  /// The desktop metrics snapshot as a compile-time constant.
  static const SuperMetrics desktop = SuperMetrics(
    mode: SuperDeviceMode.desktop,
    spacing: SuperSpacing.desktop,
    sizing: _sizingDesktop,
  );

  SuperMetrics copyWith({
    SuperDeviceMode? mode,
    SuperSpacing? spacing,
    SuperSizing? sizing,
  }) => SuperMetrics(
    mode: mode ?? this.mode,
    spacing: spacing ?? this.spacing,
    sizing: sizing ?? this.sizing,
  );

  /// Lerps every scale. Discrete [mode] snaps at the midpoint (device mode is
  /// not a continuously-animatable quantity).
  static SuperMetrics lerp(SuperMetrics a, SuperMetrics b, double t) =>
      SuperMetrics(
        mode: t < 0.5 ? a.mode : b.mode,
        spacing: SuperSpacing.lerp(a.spacing, b.spacing, t),
        sizing: SuperSizing.lerp(a.sizing, b.sizing, t),
      );
}

/// Non-null double lerp helper (private) — the numeric scales are always non-null.
double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
