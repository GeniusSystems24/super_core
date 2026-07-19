// ============================================================
// core/widgets/super_slider.dart
// ------------------------------------------------------------
// SuperSlider — the GeniusLink content carousel. A professional, reusable
// horizontal slider for ERP dashboards (KPI cards, store tiles, recent docs)
// and e-commerce surfaces (product / banner carousels). Features:
//
//   • Static [children] OR lazy [itemBuilder] + [itemCount].
//   • Responsive items-per-view via a [SuperResponsive<int>] (1 / 2 / 3 by
//     default) resolved from the ambient viewport width.
//   • Optional [peek] so the next card hints past the viewport edge.
//   • Snapping paged scroll, [gap] between items, [height] or [aspectRatio].
//   • Autoplay (pauses on hover / drag), [loop] wrap-around.
//   • Brand chevron arrows + an animated page indicator (both optional).
//   • RTL-aware (Arabic) and driven by an optional [SuperSliderController] so
//     host modules can wire external prev/next controls.
//
// All surfaces / motion / spacing resolve from the ambient theme.
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/super_device_mode.dart';

/// Imperative handle for a [SuperSlider] — lets a host module drive navigation
/// (external buttons, keyboard shortcuts) and observe the active page.
class SuperSliderController extends ChangeNotifier {
  int _index = 0;
  int _count = 0;
  bool _loop = false;
  void Function(int page)? _animate;

  /// The active page index.
  int get index => _index;

  /// Total number of pages.
  int get count => _count;

  bool get canGoPrevious => _loop ? _count > 1 : _index > 0;
  bool get canGoNext => _loop ? _count > 1 : _index < _count - 1;

  /// Animate to [page] (wraps when the slider loops).
  void animateTo(int page) => _animate?.call(page);

  /// Advance one page.
  void next() {
    if (canGoNext) _animate?.call(_loop ? _index + 1 : (_index + 1).clamp(0, _count - 1));
  }

  /// Go back one page.
  void previous() {
    if (canGoPrevious) _animate?.call(_loop ? _index - 1 : (_index - 1).clamp(0, _count - 1));
  }

  void _bind(int count, bool loop, void Function(int page) animate) {
    _count = count;
    _loop = loop;
    _animate = animate;
  }

  void _sync(int index) {
    if (_index == index) return;
    _index = index;
    notifyListeners();
  }
}

/// A responsive, snapping content carousel. Provide either [children] or
/// ([itemBuilder] + [itemCount]).
class SuperSlider extends StatefulWidget {
  const SuperSlider({
    super.key,
    this.children,
    this.itemBuilder,
    this.itemCount,
    this.visibleItems = const SuperResponsive<int>(mobile: 1, tablet: 2, desktop: 3),
    this.height,
    this.aspectRatio,
    this.gap,
    this.peek = 0,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.loop = false,
    this.showArrows = true,
    this.showIndicator = true,
    this.padding = EdgeInsets.zero,
    this.onIndexChanged,
    this.controller,
  })  : assert(children != null || (itemBuilder != null && itemCount != null),
            'Provide either children or itemBuilder + itemCount.'),
        assert(height != null || aspectRatio != null,
            'Provide either a height or an aspectRatio.');

  /// Static item list. Mutually exclusive with [itemBuilder].
  final List<Widget>? children;

  /// Lazy item builder. Requires [itemCount].
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final int? itemCount;

  /// How many items are fully visible per viewport, per form-factor.
  final SuperResponsive<int> visibleItems;

  /// Fixed viewport height. Takes precedence over [aspectRatio].
  final double? height;

  /// Per-item aspect ratio (used when [height] is null).
  final double? aspectRatio;

  /// Gap between items. Defaults to the responsive `spacing.md`.
  final double? gap;

  /// Pixels of the adjacent item revealed past the viewport edge.
  final double peek;

  final bool autoPlay;
  final Duration autoPlayInterval;

  /// Wrap from last → first (and power infinite autoplay).
  final bool loop;

  final bool showArrows;
  final bool showIndicator;

  /// Outer padding around the whole slider (viewport + controls).
  final EdgeInsetsGeometry padding;

  /// Called with the active page index whenever it settles.
  final ValueChanged<int>? onIndexChanged;

  /// Optional external controller.
  final SuperSliderController? controller;

  @override
  State<SuperSlider> createState() => _SuperSliderState();
}

class _SuperSliderState extends State<SuperSlider> {
  PageController? _page;
  double _fraction = 1;
  int _index = 0;
  double _pageOffset = 0;
  Timer? _timer;
  bool _paused = false;

  int get _count => widget.itemCount ?? widget.children!.length;

  Widget _itemAt(BuildContext c, int i) =>
      widget.itemBuilder != null ? widget.itemBuilder!(c, i) : widget.children![i];

  @override
  void initState() {
    super.initState();
    widget.controller?._bind(_count, widget.loop, _animateTo);
    _restartAutoPlay();
  }

  @override
  void didUpdateWidget(covariant SuperSlider old) {
    super.didUpdateWidget(old);
    widget.controller?._bind(_count, widget.loop, _animateTo);
    if (old.autoPlay != widget.autoPlay ||
        old.autoPlayInterval != widget.autoPlayInterval) {
      _restartAutoPlay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page?.dispose();
    super.dispose();
  }

  void _restartAutoPlay() {
    _timer?.cancel();
    if (!widget.autoPlay || _count < 2) return;
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (_paused || !mounted || _page == null || !_page!.hasClients) return;
      final next = _index + 1;
      _animateTo(widget.loop ? next : (next >= _count ? 0 : next));
    });
  }

  void _animateTo(int page) {
    if (_page == null || !_page!.hasClients) return;
    final target = widget.loop ? page : page.clamp(0, _count - 1);
    _page!.animateToPage(target,
        duration: const Duration(milliseconds: 360), curve: Curves.easeOutCubic);
  }

  PageController _ensureController(double fraction) {
    if (_page == null || (_fraction - fraction).abs() > 0.0001) {
      final keepPage = _page?.hasClients == true ? _page!.page ?? _index.toDouble() : _index.toDouble();
      _page?.dispose();
      _fraction = fraction;
      _page = PageController(viewportFraction: fraction, initialPage: keepPage.round())
        ..addListener(_onScroll);
      _pageOffset = keepPage;
    }
    return _page!;
  }

  void _onScroll() {
    if (_page?.hasClients != true) return;
    final p = _page!.page ?? 0;
    if ((p - _pageOffset).abs() > 0.001) setState(() => _pageOffset = p);
  }

  void _onSettled(int raw) {
    final i = widget.loop ? (raw % _count + _count) % _count : raw;
    if (i == _index) return;
    setState(() => _index = i);
    widget.controller?._sync(i);
    widget.onIndexChanged?.call(i);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final m = t.metrics;
    final gap = widget.gap ?? m.spacing.md;
    final visible = widget.visibleItems.resolve(SuperDeviceMode.of(context)).clamp(1, 99);

    return Padding(
      padding: widget.padding,
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          // Item extent honoring inter-item gaps and edge peek.
          final itemExtent =
              ((w - gap * (visible - 1) - widget.peek * 2) / visible).clamp(1.0, w);
          final fraction = ((itemExtent + gap) / w).clamp(0.05, 1.0);
          final controller = _ensureController(fraction);
          final vh = widget.height ?? (itemExtent / (widget.aspectRatio ?? 1));

          return MouseRegion(
            onEnter: (_) => _paused = true,
            onExit: (_) => _paused = false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: vh,
                  child: Stack(
                    children: [
                      NotificationListener<ScrollEndNotification>(
                        onNotification: (_) {
                          _onSettled((controller.page ?? 0).round());
                          return false;
                        },
                        child: PageView.builder(
                          controller: controller,
                          padEnds: false,
                          itemCount: widget.loop ? null : _count,
                          itemBuilder: (c, raw) {
                            final i = (raw % _count + _count) % _count;
                            final dist = (raw - _pageOffset).abs();
                            final scale = (1 - (dist * 0.04)).clamp(0.92, 1.0);
                            return Padding(
                              padding: EdgeInsets.only(right: gap),
                              child: Transform.scale(
                                scale: scale,
                                child: _itemAt(c, i),
                              ),
                            );
                          },
                        ),
                      ),
                      if (widget.showArrows && _count > 1) ...[
                        _Arrow(
                          start: true,
                          onTap: () => _animateTo(
                              widget.loop ? _pageOffset.round() - 1 : _index - 1),
                          enabled: widget.loop || _index > 0,
                        ),
                        _Arrow(
                          start: false,
                          onTap: () => _animateTo(
                              widget.loop ? _pageOffset.round() + 1 : _index + 1),
                          enabled: widget.loop || _index < _count - 1,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.showIndicator && _count > 1) ...[
                  SizedBox(height: m.spacing.md),
                  _Indicator(count: _count, active: _index, accent: t.tokens.accent, idle: t.border),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// An edge navigation chevron overlaid on the viewport.
class _Arrow extends StatelessWidget {
  const _Arrow({required this.start, required this.onTap, required this.enabled});
  final bool start;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final k = t.tokens;
    return PositionedDirectional(
      start: start ? 8 : null,
      end: start ? null : 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0,
          duration: k.durBase,
          child: IgnorePointer(
            ignoring: !enabled,
            child: Material(
              color: t.surface,
              shape: CircleBorder(side: BorderSide(color: t.border)),
              elevation: 2,
              shadowColor: const Color(0x33000000),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    start ? Icons.chevron_left : Icons.chevron_right,
                    size: 20,
                    color: t.fg2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An animated page indicator — the active page is a stretched accent pill.
class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.count,
    required this.active,
    required this.accent,
    required this.idle,
  });
  final int count;
  final int active;
  final Color accent;
  final Color idle;

  @override
  Widget build(BuildContext context) {
    final k = context.superTheme.tokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final on = i == active;
        return AnimatedContainer(
          duration: k.durBase,
          curve: k.curveStandard,
          width: on ? 20 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: on ? accent : idle,
            borderRadius: BorderRadius.circular(k.radiusPill),
          ),
        );
      }),
    );
  }
}
