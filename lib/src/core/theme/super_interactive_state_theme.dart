// ============================================================
// core/theme/super_interactive_state_theme.dart
// ------------------------------------------------------------
// SuperInteractiveStateThemeData — centralizes the hover / focus / pressed /
// selected / dragged / disabled treatment so every Super component resolves
// interactive states from one place instead of re-deriving overlay opacities.
//
// It is a ThemeExtension (registered alongside SuperThemeData) AND is carried
// directly on SuperMaterialThemeData so callers can override it per-theme.
// ============================================================

import 'package:flutter/material.dart';

import 'super_tokens.dart';

/// The interactive-state treatment for Super components.
///
/// Stores an [accent] plus the overlay opacity applied for each
/// [WidgetState], and exposes [overlayColor] — a ready
/// [WidgetStateProperty] that resolves the correct tint for a state set.
///
/// ```dart
/// final states = SuperInteractiveStateThemeData.of(context);
/// InkWell(overlayColor: states.overlayColor(), ...);
/// final o = states.opacity(WidgetState.hovered); // 0.08
/// ```
@immutable
class SuperInteractiveStateThemeData
    extends ThemeExtension<SuperInteractiveStateThemeData> {
  const SuperInteractiveStateThemeData({
    required this.accent,
    required this.hoverOpacity,
    required this.focusOpacity,
    required this.pressedOpacity,
    required this.selectedOpacity,
    required this.draggedOpacity,
    required this.disabledOpacity,
    required this.hoverSurface,
  });

  /// The color the state overlays tint toward (usually the primary accent).
  final Color accent;

  /// Overlay opacity applied on hover.
  final double hoverOpacity;

  /// Overlay opacity applied while focused.
  final double focusOpacity;

  /// Overlay opacity applied while pressed.
  final double pressedOpacity;

  /// Overlay opacity applied while selected.
  final double selectedOpacity;

  /// Overlay opacity applied while dragged.
  final double draggedOpacity;

  /// Content opacity applied while disabled (per the GeniusLink 40% spec).
  final double disabledOpacity;

  /// Neutral hover fill for large surfaces (table rows, list tiles) where a
  /// tinted accent overlay would be too loud.
  final Color hoverSurface;

  /// GeniusLink-standard interactive treatment. Overlays tint toward the
  /// brand accent; disabled content drops to 40% opacity.
  static const SuperInteractiveStateThemeData standard =
      SuperInteractiveStateThemeData(
    accent: SuperTokensData.defaultAccent,
    hoverOpacity: 0.08,
    focusOpacity: 0.12,
    pressedOpacity: 0.12,
    selectedOpacity: 0.10,
    draggedOpacity: 0.16,
    disabledOpacity: 0.40,
    hoverSurface: Color(0xFF2F3540),
  );

  /// Derives an interactive-state treatment from a Material [ColorScheme]:
  /// overlays follow `cs.primary`; the neutral hover surface follows the
  /// scheme's brightness.
  factory SuperInteractiveStateThemeData.fromColorScheme(ColorScheme cs) {
    final isDark = cs.brightness == Brightness.dark;
    return SuperInteractiveStateThemeData(
      accent: cs.primary,
      hoverOpacity: 0.08,
      focusOpacity: 0.12,
      pressedOpacity: 0.12,
      selectedOpacity: 0.10,
      draggedOpacity: 0.16,
      disabledOpacity: 0.40,
      hoverSurface:
          isDark ? const Color(0xFF2F3540) : const Color(0xFFEEF1F7),
    );
  }

  /// Reads the registered extension, falling back to [standard].
  static SuperInteractiveStateThemeData of(BuildContext context) =>
      Theme.of(context).extension<SuperInteractiveStateThemeData>() ?? standard;

  /// The overlay opacity for a single [state] (0 if none applies).
  double opacity(WidgetState state) => switch (state) {
        WidgetState.hovered => hoverOpacity,
        WidgetState.focused => focusOpacity,
        WidgetState.pressed => pressedOpacity,
        WidgetState.selected => selectedOpacity,
        WidgetState.dragged => draggedOpacity,
        _ => 0,
      };

  /// A [WidgetStateProperty] that tints [accent] by the appropriate overlay
  /// opacity for the resolved state set (pressed > focused > hovered).
  WidgetStateProperty<Color?> overlayColor() =>
      WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return accent.withValues(alpha: pressedOpacity);
        }
        if (states.contains(WidgetState.focused)) {
          return accent.withValues(alpha: focusOpacity);
        }
        if (states.contains(WidgetState.hovered)) {
          return accent.withValues(alpha: hoverOpacity);
        }
        if (states.contains(WidgetState.dragged)) {
          return accent.withValues(alpha: draggedOpacity);
        }
        return null;
      });

  @override
  SuperInteractiveStateThemeData copyWith({
    Color? accent,
    double? hoverOpacity,
    double? focusOpacity,
    double? pressedOpacity,
    double? selectedOpacity,
    double? draggedOpacity,
    double? disabledOpacity,
    Color? hoverSurface,
  }) =>
      SuperInteractiveStateThemeData(
        accent: accent ?? this.accent,
        hoverOpacity: hoverOpacity ?? this.hoverOpacity,
        focusOpacity: focusOpacity ?? this.focusOpacity,
        pressedOpacity: pressedOpacity ?? this.pressedOpacity,
        selectedOpacity: selectedOpacity ?? this.selectedOpacity,
        draggedOpacity: draggedOpacity ?? this.draggedOpacity,
        disabledOpacity: disabledOpacity ?? this.disabledOpacity,
        hoverSurface: hoverSurface ?? this.hoverSurface,
      );

  @override
  SuperInteractiveStateThemeData lerp(
      ThemeExtension<SuperInteractiveStateThemeData>? other, double t) {
    if (other is! SuperInteractiveStateThemeData) return this;
    return SuperInteractiveStateThemeData(
      accent: Color.lerp(accent, other.accent, t)!,
      hoverOpacity: _l(hoverOpacity, other.hoverOpacity, t),
      focusOpacity: _l(focusOpacity, other.focusOpacity, t),
      pressedOpacity: _l(pressedOpacity, other.pressedOpacity, t),
      selectedOpacity: _l(selectedOpacity, other.selectedOpacity, t),
      draggedOpacity: _l(draggedOpacity, other.draggedOpacity, t),
      disabledOpacity: _l(disabledOpacity, other.disabledOpacity, t),
      hoverSurface: Color.lerp(hoverSurface, other.hoverSurface, t)!,
    );
  }

  static double _l(double a, double b, double t) => a + (b - a) * t;
}
