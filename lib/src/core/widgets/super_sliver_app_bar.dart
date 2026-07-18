// ============================================================
// core/widgets/super_sliver_app_bar.dart
// ------------------------------------------------------------
// SuperSliverAppBar — a forked, fully-customizable GeniusLink sliver app bar.
//
// A first-class re-implementation of Flutter's [SliverAppBar]: it exposes the
// full sliver-app-bar surface (pinned / floating / snap / stretch,
// expandedHeight / collapsedHeight / toolbarHeight, flexibleSpace, bottom,
// forceElevated, elevation, colors, icon + text themes, systemOverlayStyle, …)
// via a [SliverPersistentHeader] + delegate, and reuses [SuperAppBar] for the
// toolbar chrome so the GeniusLink subtitle ([subtitle]/[subtitlePosition]) and
// responsive action-overflow ([maxActions] + per-device limits) behave exactly
// as they do in the box app bar.
//
// Defaults come from the ambient [SuperAppBarTheme].
//
//   CustomScrollView(slivers: [
//     SuperSliverAppBar(
//       pinned: true,
//       expandedHeight: 200,
//       title: const Text('Journal'),
//       subtitle: const Text('Banking • Local Transfers'),
//       flexibleSpace: const FlexibleSpaceBar(background: LedgerHeaderArt()),
//       actions: [ /* overflow past maxActions */ ],
//     ),
//     // … content slivers …
//   ]);
// ============================================================

import 'dart:math' as math;

import 'package:flutter/foundation.dart' show AsyncCallback;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show PersistentHeaderShowOnScreenConfiguration, FloatingHeaderSnapConfiguration, OverScrollHeaderStretchConfiguration;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../theme/super_app_bar_theme.dart';
import 'super_app_bar.dart';

export '../theme/super_app_bar_theme.dart' show SubtitlePosition, SuperAppBarTheme;

/// A GeniusLink sliver app bar forked from Material's [SliverAppBar], with a
/// positionable [subtitle] and responsive action overflow.
class SuperSliverAppBar extends StatefulWidget {
  /// Creates a Super sliver app bar. Parameters mirror [SliverAppBar] unless
  /// documented otherwise; the Super-specific parameters are listed first.
  const SuperSliverAppBar({
    super.key,
    // ── Super-specific ──
    this.subtitle,
    this.subtitlePosition,
    this.subtitleTextStyle,
    this.maxActions,
    this.maxMobileActions,
    this.maxTabletActions,
    this.maxDesktopActions,
    this.overflowIcon,
    // ── SliverAppBar parity ──
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.forceElevated = false,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.collapsedHeight,
    this.expandedHeight,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.shape,
    this.toolbarHeight = kToolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
  }) : assert(
         floating || !snap,
         'The "snap" argument only makes sense for floating app bars.',
       ),
       assert(
         collapsedHeight == null || collapsedHeight >= toolbarHeight,
         'The "collapsedHeight" argument has to be larger than or equal to '
         '"toolbarHeight".',
       );

  // ── Super-specific properties ──

  /// A secondary line positioned by [subtitlePosition].
  final Widget? subtitle;

  /// Where [subtitle] sits relative to [title].
  final SubtitlePosition? subtitlePosition;

  /// Style for [subtitle].
  final TextStyle? subtitleTextStyle;

  /// Max inline actions before extras collapse into a ⋮ overflow.
  final int? maxActions;

  /// Inline-action limit on mobile (falls back to theme / 3).
  final int? maxMobileActions;

  /// Inline-action limit on tablet (falls back to theme / 4).
  final int? maxTabletActions;

  /// Inline-action limit on desktop (falls back to theme / 5).
  final int? maxDesktopActions;

  /// Icon for the overflow button.
  final IconData? overflowIcon;

  // ── SliverAppBar parity ──

  /// {@macro flutter.material.appbar.leading}
  final Widget? leading;

  /// {@macro flutter.material.appbar.automaticallyImplyLeading}
  final bool automaticallyImplyLeading;

  /// The title.
  final Widget? title;

  /// Trailing action widgets (subject to [maxActions] overflow).
  final List<Widget>? actions;

  /// The widget behind the toolbar (typically a [FlexibleSpaceBar]).
  final Widget? flexibleSpace;

  /// The bottom of the app bar (e.g. a `TabBar`).
  final PreferredSizeWidget? bottom;

  /// Resting elevation.
  final double? elevation;

  /// Elevation when content scrolls under the bar.
  final double? scrolledUnderElevation;

  /// Shadow color.
  final Color? shadowColor;

  /// Surface-tint color at elevation.
  final Color? surfaceTintColor;

  /// Whether to always show elevation even when not scrolled under.
  final bool forceElevated;

  /// Fill color.
  final Color? backgroundColor;

  /// Default color for text and icons.
  final Color? foregroundColor;

  /// Icon theme for the leading + title-row icons.
  final IconThemeData? iconTheme;

  /// Icon theme for the actions.
  final IconThemeData? actionsIconTheme;

  /// Whether the bar sits at the top of the screen (status-bar padding).
  final bool primary;

  /// Whether the title is centered.
  final bool? centerTitle;

  /// Whether to exclude the toolbar semantics from the header semantics.
  final bool excludeHeaderSemantics;

  /// Horizontal spacing around the title.
  final double? titleSpacing;

  /// Height of the bar when fully collapsed. Defaults to [toolbarHeight].
  final double? collapsedHeight;

  /// Height of the bar when fully expanded (with [flexibleSpace]).
  final double? expandedHeight;

  /// Whether the bar becomes visible as soon as the user scrolls toward it.
  final bool floating;

  /// Whether the bar stays visible at the start of the scroll view.
  final bool pinned;

  /// Whether a floating bar should snap into view.
  final bool snap;

  /// Whether the bar can stretch past its full size on overscroll.
  final bool stretch;

  /// Overscroll offset that triggers [onStretchTrigger].
  final double stretchTriggerOffset;

  /// Callback fired when the stretch trigger offset is reached.
  final AsyncCallback? onStretchTrigger;

  /// The Material shape.
  final ShapeBorder? shape;

  /// The collapsed toolbar height.
  final double toolbarHeight;

  /// Width allocated to the leading widget.
  final double? leadingWidth;

  /// Default text style for the toolbar's non-title text.
  final TextStyle? toolbarTextStyle;

  /// Text style for the title.
  final TextStyle? titleTextStyle;

  /// System overlay style while the bar is shown.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Forces the Material to be fully transparent.
  final bool forceMaterialTransparency;

  /// Clip behavior for [flexibleSpace].
  final Clip? clipBehavior;

  @override
  State<SuperSliverAppBar> createState() => _SuperSliverAppBarState();
}

class _SuperSliverAppBarState extends State<SuperSliverAppBar>
    with TickerProviderStateMixin {
  FloatingHeaderSnapConfiguration? _snapConfiguration;
  OverScrollHeaderStretchConfiguration? _stretchConfiguration;
  PersistentHeaderShowOnScreenConfiguration? _showOnScreenConfiguration;

  void _updateSnapConfiguration() {
    if (widget.snap && widget.floating) {
      _snapConfiguration = FloatingHeaderSnapConfiguration(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    } else {
      _snapConfiguration = null;
    }

    _showOnScreenConfiguration = widget.floating & widget.snap
        ? const PersistentHeaderShowOnScreenConfiguration(
            minShowOnScreenExtent: double.infinity,
          )
        : null;
  }

  void _updateStretchConfiguration() {
    if (widget.stretch) {
      _stretchConfiguration = OverScrollHeaderStretchConfiguration(
        stretchTriggerOffset: widget.stretchTriggerOffset,
        onStretchTrigger: widget.onStretchTrigger,
      );
    } else {
      _stretchConfiguration = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _updateSnapConfiguration();
    _updateStretchConfiguration();
  }

  @override
  void didUpdateWidget(SuperSliverAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.snap != oldWidget.snap || widget.floating != oldWidget.floating) {
      _updateSnapConfiguration();
    }
    if (widget.stretch != oldWidget.stretch) {
      _updateStretchConfiguration();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomHeight = widget.bottom?.preferredSize.height ?? 0.0;
    final double topPadding =
        widget.primary ? MediaQuery.paddingOf(context).top : 0.0;
    final double collapsedHeight =
        (widget.pinned && widget.floating && widget.bottom != null)
            ? (widget.collapsedHeight ?? 0.0) + bottomHeight + topPadding
            : (widget.collapsedHeight ?? widget.toolbarHeight) +
                bottomHeight +
                topPadding;
    final double effectiveExpandedHeight =
        (widget.expandedHeight ?? widget.toolbarHeight) +
            bottomHeight +
            topPadding;
    final double maxExtent =
        math.max(effectiveExpandedHeight, collapsedHeight);

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: SliverPersistentHeader(
        floating: widget.floating,
        pinned: widget.pinned,
        delegate: _SuperSliverAppBarDelegate(
          vsync: this,
          minExtent: collapsedHeight,
          maxExtent: maxExtent,
          topPadding: topPadding,
          toolbarHeight: widget.toolbarHeight,
          bottomHeight: bottomHeight,
          // widget config
          subtitle: widget.subtitle,
          subtitlePosition: widget.subtitlePosition,
          subtitleTextStyle: widget.subtitleTextStyle,
          maxActions: widget.maxActions,
          maxMobileActions: widget.maxMobileActions,
          maxTabletActions: widget.maxTabletActions,
          maxDesktopActions: widget.maxDesktopActions,
          overflowIcon: widget.overflowIcon,
          leading: widget.leading,
          automaticallyImplyLeading: widget.automaticallyImplyLeading,
          title: widget.title,
          actions: widget.actions,
          flexibleSpace: widget.flexibleSpace,
          bottom: widget.bottom,
          elevation: widget.elevation,
          scrolledUnderElevation: widget.scrolledUnderElevation,
          shadowColor: widget.shadowColor,
          surfaceTintColor: widget.surfaceTintColor,
          forceElevated: widget.forceElevated,
          backgroundColor: widget.backgroundColor,
          foregroundColor: widget.foregroundColor,
          iconTheme: widget.iconTheme,
          actionsIconTheme: widget.actionsIconTheme,
          primary: widget.primary,
          centerTitle: widget.centerTitle,
          excludeHeaderSemantics: widget.excludeHeaderSemantics,
          titleSpacing: widget.titleSpacing,
          floating: widget.floating,
          pinned: widget.pinned,
          shape: widget.shape,
          leadingWidth: widget.leadingWidth,
          toolbarTextStyle: widget.toolbarTextStyle,
          titleTextStyle: widget.titleTextStyle,
          systemOverlayStyle: widget.systemOverlayStyle,
          forceMaterialTransparency: widget.forceMaterialTransparency,
          clipBehavior: widget.clipBehavior,
          snapConfiguration: _snapConfiguration,
          stretchConfiguration: _stretchConfiguration,
          showOnScreenConfiguration: _showOnScreenConfiguration,
        ),
      ),
    );
  }
}

class _SuperSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SuperSliverAppBarDelegate({
    required this.vsync,
    required double minExtent,
    required double maxExtent,
    required this.topPadding,
    required this.toolbarHeight,
    required this.bottomHeight,
    required this.subtitle,
    required this.subtitlePosition,
    required this.subtitleTextStyle,
    required this.maxActions,
    required this.maxMobileActions,
    required this.maxTabletActions,
    required this.maxDesktopActions,
    required this.overflowIcon,
    required this.leading,
    required this.automaticallyImplyLeading,
    required this.title,
    required this.actions,
    required this.flexibleSpace,
    required this.bottom,
    required this.elevation,
    required this.scrolledUnderElevation,
    required this.shadowColor,
    required this.surfaceTintColor,
    required this.forceElevated,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconTheme,
    required this.actionsIconTheme,
    required this.primary,
    required this.centerTitle,
    required this.excludeHeaderSemantics,
    required this.titleSpacing,
    required this.floating,
    required this.pinned,
    required this.shape,
    required this.leadingWidth,
    required this.toolbarTextStyle,
    required this.titleTextStyle,
    required this.systemOverlayStyle,
    required this.forceMaterialTransparency,
    required this.clipBehavior,
    required this.snapConfiguration,
    required this.stretchConfiguration,
    required this.showOnScreenConfiguration,
  })  : _minExtent = minExtent,
        _maxExtent = maxExtent;

  @override
  final TickerProvider vsync;
  final double _minExtent;
  final double _maxExtent;
  final double topPadding;
  final double toolbarHeight;
  final double bottomHeight;

  final Widget? subtitle;
  final SubtitlePosition? subtitlePosition;
  final TextStyle? subtitleTextStyle;
  final int? maxActions;
  final int? maxMobileActions;
  final int? maxTabletActions;
  final int? maxDesktopActions;
  final IconData? overflowIcon;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final bool forceElevated;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final bool floating;
  final bool pinned;
  final ShapeBorder? shape;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;
  final Clip? clipBehavior;

  @override
  final FloatingHeaderSnapConfiguration? snapConfiguration;
  @override
  final OverScrollHeaderStretchConfiguration? stretchConfiguration;
  @override
  final PersistentHeaderShowOnScreenConfiguration? showOnScreenConfiguration;

  @override
  double get minExtent => _minExtent;
  @override
  double get maxExtent => _maxExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double visibleMainHeight = maxExtent - shrinkOffset - topPadding;
    final double extraToolbarHeight =
        math.max(minExtent - topPadding - toolbarHeight - bottomHeight, 0.0);
    final double visibleToolbarHeight =
        visibleMainHeight - bottomHeight - extraToolbarHeight;
    final bool isPinnedWithOpacityFade =
        pinned && floating && bottom != null;
    final double toolbarOpacity = (!pinned || isPinnedWithOpacityFade)
        ? (visibleToolbarHeight / toolbarHeight).clamp(0.0, 1.0)
        : 1.0;
    final double bottomOpacity = pinned
        ? 1.0
        : bottomHeight == 0
            ? 1.0
            : (visibleMainHeight / bottomHeight).clamp(0.0, 1.0);

    final bool isScrolledUnder =
        overlapsContent || (pinned && shrinkOffset > maxExtent - minExtent);
    final double resting = elevation ?? 0.0;
    final double effectiveElevation =
        forceElevated || isScrolledUnder ? (scrolledUnderElevation ?? 3.0) : resting;

    final Color resolvedBg =
        backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final bool hasFlexible = flexibleSpace != null;

    final Widget toolbar = SuperAppBar(
      subtitle: subtitle,
      subtitlePosition: subtitlePosition,
      subtitleTextStyle: subtitleTextStyle,
      maxActions: maxActions,
      maxMobileActions: maxMobileActions,
      maxTabletActions: maxTabletActions,
      maxDesktopActions: maxDesktopActions,
      overflowIcon: overflowIcon,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      bottom: bottom,
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      systemOverlayStyle: systemOverlayStyle,
      shape: hasFlexible ? null : shape,
      clipBehavior: clipBehavior,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      // When a flexibleSpace is present, the surface + elevation are painted by
      // the fill Material below and the toolbar rides transparently on top.
      backgroundColor: hasFlexible ? Colors.transparent : resolvedBg,
      foregroundColor: foregroundColor,
      elevation: hasFlexible ? 0.0 : effectiveElevation,
      scrolledUnderElevation: hasFlexible ? 0.0 : effectiveElevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      forceMaterialTransparency: hasFlexible || forceMaterialTransparency,
    );

    if (!hasFlexible) {
      return toolbar;
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: Material(
            color: forceMaterialTransparency ? Colors.transparent : resolvedBg,
            elevation: forceMaterialTransparency ? 0.0 : effectiveElevation,
            shadowColor: shadowColor ?? Theme.of(context).shadowColor,
            surfaceTintColor: surfaceTintColor ?? Colors.transparent,
            shape: shape,
            clipBehavior: clipBehavior ?? Clip.none,
            child: const SizedBox.expand(),
          ),
        ),
        Positioned.fill(
          child: FlexibleSpaceBar.createSettings(
            minExtent: minExtent,
            maxExtent: maxExtent,
            currentExtent: math.max(minExtent, maxExtent - shrinkOffset),
            toolbarOpacity: toolbarOpacity,
            child: flexibleSpace!,
          ),
        ),
        Positioned(top: 0.0, left: 0.0, right: 0.0, child: toolbar),
      ],
    );
  }

  @override
  bool shouldRebuild(_SuperSliverAppBarDelegate old) {
    return minExtent != old.minExtent ||
        maxExtent != old.maxExtent ||
        topPadding != old.topPadding ||
        toolbarHeight != old.toolbarHeight ||
        bottomHeight != old.bottomHeight ||
        subtitle != old.subtitle ||
        subtitlePosition != old.subtitlePosition ||
        subtitleTextStyle != old.subtitleTextStyle ||
        maxActions != old.maxActions ||
        maxMobileActions != old.maxMobileActions ||
        maxTabletActions != old.maxTabletActions ||
        maxDesktopActions != old.maxDesktopActions ||
        overflowIcon != old.overflowIcon ||
        leading != old.leading ||
        automaticallyImplyLeading != old.automaticallyImplyLeading ||
        title != old.title ||
        actions != old.actions ||
        flexibleSpace != old.flexibleSpace ||
        bottom != old.bottom ||
        elevation != old.elevation ||
        scrolledUnderElevation != old.scrolledUnderElevation ||
        shadowColor != old.shadowColor ||
        surfaceTintColor != old.surfaceTintColor ||
        forceElevated != old.forceElevated ||
        backgroundColor != old.backgroundColor ||
        foregroundColor != old.foregroundColor ||
        iconTheme != old.iconTheme ||
        actionsIconTheme != old.actionsIconTheme ||
        primary != old.primary ||
        centerTitle != old.centerTitle ||
        titleSpacing != old.titleSpacing ||
        floating != old.floating ||
        pinned != old.pinned ||
        shape != old.shape ||
        leadingWidth != old.leadingWidth ||
        toolbarTextStyle != old.toolbarTextStyle ||
        titleTextStyle != old.titleTextStyle ||
        systemOverlayStyle != old.systemOverlayStyle ||
        forceMaterialTransparency != old.forceMaterialTransparency ||
        clipBehavior != old.clipBehavior ||
        snapConfiguration != old.snapConfiguration ||
        stretchConfiguration != old.stretchConfiguration ||
        showOnScreenConfiguration != old.showOnScreenConfiguration;
  }
}
