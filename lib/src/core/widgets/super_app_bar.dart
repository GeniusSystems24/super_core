// ============================================================
// core/widgets/super_app_bar.dart
// ------------------------------------------------------------
// SuperAppBar — a forked, fully-customizable GeniusLink app bar.
//
// This is a first-class re-implementation of Flutter's Material [AppBar]: it
// exposes every AppBar property (leading, title, actions, flexibleSpace,
// bottom, elevation, scrolledUnderElevation, shadow/surfaceTint colors,
// background/foreground, icon themes, title/toolbar text styles, centerTitle,
// titleSpacing, toolbarHeight, leadingWidth, primary, systemOverlayStyle,
// clipBehavior, …) and mirrors AppBar's theme-resolution precedence
// (widget > SuperAppBarTheme/AppBarTheme > Material defaults) and its
// scrolled-under elevation behavior (via [ScrollNotificationObserver]).
//
// On top of the stock app bar it adds two GeniusLink features:
//   • [subtitle] + [subtitlePosition] — a secondary line above OR below the
//     title.
//   • responsive action overflow — at most [maxActions] inline action buttons
//     (resolved per device class from maxMobile/Tablet/DesktopActions); any
//     extras collapse into a trailing three-dot [PopupMenuButton].
//
// Defaults come from the ambient [SuperAppBarTheme] that `SuperMaterialThemeData`
// installs into `ThemeData.appBarTheme`.
//
//   Scaffold(
//     appBar: SuperAppBar(
//       title: const Text('Create Store'),
//       subtitle: const Text('Stores & Products • Stores'),
//       subtitlePosition: SubtitlePosition.above,
//       actions: [ /* > maxActions collapse into a ⋮ menu */ ],
//     ),
//   );
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OrdinalSortKey;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../theme/super_app_bar_theme.dart';
import '../theme/super_device_mode.dart';

export '../theme/super_app_bar_theme.dart' show SubtitlePosition, SuperAppBarTheme;

/// A GeniusLink app bar forked from Material's [AppBar], with a positionable
/// [subtitle] and responsive action overflow. Implements [PreferredSizeWidget]
/// so it drops straight into `Scaffold.appBar`.
class SuperAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates a Super app bar. Every parameter mirrors the equivalent [AppBar]
  /// property unless documented otherwise; the Super-specific parameters
  /// ([subtitle], [subtitlePosition], [maxActions] and friends) are listed
  /// first.
  SuperAppBar({
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
    // ── AppBar parity ──
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
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
  }) : preferredSize = _PreferredSuperAppBarSize(
         toolbarHeight,
         bottom?.preferredSize.height,
         subtitle != null,
       );

  // ── Super-specific properties ──

  /// A secondary line rendered with [subtitleTextStyle], positioned by
  /// [subtitlePosition]. Null hides the subtitle.
  final Widget? subtitle;

  /// Where [subtitle] sits relative to [title]. Falls back to the
  /// [SuperAppBarTheme] value ([SubtitlePosition.below]).
  final SubtitlePosition? subtitlePosition;

  /// Style for [subtitle]. Falls back to the [SuperAppBarTheme] subtitle style,
  /// then a de-emphasized `bodySmall`.
  final TextStyle? subtitleTextStyle;

  /// Maximum inline action buttons before extras collapse into a ⋮ overflow.
  /// When null the limit is resolved responsively (see [maxMobileActions] etc.).
  final int? maxActions;

  /// Inline-action limit on a mobile-width layout (falls back to theme / 3).
  final int? maxMobileActions;

  /// Inline-action limit on a tablet-width layout (falls back to theme / 4).
  final int? maxTabletActions;

  /// Inline-action limit on a desktop-width layout (falls back to theme / 5).
  final int? maxDesktopActions;

  /// Icon for the overflow button. Defaults to [Icons.more_vert].
  final IconData? overflowIcon;

  // ── AppBar parity properties (see [AppBar] for full docs) ──

  /// {@macro flutter.material.appbar.leading}
  final Widget? leading;

  /// {@macro flutter.material.appbar.automaticallyImplyLeading}
  final bool automaticallyImplyLeading;

  /// The primary widget displayed in the app bar (the title).
  final Widget? title;

  /// Action widgets displayed after the title. Subject to [maxActions] overflow.
  final List<Widget>? actions;

  /// Displayed behind the toolbar and bottom; typically a [FlexibleSpaceBar].
  final Widget? flexibleSpace;

  /// Shown at the bottom of the app bar (often a `TabBar`).
  final PreferredSizeWidget? bottom;

  /// Resting Material elevation.
  final double? elevation;

  /// Elevation when content scrolls under the app bar.
  final double? scrolledUnderElevation;

  /// Shadow color for the resting / scrolled-under elevation.
  final Color? shadowColor;

  /// Surface-tint color applied at elevation (M3).
  final Color? surfaceTintColor;

  /// The Material shape (e.g. a bottom hairline border).
  final ShapeBorder? shape;

  /// Fill color. Defaults to the theme app-bar background / `colorScheme.surface`.
  final Color? backgroundColor;

  /// Default color for text and icons within the bar.
  final Color? foregroundColor;

  /// Icon theme for the leading widget + title-row icons.
  final IconThemeData? iconTheme;

  /// Icon theme for the [actions].
  final IconThemeData? actionsIconTheme;

  /// Whether the bar sits at the top of the screen (adds status-bar padding).
  final bool primary;

  /// Whether the title is centered. Falls back to theme / platform default.
  final bool? centerTitle;

  /// Whether to exclude the toolbar's semantics from the header semantics.
  final bool excludeHeaderSemantics;

  /// Horizontal spacing around the title.
  final double? titleSpacing;

  /// Opacity of the toolbar contents.
  final double toolbarOpacity;

  /// Opacity of the bottom contents.
  final double bottomOpacity;

  /// The toolbar height. Defaults to [kToolbarHeight] (+ subtitle allowance).
  final double? toolbarHeight;

  /// Width allocated to the leading widget.
  final double? leadingWidth;

  /// Default text style for the toolbar's non-title text.
  final TextStyle? toolbarTextStyle;

  /// Text style for the title.
  final TextStyle? titleTextStyle;

  /// System overlay style (status / navigation bar) while the bar is shown.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Forces the Material behind the bar to be fully transparent.
  final bool forceMaterialTransparency;

  /// Clip behavior for [flexibleSpace].
  final Clip? clipBehavior;

  @override
  final Size preferredSize;

  @override
  State<SuperAppBar> createState() => _SuperAppBarState();
}

class _SuperAppBarState extends State<SuperAppBar> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
    }
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && defaultScrollNotificationPredicate(notification)) {
      final bool oldScrolledUnder = _scrolledUnder;
      final ScrollMetrics metrics = notification.metrics;
      _scrolledUnder = switch (metrics.axisDirection) {
        AxisDirection.up => metrics.extentAfter > 0,
        AxisDirection.down => metrics.extentBefore > 0,
        AxisDirection.right || AxisDirection.left => false,
      };
      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {/* rebuild for the scrolled-under elevation */});
      }
    }
  }

  bool _getEffectiveCenterTitle(ThemeData theme, SuperAppBarTheme appBarTheme) {
    if (widget.centerTitle != null) return widget.centerTitle!;
    if (appBarTheme.centerTitle != null) return appBarTheme.centerTitle!;
    return switch (theme.platform) {
      TargetPlatform.android ||
      TargetPlatform.fuchsia ||
      TargetPlatform.linux ||
      TargetPlatform.windows => false,
      TargetPlatform.iOS || TargetPlatform.macOS => widget.actions == null || widget.actions!.length < 2,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final SuperAppBarTheme appBarTheme = SuperAppBarTheme.of(context);
    final SuperDeviceMode mode = SuperDeviceMode.of(context);
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);

    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    final Color backgroundColor =
        widget.backgroundColor ?? appBarTheme.backgroundColor ?? colorScheme.surface;
    final Color foregroundColor =
        widget.foregroundColor ?? appBarTheme.foregroundColor ?? colorScheme.onSurface;
    final double toolbarHeight =
        widget.toolbarHeight ?? appBarTheme.toolbarHeight ?? _defaultToolbarHeight;
    final double elevation = widget.elevation ?? appBarTheme.elevation ?? 0.0;
    final double scrolledUnderElevation =
        widget.scrolledUnderElevation ?? appBarTheme.scrolledUnderElevation ?? 3.0;
    final double effectiveElevation = _scrolledUnder ? scrolledUnderElevation : elevation;

    IconThemeData overallIconTheme = widget.iconTheme ??
        appBarTheme.iconTheme ??
        theme.iconTheme.copyWith(color: foregroundColor);
    IconThemeData actionsIconTheme = widget.actionsIconTheme ??
        appBarTheme.actionsIconTheme ??
        overallIconTheme;

    TextStyle? toolbarTextStyle = widget.toolbarTextStyle ??
        appBarTheme.toolbarTextStyle ??
        theme.textTheme.bodyMedium?.copyWith(color: foregroundColor);
    TextStyle? titleTextStyle = widget.titleTextStyle ??
        appBarTheme.titleTextStyle ??
        theme.textTheme.titleLarge?.copyWith(color: foregroundColor);
    final TextStyle? subtitleStyle = widget.subtitleTextStyle ??
        appBarTheme.subtitleTextStyle ??
        theme.textTheme.bodySmall?.copyWith(color: foregroundColor.withValues(alpha: 0.75));

    final bool centerTitle = _getEffectiveCenterTitle(theme, appBarTheme);
    final double titleSpacing =
        widget.titleSpacing ?? appBarTheme.titleSpacing ?? NavigationToolbar.kMiddleSpacing;

    // ── Leading ──
    Widget? leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (hasDrawer) {
        leading = DrawerButton(onPressed: () => Scaffold.of(context).openDrawer());
      } else if (!hasEndDrawer && canPop) {
        leading = useCloseButton ? const CloseButton() : const BackButton();
      }
    }
    if (leading != null) {
      leading = ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: widget.leadingWidth ?? kToolbarHeight),
        child: leading,
      );
    }

    // ── Title (+ subtitle) ──
    Widget? title = widget.title;
    if (title != null) {
      title = DefaultTextStyle(
        style: titleTextStyle ?? const TextStyle(),
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: title,
      );
      if (widget.subtitle != null) {
        final SubtitlePosition pos =
            widget.subtitlePosition ?? appBarTheme.effectiveSubtitlePosition;
        final Widget sub = DefaultTextStyle(
          style: subtitleStyle ?? const TextStyle(),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          child: widget.subtitle!,
        );
        title = Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: pos == SubtitlePosition.above ? [sub, title] : [title, sub],
        );
      }
    }

    // ── Actions (with responsive overflow) ──
    Widget? actions;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      final int limit = widget.maxActions ??
          (widget.maxMobileActions != null ||
                  widget.maxTabletActions != null ||
                  widget.maxDesktopActions != null
              ? _perDeviceLimit(mode)
              : appBarTheme.maxActionsFor(mode));
      final List<Widget> all = widget.actions!;
      final List<Widget> children;
      if (all.length <= limit) {
        children = List<Widget>.of(all);
      } else {
        final List<Widget> inline = all.sublist(0, limit);
        final List<Widget> overflow = all.sublist(limit);
        children = [
          ...inline,
          PopupMenuButton<int>(
            icon: Icon(widget.overflowIcon ?? Icons.more_vert),
            tooltip: MaterialLocalizations.of(context).showMenuTooltip,
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              for (int i = 0; i < overflow.length; i++)
                PopupMenuItem<int>(value: i, child: overflow[i]),
            ],
          ),
        ];
      }
      actions = Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: children);
      actions = IconButtonTheme(
        data: IconButtonThemeData(
          style: IconButton.styleFrom(foregroundColor: actionsIconTheme.color),
        ),
        child: actions,
      );
    }

    // ── Toolbar ──
    final Widget toolbar = NavigationToolbar(
      leading: leading,
      middle: title,
      trailing: actions,
      centerMiddle: centerTitle,
      middleSpacing: titleSpacing,
    );

    Widget appBar = ClipRect(
      clipBehavior: widget.clipBehavior ?? Clip.hardEdge,
      child: CustomSingleChildLayout(
        delegate: const _ToolbarContainerLayout(),
        child: IconTheme.merge(
          data: overallIconTheme,
          child: DefaultTextStyle(
            style: toolbarTextStyle ?? const TextStyle(),
            child: SizedBox(height: toolbarHeight, child: toolbar),
          ),
        ),
      ),
    );

    // ── Toolbar + bottom ──
    appBar = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: toolbarHeight),
            child: Opacity(opacity: widget.toolbarOpacity, child: appBar),
          ),
        ),
        if (widget.bottom != null)
          widget.bottomOpacity == 1.0
              ? widget.bottom!
              : Opacity(
                  opacity: const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.bottomOpacity),
                  child: widget.bottom,
                ),
      ],
    );

    // ── Flexible space behind the toolbar ──
    if (widget.flexibleSpace != null) {
      appBar = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Semantics(sortKey: const OrdinalSortKey(1.0), explicitChildNodes: true, child: widget.flexibleSpace),
          Semantics(sortKey: const OrdinalSortKey(0.0), explicitChildNodes: true, child: appBar),
        ],
      );
    }

    final SystemUiOverlayStyle overlayStyle = widget.systemOverlayStyle ??
        appBarTheme.systemOverlayStyle ??
        _overlayStyleFor(backgroundColor);

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          color: widget.forceMaterialTransparency ? Colors.transparent : backgroundColor,
          elevation: widget.forceMaterialTransparency ? 0.0 : effectiveElevation,
          shadowColor: widget.shadowColor ?? appBarTheme.shadowColor ?? theme.shadowColor,
          surfaceTintColor: widget.surfaceTintColor ?? appBarTheme.surfaceTintColor ?? Colors.transparent,
          shape: widget.shape ?? appBarTheme.shape,
          child: Semantics(
            explicitChildNodes: true,
            child: SafeArea(
              bottom: false,
              top: widget.primary,
              child: appBar,
            ),
          ),
        ),
      ),
    );
  }

  double get _defaultToolbarHeight =>
      widget.subtitle != null ? kToolbarHeight + 18.0 : kToolbarHeight;

  int _perDeviceLimit(SuperDeviceMode mode) => switch (mode) {
    SuperDeviceMode.mobile => widget.maxMobileActions ?? SuperAppBarTheme.defaultMobileActions,
    SuperDeviceMode.tablet => widget.maxTabletActions ?? SuperAppBarTheme.defaultTabletActions,
    SuperDeviceMode.desktop => widget.maxDesktopActions ?? SuperAppBarTheme.defaultDesktopActions,
  };

  static SystemUiOverlayStyle _overlayStyleFor(Color background) {
    final bool darkBar = background.computeLuminance() < 0.5;
    return SystemUiOverlayStyle(
      statusBarColor: background,
      statusBarIconBrightness: darkBar ? Brightness.light : Brightness.dark,
      statusBarBrightness: darkBar ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: background,
      systemNavigationBarIconBrightness: darkBar ? Brightness.light : Brightness.dark,
    );
  }
}

/// Centers the toolbar within the available height and gives it the incoming
/// max width — the same job Flutter's private `_ToolbarContainerLayout` does.
class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
  const _ToolbarContainerLayout();

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.tighten(height: constraints.maxHeight);

  @override
  Size getSize(BoxConstraints constraints) =>
      Size(constraints.maxWidth, constraints.maxHeight);

  @override
  Offset getPositionForChild(Size size, Size childSize) =>
      Offset(0.0, size.height - childSize.height);

  @override
  bool shouldRelayout(_ToolbarContainerLayout oldDelegate) => false;
}

/// Mirrors Flutter's private `_PreferredAppBarSize`: the preferred height is the
/// toolbar height plus the bottom's height. When [_hasSubtitle] is set and no
/// explicit toolbar height was given, an allowance is added for the subtitle.
class _PreferredSuperAppBarSize extends Size {
  _PreferredSuperAppBarSize(this.toolbarHeight, this.bottomHeight, this.hasSubtitle)
      : super.fromHeight(
          (toolbarHeight ?? (hasSubtitle ? kToolbarHeight + 18.0 : kToolbarHeight)) +
              (bottomHeight ?? 0),
        );

  final double? toolbarHeight;
  final double? bottomHeight;
  final bool hasSubtitle;
}
