// ============================================================
// core/theme/super_tokens.dart
// ------------------------------------------------------------
// SuperTokensData — the DYNAMIC brand-token bundle for the GeniusLink design
// system. Prior to v2.0.0 these were compile-time `static const` values on an
// `abstract final class SuperTokens`; they are now instance fields on this
// immutable data class so a theme can override any of them. There are NO static
// token constants — the only default values are the literals baked into the
// constructor, and the sole default *instance* is [SuperTokensData.fallback].
//
// The bundle is carried by [SuperThemeData.tokens] (registered as a
// `ThemeExtension` by `SuperMaterialThemeData`) and surfaced directly as
// `SuperMaterialThemeData.tokens`, so every Super component reads brand tokens
// from the ambient theme via `SuperThemeData.of(context).tokens` — never from a
// static constant.
//
//   final tokens = SuperThemeData.of(context).tokens;
//   SizedBox(height: tokens.space4);
//   BorderRadius.circular(tokens.radiusCard);
//
// Ported from `colors_and_type.css`.
// ============================================================

import 'package:flutter/widgets.dart';

/// An immutable bundle of the theme-level GeniusLink brand tokens — the accent
/// + semantic palette, font families, radii, the 4px spacing scale, control
/// metrics, and motion curves.
///
/// Read the active bundle from the ambient theme — there are no static token
/// constants to reach for:
///
/// ```dart
/// final tokens = SuperThemeData.of(context).tokens; // or theme.tokens
/// ```
///
/// The default values are the literals baked into the constructor, so
/// `const SuperTokensData()` is the canonical brand default and
/// [SuperTokensData.fallback] is a shared const *instance* of it. Override any
/// subset with [copyWith] or by passing `tokens:` to
/// `SuperMaterialThemeData.light` / `.dark`.
@immutable
class SuperTokensData {
  /// Creates a token bundle. Every parameter defaults to the GeniusLink brand
  /// value (defined inline here — the single source of truth), so omitting all
  /// of them yields the canonical default theme.
  const SuperTokensData({
    this.accent = const Color(0xFF4A7CFF),
    this.accentHover = const Color(0xFF5E8DFF),
    this.accentPressed = const Color(0xFF3D6DEB),
    this.info = const Color(0xFF0EA5E9),
    this.success = const Color(0xFF1DB88A),
    this.warning = const Color(0xFFF97316),
    this.danger = const Color(0xFFEF4444),
    this.displayFont = 'Manrope',
    this.bodyFont = 'Inter',
    this.monoFont = 'JetBrainsMono',
    this.arabicFont = 'NotoNaskhArabic',
    this.radiusControl = 4,
    this.radiusMd = 6,
    this.radiusCard = 8,
    this.radiusPill = 12,
    this.space1 = 4,
    this.space2 = 8,
    this.space3 = 12,
    this.space4 = 16,
    this.space6 = 24,
    this.space8 = 32,
    this.space10 = 40,
    this.space16 = 64,
    this.space20 = 80,
    this.controlHeight = 40,
    this.iconButton = 32,
    this.markerWidth = 4,
    this.markerHeight = 40,
    this.contentColumn = 680,
    this.fieldComfortable = 42,
    this.fieldCompact = 36,
    this.stepperSize = 24,
    this.trailingIcon = 26,
    this.durFast = const Duration(milliseconds: 100),
    this.durBase = const Duration(milliseconds: 150),
    this.durExpand = const Duration(milliseconds: 200),
    this.curveStandard = const Cubic(0.4, 0, 0.2, 1),
    this.curveOut = const Cubic(0, 0, 0.2, 1),
  });

  // ── Brand + semantic palette ──────────────────────────────────────────────

  /// The single dominant electric-royal-blue accent.
  final Color accent;

  /// The accent lightened ~6% for hover states.
  final Color accentHover;

  /// The accent darkened for pressed states.
  final Color accentPressed;

  /// Semantic informational color — neutral notices / in-progress states
  /// (sky blue, distinct from the royal-blue [accent]).
  final Color info;

  /// Semantic success color — ledger / balance sections.
  final Color success;

  /// Semantic warning color — notes / documentation sections.
  final Color warning;

  /// Semantic danger color — destructive actions / errors.
  final Color danger;

  // ── Typography families ─────────────────────────────────────────────────

  /// Display face — H1 page titles and the page-name watermark.
  final String displayFont;

  /// Body face — headings, body, labels, captions.
  final String bodyFont;

  /// Monospace face — numerics, serials, audit-log entries.
  final String monoFont;

  /// Arabic face — Arabic glyph runs.
  final String arabicFont;

  // ── Radii ──────────────────────────────────────────────────────────────

  /// Control radius — inputs, buttons.
  final double radiusControl;

  /// Medium radius.
  final double radiusMd;

  /// Card radius — section cards (default).
  final double radiusCard;

  /// Pill radius — status pills, section-marker bar.
  final double radiusPill;

  // ── Spacing scale (4px base unit) ──────────────────────────────────────
  /// 4px.
  final double space1;

  /// 8px.
  final double space2;

  /// 12px.
  final double space3;

  /// 16px.
  final double space4;

  /// 24px.
  final double space6;

  /// 32px.
  final double space8;

  /// 40px.
  final double space10;

  /// 64px.
  final double space16;

  /// 80px.
  final double space20;

  // ── Control metrics ────────────────────────────────────────────────────

  /// Default control height — inputs + buttons.
  final double controlHeight;

  /// Square icon-button hit area.
  final double iconButton;

  /// Section-marker bar width.
  final double markerWidth;

  /// Section-marker bar height.
  final double markerHeight;

  /// Centered page content-column width.
  final double contentColumn;

  /// Comfortable-density field height.
  final double fieldComfortable;

  /// Compact-density field height.
  final double fieldCompact;

  /// The +/- stepper button size on numeric fields.
  final double stepperSize;

  /// In-field trailing affordance (clear / reveal / calendar / error badge).
  final double trailingIcon;

  // ── Motion ───────────────────────────────────────────────────────────────

  /// Fast transition — press/scale feedback.
  final Duration durFast;

  /// Base transition — color / background changes.
  final Duration durBase;

  /// Expand/collapse transition — accordions, expandable cards.
  final Duration durExpand;

  /// Standard easing curve (`ease`).
  final Curve curveStandard;

  /// Deceleration curve (`ease-out`).
  final Curve curveOut;

  // ── Section-marker intent colors ─────────────────────────────────────────

  /// Blue — primary identity / definition / details sections.
  Color get markerIdentity => accent;

  /// Green — financial / balance / ledger / transfer sections.
  Color get markerLedger => success;

  /// Orange — notes / compliance / documentation sections.
  Color get markerNotes => warning;

  /// Resolves the bar fill color for a [SuperMarker] intent from this bundle.
  Color markerColor(SuperMarker marker) => switch (marker) {
    SuperMarker.identity => markerIdentity,
    SuperMarker.ledger => markerLedger,
    SuperMarker.notes => markerNotes,
  };

  /// A shared const instance carrying every GeniusLink default. Used as the
  /// fallback token bundle throughout the toolkit.
  static const SuperTokensData fallback = SuperTokensData();

  /// Returns a copy of this bundle with the given fields replaced.
  SuperTokensData copyWith({
    Color? accent,
    Color? accentHover,
    Color? accentPressed,
    Color? info,
    Color? success,
    Color? warning,
    Color? danger,
    String? displayFont,
    String? bodyFont,
    String? monoFont,
    String? arabicFont,
    double? radiusControl,
    double? radiusMd,
    double? radiusCard,
    double? radiusPill,
    double? space1,
    double? space2,
    double? space3,
    double? space4,
    double? space6,
    double? space8,
    double? space10,
    double? space16,
    double? space20,
    double? controlHeight,
    double? iconButton,
    double? markerWidth,
    double? markerHeight,
    double? contentColumn,
    double? fieldComfortable,
    double? fieldCompact,
    double? stepperSize,
    double? trailingIcon,
    Duration? durFast,
    Duration? durBase,
    Duration? durExpand,
    Curve? curveStandard,
    Curve? curveOut,
  }) => SuperTokensData(
    accent: accent ?? this.accent,
    accentHover: accentHover ?? this.accentHover,
    accentPressed: accentPressed ?? this.accentPressed,
    info: info ?? this.info,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    displayFont: displayFont ?? this.displayFont,
    bodyFont: bodyFont ?? this.bodyFont,
    monoFont: monoFont ?? this.monoFont,
    arabicFont: arabicFont ?? this.arabicFont,
    radiusControl: radiusControl ?? this.radiusControl,
    radiusMd: radiusMd ?? this.radiusMd,
    radiusCard: radiusCard ?? this.radiusCard,
    radiusPill: radiusPill ?? this.radiusPill,
    space1: space1 ?? this.space1,
    space2: space2 ?? this.space2,
    space3: space3 ?? this.space3,
    space4: space4 ?? this.space4,
    space6: space6 ?? this.space6,
    space8: space8 ?? this.space8,
    space10: space10 ?? this.space10,
    space16: space16 ?? this.space16,
    space20: space20 ?? this.space20,
    controlHeight: controlHeight ?? this.controlHeight,
    iconButton: iconButton ?? this.iconButton,
    markerWidth: markerWidth ?? this.markerWidth,
    markerHeight: markerHeight ?? this.markerHeight,
    contentColumn: contentColumn ?? this.contentColumn,
    fieldComfortable: fieldComfortable ?? this.fieldComfortable,
    fieldCompact: fieldCompact ?? this.fieldCompact,
    stepperSize: stepperSize ?? this.stepperSize,
    trailingIcon: trailingIcon ?? this.trailingIcon,
    durFast: durFast ?? this.durFast,
    durBase: durBase ?? this.durBase,
    durExpand: durExpand ?? this.durExpand,
    curveStandard: curveStandard ?? this.curveStandard,
    curveOut: curveOut ?? this.curveOut,
  );

  /// Linearly interpolates between two token bundles. Colors, doubles and
  /// durations interpolate; discrete values (font families, curves) snap at the
  /// midpoint.
  static SuperTokensData lerp(SuperTokensData a, SuperTokensData b, double t) {
    if (identical(a, b)) return a;
    double d(double x, double y) => x + (y - x) * t;
    Duration dur(Duration x, Duration y) => Duration(
      microseconds: (x.inMicroseconds +
              (y.inMicroseconds - x.inMicroseconds) * t)
          .round(),
    );
    final snapB = t >= 0.5;
    return SuperTokensData(
      accent: Color.lerp(a.accent, b.accent, t)!,
      accentHover: Color.lerp(a.accentHover, b.accentHover, t)!,
      accentPressed: Color.lerp(a.accentPressed, b.accentPressed, t)!,
      info: Color.lerp(a.info, b.info, t)!,
      success: Color.lerp(a.success, b.success, t)!,
      warning: Color.lerp(a.warning, b.warning, t)!,
      danger: Color.lerp(a.danger, b.danger, t)!,
      displayFont: snapB ? b.displayFont : a.displayFont,
      bodyFont: snapB ? b.bodyFont : a.bodyFont,
      monoFont: snapB ? b.monoFont : a.monoFont,
      arabicFont: snapB ? b.arabicFont : a.arabicFont,
      radiusControl: d(a.radiusControl, b.radiusControl),
      radiusMd: d(a.radiusMd, b.radiusMd),
      radiusCard: d(a.radiusCard, b.radiusCard),
      radiusPill: d(a.radiusPill, b.radiusPill),
      space1: d(a.space1, b.space1),
      space2: d(a.space2, b.space2),
      space3: d(a.space3, b.space3),
      space4: d(a.space4, b.space4),
      space6: d(a.space6, b.space6),
      space8: d(a.space8, b.space8),
      space10: d(a.space10, b.space10),
      space16: d(a.space16, b.space16),
      space20: d(a.space20, b.space20),
      controlHeight: d(a.controlHeight, b.controlHeight),
      iconButton: d(a.iconButton, b.iconButton),
      markerWidth: d(a.markerWidth, b.markerWidth),
      markerHeight: d(a.markerHeight, b.markerHeight),
      contentColumn: d(a.contentColumn, b.contentColumn),
      fieldComfortable: d(a.fieldComfortable, b.fieldComfortable),
      fieldCompact: d(a.fieldCompact, b.fieldCompact),
      stepperSize: d(a.stepperSize, b.stepperSize),
      trailingIcon: d(a.trailingIcon, b.trailingIcon),
      durFast: dur(a.durFast, b.durFast),
      durBase: dur(a.durBase, b.durBase),
      durExpand: dur(a.durExpand, b.durExpand),
      curveStandard: snapB ? b.curveStandard : a.curveStandard,
      curveOut: snapB ? b.curveOut : a.curveOut,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SuperTokensData &&
      other.accent == accent &&
      other.accentHover == accentHover &&
      other.accentPressed == accentPressed &&
      other.info == info &&
      other.success == success &&
      other.warning == warning &&
      other.danger == danger &&
      other.displayFont == displayFont &&
      other.bodyFont == bodyFont &&
      other.monoFont == monoFont &&
      other.arabicFont == arabicFont &&
      other.radiusControl == radiusControl &&
      other.radiusMd == radiusMd &&
      other.radiusCard == radiusCard &&
      other.radiusPill == radiusPill &&
      other.space1 == space1 &&
      other.space2 == space2 &&
      other.space3 == space3 &&
      other.space4 == space4 &&
      other.space6 == space6 &&
      other.space8 == space8 &&
      other.space10 == space10 &&
      other.space16 == space16 &&
      other.space20 == space20 &&
      other.controlHeight == controlHeight &&
      other.iconButton == iconButton &&
      other.markerWidth == markerWidth &&
      other.markerHeight == markerHeight &&
      other.contentColumn == contentColumn &&
      other.fieldComfortable == fieldComfortable &&
      other.fieldCompact == fieldCompact &&
      other.stepperSize == stepperSize &&
      other.trailingIcon == trailingIcon &&
      other.durFast == durFast &&
      other.durBase == durBase &&
      other.durExpand == durExpand &&
      other.curveStandard == curveStandard &&
      other.curveOut == curveOut;

  @override
  int get hashCode => Object.hashAll([
    accent,
    accentHover,
    accentPressed,
    info,
    success,
    warning,
    danger,
    displayFont,
    bodyFont,
    monoFont,
    arabicFont,
    radiusControl,
    radiusMd,
    radiusCard,
    radiusPill,
    space1,
    space2,
    space3,
    space4,
    space6,
    space8,
    space10,
    space16,
    space20,
    controlHeight,
    iconButton,
    markerWidth,
    markerHeight,
    contentColumn,
    fieldComfortable,
    fieldCompact,
    stepperSize,
    trailingIcon,
    durFast,
    durBase,
    durExpand,
    curveStandard,
    curveOut,
  ]);
}

/// The three intents a section-marker bar can express.
///
/// The concrete fill color is resolved from the ambient theme's
/// [SuperTokensData] (so it honors a customized palette) via [resolve]:
///
/// ```dart
/// final tokens = SuperThemeData.of(context).tokens;
/// color: SuperMarker.ledger.resolve(tokens);
/// ```
enum SuperMarker {
  /// Blue — identity / definition / details.
  identity,

  /// Green — financial / balance / ledger / transfer.
  ledger,

  /// Orange — notes / compliance / documentation.
  notes;

  /// The bar fill color for this intent, resolved dynamically from [tokens].
  /// There is no static default color — always resolve against the ambient
  /// theme's [SuperTokensData].
  Color resolve(SuperTokensData tokens) => tokens.markerColor(this);
}
