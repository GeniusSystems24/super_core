part of 'grid.dart';

/// A child and its responsive column spans for [SuperGrid].
class SuperGridCell {
  const SuperGridCell({
    required this.child,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.large,
    this.mobileOrder,
    this.tabletOrder,
    this.desktopOrder,
    this.largeOrder,
  });

  /// Widget rendered in the grid cell.
  final Widget child;

  /// Column span at [SuperBreakpoint.mobile].
  final int mobile;

  /// Column span at [SuperBreakpoint.tablet]. Inherits [mobile] when null.
  final int? tablet;

  /// Column span at [SuperBreakpoint.desktop]. Inherits [tablet] then [mobile].
  final int? desktop;

  /// Column span at [SuperBreakpoint.large]. Inherits narrower values.
  final int? large;

  /// Display order at mobile. Lower values appear first.
  final int? mobileOrder;

  /// Display order at tablet. Inherits [mobileOrder] when omitted.
  final int? tabletOrder;

  /// Display order at desktop. Inherits [tabletOrder] then [mobileOrder].
  final int? desktopOrder;

  /// Display order at large. Inherits narrower order values.
  final int? largeOrder;

  /// Active column span for [breakpoint]. A value of `0` hides the cell.
  int columnsAt(SuperBreakpoint breakpoint) => switch (breakpoint) {
    SuperBreakpoint.large => large ?? desktop ?? tablet ?? mobile,
    SuperBreakpoint.desktop => desktop ?? tablet ?? mobile,
    SuperBreakpoint.tablet => tablet ?? mobile,
    SuperBreakpoint.mobile => mobile,
  };

  /// Active display order for [breakpoint].
  int orderAt(SuperBreakpoint breakpoint) => switch (breakpoint) {
    SuperBreakpoint.large =>
      largeOrder ?? desktopOrder ?? tabletOrder ?? mobileOrder ?? 0,
    SuperBreakpoint.desktop => desktopOrder ?? tabletOrder ?? mobileOrder ?? 0,
    SuperBreakpoint.tablet => tabletOrder ?? mobileOrder ?? 0,
    SuperBreakpoint.mobile => mobileOrder ?? 0,
  };
}
