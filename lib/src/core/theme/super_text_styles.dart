// ============================================================
// core/theme/super_text_styles.dart
// ------------------------------------------------------------
// SuperTextTheme — the GeniusLink type ramp as a full Material [TextTheme]
// subclass. Extends [TextTheme] so it can be passed directly to any Flutter
// widget that accepts a [TextTheme] (MaterialApp, ThemeData, etc.) while
// also exposing the branded names used across the Super design system:
// displayLg, headlineSm, titleMd, bodyLg, bodySm, labelMd, labelSm, mono,
// eyebrow, heading, body, label, caption, button, pill, h1.
//
// Build from the ambient tokens:
//   final tt = context.superTheme.textTheme;          // colorless
//   Text('Hello', style: tt.titleMd.copyWith(color: t.fg1));
//
// The Material ThemeData.textTheme is also a colored SuperTextTheme when
// SuperMaterialThemeData is used, so:
//   TextTheme.of(context).titleMedium  // works everywhere
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'super_tokens.dart';

/// The GeniusLink type ramp as a [TextTheme] subclass.
///
/// All 15 standard Material slots are populated; branded getters provide
/// convenient named access. Colorless by default — apply `fg*` tokens at each
/// call site with `.copyWith(color: t.fg1)`, or obtain a pre-colored instance
/// via [colorize].
class SuperTextTheme extends TextTheme {
  const SuperTextTheme._({
    required this.displayLg,
    required this.headlineSm,
    required this.titleMd,
    required this.bodyLg,
    required this.bodySm,
    required this.labelMd,
    required this.labelSm,
    required this.mono,
    required this.eyebrow,
    // Extra params for the remaining TextTheme slots.
    required TextStyle displayMediumStyle,
    required TextStyle displaySmallStyle,
    required TextStyle headlineLargeStyle,
    required TextStyle headlineMediumStyle,
    required TextStyle titleLargeStyle,
    required TextStyle titleSmallStyle,
    required TextStyle captionStyle,
    required TextStyle buttonStyle,
  }) : super(
         displayLarge: displayLg,
         displayMedium: displayMediumStyle,
         displaySmall: displaySmallStyle,
         headlineLarge: headlineLargeStyle,
         headlineMedium: headlineMediumStyle,
         headlineSmall: headlineSm,
         titleLarge: titleLargeStyle,
         titleMedium: titleMd,
         titleSmall: titleSmallStyle,
         bodyLarge: bodyLg,
         bodyMedium: bodySm,
         bodySmall: captionStyle,
         labelLarge: buttonStyle,
         labelMedium: labelMd,
         labelSmall: labelSm,
       );

  // ── Branded ramp (GeniusTextTokens equivalent) ────────────────────────────

  /// Display / hero title — Manrope 56/700 (mobile) or 48/700 (desktop).
  final TextStyle displayLg;

  /// Headline — Manrope 24/700 (mobile) or 22/700 (desktop).
  final TextStyle headlineSm;

  /// Section / card title — Manrope 18/600 (mobile) or 16/600 (desktop).
  ///
  /// Maps to [TextTheme.titleMedium].
  final TextStyle titleMd;

  /// Body large — Inter 16/400 (mobile) or 14/400 (desktop).
  ///
  /// Maps to [TextTheme.bodyLarge].
  final TextStyle bodyLg;

  /// Body standard — Inter 14/400 (mobile) or 13/400 (desktop).
  ///
  /// Maps to [TextTheme.bodyMedium].
  final TextStyle bodySm;

  /// Label medium — Inter 12/600 (mobile) or 11/600 (desktop).
  ///
  /// Maps to [TextTheme.labelMedium].
  final TextStyle labelMd;

  /// Label small — Inter 10/500 (mobile) or 9/500 (desktop).
  ///
  /// Maps to [TextTheme.labelSmall].
  final TextStyle labelSm;

  // ── Extra styles (no direct Material TextTheme slot) ──────────────────────

  /// Monospace face — JetBrains Mono, tabular figures. For numerics, serials,
  /// audit-log entries. Not part of the Material TextTheme ramp.
  final TextStyle mono;

  /// Breadcrumb / eyebrow — Inter 11/700, very wide tracking (~0.15em).
  /// Not part of the Material TextTheme ramp.
  final TextStyle eyebrow;

  // ── Convenience getters (drop-in replacements for the old SuperText class) ─

  /// Page / dialog heading — [TextTheme.titleLarge].
  TextStyle get h1 => titleLarge!;

  /// Section heading — [titleMd] / [TextTheme.titleMedium].
  TextStyle get heading => titleMedium!;

  /// Standard body copy — [bodySm] / [TextTheme.bodyMedium].
  TextStyle get body => bodyMedium!;

  /// Form label / table header — [labelMd] / [TextTheme.labelMedium].
  TextStyle get label => labelMedium!;

  /// Small caption / hint — [TextTheme.bodySmall].
  TextStyle get caption => bodySmall!;

  /// Button / CTA text — [TextTheme.labelLarge].
  TextStyle get button => labelLarge!;

  /// Status-pill text — [labelSm] / [TextTheme.labelSmall].
  TextStyle get pill => labelSmall!;

  // ── Factory ───────────────────────────────────────────────────────────────

  /// Builds the ramp from [tokens] for the given device density and locale.
  ///
  /// [isDesktop] selects tighter Windows-density metrics; pass
  /// `mode == SuperDeviceMode.desktop` from a [SuperThemeData].
  ///
  /// [isArabic] switches body and display faces to `NotoNaskhArabic`.
  factory SuperTextTheme.fromTokens(
    SuperTokensData tokens, {
    bool isDesktop = false,
    bool isArabic = false,
  }) {
    final TextStyle b = isArabic
        ? GoogleFonts.notoNaskhArabic()
        : GoogleFonts.inter();
    final TextStyle d = isArabic
        ? GoogleFonts.notoNaskhArabic()
        : GoogleFonts.manrope();

    if (isDesktop) {
      return SuperTextTheme._(
        displayLg: d.copyWith(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          height: 1.12,
        ),
        headlineSm: d.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleMd: d.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
        bodyLg: b.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodySm: b.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        labelMd: b.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.25,
          letterSpacing: 0.5,
        ),
        labelSm: b.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          height: 1.25,
          letterSpacing: 0.4,
        ),
        mono: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 13,
          height: 1.35,
          fontWeight: FontWeight.w400,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        eyebrow: b.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: 1.5,
        ),
        displayMediumStyle: d.copyWith(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          height: 1.14,
        ),
        displaySmallStyle: d.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.18,
        ),
        headlineLargeStyle: d.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.22,
        ),
        headlineMediumStyle: d.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        titleLargeStyle: d.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        titleSmallStyle: b.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
        captionStyle: b.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          height: 1.35,
        ),
        buttonStyle: b.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      );
    }
    return SuperTextTheme._(
      displayLg: d.copyWith(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      headlineSm: d.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      titleMd: d.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLg: b.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySm: b.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      labelMd: b.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.6,
      ),
      labelSm: b.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.5,
      ),
      mono: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 14,
        height: 1.35,
        fontWeight: FontWeight.w400,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
      eyebrow: b.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 1.65,
      ),
      displayMediumStyle: d.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.14,
      ),
      displaySmallStyle: d.copyWith(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        height: 1.18,
      ),
      headlineLargeStyle: d.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.22,
      ),
      headlineMediumStyle: d.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      titleLargeStyle: d.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.3,
      ),
      titleSmallStyle: b.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      captionStyle: b.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
      ),
      buttonStyle: b.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }

  // ── Color application ─────────────────────────────────────────────────────

  /// Returns a copy with primary styles colored [fg1] and subtler styles
  /// (labelSm, eyebrow, caption) colored [fg3].
  SuperTextTheme colorize(Color fg1, Color fg3) {
    TextStyle p(TextStyle s) => s.copyWith(color: fg1);
    TextStyle q(TextStyle s) => s.copyWith(color: fg3);
    return SuperTextTheme._(
      displayLg: p(displayLg),
      headlineSm: p(headlineSm),
      titleMd: p(titleMd),
      bodyLg: p(bodyLg),
      bodySm: p(bodySm),
      labelMd: p(labelMd),
      labelSm: q(labelSm),
      mono: p(mono),
      eyebrow: q(eyebrow),
      displayMediumStyle: p(displayMedium!),
      displaySmallStyle: p(displaySmall!),
      headlineLargeStyle: p(headlineLarge!),
      headlineMediumStyle: p(headlineMedium!),
      titleLargeStyle: p(titleLarge!),
      titleSmallStyle: p(titleSmall!),
      captionStyle: q(bodySmall!),
      buttonStyle: p(labelLarge!),
    );
  }

  // ── superCopyWith ─────────────────────────────────────────────────────────

  /// Returns a copy with the given branded fields replaced, preserving all
  /// TextTheme slot mappings.
  SuperTextTheme superCopyWith({
    TextStyle? displayLg,
    TextStyle? headlineSm,
    TextStyle? titleMd,
    TextStyle? bodyLg,
    TextStyle? bodySm,
    TextStyle? labelMd,
    TextStyle? labelSm,
    TextStyle? mono,
    TextStyle? eyebrow,
  }) => SuperTextTheme._(
    displayLg: displayLg ?? this.displayLg,
    headlineSm: headlineSm ?? this.headlineSm,
    titleMd: titleMd ?? this.titleMd,
    bodyLg: bodyLg ?? this.bodyLg,
    bodySm: bodySm ?? this.bodySm,
    labelMd: labelMd ?? this.labelMd,
    labelSm: labelSm ?? this.labelSm,
    mono: mono ?? this.mono,
    eyebrow: eyebrow ?? this.eyebrow,
    displayMediumStyle: displayMedium!,
    displaySmallStyle: displaySmall!,
    headlineLargeStyle: headlineLarge!,
    headlineMediumStyle: headlineMedium!,
    titleLargeStyle: titleLarge!,
    titleSmallStyle: titleSmall!,
    captionStyle: bodySmall!,
    buttonStyle: labelLarge!,
  );
}
