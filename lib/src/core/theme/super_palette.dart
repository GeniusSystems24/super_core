// ============================================================
// core/theme/super_palette.dart
// ------------------------------------------------------------
// SuperPalette — swappable color palette for the GeniusLink design system.
// Provides six built-in palettes, each with 10 shades (50–900) and semantic
// accessors. Pass a palette to SuperMaterialThemeData.light / .dark to
// generate a complete Material 3 ThemeData.
// ============================================================

import 'package:flutter/material.dart';

/// A complete color palette — 10 ordered shades plus derived semantic tokens.
///
/// Six palettes ship with super_core:
/// - [SuperPalette.bluePalette]       — default GeniusLink electric-blue accent
/// - [SuperPalette.purplePalette]     — violet / indigo
/// - [SuperPalette.greenPalette]      — GeniusLink success green
/// - [SuperPalette.goldenPalette]     — warm amber / gold
/// - [SuperPalette.grayPalette]       — neutral grays (GeniusLink surface ramp)
/// - [SuperPalette.monochromePalette] — pure black / white
///
/// All six palettes share the same neutral GeniusLink dark/light surfaces;
/// only the accent (primary) varies between them. This preserves the
/// precision-instrument feel of the design system regardless of accent choice.
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme:     SuperMaterialThemeData.light(palette: SuperPalette.bluePalette),
///   darkTheme: SuperMaterialThemeData.dark(palette: SuperPalette.bluePalette),
/// );
/// ```
@immutable
class SuperPalette {
  const SuperPalette({
    required this.name,
    required this.shade50,
    required this.shade100,
    required this.shade200,
    required this.shade300,
    required this.shade400,
    required this.shade500,
    required this.shade600,
    required this.shade700,
    required this.shade800,
    required this.shade900,
  });

  /// Human-readable label used in debug output and the example UI.
  final String name;

  // ── 10-step ramp, lightest → darkest ──────────────────────────────────────
  final Color shade50;
  final Color shade100;
  final Color shade200;
  final Color shade300;
  final Color shade400;

  /// The canonical primary / brand color for this palette.
  final Color shade500;

  final Color shade600;
  final Color shade700;
  final Color shade800;
  final Color shade900;

  // ── Semantic convenience getters ──────────────────────────────────────────

  /// Primary brand color for light mode — [shade500].
  Color get primary => shade500;

  /// Primary brand color for dark mode — [shade300] (lighter for contrast).
  Color get primaryDark => shade300;

  /// Foreground on [primary] in light mode (white or near-black by luminance).
  Color get onPrimary => _onColor(shade500);

  /// Foreground on [primaryDark] — always [shade900].
  Color get onPrimaryDark => shade900;

  // ── Cross-palette semantic colors (GeniusLink standard) ──────────────────
  // These are identical across all palettes — they are GeniusLink brand tokens.

  /// Error / danger — GeniusLink red `#EF4444`.
  Color get error => const Color(0xFFEF4444);

  /// Error in dark mode (softened) — `#F87171`.
  Color get errorDark => const Color(0xFFF87171);

  /// Success / ledger — GeniusLink green `#1DB88A`.
  Color get success => const Color(0xFF1DB88A);

  /// Warning / notes — GeniusLink orange `#F97316`.
  Color get warning => const Color(0xFFF97316);

  // ── GeniusLink-standard neutral surface tokens ────────────────────────────
  // All six palettes share these surfaces; accent/primary is the only variable.

  // Light surfaces
  static const Color _lightBg        = Color(0xFFF7F8FA);
  static const Color _lightSurface   = Color(0xFFFFFFFF);
  static const Color _lightInputBg   = Color(0xFFF1F3F8);
  static const Color _lightHover     = Color(0xFFEEF1F7);
  static const Color _lightBorder    = Color(0xFFE2E8F0);
  static const Color _lightBorderStr = Color(0xFFC2C6D6);
  static const Color _lightFg1       = Color(0xFF0F172A);
  static const Color _lightFg2       = Color(0xFF424754);
  static const Color _lightFg3       = Color(0xFF64748B);
  static const Color _lightFg4       = Color(0xFFAEB4C2);

  // Dark surfaces
  static const Color _darkBg         = Color(0xFF111318);
  static const Color _darkSurface    = Color(0xFF1E2025);
  static const Color _darkSurface2   = Color(0xFF292D38);
  static const Color _darkInputBg    = Color(0xFF33353A);
  static const Color _darkHover      = Color(0xFF2F3540);
  static const Color _darkBorder     = Color(0x6643464F);
  static const Color _darkBorderStr  = Color(0xFF434654);
  static const Color _darkFg1        = Color(0xFFE2E2E9);
  static const Color _darkFg2        = Color(0xFFC3C6D7);
  static const Color _darkFg3        = Color(0xFF8D90A0);
  static const Color _darkFg4        = Color(0xFF5A5D68);

  // ── Surface token accessors (used by SuperMaterialThemeData) ──────────────

  Color get lightBg        => _lightBg;
  Color get lightSurface   => _lightSurface;
  Color get lightInputBg   => _lightInputBg;
  Color get lightHover     => _lightHover;
  Color get lightBorder    => _lightBorder;
  Color get lightBorderStr => _lightBorderStr;
  Color get lightFg1       => _lightFg1;
  Color get lightFg2       => _lightFg2;
  Color get lightFg3       => _lightFg3;
  Color get lightFg4       => _lightFg4;

  Color get darkBg         => _darkBg;
  Color get darkSurface    => _darkSurface;
  Color get darkSurface2   => _darkSurface2;
  Color get darkInputBg    => _darkInputBg;
  Color get darkHover      => _darkHover;
  Color get darkBorder     => _darkBorder;
  Color get darkBorderStr  => _darkBorderStr;
  Color get darkFg1        => _darkFg1;
  Color get darkFg2        => _darkFg2;
  Color get darkFg3        => _darkFg3;
  Color get darkFg4        => _darkFg4;

  // ── ColorScheme generation ────────────────────────────────────────────────

  /// Generates a [ColorScheme] tuned for light [ThemeData].
  ///
  /// Primary and container colors are derived from this palette's shades.
  /// Surface tokens use the GeniusLink-standard neutral light ramp so all
  /// palettes maintain the same high-contrast precision-instrument feel.
  ColorScheme toLightColorScheme() => ColorScheme(
        brightness: Brightness.light,
        primary: shade500,
        onPrimary: _onColor(shade500),
        primaryContainer: shade100,
        onPrimaryContainer: shade800,
        secondary: shade600,
        onSecondary: _onColor(shade600),
        secondaryContainer: shade50,
        onSecondaryContainer: shade700,
        tertiary: shade400,
        onTertiary: _onColor(shade400),
        tertiaryContainer: shade100,
        onTertiaryContainer: shade700,
        error: error,
        onError: const Color(0xFFFFFFFF),
        errorContainer: const Color(0xFFFEE2E2),
        onErrorContainer: const Color(0xFF7F1D1D),
        // Fixed accent roles (identical across light & dark, per Material 3)
        primaryFixed: shade100,
        primaryFixedDim: shade200,
        onPrimaryFixed: shade900,
        onPrimaryFixedVariant: shade700,
        secondaryFixed: shade100,
        secondaryFixedDim: shade200,
        onSecondaryFixed: shade900,
        onSecondaryFixedVariant: shade700,
        tertiaryFixed: shade100,
        tertiaryFixedDim: shade200,
        onTertiaryFixed: shade900,
        onTertiaryFixedVariant: shade700,
        // Surfaces — neutral GeniusLink standard.
        // `surface` is the base page background (the Scaffold color); cards,
        // panels and fields sit ABOVE it on the brighter surfaceContainer ramp
        // so they stay clearly separated from the Scaffold.
        background: _lightBg,
        onBackground: _lightFg1,
        surface: _lightBg,
        onSurface: _lightFg1,
        surfaceVariant: _lightInputBg,
        onSurfaceVariant: _lightFg2,
        // Surface container ramp — brightest (lowest) → dimmest (highest).
        // Cards default to surfaceContainerLowest (#FFFFFF), clearly lifted off
        // the #F7F8FA page background.
        surfaceDim: const Color(0xFFDFE3EC),
        surfaceBright: _lightSurface,
        surfaceContainerLowest: _lightSurface,
        surfaceContainerLow: const Color(0xFFF4F6FA),
        surfaceContainer: _lightHover,
        surfaceContainerHigh: const Color(0xFFE7EAF1),
        surfaceContainerHighest: const Color(0xFFDFE3EC),
        // Inverse
        inverseSurface: _darkSurface,
        onInverseSurface: _darkFg1,
        inversePrimary: shade200,
        // Borders / outlines
        outline: _lightBorder,
        outlineVariant: _lightBorderStr,
        // Shadows
        shadow: const Color(0xFF000000),
        scrim: const Color(0xFF000000),
        // Surface tint — disabled per GeniusLink flat-surface spec
        surfaceTint: Colors.transparent,
      );

  /// Generates a [ColorScheme] tuned for dark [ThemeData].
  ///
  /// Primary becomes [shade300] for legibility on dark surfaces.
  /// Surface tokens use the GeniusLink-standard near-black neutral ramp.
  ColorScheme toDarkColorScheme() => ColorScheme(
        brightness: Brightness.dark,
        primary: shade300,
        onPrimary: shade900,
        primaryContainer: shade700,
        onPrimaryContainer: shade100,
        secondary: shade400,
        onSecondary: shade900,
        secondaryContainer: _darkSurface2,
        onSecondaryContainer: shade200,
        tertiary: shade300,
        onTertiary: shade900,
        tertiaryContainer: shade700,
        onTertiaryContainer: shade100,
        error: errorDark,
        onError: const Color(0xFF7F1D1D),
        errorContainer: const Color(0xFF991B1B),
        onErrorContainer: const Color(0xFFFEE2E2),
        // Fixed accent roles (identical across light & dark, per Material 3)
        primaryFixed: shade100,
        primaryFixedDim: shade200,
        onPrimaryFixed: shade900,
        onPrimaryFixedVariant: shade700,
        secondaryFixed: shade100,
        secondaryFixedDim: shade200,
        onSecondaryFixed: shade900,
        onSecondaryFixedVariant: shade700,
        tertiaryFixed: shade100,
        tertiaryFixedDim: shade200,
        onTertiaryFixed: shade900,
        onTertiaryFixedVariant: shade700,
        // Surfaces — neutral GeniusLink standard (dark).
        // `surface` is the near-black base page background (the Scaffold color);
        // cards, panels and fields sit ABOVE it on the brighter surfaceContainer
        // ramp so they stay clearly separated from the Scaffold.
        background: _darkBg,
        onBackground: _darkFg1,
        surface: _darkBg,
        onSurface: _darkFg1,
        surfaceVariant: _darkInputBg,
        onSurfaceVariant: _darkFg3,
        // Surface container ramp — dimmest (lowest) → brightest (highest).
        // Cards default to surfaceContainer (#1E2025), clearly lifted off the
        // #111318 page background.
        surfaceDim: const Color(0xFF0C0D10),
        surfaceBright: const Color(0xFF35373D),
        surfaceContainerLowest: const Color(0xFF0C0D10),
        surfaceContainerLow: const Color(0xFF16181D),
        surfaceContainer: _darkSurface,
        surfaceContainerHigh: const Color(0xFF24262C),
        surfaceContainerHighest: _darkSurface2,
        // Inverse
        inverseSurface: _lightSurface,
        onInverseSurface: _lightFg1,
        inversePrimary: shade600,
        // Borders / outlines
        outline: _darkBorderStr,
        outlineVariant: _darkBorder,
        // Shadows
        shadow: const Color(0xFF000000),
        scrim: const Color(0xFF000000),
        // Surface tint — disabled per GeniusLink flat-surface spec
        surfaceTint: Colors.transparent,
      );

  // ── Internal helpers ──────────────────────────────────────────────────────

  /// Returns white or near-black foreground for legibility on [bg].
  static Color _onColor(Color bg) => bg.computeLuminance() > 0.35
      ? const Color(0xFF0F172A)
      : const Color(0xFFFFFFFF);

  // ── Built-in palette instances ────────────────────────────────────────────

  /// Default GeniusLink electric-royal-blue accent palette.
  ///
  /// shade500 = #4A7CFF — matches SuperTokens.accent exactly.
  static const SuperPalette bluePalette = SuperPalette(
    name: 'Blue',
    shade50:  Color(0xFFEEF2FF),
    shade100: Color(0xFFE0E9FF),
    shade200: Color(0xFFC7D5FF),
    shade300: Color(0xFFA3B9FF),
    shade400: Color(0xFF7A9AFF),
    shade500: Color(0xFF4A7CFF), // SuperTokens.accent
    shade600: Color(0xFF3D6DEB), // SuperTokens.accentPressed
    shade700: Color(0xFF2F57CC),
    shade800: Color(0xFF2240A3),
    shade900: Color(0xFF162D7A),
  );

  /// Violet / indigo palette — harmonious with [bluePalette].
  static const SuperPalette purplePalette = SuperPalette(
    name: 'Purple',
    shade50:  Color(0xFFF3F0FF),
    shade100: Color(0xFFE9E4FF),
    shade200: Color(0xFFD4CAFF),
    shade300: Color(0xFFB8AAFF),
    shade400: Color(0xFF9C88FF),
    shade500: Color(0xFF7C5CFC),
    shade600: Color(0xFF6A47F0),
    shade700: Color(0xFF5535D4),
    shade800: Color(0xFF4226AD),
    shade900: Color(0xFF2D1785),
  );

  /// GeniusLink success-green palette.
  ///
  /// shade500 = #1DB88A — matches SuperTokens.success exactly.
  static const SuperPalette greenPalette = SuperPalette(
    name: 'Green',
    shade50:  Color(0xFFE8FBF5),
    shade100: Color(0xFFCDF7E9),
    shade200: Color(0xFF9AEFD3),
    shade300: Color(0xFF60E4BA),
    shade400: Color(0xFF2ED0A1),
    shade500: Color(0xFF1DB88A), // SuperTokens.success
    shade600: Color(0xFF179A73),
    shade700: Color(0xFF117C5C),
    shade800: Color(0xFF0C5E47),
    shade900: Color(0xFF084032),
  );

  /// Warm amber / gold palette.
  static const SuperPalette goldenPalette = SuperPalette(
    name: 'Golden',
    shade50:  Color(0xFFFFFBEB),
    shade100: Color(0xFFFEF3C7),
    shade200: Color(0xFFFDE68A),
    shade300: Color(0xFFFCD34D),
    shade400: Color(0xFFFBBF24),
    shade500: Color(0xFFF59E0B),
    shade600: Color(0xFFD97706),
    shade700: Color(0xFFB45309),
    shade800: Color(0xFF92400E),
    shade900: Color(0xFF78350F),
  );

  /// Neutral gray palette — mirrors the GeniusLink surface ramp exactly.
  ///
  /// shade900 = dark bg (#111318), shade800 = dark card (#1E2025),
  /// shade50  = light bg (#F7F8FA).
  static const SuperPalette grayPalette = SuperPalette(
    name: 'Gray',
    shade50:  Color(0xFFF7F8FA),
    shade100: Color(0xFFEEF1F7),
    shade200: Color(0xFFE2E8F0),
    shade300: Color(0xFFC2C6D6),
    shade400: Color(0xFF8D90A0),
    shade500: Color(0xFF64748B),
    shade600: Color(0xFF434654),
    shade700: Color(0xFF33353A),
    shade800: Color(0xFF1E2025),
    shade900: Color(0xFF111318),
  );

  /// Pure black / white monochrome palette — maximum neutrality.
  static const SuperPalette monochromePalette = SuperPalette(
    name: 'Monochrome',
    shade50:  Color(0xFFFAFAFA),
    shade100: Color(0xFFF5F5F5),
    shade200: Color(0xFFE5E5E5),
    shade300: Color(0xFFD4D4D4),
    shade400: Color(0xFFA3A3A3),
    shade500: Color(0xFF737373),
    shade600: Color(0xFF525252),
    shade700: Color(0xFF404040),
    shade800: Color(0xFF262626),
    shade900: Color(0xFF171717),
  );

  /// All six built-in palettes in display order.
  static const List<SuperPalette> values = [
    bluePalette,
    purplePalette,
    greenPalette,
    goldenPalette,
    grayPalette,
    monochromePalette,
  ];
}
