// ============================================================
// core/theme/super_app_bar_theme.dart
// ------------------------------------------------------------
// SuperAppBarTheme — an [AppBarThemeData] subclass that carries the extra
// configuration [SuperAppBar] and [SuperSliverAppBar] need on top of a stock
// app bar: where the subtitle sits relative to the title, and how many action
// buttons are shown before the rest collapse into a three-dot overflow menu
// (with a responsive default per device class).
//
// Because it IS an [AppBarThemeData], a SuperAppBarTheme instance drops straight
// into `ThemeData.appBarTheme`; `SuperMaterialThemeData` installs one by
// default. The Super app bars read it via [SuperAppBarTheme.of].
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import 'super_device_mode.dart';

/// Where a [SuperAppBar] / [SuperSliverAppBar] subtitle is placed relative to
/// its title.
enum SubtitlePosition {
  /// Subtitle rendered above the title (breadcrumb / eyebrow style).
  above,

  /// Subtitle rendered below the title (conventional supporting text).
  below,
}

/// An [AppBarThemeData] extended with the Super app-bar configuration:
/// [subtitlePosition] and the responsive action-overflow limits
/// ([maxActions] / [maxMobileActions] / [maxTabletActions] /
/// [maxDesktopActions]).
///
/// All inherited [AppBarThemeData] properties (background, elevation, icon themes,
/// title / toolbar text styles, shape, system overlay style, …) behave exactly
/// as they do on a stock app bar.
class SuperAppBarTheme extends AppBarThemeData {
  /// Creates a Super app-bar theme. Inherited [AppBarThemeData] parameters are
  /// forwarded unchanged; the Super-specific parameters are listed first.
  const SuperAppBarTheme({
    this.subtitlePosition,
    this.subtitleTextStyle,
    this.maxActions,
    this.maxMobileActions,
    this.maxTabletActions,
    this.maxDesktopActions,
    super.backgroundColor,
    super.foregroundColor,
    super.elevation,
    super.scrolledUnderElevation,
    super.shadowColor,
    super.surfaceTintColor,
    super.shape,
    super.iconTheme,
    super.actionsIconTheme,
    super.centerTitle,
    super.titleSpacing,
    super.toolbarHeight,
    super.leadingWidth,
    super.toolbarTextStyle,
    super.titleTextStyle,
    super.systemOverlayStyle,
  });

  /// Where the subtitle sits relative to the title. Defaults to
  /// [SubtitlePosition.below] when unset.
  final SubtitlePosition? subtitlePosition;

  /// Text style for the subtitle line. Falls back to a de-emphasized variant of
  /// [toolbarTextStyle] / [titleTextStyle] when unset.
  final TextStyle? subtitleTextStyle;

  /// An explicit action limit that overrides the per-device values below. When
  /// null, the limit is chosen responsively from [maxMobileActions] /
  /// [maxTabletActions] / [maxDesktopActions].
  final int? maxActions;

  /// Max inline actions on a mobile-width layout (default 3).
  final int? maxMobileActions;

  /// Max inline actions on a tablet-width layout (default 4).
  final int? maxTabletActions;

  /// Max inline actions on a desktop-width layout (default 5).
  final int? maxDesktopActions;

  /// The responsive default limits (mobile 3 / tablet 4 / desktop 5).
  static const int defaultMobileActions = 3;
  static const int defaultTabletActions = 4;
  static const int defaultDesktopActions = 5;

  /// The maximum number of inline actions for [mode]. [maxActions] wins when
  /// set; otherwise the per-device value (falling back to the responsive
  /// defaults 3 / 4 / 5).
  int maxActionsFor(SuperDeviceMode mode) {
    if (maxActions != null) return maxActions!;
    return switch (mode) {
      SuperDeviceMode.mobile => maxMobileActions ?? defaultMobileActions,
      SuperDeviceMode.tablet => maxTabletActions ?? defaultTabletActions,
      SuperDeviceMode.desktop => maxDesktopActions ?? defaultDesktopActions,
    };
  }

  /// The subtitle position with the [SubtitlePosition.below] default applied.
  SubtitlePosition get effectiveSubtitlePosition =>
      subtitlePosition ?? SubtitlePosition.below;

  /// Reads the ambient [SuperAppBarTheme] from [ThemeData.appBarTheme] when the
  /// installed app-bar theme is a SuperAppBarTheme, otherwise returns an empty
  /// SuperAppBarTheme wrapping the ambient plain [AppBarThemeData] so callers always
  /// get the Super-specific getters (with their defaults).
  static SuperAppBarTheme of(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    if (appBarTheme is SuperAppBarTheme) return appBarTheme;
    return SuperAppBarTheme.fromAppBarTheme(appBarTheme);
  }

  /// Wraps a plain [AppBarThemeData] as a SuperAppBarTheme (Super-specific fields
  /// left null → their defaults apply).
  factory SuperAppBarTheme.fromAppBarTheme(AppBarThemeData theme) {
    if (theme is SuperAppBarTheme) return theme;
    return SuperAppBarTheme(
      backgroundColor: theme.backgroundColor,
      foregroundColor: theme.foregroundColor,
      elevation: theme.elevation,
      scrolledUnderElevation: theme.scrolledUnderElevation,
      shadowColor: theme.shadowColor,
      surfaceTintColor: theme.surfaceTintColor,
      shape: theme.shape,
      iconTheme: theme.iconTheme,
      actionsIconTheme: theme.actionsIconTheme,
      centerTitle: theme.centerTitle,
      titleSpacing: theme.titleSpacing,
      toolbarHeight: theme.toolbarHeight,
      leadingWidth: theme.leadingWidth,
      toolbarTextStyle: theme.toolbarTextStyle,
      titleTextStyle: theme.titleTextStyle,
      systemOverlayStyle: theme.systemOverlayStyle,
    );
  }

  /// Returns a copy with the Super-specific fields (and the common app-bar
  /// surface fields) replaced. Constructs directly rather than overriding
  /// [AppBarThemeData.copyWith] — whose parameter list varies across Flutter
  /// versions — so it stays a superset without an unsafe override.
  SuperAppBarTheme copyWithSuper({
    SubtitlePosition? subtitlePosition,
    TextStyle? subtitleTextStyle,
    int? maxActions,
    int? maxMobileActions,
    int? maxTabletActions,
    int? maxDesktopActions,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    double? scrolledUnderElevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    bool? centerTitle,
    double? titleSpacing,
    double? toolbarHeight,
    double? leadingWidth,
    TextStyle? toolbarTextStyle,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
  }) => SuperAppBarTheme(
    subtitlePosition: subtitlePosition ?? this.subtitlePosition,
    subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
    maxActions: maxActions ?? this.maxActions,
    maxMobileActions: maxMobileActions ?? this.maxMobileActions,
    maxTabletActions: maxTabletActions ?? this.maxTabletActions,
    maxDesktopActions: maxDesktopActions ?? this.maxDesktopActions,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    elevation: elevation ?? this.elevation,
    scrolledUnderElevation:
        scrolledUnderElevation ?? this.scrolledUnderElevation,
    shadowColor: shadowColor ?? this.shadowColor,
    surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
    shape: shape ?? this.shape,
    iconTheme: iconTheme ?? this.iconTheme,
    actionsIconTheme: actionsIconTheme ?? this.actionsIconTheme,
    centerTitle: centerTitle ?? this.centerTitle,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    toolbarHeight: toolbarHeight ?? this.toolbarHeight,
    leadingWidth: leadingWidth ?? this.leadingWidth,
    toolbarTextStyle: toolbarTextStyle ?? this.toolbarTextStyle,
    titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    systemOverlayStyle: systemOverlayStyle ?? this.systemOverlayStyle,
  );

  /// Merges [other] over this theme (its non-null fields win). Returns a
  /// SuperAppBarTheme carrying both stocks of configuration.
  SuperAppBarTheme mergeWith(SuperAppBarTheme? other) {
    if (other == null) return this;
    return copyWithSuper(
      subtitlePosition: other.subtitlePosition,
      subtitleTextStyle: other.subtitleTextStyle,
      maxActions: other.maxActions,
      maxMobileActions: other.maxMobileActions,
      maxTabletActions: other.maxTabletActions,
      maxDesktopActions: other.maxDesktopActions,
      backgroundColor: other.backgroundColor,
      foregroundColor: other.foregroundColor,
      elevation: other.elevation,
      scrolledUnderElevation: other.scrolledUnderElevation,
      shadowColor: other.shadowColor,
      surfaceTintColor: other.surfaceTintColor,
      shape: other.shape,
      iconTheme: other.iconTheme,
      actionsIconTheme: other.actionsIconTheme,
      centerTitle: other.centerTitle,
      titleSpacing: other.titleSpacing,
      toolbarHeight: other.toolbarHeight,
      leadingWidth: other.leadingWidth,
      toolbarTextStyle: other.toolbarTextStyle,
      titleTextStyle: other.titleTextStyle,
      systemOverlayStyle: other.systemOverlayStyle,
    );
  }
}
