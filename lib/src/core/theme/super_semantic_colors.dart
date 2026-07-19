// ============================================================
// core/theme/super_semantic_colors.dart
// ------------------------------------------------------------
// SuperSemanticColors — a structured, brightness-resolved semantic color set
// for the GeniusLink design system. Where SuperTokensData carries the raw
// semantic *solids* (info / success / warning / danger), this bundle expands
// each intent into the four roles a status surface actually needs:
//
//   • solid    — the vivid color (icon / emphasis text / active border)
//   • onSolid  — legible foreground ON a solid fill (badges, filled buttons)
//   • subtle   — a faint opaque tint of the solid over the card surface
//                (status-pill / banner / snackbar background)
//   • onSubtle — legible foreground on the subtle fill (pill / banner text)
//   • border   — hairline border for a subtle container
//
// Six intents ship: info, success, warning, danger, accent, neutral. Each is a
// [SuperSemanticColor]. The bundle is a [ThemeExtension] registered by
// SuperMaterialThemeData, so components read it via `SuperSemanticColors.of`.
//
//   final sem = SuperSemanticColors.of(context);
//   final s   = sem.success;              // or sem.byIntent(SuperSemanticIntent.success)
//   Container(color: s.subtle, ... Text(label, style: TextStyle(color: s.onSubtle)));
// ============================================================

import 'package:flutter/material.dart';

import 'super_color_utils.dart';
import 'super_theme.dart';

/// The six semantic intents expressed by [SuperSemanticColors].
enum SuperSemanticIntent { info, success, warning, danger, accent, neutral }

/// One resolved semantic color — the full set of roles for a single intent.
@immutable
class SuperSemanticColor {
  const SuperSemanticColor({
    required this.solid,
    required this.onSolid,
    required this.subtle,
    required this.onSubtle,
    required this.border,
  });

  /// The vivid color — icons, emphasis text, active borders, filled fills.
  final Color solid;

  /// Legible foreground placed on top of [solid] (badges / filled buttons).
  final Color onSolid;

  /// A faint opaque tint of [solid] over the card surface — the background for
  /// status pills, banners and toasts.
  final Color subtle;

  /// Legible foreground placed on top of [subtle] (pill / banner text).
  final Color onSubtle;

  /// Hairline border for a container filled with [subtle].
  final Color border;

  /// Builds a full role set from a single [base] solid over [surface].
  ///
  /// In dark mode the solid is lifted slightly for legibility; the subtle fill
  /// and border are opaque blends of the base over the surface; [onSubtle] is
  /// chosen for the best contrast against the subtle fill from a small set of
  /// candidates (the base, tonal variants, and the neutral foreground).
  factory SuperSemanticColor.fromBase(
    Color base, {
    required Color surface,
    required bool dark,
    required Color neutralFg,
  }) {
    final solid = dark ? base.lighten(0.06) : base;
    final subtle = base.tintOver(surface, dark ? 0.20 : 0.12);
    final border = base.tintOver(surface, dark ? 0.44 : 0.34);
    final onSubtle = subtle.bestForegroundFrom(<Color>[
      base,
      base.lighten(0.26),
      base.darken(0.22),
      neutralFg,
    ]);
    return SuperSemanticColor(
      solid: solid,
      onSolid: solid.onColor(),
      subtle: subtle,
      onSubtle: onSubtle,
      border: border,
    );
  }

  /// Returns a copy with the given fields replaced.
  SuperSemanticColor copyWith({
    Color? solid,
    Color? onSolid,
    Color? subtle,
    Color? onSubtle,
    Color? border,
  }) =>
      SuperSemanticColor(
        solid: solid ?? this.solid,
        onSolid: onSolid ?? this.onSolid,
        subtle: subtle ?? this.subtle,
        onSubtle: onSubtle ?? this.onSubtle,
        border: border ?? this.border,
      );

  /// Linearly interpolates between two role sets.
  static SuperSemanticColor lerp(
      SuperSemanticColor a, SuperSemanticColor b, double t) {
    return SuperSemanticColor(
      solid: Color.lerp(a.solid, b.solid, t)!,
      onSolid: Color.lerp(a.onSolid, b.onSolid, t)!,
      subtle: Color.lerp(a.subtle, b.subtle, t)!,
      onSubtle: Color.lerp(a.onSubtle, b.onSubtle, t)!,
      border: Color.lerp(a.border, b.border, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SuperSemanticColor &&
      other.solid == solid &&
      other.onSolid == onSolid &&
      other.subtle == subtle &&
      other.onSubtle == onSubtle &&
      other.border == border;

  @override
  int get hashCode => Object.hash(solid, onSolid, subtle, onSubtle, border);
}

/// The structured semantic color bundle — one [SuperSemanticColor] per intent.
///
/// Registered as a [ThemeExtension] by `SuperMaterialThemeData` (derived from
/// the active palette, brightness and token semantics), so any widget can read
/// it:
///
/// ```dart
/// final sem = SuperSemanticColors.of(context);
/// StatusChip(bg: sem.warning.subtle, fg: sem.warning.onSubtle);
/// ```
@immutable
class SuperSemanticColors extends ThemeExtension<SuperSemanticColors> {
  const SuperSemanticColors({
    required this.info,
    required this.success,
    required this.warning,
    required this.danger,
    required this.accent,
    required this.neutral,
  });

  /// Informational — neutral notices, tips, in-progress states (sky blue).
  final SuperSemanticColor info;

  /// Positive — posted / balanced / approved (GeniusLink green).
  final SuperSemanticColor success;

  /// Cautionary — notes / pending review / documentation (GeniusLink orange).
  final SuperSemanticColor warning;

  /// Destructive / error — voided / failed / delete (GeniusLink red).
  final SuperSemanticColor danger;

  /// Brand accent expressed as a semantic surface (selected / primary state).
  final SuperSemanticColor accent;

  /// Neutral — inert / locked / disabled chips resolved on the surface ramp.
  final SuperSemanticColor neutral;

  /// The role set for [intent].
  SuperSemanticColor byIntent(SuperSemanticIntent intent) => switch (intent) {
        SuperSemanticIntent.info => info,
        SuperSemanticIntent.success => success,
        SuperSemanticIntent.warning => warning,
        SuperSemanticIntent.danger => danger,
        SuperSemanticIntent.accent => accent,
        SuperSemanticIntent.neutral => neutral,
      };

  /// Derives the full semantic set from an ambient [SuperThemeData] — using its
  /// token solids (`tokens.info/success/warning/danger/accent`), card [surface],
  /// neutral foreground and [brightness].
  factory SuperSemanticColors.fromSuperTheme(SuperThemeData t) {
    final k = t.tokens;
    final surface = t.surface;
    final dark = t.brightness == Brightness.dark;
    SuperSemanticColor build(Color base) => SuperSemanticColor.fromBase(
          base,
          surface: surface,
          dark: dark,
          neutralFg: t.fg1,
        );
    return SuperSemanticColors(
      info: build(k.info),
      success: build(k.success),
      warning: build(k.warning),
      danger: build(k.danger),
      accent: build(k.accent),
      neutral: SuperSemanticColor(
        solid: t.fg3,
        onSolid: t.fg3.onColor(),
        subtle: t.hover,
        onSubtle: t.fg2,
        border: t.border,
      ),
    );
  }

  /// Reads the registered extension, falling back to a set derived from the
  /// ambient [SuperThemeData] (which itself falls back to the dark preset).
  static SuperSemanticColors of(BuildContext context) =>
      Theme.of(context).extension<SuperSemanticColors>() ??
      SuperSemanticColors.fromSuperTheme(SuperThemeData.of(context));

  @override
  SuperSemanticColors copyWith({
    SuperSemanticColor? info,
    SuperSemanticColor? success,
    SuperSemanticColor? warning,
    SuperSemanticColor? danger,
    SuperSemanticColor? accent,
    SuperSemanticColor? neutral,
  }) =>
      SuperSemanticColors(
        info: info ?? this.info,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        danger: danger ?? this.danger,
        accent: accent ?? this.accent,
        neutral: neutral ?? this.neutral,
      );

  @override
  SuperSemanticColors lerp(
      ThemeExtension<SuperSemanticColors>? other, double t) {
    if (other is! SuperSemanticColors) return this;
    return SuperSemanticColors(
      info: SuperSemanticColor.lerp(info, other.info, t),
      success: SuperSemanticColor.lerp(success, other.success, t),
      warning: SuperSemanticColor.lerp(warning, other.warning, t),
      danger: SuperSemanticColor.lerp(danger, other.danger, t),
      accent: SuperSemanticColor.lerp(accent, other.accent, t),
      neutral: SuperSemanticColor.lerp(neutral, other.neutral, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SuperSemanticColors &&
      other.info == info &&
      other.success == success &&
      other.warning == warning &&
      other.danger == danger &&
      other.accent == accent &&
      other.neutral == neutral;

  @override
  int get hashCode =>
      Object.hash(info, success, warning, danger, accent, neutral);
}
