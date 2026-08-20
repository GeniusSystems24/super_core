import 'package:flutter/material.dart';

import '../../controllers/super_toast_controller.dart';
import '../../models/super_toast_entry.dart';
import '../../models/super_toast_style.dart';
import 'animated_super_toast.dart';
import 'super_toast_stack_layout.dart';
import 'super_toast_swipe.dart';

/// Manages interaction/expansion for one resolved viewport placement.
class SuperToastStack extends StatefulWidget {
  const SuperToastStack({
    required this.controller,
    required this.style,
    required this.expandedAlignTransform,
    required this.collapsedAlignTransform,
    required this.entries,
    super.key,
  });

  final SuperToastController controller;
  final SuperToastResolvedHostStyle style;
  final Offset expandedAlignTransform;
  final Offset collapsedAlignTransform;
  final List<SuperToastEntry> entries;

  @override
  State<SuperToastStack> createState() => _SuperToastStackState();
}

class _SuperToastStackState extends State<SuperToastStack>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<SuperToastSwipeState> _swiping =
      ValueNotifier<SuperToastSwipeState>(const SuperToastUnswiped());

  late final AnimationController _controller;
  late CurvedAnimation _expand;
  bool _autoDismiss = true;
  bool _hovered = false;
  bool _reduceMotion = false;
  int _hoverFence = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.style.motion.expandDuration,
      reverseDuration: widget.style.motion.collapseDuration,
    )..addListener(_rebuild);
    _expand = CurvedAnimation(
      parent: _controller,
      curve: widget.style.motion.expandCurve,
      reverseCurve: widget.style.motion.collapseCurve,
    );
    _swiping.addListener(_collapseAfterExternalSwipe);

    if (widget.style.expandBehavior == SuperToastExpandBehavior.always) {
      _controller.value = 1;
    }
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final media = MediaQuery.maybeOf(context);
    final reduce =
        (media?.accessibleNavigation ?? false) ||
        (media?.disableAnimations ?? false);
    if (_reduceMotion != reduce) {
      _reduceMotion = reduce;
      _syncDurations();
    }
  }

  @override
  void didUpdateWidget(covariant SuperToastStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncDurations();

    if (widget.style.motion.expandCurve != oldWidget.style.motion.expandCurve ||
        widget.style.motion.collapseCurve !=
            oldWidget.style.motion.collapseCurve) {
      _expand.dispose();
      _expand = CurvedAnimation(
        parent: _controller,
        curve: widget.style.motion.expandCurve,
        reverseCurve: widget.style.motion.collapseCurve,
      );
    }

    if (widget.style.expandBehavior != oldWidget.style.expandBehavior) {
      switch (widget.style.expandBehavior) {
        case SuperToastExpandBehavior.always:
          _controller.value = 1;
          break;
        case SuperToastExpandBehavior.disabled:
          _controller.value = 0;
          break;
        case SuperToastExpandBehavior.hoverOrPress:
          break;
      }
    }
  }

  void _syncDurations() {
    _controller
      ..duration = _reduceMotion
          ? Duration.zero
          : widget.style.motion.expandDuration
      ..reverseDuration = _reduceMotion
          ? Duration.zero
          : widget.style.motion.collapseDuration;
  }

  void _collapseAfterExternalSwipe() {
    if (!mounted || _swiping.value is! SuperToastExternalEndSwipe) return;
    setState(() {
      _autoDismiss = true;
      _swiping.value = _swiping.value.end();
    });
    if (widget.style.expandBehavior == SuperToastExpandBehavior.hoverOrPress) {
      _controller.reverse();
    }
  }

  Future<void> _onEnter() async {
    final fence = ++_hoverFence;
    _hovered = true;
    _swiping.value = _swiping.value.enter();
    await Future<void>.delayed(widget.style.expandHoverEnterDuration);
    if (!mounted || fence != _hoverFence) return;

    setState(() => _autoDismiss = false);
    if (widget.style.expandBehavior == SuperToastExpandBehavior.hoverOrPress) {
      await _controller.forward();
    }
  }

  Future<void> _onExit() async {
    final fence = ++_hoverFence;
    _hovered = false;
    _swiping.value = _swiping.value.exit();
    await Future<void>.delayed(widget.style.expandHoverExitDuration);
    if (!mounted ||
        fence != _hoverFence ||
        _swiping.value is SuperToastExternalSwipe) {
      return;
    }

    setState(() => _autoDismiss = true);
    if (widget.style.expandBehavior == SuperToastExpandBehavior.hoverOrPress) {
      await _controller.reverse();
    }
  }

  void _onPressed() {
    if (_hovered) return;
    setState(() => _autoDismiss = !_autoDismiss);
    if (widget.style.expandBehavior == SuperToastExpandBehavior.hoverOrPress) {
      final isExpandedOrExpanding =
          _controller.status == AnimationStatus.forward ||
          _controller.status == AnimationStatus.completed;
      isExpandedOrExpanding ? _controller.reverse() : _controller.forward();
    }
  }

  @override
  void dispose() {
    _hoverFence++;
    _swiping
      ..removeListener(_collapseAfterExternalSwipe)
      ..dispose();
    _expand.dispose();
    _controller
      ..removeListener(_rebuild)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => _onEnter(),
    onExit: (_) => _onExit(),
    child: GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: _onPressed,
      child: SuperToastStackLayout(
        style: widget.style,
        expandedAlignTransform: widget.expandedAlignTransform,
        collapsedAlignTransform: widget.collapsedAlignTransform,
        expand: _reduceMotion ? _controller.value.roundToDouble() : _expand.value,
        children: [
          for (final indexed in widget.entries.indexed)
            _buildEntry(context, indexed.$1, indexed.$2),
        ],
      ),
    ),
  );

  Widget _buildEntry(BuildContext context, int sourceIndex, SuperToastEntry entry) {
    final indexFromFront = widget.entries.length - 1 - sourceIndex;
    final resolvedStyle = entry.style.resolve(context);
    return AnimatedSuperToast(
      key: ValueKey<int>(entry.id),
      entry: entry,
      style: resolvedStyle,
      alignTransform: widget.collapsedAlignTransform,
      index: indexFromFront,
      length: widget.entries.length,
      expand: _expand.value,
      visible: indexFromFront < widget.style.maxVisible,
      autoDismiss: entry.data.pauseOnHover ? _autoDismiss : true,
      resumeStagger: widget.style.resumeStagger,
      swiping: _swiping,
      onDismissed: () {
        widget.controller.completeDismiss(entry.id);
        if (mounted &&
            widget.entries.length <= 1 &&
            widget.style.expandBehavior ==
                SuperToastExpandBehavior.hoverOrPress) {
          _controller.value = 0;
        }
      },
      child: Directionality(
        textDirection: entry.textDirection,
        child: entry.builder(context),
      ),
    );
  }
}
