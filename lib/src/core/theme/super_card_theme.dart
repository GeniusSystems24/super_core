// ============================================================
// core/theme/super_card_theme.dart
// ------------------------------------------------------------
// SuperCardTheme — a [CardThemeData] subclass that carries the extra defaults
// [SuperCard] needs for its expand/collapse behavior, its leading/trailing
// slots, and its border treatment, on top of the stock card surface fields
// (color, elevation, shadow, shape, margin, clip).
//
// Because it IS a [CardThemeData], a SuperCardTheme instance drops straight
// into `ThemeData.cardTheme`; `SuperMaterialThemeData` installs one by default.
// [SuperCard] reads it via [SuperCardTheme.of].
// ============================================================

import 'package:flutter/material.dart';

/// A [CardThemeData] extended with [SuperCard] configuration: the expand
/// direction + animation, whether a tap toggles expansion, whether a chevron
/// affordance is shown, the interior padding, and the resting / selected border
/// colors.
class SuperCardTheme extends CardThemeData {
  /// Creates a Super card theme. Inherited [CardThemeData] parameters are
  /// forwarded unchanged; the Super-specific parameters are listed first.
  const SuperCardTheme({
    this.expandDirection,
    this.expandDuration,
    this.expandCurve,
    this.toggleOnTap,
    this.showExpandIcon,
    this.padding,
    this.gap,
    this.borderColor,
    this.selectedBorderColor,
    super.clipBehavior,
    super.color,
    super.shadowColor,
    super.elevation,
    super.surfaceTintColor,
    super.margin,
    super.shape,
  });

  /// The axis the card grows along when it expands. Defaults to [Axis.vertical].
  final Axis? expandDirection;

  /// The expand/collapse animation duration. Defaults to `durExpand` (200ms).
  final Duration? expandDuration;

  /// The expand/collapse animation curve. Defaults to `curveOut` (ease-out).
  final Curve? expandCurve;

  /// Whether tapping the card body toggles its expansion. Defaults to `true`
  /// when the card is expandable.
  final bool? toggleOnTap;

  /// Whether an animated chevron affordance is shown in the trailing slot of an
  /// expandable card. Defaults to `true`.
  final bool? showExpandIcon;

  /// Interior padding. Defaults to the `space6` (24px) card interior.
  final EdgeInsetsGeometry? padding;

  /// Gap between the leading / body / trailing slots. Defaults to `space4`.
  final double? gap;

  /// Resting border color. Defaults to [SuperThemeData.border].
  final Color? borderColor;

  /// Border color when the card is `selected`. Defaults to the primary accent.
  final Color? selectedBorderColor;

  /// Reads the ambient [SuperCardTheme] from [ThemeData.cardTheme] when the
  /// installed card theme is a SuperCardTheme, otherwise wraps the ambient plain
  /// [CardThemeData] so callers always get the Super-specific getters.
  static SuperCardTheme of(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    if (cardTheme is SuperCardTheme) return cardTheme;
    return SuperCardTheme.fromCardTheme(cardTheme);
  }

  /// Wraps a plain [CardThemeData] as a SuperCardTheme (Super-specific fields
  /// left null → their defaults apply).
  factory SuperCardTheme.fromCardTheme(CardThemeData theme) {
    if (theme is SuperCardTheme) return theme;
    return SuperCardTheme(
      clipBehavior: theme.clipBehavior,
      color: theme.color,
      shadowColor: theme.shadowColor,
      elevation: theme.elevation,
      surfaceTintColor: theme.surfaceTintColor,
      margin: theme.margin,
      shape: theme.shape,
    );
  }

  /// Returns a copy with the given fields replaced. Preserves the concrete
  /// [SuperCardTheme] type and every Super-specific field.
  @override
  SuperCardTheme copyWith({
    Axis? expandDirection,
    Duration? expandDuration,
    Curve? expandCurve,
    bool? toggleOnTap,
    bool? showExpandIcon,
    EdgeInsetsGeometry? padding,
    double? gap,
    Color? borderColor,
    Color? selectedBorderColor,
    Clip? clipBehavior,
    Color? color,
    Color? shadowColor,
    double? elevation,
    Color? surfaceTintColor,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
  }) => SuperCardTheme(
    expandDirection: expandDirection ?? this.expandDirection,
    expandDuration: expandDuration ?? this.expandDuration,
    expandCurve: expandCurve ?? this.expandCurve,
    toggleOnTap: toggleOnTap ?? this.toggleOnTap,
    showExpandIcon: showExpandIcon ?? this.showExpandIcon,
    padding: padding ?? this.padding,
    gap: gap ?? this.gap,
    borderColor: borderColor ?? this.borderColor,
    selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
    clipBehavior: clipBehavior ?? this.clipBehavior,
    color: color ?? this.color,
    shadowColor: shadowColor ?? this.shadowColor,
    elevation: elevation ?? this.elevation,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    margin: margin ?? this.margin,
    shape: shape ?? this.shape,
  );
}
