// ============================================================
// features/toast/presentation/controllers/super_toast_controller.dart
// ------------------------------------------------------------
// MVC controller. Owns active entries and lifecycle only; gesture state,
// timers, animation controllers and layout remain presentation-view concerns.
// ============================================================

import 'package:flutter/widgets.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/super_toast_data.dart';
import '../models/super_toast_alignment.dart';
import '../models/super_toast_entry.dart';
import '../models/super_toast_style.dart';

/// Public handle returned for an active toast.
class SuperToastHandle {
  SuperToastHandle._(this._controller, this.id);

  final SuperToastController _controller;
  final int id;

  /// True while the toast exists and has not started a programmatic dismiss.
  bool get showing => _controller.isShowing(id);

  /// Backwards-compatible alias for [showing].
  bool get isActive => _controller.contains(id);

  /// Effective auto-dismiss pause state reported by the animated view.
  bool get isPaused => _controller.isPaused(id);

  /// Requests animated dismissal. Repeated calls are ignored.
  void dismiss() => _controller.dismiss(id);

  /// Suspends auto-dismiss. Resume restarts the configured duration, matching
  /// the reference toaster's interaction behavior.
  void pause() => _controller.pause(id);

  /// Resumes auto-dismiss when allowed by the current stack interaction.
  void resume() => _controller.resume(id);
}

typedef SuperToastRawBuilder = Widget Function(
  BuildContext context,
  SuperToastHandle entry,
);

/// Entry/lifecycle controller used by [SuperToastHost].
class SuperToastController extends ChangeNotifier {
  SuperToastController();

  /// Shared controller used by the default app-level host.
  static final SuperToastController shared = SuperToastController();

  final List<SuperToastEntry> _entries = <SuperToastEntry>[];
  int _nextId = 0;
  bool _disposed = false;

  List<SuperToastEntry> get entries => List.unmodifiable(_entries);
  int get activeCount => _entries.length;

  bool contains(int id) => _entries.any((entry) => entry.id == id);

  bool isShowing(int id) {
    final entry = _entry(id);
    return entry != null && !entry.dismissing.value;
  }

  bool isPaused(int id) {
    final entry = _entry(id);
    return entry != null &&
        (entry.manualPaused.value || entry.timerPaused.value);
  }

  /// Inserts a toast entry. A [SuperToastHost] using this controller must be in
  /// the widget tree for it to render.
  SuperToastHandle show(
    BuildContext context,
    SuperToastData data, {
    required SuperToastRawBuilder builder,
    SuperToastAlignment? alignment,
    SuperToastAlignment? defaultAlignment,
    List<AxisDirection>? swipeToDismiss,
    double dismissThreshold = 0.5,
    SuperToastStyle style = const SuperToastStyle(),
    VoidCallback? onDismiss,
  }) {
    assert(!_disposed, 'Cannot use a disposed SuperToastController.');
    assert(
      dismissThreshold >= 0 && dismissThreshold <= 1,
      'dismissThreshold must be between 0 and 1.',
    );

    final id = ++_nextId;
    final handle = SuperToastHandle._(this, id);
    final direction = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final requestedAlignment = alignment ??
        (data.position == SuperToastPosition.adaptive
            ? defaultAlignment ?? SuperToastAlignment.adaptive(context.superTheme.mode)
            : SuperToastAlignment.fromPosition(
                data.position,
                context.superTheme.mode,
              ));
    final placement = requestedAlignment.resolve(direction);
    final resolvedSwipe = List<AxisDirection>.unmodifiable(
      swipeToDismiss ?? _defaultSwipeDirections(placement.alignment),
    );

    final entry = SuperToastEntry(
      id: id,
      data: data,
      placement: placement,
      textDirection: direction,
      swipeToDismiss: resolvedSwipe,
      dismissThreshold: dismissThreshold,
      style: style,
      builder: (context) => builder(context, handle),
      onDismiss: onDismiss,
    );

    _entries.add(entry);
    notifyListeners();
    return handle;
  }

  /// Starts programmatic dismissal. Removal occurs after the animated view
  /// reports completion.
  void dismiss(int id) {
    if (_disposed) return;
    final entry = _entry(id);
    if (entry == null || entry.dismissing.value) return;
    entry.dismissing.value = true;
  }

  /// Pauses the timer through the entry's manual interaction notifier.
  void pause(int id) {
    final entry = _entry(id);
    if (entry == null || entry.dismissing.value) return;
    entry.manualPaused.value = true;
  }

  /// Resumes a manually paused timer.
  void resume(int id) {
    final entry = _entry(id);
    if (entry == null || entry.dismissing.value) return;
    entry.manualPaused.value = false;
  }

  /// Called by the animated view after dismiss/swipe motion is complete.
void completeDismiss(int id) {
    if (_disposed) return;
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index == -1) return;

    final entry = _entries.removeAt(index);
    notifyListeners();
    final callback = entry.onDismiss;
    entry.dispose();
    callback?.call();
  }

  /// Removes one entry without animation. Intended for teardown/tests.
  void dismissImmediately(int id) {
    if (_disposed) return;
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index == -1) return;
    final entry = _entries.removeAt(index);
    notifyListeners();
    final callback = entry.onDismiss;
    entry.dispose();
    callback?.call();
  }

  /// Requests dismissal of every active toast.
  void dismissAll({bool immediate = false}) {
    if (_disposed) return;
    if (immediate) {
      final removed = List<SuperToastEntry>.of(_entries);
      _entries.clear();
      notifyListeners();
      for (final entry in removed) {
        final callback = entry.onDismiss;
        entry.dispose();
        callback?.call();
      }
      return;
    }

    for (final entry in List<SuperToastEntry>.of(_entries)) {
      if (!entry.dismissing.value) {
        entry.dismissing.value = true;
      }
    }
  }

  SuperToastEntry? _entry(int id) {
    for (final entry in _entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  static List<AxisDirection> _defaultSwipeDirections(Alignment alignment) => [
    if (alignment.y < 0)
      AxisDirection.up
    else if (alignment.y > 0)
      AxisDirection.down,
    if (alignment.x < 0)
      AxisDirection.left
    else if (alignment.x > 0)
      AxisDirection.right,
  ];

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    for (final entry in _entries) {
      entry.dispose();
    }
    _entries.clear();
    super.dispose();
  }
}
