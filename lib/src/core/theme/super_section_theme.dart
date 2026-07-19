// ============================================================
// core/theme/super_section_theme.dart
// ------------------------------------------------------------
// ThemeExtensions that carry the configurable defaults for the section family:
//   • SuperSectionHeaderThemeData — SuperSectionHeader
//   • SuperSectionFooterThemeData — SuperSectionFooter / SuperFooterLink
//   • SuperSectionThemeData       — SuperSection shell
//
// Each is registered by SuperMaterialThemeData (ensure-present, like
// SuperSemanticColors) so widgets read `X.of(context)` and fall back to their
// hard-coded GeniusLink defaults for any null field. A widget-level parameter
// always wins over the theme value; the theme value wins over the hard default.
// ============================================================

import 'dart:ui';

import 'package:flutter/material.dart';

import 'super_tokens.dart';
// ════════════════════════════════════════════════════════════════════════════
// SuperSectionHeaderThemeData
// ════════════════════════════════════════════════════════════════════════════

/// Configurable defaults for `SuperSectionHeader`.
@immutable
class SuperSectionHeaderThemeData
    extends ThemeExtension<SuperSectionHeaderThemeData> {
  const SuperSectionHeaderThemeData({
    this.defaultMarker,
    // style1 marker bar
    this.markerWidth,
    this.markerRadius,
    // style2 marker tab + icon chip
    this.style2BarWidth,
    this.style2BarHeight,
    this.style2BarTailRadius,
    this.iconChipSize,
    this.iconChipRadius,
    this.iconChipTintOpacity,
    this.iconSize,
    // text
    this.titleStyle,
    this.subtitleStyle,
    this.eyebrowStyle,
    this.arabicStyle,
    this.style2TitleStyle,
    this.style2SubtitleStyle,
    // spacing
    this.gap,
    this.trailingIconSize,
  });

  /// Marker intent used when a header does not specify one.
  final SuperMarker? defaultMarker;

  final double? markerWidth;
  final double? markerRadius;

  final double? style2BarWidth;
  final double? style2BarHeight;
  final double? style2BarTailRadius;
  final double? iconChipSize;
  final double? iconChipRadius;
  final double? iconChipTintOpacity;
  final double? iconSize;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? eyebrowStyle;
  final TextStyle? arabicStyle;
  final TextStyle? style2TitleStyle;
  final TextStyle? style2SubtitleStyle;

  final double? gap;
  final double? trailingIconSize;

  /// The registered instance, or an all-null default so callers always get one.
  static SuperSectionHeaderThemeData of(BuildContext context) =>
      Theme.of(context).extension<SuperSectionHeaderThemeData>() ??
      const SuperSectionHeaderThemeData();

  @override
  SuperSectionHeaderThemeData copyWith({
    SuperMarker? defaultMarker,
    double? markerWidth,
    double? markerRadius,
    double? style2BarWidth,
    double? style2BarHeight,
    double? style2BarTailRadius,
    double? iconChipSize,
    double? iconChipRadius,
    double? iconChipTintOpacity,
    double? iconSize,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? eyebrowStyle,
    TextStyle? arabicStyle,
    TextStyle? style2TitleStyle,
    TextStyle? style2SubtitleStyle,
    double? gap,
    double? trailingIconSize,
  }) =>
      SuperSectionHeaderThemeData(
        defaultMarker: defaultMarker ?? this.defaultMarker,
        markerWidth: markerWidth ?? this.markerWidth,
        markerRadius: markerRadius ?? this.markerRadius,
        style2BarWidth: style2BarWidth ?? this.style2BarWidth,
        style2BarHeight: style2BarHeight ?? this.style2BarHeight,
        style2BarTailRadius: style2BarTailRadius ?? this.style2BarTailRadius,
        iconChipSize: iconChipSize ?? this.iconChipSize,
        iconChipRadius: iconChipRadius ?? this.iconChipRadius,
        iconChipTintOpacity: iconChipTintOpacity ?? this.iconChipTintOpacity,
        iconSize: iconSize ?? this.iconSize,
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        eyebrowStyle: eyebrowStyle ?? this.eyebrowStyle,
        arabicStyle: arabicStyle ?? this.arabicStyle,
        style2TitleStyle: style2TitleStyle ?? this.style2TitleStyle,
        style2SubtitleStyle: style2SubtitleStyle ?? this.style2SubtitleStyle,
        gap: gap ?? this.gap,
        trailingIconSize: trailingIconSize ?? this.trailingIconSize,
      );

  @override
  SuperSectionHeaderThemeData lerp(
      ThemeExtension<SuperSectionHeaderThemeData>? other, double t) {
    if (other is! SuperSectionHeaderThemeData) return this;
    double? d(double? a, double? b) =>
        (a == null && b == null) ? null : lerpDouble(a, b, t);
    return SuperSectionHeaderThemeData(
      defaultMarker: t < 0.5 ? defaultMarker : other.defaultMarker,
      markerWidth: d(markerWidth, other.markerWidth),
      markerRadius: d(markerRadius, other.markerRadius),
      style2BarWidth: d(style2BarWidth, other.style2BarWidth),
      style2BarHeight: d(style2BarHeight, other.style2BarHeight),
      style2BarTailRadius: d(style2BarTailRadius, other.style2BarTailRadius),
      iconChipSize: d(iconChipSize, other.iconChipSize),
      iconChipRadius: d(iconChipRadius, other.iconChipRadius),
      iconChipTintOpacity: d(iconChipTintOpacity, other.iconChipTintOpacity),
      iconSize: d(iconSize, other.iconSize),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
      eyebrowStyle: TextStyle.lerp(eyebrowStyle, other.eyebrowStyle, t),
      arabicStyle: TextStyle.lerp(arabicStyle, other.arabicStyle, t),
      style2TitleStyle: TextStyle.lerp(style2TitleStyle, other.style2TitleStyle, t),
      style2SubtitleStyle:
          TextStyle.lerp(style2SubtitleStyle, other.style2SubtitleStyle, t),
      gap: d(gap, other.gap),
      trailingIconSize: d(trailingIconSize, other.trailingIconSize),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SuperSectionFooterThemeData
// ════════════════════════════════════════════════════════════════════════════

/// Configurable defaults for `SuperSectionFooter` / `SuperFooterLink`.
@immutable
class SuperSectionFooterThemeData
    extends ThemeExtension<SuperSectionFooterThemeData> {
  const SuperSectionFooterThemeData({
    this.showDivider,
    this.brandStyle,
    this.linkStyle,
    this.emphasizedColor,
    this.letterSpacing,
    this.verticalPadding,
    this.spacing,
    this.runSpacing,
  });

  /// Whether the hairline rule is drawn by default.
  final bool? showDivider;
  final TextStyle? brandStyle;
  final TextStyle? linkStyle;

  /// Color for `emphasized` links (defaults to the accent).
  final Color? emphasizedColor;
  final double? letterSpacing;
  final double? verticalPadding;
  final double? spacing;
  final double? runSpacing;

  static SuperSectionFooterThemeData of(BuildContext context) =>
      Theme.of(context).extension<SuperSectionFooterThemeData>() ??
      const SuperSectionFooterThemeData();

  @override
  SuperSectionFooterThemeData copyWith({
    bool? showDivider,
    TextStyle? brandStyle,
    TextStyle? linkStyle,
    Color? emphasizedColor,
    double? letterSpacing,
    double? verticalPadding,
    double? spacing,
    double? runSpacing,
  }) =>
      SuperSectionFooterThemeData(
        showDivider: showDivider ?? this.showDivider,
        brandStyle: brandStyle ?? this.brandStyle,
        linkStyle: linkStyle ?? this.linkStyle,
        emphasizedColor: emphasizedColor ?? this.emphasizedColor,
        letterSpacing: letterSpacing ?? this.letterSpacing,
        verticalPadding: verticalPadding ?? this.verticalPadding,
        spacing: spacing ?? this.spacing,
        runSpacing: runSpacing ?? this.runSpacing,
      );

  @override
  SuperSectionFooterThemeData lerp(
      ThemeExtension<SuperSectionFooterThemeData>? other, double t) {
    if (other is! SuperSectionFooterThemeData) return this;
    double? d(double? a, double? b) =>
        (a == null && b == null) ? null : lerpDouble(a, b, t);
    return SuperSectionFooterThemeData(
      showDivider: t < 0.5 ? showDivider : other.showDivider,
      brandStyle: TextStyle.lerp(brandStyle, other.brandStyle, t),
      linkStyle: TextStyle.lerp(linkStyle, other.linkStyle, t),
      emphasizedColor: Color.lerp(emphasizedColor, other.emphasizedColor, t),
      letterSpacing: d(letterSpacing, other.letterSpacing),
      verticalPadding: d(verticalPadding, other.verticalPadding),
      spacing: d(spacing, other.spacing),
      runSpacing: d(runSpacing, other.runSpacing),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SuperSectionThemeData
// ════════════════════════════════════════════════════════════════════════════

/// Configurable defaults for the `SuperSection` shell.
@immutable
class SuperSectionThemeData extends ThemeExtension<SuperSectionThemeData> {
  const SuperSectionThemeData({
    this.card,
    this.background,
    this.borderColor,
    this.selectedBorderColor,
    this.selectedTintOpacity,
    this.radius,
    this.padding,
    this.gap,
    this.headerGap,
    this.footerGap,
    this.dividerAfterHeader,
    this.expandDuration,
    this.expandCurve,
  });

  /// Whether the section wraps in a card surface by default.
  final bool? card;
  final Color? background;
  final Color? borderColor;
  final Color? selectedBorderColor;

  /// Selected-state tint strength blended over the surface.
  final double? selectedTintOpacity;
  final double? radius;
  final EdgeInsetsGeometry? padding;

  /// Gap between `children`.
  final double? gap;

  /// Gap between the header and the body.
  final double? headerGap;

  /// Gap between the body and the footer.
  final double? footerGap;
  final bool? dividerAfterHeader;
  final Duration? expandDuration;
  final Curve? expandCurve;

  static SuperSectionThemeData of(BuildContext context) =>
      Theme.of(context).extension<SuperSectionThemeData>() ??
      const SuperSectionThemeData();

  @override
  SuperSectionThemeData copyWith({
    bool? card,
    Color? background,
    Color? borderColor,
    Color? selectedBorderColor,
    double? selectedTintOpacity,
    double? radius,
    EdgeInsetsGeometry? padding,
    double? gap,
    double? headerGap,
    double? footerGap,
    bool? dividerAfterHeader,
    Duration? expandDuration,
    Curve? expandCurve,
  }) =>
      SuperSectionThemeData(
        card: card ?? this.card,
        background: background ?? this.background,
        borderColor: borderColor ?? this.borderColor,
        selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
        selectedTintOpacity: selectedTintOpacity ?? this.selectedTintOpacity,
        radius: radius ?? this.radius,
        padding: padding ?? this.padding,
        gap: gap ?? this.gap,
        headerGap: headerGap ?? this.headerGap,
        footerGap: footerGap ?? this.footerGap,
        dividerAfterHeader: dividerAfterHeader ?? this.dividerAfterHeader,
        expandDuration: expandDuration ?? this.expandDuration,
        expandCurve: expandCurve ?? this.expandCurve,
      );

  @override
  SuperSectionThemeData lerp(
      ThemeExtension<SuperSectionThemeData>? other, double t) {
    if (other is! SuperSectionThemeData) return this;
    double? d(double? a, double? b) =>
        (a == null && b == null) ? null : lerpDouble(a, b, t);
    return SuperSectionThemeData(
      card: t < 0.5 ? card : other.card,
      background: Color.lerp(background, other.background, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      selectedBorderColor:
          Color.lerp(selectedBorderColor, other.selectedBorderColor, t),
      selectedTintOpacity: d(selectedTintOpacity, other.selectedTintOpacity),
      radius: d(radius, other.radius),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      gap: d(gap, other.gap),
      headerGap: d(headerGap, other.headerGap),
      footerGap: d(footerGap, other.footerGap),
      dividerAfterHeader: t < 0.5 ? dividerAfterHeader : other.dividerAfterHeader,
      expandDuration: t < 0.5 ? expandDuration : other.expandDuration,
      expandCurve: t < 0.5 ? expandCurve : other.expandCurve,
    );
  }
}
