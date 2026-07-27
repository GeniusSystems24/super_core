// ============================================================
// core/theme/super_spacing.dart
// ------------------------------------------------------------
// SuperSpacing — the GeniusLink spacing system (ported from the reference
// `genius_spacing.dart`) as a single, immutable, responsive layout-metric
// bundle. One snapshot carries:
//   • the numbered 4px spacing scale   (space1 … space12)
//   • corner radii                     (radiusControl / radiusMd / …)
//   • the standard control height      (controlHeight)
//   • the tuned container insets        (cardPadding / pagePadding / …)
// plus the GeniusLink derived getters (border-radius, control-size,
// container-padding and margin helpers).
//
// It is resolved per [SuperDeviceMode] via the centralized [responsive]
// container — the density steps DOWN from mobile → desktop exactly like the
// reference's android → windows presets, with a dedicated tablet step in
// between. Read the active bundle from the ambient theme:
//
//   final s = SuperThemeData.of(context).spacing;
//   SizedBox(height: s.space4);
//   Padding(padding: s.cardPadding, child: ...);
//   BorderRadius.circular(s.radiusCard);
//
// All three device configurations stay reachable through [responsive] /
// [mobile] / [tablet] / [desktop].
// ============================================================

import 'package:flutter/widgets.dart';

import 'super_device_mode.dart';

/// The GeniusLink spacing system: a responsive bundle of the numbered spacing
/// scale, corner radii, the standard control height and the tuned container
/// insets, plus the derived padding / margin / radius / control-size helpers.
///
/// Obtain the active snapshot for a device mode via [SuperSpacing.of], or read
/// it from the ambient theme via `SuperThemeData.of(context).spacing`. The
/// three per-mode presets ([mobile] / [tablet] / [desktop]) are compile-time
/// constants and stay reachable through [responsive].
@immutable
class SuperSpacing {
  const SuperSpacing({
    // scale
    required this.space1,
    required this.space2,
    required this.space3,
    required this.space4,
    required this.space5,
    required this.space6,
    required this.space8,
    required this.space10,
    required this.space12,
    // radii
    required this.radiusControl,
    required this.radiusMd,
    required this.radiusCard,
    required this.radiusPill,
    // control
    required this.controlHeight,
    // insets
    required this.cardPadding,
    required this.controlPadding,
    required this.fieldPadding,
    required this.pagePadding,
    required this.cardMargin,
    required this.sectionMargin,
    required this.pageMargin,
  });

  // ── Numbered spacing scale (4px base unit) ────────────────────────────────
  //
  // The canonical GeniusLink gap scale. Values step DOWN with the viewport
  // (mobile = roomiest / android density, desktop = tightest / windows
  // density), so denser pointer surfaces get a tighter rhythm.

  /// 4 / 3 / 2 — hairline gap.
  final double space1;

  /// 8 / 6 / 4 — tight gap (icon ↔ label).
  final double space2;

  /// 12 / 10 / 8 — default in-component gap.
  final double space3;

  /// 16 / 14 / 12 — group gap.
  final double space4;

  /// 20 / 18 / 16 — block gap.
  final double space5;

  /// 24 / 22 / 20 — section gap.
  final double space6;

  /// 32 / 28 / 24.
  final double space8;

  /// 40 / 36 / 32.
  final double space10;

  /// 48 / 44 / 40.
  final double space12;

  // ── Semantic gap aliases ──────────────────────────────────────────────────
  //
  // Named views onto the numbered scale, kept for ergonomic call sites (the
  // Material theme reads gaps by intent rather than by step).

  /// Hairline gap — alias of [space1].
  double get xs => space1;

  /// Tight gap (icon ↔ label) — alias of [space2].
  double get sm => space2;

  /// Default in-component gap — alias of [space3].
  double get md => space3;

  /// Group gap — alias of [space4].
  double get lg => space4;

  /// Block gap — alias of [space5].
  double get xl => space5;

  /// Gap between stacked section cards — alias of [space3].
  double get section => space3;

  // ── Corner radii ──────────────────────────────────────────────────────────
  //
  // Preserved from the previous token values (relocated here); constant across
  // device modes.

  /// Control radius — inputs, buttons (4).
  final double radiusControl;

  /// Medium radius (6).
  final double radiusMd;

  /// Card radius — section cards (8).
  final double radiusCard;

  /// Pill radius — status pills, section-marker bar (12).
  final double radiusPill;

  // ── Control metric ──────────────────────────────────────────────────────
  /// Standard control height — buttons / inputs (48 / 44 / 40).
  final double controlHeight;

  // ── Container insets (tuned per mode) ─────────────────────────────────────

  /// Section-card interior padding (14 / 16 / 18 — grows with the viewport so
  /// larger surfaces breathe).
  final EdgeInsets cardPadding;

  /// Button / control interior padding.
  final EdgeInsets controlPadding;

  /// Input-field content padding.
  final EdgeInsets fieldPadding;

  /// Page frame padding around the content column.
  final EdgeInsets pagePadding;

  /// Outer margin around a single card.
  final EdgeInsets cardMargin;

  /// Margin below a section (vertical rhythm between stacked sections).
  final EdgeInsets sectionMargin;

  /// Outer page margin (content column offset from the viewport edge).
  final EdgeInsets pageMargin;

  // ── Derived scale paddings (GeniusLink parity helpers) ────────────────────

  EdgeInsets get containerPadding1 => EdgeInsets.all(space1);
  EdgeInsets get containerPadding2 => EdgeInsets.all(space2);
  EdgeInsets get containerPadding3 => EdgeInsets.all(space3);
  EdgeInsets get containerPadding4 => EdgeInsets.all(space4);
  EdgeInsets get containerPadding5 => EdgeInsets.all(space5);
  EdgeInsets get containerPadding6 => EdgeInsets.all(space6);

  /// Compact section-card interior (one step tighter than [cardPadding]).
  EdgeInsets get compactCardPadding => EdgeInsets.all(space4);

  /// List-tile interior padding.
  EdgeInsets get listTilePadding =>
      EdgeInsets.symmetric(horizontal: space4, vertical: space3);

  // ── Derived control sizes ─────────────────────────────────────────────────

  Size get controlMinSize => Size(0, controlHeight);
  Size get controlMaxSize => Size(double.infinity, controlHeight);
  Size get squareControlSize => Size.square(controlHeight);
  BoxConstraints get singleLineControlConstraints =>
      BoxConstraints.tightFor(height: controlHeight);
  BoxConstraints get fieldIconConstraints =>
      BoxConstraints.tightFor(width: controlHeight, height: controlHeight);

  // ── Derived border radii ──────────────────────────────────────────────────

  BorderRadius get borderRadiusControl => BorderRadius.circular(radiusControl);
  BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  BorderRadius get borderRadiusCard => BorderRadius.circular(radiusCard);
  BorderRadius get borderRadiusPill => BorderRadius.circular(radiusPill);

  /// Input-field border radius — alias of [borderRadiusControl].
  BorderRadius get fieldBorderRadius => borderRadiusControl;

  /// Button border radius — alias of [borderRadiusControl].
  BorderRadius get buttonBorderRadius => borderRadiusControl;

  /// Card border radius — alias of [borderRadiusCard].
  BorderRadius get cardBorderRadius => borderRadiusCard;

  /// Pill border radius — alias of [borderRadiusPill].
  BorderRadius get pillBorderRadius => borderRadiusPill;

  // ── Per-mode presets (single source of truth) ─────────────────────────────

  /// Phones — roomiest rhythm (android density in the reference).
  static const SuperSpacing mobile = SuperSpacing(
    space1: 4,
    space2: 8,
    space3: 12,
    space4: 16,
    space5: 20,
    space6: 24,
    space8: 32,
    space10: 40,
    space12: 48,
    radiusControl: 4,
    radiusMd: 6,
    radiusCard: 8,
    radiusPill: 12,
    controlHeight: 48,
    cardPadding: EdgeInsets.all(14),
    controlPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    fieldPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    pagePadding: EdgeInsets.all(12),
    cardMargin: EdgeInsets.zero,
    sectionMargin: EdgeInsets.only(bottom: 12),
    pageMargin: EdgeInsets.zero,
  );

  /// Tablets — a dedicated step between mobile and desktop.
  static const SuperSpacing tablet = SuperSpacing(
    space1: 3,
    space2: 6,
    space3: 10,
    space4: 14,
    space5: 18,
    space6: 22,
    space8: 28,
    space10: 36,
    space12: 44,
    radiusControl: 4,
    radiusMd: 6,
    radiusCard: 8,
    radiusPill: 12,
    controlHeight: 44,
    cardPadding: EdgeInsets.all(16),
    controlPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    fieldPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    pagePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    cardMargin: EdgeInsets.zero,
    sectionMargin: EdgeInsets.only(bottom: 14),
    pageMargin: EdgeInsets.symmetric(horizontal: 24),
  );

  /// Desktop / web — tightest rhythm (windows density in the reference).
  static const SuperSpacing desktop = SuperSpacing(
    space1: 2,
    space2: 4,
    space3: 8,
    space4: 12,
    space5: 16,
    space6: 20,
    space8: 24,
    space10: 32,
    space12: 40,
    radiusControl: 4,
    radiusMd: 6,
    radiusCard: 8,
    radiusPill: 12,
    controlHeight: 40,
    cardPadding: EdgeInsets.all(18),
    controlPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    fieldPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    pagePadding: EdgeInsets.symmetric(horizontal: 48, vertical: 24),
    cardMargin: EdgeInsets.zero,
    sectionMargin: EdgeInsets.only(bottom: 16),
    pageMargin: EdgeInsets.symmetric(horizontal: 64),
  );

  /// The responsive definition — one [SuperSpacing] per [SuperDeviceMode].
  /// All three configurations stay reachable, e.g. `SuperSpacing.responsive.desktop`.
  static const SuperResponsive<SuperSpacing> responsive =
      SuperResponsive<SuperSpacing>(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );

  /// The active [SuperSpacing] for [mode].
  factory SuperSpacing.of(SuperDeviceMode mode) => responsive.resolve(mode);

  // ── copyWith / lerp / equality ────────────────────────────────────────────

  SuperSpacing copyWith({
    double? space1,
    double? space2,
    double? space3,
    double? space4,
    double? space5,
    double? space6,
    double? space8,
    double? space10,
    double? space12,
    double? radiusControl,
    double? radiusMd,
    double? radiusCard,
    double? radiusPill,
    double? controlHeight,
    EdgeInsets? cardPadding,
    EdgeInsets? controlPadding,
    EdgeInsets? fieldPadding,
    EdgeInsets? pagePadding,
    EdgeInsets? cardMargin,
    EdgeInsets? sectionMargin,
    EdgeInsets? pageMargin,
  }) => SuperSpacing(
    space1: space1 ?? this.space1,
    space2: space2 ?? this.space2,
    space3: space3 ?? this.space3,
    space4: space4 ?? this.space4,
    space5: space5 ?? this.space5,
    space6: space6 ?? this.space6,
    space8: space8 ?? this.space8,
    space10: space10 ?? this.space10,
    space12: space12 ?? this.space12,
    radiusControl: radiusControl ?? this.radiusControl,
    radiusMd: radiusMd ?? this.radiusMd,
    radiusCard: radiusCard ?? this.radiusCard,
    radiusPill: radiusPill ?? this.radiusPill,
    controlHeight: controlHeight ?? this.controlHeight,
    cardPadding: cardPadding ?? this.cardPadding,
    controlPadding: controlPadding ?? this.controlPadding,
    fieldPadding: fieldPadding ?? this.fieldPadding,
    pagePadding: pagePadding ?? this.pagePadding,
    cardMargin: cardMargin ?? this.cardMargin,
    sectionMargin: sectionMargin ?? this.sectionMargin,
    pageMargin: pageMargin ?? this.pageMargin,
  );

  /// Linearly interpolates between two spacing bundles.
  static SuperSpacing lerp(SuperSpacing a, SuperSpacing b, double t) =>
      SuperSpacing(
        space1: _d(a.space1, b.space1, t),
        space2: _d(a.space2, b.space2, t),
        space3: _d(a.space3, b.space3, t),
        space4: _d(a.space4, b.space4, t),
        space5: _d(a.space5, b.space5, t),
        space6: _d(a.space6, b.space6, t),
        space8: _d(a.space8, b.space8, t),
        space10: _d(a.space10, b.space10, t),
        space12: _d(a.space12, b.space12, t),
        radiusControl: _d(a.radiusControl, b.radiusControl, t),
        radiusMd: _d(a.radiusMd, b.radiusMd, t),
        radiusCard: _d(a.radiusCard, b.radiusCard, t),
        radiusPill: _d(a.radiusPill, b.radiusPill, t),
        controlHeight: _d(a.controlHeight, b.controlHeight, t),
        cardPadding: EdgeInsets.lerp(a.cardPadding, b.cardPadding, t)!,
        controlPadding: EdgeInsets.lerp(a.controlPadding, b.controlPadding, t)!,
        fieldPadding: EdgeInsets.lerp(a.fieldPadding, b.fieldPadding, t)!,
        pagePadding: EdgeInsets.lerp(a.pagePadding, b.pagePadding, t)!,
        cardMargin: EdgeInsets.lerp(a.cardMargin, b.cardMargin, t)!,
        sectionMargin: EdgeInsets.lerp(a.sectionMargin, b.sectionMargin, t)!,
        pageMargin: EdgeInsets.lerp(a.pageMargin, b.pageMargin, t)!,
      );

  @override
  bool operator ==(Object other) =>
      other is SuperSpacing &&
      other.space1 == space1 &&
      other.space2 == space2 &&
      other.space3 == space3 &&
      other.space4 == space4 &&
      other.space5 == space5 &&
      other.space6 == space6 &&
      other.space8 == space8 &&
      other.space10 == space10 &&
      other.space12 == space12 &&
      other.radiusControl == radiusControl &&
      other.radiusMd == radiusMd &&
      other.radiusCard == radiusCard &&
      other.radiusPill == radiusPill &&
      other.controlHeight == controlHeight &&
      other.cardPadding == cardPadding &&
      other.controlPadding == controlPadding &&
      other.fieldPadding == fieldPadding &&
      other.pagePadding == pagePadding &&
      other.cardMargin == cardMargin &&
      other.sectionMargin == sectionMargin &&
      other.pageMargin == pageMargin;

  @override
  int get hashCode => Object.hashAll([
    space1,
    space2,
    space3,
    space4,
    space5,
    space6,
    space8,
    space10,
    space12,
    radiusControl,
    radiusMd,
    radiusCard,
    radiusPill,
    controlHeight,
    cardPadding,
    controlPadding,
    fieldPadding,
    pagePadding,
    cardMargin,
    sectionMargin,
    pageMargin,
  ]);
}

/// Non-null double lerp helper — the numeric scales are always non-null.
double _d(double a, double b, double t) => a + (b - a) * t;
