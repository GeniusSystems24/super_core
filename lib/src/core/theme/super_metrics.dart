// ============================================================
// core/theme/super_metrics.dart
// ------------------------------------------------------------
// SuperMetrics — the responsive design-token bundle. One immutable snapshot of
// the spacing / sizing / padding / margin scales for a single SuperDeviceMode,
// plus the CENTRALIZED responsive definitions those snapshots resolve from.
//
// There is exactly one place each responsive value is written:
//   SuperMetrics.spacingResponsive / sizingResponsive / paddingResponsive /
//   marginResponsive.
// Everything else calls `SuperMetrics.of(mode)` and reads the active values.
// ============================================================

import 'package:flutter/widgets.dart';

import 'super_device_mode.dart';

/// Responsive spacing scale (gaps between elements). All multiples of the 4px
/// base unit; larger form-factors breathe more.
@immutable
class SuperSpacing {
  const SuperSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.section,
  });

  /// Hairline gap.
  final double xs;

  /// Tight gap (icon ↔ label).
  final double sm;

  /// Default in-component gap.
  final double md;

  /// Group gap.
  final double lg;

  /// Block gap.
  final double xl;

  /// Gap between stacked section cards.
  final double section;

  SuperSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? section,
  }) =>
      SuperSpacing(
        xs: xs ?? this.xs,
        sm: sm ?? this.sm,
        md: md ?? this.md,
        lg: lg ?? this.lg,
        xl: xl ?? this.xl,
        section: section ?? this.section,
      );

  static SuperSpacing lerp(SuperSpacing a, SuperSpacing b, double t) => SuperSpacing(
        xs: _lerpDouble(a.xs, b.xs, t),
        sm: _lerpDouble(a.sm, b.sm, t),
        md: _lerpDouble(a.md, b.md, t),
        lg: _lerpDouble(a.lg, b.lg, t),
        xl: _lerpDouble(a.xl, b.xl, t),
        section: _lerpDouble(a.section, b.section, t),
      );
}

/// Responsive sizing scale (control heights, icon + touch-target sizes).
///
/// Note the inverse relationship with [SuperSpacing]: controls are *taller* on
/// mobile (≥44px touch targets) and *shorter* on desktop (dense pointer UI).
@immutable
class SuperSizing {
  const SuperSizing({
    required this.control,
    required this.iconButton,
    required this.icon,
    required this.fieldComfortable,
    required this.fieldCompact,
    required this.contentColumn,
  });

  /// Button / input height.
  final double control;

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
    double? control,
    double? iconButton,
    double? icon,
    double? fieldComfortable,
    double? fieldCompact,
    double? contentColumn,
  }) =>
      SuperSizing(
        control: control ?? this.control,
        iconButton: iconButton ?? this.iconButton,
        icon: icon ?? this.icon,
        fieldComfortable: fieldComfortable ?? this.fieldComfortable,
        fieldCompact: fieldCompact ?? this.fieldCompact,
        contentColumn: contentColumn ?? this.contentColumn,
      );

  static SuperSizing lerp(SuperSizing a, SuperSizing b, double t) => SuperSizing(
        control: _lerpDouble(a.control, b.control, t),
        iconButton: _lerpDouble(a.iconButton, b.iconButton, t),
        icon: _lerpDouble(a.icon, b.icon, t),
        fieldComfortable: _lerpDouble(a.fieldComfortable, b.fieldComfortable, t),
        fieldCompact: _lerpDouble(a.fieldCompact, b.fieldCompact, t),
        contentColumn: _lerpDouble(a.contentColumn, b.contentColumn, t),
      );
}

/// Responsive *inner* padding bundle (space inside a container).
@immutable
class SuperPadding {
  const SuperPadding({
    required this.card,
    required this.control,
    required this.field,
    required this.page,
  });

  /// Section-card interior.
  final EdgeInsets card;

  /// Button interior.
  final EdgeInsets control;

  /// Input-field content padding.
  final EdgeInsets field;

  /// Page frame padding around the content column.
  final EdgeInsets page;

  SuperPadding copyWith({
    EdgeInsets? card,
    EdgeInsets? control,
    EdgeInsets? field,
    EdgeInsets? page,
  }) =>
      SuperPadding(
        card: card ?? this.card,
        control: control ?? this.control,
        field: field ?? this.field,
        page: page ?? this.page,
      );

  static SuperPadding lerp(SuperPadding a, SuperPadding b, double t) => SuperPadding(
        card: EdgeInsets.lerp(a.card, b.card, t)!,
        control: EdgeInsets.lerp(a.control, b.control, t)!,
        field: EdgeInsets.lerp(a.field, b.field, t)!,
        page: EdgeInsets.lerp(a.page, b.page, t)!,
      );
}

/// Responsive *outer* margin bundle (space around a container).
@immutable
class SuperMargin {
  const SuperMargin({
    required this.card,
    required this.section,
    required this.page,
  });

  /// Margin around a single card.
  final EdgeInsets card;

  /// Margin below a section (vertical rhythm between stacked sections).
  final EdgeInsets section;

  /// Outer page margin (content column offset from the viewport edge).
  final EdgeInsets page;

  SuperMargin copyWith({
    EdgeInsets? card,
    EdgeInsets? section,
    EdgeInsets? page,
  }) =>
      SuperMargin(
        card: card ?? this.card,
        section: section ?? this.section,
        page: page ?? this.page,
      );

  static SuperMargin lerp(SuperMargin a, SuperMargin b, double t) => SuperMargin(
        card: EdgeInsets.lerp(a.card, b.card, t)!,
        section: EdgeInsets.lerp(a.section, b.section, t)!,
        page: EdgeInsets.lerp(a.page, b.page, t)!,
      );
}

/// An immutable snapshot of every responsive token scale for one
/// [SuperDeviceMode]. Obtain via [SuperMetrics.of].
///
/// ```dart
/// final m = SuperMetrics.of(SuperDeviceMode.tablet);
/// Padding(padding: m.padding.card, child: ...);
/// SizedBox(height: m.spacing.section);
/// ```
///
/// All three device configurations remain reachable through the static
/// `*Responsive` containers, e.g. `SuperMetrics.spacingResponsive.desktop`.
@immutable
class SuperMetrics {
  const SuperMetrics({
    required this.mode,
    required this.spacing,
    required this.sizing,
    required this.padding,
    required this.margin,
  });

  /// The device mode these active values were resolved for.
  final SuperDeviceMode mode;

  final SuperSpacing spacing;
  final SuperSizing sizing;
  final SuperPadding padding;
  final SuperMargin margin;

  /// Resolves the active [SuperMetrics] for [mode] from the centralized
  /// responsive definitions.
  factory SuperMetrics.of(SuperDeviceMode mode) => SuperMetrics(
        mode: mode,
        spacing: spacingResponsive.resolve(mode),
        sizing: sizingResponsive.resolve(mode),
        padding: paddingResponsive.resolve(mode),
        margin: marginResponsive.resolve(mode),
      );

  // ── CENTRALIZED responsive definitions (single source of truth) ───────────
  //
  // Each per-mode bundle is written exactly once as a private const, then
  // wired into BOTH the responsive containers (for runtime resolution) and the
  // const SuperMetrics presets (for use as const defaults). No value is
  // duplicated.

  // Spacing — gaps grow with the viewport.
  static const SuperSpacing _spacingMobile =
      SuperSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 20, section: 20);
  static const SuperSpacing _spacingTablet =
      SuperSpacing(xs: 4, sm: 8, md: 14, lg: 20, xl: 28, section: 28);
  static const SuperSpacing _spacingDesktop =
      SuperSpacing(xs: 4, sm: 8, md: 16, lg: 24, xl: 32, section: 32);

  // Sizing — controls shrink as the pointer gets more precise.
  static const SuperSizing _sizingMobile = SuperSizing(
    control: 48,
    iconButton: 44,
    icon: 22,
    fieldComfortable: 48,
    fieldCompact: 42,
    contentColumn: 480,
  );
  static const SuperSizing _sizingTablet = SuperSizing(
    control: 44,
    iconButton: 40,
    icon: 21,
    fieldComfortable: 44,
    fieldCompact: 42,
    contentColumn: 600,
  );
  static const SuperSizing _sizingDesktop = SuperSizing(
    control: 40,
    iconButton: 32,
    icon: 20,
    fieldComfortable: 42,
    fieldCompact: 42,
    contentColumn: 680,
  );

  // Padding — inner space widens with the viewport.
  static const SuperPadding _paddingMobile = SuperPadding(
    card: EdgeInsets.all(16),
    control: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    field: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    page: EdgeInsets.all(16),
  );
  static const SuperPadding _paddingTablet = SuperPadding(
    card: EdgeInsets.all(20),
    control: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    field: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    page: EdgeInsets.symmetric(horizontal: 32, vertical: 28),
  );
  static const SuperPadding _paddingDesktop = SuperPadding(
    card: EdgeInsets.fromLTRB(24, 24, 24, 40),
    control: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    field: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    page: EdgeInsets.symmetric(horizontal: 80, vertical: 40),
  );

  // Margin — outer space widens with the viewport.
  static const SuperMargin _marginMobile = SuperMargin(
    card: EdgeInsets.zero,
    section: EdgeInsets.only(bottom: 20),
    page: EdgeInsets.zero,
  );
  static const SuperMargin _marginTablet = SuperMargin(
    card: EdgeInsets.zero,
    section: EdgeInsets.only(bottom: 28),
    page: EdgeInsets.symmetric(horizontal: 40),
  );
  static const SuperMargin _marginDesktop = SuperMargin(
    card: EdgeInsets.zero,
    section: EdgeInsets.only(bottom: 32),
    page: EdgeInsets.symmetric(horizontal: 120),
  );

  /// Responsive spacing scale.
  static const SuperResponsive<SuperSpacing> spacingResponsive =
      SuperResponsive<SuperSpacing>(
    mobile: _spacingMobile,
    tablet: _spacingTablet,
    desktop: _spacingDesktop,
  );

  /// Responsive sizing scale.
  static const SuperResponsive<SuperSizing> sizingResponsive =
      SuperResponsive<SuperSizing>(
    mobile: _sizingMobile,
    tablet: _sizingTablet,
    desktop: _sizingDesktop,
  );

  /// Responsive inner-padding scale.
  static const SuperResponsive<SuperPadding> paddingResponsive =
      SuperResponsive<SuperPadding>(
    mobile: _paddingMobile,
    tablet: _paddingTablet,
    desktop: _paddingDesktop,
  );

  /// Responsive outer-margin scale.
  static const SuperResponsive<SuperMargin> marginResponsive =
      SuperResponsive<SuperMargin>(
    mobile: _marginMobile,
    tablet: _marginTablet,
    desktop: _marginDesktop,
  );

  // ── Const presets (usable as const default values) ────────────────────────

  /// The mobile metrics snapshot as a compile-time constant.
  static const SuperMetrics mobile = SuperMetrics(
    mode: SuperDeviceMode.mobile,
    spacing: _spacingMobile,
    sizing: _sizingMobile,
    padding: _paddingMobile,
    margin: _marginMobile,
  );

  /// The tablet metrics snapshot as a compile-time constant.
  static const SuperMetrics tablet = SuperMetrics(
    mode: SuperDeviceMode.tablet,
    spacing: _spacingTablet,
    sizing: _sizingTablet,
    padding: _paddingTablet,
    margin: _marginTablet,
  );

  /// The desktop metrics snapshot as a compile-time constant.
  static const SuperMetrics desktop = SuperMetrics(
    mode: SuperDeviceMode.desktop,
    spacing: _spacingDesktop,
    sizing: _sizingDesktop,
    padding: _paddingDesktop,
    margin: _marginDesktop,
  );

  SuperMetrics copyWith({
    SuperDeviceMode? mode,
    SuperSpacing? spacing,
    SuperSizing? sizing,
    SuperPadding? padding,
    SuperMargin? margin,
  }) =>
      SuperMetrics(
        mode: mode ?? this.mode,
        spacing: spacing ?? this.spacing,
        sizing: sizing ?? this.sizing,
        padding: padding ?? this.padding,
        margin: margin ?? this.margin,
      );

  /// Lerps every scale. Discrete [mode] snaps at the midpoint (device mode is
  /// not a continuously-animatable quantity).
  static SuperMetrics lerp(SuperMetrics a, SuperMetrics b, double t) => SuperMetrics(
        mode: t < 0.5 ? a.mode : b.mode,
        spacing: SuperSpacing.lerp(a.spacing, b.spacing, t),
        sizing: SuperSizing.lerp(a.sizing, b.sizing, t),
        padding: SuperPadding.lerp(a.padding, b.padding, t),
        margin: SuperMargin.lerp(a.margin, b.margin, t),
      );
}

/// Non-null double lerp helper (private) — the numeric scales are always non-null.
double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
