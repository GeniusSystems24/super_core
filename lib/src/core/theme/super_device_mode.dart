// ============================================================
// core/theme/super_device_mode.dart
// ------------------------------------------------------------
// SuperDeviceMode — the three responsive form-factors the design system
// targets, plus SuperResponsive<T>, the container that carries one value per
// mode and resolves the active one.
//
// These are the single source of truth for "which set of tokens is live".
// SuperMetrics, the responsive TextTheme, and the responsive
// InputDecorationTheme all key off a SuperDeviceMode.
// ============================================================

import 'package:flutter/widgets.dart';

/// The responsive form-factor a [SuperMaterialThemeData] is generated for.
///
/// Passed to `SuperMaterialThemeData.light(mode: ...)` / `.dark(mode: ...)`.
/// Defaults to [mobile] everywhere.
enum SuperDeviceMode {
  /// Phones — largest touch targets, tightest content column, densest rhythm.
  mobile,

  /// Tablets — medium targets and spacing.
  tablet,

  /// Desktop / web — smallest control heights, most generous page margins.
  desktop;

  /// The conventional Material breakpoint (min logical width, dp) at which
  /// this mode becomes appropriate. Handy when picking a mode from a
  /// `LayoutBuilder` / `MediaQuery`.
  double get minWidth => switch (this) {
        SuperDeviceMode.mobile => 0,
        SuperDeviceMode.tablet => 600,
        SuperDeviceMode.desktop => 1024,
      };

  /// Picks the mode for a given logical [width] using [minWidth] breakpoints.
  ///
  /// ```dart
  /// final mode = SuperDeviceMode.forWidth(MediaQuery.sizeOf(context).width);
  /// ```
  static SuperDeviceMode forWidth(double width) {
    if (width >= SuperDeviceMode.desktop.minWidth) return SuperDeviceMode.desktop;
    if (width >= SuperDeviceMode.tablet.minWidth) return SuperDeviceMode.tablet;
    return SuperDeviceMode.mobile;
  }

  /// Picks the mode from the ambient [MediaQuery] width.
  static SuperDeviceMode of(BuildContext context) =>
      forWidth(MediaQuery.sizeOf(context).width);

  bool get isMobile => this == SuperDeviceMode.mobile;
  bool get isTablet => this == SuperDeviceMode.tablet;
  bool get isDesktop => this == SuperDeviceMode.desktop;
}

/// A value that varies across the three [SuperDeviceMode]s.
///
/// The canonical way the design system keeps a single responsive definition
/// in one place while still exposing all three configurations:
///
/// ```dart
/// const gutter = SuperResponsive<double>(mobile: 16, tablet: 24, desktop: 32);
/// gutter.resolve(SuperDeviceMode.tablet); // 24
/// gutter.desktop;                          // 32 — all three stay reachable
/// ```
@immutable
class SuperResponsive<T> {
  const SuperResponsive({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  /// A [SuperResponsive] whose value is identical across all three modes.
  const SuperResponsive.all(T value)
      : mobile = value,
        tablet = value,
        desktop = value;

  final T mobile;
  final T tablet;
  final T desktop;

  /// The value for [mode] — the "active" configuration.
  T resolve(SuperDeviceMode mode) => switch (mode) {
        SuperDeviceMode.mobile => mobile,
        SuperDeviceMode.tablet => tablet,
        SuperDeviceMode.desktop => desktop,
      };

  /// Returns a new [SuperResponsive] with each value mapped through [f].
  SuperResponsive<R> map<R>(R Function(T value) f) => SuperResponsive<R>(
        mobile: f(mobile),
        tablet: f(tablet),
        desktop: f(desktop),
      );

  @override
  bool operator ==(Object other) =>
      other is SuperResponsive<T> &&
      other.mobile == mobile &&
      other.tablet == tablet &&
      other.desktop == desktop;

  @override
  int get hashCode => Object.hash(mobile, tablet, desktop);

  @override
  String toString() =>
      'SuperResponsive<$T>(mobile: $mobile, tablet: $tablet, desktop: $desktop)';
}
