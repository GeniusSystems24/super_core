// ============================================================
// core/theme/super_tokens.dart
// ------------------------------------------------------------
// SuperTokensData — the DYNAMIC brand-token bundle for the GeniusLink design
// system: the accent + semantic palette, the font families, the section-marker
// bar dimensions, and the motion curves. Prior to v2.0.0 these were compile-time
// `static const` values on an `abstract final class SuperTokens`; they are now
// instance fields on this immutable data class so a theme can override any of
// them. There are NO static token constants — the only default values are the
// literals baked into the constructor, and the sole default *instance* is
// [SuperTokensData.fallback].
//
// The spacing scale, corner radii, control heights and container insets moved
// out of this bundle in v3.0.0 — read them from [SuperSpacing] instead
// (`SuperThemeData.of(context).spacing`). SuperTokensData now carries only the
// brand identity: colors, fonts, motion and the marker-bar geometry.
//
// The bundle is carried by [SuperThemeData.tokens] (registered as a
// `ThemeExtension` by `SuperMaterialThemeData`) and surfaced directly as
// `SuperMaterialThemeData.tokens`, so every Super component reads brand tokens
// from the ambient theme via `SuperThemeData.of(context).tokens` — never from a
// static constant.
//
//   final tokens = SuperThemeData.of(context).tokens;
//   color: SuperMarker.ledger.resolve(tokens);
//
// Ported from `colors_and_type.css`.
// ============================================================

import 'package:flutter/widgets.dart';

/// An immutable bundle of the theme-level GeniusLink brand tokens — the accent
/// + semantic palette, font families, the section-marker bar dimensions, and
/// the motion curves.
///
/// Read the active bundle from the ambient theme — there are no static token
/// constants to reach for:
///
/// ```dart
/// final tokens = SuperThemeData.of(context).tokens; // or theme.tokens
/// ```
///
/// Spacing, radii, control heights and insets live in [SuperSpacing]
/// (`SuperThemeData.of(context).spacing`), not here.
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
    this.markerWidth = 4,
    this.markerHeight = 34,
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

  // ── Section-marker geometry ───────────────────────────────────────────────

  /// Section-marker bar width.
  final double markerWidth;

  /// Section-marker bar height for a title + subtitle header. A title-only
  /// header uses an 18px bar sized to its cap height.
  final double markerHeight;

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
    double? markerWidth,
    double? markerHeight,
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
    markerWidth: markerWidth ?? this.markerWidth,
    markerHeight: markerHeight ?? this.markerHeight,
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
      microseconds:
          (x.inMicroseconds + (y.inMicroseconds - x.inMicroseconds) * t)
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
      markerWidth: d(a.markerWidth, b.markerWidth),
      markerHeight: d(a.markerHeight, b.markerHeight),
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
      other.markerWidth == markerWidth &&
      other.markerHeight == markerHeight &&
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
    markerWidth,
    markerHeight,
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
