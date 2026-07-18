// ============================================================
// core/theme/super_tokens.dart
// ------------------------------------------------------------
// SuperTokensData — the DYNAMIC brand-token bundle for the GeniusLink design
// system. Prior to v2.0.0 these were compile-time `static const` values on an
// `abstract final class SuperTokens`; they are now instance fields on this
// immutable data class so a theme can override any of them.
//
// Every value has a built-in default (exposed as a `default*` constant) so the
// zero-argument `const SuperTokensData()` reproduces the historical GeniusLink
// values exactly. The bundle is carried by [SuperThemeData.tokens] (registered
// as a `ThemeExtension` by `SuperMaterialThemeData`) and surfaced directly as
// `SuperMaterialThemeData.tokens`, so every Super component reads brand tokens
// from the ambient theme via `SuperThemeData.of(context).tokens`.
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
/// Obtain the active bundle from the ambient theme:
///
/// ```dart
/// final tokens = SuperThemeData.of(context).tokens; // or theme.tokens
/// ```
///
/// Every field defaults to the historical GeniusLink value (see the `default*`
/// constants), so `const SuperTokensData()` is the canonical brand default and
/// `SuperTokensData.fallback` is a shared const instance of it. Override any
/// subset with [copyWith] or by passing `tokens:` to
/// `SuperMaterialThemeData.light` / `.dark`.
@immutable
class SuperTokensData {
  /// Creates a token bundle. Every parameter defaults to the GeniusLink brand
  /// value, so omitting all of them yields the canonical default theme.
  const SuperTokensData({
    this.accent = defaultAccent,
    this.accentHover = defaultAccentHover,
    this.accentPressed = defaultAccentPressed,
    this.success = defaultSuccess,
    this.warning = defaultWarning,
    this.danger = defaultDanger,
    this.displayFont = defaultDisplayFont,
    this.bodyFont = defaultBodyFont,
    this.monoFont = defaultMonoFont,
    this.arabicFont = defaultArabicFont,
    this.radiusControl = defaultRadiusControl,
    this.radiusMd = defaultRadiusMd,
    this.radiusCard = defaultRadiusCard,
    this.radiusPill = defaultRadiusPill,
    this.space1 = defaultSpace1,
    this.space2 = defaultSpace2,
    this.space3 = defaultSpace3,
    this.space4 = defaultSpace4,
    this.space6 = defaultSpace6,
    this.space8 = defaultSpace8,
    this.space10 = defaultSpace10,
    this.space16 = defaultSpace16,
    this.space20 = defaultSpace20,
    this.controlHeight = defaultControlHeight,
    this.iconButton = defaultIconButton,
    this.markerWidth = defaultMarkerWidth,
    this.markerHeight = defaultMarkerHeight,
    this.contentColumn = defaultContentColumn,
    this.fieldComfortable = defaultFieldComfortable,
    this.fieldCompact = defaultFieldCompact,
    this.stepperSize = defaultStepperSize,
    this.trailingIcon = defaultTrailingIcon,
    this.durFast = defaultDurFast,
    this.durBase = defaultDurBase,
    this.durExpand = defaultDurExpand,
    this.curveStandard = defaultCurveStandard,
    this.curveOut = defaultCurveOut,
  });

  // ── Default brand values (the historical `SuperTokens` constants) ─────────

  /// The single dominant electric-royal-blue accent — default [accent].
  static const Color defaultAccent = Color(0xFF4A7CFF);

  /// Default [accentHover] — the accent +6% lightness.
  static const Color defaultAccentHover = Color(0xFF5E8DFF);

  /// Default [accentPressed] — the accent darkened on press.
  static const Color defaultAccentPressed = Color(0xFF3D6DEB);

  /// Default [success] — ledger / balance green.
  static const Color defaultSuccess = Color(0xFF1DB88A);

  /// Default [warning] — notes / documentation orange.
  static const Color defaultWarning = Color(0xFFF97316);

  /// Default [danger] — destructive / error red.
  static const Color defaultDanger = Color(0xFFEF4444);

  /// Default [displayFont] — H1 page titles + watermark.
  static const String defaultDisplayFont = 'Manrope';

  /// Default [bodyFont] — headings, body, labels, captions (the workhorse).
  static const String defaultBodyFont = 'Inter';

  /// Default [monoFont] — numerics, serials, audit log.
  static const String defaultMonoFont = 'JetBrainsMono';

  /// Default [arabicFont] — Arabic glyphs.
  static const String defaultArabicFont = 'NotoNaskhArabic';

  /// Default radii (control 4 / md 6 / card 8 / pill 12).
  static const double defaultRadiusControl = 4;
  static const double defaultRadiusMd = 6;
  static const double defaultRadiusCard = 8;
  static const double defaultRadiusPill = 12;

  /// Default 4px-based spacing scale.
  static const double defaultSpace1 = 4;
  static const double defaultSpace2 = 8;
  static const double defaultSpace3 = 12;
  static const double defaultSpace4 = 16;
  static const double defaultSpace6 = 24;
  static const double defaultSpace8 = 32;
  static const double defaultSpace10 = 40;
  static const double defaultSpace16 = 64;
  static const double defaultSpace20 = 80;

  /// Default control metrics.
  static const double defaultControlHeight = 40;
  static const double defaultIconButton = 32;
  static const double defaultMarkerWidth = 4;
  static const double defaultMarkerHeight = 40;
  static const double defaultContentColumn = 680;
  static const double defaultFieldComfortable = 42;
  static const double defaultFieldCompact = 36;
  static const double defaultStepperSize = 24;
  static const double defaultTrailingIcon = 26;

  /// Default motion (durations + curves).
  static const Duration defaultDurFast = Duration(milliseconds: 100);
  static const Duration defaultDurBase = Duration(milliseconds: 150);
  static const Duration defaultDurExpand = Duration(milliseconds: 200);
  static const Curve defaultCurveStandard = Cubic(0.4, 0, 0.2, 1);
  static const Curve defaultCurveOut = Cubic(0, 0, 0.2, 1);

  // ── Brand + semantic palette ──────────────────────────────────────────────

  /// The single dominant electric-royal-blue accent.
  final Color accent;

  /// The accent lightened ~6% for hover states.
  final Color accentHover;

  /// The accent darkened for pressed states.
  final Color accentPressed;

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
  identity(SuperTokensData.defaultAccent),

  /// Green — financial / balance / ledger / transfer.
  ledger(SuperTokensData.defaultSuccess),

  /// Orange — notes / compliance / documentation.
  notes(SuperTokensData.defaultWarning);

  const SuperMarker(this.defaultColor);

  /// The built-in default fill color for this intent (the GeniusLink brand
  /// value). Prefer [resolve] to honor a customized [SuperTokensData].
  final Color defaultColor;

  /// The bar fill color for this intent, resolved from [tokens].
  Color resolve(SuperTokensData tokens) => tokens.markerColor(this);
}
