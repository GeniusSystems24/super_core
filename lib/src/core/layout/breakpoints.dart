import 'package:flutter/widgets.dart';

/// Responsive column breakpoints used by the Super layout primitives.
///
/// The breakpoints mirror the legacy GeniusLink layout grid:
/// mobile uses 4 columns, tablet uses 8, and desktop/large use 12.
enum SuperBreakpoint {
  /// Mobile layout, up to 599 logical pixels wide.
  mobile(columns: 4, maxWidth: 599, scale: 1.15),

  /// Tablet layout, from 600 to 839 logical pixels wide.
  tablet(columns: 8, maxWidth: 839, scale: 1.15),

  /// Desktop layout, from 840 to 1199 logical pixels wide.
  desktop(columns: 12, maxWidth: 1199, scale: 1.15),

  /// Large desktop layout, 1200 logical pixels and wider.
  large(columns: 12, maxWidth: double.infinity, scale: 1.15);

  const SuperBreakpoint({
    required this.columns,
    required this.maxWidth,
    required this.scale,
  });

  /// Number of grid columns available at this breakpoint.
  final int columns;

  /// Inclusive maximum width for this breakpoint.
  final double maxWidth;

  /// Legacy scale hint retained for callers that still tune desktop previews.
  final double scale;

  /// Inclusive lower bound for this breakpoint.
  double get minWidth => switch (this) {
    SuperBreakpoint.mobile => 0,
    SuperBreakpoint.tablet => SuperBreakpoints.compactMax + 1,
    SuperBreakpoint.desktop => SuperBreakpoints.mediumMax + 1,
    SuperBreakpoint.large => SuperBreakpoints.expandedMax + 1,
  };

  /// Resolves the breakpoint from a logical width.
  static SuperBreakpoint ofWidth(double width) {
    if (width <= SuperBreakpoint.mobile.maxWidth) {
      return SuperBreakpoint.mobile;
    }
    if (width <= SuperBreakpoint.tablet.maxWidth) {
      return SuperBreakpoint.tablet;
    }
    if (width <= SuperBreakpoint.desktop.maxWidth) {
      return SuperBreakpoint.desktop;
    }
    return SuperBreakpoint.large;
  }

  /// Resolves the breakpoint from an ambient [SuperBreakpointProvider] or the
  /// current [MediaQuery] width.
  static SuperBreakpoint of(BuildContext context) =>
      _SuperBreakpointScope.dependOn(context)?.breakpoint ??
      SuperBreakpoint.globalOf(context);

  /// Resolves the breakpoint from the full-screen [MediaQuery] width,
  /// ignoring any [SuperBreakpointProvider].
  static SuperBreakpoint globalOf(BuildContext context) =>
      SuperBreakpoint.ofWidth(MediaQuery.sizeOf(context).width);
}

/// Helpers for resolving values against the Super breakpoint set.
class SuperBreakpoints {
  const SuperBreakpoints._();

  /// Maximum mobile width.
  static const double compactMax = 599;

  /// Maximum tablet width.
  static const double mediumMax = 839;

  /// Maximum desktop width before [SuperBreakpoint.large].
  static const double expandedMax = 1199;

  /// Resolves a value for the active breakpoint from [context].
  static T resolve<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? large,
  }) => resolveFor(
    SuperBreakpoint.of(context),
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
    large: large,
  );

  /// Resolves a value for an explicit [breakpoint].
  static T resolveFor<T>(
    SuperBreakpoint breakpoint, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? large,
  }) => switch (breakpoint) {
    SuperBreakpoint.large => large ?? desktop ?? tablet ?? mobile,
    SuperBreakpoint.desktop => desktop ?? tablet ?? mobile,
    SuperBreakpoint.tablet => tablet ?? mobile,
    SuperBreakpoint.mobile => mobile,
  };
}

/// Provides a fixed Super layout breakpoint to a subtree.
///
/// This is useful for previews, side panels, dialogs, and nested grids where a
/// local layout width should override the full-screen [MediaQuery] width.
class SuperBreakpointProvider extends StatelessWidget {
  const SuperBreakpointProvider({
    super.key,
    required this.child,
    this.defaultWidth,
    this.breakpoint,
  });

  /// Child subtree that receives the resolved breakpoint.
  final Widget child;

  /// Width used when [breakpoint] is not supplied.
  final double? defaultWidth;

  /// Explicit breakpoint. When null, [defaultWidth] or [MediaQuery] width is
  /// mapped through [SuperBreakpoint.ofWidth].
  final SuperBreakpoint? breakpoint;

  /// Returns the nearest provided breakpoint without subscribing to changes.
  static SuperBreakpoint? maybeBreakpointOf(BuildContext context) =>
      _SuperBreakpointScope.maybeOf(context)?.breakpoint;

  /// Returns the nearest provided width without subscribing to changes.
  static double? maybeWidthOf(BuildContext context) =>
      _SuperBreakpointScope.maybeOf(context)?.width;

  @override
  Widget build(BuildContext context) {
    final explicitBreakpoint = breakpoint;
    final width =
        defaultWidth ??
        (explicitBreakpoint == null
            ? MediaQuery.sizeOf(context).width
            : _representativeWidth(explicitBreakpoint));
    final resolvedBreakpoint =
        explicitBreakpoint ?? SuperBreakpoint.ofWidth(width);

    return _SuperBreakpointScope(
      width: width,
      breakpoint: resolvedBreakpoint,
      child: child,
    );
  }
}

double _representativeWidth(SuperBreakpoint breakpoint) => switch (breakpoint) {
  SuperBreakpoint.mobile => SuperBreakpoints.compactMax,
  SuperBreakpoint.tablet => SuperBreakpoint.tablet.minWidth,
  SuperBreakpoint.desktop => SuperBreakpoint.desktop.minWidth,
  SuperBreakpoint.large => SuperBreakpoints.expandedMax + 1,
};

class _SuperBreakpointScope extends InheritedWidget {
  const _SuperBreakpointScope({
    required this.width,
    required this.breakpoint,
    required super.child,
  });

  final double width;
  final SuperBreakpoint breakpoint;

  static _SuperBreakpointScope? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_SuperBreakpointScope>();

  static _SuperBreakpointScope? dependOn(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SuperBreakpointScope>();

  @override
  bool updateShouldNotify(_SuperBreakpointScope oldWidget) =>
      width != oldWidget.width || breakpoint != oldWidget.breakpoint;
}
