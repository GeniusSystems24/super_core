// ============================================================
// core/theme/super_color_utils.dart
// ------------------------------------------------------------
// Color utilities for the GeniusLink design system: hex parsing / formatting,
// perceptual tonal operations (lighten / darken / mix / tone), and WCAG 2.1
// contrast helpers used to pick legible on-colors.
//
// Everything is exposed as the `SuperColorX` extension on [Color] plus a few
// statics on it (`SuperColorX.fromHex`, `SuperColorX.tryFromHex`). Flutter's
// `Color.computeLuminance()` already returns the WCAG relative luminance, so the
// contrast math builds directly on it.
//
//   final c   = SuperColorX.fromHex('#4A7CFF');
//   final hex = c.toHex();                 // '#4A7CFF'
//   final on  = c.onColor();               // white or near-black by contrast
//   final ok  = c.contrastRatio(on) >= 4.5;// WCAG AA body text
// ============================================================

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// GeniusLink default light on-color (near-black slate `#0F172A`).
const Color _kOnLight = Color(0xFF0F172A);

/// GeniusLink default dark on-color (white).
const Color _kOnDark = Color(0xFFFFFFFF);

/// Color helpers used across the Super toolkit.
///
/// Tonal operations run in HSL space (perceptually smoother than raw RGB
/// scaling); contrast helpers follow WCAG 2.1 using [Color.computeLuminance].
extension SuperColorX on Color {
  // ── Hex ────────────────────────────────────────────────────────────────────

  /// Parses a hex string into a [Color]. Accepts `#RGB`, `#RRGGBB`,
  /// `#AARRGGBB`, with or without a leading `#` / `0x`. Throws [FormatException]
  /// on malformed input — use [tryFromHex] for a null-returning variant.
  static Color fromHex(String hex) {
    final c = tryFromHex(hex);
    if (c == null) {
      throw FormatException('Not a valid hex color', hex);
    }
    return c;
  }

  /// Like [fromHex] but returns `null` instead of throwing on bad input.
  static Color? tryFromHex(String hex) {
    var s = hex.trim().toUpperCase();
    if (s.startsWith('#')) s = s.substring(1);
    if (s.startsWith('0X')) s = s.substring(2);
    if (s.length == 3) {
      s = s.split('').map((ch) => '$ch$ch').join(); // RGB -> RRGGBB
    }
    if (s.length == 6) s = 'FF$s'; // add opaque alpha
    if (s.length != 8) return null;
    final v = int.tryParse(s, radix: 16);
    return v == null ? null : Color(v);
  }

  /// Formats this color as an uppercase hex string.
  ///
  /// [leadingHash] prepends `#`; [includeAlpha] emits `#AARRGGBB` instead of
  /// `#RRGGBB`.
  String toHex({bool leadingHash = true, bool includeAlpha = false}) {
    final argb = toARGB32();
    final body = includeAlpha
        ? argb.toRadixString(16).padLeft(8, '0')
        : (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '${leadingHash ? '#' : ''}${body.toUpperCase()}';
  }

  // ── Tonal operations (HSL) ───────────────────────────────────────────────────

  /// Returns this color with lightness increased by [amount] (0–1).
  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Returns this color with lightness decreased by [amount] (0–1).
  Color darken([double amount = 0.1]) => lighten(-amount);

  /// Returns this color with saturation increased by [amount] (0–1).
  Color saturate([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withSaturation((hsl.saturation + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Returns this color with saturation decreased by [amount] (0–1).
  Color desaturate([double amount = 0.1]) => saturate(-amount);

  /// Linearly interpolates toward [other] by [t] (0 = this, 1 = other).
  Color mix(Color other, [double t = 0.5]) => Color.lerp(this, other, t)!;

  /// Mixes toward white ([t] > 0) or black ([t] < 0) — a quick "tone" nudge that
  /// preserves hue better than [lighten] for near-white / near-black inputs.
  Color tone(double t) => t >= 0
      ? mix(const Color(0xFFFFFFFF), t)
      : mix(const Color(0xFF000000), -t);

  /// This color blended over [background] at [opacity], yielding an opaque tint
  /// (mirrors the web `color-mix(... this N%, background)` idiom).
  Color tintOver(Color background, [double opacity = 0.14]) =>
      Color.alphaBlend(withValues(alpha: opacity), background);

  // ── WCAG contrast ──────────────────────────────────────────────────────────

  /// The WCAG 2.1 contrast ratio between this color and [other] (1.0–21.0).
  double contrastRatio(Color other) {
    final l1 = computeLuminance();
    final l2 = other.computeLuminance();
    final hi = math.max(l1, l2);
    final lo = math.min(l1, l2);
    return (hi + 0.05) / (lo + 0.05);
  }

  /// Whether text of [other] on this background meets WCAG AA
  /// (4.5:1 normal, 3.0:1 for [largeText]).
  bool meetsAA(Color other, {bool largeText = false}) =>
      contrastRatio(other) >= (largeText ? 3.0 : 4.5);

  /// Whether text of [other] on this background meets WCAG AAA
  /// (7.0:1 normal, 4.5:1 for [largeText]).
  bool meetsAAA(Color other, {bool largeText = false}) =>
      contrastRatio(other) >= (largeText ? 4.5 : 7.0);

  /// Picks the more legible foreground for text placed **on** this color —
  /// whichever of [dark] / [light] has the higher contrast ratio. Defaults to
  /// the GeniusLink near-black slate and white.
  Color onColor({Color dark = _kOnLight, Color light = _kOnDark}) =>
      contrastRatio(dark) >= contrastRatio(light) ? dark : light;

  /// Returns whichever of [candidates] has the highest contrast **on** this
  /// color (i.e. treats `this` as the background). Falls back to [onColor] when
  /// [candidates] is empty.
  Color bestForegroundFrom(Iterable<Color> candidates) {
    Color? best;
    double bestRatio = -1;
    for (final c in candidates) {
      final r = contrastRatio(c);
      if (r > bestRatio) {
        bestRatio = r;
        best = c;
      }
    }
    return best ?? onColor();
  }
}
