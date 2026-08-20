import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/super_toast_entry.dart';
import '../../models/super_toast_style.dart';
import 'super_toast_parent_data.dart';
import 'super_toast_swipe.dart';

class AnimatedSuperToast extends StatefulWidget {
  const AnimatedSuperToast({
    required this.entry,
    required this.style,
    required this.alignTransform,
    required this.index,
    required this.length,
    required this.expand,
    required this.visible,
    required this.autoDismiss,
    required this.resumeStagger,
    required this.swiping,
    required this.onDismissed,
    required this.child,
    super.key,
  });

  final SuperToastEntry entry;
  final SuperToastResolvedStyle style;
  final Offset alignTransform;
  final int index;
  final int length;
  final double expand;
  final bool visible;
  final bool autoDismiss;
  final Duration resumeStagger;
  final ValueNotifier<SuperToastSwipeState> swiping;
  final VoidCallback onDismissed;
  final Widget child;

  @override
  State<AnimatedSuperToast> createState() => _AnimatedSuperToastState();
}

class _AnimatedSuperToastState extends State<AnimatedSuperToast>
    with TickerProviderStateMixin {
  static const List<AxisDirection> _horizontal = <AxisDirection>[
    AxisDirection.left,
    AxisDirection.right,
  ];
  static const List<AxisDirection> _vertical = <AxisDirection>[
    AxisDirection.up,
    AxisDirection.down,
  ];

  Timer? _timer;
  bool _accessibleNavigation = false;
  bool _reduceMotion = false;
  bool _pointerInside = false;
  bool _dismissCompleted = false;

  late final AnimationController _entranceController;
  late final AnimationController _transitionController;
  late final AnimationController _visibleController;
  late final AnimationController _swipeController;
  late CurvedAnimation _entranceCurve;
  late CurvedAnimation _transitionCurve;
  late CurvedAnimation _visibleCurve;
  late CurvedAnimation _swipeCurve;
  late Animation<double> _entranceOpacity;

  Offset _swipeFraction = Offset.zero;
  Offset _swipeTarget = Offset.zero;
  int _signal = 0;

  @override
  void initState() {
    super.initState();
    _createAnimations();
    widget.entry.dismissing.addListener(_onProgrammaticDismiss);
    widget.entry.manualPaused.addListener(_onManualPauseChanged);

    if (widget.entry.dismissing.value) {
      _entranceController.value = 1;
      scheduleMicrotask(_startDismissing);
    } else {
      _entranceController.forward();
    }
  }

  void _createAnimations() {
    final motion = widget.style.motion;
    _entranceController = AnimationController(
      vsync: this,
      duration: motion.entranceDuration,
      reverseDuration: motion.dismissDuration,
    )
      ..addListener(_rebuild)
      ..addStatusListener(_entranceStatus);
    _transitionController = AnimationController(
      vsync: this,
      duration: motion.transitionDuration,
    )
      ..value = 1
      ..addListener(_rebuild);
    _visibleController = AnimationController(
      vsync: this,
      duration: motion.reentranceDuration,
      reverseDuration: motion.exitDuration,
    )
      ..value = widget.visible ? 1 : 0
      ..addListener(_rebuild);
    _swipeController = AnimationController(
      vsync: this,
      duration: motion.swipeCompletionDuration,
    )
      ..addListener(_rebuild)
      ..addStatusListener(_swipeStatus);

    _entranceCurve = CurvedAnimation(
      parent: _entranceController,
      curve: motion.entranceCurve,
      reverseCurve: motion.dismissCurve,
    );
    _transitionCurve = CurvedAnimation(
      parent: _transitionController,
      curve: motion.transitionCurve,
    );
    _visibleCurve = CurvedAnimation(
      parent: _visibleController,
      curve: motion.reentranceCurve,
      reverseCurve: motion.exitCurve,
    );
    _swipeCurve = CurvedAnimation(
      parent: _swipeController,
      curve: motion.swipeCompletionCurve,
    );
    _entranceOpacity =
        motion.entranceDismissFadeTween.animate(_entranceCurve);
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final media = MediaQuery.maybeOf(context);
    final accessible = media?.accessibleNavigation ?? false;
    final reduce = accessible || (media?.disableAnimations ?? false);
    final changed = accessible != _accessibleNavigation || reduce != _reduceMotion;
    _accessibleNavigation = accessible;
    _reduceMotion = reduce;

    if (changed) {
      _syncMotionDurations();
    }

    if (_accessibleNavigation) {
      _cancelTimer(paused: true);
    } else {
      _syncTimer();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedSuperToast oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.entry != oldWidget.entry) {
      oldWidget.entry.dismissing.removeListener(_onProgrammaticDismiss);
      oldWidget.entry.manualPaused.removeListener(_onManualPauseChanged);
      widget.entry.dismissing.addListener(_onProgrammaticDismiss);
      widget.entry.manualPaused.addListener(_onManualPauseChanged);
    }

    if (widget.style.motion != oldWidget.style.motion) {
      _syncMotionDurations();
      _replaceCurves();
      _signal++;
    }

    if (widget.index != oldWidget.index) {
      _transitionController
        ..reset()
        ..forward();
      _signal++;
    }

    if (widget.visible != oldWidget.visible) {
      widget.visible
          ? _visibleController.forward()
          : _visibleController.reverse();
    }

    if (widget.autoDismiss != oldWidget.autoDismiss ||
        widget.entry.data.duration != oldWidget.entry.data.duration) {
      _syncTimer(withStagger: widget.autoDismiss && !oldWidget.autoDismiss);
    }
  }

  void _syncMotionDurations() {
    final motion = widget.style.motion;
    const zero = Duration.zero;
    _entranceController
      ..duration = _reduceMotion ? zero : motion.entranceDuration
      ..reverseDuration = _reduceMotion ? zero : motion.dismissDuration;
    _transitionController.duration =
        _reduceMotion ? zero : motion.transitionDuration;
    _visibleController
      ..duration = _reduceMotion ? zero : motion.reentranceDuration
      ..reverseDuration = _reduceMotion ? zero : motion.exitDuration;
    _swipeController.duration =
        _reduceMotion ? zero : motion.swipeCompletionDuration;
  }

  void _replaceCurves() {
    final motion = widget.style.motion;
    _entranceCurve.dispose();
    _transitionCurve.dispose();
    _visibleCurve.dispose();
    _swipeCurve.dispose();
    _entranceCurve = CurvedAnimation(
      parent: _entranceController,
      curve: motion.entranceCurve,
      reverseCurve: motion.dismissCurve,
    );
    _transitionCurve = CurvedAnimation(
      parent: _transitionController,
      curve: motion.transitionCurve,
    );
    _visibleCurve = CurvedAnimation(
      parent: _visibleController,
      curve: motion.reentranceCurve,
      reverseCurve: motion.exitCurve,
    );
    _swipeCurve = CurvedAnimation(
      parent: _swipeController,
      curve: motion.swipeCompletionCurve,
    );
    _entranceOpacity =
        motion.entranceDismissFadeTween.animate(_entranceCurve);
  }

  bool get _hasDuration {
    final duration = widget.entry.data.duration;
    return duration != null && duration.inMicroseconds > 0;
  }

  bool get _timerAllowed =>
      _hasDuration &&
      !_accessibleNavigation &&
      widget.autoDismiss &&
      !widget.entry.manualPaused.value &&
      !_pointerInside &&
      !widget.entry.dismissing.value;

  void _syncTimer({bool withStagger = false}) {
    if (!_timerAllowed) {
      _cancelTimer(paused: _hasDuration);
      return;
    }
    _restartTimer(
      withStagger
          ? _scaled(widget.resumeStagger, widget.length - widget.index - 1)
          : Duration.zero,
    );
  }

  void _restartTimer([Duration stagger = Duration.zero]) {
    if (!_timerAllowed) return;
    final duration = widget.entry.data.duration!;
    _timer?.cancel();
    widget.entry.timerPaused.value = false;
    _timer = Timer(duration + stagger, () {
      _timer = null;
      _startDismissing();
    });
  }

  void _cancelTimer({required bool paused}) {
    _timer?.cancel();
    _timer = null;
    if (widget.entry.timerPaused.value != paused) {
      widget.entry.timerPaused.value = paused;
    }
  }

  void _onManualPauseChanged() => _syncTimer(
    withStagger: !widget.entry.manualPaused.value,
  );

  void _onProgrammaticDismiss() {
    if (!widget.entry.dismissing.value) return;
    _startDismissing();
  }

  void _startDismissing() {
    if (_dismissCompleted || !mounted) return;
    _cancelTimer(paused: false);
    if (_accessibleNavigation || _reduceMotion) {
      scheduleMicrotask(() {
        if (mounted && !_dismissCompleted) {
          _entranceController.value = 0;
          _finishDismiss();
        }
      });
    } else if (_entranceController.status != AnimationStatus.reverse) {
      _entranceController.reverse();
    }
  }

  void _entranceStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed &&
        _entranceController.value == 0) {
      _finishDismiss();
    }
  }

  void _finishDismiss() {
    if (_dismissCompleted) return;
    _dismissCompleted = true;
    widget.onDismissed();
  }

  void _swipeStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    if (_swipeTarget == Offset.zero) {
      setState(() {
        _swipeFraction = Offset.zero;
        _swipeController.reset();
      });
      _syncTimer(withStagger: true);
    } else {
      _finishDismiss();
    }
  }

  bool _containsAny(List<AxisDirection> left, List<AxisDirection> right) =>
      left.any(right.contains);

  void _beginSwipe(List<AxisDirection> axis) {
    if (!_containsAny(widget.entry.swipeToDismiss, axis)) return;
    _cancelTimer(paused: true);
    widget.swiping.value = widget.swiping.value.start();
  }

  void _endHorizontalSwipe() {
    if (!_containsAny(widget.entry.swipeToDismiss, _horizontal)) return;
    final x = _swipeFraction.dx;
    _swipeTarget = switch (x) {
      < 0 when x < -widget.entry.dismissThreshold => const Offset(-1, 0),
      > 0 when x > widget.entry.dismissThreshold => const Offset(1, 0),
      _ => Offset.zero,
    };
    _swipeController
      ..reset()
      ..forward();
    widget.swiping.value = widget.swiping.value.end();
  }

  void _endVerticalSwipe() {
    if (!_containsAny(widget.entry.swipeToDismiss, _vertical)) return;
    final y = _swipeFraction.dy;
    _swipeTarget = switch (y) {
      < 0 when y < -widget.entry.dismissThreshold => const Offset(0, -1),
      > 0 when y > widget.entry.dismissThreshold => const Offset(0, 1),
      _ => Offset.zero,
    };
    _swipeController
      ..reset()
      ..forward();
    widget.swiping.value = widget.swiping.value.end();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.entry.dismissing.removeListener(_onProgrammaticDismiss);
    widget.entry.manualPaused.removeListener(_onManualPauseChanged);
    _swipeCurve.dispose();
    _visibleCurve.dispose();
    _transitionCurve.dispose();
    _entranceCurve.dispose();
    _swipeController.dispose();
    _visibleController.dispose();
    _transitionController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translation = _reduceMotion
        ? Offset.zero
        : -widget.alignTransform * (1 - _entranceCurve.value);
    translation += Offset.lerp(
      _swipeFraction,
      _swipeTarget,
      _swipeCurve.value,
    )!;

    var opacity = _reduceMotion
        ? (widget.visible ? 1.0 : 0.0)
        : _entranceOpacity.value * _visibleCurve.value;
    opacity *= (1 - _swipeFraction.distance.abs()).clamp(0.0, 1.0).toDouble();

    return SuperToastLayoutData(
      index: widget.index,
      transition: _reduceMotion ? 1 : _transitionCurve.value,
      visible: widget.visible,
      signal: _signal,
      child: IgnorePointer(
        ignoring: !widget.visible,
        child: ConstrainedBox(
          constraints: widget.style.constraints,
          child: MouseRegion(
            onEnter: (_) {
              if (!widget.entry.data.pauseOnHover) return;
              _pointerInside = true;
              _cancelTimer(paused: _hasDuration);
            },
            onExit: (_) {
              if (!widget.entry.data.pauseOnHover) return;
              _pointerInside = false;
              _syncTimer(withStagger: true);
            },
            child: GestureDetector(
              onHorizontalDragStart: (_) => _beginSwipe(_horizontal),
              onHorizontalDragUpdate: (details) {
                final width = context.size?.width ?? 1;
                final delta = details.primaryDelta ?? 0.0;
                if (widget.entry.swipeToDismiss.contains(AxisDirection.left)) {
                  setState(() {
                    final next = _swipeFraction.dx + delta / width;
                    _swipeFraction = Offset(next.clamp(-1.1, 0.05).toDouble(), 0);
                  });
                } else if (widget.entry.swipeToDismiss.contains(AxisDirection.right)) {
                  setState(() {
                    final next = _swipeFraction.dx + delta / width;
                    _swipeFraction = Offset(next.clamp(-0.05, 1.1).toDouble(), 0);
                  });
                }
              },
              onHorizontalDragEnd: (_) => _endHorizontalSwipe(),
              onVerticalDragStart: (_) => _beginSwipe(_vertical),
              onVerticalDragUpdate: (details) {
                final height = context.size?.height ?? 1;
                final delta = details.primaryDelta ?? 0.0;
                if (widget.entry.swipeToDismiss.contains(AxisDirection.up)) {
                  setState(() {
                    final next = _swipeFraction.dy + delta / height;
                    _swipeFraction = Offset(0, next.clamp(-1.1, 0.05).toDouble());
                  });
                } else if (widget.entry.swipeToDismiss.contains(AxisDirection.down)) {
                  setState(() {
                    final next = _swipeFraction.dy + delta / height;
                    _swipeFraction = Offset(0, next.clamp(-0.05, 1.1).toDouble());
                  });
                }
              },
              onVerticalDragEnd: (_) => _endVerticalSwipe(),
              child: FractionalTranslation(
                translation: translation,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0).toDouble(),
                  child: Semantics(
                    container: true,
                    liveRegion: widget.visible,
                    onDismiss: widget.visible ? _startDismissing : null,
                    child: widget.child,
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

Duration _scaled(Duration duration, int factor) {
  final safeFactor = factor < 0 ? 0 : factor;
  return Duration(microseconds: duration.inMicroseconds * safeFactor);
}
